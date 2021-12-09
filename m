Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2297646F4A1
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 21:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhLIUKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 15:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhLIUKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 15:10:32 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E86CC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 12:06:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so7811883pja.1
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 12:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gwRCmOcV8mgYMV639Uo05ejPIh8FktnV4IXwk6MdTjQ=;
        b=rCYVdmK+TX+X6LTr69UjHCcsZTsdtbX0k3e9IxoVFolffDP0k5Wg7g4zhVDr85Ct2i
         feELn1mJECv14nuZDTaE+YZM9BKlPWM/zC/cEHBuKeAsr9tYuTjb0sf5URooqeL2yh+d
         GO5VveR6IEi0NvaJoKUrYEXn7RlYf/6SPrdnoGglLEYs57oI87jJ8hM5TLOe9ACoF6oi
         GNOKlgN/V9KyW3H+CtvadBaMpdxbY1wbOdNU3NeEMBkJ0ZvN6jcvPCzOJGmjVdVcFwJf
         En57I1oh0kYrpfi9Yc+PhBDbXXSK4jM0Z84z74xvdiFncnYeRt0Mwiuu/BDYNhSZzECG
         CL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gwRCmOcV8mgYMV639Uo05ejPIh8FktnV4IXwk6MdTjQ=;
        b=WY83n/Hq3LLIgq5iTaDlTsw99JcJO3RftykQswMLerVSbdT1N64va71MV7+dUwI10/
         OWEXLSGBJUyqclDE9pAXxqfx7+R7lAHEaLSLSc9L2vs4+a2Ywf4DtIsUhlJqkDPgvLSj
         h/bOWf2NfxT6O776X9SMJA77kdQDh8YZDwB8z4j8HPABFtVz6HITJDN4kPkofdZroY71
         qRzy0QpMx8xkQMdOYpYHUczAVbttdnazONmzKWwoALxyKXrw3OLRobN7uYlGks+z2F0w
         HUu4UVfXtbTC9I6M8CsVl99Ry1NeIqzlq6geLXwNkqOCMq62CgpKM5XJlI8xDrwVw+4Z
         mX0g==
X-Gm-Message-State: AOAM532B2KHlvtBisuF8hlvMl23ogT4Rcln3e3TDuO/y/qJrfgho9CxO
        bDwbC1jXhgbbXgE0MAQalHcsPg==
X-Google-Smtp-Source: ABdhPJzDAoTgPP46cvnRMAno2mdmBoh694Rmc3miUZpw4CdREWdZIlKah08+HQwjAiHLbnuyBY/02w==
X-Received: by 2002:a17:902:7289:b0:142:805f:e2c with SMTP id d9-20020a170902728900b00142805f0e2cmr69576070pll.42.1639080418442;
        Thu, 09 Dec 2021 12:06:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k16sm507161pfu.183.2021.12.09.12.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 12:06:57 -0800 (PST)
Date:   Thu, 9 Dec 2021 20:06:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 2/3] x86: Align L2's stacks
Message-ID: <YbJh3mBZ0c86E7TU@google.com>
References: <20211209182624.2316453-1-aaronlewis@google.com>
 <20211209182624.2316453-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209182624.2316453-3-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Aaron Lewis wrote:
> Setting the stack to PAGE_SIZE - 1 sets the stack to being 1-byte

LOL, nice.  It's also pointless because any access larger than a byte that occurs
without first adjusting the stack will explode.

> aligned, which fails in usermode with alignment checks enabled (ie: with
> flags cr0.am set and eflags.ac set).  This was causing an #AC in
> usermode.c when preparing to call the callback in run_in_user().
> Aligning the stack fixes the issue.
> 
> For the purposes of fixing the #AC in usermode.c the stack has to be
> aligned to at least an 8-byte boundary.  Setting it to a page aligned
> boundary ensures any stack alignment requirements are met as x86_64
> stacks generally want to be 16-byte aligned.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6dc9a55..44f4861 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1242,7 +1242,7 @@ static void init_vmcs_guest(void)
>  	vmcs_write(GUEST_CR4, guest_cr4);
>  	vmcs_write(GUEST_SYSENTER_CS,  KERNEL_CS);
>  	vmcs_write(GUEST_SYSENTER_ESP,
> -		(u64)(guest_syscall_stack + PAGE_SIZE - 1));
> +		(u64)(guest_syscall_stack + PAGE_SIZE));
>  	vmcs_write(GUEST_SYSENTER_EIP, (u64)(&entry_sysenter));
>  	vmcs_write(GUEST_DR7, 0);
>  	vmcs_write(GUEST_EFER, rdmsr(MSR_EFER));
> @@ -1292,7 +1292,7 @@ static void init_vmcs_guest(void)
>  
>  	/* 26.3.1.4 */
>  	vmcs_write(GUEST_RIP, (u64)(&guest_entry));
> -	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE - 1));
> +	vmcs_write(GUEST_RSP, (u64)(guest_stack + PAGE_SIZE));

Rather than do the math here, which looks arbitrary at first blance, what about
adjusting on allocation and renaming the variables accordingly?  E.g.

diff --git a/x86/vmx.c b/x86/vmx.c
index 6dc9a55..bc8be77 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1388,8 +1388,8 @@ void init_vmx(u64 *vmxon_region)
 static void alloc_bsp_vmx_pages(void)
 {
        bsp_vmxon_region = alloc_page();
-       guest_stack = alloc_page();
-       guest_syscall_stack = alloc_page();
+       guest_stack_top = alloc_page() + PAGE_SIZE;
+       guest_syscall_stack_top = alloc_page() + PAGE_SIZE;
        vmcs_root = alloc_page();
 }

>  	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
>  
>  	/* 26.3.1.5 */
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
