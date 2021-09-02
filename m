Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98643FF53B
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbhIBVBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbhIBVB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:01:29 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF16C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:00:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e16so2622122pfc.6
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YMhfaodcgc77ZP8ABkUmOAdhtqO4++UxJv6RcpOUv/w=;
        b=eWmYUlZrxbqNuuMJ/0PDLmAq8uKaypddRBaU11mMZBstxElgL2M6PYro90x+u8uYwJ
         I4sMfaFz3cZLrHxdWT1tbUdOxj1PelcqFSh5MH+2EBr81IXepqqNNMmvYSsHw3kbBVmw
         a5YNZysGloOEgYu8wLvDxpkeAEz2LQfBXGu8xdurstGe0PWZA6RPE9DPOIO5SIlkhkXi
         tqGc2LC1/098pNwdbB91XwDiLoCloE/vM+JYbxa2EYlGPl4R6tpT5lZGEVEtl99Ilq59
         FZN97QCzYsimZYp7fekRjIa/vI+7if8apNyeEm5juRDsmrILIc3rbphILHVbO5T0e9/3
         tntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YMhfaodcgc77ZP8ABkUmOAdhtqO4++UxJv6RcpOUv/w=;
        b=nwLMP/5LYWGarl6bcXuqNejxo061KirhUGICDIwoSRGUD7w47ykmaJLGqlaq1BCma3
         Uf6c392CJjj4JOrxrjJqSrASJwUzz/PneH6n2NzorWJxApwOQw3NN/35fx3Ro73v0zfx
         cBG6e9h+Mv58VO95IIbxrxcxx0VAc9hgG92KKVXVWh/CeNqpgJ7IZ90sCbM+Qdv2iTWV
         UHqJvhIVAe/HaMaRdrh/ISSu7nk6TftgIhCAt6zb/dR1skD1PVPcxxebfekodwHy5jIC
         JWK7emUYDydnAXVYytTjGOiqjInz0oW4bEiC4HrwCSHjYKgJqwqY4FoDETzO61/4nF2Z
         BvKQ==
X-Gm-Message-State: AOAM5315wO1HpAfGOgmHmBLj5J73mMUcEzRcldAIqO8ms0JbVAjK1l2L
        KXaou+D3joPQMib1m8ueBwrnRg==
X-Google-Smtp-Source: ABdhPJybtFU71yoL/8EACzoVoe1O4RBTw6PhlXl6pINq5M7Du4FD99aQaNRl0wcu39Gj15GDLdnefA==
X-Received: by 2002:a65:6a09:: with SMTP id m9mr256953pgu.269.1630616429603;
        Thu, 02 Sep 2021 14:00:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 11sm3195915pfm.208.2021.09.02.14.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:00:29 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:00:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/8] KVM: Drop 'except' parameter from
 kvm_make_vcpus_request_mask()
Message-ID: <YTE7aQ4HnlI6cx1f@google.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
 <20210827092516.1027264-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827092516.1027264-6-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Vitaly Kuznetsov wrote:
> Both remaining callers of kvm_make_vcpus_request_mask() pass 'NULL' for
> 'except' parameter so it can just be dropped.
> 
> No functional change intended.

Trademark infringement.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com> 
