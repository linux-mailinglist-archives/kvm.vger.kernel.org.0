Return-Path: <kvm+bounces-778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B32B7E28B9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 558DA28131B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A5728E0F;
	Mon,  6 Nov 2023 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VS2mrP9J"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF128E08
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:31:21 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F94112
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:31:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc5ef7e815so30579595ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 07:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699284680; x=1699889480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W4pgWCBKNlAdji/TNyedAYk8usKNcfQXaSq+BvgKk6s=;
        b=VS2mrP9JMObCyBc3U1bEWv/lJ3A/ztpYHfW2X8kYcyH8DlefIF2Q68JIoPHsE1HWZj
         XzIetZ3Uj9A9aIk7gTGVUofPTSKOYlXfhZj2V7f1yb2bSWgRhrkSv+j/fK7AyzBH+6nP
         htCiW4OTQTAoxnoq7XGc3bNae+4kwFWvOXgAfteefJCKcAqkGMK+yH8i0tN5kHCpH+p4
         iilEXbElOIQOoAUbiEhzSLs4nKdK0ICIORxhIh+R2lUVmD5tAi7vQMcsRvKQt3QgHI2h
         H+/8i8PQ8gp9nGbXs8hZCTU8ZWVs0+7S4y6vKRNKP1vTxRQPKYSRqXXWiw/o7RvS+exH
         9PTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284680; x=1699889480;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W4pgWCBKNlAdji/TNyedAYk8usKNcfQXaSq+BvgKk6s=;
        b=kSmcRcY5BAoXKids33KSU5Wj4R4A7yiWdjec1gkvxi7Iy4UlYepf9X/gfQIy+iP0n8
         eOi7lgl2uZdeT0FFUqhoEi7cvCYbS1kdmA6DI6TG9RjWhxcnhejzKw7HdO0FnfdNY5jN
         l46VdIoYMzR3g9UcREzdGkg7cshlwXXlcKZ3pe960s+IZhRl8MXz6O+VByLJoGTEfWYx
         tIhd1puUdPcEW/SAH9szs9Hmh9Xu1gU5q/lc1MClsgTRK76lWumlmWklA/9q14he0JiE
         jzWU6ZmVDI9FbV3JNFsBSpVlN2wLZUy2O9gQCfKln+6Efp/kUhdoB1kLALvbb3AN0eNf
         3Clw==
X-Gm-Message-State: AOJu0YyR4aR2F2d1DBXGYmArMxlbzq+y6phfBBFp4hOwUlJ8qDLbAMCR
	uS5WxRYXiRAErG+WOC9w7sei8U/SZVc=
X-Google-Smtp-Source: AGHT+IE+rwwSZOnNIm1oVLkjORXDZFsy09Wm5zk955j3nfIYxz7wPLisHgR0CkAQkaQqXTvi+0e32bs4FSs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ac8e:b0:1cc:30cf:eae6 with SMTP id
 h14-20020a170902ac8e00b001cc30cfeae6mr498273plr.10.1699284680259; Mon, 06 Nov
 2023 07:31:20 -0800 (PST)
Date: Mon, 6 Nov 2023 07:31:18 -0800
In-Reply-To: <CALMp9eS+kNYYK_1Ufy5vc5PK25q-ny20woxbHz1onStkcfWNVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-3-seanjc@google.com>
 <CALMp9eS+kNYYK_1Ufy5vc5PK25q-ny20woxbHz1onStkcfWNVw@mail.gmail.com>
Message-ID: <ZUkGxqX8mJPPtxHD@google.com>
Subject: Re: [PATCH v6 02/20] KVM: x86/pmu: Don't enumerate support for fixed
 counters KVM can't virtualize
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 04, 2023, Jim Mattson wrote:
> On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Hide fixed counters for which perf is incapable of creating the associa=
ted
> > architectural event.  Except for the so called pseudo-architectural eve=
nt
> > for counting TSC reference cycle, KVM virtualizes fixed counters by
> > creating a perf event for the associated general purpose architectural
> > event.  If the associated event isn't supported in hardware, KVM can't
> > actually virtualize the fixed counter because perf will likely not prog=
ram
> > up the correct event.
>=20
> Won't it? My understanding was that perf preferred to use a fixed
> counter when there was a choice of fixed or general purpose counter.
> Unless the fixed counter is already assigned to a perf_event, KVM's
> request should be satisfied by assigning the fixed counter.
>=20
> > Note, this issue is almost certainly limited to running KVM on a funky
> > virtual CPU model, no known real hardware has an asymmetric PMU where a
> > fixed counter is supported but the associated architectural event is no=
t.
>=20
> This seems like a fix looking for a problem. Has the "problem"
> actually been encountered?

Heh, yes, I "encountered" the problem in a curated VM I created.  But I com=
pletely
agree that this is unnecessary, especially since odds are very, very good t=
hat
requesting the architectural general purpose encoding will still work.  E.g=
. in
my goofy setup, the underlying hardware does support the architectural even=
t and
so even if perf doesn't use the fixed counter for whatever reason, the GP c=
ounter
will still count the right event.

