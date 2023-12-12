Return-Path: <kvm+bounces-4187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9989E80EFE2
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43EB61F21600
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EDA75423;
	Tue, 12 Dec 2023 15:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJbaZsgl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793BCD3
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:17:19 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5e03f0ede64so29312257b3.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702394238; x=1702999038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJWKmgvktPUx3ODhsCg6ktCXUdvD/lpvE/GKvFcTj0w=;
        b=QJbaZsglObkPclBHfBx4dJ76/n4Cf7fGbmBGD4S1D9gg5MTyMwdeaTOxBxHoFj+E6w
         fDPglQ/itB/5A2OOG2OkIVNel4vsqjuwqAAlENXywd0PZuddlcxlM6/mycj2231fpNkI
         QW/V4qPWOxCaO7Oyk5syZ+NPxOQTXfo0k39qBUGonivknI9Wy8A2O8xc2Mxf2Zm0ledC
         pzu25e/Nhu/KfY0J3rdg67L+sEVoPW5MzRKT8Xgk2FPbJjImELWoqwhgMeLd1TeU02EG
         N5I1tmmDmhaRjQxaJXZThEg9hXmFKivtvYqof1eJ/hdCEc3u7xMi0ZEQfUnUZ8lSlqUW
         lEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702394238; x=1702999038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JJWKmgvktPUx3ODhsCg6ktCXUdvD/lpvE/GKvFcTj0w=;
        b=WCeuSmS+nqoz4v2wc/pEcL2WV6A8BxX47NBENd/5+Y4G7hsJi5mCZUTLFxB07Iq0Fv
         URSF1/NffkKg+1HjknGZvS0wS1yzAkw4vekIlm22tTLjx3t3r9/b6sbukCA+j6jr0Nqp
         th2A2yoXcQjgYLniG3kTtlX64LnWwkfvt4CkwD7f/EE6IStZWEU39wE6R5Xc+zo23cPl
         z1cEpgGGW3UbB5GTHuTaKEFOZXLmUdlZelG2j7YekDHAIV8eook+BcBR/AUYsBXkgxad
         CbIiZHtS3gffM7Wv+J4DXItToR+b4Y1z/zRsb6id24t4CjZuUp2DUs4Ka9Vq4NnXWaS+
         b8tg==
X-Gm-Message-State: AOJu0YyQeSwQzVABVoG90ikrJeFY1bCTj2JQ4uC6L71Kr5lNwDCB/iNj
	GrOS7Yn1kpvyRKIlTDIMMm2aRJgZ/8w=
X-Google-Smtp-Source: AGHT+IFH9FowbiJTu0FOYEXqU8FXSIbNhjIKxTxw4pWsLMcJ7/A+9cxTxfpCXBR+cjiFfeVtpNLn6zwBS4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f03:b0:5d3:cca8:1d59 with SMTP id
 dc3-20020a05690c0f0300b005d3cca81d59mr66693ywb.5.1702394238203; Tue, 12 Dec
 2023 07:17:18 -0800 (PST)
Date: Tue, 12 Dec 2023 07:17:16 -0800
In-Reply-To: <20231212062708.16509-1-dan1.wu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212062708.16509-1-dan1.wu@intel.com>
Message-ID: <ZXh5fJonSWLcHmkN@google.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86: fix async page fault issues
From: Sean Christopherson <seanjc@google.com>
To: Dan Wu <dan1.wu@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 12, 2023, Dan Wu wrote:
> When running asyncpf test, it gets skipped without a clear reason:
> 
>     ./asyncpf
> 
>     enabling apic
>     smp: waiting for 0 APs
>     paging enabled
>     cr0 = 80010011
>     cr3 = 107f000
>     cr4 = 20
>     install handler
>     enable async pf
>     alloc memory
>     start loop
>     end loop
>     start loop
>     end loop
>     SUMMARY: 0 tests
>     SKIP asyncpf (0 tests)
> 
> The reason is that KVM changed to use interrupt-based 'page-ready' notification
> and abandoned #PF-based 'page-ready' notification mechanism. Interrupt-based
> 'page-ready' notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well
> in MSR_KVM_ASYNC_PF_EN to enable asyncpf.
> 
> This series tries to fix the problem by separating two testcases for different mechanisms.
> 
> - For old #PF-based notification, changes current asyncpf.c to add CPUID check
>   at the beginning. It checks (KVM_FEATURE_ASYNC_PF && !KVM_FEATURE_ASYNC_PF_INT),
>   otherwise it gets skipped.
> 
> - For new interrupt-based notification, add a new test, asyncpf-int.c, to check
>   (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement interrupt-based
>   'page-ready' handler.

Using #PF to deliver page-ready is completely dead, no?  Unless I'm mistaken, let's
just drop the existing support and replace it with the interrupted-based mechanism.
I see no reason to continue maintaining the old crud.  If someone wants to verify
an old, broken KVM, then they can use the old version of KUT.

