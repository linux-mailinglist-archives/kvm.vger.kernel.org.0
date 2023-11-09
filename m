Return-Path: <kvm+bounces-1351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC7C7E6D4C
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:23:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC312810BC
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 15:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DD220318;
	Thu,  9 Nov 2023 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GgQtopqG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA7112B99
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:23:09 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C049530EB
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:23:08 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5af9b0850fdso13646767b3.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 07:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699543388; x=1700148188; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kigI6ClI5egwqqPJrt8+IeHIdPDCUrXTRQpt6o3p25c=;
        b=GgQtopqGyNnoJUxGoqLTpXHh3YJf0lYuQxp7mtAp7ewXWYpRa9r44HWdSyaudVaf9j
         DkeKPgudRWU6SbEshZOLgaQ2FeTRjP2WCrnZaWX5rokTbFf+4Zy5o6hHqobYS5hfhBTu
         dm64nZeo8lY3ceBejTD6mTkfUQqiwnJl1zxnSqFCHOIUYQs0ijjq1pauTlK+KceuEeHP
         1m6HqJFY1/pARHn87eXGJysI/WUPElqMbiLP4LQcvs7dQDn9ocD8xt8qUvGVBomPg9fg
         aCfELCr9UesRRKnYmNsdlp8mRUO1Ay7uM36X6ESFts2a+6RbpLi6GyS/WQH+pMoQtDhm
         tHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699543388; x=1700148188;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kigI6ClI5egwqqPJrt8+IeHIdPDCUrXTRQpt6o3p25c=;
        b=SMHeScfSF055rjigzhca5zHcvUVn7+2OrA/onpXueHhN6KpvjbugsJjC16qlTjLCYq
         OhonStKhAh75GyY8xAx5HTqMJph29/vJKecHO0vV/RAfvyqB+ey+cgufeinCL2SQrLBh
         TbyD2mEHuuYO4nzXlTKynUrLanFGT70pyaJ1d38NmSq3u+IM1A7t/gjZrVDS/enoR7Cl
         kPMmk2yPTniKuhTXt9XQPOdg9uRTUKUIAHSuCRGcPVESqAAu4qzgzWgMuLSldQWRMtHy
         7iBqPgXq5ASfewU4legXQSSh+6EPFEY5itLyv3M0e4zxDkZ2Sa1goenbUkasEdOfoV43
         kuTw==
X-Gm-Message-State: AOJu0YyuqoRj9zgWVzVJWZyAqsc8RLfXlsv8UBXCbu9dVJkxogp7x434
	1jGCxg6Mji1FvE5bFHXtzswDJgDUq7k=
X-Google-Smtp-Source: AGHT+IFXnzP17PCTQd37aYqPCT1uLviAELrNiOsHNVjcYyLHD22AsT92khPvu9YBl9QRnes7DTAeBrp7upE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e95:0:b0:57a:118a:f31 with SMTP id
 c143-20020a814e95000000b0057a118a0f31mr149451ywb.7.1699543388029; Thu, 09 Nov
 2023 07:23:08 -0800 (PST)
Date: Thu, 9 Nov 2023 07:23:06 -0800
In-Reply-To: <20231108003135.546002-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-11-seanjc@google.com>
Message-ID: <ZUz5WrxGf4blspae@google.com>
Subject: Re: [PATCH v7 10/19] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 07, 2023, Sean Christopherson wrote:
> @@ -199,6 +219,22 @@ static void guest_test_arch_event(uint8_t idx)
>  		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
>  					MSR_P6_EVNTSEL0 + i, eventsel);
>  	}
> +
> +	if (!guest_has_perf_global_ctrl)
> +		return;
> +
> +	fixed_event = intel_event_to_feature[idx].fixed_event;
> +	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
> +		return;
> +
> +	i = fixed_event.f.bit;
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
> +
> +	__guest_test_arch_event(idx, fixed_event, FIXED_PMC_RDPMC_BASE + i,

Grr, this should be an OR, not a SUM, i.e. "FIXED_PMC_RDPMC_BASE | i".  That's
how Like/Jinrong originally had things, but I got confused by the BASE terminology
and "fixed" it.  The end result is the name, but the PMU code is hard enough to
follow as it is.

I'm also going to rename FIXED_PMC_RDPMC_BASE, that is a terrible name that got
copy+pasted from perf.  It's not a base value, it's a single flag that says "read
fixed counters".

