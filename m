Return-Path: <kvm+bounces-4557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88DF4814549
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 11:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBAD51C22F92
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 10:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773BA1A734;
	Fri, 15 Dec 2023 10:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HCknJ1SY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E17B1A71C
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 10:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702635474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=42FJiFvltYp2rdiqySuaRIVVGIjwc6Ht5anz+ABGSo8=;
	b=HCknJ1SYDuZgbw04xsPJb9DR+08q8GMa4E0MP5EvNoGkkPL5CwRH5ZRvcOGRlZQbHkSyIc
	qIRZQI/uxnKDSgGlrmSF2QD9w1oAOCf59KOlvZy+hlOV1EjtS2EY7a2SRiFLCQmWjKmE5e
	xPxD7SJafc8n40U0Ob6oC9bhTPp7VxY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-Ar13ZUxTM5m2n2iBZNH5Iw-1; Fri, 15 Dec 2023 05:17:53 -0500
X-MC-Unique: Ar13ZUxTM5m2n2iBZNH5Iw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-77f6cd3da10so78109385a.1
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 02:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702635472; x=1703240272;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42FJiFvltYp2rdiqySuaRIVVGIjwc6Ht5anz+ABGSo8=;
        b=OOoaaaAflr7FWIUR23JEswQN9qa8w3LLhRz9/bwFxn5Tm8HmCKy6aiiDjHOOFQpHLb
         479pL8oVYDo7EXiKcAiaXG3vhBsILRO1A7GpMt1KyE1iTFoFfovg0aAxNjHIa2M5uk4u
         hy1JuBv60fEmRadZJwQBIGMLk930gy4WyLsuyv4thaoOnRjycTBSBgzbyWwhCDAj/GFq
         0KoMvhfOuQbVfEC+eBlFm9HfjliazYGK6Z4KIqR9dmXWfvKk60Fi3V18m1TYKBMdroeb
         pfOkrR96+j7yL0knnfuakG1lSVUCEknDk+VlImHI9Em1piwVJ/wRw1mAJrrfgrBnwQlr
         I0ww==
X-Gm-Message-State: AOJu0Yw1joeVYiwKvzJg+zjxmoiB5T6dSrMH9kVYoB/XpaAMQ4Va4UN6
	WSjKUBtr5z7Y6KOw6ctW/UN30JTBPbXx4F69HR2b1L3h0ZzWewPIswhCS/1aprRdSo9mn2WysQ8
	IO1tK/q16q0nH
X-Received: by 2002:a05:620a:27cc:b0:77f:1382:e6ee with SMTP id i12-20020a05620a27cc00b0077f1382e6eemr13807785qkp.146.1702635472509;
        Fri, 15 Dec 2023 02:17:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtlgZ6Vf8A9Q7i4kEqb7UmwkpjoJSFeIhKzIWQgD4mRCU4qzjQHbQ3PMKqqff5KX8/dbxwgg==
X-Received: by 2002:a05:620a:27cc:b0:77f:1382:e6ee with SMTP id i12-20020a05620a27cc00b0077f1382e6eemr13807769qkp.146.1702635472240;
        Fri, 15 Dec 2023 02:17:52 -0800 (PST)
Received: from rh (p200300c93f174f005d25f1299b34cd9e.dip0.t-ipconnect.de. [2003:c9:3f17:4f00:5d25:f129:9b34:cd9e])
        by smtp.gmail.com with ESMTPSA id w5-20020a05620a148500b0077d65ef6ca9sm5910268qkj.136.2023.12.15.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 02:17:52 -0800 (PST)
Date: Fri, 15 Dec 2023 11:17:47 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eauger@redhat.com>
cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org, 
    Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, 
    qemu-devel@nongnu.org
Subject: Re: [PATCH v4] arm/kvm: Enable support for
 KVM_ARM_VCPU_PMU_V3_FILTER
In-Reply-To: <f1b6dffb-0a23-82d2-7699-67e12691e5c4@redhat.com>
Message-ID: <80bd3241-f3e2-f5ee-27b9-af5ad76144d4@redhat.com>
References: <20231207103648.2925112-1-shahuang@redhat.com> <be70b17c-21cf-4f4e-8ec1-62c18ffd4100@redhat.com> <f1b6dffb-0a23-82d2-7699-67e12691e5c4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 15 Dec 2023, Sebastian Ott wrote:
> On Thu, 14 Dec 2023, Eric Auger wrote:
>>  On 12/7/23 11:36, Shaoqin Huang wrote:
>>>  +    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, &attr)) {
>>>  +        warn_report("The kernel doesn't support the PMU Event
>>>  Filter!\n");
>>>  +        return;
>>>  +    }
>>>  +
>>>  +    /* The filter only needs to be initialized for 1 vcpu. */
>>  Are you sure? This is a per vcpu device ctrl. Where is it written in the
>>  doc that this shall not be called for each vcpu
>
> The interface is per vcpu but the filters are actually managed per vm
> (kvm->arch.pmu_filter). From (kernel) commit 6ee7fca2a ("KVM: arm64: Add 
> KVM_ARM_VCPU_PMU_V3_SET_PMU attribute"):
>  To ensure that KVM doesn't expose an asymmetric system to the guest, the
>  PMU set for one VCPU will be used by all other VCPUs. Once a VCPU has run,
>  the PMU cannot be changed in order to avoid changing the list of available
>  events for a VCPU, or to change the semantics of existing events.

I've managed to quote the wrong commit. It's that one:
d7eec2360e3 ("KVM: arm64: Add PMU event filtering infrastructure")
  Note that although the ioctl is per-vcpu, the map of allowed events is
  global to the VM (it can be setup from any vcpu until the vcpu PMU is
  initialized).

Sebastian


