Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC41FCCF6
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgFQMCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 08:02:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726355AbgFQMCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 08:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592395321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j3KZfv+ABDEhp38Vycq0NUDA6yFL4fPzRdNzYITXogA=;
        b=Md8qINb/kQTyZ5kYK6DUfJnd9SJBfHJLHg37c3Inji5S6OZSGhYWliIHOf3UnchrZjDUV6
        q2GqlPgV6Q56wj+U2dmiZmczXjrP6ZffRpU2Rgjufyjma07tW9JxI9B4mSpKgrxil9NoBK
        xfQomaZ7o2OZr+eZMjRJqxwEAxOlr8M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-H1BA2CP0M22Nib1h2gSLNQ-1; Wed, 17 Jun 2020 08:01:46 -0400
X-MC-Unique: H1BA2CP0M22Nib1h2gSLNQ-1
Received: by mail-ed1-f70.google.com with SMTP id n17so741823eda.13
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 05:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j3KZfv+ABDEhp38Vycq0NUDA6yFL4fPzRdNzYITXogA=;
        b=pMbpslc/zI+TqXN+PDKmBisdrGdf6D7/HrMXvN4lHa+U+hws8EmRJMNSdfWeqZyx8W
         Xyh6dHAnOVKgZc1RyE39kWMQqsB3AUcGab7v2Bjucljepg1AwYf5p+SEO4ytCFhc8ahQ
         ZkRVK+ZE02wRKO8RHEZpO3sNJJoTGxp4WFj9AMfQmm4Nod1uPyU+pGcB2Wyy49toXtUb
         Mlqa2OL5ndk82PbCO0MxGJ7g0POyo/gTaPX+1e8qnohRE9MhPDnDId6lTmH9HzVk3RrP
         uQTSU8K8P7X1/c25HHLgS4XoDeLkyh+yAqPExOVQDW51HKKmSKDDQH0/fsAia/WmsAv4
         i5Lg==
X-Gm-Message-State: AOAM532YbKNrs04tRC9THNjOxs3CnA7pNLjxklJ1+m9kDtBTCZooezsx
        t0UwQJa0MpNsuUJigkG6IJdYv9UHpIuir0x9y92GuaMBDVde+Hxg7FLK0hqWPrwWD/MyWWXvdk+
        hWJTkDgLx/046
X-Received: by 2002:a17:906:d923:: with SMTP id rn3mr7250415ejb.261.1592395305182;
        Wed, 17 Jun 2020 05:01:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJTv8Lt7Y1Uah818uoeMpjzSrj4tS1DxrHkKqJv8p6S2J4u8awmoCA33uvTJEHVhtYzKQZxw==
X-Received: by 2002:a17:906:d923:: with SMTP id rn3mr7250377ejb.261.1592395304808;
        Wed, 17 Jun 2020 05:01:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o16sm13382023ejg.106.2020.06.17.05.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 05:01:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, tglx@linutronix.de,
        jmattson@google.com
Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
In-Reply-To: <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu> <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
Date:   Wed, 17 Jun 2020 14:01:42 +0200
Message-ID: <87r1udhpeh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Babu Moger <babu.moger@amd.com> writes:

> The new intercept bits have been added in vmcb control
> area to support the interception of INVPCID instruction.
>
> The following bit is added to the VMCB layout control area
> to control intercept of INVPCID:
>
> Byte Offset     Bit(s)          Function
> 14h             2               intercept INVPCID
>
> Add the interfaces to support these extended interception.
> Also update the tracing for extended intercepts.
>
> AMD documentation for INVPCID feature is available at "AMD64
> Architecture Programmer’s Manual Volume 2: System Programming,
> Pub. 24593 Rev. 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/svm.h |    3 ++-
>  arch/x86/kvm/svm/nested.c  |    6 +++++-
>  arch/x86/kvm/svm/svm.c     |    1 +
>  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
>  arch/x86/kvm/trace.h       |   12 ++++++++----
>  5 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 8a1f5382a4ea..62649fba8908 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u32 intercept_dr;
>  	u32 intercept_exceptions;
>  	u64 intercept;
> -	u8 reserved_1[40];
> +	u32 intercept_extended;
> +	u8 reserved_1[36];
>  	u16 pause_filter_thresh;
>  	u16 pause_filter_count;
>  	u64 iopm_base_pa;
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8a6db11dcb43..7f6d0f2533e2 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	c->intercept_dr = h->intercept_dr;
>  	c->intercept_exceptions = h->intercept_exceptions;
>  	c->intercept = h->intercept;
> +	c->intercept_extended = h->intercept_extended;
>  
>  	if (g->int_ctl & V_INTR_MASKING_MASK) {
>  		/* We only want the cr8 intercept bits of L1 */
> @@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	c->intercept_dr |= g->intercept_dr;
>  	c->intercept_exceptions |= g->intercept_exceptions;
>  	c->intercept |= g->intercept;
> +	c->intercept_extended |= g->intercept_extended;
>  }
>  
>  static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> @@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
>  	dst->intercept_dr         = from->intercept_dr;
>  	dst->intercept_exceptions = from->intercept_exceptions;
>  	dst->intercept            = from->intercept;
> +	dst->intercept_extended   = from->intercept_extended;
>  	dst->iopm_base_pa         = from->iopm_base_pa;
>  	dst->msrpm_base_pa        = from->msrpm_base_pa;
>  	dst->tsc_offset           = from->tsc_offset;
> @@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
>  				    nested_vmcb->control.intercept_cr >> 16,
>  				    nested_vmcb->control.intercept_exceptions,
> -				    nested_vmcb->control.intercept);
> +				    nested_vmcb->control.intercept,
> +				    nested_vmcb->control.intercept_extended);
>  
>  	/* Clear internal status */
>  	kvm_clear_exception_queue(&svm->vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9e333b91ff78..285e5e1ff518 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
>  	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
>  	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
> +	pr_err("%-20s%08x\n", "intercepts (extended):", control->intercept_extended);
>  	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
>  	pr_err("%-20s%d\n", "pause filter threshold:",
>  	       control->pause_filter_thresh);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6ac4c00a5d82..935d08fac03d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
>  	recalc_intercepts(svm);
>  }
>  
> +static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_extended |= (1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
> +static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	vmcb->control.intercept_extended &= ~(1U << bit);
> +
> +	recalc_intercepts(svm);
> +}
> +
>  static inline bool is_intercept(struct vcpu_svm *svm, int bit)
>  {
>  	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b66432b015d2..5c841c42b33d 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
>  );
>  
>  TRACE_EVENT(kvm_nested_intercepts,
> -	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept),
> -	    TP_ARGS(cr_read, cr_write, exceptions, intercept),
> +	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept,
> +		     __u32 extended),
> +	    TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
>  
>  	TP_STRUCT__entry(
>  		__field(	__u16,		cr_read		)
>  		__field(	__u16,		cr_write	)
>  		__field(	__u32,		exceptions	)
>  		__field(	__u64,		intercept	)
> +		__field(	__u32,		extended	)
>  	),
>  
>  	TP_fast_assign(
> @@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
>  		__entry->cr_write	= cr_write;
>  		__entry->exceptions	= exceptions;
>  		__entry->intercept	= intercept;
> +		__entry->extended	= extended;
>  	),
>  
> -	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
> +	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx"
> +		  "intercept (extended): %08x",
>  		__entry->cr_read, __entry->cr_write, __entry->exceptions,
> -		__entry->intercept)
> +		__entry->intercept, __entry->extended)

Nit: I would've renamed 'extended' to something like 'intercept_ext' as
it is not clear what it is about otherwise. Also, if you decide to do
so, you may as well shorten 'intercept_extended' to 'intercept_ext'
everywhere else to be consistent. Or just use 'intercept_extended', with
no 80-character-per-line limitation we no longer need to be concise.

>  );
>  /*
>   * Tracepoint for #VMEXIT while nested
>

-- 
Vitaly

