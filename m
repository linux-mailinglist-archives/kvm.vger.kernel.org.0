Return-Path: <kvm+bounces-5858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD9B827C8C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 02:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 627F71C2288F
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 01:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4995A211C;
	Tue,  9 Jan 2024 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cy2yPlAh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68DA186C
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 01:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2cd04078ebeso30726381fa.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 17:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704763925; x=1705368725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqux+LcaKelggaB3rDs9tXbehWCfqmUp+Vj6CP8n9ZU=;
        b=Cy2yPlAhvhAP0DNAsIdnnXZS63uxtLybIt5tBsGwu4ydwegSCGNwINRetVHSiptP+T
         iGs5nz3QZEiCngJpXajh+gahSnatQKHYQXlQCVCAYBfmR2nLmfNkLuoI0lSaYbXHlUeO
         bsVihfvpgXG6eztcSyAuq4d8fVRjGLzzYK5v5E4D8nMaR+QJRi6eT/sd0gkEEZkI8xba
         9+I9pMSrynJ7fQS7pW1H3jXJsxsyN3qc1RMA6+qsjnNpBjj7/0dUwOGMZ7/fTP/BMWD3
         lKEuRAK9oYROvCG5aTtD7HSYzIhXZCo/oXGbeq6hdhx90fjOxicOiGUQYpI/7kcxCBcJ
         cpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704763925; x=1705368725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqux+LcaKelggaB3rDs9tXbehWCfqmUp+Vj6CP8n9ZU=;
        b=TYnhdNsnI8OWjD+8xZT57sDknl1WViXYf9ZC6Xkf8IdVYfwCp2G86kk7Hz9kuf42WG
         0l/8TQEcemvJo9jL6ESrrg7yJzF5urxNEEUS6noTVVQUqdWncQWir7kMqxWQOFIBO2Zp
         qERn+nX38MKYoxmq62iLYF2jviASjoNXw5A3QX5B5P8l62a9bw1sUDqapqIlXiLJVtnx
         YNDxuoXvpEJxiKh9JzvCmkAuSYxUgmvqmjQ09hEeM9HbPzE4W67DmZyEvWYpnQiLS1k5
         gdS00DQcvqdWs+1ctEYFSqly83rUw6Cmbhcgkr22dTxA/BjlS5ddtAnHMW/2sZJd70Dc
         kj8A==
X-Gm-Message-State: AOJu0YxAPoaSSQ+mV0QG8x9aIFY1RW8feJri9DYV9jAJEn06J1Fq3Pjm
	6H97vfuN4LBYRTKWHEHtKsBmX8exVz4C4fIaViEhVAqR9x+H
X-Google-Smtp-Source: AGHT+IHIcdGC5FwkPbRs/JX9n0WUrV1i17KlbKSwO8N8Qs5NlsKrwN/fJYPmZ9xelKa6ETaAV4o/PzMo6xcxLCfQlts=
X-Received: by 2002:a2e:9950:0:b0:2cd:191a:c1bf with SMTP id
 r16-20020a2e9950000000b002cd191ac1bfmr4343ljj.14.1704763924662; Mon, 08 Jan
 2024 17:32:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev> <e0facec9-8c50-10cb-fd02-1214f9a49571@redhat.com>
 <ab1337bc-d4a2-0afc-3e26-0d50dff4ea73@huawei.com> <ZZx5y_iy9kXg47SW@linux.dev>
In-Reply-To: <ZZx5y_iy9kXg47SW@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 8 Jan 2024 17:31:51 -0800
Message-ID: <CAAdAUtie4GFKAPhk4wDWnEmSOzWF+X-6eHwS79169JRv_=hKdg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eauger@redhat.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zenghui,

I don't have a Cortex A72 to fully verify the fix. Could you help
verify the following change?

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index bac05210b539..f17454dc6d9e 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct
reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
        uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);

-       if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
+       if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
                switch (ftr_bits->type) {
                case FTR_EXACT:
                        ftr =3D ftr_bits->safe_val;
                        break;
                case FTR_LOWER_SAFE:
-                       if (ftr > 0)
+                       uint64_t min_safe =3D 0;
+
+                       if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_DebugV=
er"))
+                               min_safe =3D ID_AA64DFR0_EL1_DebugVer_IMP;
+                       else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_CopDb=
g"))
+                               min_safe =3D ID_DFR0_EL1_CopDbg_Armv8;
+
+                       if (ftr > min_safe)
                                ftr--;
                        break;
                case FTR_HIGHER_SAFE:
@@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits
*ftr_bits, uint64_t ftr)
                        ftr =3D ftr_bits->safe_val;
                        break;
                case FTR_LOWER_SAFE:
-                       if (ftr > 0)
+                       uint64_t min_safe =3D 0;
+
+                       if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"))
+                               min_safe =3D ID_DFR0_EL1_PerfMon_PMUv3;
+
+                       if (ftr > min_safe)
                                ftr--;
                        break;
                case FTR_HIGHER_SAFE:
@@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct
reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
        uint64_t ftr_max =3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);

-       if (ftr_bits->type =3D=3D FTR_UNSIGNED) {
+       if (ftr_bits->sign =3D=3D FTR_UNSIGNED) {
                switch (ftr_bits->type) {
                case FTR_EXACT:
                        ftr =3D max((uint64_t)ftr_bits->safe_val + 1, ftr +=
 1);

On Mon, Jan 8, 2024 at 2:40=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Zenghui,
>
> On Fri, Jan 05, 2024 at 05:07:08PM +0800, Zenghui Yu wrote:
> > On 2023/10/19 16:38, Eric Auger wrote:
> >
> > > > +static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] =3D {
> > > > + S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
> > >
> > > Strictly speaking this is not always safe to have a lower value. For
> > > instance: From Armv8.1, if FEAT_PMUv3 is implemented, the value 0b000=
1
> > > is not permitted. But I guess this consistency is to be taken into
> > > account by the user space. But may be wort a comment. Here and below
> > >
> > > You may at least clarify what does mean 'safe'
> > >
> > > > + REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, 0),
> >
> > I've seen the following failure on Cortex A72 where
> > ID_AA64DFR0_EL1.DebugVer is 6.
>
> Ah, yes, the test is wrong. KVM enforces a minimum value of 0x6 on this
> field, yet get_safe_value() returns 0x5 for the field.
>
> Jing, do you have time to check this test for similar failures and send
> out a fix for Zenghui's observations?
>
> > # ./aarch64/set_id_regs
> > TAP version 13
> > 1..79
> > ok 1 ID_AA64DFR0_EL1_PMUVer
> > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >   include/kvm_util_base.h:553: !ret
> >   pid=3D2288505 tid=3D2288505 errno=3D22 - Invalid argument
> >      1        0x0000000000402787: vcpu_set_reg at kvm_util_base.h:553
> > (discriminator 6)
> >      2         (inlined by) test_reg_set_success at set_id_regs.c:342
> > (discriminator 6)
> >      3         (inlined by) test_user_set_reg at set_id_regs.c:413 (dis=
criminator
> > 6)
> >      4        0x0000000000401943: main at set_id_regs.c:475
> >      5        0x0000ffffbdd5d03b: ?? ??:0
> >      6        0x0000ffffbdd5d113: ?? ??:0
> >      7        0x0000000000401a2f: _start at ??:?
> >   KVM_SET_ONE_REG failed, rc: -1 errno: 22 (Invalid argument)
>
> --
> Thanks,
> Oliver

Thanks,
Jing

