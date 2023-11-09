Return-Path: <kvm+bounces-1350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC867E6D2C
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04141B20FDE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 15:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D840A200DC;
	Thu,  9 Nov 2023 15:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvAIUcMh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D0E200B9
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:19:29 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F565358E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:19:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-daee86e2d70so903019276.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 07:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699543168; x=1700147968; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2QjzZFTKwtqihTElGETV0lGXwGv/SmVMdX4dMdC65J4=;
        b=dvAIUcMhHIaGvWt0rsUlMOCZdIIDxtBfsRkNzduYREEXP992FRywvpr8nYvea3II6l
         gio3WiRugyAgFOFF0VEWYa6Pe/+K/ORKHVdlxKIzSYdf98m6Oej+RhWYkmUnO1YXh7Us
         Y6T9MxT7K/5k6eJ7hVYRFYlmRZ+Yq7Udfmu3S43oexF6xdg/8MytxkLUnM5ZucmrePRH
         BtTTAajC/zVrsHorXwWYvDUWqRO5E81JLqN8PeWu1rRbrdHv+NpLjnFj4329wM0yKcvN
         avtTnje+dCwrTeDrISJTlen9MFTG3ylIuMBuz9u6k0/Z7FUdtCkRNFYj3AricjnmA64b
         qkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699543168; x=1700147968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2QjzZFTKwtqihTElGETV0lGXwGv/SmVMdX4dMdC65J4=;
        b=H3t+ez1NW8AiOTsUdYwuN6ArhAeq/6qcpDeNic0Jhn4jpZ3OfIw7M79eRyIflVTKwg
         n66vNtF9IC1vNmdanukA2XAyoD+qrMtiHyPrPKOQk6aSKogxUKD7f+XQ5//EGoP+Cu84
         Xbmh0AlbK3rYp73Ib8nEOwm7cYQoRNOdn3hAM5ZN+AJIE0bfs2seVWN3W/ixrVa/TZ4H
         9RrBF3NbWpik6Yxi5Kw4BzLlz9tpq02a84B3itYf4Hh5ls4C6E5U26i92KV5exa2Dlol
         EoN45sW5clilf6njQsG2j/8qMOlYH/9Rva+of/33/C3MjdQBQrc7vwas0hOJea7Gljib
         ObQg==
X-Gm-Message-State: AOJu0YzJz8iCTVIJuopd+C0/4FsQuoE27tWJ++AqsPURhVMLKuRzMp1C
	5Im91jwEbV9m5+nzL9c9EETyjTBlp4Q=
X-Google-Smtp-Source: AGHT+IFh+izpVorNeAJ+xXhgLFVgmpeiu54AerfQ3mePVz8cGOCzFvnLT3CiLUQbuUHCrqtWmx0At58umfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2fd2:0:b0:d7e:7a8a:2159 with SMTP id
 v201-20020a252fd2000000b00d7e7a8a2159mr125775ybv.5.1699543167922; Thu, 09 Nov
 2023 07:19:27 -0800 (PST)
Date: Thu, 9 Nov 2023 07:19:26 -0800
In-Reply-To: <fa25f3eb-eb9a-4d83-8fdf-f133c60484da@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-13-seanjc@google.com>
 <fa25f3eb-eb9a-4d83-8fdf-f133c60484da@linux.intel.com>
Message-ID: <ZUz4ftgXQnOL_sHJ@google.com>
Subject: Re: [PATCH v7 12/19] KVM: selftests: Test consistency of CPUID with
 num of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Dapeng Mi wrote:
> 
> On 11/8/2023 8:31 AM, Sean Christopherson wrote:
> > From: Jinrong Liang <cloudliang@tencent.com>
> > 
> > Extend the PMU counters test to verify KVM emulation of fixed counters in
> > addition to general purpose counters.  Fixed counters add an extra wrinkle
> > in the form of an extra supported bitmask.  Thus quoth the SDM:
> > 
> >    fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)
> > 
> > Test that KVM handles a counter being available through either method.
> > 
> > Co-developed-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 ++++++++++++++++++-
> >   1 file changed, 57 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > index 6f2d3a64a118..8c934e261f2d 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > @@ -285,13 +285,19 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
> >   	       expect_gp ? "#GP" : "no fault", msr, vector)			\
> >   static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
> > -				 uint8_t nr_counters)
> > +				 uint8_t nr_counters, uint32_t or_mask)
> 
> 
> 'or_mask' doesn't show a clear meaning, "counters_bitmap" may be a better
> name.

I don't love "or_mask" either, but I like "counters_bitmap" far less, as it doesn't
provide any hint as to the polarity or behavior.  Readers that aren't familiar with
the kludgy enumeration of PMCs in CPUID won't already know that it's a mask that's
OR-d in, e.g. counters_bitmap could be a replacement, it could be an AND-mask, it
could be something entirely unrelated.  I opted for a name that describe the behavior
because I don't see a way to succintly capture the (IMO) weird enumeration.

