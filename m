Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3288132D92C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 19:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhCDSCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 13:02:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232321AbhCDSB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 13:01:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614880830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BqnFEGfnZr3W8uIDG+7Nvt/a5cFx4d8s4ykgtc1+mo=;
        b=V2vWyWI/MY6YdNYlmn7WMeUNDu1UKIPut9E+nHqTwVVCzUe4hZV1m4Q9FiLtYPEAW6xDdt
        Y/aXn21voHQmerObnkdh/PjTrLhcB2vn8BaC1IJXc4NNt4bKKA+q4UPxVTd44IB7zvI27n
        NkIF3XyHrMrmMwkCnOacPR42oJUoMuE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-yeUezG_INICTSmWqMbTy6Q-1; Thu, 04 Mar 2021 13:00:27 -0500
X-MC-Unique: yeUezG_INICTSmWqMbTy6Q-1
Received: by mail-wm1-f72.google.com with SMTP id f9so4812272wml.0
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 10:00:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5BqnFEGfnZr3W8uIDG+7Nvt/a5cFx4d8s4ykgtc1+mo=;
        b=QsxXhrfaHWAThRm2pRv/ZSHaDLwWzFbtDpKT+Fppg27LKAnpMpiD+OaC7S0A3pjIDB
         avhvVNUHLNln1fOpAngb68yrQ1+MIQpRB/1BzDt5pfvZVpDIZL8yDN2vhjxdJS5I+qh2
         tR77uaqO8ibHQIJWFjs5096+88j+eCwFXkJUxDUPliJaBYh9PKNCPP21k2qUi3rjH8xW
         NCRIRZgH3r8+ld9NZ6eDBy7wx8zCVxSJAzv463CcQdK3H1Bi1H7teGghTr8W7g3AR0LO
         8ESQZDpKSMlFoGis18QUr1Sk9PsNrBCQVvqiL/jv/7/KqXU/Wf+cBoscPyBHzAeacDOd
         OA/g==
X-Gm-Message-State: AOAM531DZN+q5vQVk1PLskg5b2bd0i8CdvyjJvavXk3eHnBWr2+wX2D/
        74Zn9gq7XWhrbUgIZVvt2Fx9BwB/SRsj2vB8b99CrA7hi8e/hq8MDXOd7qxz1rGodclRGLypwFO
        BYIGwthone4dJ
X-Received: by 2002:a5d:6703:: with SMTP id o3mr5219331wru.357.1614880826405;
        Thu, 04 Mar 2021 10:00:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr0VEED2Vf1x91kUpe+VUszhB6JIwu7nT3iVdeJSwwp6GxjkNh4y3M7TvIxWsRmvTjcSK7bA==
X-Received: by 2002:a5d:6703:: with SMTP id o3mr5219310wru.357.1614880826202;
        Thu, 04 Mar 2021 10:00:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p11sm24792205wrs.80.2021.03.04.10.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 10:00:25 -0800 (PST)
Subject: Re: [PATCH] nSVM: Test VMLOAD/VMSAVE intercepts
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210304163613.42116-1-krish.sadhukhan@oracle.com>
 <20210304163613.42116-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c425a34-e300-deae-e418-5b96868cef63@redhat.com>
Date:   Thu, 4 Mar 2021 19:00:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210304163613.42116-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/21 17:36, Krish Sadhukhan wrote:
> If VMLOAD/VMSAVE intercepts are disabled, no respective #VMEXIT to host
> happens. Enabling VMLOAD/VMSAVE intercept will cause respective #VMEXIT
> to host.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   x86/svm_tests.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 64 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 29a0b59..7f4e63e 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2382,6 +2382,69 @@ static void svm_vmrun_errata_test(void)
>       }
>   }
>   
> +static void vmload_vmsave_guest_main(struct svm_test *test)
> +{
> +	u64 vmcb_phys = virt_to_phys(vmcb);
> +
> +	asm volatile ("vmload %0" : : "a"(vmcb_phys));
> +	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
> +}
> +
> +static void svm_vmload_vmsave(void)
> +{
> +	u32 intercept_saved = vmcb->control.intercept;
> +
> +	test_set_guest(vmload_vmsave_guest_main);
> +
> +	/*
> +	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
> +	 * respective #VMEXIT to host
> +	 */
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> +
> +	/*
> +	 * Enabling intercept for VMLOAD and VMSAVE causes respective
> +	 * #VMEXIT to host
> +	 */
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> +
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> +
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	svm_vmrun();
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> +
> +	vmcb->control.intercept = intercept_saved;
> +}
> +
>   struct svm_test svm_tests[] = {
>       { "null", default_supported, default_prepare,
>         default_prepare_gif_clear, null_test,
> @@ -2495,5 +2558,6 @@ struct svm_test svm_tests[] = {
>       TEST(svm_cr4_osxsave_test),
>       TEST(svm_guest_state_test),
>       TEST(svm_vmrun_errata_test),
> +    TEST(svm_vmload_vmsave),
>       { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>   };
> 

Queued, thanks.

Paolo

