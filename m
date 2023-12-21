Return-Path: <kvm+bounces-5099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B1781BD6C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93458284D0F
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA22A634E9;
	Thu, 21 Dec 2023 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkyphdWj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BEB6280F
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703180347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lmqp/czkHMojOeftPQVWbvCS1EgUxfVVJpJ5v/dQTQg=;
	b=FkyphdWjk+fOHb1+cug03wuELO4N7zawBtL3yw/n/ernqjSTpzFaoZ4QeMI/Y6ETfE+d37
	/O9qhnm6VHrgOTxGSjfG4EIr06gGVD2UIW0Gefj8F+itrbTt/LwUII299ONjnImc8tDYjS
	nEDmlwRtxf7beYRka5u7G+qoLHrWlUs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-xF3VrjgCMzOB_rTmPS4p3g-1; Thu, 21 Dec 2023 12:39:06 -0500
X-MC-Unique: xF3VrjgCMzOB_rTmPS4p3g-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-553dd5dfba8so1160619a12.0
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 09:39:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703180345; x=1703785145;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lmqp/czkHMojOeftPQVWbvCS1EgUxfVVJpJ5v/dQTQg=;
        b=OjZZUXnl1pioGFHGVhj6tVylfIYZy2MGsw0ASnJmXTLpDiBH28SJodS0Fo7Mypaoht
         nNZgWlRJJX8GojIELfOU5dpYce1Mo1T5TESK8TiIYtdNYFNYO8jileIi5fhgvRxstoIM
         ZZNMo1q5IrTKQ2E9S/gmN6gNIe7Agj7TiHvfOK21irNlIodNGw/EUL2OFCXmXoKbwr4T
         /+fT30muReGsabG2L8eiWM1/AfWW6A7FYsmO5U49RxUaVEDgc/jJbAFUd+AkRCOsw3l6
         U583j8gzRYGU2vUjKgk1POXeNrazui621ej9rvx8/VzmLcOMKn+PNMf+eWEm8L8QoUEx
         IsHA==
X-Gm-Message-State: AOJu0YyBV0mLmKs6oduopy3OPFb1rCoKNzZF+YvJJF6IUkXGbwcGVjkj
	pLL0PyggJYnBtUi0ldG2LvErXFISN2oSxaWkkVRDtOPeBWa++XKmal2SbM3dF4bN0A0hc5Omfqi
	+pY5SwOD+99/F+t2zEDEb
X-Received: by 2002:a50:99de:0:b0:553:58d7:5eb3 with SMTP id n30-20020a5099de000000b0055358d75eb3mr35314edb.38.1703180344845;
        Thu, 21 Dec 2023 09:39:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQCfZTR9V7XNfqQczu+7awxhtC9Yp61ULvBbgJpcwHcsspznBrlIYM+QcD3j2R/lAnW8Af7w==
X-Received: by 2002:a50:99de:0:b0:553:58d7:5eb3 with SMTP id n30-20020a5099de000000b0055358d75eb3mr35309edb.38.1703180344570;
        Thu, 21 Dec 2023 09:39:04 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id h7-20020a0564020e0700b0055283720ec3sm1443741edh.76.2023.12.21.09.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:39:04 -0800 (PST)
Message-ID: <5da78d01b6f585125c6374e6e878c70e65576704.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: x86/hyperv: Calculate APIC bus frequency
 for hyper-v
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, Vishal
 Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@gmail.com
Date: Thu, 21 Dec 2023 19:39:01 +0200
In-Reply-To: <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
	 <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-19 at 00:34 -0800, Isaku Yamahata wrote:
> Remove APIC_BUS_FREUQNCY

> and calculate it based on APIC bus cycles per NS.
> APIC_BUS_FREUQNCY is used only for HV_X64_MSR_APIC_FREQUENCY.  The MSR is
> not frequently read, calculate it every time.
> 
> In order to make APIC bus frequency configurable, we need to make make two
> related constants into variables.  APIC_BUS_FREUQNCY and APIC_BUS_CYCLE_NS.
> One can be calculated from the other.

APIC_BUS_FREUQNCY is a typo.

>    APIC_BUS_CYCLES_NS = 1000 * 1000 * 1000 / APIC_BUS_FREQUENCY.
> By removing APIC_BUS_FREQUENCY, we need to track only single variable
> instead of two.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v3:
> - Newly added according to Maxim Levistsky suggestion.
Typo: Maxim Levitsky

> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  arch/x86/kvm/lapic.h  | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 238afd7335e4..a40ca2fef58c 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1687,7 +1687,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
>  		break;
>  	case HV_X64_MSR_APIC_FREQUENCY:
> -		data = APIC_BUS_FREQUENCY;
> +		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
>  		break;
>  	default:
>  		kvm_pr_unimpl_rdmsr(vcpu, msr);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0a0ea4b5dd8c..a20cb006b6c8 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -17,7 +17,6 @@
>  #define APIC_DEST_MASK			0x800
>  
>  #define APIC_BUS_CYCLE_NS       1
> -#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
>  
>  #define APIC_BROADCAST			0xFF
>  #define X2APIC_BROADCAST		0xFFFFFFFFul


Other than typos:

Reviewed-by: Maxim Levitsky <maximlevitsky@gmail.com>

Best regards,
	Maxim Levitsky


