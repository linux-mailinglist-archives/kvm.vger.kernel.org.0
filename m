Return-Path: <kvm+bounces-72262-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFbALh49ommq1AQAu9opvQ
	(envelope-from <kvm+bounces-72262-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BEA51BF8AD
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2129A3008503
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBB026CE17;
	Sat, 28 Feb 2026 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFoqE6TS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48AE2459D4
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772240127; cv=none; b=fKAFPTJVsa01w3EOOZWaDjvs8il5BEk3+GsN0EfD1VfR8cKXd+KofrVg/ilp4hsNRCLo6TbW6v54J9dUDuqFl2Gt447XXtOXCQGAsBm8vu3ij0NEncdxTnAZPz1IdwSPLdjE1Cc+veFeqTgU9W/UCG3pE3fnaiRvCRBUzi4neEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772240127; c=relaxed/simple;
	bh=LuR8uJp4EH86mWRI6ZbM5/S+UOlw+dsUfdvOULBWOWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gNwG5Us4zlA5rIu7IsZpOONDQtypyV+6twdw5Tc1CEX/elkKRrbFt2sgCToNuiw49nmkNH6P1w9Ql/V5hEed9JfxOUoO3+JvJFoJlnsG5L3+gFexwFr6Fwb4xybYcW4cnqdWbGEoajAbcaEotWtfnuZXg4a5yRvE++SffRjhujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFoqE6TS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75484C2BC9E
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772240127;
	bh=LuR8uJp4EH86mWRI6ZbM5/S+UOlw+dsUfdvOULBWOWM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EFoqE6TSMjA4xGzHde3o35McUaIx5UeLMfXh+IJXd9Qt9daVlzA2RdHs0r1nfV4u1
	 N737YSqSmcsqfeNnkeDj855F4ARGuTCwPwSLutMZoj1bJhLqMXXfLPsD6vXl9Hho3i
	 HGxQrDvPqZMnYkJvvY3bbvXVLi3YHTQGxkPOWufbSTNgql2kvfkoexPP/mgEuyKqnh
	 18cxuWTk76c6nI5q5PcdLBHB/whPWKw1d5gx+rcKANUx/bmlq5pMI7dd2vFu7KCnpU
	 0Z/SgKpDLpH6XG82ZhwiKKS1O3/8u78MKvReLrPfjJ509gjy4ehaBCIn2GabcQjl+J
	 PR4aG+Ihqo5AA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9381e78a31so153115466b.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:55:27 -0800 (PST)
X-Gm-Message-State: AOJu0YzMC/3nRL684vA2Qu8NbDnQbZ6xhyc6Tp3JlXQ8s6uT8ob8Zrd5
	uqfINGMKo1ozlLfIj71AyffZQCZlRjTu2yBYUn87JZxVYodDA5pTAbjaU2LmD25qz/FNiObVy9Z
	1WTbGuR0SePs4PBIlv8i/eT4AVQ5zo24=
X-Received: by 2002:a17:907:9285:b0:b8e:14cc:9197 with SMTP id
 a640c23a62f3a-b937639bba2mr325334766b.15.1772240126266; Fri, 27 Feb 2026
 16:55:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227213849.3653331-1-jmattson@google.com>
In-Reply-To: <20260227213849.3653331-1-jmattson@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 16:55:14 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
X-Gm-Features: AaiRm50jroajCDHWriBK4e9Ee8OypJ8FGHhTDJST7PTzmgYMu2Lo6ivT84mvpMA
Message-ID: <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72262-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 3BEA51BF8AD
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 1:39=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> Linux commit 400816f60c54 ("perf/x86/intel: Implement support for TSX For=
ce
> Abort") introduced a feature that temporarily disables RTM on Skylake and
> similar CPUs (06_55H stepping <=3D 5, 06_4EH, 06_5EH, 06_8EH stepping <=
=3D 0BH,
> and 06_9EH stepping <=3D 0CH) via the TSX_FORCE_ABORT MSR, so that all fo=
ur
> general purpose PMCs can be used by perf. This feature is on by default,
> but can be disabled by writing 0 to /sys/devices/cpu/allow_tsx_force_abor=
t.
>
> When TSX_FORCE_ABORT.RTM_FORCE_ABORT[bit 0] is set, all RTM transactions
> will immediately abort, before the xbegin instruction retires.
>
> The test of a single-step #DB delivered in a transactional region,
> introduced in commit 414bd9d5ebd7 ("x86: nVMX: Basic test of #DB intercep=
t
> in L1"), does not handle this scenario.
>
> Modify the test to identify an immediate RTM transaction abort and to try
> up to 30 times before giving up. If the xbegin instruction never retires,
> report the test as skipped.
>
> Note that when an RTM transaction aborts, the CPU state is rolled back to
> before the xbegin instruction, but the RIP is modified to point to the
> fallback code address. Hence, if the transaction aborts before the
> single-step #DB trap is delivered, the first instruction of the fallback
> code will retire before the single-step #DB trap is delivered.
>
> Fixes: 414bd9d5ebd7 ("x86: nVMX: Basic test of #DB intercept in L1")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  lib/x86/msr.h   |  1 +
>  x86/vmx_tests.c | 56 ++++++++++++++++++++++++++++++++-----------------
>  2 files changed, 38 insertions(+), 19 deletions(-)
>
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index 7397809c07cd..97f52bb5bb4e 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -109,6 +109,7 @@
>  #define DEBUGCTLMSR_BTS_OFF_OS         (1UL <<  9)
>  #define DEBUGCTLMSR_BTS_OFF_USR                (1UL << 10)
>  #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI (1UL << 11)
> +#define DEBUGCTLMSR_RTM_DEBUG          (1UL << 15)
>
>  #define MSR_LBR_NHM_FROM       0x00000680
>  #define MSR_LBR_NHM_TO         0x000006c0
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 5ffb80a3d866..2094a0d3ec57 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9217,9 +9217,10 @@ static void vmx_db_test_guest(void)
>          * For a hardware generated single-step #DB in a transactional re=
gion.
>          */
>         asm volatile("vmcall;"
> -                    ".Lxbegin: xbegin .Lskip_rtm;"
> +                    ".Lrtm_begin: xbegin .Lrtm_fallback;"
>                      "xend;"
> -                    ".Lskip_rtm:");
> +                    ".Lrtm_fallback: nop;"
> +                    ".Lpost_rtm:");
>  }
>
>  /*
> @@ -9295,6 +9296,10 @@ static void single_step_guest(const char *test_nam=
e, u64 starting_dr6,
>   * exception bits are properly accumulated into the exit qualification
>   * field.
>   */
> +
> +#define RTM_RETRIES 30
> +#define ONE_BILLION 1000000000ul

I think the name would be more descriptive as RTM_DELAY_CYCLES or sth,
IIUC this will be in the order of 100s of milliseconds. Do we need to
wait that long between retries? If the CPU is in a state where it will
always abort RTM, 30 retries will end up taking seconds or 10s of
seconds, right?

