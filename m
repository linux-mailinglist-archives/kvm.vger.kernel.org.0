Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F935487F38
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 00:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiAGXJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 18:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiAGXJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 18:09:21 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79D6C06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 15:09:21 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s1so6870462pga.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 15:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHllN4kbwo4ufYEtJroZvaPo8Ljk02uIK7K+t+FgJRE=;
        b=clxQZ9/ftSN9Vg09HHNPgNxsc3gPmDUeH96HuZnP9bVy/K3lNNKB0FSAY+y+NnH/ls
         llJ8ym3M7uTyclFeuMpU2Me8bq8oK/6UHYeCvsYppqYFD+WARZ3FFYb8OAR79LenuP32
         209ruO+EokmLNmPBtT3AxH/JhPL7IEGTYUpP8X5buH+NFTqRq3QIxDw4xhkxSzaxCzIY
         /LjgTG+p2A5gYANiEX0T/7bslhjYorhRn27YidxdToHKUYDga8kOXYOPd0Euf6FUHFRW
         pdnfbhgMpsMmOjzDHVWsj+0+FjyF0wILDRcHiKFFQQZTEA/w2mcxJue3EOEU0yogKkhM
         zERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qHllN4kbwo4ufYEtJroZvaPo8Ljk02uIK7K+t+FgJRE=;
        b=1Hs/GzMR8zu/n3q+Q6hlN45uC5sSuUtDv8IoHY0pR9M0lZpb51nbDoAkgAMQkQud4q
         omITOBp3xey3NCxiJaF1moU335lF5GSC3ksNBzdvjCBhijcd0OuyRe33S+5ewB4Srney
         8vc9oi5gi19r+wF313w9kW/QZn3hXf2QOrAdb0EsG4MK5ZdAqfWZecW51hIfHIVhoYs7
         ZAjFq81oohaORUKbIut0ouPcw2C4/Ocbgyn+XlDxMxA6IKRAaK7Z8GIBzj7yYmq5kf1L
         ftzSkT7JpJmTu4LfDn66F+Ey7RSgJrj0AbpLSioxmZH7+X2DDlCAE2nQUD044qBPQo6H
         QJeA==
X-Gm-Message-State: AOAM531VBdCXvfFc2hAbUrhgSzMjpyuGqqzci2tJbWyYQvY4EautcpDS
        h6lgt2oQyObFuABnyh6sZEdFRw==
X-Google-Smtp-Source: ABdhPJyt7KDmdYwRa0yzfNvIJHbHrYXII036Dt2obZiD43vzHxUYpQN2oxvsCMZIkl0YL3nuC8wDYQ==
X-Received: by 2002:a63:af16:: with SMTP id w22mr57593728pge.560.1641596960987;
        Fri, 07 Jan 2022 15:09:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p186sm8622pfp.128.2022.01.07.15.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 15:09:20 -0800 (PST)
Date:   Fri, 7 Jan 2022 23:09:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: nVMX: Rename vmcs_to_field_offset{,_table}
Message-ID: <YdjIHQXtRilU2Hm7@google.com>
References: <20220107102859.1471362-1-vkuznets@redhat.com>
 <20220107102859.1471362-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107102859.1471362-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022, Vitaly Kuznetsov wrote:
> vmcs_to_field_offset{,_table} may sound misleading as VMCS is an opaque
> blob which is not supposed to be accessed directly. In fact,
> vmcs_to_field_offset{,_table} are related to KVM defined VMCS12 structure.
> 
> Rename vmcs_field_to_offset() to get_vmcs12_field_offset() for clarity.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
