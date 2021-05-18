Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA323880DF
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352009AbhERT7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352004AbhERT7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:59:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68587C061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:58:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e19so8235254pfv.3
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nC+H8cCNxnda/BpZpKO5FV3ScjJYc3oc78+AAfuoy6w=;
        b=mOew9EHjY+srvL7oxZsnsh8B4D1WQaAyvJiwi2H/KZJhveqG0Fpaa1p7ufH8ELegwp
         ofpdkGQlpYP4OPDpxYUNQpWuni9E5644sbDux478eupwFvHyFONxotIx0mIJio6mOiYf
         HBEIAeZcI9xrQgngZxv+jMJs1zSecDPcPU4U80BM4nAaMSaposjYfQ7OqpcGdpdQagCc
         dTo2UI18GTR3wdPOUhu0ans5S/oKQbIoB4Y3RfNeTPWXSBpMzcV+z01UopXp4XJ4irxb
         iE6MB3XFI23wdHimTcC6t/d7QikNtLRxZ84/FGgJU2zRkXpjqC4GSHXwbKNl0yJOyRGd
         A9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nC+H8cCNxnda/BpZpKO5FV3ScjJYc3oc78+AAfuoy6w=;
        b=XSYEITsrh7OoiFdFiBNAJFe7CTnB6bmpknOWu1IBwabDuA8dbnHoM5V3uvG8LJ7b5H
         5AA+OExSa7AJAIO4Lamcg4EhdcH8iN07e8M5TheNHpVGBVYBrWZ50u5F4hvKDIjaLboX
         lvKlwHBN5kI8ahzkRGP+xmj/rOBD+QA2AtwSLiIcI5XlEMWG9m0fqhVAmCWw0hAaIjYg
         Xch/Oti0jQLUt0/2cwMvg6pTHKYKF+lBsUwJmkxEGhCpxw10wIgNkjLDIXCNvjtRsSjG
         AuF1nnmMI639ncYS7nPcnU6BSf73ML2N6/yEIvBsayBc5Vl7BTyaBWQagSDuNLXw7tjF
         H4SA==
X-Gm-Message-State: AOAM532IyKAnXjqTlhowusMJgN7OMpx7MA/zx3IKweax/lqkRa39ho4t
        Qbf0wYHwDbl4ozuFtFoYsZfxtQ==
X-Google-Smtp-Source: ABdhPJxHxRmPXj809ZQ+TFn8XrFu5p7EQuiB2/g9jTrbf9aIdrL9Zpleqin73/tjbbV7IElxTxfotA==
X-Received: by 2002:a65:550e:: with SMTP id f14mr6812349pgr.160.1621367879851;
        Tue, 18 May 2021 12:57:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w197sm9187865pfc.5.2021.05.18.12.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:57:59 -0700 (PDT)
Date:   Tue, 18 May 2021 19:57:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC
 check from cpu_has_vmx_posted_intr()
Message-ID: <YKQcQy6SEvYB+lMS@google.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518144339.1987982-3-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Vitaly Kuznetsov wrote:
> CONFIG_X86_LOCAL_APIC is always on when CONFIG_KVM (on x86) since
> commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
