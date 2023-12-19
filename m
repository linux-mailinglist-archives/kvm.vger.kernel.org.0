Return-Path: <kvm+bounces-4761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5F9818042
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 04:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79B95284210
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 03:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3038B11725;
	Tue, 19 Dec 2023 03:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tg1HrtQT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A5B11709
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so8320a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 19:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702957225; x=1703562025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5FUuLgaGf3Ehy+dGQ0rAjiQIaBVuk5PDJgLlbYNQhA=;
        b=tg1HrtQTUJr+jmA51KV4kTaaw6bEeT3PaFc1lls55Cda+P5Zdg9M0m4F/iXHht+kVS
         cHqHw14q1HOR+Pq1SBXXq6qpPXUL0YWzLkfhDcqMesABCX7T4C3Cn5UvdIGhCtKPfh6D
         tL4w0/a1DY07VKnmy0vVCjgOFUuz5+lIdp2sgUgs6NkRyo6J1HF4zdgFgcr4sMlydCHD
         0/fmEHuTJp/gxnoe2GnxQ4S2Npp2xaiAAVxWfaT1e5BwM8YJJD9vGzU8+Bpq/ghRhEdd
         HbhQTQveP/iyzwif/Ami/G7IqQsnSw1cwBgJhsYawoLRmagYAQVlkT+9btblGFTLdlx2
         o9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702957225; x=1703562025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5FUuLgaGf3Ehy+dGQ0rAjiQIaBVuk5PDJgLlbYNQhA=;
        b=AwQSKugbCzMAh6D/cCTW7c85cHy5MGZH9n4a+WrN8GwYtL7lbevVD4jm9NdVutfaRm
         3Ox9u9HgI2IfcgDD3WSO3MwlLxm0Q1kTbNHcXNfQq3vchzGQS6EQ6djDKe6PPoQynKKV
         yhaK4Vw9oxBvWvJhuo/SkTXwOh9Cx27a4t4wkHVJDJE8GtIsJ2yQCnN4KQHs8TZ8D0+x
         lHbPdnCVQ3SBsACOsLhCoEo2L3i3WmV1lwu86uxNIrbWpMLYXSIYCKcmwv8MOa8BIu6i
         N4RRJ33L99aKlVOnh7RG/lUkT/XCPNdPQ20ON+E5yBRsmwv9aCPZaG7a2fJzqZ+zneL2
         MgzA==
X-Gm-Message-State: AOJu0YxtWUwTWQWiPq+9AGD2Zgpj9aqSBz0Ir7cIi/50Z6DjWUtAK+Or
	qdTTCbVpKzSIzbg+jre+ldXqjQ53LE/aWIy3jnqp9jxWK5lU
X-Google-Smtp-Source: AGHT+IEqgRZMP0DxMI1ohL2C9I2Lr9A0Ajqd+W8Y92PHxfhD22/wRIhfTj+Idlin9DYhrqQfrw2UgadH4Oz1KMpfaTU=
X-Received: by 2002:a50:d488:0:b0:553:479c:d9c2 with SMTP id
 s8-20020a50d488000000b00553479cd9c2mr120412edi.4.1702957224903; Mon, 18 Dec
 2023 19:40:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYBhl200jZpWDqpU@google.com>
 <ZYEFGQBti5DqlJiu@chao-email>
In-Reply-To: <ZYEFGQBti5DqlJiu@chao-email>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 18 Dec 2023 19:40:11 -0800
Message-ID: <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, 
	pbonzini@redhat.com, eddie.dong@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 6:51=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Mon, Dec 18, 2023 at 07:13:27AM -0800, Sean Christopherson wrote:
> >On Mon, Dec 18, 2023, Tao Su wrote:
> >> When host doesn't support 5-level EPT, bits 51:48 of the guest physica=
l
> >> address must all be zero, otherwise an EPT violation always occurs and
> >> current handler can't resolve this if the gpa is in RAM region. Hence,
> >> instruction will keep being executed repeatedly, which causes infinite
> >> EPT violation.
> >>
> >> Six KVM selftests are timeout due to this issue:
> >>     kvm:access_tracking_perf_test
> >>     kvm:demand_paging_test
> >>     kvm:dirty_log_test
> >>     kvm:dirty_log_perf_test
> >>     kvm:kvm_page_table_test
> >>     kvm:memslot_modification_stress_test
> >>
> >> The above selftests add a RAM region close to max_gfn, if host has 52
> >> physical bits but doesn't support 5-level EPT, these will trigger infi=
nite
> >> EPT violation when access the RAM region.
> >>
> >> Since current Intel CPUID doesn't report max guest physical bits like =
AMD,
> >> introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when t=
dp is
> >> enabled and report the max guest physical bits which is smaller than h=
ost.
> >>
> >> When guest physical bits is smaller than host, some GPA are illegal fr=
om
> >> guest's perspective, but are still legal from hardware's perspective,
> >> which should be trapped to inject #PF. Current KVM already has a param=
eter
> >> allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
> >> host.MAXPHYADDR, which is disabled by default when EPT is enabled, use=
r
> >> can enable it when loading kvm-intel module. When allow_smaller_maxphy=
addr
> >> is enabled and guest accesses an illegal address from guest's perspect=
ive,
> >> KVM will utilize EPT violation and emulate the instruction to inject #=
PF
> >> and determine #PF error code.
> >
> >No, fix the selftests, it's not KVM's responsibility to advertise the co=
rrect
> >guest.MAXPHYADDR.
>
> In this case, host.MAXPHYADDR is 52 and EPT supports 4-level only thus ca=
n
> translate up to 48 bits of GPA.

There are a number of issues that KVM does not handle when
guest.MAXPHYADDR < host.MAXPHYADDR. For starters, KVM doesn't raise a
#GP in PAE mode when one of the address bits above guest.MAXPHYADDR is
set in one of the PDPTRs.

Honestly, I think KVM should just disable EPT if the EPT tables can't
support the CPU's physical address width.

> Here nothing visible to selftests or QEMU indicates that guest.MAXPHYADDR=
 =3D 52
> is invalid/incorrect. how can we say selftests are at fault and we should=
 fix
> them?

In this case, the CPU is at fault, and you should complain to the CPU vendo=
r.

