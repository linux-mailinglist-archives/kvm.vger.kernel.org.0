Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119C442AACF
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhJLRdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232509AbhJLRdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 13:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634059863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7O9XAJPqw1pERvs0EKY5qZyYY4IGf7kZ5Q2zMZNRDY4=;
        b=fZ+9kJqNL9zZKgPfM4J1u5/7H0Wzk++YffQk3gAQvyTl/L91AeQ5CnyoAOVhRe/acP+Oqv
        bk/nvRXvFUhwea7tZytWBe4EnsLYRIUdPEdLwnBEDdcLWnallsD1J1hzpT086BgFq1Es95
        drjPC0gzROGRyX7U8V/MCDU82dwtgCs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-znMLsdmiOWS1Jh-_9sufrw-1; Tue, 12 Oct 2021 13:31:01 -0400
X-MC-Unique: znMLsdmiOWS1Jh-_9sufrw-1
Received: by mail-wr1-f70.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso16433164wrg.7
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 10:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7O9XAJPqw1pERvs0EKY5qZyYY4IGf7kZ5Q2zMZNRDY4=;
        b=1+Q4Ims+q2Y4ek8Se1/uhEqhs9n/fGtnWApWG7DIKsjf0QfRS7lvLgifGvywJz7hsJ
         7o3aqwuRi8qZgiPCAOnDKDgSqJBP63neiTSDDPSQPbr+HnYEClAI5mPg4H5VQ+3verXu
         kwdkTt/qWVQk732pKCXY2PJv4JxiQ1BwWlYFKEVbwqM9Cq1uSTPOdG1ZGKw8R43c3hAu
         WKAX3rnq4DNS3BTh+lP/jQt/aYJ4LxOvmxilUR1b8ZP+uQex9IOrUW/cjV+iSfA+NK0w
         ozTPxLUqwfsJWMY5zizbzKqOUiIuCHqEeemAxVi673BfszXUCARvjRVmr6c/IGJjC5ql
         d5BQ==
X-Gm-Message-State: AOAM533+FYIW5wUQkdQiluIWh/oZgSrfm07GrNz4cmtq16mbaPL1h7+N
        Nebzrr0MXgJErIWG4Uf1LBGPZnQlrxII7l9wrT4toQMIBwkPdRYOvVkxS6ekSBY+mhIWtpI3asX
        mrhiL0sDa15NZ
X-Received: by 2002:a1c:4302:: with SMTP id q2mr7321650wma.133.1634059859909;
        Tue, 12 Oct 2021 10:30:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+cx6C+ClIaLXdBDG70Wy6jSMQPxmPmEqwxGgVvlLrD2bo6JjJAkb4wAwYLBA7jyUr8x8Zuw==
X-Received: by 2002:a1c:4302:: with SMTP id q2mr7321614wma.133.1634059859632;
        Tue, 12 Oct 2021 10:30:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p19sm3011439wmg.29.2021.10.12.10.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 10:30:59 -0700 (PDT)
Message-ID: <bbf53506-43df-78cc-c954-ed4e8384b1d2@redhat.com>
Date:   Tue, 12 Oct 2021 19:30:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 15/31] x86/fpu: Rework copy_xstate_to_uabi_buf()
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.189084655@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211011223611.189084655@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 02:00, Thomas Gleixner wrote:
> Prepare for replacing the KVM copy xstate to user function by extending
> copy_xstate_to_uabi_buf() with a pkru argument which allows the caller to
> hand in the pkru value, which is required for KVM because the guest PKRU is
> not accessible via current. Fixup all callsites accordingly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   arch/x86/kernel/fpu/xstate.c |   34 ++++++++++++++++++++++++++--------
>   arch/x86/kernel/fpu/xstate.h |    3 +++
>   2 files changed, 29 insertions(+), 8 deletions(-)
> 
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -940,9 +940,10 @@ static void copy_feature(bool from_xstat
>   }
>   
>   /**
> - * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
> + * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
>    * @to:		membuf descriptor
> - * @tsk:	The task from which to copy the saved xstate
> + * @xsave:	The xsave from which to copy
> + * @pkru_val:	The PKRU value to store in the PKRU component
>    * @copy_mode:	The requested copy mode
>    *
>    * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
> @@ -951,11 +952,10 @@ static void copy_feature(bool from_xstat
>    *
>    * It supports partial copy but @to.pos always starts from zero.
>    */
> -void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
> -			     enum xstate_copy_mode copy_mode)
> +void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
> +			       u32 pkru_val, enum xstate_copy_mode copy_mode)
>   {
>   	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
> -	struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
>   	struct xregs_state *xinit = &init_fpstate.xsave;
>   	struct xstate_header header;
>   	unsigned int zerofrom;
> @@ -1033,10 +1033,9 @@ void copy_xstate_to_uabi_buf(struct memb
>   			struct pkru_state pkru = {0};
>   			/*
>   			 * PKRU is not necessarily up to date in the
> -			 * thread's XSAVE buffer.  Fill this part from the
> -			 * per-thread storage.
> +			 * XSAVE buffer. Use the provided value.
>   			 */
> -			pkru.pkru = tsk->thread.pkru;
> +			pkru.pkru = pkru_val;
>   			membuf_write(&to, &pkru, sizeof(pkru));
>   		} else {
>   			copy_feature(header.xfeatures & BIT_ULL(i), &to,
> @@ -1056,6 +1055,25 @@ void copy_xstate_to_uabi_buf(struct memb
>   		membuf_zero(&to, to.left);
>   }
>   
> +/**
> + * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
> + * @to:		membuf descriptor
> + * @tsk:	The task from which to copy the saved xstate
> + * @copy_mode:	The requested copy mode
> + *
> + * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
> + * format, i.e. from the kernel internal hardware dependent storage format
> + * to the requested @mode. UABI XSTATE is always uncompacted!
> + *
> + * It supports partial copy but @to.pos always starts from zero.
> + */
> +void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
> +			     enum xstate_copy_mode copy_mode)
> +{
> +	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.state.xsave,
> +				  tsk->thread.pkru, copy_mode);
> +}
> +
>   static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
>   			    const void *kbuf, const void __user *ubuf)
>   {
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -15,4 +15,7 @@ static inline void xstate_init_xcomp_bv(
>   		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
>   }
>   
> +extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
> +				      u32 pkru_val, enum xstate_copy_mode copy_mode);
> +
>   #endif
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

