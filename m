Return-Path: <kvm+bounces-34-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6EE7DB25F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 04:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8093B20DCC
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 03:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B1B111A;
	Mon, 30 Oct 2023 03:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcatbkYR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0035EC7
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 03:57:12 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1659B
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 20:57:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6b6f4c118b7so3569299b3a.0
        for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 20:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698638230; x=1699243030; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ne8SXDkcXFFwq2DJL9gmjTYE7QsrFEkJZWdUaILBAC8=;
        b=KcatbkYRjGOlJI8A23ZSXDpfHjnify9p0cGIhDRkcJnH8H8mWlZEQ3gWX2W9Zge0fW
         ftTDqLRvKqgk10Jtpqpn7loOKuX7pDDiEnHxRCbLs2sNnRVMaPlAvJ9cmNVEpw+SUjzG
         PBxaNr79D2Cl6EH7O8cexZCW37Skg3YE6Lc/5dDA+Ko+V6SLCcDzb866NeEel6YUUT23
         BdnBfiZHcPFi9P7Un5bPEHQAnK0sWGZyttyxrGhHyN7jJgMiZZfwfEL4MdVfo7nHrXUR
         NBkGjRpry9di8qMRABgJcG+Me+tZm0YdrkDwKtAP7OSss9jTSJ3DcUKptMpjZF3CPh7u
         mcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698638230; x=1699243030;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ne8SXDkcXFFwq2DJL9gmjTYE7QsrFEkJZWdUaILBAC8=;
        b=xL8fJzE0Q8V/Es8uz8RHIPlx57INTdpaASGIZSLEpXCm9OEFri1NmDNawYuWnotJ+C
         f5VUBCJsqXIXH2Hz6vzPiRmWRw4ay12wnWk+0J07z9C0w6+VmiPpkRofKkPYuCyf1Ja1
         P9jHZFjtV7Sj8Y5/+HQ9ipgq146ChDQ17sZvCZVWsnWoOFQMGd/w+WGtnj0NL4GMknWR
         /Q+FgkugKeANfAKKGGYbDiwsKgcesdapEsEsPouhlQ7R/Yg1ddKPFX5DB+ZwJ/IxLCrK
         UJPFzeob61gDW2J+iDj2iFVdIc5rG7x996U/hyEZlxfI51mN2LGlZ0Hevq2WQkPwVvbL
         conA==
X-Gm-Message-State: AOJu0Yz4FVh2NM+D8NSa2o//vVh3J3H1+UzvtunOoQ3iGBMWetBDUEbX
	rQkbqeADxnAanU8+HGsCqhptXA==
X-Google-Smtp-Source: AGHT+IFoAgdtfAghj821g9kM1YgGoDdEC6gChDxr4PITFJqr111aBbTmgAn9BDyGIaR80cEFIm61RQ==
X-Received: by 2002:a05:6a00:218d:b0:6b3:55fd:d851 with SMTP id h13-20020a056a00218d00b006b355fdd851mr7660252pfi.10.1698638229341;
        Sun, 29 Oct 2023 20:57:09 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0010c500b006bfb903599esm4913052pfu.139.2023.10.29.20.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 20:57:08 -0700 (PDT)
Date: Mon, 30 Oct 2023 03:57:04 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch 0/5] Fix PMU test failures on Sapphire
 Rapids
Message-ID: <ZT8pkA28Q8zzDMrp@google.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <ZTmo9IVM2Tq6ZSrn@google.com>
 <719318df-dc19-4f4c-88ff-5c69377f713c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <719318df-dc19-4f4c-88ff-5c69377f713c@linux.intel.com>

On Thu, Oct 26, 2023, Mi, Dapeng wrote:
> On 10/26/2023 7:47 AM, Mingwei Zhang wrote:
> > On Tue, Oct 24, 2023, Dapeng Mi wrote:
> > > When running pmu test on Intel Sapphire Rapids, we found several
> > > failures are encountered, such as "llc misses" failure, "all counters"
> > > failure and "fixed counter 3" failure.
> > hmm, I have tested your series on a SPR machine. It looks like, all "llc
> > misses" already pass on my side. "all counters" always fail with/without
> > your patches. "fixed counter 3" never exists... I have "fixed
> > cntr-{0,1,2}" and "fixed-{0,1,2}"
> 
> 1. "LLC misses" failure
> 
> Yeah, the "LLC misses" failure is not always seen. I can see the "LLC 
> misses" 2 ~3 times out of 10 runs of PMU standalone test and you could see
> the failure with higher possibility if you run the full kvm-unit-tests. I
> think whether you can see the "LLC misses" failure it really depends on
> current cache status on your system, how much cache memory are consumed by
> other programs. If there are lots of free cache lines on system when running
> the pmu test, you may have higher possibility to see the LLC misses failures
> just like what I see below.
> 
> PASS: Intel: llc references-7
> *FAIL*: Intel: llc misses-0
> PASS: Intel: llc misses-1
> PASS: Intel: llc misses-2
> 
> 2. "all counters" failure
> 
> Actually the "all counters" failure are not always seen, but it doesn't mean
> current code is correct. In current code, the length of "cnt[10]" array in
> check_counters_many() is defined as 10, but there are at least 11 counters
> supported (8 GP counters + 3 fixed counters) on SPR even though fixed
> counter 3 is not supported in current upstream code. Obviously there would
> be out of range memory access in check_counters_many().
> 

ok, I will double check on these. Thanks.

> > 
> > You may want to double check the requirements of your series. Not just
> > under your setting without explainning those setting in detail.
> > 
> > Maybe what I am missing is your topdown series? So, before your topdown
> > series checked in. I don't see value in this series.
> 
> 3. "fixed counter 3" failure
> 
> Yeah, I just realized I used the kernel which includes the vtopdown
> supporting patches after Jim's reminding. As the reply for Jim's comments
> says, the patches for support slots event are still valuable for current
> emulation framework and I would split them from the original vtopdown
> patchset and resend them as an independent patchset. Anyway, even though
> there is not slots event support in Kernel, it only impacts the patch 4/5,
> other patches are still valuable.
> 
> 
> > 
> > Thanks.
> > -Mingwei
> > > Intel Sapphire Rapids introduces new fixed counter 3, total PMU counters
> > > including GP and fixed counters increase to 12 and also optimizes cache
> > > subsystem. All these changes make the original assumptions in pmu test
> > > unavailable any more on Sapphire Rapids. Patches 2-4 fixes these
> > > failures, patch 0 remove the duplicate code and patch 5 adds assert to
> > > ensure predefine fixed events are matched with HW fixed counters.
> > > 
> > > Dapeng Mi (4):
> > >    x86: pmu: Change the minimum value of llc_misses event to 0
> > >    x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
> > >    x86: pmu: Support validation for Intel PMU fixed counter 3
> > >    x86: pmu: Add asserts to warn inconsistent fixed events and counters
> > > 
> > > Xiong Zhang (1):
> > >    x86: pmu: Remove duplicate code in pmu_init()
> > > 
> > >   lib/x86/pmu.c |  5 -----
> > >   x86/pmu.c     | 17 ++++++++++++-----
> > >   2 files changed, 12 insertions(+), 10 deletions(-)
> > > 
> > > 
> > > base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
> > > -- 
> > > 2.34.1
> > > 

