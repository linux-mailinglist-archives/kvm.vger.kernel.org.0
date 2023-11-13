Return-Path: <kvm+bounces-1597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FB87E9D65
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 14:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C85FBB208A0
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 13:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E782208C2;
	Mon, 13 Nov 2023 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="py4g605l"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A92031B
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 13:40:58 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C848D73
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 05:40:56 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc252cbde2so45090665ad.0
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 05:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699882856; x=1700487656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=grMhSA8EkJmQQzxh1GozgoQ7euxsD4+OSt/yXIyQHbI=;
        b=py4g605lrblfDVOvgOlNY3ClyHPLDqbFW2UT1YTd4Ag7vaqwkThndPFqQ4VZNCcJz+
         +8DH0t3HbJO8xFA0BC33MSD15ZBg73al+ozQfrYg2bG1I5hqS4yUvmz/nrA8FPpBxx9a
         qiEm5RpiUDDMQ3TQkqDQJpB9CginyxgofCIK/svAuuLJn5mIqbeNAXIpjs3GSL7/I6KC
         awsflbba6KnytqDFNQCk7qUCg314NwEXtMU53r3pNiMn/WR2zbl7UdMCBgSQzCUw+J7H
         LKiS6s2AANzHVirwQ5sGegSQvEvc4RobaSgmr7X5KPv7b5PiLYi1IvAJ5+a6yEH+iYan
         Te7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699882856; x=1700487656;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=grMhSA8EkJmQQzxh1GozgoQ7euxsD4+OSt/yXIyQHbI=;
        b=p4eSF9u6vG62EkwcxfsvTaCkpH1FxnOYSaz9j9Hz8k9NNbZiDO2zv5qAkJYKrZU6jN
         DUKjnn7jwIwzQJw4JLsSu8mFG0R7pa7eJjEvRH9xelEz5X+dtN2fMNhV9fyKs178B9Tf
         fj9H+cwoiIX/NuX61xZ7K1akXGleLh/Vnu8kTxVJdjJSC3kCZBGr/8FTEzd129DzlU9C
         AxrvVwwXHPqt8vfyOTulPWHuGuL0jm2vx6rBOBy5aSIrPB/1zyKXhJkIxTQ+qZCVJT3/
         qsIoikDmRwgyH3uprJwhenAVOjhUcd0tJUux3HuHbS/nbmYC5r3N0HFmyok8kgd5ikxK
         gVyA==
X-Gm-Message-State: AOJu0Yw+LtyeB3x52Z58Be/6oR+GhYGjMGJIXBuHhBCE5+Q2aw5RyZ/4
	Pb33Ox7bbmxvj51ClZ2226iile0qRiU=
X-Google-Smtp-Source: AGHT+IGKkZbz8G134/I6ioIQ6rHAyKn4MTSEwp5YQNMnVY5eA3LBDtFO1zpdTitE4tEcg9M1FDie4oR41hs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:428a:b0:1cc:449a:7f4d with SMTP id
 ju10-20020a170903428a00b001cc449a7f4dmr1794531plb.12.1699882855839; Mon, 13
 Nov 2023 05:40:55 -0800 (PST)
Date: Mon, 13 Nov 2023 05:40:54 -0800
In-Reply-To: <feb599ea-89e6-1dd9-ba71-3c3d1e027e06@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com> <20231110021306.1269082-27-seanjc@google.com>
 <feb599ea-89e6-1dd9-ba71-3c3d1e027e06@gmail.com>
Message-ID: <ZVInZkwjbanQ2rkx@google.com>
Subject: Re: [PATCH v8 26/26] KVM: selftests: Extend PMU counters test to
 validate RDPMC after WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Jinrong Liang <ljr.kernel@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>, Jinrong Liang <cloudliang@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2023, Jinrong Liang wrote:
> =E5=9C=A8 2023/11/10 10:13, Sean Christopherson =E5=86=99=E9=81=93:
> > Extend the read/write PMU counters subtest to verify that RDPMC also re=
ads
> > back the written value.  Opportunsitically verify that attempting to us=
e
> > the "fast" mode of RDPMC fails, as the "fast" flag is only supported by
> > non-architectural PMUs, which KVM doesn't virtualize.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > +		/* Redo the read tests with RDPMC, and with forced emulation. */
> > +		vector =3D rdpmc_safe(rdpmc_idx, &val);
> > +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vecto=
r);
> > +		if (expect_success)
> > +			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
> > +
> > +		vector =3D rdpmc_safe_fep(rdpmc_idx, &val);
> > +		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vecto=
r);
> > +		if (expect_success)
> > +			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);

> This test case failed on my Intel machine.
>=20
> Error message=EF=BC=9A
> Testing arch events, PMU version 0, perf_caps =3D 0
> Testing GP counters, PMU version 0, perf_caps =3D 0
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   lib/x86_64/processor.c:1100: Unhandled exception in guest
>   pid=3D464480 tid=3D464480 errno=3D4 - Interrupted system call
>      1	0x00000000004120e1: assert_on_unhandled_exception =E4=BA=8E proces=
sor.c:1146
>      2	0x00000000004062d9: _vcpu_run =E4=BA=8E kvm_util.c:1634
>      3	0x00000000004062fa: vcpu_run =E4=BA=8E kvm_util.c:1645
>      4	0x0000000000403697: run_vcpu =E4=BA=8E pmu_counters_test.c:56
>      5	0x00000000004026fc: test_gp_counters =E4=BA=8E pmu_counters_test.c=
:434
>      6	(=E5=B7=B2=E5=86=85=E8=BF=9E=E5=85=A5)test_intel_counters =E4=BA=
=8E pmu_counters_test.c:580
>      7	(=E5=B7=B2=E5=86=85=E8=BF=9E=E5=85=A5)main =E4=BA=8E pmu_counters_=
test.c:604
>      8	0x00007f7a2f03ad84: ?? ??:0
>      9	0x00000000004028bd: _start =E4=BA=8E ??:?
>   Unhandled exception '0x6' at guest RIP '0x402bab'

Argh, I didn't add a check to see if forced emulation is actually enabled (=
forced
emulation uses a magic "prefix" to trigger a #UD, which KVM intercepts; if =
forced
emulation isn't enabled, KVM ignores the magic prefix and reflects the #UD =
back
into the guest).

This fixes the test for me:

---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools=
/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 248ebe8c0577..ae5f6042f1e8 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -325,6 +325,26 @@ __GUEST_ASSERT(expect_gp ? vector =3D=3D GP_VECTOR : !=
vector,			\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
 		       msr, expected_val, val);
=20
+static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
+			     uint64_t expected_val)
+{
+	uint8_t vector;
+	uint64_t val;
+
+	vector =3D rdpmc_safe(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+	if (!is_forced_emulation_enabled)
+		return;
+
+	vector =3D rdpmc_safe_fep(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+}
+
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_co=
unters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
@@ -367,20 +387,15 @@ static void guest_rd_wr_counters(uint32_t base_msr, u=
int8_t nr_possible_counters
 		if (!expect_gp)
 			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
=20
+		/*
+		 * Redo the read tests with RDPMC, which has different indexing
+		 * semantics and additional capabilities.
+		 */
 		rdpmc_idx =3D i;
 		if (base_msr =3D=3D MSR_CORE_PERF_FIXED_CTR0)
 			rdpmc_idx |=3D INTEL_RDPMC_FIXED;
=20
-		/* Redo the read tests with RDPMC, and with forced emulation. */
-		vector =3D rdpmc_safe(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
-		if (expect_success)
-			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
-
-		vector =3D rdpmc_safe_fep(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
-		if (expect_success)
-			GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+		guest_test_rdpmc(rdpmc_idx, expect_success, expected_val);
=20
 		/*
 		 * KVM doesn't support non-architectural PMUs, i.e. it should
@@ -389,12 +404,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, ui=
nt8_t nr_possible_counters
 		 */
 		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
 		rdpmc_idx |=3D INTEL_RDPMC_FAST;
-
-		vector =3D rdpmc_safe(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
-
-		vector =3D rdpmc_safe_fep(rdpmc_idx, &val);
-		GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, true, vector);
+		guest_test_rdpmc(rdpmc_idx, false, -1ull);
=20
 		vector =3D wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);

base-commit: 743a1a6d106931691be32e081e929d9b3de5777f
--=20


