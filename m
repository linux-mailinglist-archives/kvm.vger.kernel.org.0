Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F8B2F8127
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhAOQsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbhAOQs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 11:48:29 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A041CC0613C1
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:47:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id md11so5382071pjb.0
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/AM9aRmJWmTTTa7i8G9VQEdz92RzM65uj/53ehXLuAg=;
        b=ahzPgjpwAuCAUuChx+v0nvAzq2oICXKzY79xl7HP5Lq6PP7ciMHAjERgzCojH3Ioot
         VRgyMjAzUf60ha291tPvl6nBJxFxSG0ijHGp+5Kuz7T5yWbf4owzEjJdgqA1V+gGtSUr
         KcF90J0RtU6b+qjEj+pcSLkZZomqu16/60jP3tLwfoahxj8CF+fDBWBSUtnUKUjs7Cuc
         38gnXuiUkuNWeGah9oevnelHj3taW0an8jS0yVT6MdYUcaHiSX/KOwXYo2l7ycXdyxBo
         WNJ8kpJlMEsL3bu4Q4p3kFr2qWxKkdjUPD/T7AUIvCHOKiSYkXrfBZR/xKru6HVoGnvq
         ZYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AM9aRmJWmTTTa7i8G9VQEdz92RzM65uj/53ehXLuAg=;
        b=VQYK2u7zC8H5maYZDBQ46HaCPie1r9GaxJ4996wKpM6MICuEV5Q7VK/mR4NWso2EMS
         Sf7k8enN8zw26d9NlmfkGt9hYngCwgMqXIytjVL85vi/cvy8Xh3NClwbZOXv5I3hrH8K
         8ShRLTZm/5kM9dCoWiWskT3m67bvtFjrcUVXolb9nsWiFVNakBDiqlY0L8s8hgyH88Eq
         l7F0rBZu90eH2RJaiOH8tM3ZooUikvUGBHgYr5Uqyb3Ss0eBlqOfjWOOZpJEQZ6IOlQw
         +lr4rT+H4UiT6rPGh1tbU58d6tIGiCp44sKJiDXOF85lJKsNjGnFVPy/YwzmNpDfd+CE
         BGIA==
X-Gm-Message-State: AOAM532IiSvs25I7WJ2rdRrOZYABUeZWDrCiPYp4Guj20zTKGvTWq0R2
        JA5bhLdlr3Yjlr6LpqKvdbJXzUyD+MR1bA==
X-Google-Smtp-Source: ABdhPJz4k/ixfFah9o9h7XYlXd4T/oSqOqMMrndgVELd/sk2bSk995UFvLVdZ4pFmsW266v4SnsXPg==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr11382908pjb.57.1610729269090;
        Fri, 15 Jan 2021 08:47:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w6sm8632563pfq.208.2021.01.15.08.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:47:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:47:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 1/4] KVM: x86: Drop redundant KVM_MEM_SLOTS_NUM
 definition
Message-ID: <YAHHLuYmUeajMFhd@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115131844.468982-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> KVM_MEM_SLOTS_NUM is already defined in include/linux/kvm_host.h the
> exact same way.

I'm pretty sure you can remove the "#ifndef KVM_MEM_SLOTS_NUM" in
linux/kvm_host.h, looks like x86 is the only arch that was defining
KVM_MEM_SLOTS_NUM.

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c27cbe3baccc..1bcf67d76753 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -43,7 +43,6 @@
>  #define KVM_USER_MEM_SLOTS 509
>  /* memory slots that are not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS 3
> -#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
>  
>  #define KVM_HALT_POLL_NS_DEFAULT 200000
>  
> -- 
> 2.29.2
> 
