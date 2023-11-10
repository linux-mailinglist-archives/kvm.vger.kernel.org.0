Return-Path: <kvm+bounces-1488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E4C7E7D2B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 15:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E5A52812D1
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B1A1C2BB;
	Fri, 10 Nov 2023 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0RhG0Qz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F400B1BDCA
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 14:51:22 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F375739CE6
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:51:21 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5bc3be6a91bso23602257b3.1
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699627881; x=1700232681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0mloYI4ZoLlQinekJcU/lurgLOSGND62aO9fKE274N0=;
        b=A0RhG0QzUR2cP7qmBFogt1s+A3mu+i+sr05ow5cRIJGSQOzcKQ8DFkKZBMKLFrYmO/
         KRPQj8GslF9joEmC8E+Fvq+IXAK3qZxlIytoa/In0dxtTQ25zhPDIkCy9fAuTVjSHy9F
         ZwWdtPPdR8wfzJwXxfqr7Nh7mHguvRtlbl1745I30oloZTMj3y392Dqy1euN2F1wjCnm
         VCAbuqtRI09rD10x3jdjN/YJQwkjXJZkQnvNc+CfXzk1pHa7W9pcQHpccJo+xmoS2iAd
         d0u7CReIoZAl2BpgZaj6PSpDtq3Be2nksYXXB1vxV+HESvM7rHHVD9kRKuzejF5QFEyu
         iLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699627881; x=1700232681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mloYI4ZoLlQinekJcU/lurgLOSGND62aO9fKE274N0=;
        b=R+C0Xykio20nOaol6Z8a4qOM/QW74WLx9qvNix9NmRGrOYbjCkG7Lyl/97/Lc+KPaa
         lZ+S74sK2o/lxiFT8rlXBgxG2ThWEt2zAKaTqcS9P7VAD94cj1mhzns4m8TKjJQarHn6
         Z7JkBMYavgxeEWpSe18aAHQiPglA88rB5bX6f0/EEShf+gm25SOlTYVpojeqZX2iZ2HN
         0h7kKVtkAlR10J/W7kqpfKT0lRgizvXggk/Kt3ohTiIHGbkGUu4l2/QjMe2Cg2pdNNmE
         CMRWvBKHzQpe9fTSSMALPP2pTfzZbUqmVypC112SElMOYie8U6+hJl/4kJnLduonpOsB
         Hxzg==
X-Gm-Message-State: AOJu0Yz1HpZGP3OIEx3WQaF5UioKB5vnDHac9H07UN82l7sDT0evCLe3
	dALVgz9VTOetCzD/C8jLqSRtD1sBQow=
X-Google-Smtp-Source: AGHT+IH3/OeuatOzR2sFBSWymG2OgAYclU8eTE9kiFo/7nRT84eGi909cRo3wqw1PhQmUAKhID8qy0DK6Ig=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:384:b0:da0:37e1:558e with SMTP id
 f4-20020a056902038400b00da037e1558emr91865ybs.6.1699627881224; Fri, 10 Nov
 2023 06:51:21 -0800 (PST)
Date: Fri, 10 Nov 2023 06:51:19 -0800
In-Reply-To: <5d0c1946-0b22-4983-868b-db7f79fe16bc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com> <20231110021306.1269082-8-seanjc@google.com>
 <5d0c1946-0b22-4983-868b-db7f79fe16bc@linux.intel.com>
Message-ID: <ZU5DZ110JPvcmZp0@google.com>
Subject: Re: [PATCH v8 07/26] KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Dapeng Mi wrote:
> 
> On 11/10/2023 10:12 AM, Sean Christopherson wrote:
> > Move the handling of "fast" RDPMC instructions, which drop bits 63:31 of
> 
> 63:32?

Oof, yeah.

> > @@ -55,12 +59,17 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
> >   	}
> >   }
> > +static u32 intel_rdpmc_get_masked_idx(struct kvm_pmu *pmu, u32 idx)
> 
> inline?

No, for functions that are visible only to the local compilation unit, there's
no reason to use "inline".  "inline" is just a hint, and modern compilers are
smart enough to inline functions when appropriate without a hint, e.g. gcc and
clang inline this on all my configurations.  Compilers may also ignore the hint,
e.g. KASAN=y tends to produce some really amusing results.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

