Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60030F619
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 16:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbhBDPVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 10:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237226AbhBDPUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 10:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612451959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pmnlbazg6+NHbnJobwEA250vXJhh0dacgvmsd2kgHhM=;
        b=W2VL+GhzEsq8XK81xWGaRdD2k1W8jokk00mrnFQC72bYDSJ18lPWisdct2e2ZBp0VtCk5F
        StI2GMTwo9YACg3gMKjIsldVWmfKN0x0TfkiTiD3Y5vMzom8tjPSUCBEO+x4ywI+N2Ildv
        lqQKGluMEVGfA/CDdpT8TWMAY68BJDc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-qMtp83esPtCKEdvbNIygcQ-1; Thu, 04 Feb 2021 10:19:18 -0500
X-MC-Unique: qMtp83esPtCKEdvbNIygcQ-1
Received: by mail-wr1-f71.google.com with SMTP id r5so2952500wrx.18
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 07:19:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pmnlbazg6+NHbnJobwEA250vXJhh0dacgvmsd2kgHhM=;
        b=E+imI6MrK4Lfz4iJvU2AUz/DGJm5xpCDLXSI4yxgssu9HHXHXX0tGuoJ+g++1cpjOr
         CoQjvoOm8DpXFfLUZPwe/ALTLThQ+nDS5woVn5gm9tJxD4DOJjWfCsCczN0xmp0NBNVd
         6dg2ip0qvj4YyDwA2f3tBrgbQA/DsR2vwMfyDIyhnAQasAzxmwIaPEm1uHt1ye4vhFDv
         qKFjL+33CZqVJ2E77KZUPbbwN5+SFPqLgWnYVt8kPES60umfR5fOdYBsO8lhAcZQzFiX
         TXJq2Qf/inNtnFqvYvBCubqkelZEBHvSmH4evPa7LeVteCgEpqG84eGvgII2ujNNt36K
         bamw==
X-Gm-Message-State: AOAM530hcA1RUd2za/GZ379/KHDfVpnoJRZJFpF2pv6kjefus5I0hY+U
        8Wcj9Wt3WJrwRuOzqiKjcLUEpvgc3/gT/pQrckRoQrq4VVbpzWmk+Ksb/8jRt7WoAQF1GWjXbp5
        GDPOr49Wd7Npx
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr10073083wry.356.1612451957242;
        Thu, 04 Feb 2021 07:19:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYWd962neGwCgRgTcfwGPzk7YGlpuAuJrYLrkQ85l89hgtzEaKBKWXqp1YUWgb9EtZVpG11g==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr10073073wry.356.1612451957102;
        Thu, 04 Feb 2021 07:19:17 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t18sm8442605wrr.56.2021.02.04.07.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 07:19:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Kechen Lu <kechenl@nvidia.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
In-Reply-To: <87wnvnop1p.fsf@vitty.brq.redhat.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
 <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
 <87wnvnop1p.fsf@vitty.brq.redhat.com>
Date:   Thu, 04 Feb 2021 16:19:15 +0100
Message-ID: <87tuqroo7g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> +
> +	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> +
> +	/* Hyper-V SynIC auto EOI SINT's are not compatible with APICV */
> +	if (!auto_eoi_old && auto_eoi_new) {
> +		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
> +			kvm_request_apicv_update(vcpu->kvm, false,
> +						 APICV_INHIBIT_REASON_HYPERV);
> +	} else if (!auto_eoi_old && auto_eoi_new) {

Sigh, this 'else' should be 

} else if (!auto_eoi_new && auto_eoi_old) {

...

> +		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
> +			kvm_request_apicv_update(vcpu->kvm, true,
> +						 APICV_INHIBIT_REASON_HYPERV);
> +	}
>  }
>  
>  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> @@ -903,12 +923,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>  {
>  	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
>  
> -	/*
> -	 * Hyper-V SynIC auto EOI SINT's are
> -	 * not compatible with APICV, so request
> -	 * to deactivate APICV permanently.
> -	 */
> -	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
>  	synic->active = true;
>  	synic->dont_zero_synic_pages = dont_zero_synic_pages;
>  	synic->control = HV_SYNIC_CONTROL_ENABLE;

-- 
Vitaly

