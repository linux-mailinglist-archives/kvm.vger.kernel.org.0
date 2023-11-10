Return-Path: <kvm+bounces-1448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB877E77C6
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BCCCB21088
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CC515B3;
	Fri, 10 Nov 2023 02:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6O8i49T"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE47EB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:52:11 +0000 (UTC)
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FA52D64;
	Thu,  9 Nov 2023 18:52:11 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1cc9b626a96so13155015ad.2;
        Thu, 09 Nov 2023 18:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699584731; x=1700189531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McT5MARLcUfJTGIDkAnx307QFnzMb994razTYXqedEA=;
        b=a6O8i49TKIdn8Ik/FriyfSui7GBAoZQ90o1rI+R3g5+5069tQVk9UozrcIf4IJBQ7H
         ppn3an3MKO8jrHHYo0lndsKyRLITRFqDyusN5t6RHKdgypes2bW6mdJyjTu8EHfjHzHG
         x0miT+VekGBGMLmM1KcTmIOlTep0dF7cJ57MYyz/H7eqO1KkAIXxyhb63ym9vKpfC56U
         d8LClqzE5p4+f3ZX3R40bQEh8Qu9AGfymiI7n65lCSiqesvSL/ujlHDI57mD4Mlwc2Oh
         9tns0FvusVTlHOGD5gOvYESMY0XaFOseBUJlKs/JA8OwcjKKNq7vEBFqVpMgMvejuTXE
         OhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699584731; x=1700189531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=McT5MARLcUfJTGIDkAnx307QFnzMb994razTYXqedEA=;
        b=M07Db0SkEZGKvfoMEwM+ykZ+udL9LFoYnB3Cct5THrI5DI6hVLXyauGzOcYVrnC026
         HXd/93rHcv9BHPnTC9T8lVBEWNWTrXg00zeDiaMTgnkyQYl5QujGqn3XDDoH0iCgW/wj
         DjsokIDyHIlhvRulRSPyrvbOAD2TqwDLgzxiMvOVprTS2xM+1uy1JswfVN3o5CtZld2Z
         AUt/YCqYmGp/ktJHQQhsr+v8BunJ2a/85BS9RlpdQd2Rxa0iala1cRE6SnsjQdDpeb/T
         42SZnKqtgprNFx3fVaTl3HLCKUjLaAfP36joVPRxbcv0Hoo2BXYD/aa3mFa99iuF5pQV
         24Qw==
X-Gm-Message-State: AOJu0Yz8YZ0rjij6WGplbHnG3+krBdjYn4LUtL66h8va83S1yQrxHyqM
	3yZAuyayPiSilmSCwzSXje8=
X-Google-Smtp-Source: AGHT+IHMYN2ug885QMW0coGWX3rSUklCD/0HrKYb5OibqsywQRjREhgKyD+fuQK28pn0mpk8ryzOcw==
X-Received: by 2002:a17:903:2341:b0:1cc:449b:41e3 with SMTP id c1-20020a170903234100b001cc449b41e3mr7154489plh.59.1699584730846;
        Thu, 09 Nov 2023 18:52:10 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902b58d00b001bf6ea340b3sm4202241pls.116.2023.11.09.18.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 18:52:10 -0800 (PST)
Message-ID: <23b71d3f-af12-5ec0-e23c-40b478d2ae9b@gmail.com>
Date: Fri, 10 Nov 2023 10:52:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v8 00/26] KVM: x86/pmu: selftests: Fixes and new tests
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi
 <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>,
 Jinrong Liang <cloudliang@tencent.com>, Jinrong Liang <ljr.kernel@gmail.com>
References: <20231110021306.1269082-1-seanjc@google.com>
From: Jinrong Liang <ljr.kernel@gmail.com>
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2023/11/10 10:12, Sean Christopherson 写道:
> Another round, another new pile of fixes and tests.  My apologies for
> sending so many versions of this thing, I thought v7 was going to be the
> last one.  *sigh*
> 
> Fix bugs where KVM incorrectly refuses to virtualize fixed counters and
> events whose encodings match unsupported arch events, and add a PMU
> counters selftest to verify the behavior.
> 
> As an aside, my hope is that in the long term, we can build out the PMU
> selftests and deprecate the PMU tests in KUT so that we have everything
> in-kernel and in one spot.

I am currently working on enhancing the PMU selftests to achieve this goal.

> 
> v8:
>   - Collect reviews. [Jim, Dapeng, Kan]
>   - Tweak names for the RDPMC flags in the selftests #defines.
>   - Get the event selectors used to virtualize fixed straight from perf
>     instead of hardcoding the (wrong) selectors in KVM. [Kan]
>   - Rename an "eventsel" field to "event" for a patch that gets blasted
>     away in the end anyways. [Jim]
>   - Add patches to fix RDPMC emulation and to test the behavior on Intel.
>     I spot tested on AMD and spent ~30 minutes trying to squeeze in the
>     bare minimum AMD support, but the PMU implementations between Intel
>     and AMD are juuuust different enough to make adding AMD support non-
>     trivial, and this series is already way too big.

I'm working on selftests for AMD PMU counters. Can I post a separate 
AMD PMU counters selftests patchset after this patchset is merged?

Thanks，

Jinrong

>   
> v7:
>   - https://lore.kernel.org/all/20231108003135.546002-1-seanjc@google.com
>   - Drop patches that unnecessarily sanitized supported CPUID. [Jim]
>   - Purge the array of architectural event encodings. [Jim, Dapeng]
>   - Clean up pmu.h to remove useless macros, and make it easier to use the
>     new macros. [Jim]
>   - Port more of pmu_event_filter_test.c to pmu.h macros. [Jim, Jinrong]
>   - Clean up test comments and error messages. [Jim]
>   - Sanity check the value provided to vcpu_set_cpuid_property(). [Jim]
> 
> v6:
>   - https://lore.kernel.org/all/20231104000239.367005-1-seanjc@google.com
>   - Test LLC references/misses with CFLUSH{OPT}. [Jim]
>   - Make the tests play nice without PERF_CAPABILITIES. [Mingwei]
>   - Don't squash eventsels that happen to match an unsupported arch event. [Kan]
>   - Test PMC counters with forced emulation (don't ask how long it took me to
>     figure out how to read integer module params).
> 
> v5: https://lore.kernel.org/all/20231024002633.2540714-1-seanjc@google.com
> v4: https://lore.kernel.org/all/20230911114347.85882-1-cloudliang@tencent.com
> v3: https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com
> 
> Jinrong Liang (7):
>    KVM: selftests: Add vcpu_set_cpuid_property() to set properties
>    KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
>    KVM: selftests: Test Intel PMU architectural events on gp counters
>    KVM: selftests: Test Intel PMU architectural events on fixed counters
>    KVM: selftests: Test consistency of CPUID with num of gp counters
>    KVM: selftests: Test consistency of CPUID with num of fixed counters
>    KVM: selftests: Add functional test for Intel's fixed PMU counters
> 
> Sean Christopherson (19):
>    KVM: x86/pmu: Always treat Fixed counters as available when supported
>    KVM: x86/pmu: Allow programming events that match unsupported arch
>      events
>    KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
>      encodings
>    KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
>    KVM: x86/pmu: Get eventsel for fixed counters from perf
>    KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
>    KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
>    KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
>    KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
>    KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
>    KVM: selftests: Expand PMU counters test to verify LLC events
>    KVM: selftests: Add a helper to query if the PMU module param is
>      enabled
>    KVM: selftests: Add helpers to read integer module params
>    KVM: selftests: Query module param to detect FEP in MSR filtering test
>    KVM: selftests: Move KVM_FEP macro into common library header
>    KVM: selftests: Test PMC virtualization with forced emulation
>    KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
>    KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and
>      XGETBV
>    KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR
> 
>   arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 -
>   arch/x86/kvm/pmu.c                            |   4 +-
>   arch/x86/kvm/pmu.h                            |   1 -
>   arch/x86/kvm/svm/pmu.c                        |  10 +-
>   arch/x86/kvm/vmx/pmu_intel.c                  | 133 ++--
>   tools/testing/selftests/kvm/Makefile          |   2 +
>   .../selftests/kvm/include/kvm_util_base.h     |   4 +
>   tools/testing/selftests/kvm/include/pmu.h     |  97 +++
>   .../selftests/kvm/include/x86_64/processor.h  | 148 ++++-
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
>   tools/testing/selftests/kvm/lib/pmu.c         |  31 +
>   .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 607 ++++++++++++++++++
>   .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++---
>   .../smaller_maxphyaddr_emulation_test.c       |   2 +-
>   .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
>   17 files changed, 1035 insertions(+), 256 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/pmu.h
>   create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> 
> 
> base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
> 


