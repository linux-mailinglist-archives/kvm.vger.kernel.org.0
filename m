Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93259344FA1
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCVTJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:09:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230001AbhCVTIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 15:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616440127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hh5/cz6G/AaWkrGjRgIuukSL88RqHPGAaCDR82hIr6A=;
        b=S/LURE2GlPSAvgeUeFYP8RcYANwt62yZXc9wwQUJ2L6EkqCkPUs7iBZht9N5aHGFQ9mG2b
        /7wyhgutrzgjBxclthGHCJqrORasphU6virQdgXeUbt5rPFppMEMsZ1jtxXNp2P/hsNgtn
        OscQTkzgIDnTMov5D78x8srEyBCgAIw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-68L_Bvt_MZaTzWM9xN-CHw-1; Mon, 22 Mar 2021 15:08:41 -0400
X-MC-Unique: 68L_Bvt_MZaTzWM9xN-CHw-1
Received: by mail-wr1-f71.google.com with SMTP id y5so26577174wrp.2
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 12:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hh5/cz6G/AaWkrGjRgIuukSL88RqHPGAaCDR82hIr6A=;
        b=FI8vwhuOk5b/LED3TRWAj+MrnLLCXypjrZXoUmaXYKgHZ4nme+MZDg52+eUCIYmetC
         3dJ7Tq8Ow/se4ucDtDERb5BY6pRGoB3vReCOvsIlnVvr8be2ORthNqVVPQSz1QyuDe5R
         DHSQpTm/KGUbKFc1V70UEl/YzXXBP1HFLEPdj+9Ey/46L5YSevayS8uNelYhHHRqI5ZT
         r4VTqM8TH4b16lfkIHD95q4Gz70WmcuBwq1EU8tZLhWR4X1ekzlTlBTz/CqAQGzfvzlk
         5Y7SA4RhYC6Ff0sDeePCwGgJmuJpOSPaSJJyQFGc9auGetlm6Rfk2XEYkBqbaCbqM3JU
         TFSA==
X-Gm-Message-State: AOAM533iPbh2fqJSAwkVtbJiTBwllTvxjcjJT9Q/P0tPAawEWOJi7LyE
        lAIT5+qawcK5YtPYeYPLqAab3AhTSZrz5/P1lHhaZEPus6xijZxU1T+wbGOUv1kpw0RTK9ypIAy
        yInvUzs8lV3t4
X-Received: by 2002:adf:c40b:: with SMTP id v11mr70241wrf.320.1616440120201;
        Mon, 22 Mar 2021 12:08:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjww5Kl4RwUo6v5C+C7GtLgHY7OA6ckF4HXfpyI2KS0dXhHML3E/fEouhJoZpqVTp5c4mx4Q==
X-Received: by 2002:adf:c40b:: with SMTP id v11mr70232wrf.320.1616440120027;
        Mon, 22 Mar 2021 12:08:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m11sm19484456wrz.40.2021.03.22.12.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:08:39 -0700 (PDT)
Subject: Re: [PATCH 1/4 v4] KVM: nSVM: Trigger synthetic #DB intercept
 following completion of single-stepped VMRUN instruction
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
 <20210322181007.71519-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc8a657c-19c6-cefe-d527-6e14567dc7dc@redhat.com>
Date:   Mon, 22 Mar 2021 20:08:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210322181007.71519-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/21 19:10, Krish Sadhukhan wrote:
> According to APM, the #DB intercept for a single-stepped VMRUN must happen
> after the completion of that instruction, when the guest does #VMEXIT to
> the host. However, in the current implementation of KVM, the #DB intercept
> for a single-stepped VMRUN happens after the completion of the instruction
> that follows the VMRUN instruction. When the #DB intercept handler is
> invoked, it shows the RIP of the instruction that follows VMRUN, instead of
> of VMRUN itself. This is an incorrect RIP as far as single-stepping VMRUN
> is concerned.
> 
> This patch fixes the problem by checking for the condtion that the VMRUN
> instruction is being single-stepped and if so, triggers a synthetic #DB
> intercept so that the #DB for the VMRUN is accounted for at the right time.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
> ---
>   arch/x86/kvm/svm/svm.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58a45bb139f8..085aa02f584d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3825,6 +3825,21 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	trace_kvm_entry(vcpu);
>   
> +	if (unlikely(to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
> +	    to_svm(vcpu)->vmcb->save.rflags & X86_EFLAGS_TF)) {
> +		/*
> +		 * We are here following a VMRUN that is being
> +		 * single-stepped. The #DB intercept that is due for this
> +		 * single-stepping, will only be triggered when we execute
> +		 * the next VCPU instruction via _svm_vcpu_run(). But it
> +		 * will be too late. So we fake a #DB intercept by setting
> +		 * the appropriate exit code and returning to our caller
> +		 * right from here so that the due #DB can be accounted for.
> +		 */
> +		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + DB_VECTOR;
> +		return EXIT_FASTPATH_NONE;
> +	}
> +
>   	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
>   	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>   	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
> 

Thanks for the test...  Here I wonder if doing it on the nested vmexit, 
and using kvm_queue_exception, would be clearer.  This VMCB patching is 
quite mysterious.

Paolo

