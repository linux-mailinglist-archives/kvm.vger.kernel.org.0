Return-Path: <kvm+bounces-430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC027DF97A
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BBB7B213C7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C0F21111;
	Thu,  2 Nov 2023 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gZA8aNOV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A819208A4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:04:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7BA3C18
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9TXakoAWW1FFOLF5UXdw93JMmC9MoRdLwbBdEicJ9T4=;
	b=gZA8aNOViEt4o0yigtQsiPkGQKBI0Tg/g0bPHKwI0rwjbM8UGKxocNbEpdzjWrMWuJr6sv
	tUwqaYyA589qcKBCMkYOKNMlcYQmRZV0MtcCabxkm2SZwzDaX2fYtCiylaIzI+THWbQCi5
	3FZ+mkk1XS2DTFqQA5TjikdQ3jN0kWA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-wqHcr5D9PliPGqgzYXxgzQ-1; Thu, 02 Nov 2023 14:00:40 -0400
X-MC-Unique: wqHcr5D9PliPGqgzYXxgzQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32da7983d20so822715f8f.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948039; x=1699552839;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TXakoAWW1FFOLF5UXdw93JMmC9MoRdLwbBdEicJ9T4=;
        b=gZ+4uPoCRCii0n2D0GKGjJJpO1gqoSqshxKkN9ciEpe+9a2m2o2gCPgdJ93dBUXpLT
         yh37qpIMUQfsqZ//mCFc+d/vzm787eFJKt/f0emLsFULQ8rQXRceEIkKCuuqU8jg0i3c
         GR9O2jxzM+kB+siX91xir+K91sVe10B2IOTWY544+fbFt4WHSSVSLkLjG18H1WK5IVUD
         X1cppoPaWd9mEPziCEMetHhIZNRcbnGGh2cpzKSDRxZxlIZkbhYgY0+3QvzxdzF3MMZp
         GMYEUBG5Vk1aaCDZMwb4bdf5l6xPTmVJl5O4xFAgmRI1uHJXC+2HlTYUtWHIoIgr1sYp
         otvg==
X-Gm-Message-State: AOJu0YyVhEL2NdrYykku5ipNasf6I9ZG/JoJxTxB8y2s/FJKSKmE9o5F
	OqZn0qUfGUeT6o4VBhRwa+uFXIBofUjLJFwKaA4Ay3XggT7HygX9P7oVcSYOLW5ddLFVl9wWTXu
	j3ttvbluXN4g4
X-Received: by 2002:adf:d1ca:0:b0:32f:89fb:771b with SMTP id b10-20020adfd1ca000000b0032f89fb771bmr298493wrd.4.1698948038788;
        Thu, 02 Nov 2023 11:00:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQ+PseGXhaGK5KA47SlyvvRQ+IpK7jimMGqL/PtZUrchAkuXB/NyC2l+qCdJkE8Bvk3Naoiw==
X-Received: by 2002:adf:d1ca:0:b0:32f:89fb:771b with SMTP id b10-20020adfd1ca000000b0032f89fb771bmr298468wrd.4.1698948038507;
        Thu, 02 Nov 2023 11:00:38 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id l10-20020a1c790a000000b004063977eccesm3573161wme.42.2023.11.02.11.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:00:38 -0700 (PDT)
Message-ID: <65781f864b94db127a7a17e52835326a8a6a9ea0.camel@redhat.com>
Subject: Re: [PATCH 1/9] KVM: x86: SVM: Emulate reads and writes to shadow
 stack MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:00:36 +0200
In-Reply-To: <20231010200220.897953-2-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-2-john.allen@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> Set up interception of shadow stack MSRs. In the event that shadow stack
> is unsupported on the host or the MSRs are otherwise inaccessible, the
> interception code will return an error. In certain circumstances such as
> host initiated MSR reads or writes, the interception code will get or
> set the requested MSR value.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f283eb47f6ac..6a0d225311bc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2859,6 +2859,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (guest_cpuid_is_intel(vcpu))
>  			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
>  		break;
> +	case MSR_IA32_S_CET:
> +		msr_info->data = svm->vmcb->save.s_cet;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		msr_info->data = svm->vmcb->save.isst_addr;
> +		break;
> +	case MSR_KVM_SSP:
> +		msr_info->data = svm->vmcb->save.ssp;
> +		break;
>  	case MSR_TSC_AUX:
>  		msr_info->data = svm->tsc_aux;
>  		break;
> @@ -3085,6 +3094,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
>  		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
>  		break;
> +	case MSR_IA32_S_CET:
> +		svm->vmcb->save.s_cet = data;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		svm->vmcb->save.isst_addr = data;
> +		break;
> +	case MSR_KVM_SSP:
> +		svm->vmcb->save.ssp = data;
> +		break;
>  	case MSR_TSC_AUX:
>  		/*
>  		 * TSC_AUX is usually changed only during boot and never read

Looks good, except that if my complaint about turning the fake 'MSR_KVM_SSP' into
a first class register with an ioctl to load/save it is accepted, then
there will be a new vendor callback to read/write it instead of doing it in svm_get_msr/svm_set_msr.


Besides this,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


