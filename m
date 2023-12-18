Return-Path: <kvm+bounces-4730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592458174F3
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C71F3B233EF
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE423D54B;
	Mon, 18 Dec 2023 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ps263LX8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9063D54D
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 15:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-db4004a8aa9so2804863276.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702912409; x=1703517209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jiq5IR8T/AfEafFv3csuNV9k6ScXm1XW+J8Iu+gJQFE=;
        b=Ps263LX8Ne2/MG70AeVnYAT/4isfY32Ps3kDvNx/UtvLgbp79of8grPvEGao6S9tWO
         wNRUF42ldZGL04Kc298/a/vmPCuX0h7FtQWw7ZL9a1imEXr57AwhClEu/cHkzdm7K4Da
         DYEvSxHOaBFUHZv+yO0HcSt03nX+Xyj4iHdJAoXOxS2ruKWb10LeMJGVimAU5t5iKPGG
         K0i8VQiek67B/ME8GaJ6c+dvFzgEMuFk24QeRJlpE+hccUb26yquaebCJgw6pQZRHP/d
         EAgllzHuSpZryzOKmoMctVlwtr3JT2CPTpXbMbjqCYanLdHAyHpaTXBuV9P+kAS5gy18
         VS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702912409; x=1703517209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jiq5IR8T/AfEafFv3csuNV9k6ScXm1XW+J8Iu+gJQFE=;
        b=C6KgKOT7yvwcRNjNlbZ0pi142fXaP9DQfRKEJ4VkCW1PPrid+sWEKaXpKcseZPSa61
         FFBNP9mFSX/oGaPwNL/L8A5uHOoQzOSP59scHtoncIWrw9waUL1j6Wgf09E26YGHxLvO
         X3xg3Szzcp8q+LObeY4vkDlIhEmDftBSYtCUWjCUTm3cmeZhZAHyfnhnZTHH8AVWM1iq
         3dGCeT5i8yUY8Linh62VUWfcgS++J+WPiKuefy48qhtecJSqiSDewem8314NNE68J+Yu
         KLhDXsUCP2LIkwVsK64vaxEGOqzwCZLKNjP1iGfmdS21AAgeoROuBxIkr8SlF/3/K6j2
         gZaQ==
X-Gm-Message-State: AOJu0YyaaD+x7K/M8CAEfVStCw6+rgUENj5l1ZPwZFgkeF6D7t0yCun7
	NNqM8vWtHU4DOXXbkpdLgKutKRM5tz4=
X-Google-Smtp-Source: AGHT+IGCOkvHHzTHdD5+iMnXOhMY1iR+vBZFoezlqCiNsFkaeKkzXB7YWAEnqcbv+gk3IMv9I/mqf1R88zU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:787:0:b0:d9a:efcc:42af with SMTP id
 b7-20020a5b0787000000b00d9aefcc42afmr278486ybq.2.1702912409108; Mon, 18 Dec
 2023 07:13:29 -0800 (PST)
Date: Mon, 18 Dec 2023 07:13:27 -0800
In-Reply-To: <20231218140543.870234-2-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com> <20231218140543.870234-2-tao1.su@linux.intel.com>
Message-ID: <ZYBhl200jZpWDqpU@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com, 
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Tao Su wrote:
> When host doesn't support 5-level EPT, bits 51:48 of the guest physical
> address must all be zero, otherwise an EPT violation always occurs and
> current handler can't resolve this if the gpa is in RAM region. Hence,
> instruction will keep being executed repeatedly, which causes infinite
> EPT violation.
> 
> Six KVM selftests are timeout due to this issue:
>     kvm:access_tracking_perf_test
>     kvm:demand_paging_test
>     kvm:dirty_log_test
>     kvm:dirty_log_perf_test
>     kvm:kvm_page_table_test
>     kvm:memslot_modification_stress_test
> 
> The above selftests add a RAM region close to max_gfn, if host has 52
> physical bits but doesn't support 5-level EPT, these will trigger infinite
> EPT violation when access the RAM region.
> 
> Since current Intel CPUID doesn't report max guest physical bits like AMD,
> introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when tdp is
> enabled and report the max guest physical bits which is smaller than host.
> 
> When guest physical bits is smaller than host, some GPA are illegal from
> guest's perspective, but are still legal from hardware's perspective,
> which should be trapped to inject #PF. Current KVM already has a parameter
> allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
> host.MAXPHYADDR, which is disabled by default when EPT is enabled, user
> can enable it when loading kvm-intel module. When allow_smaller_maxphyaddr
> is enabled and guest accesses an illegal address from guest's perspective,
> KVM will utilize EPT violation and emulate the instruction to inject #PF
> and determine #PF error code.

No, fix the selftests, it's not KVM's responsibility to advertise the correct
guest.MAXPHYADDR.

