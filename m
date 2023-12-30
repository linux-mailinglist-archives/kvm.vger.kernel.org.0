Return-Path: <kvm+bounces-5336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA998203F6
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 09:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 414A71C20AFA
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEDA8BE7;
	Sat, 30 Dec 2023 08:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ckBfBUTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D58BE3
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 08:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-35fc1a1b52bso28847675ab.2
        for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 00:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703923306; x=1704528106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPf6Z8tNoGfk9MBYZ1RUJvDaaG9qPZRvtU/U6N7KNnE=;
        b=ckBfBUTKsPKnbFcdr3E7+Q4lBxFoRTmMzFCEiz4urib9eotQZgmMlP01J8Egb9qkKM
         7klC0kKQ/ExMWvtdXv5mVvQDZzXTLjCeUZS5BcRxvU28dXf7eAZKzhrl2uslOZOpfODd
         sgYAjKGgQXbQOiDH9OyUX00EOa0fsx8Al/lMY9pvH/qBU+rSREru3VAOr8iDRYtLcnAD
         F++WdSBqaI2ssbRzzkl7LFBODmDeKbRwqDltfFNK0jS2XLh38UFYz9qpTuDBYzNM4APm
         vFaa/ngt0uUtV0dJcrILmlH+uinP880j9pSYZw6DwXt+gI14caXv7khUT7dczByMCiOu
         sFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703923306; x=1704528106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LPf6Z8tNoGfk9MBYZ1RUJvDaaG9qPZRvtU/U6N7KNnE=;
        b=SOo1ygrEKDYAOySHCc6EdfLKukrF3KM5+o3vHNEi5HzSo7oJTJCXyzkqlG3bXdaexo
         Irifp/KUD7IZq+RcL+mfhQBOdQubJ/kXuSut1bSluFvSR58OXguiMnQIwZX8lbHoGfaY
         gvrzjddhzO+IV/dUSyZ9vFbCAz9omaQNCmyNdIM4D7DijVYEE9zg3mHOdP3+gG2K+eVB
         hsDj6TQx/akbmKlFtvgrt/8gN6lnm90uGLfckNI0Zb7tUK2NxNguEFw7SQt+G/K2tsWV
         6/VVeT4a69weiKCzPIRNt5S2vVaKrB9VqZ3hvZ1G1Ooblf7Sefv+NZ6IPaVMh+caqjra
         MlDw==
X-Gm-Message-State: AOJu0Yw4ELMWP3j/E2lSu6fsJDmOoBRZDF2cWY7uOMPpXxgbEZNCEa7h
	PpB0CSAJlvps7k+uAMIv5cCc+KaebRfRRU3WihXWtzgapZ3Qww==
X-Google-Smtp-Source: AGHT+IG8kNEDveFHvGFklktInOSrh1sA+fL4mwRG4OISbyge3JZk+7FM4QwNXRHrKqUNcK01OLVK5yRqEEzfirj8O3E=
X-Received: by 2002:a92:c549:0:b0:35f:ee15:742c with SMTP id
 a9-20020a92c549000000b0035fee15742cmr11876530ilj.7.1703923306083; Sat, 30 Dec
 2023 00:01:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-8-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-8-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:31:36 +0530
Message-ID: <CAAhSdy1cb_bEuE+pHusEoumhteu=Y87+WXpE=Eox1k2ng4pdZg@mail.gmail.com>
Subject: Re: [v2 07/10] RISC-V: KVM: No need to exit to the user space if perf
 event failed
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> Currently, we return a linux error code if creating a perf event failed
> in kvm. That shouldn't be necessary as guest can continue to operate
> without perf profiling or profiling with firmware counters.
>
> Return appropriate SBI error code to indicate that PMU configuration
> failed. An error message in kvm already describes the reason for failure.
>
> Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without samplin=
g")
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c     | 14 +++++++++-----
>  arch/riscv/kvm/vcpu_sbi_pmu.c |  6 +++---
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 8c44f26e754d..08f561998611 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -229,8 +229,9 @@ static int kvm_pmu_validate_counter_mask(struct kvm_p=
mu *kvpmu, unsigned long ct
>         return 0;
>  }
>
> -static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_ev=
ent_attr *attr,
> -                                    unsigned long flags, unsigned long e=
idx, unsigned long evtdata)
> +static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_e=
vent_attr *attr,
> +                                     unsigned long flags, unsigned long =
eidx,
> +                                     unsigned long evtdata)
>  {
>         struct perf_event *event;
>
> @@ -455,7 +456,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu =
*vcpu, unsigned long ctr_ba
>                                      unsigned long eidx, u64 evtdata,
>                                      struct kvm_vcpu_sbi_return *retdata)
>  {
> -       int ctr_idx, ret, sbiret =3D 0;
> +       int ctr_idx, sbiret =3D 0;
> +       long ret;
>         bool is_fevent;
>         unsigned long event_code;
>         u32 etype =3D kvm_pmu_get_perf_event_type(eidx);
> @@ -514,8 +516,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu=
 *vcpu, unsigned long ctr_ba
>                         kvpmu->fw_event[event_code].started =3D true;
>         } else {
>                 ret =3D kvm_pmu_create_perf_event(pmc, &attr, flags, eidx=
, evtdata);
> -               if (ret)
> -                       return ret;
> +               if (ret) {
> +                       sbiret =3D SBI_ERR_NOT_SUPPORTED;
> +                       goto out;
> +               }
>         }
>
>         set_bit(ctr_idx, kvpmu->pmc_in_use);
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.=
c
> index 7eca72df2cbd..b70179e9e875 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -42,9 +42,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcp=
u, struct kvm_run *run,
>  #endif
>                 /*
>                  * This can fail if perf core framework fails to create a=
n event.
> -                * Forward the error to userspace because it's an error w=
hich
> -                * happened within the host kernel. The other option woul=
d be
> -                * to convert to an SBI error and forward to the guest.
> +                * No need to forward the error to userspace and exit the=
 guest
> +                * operation can continue without profiling. Forward the
> +                * appropriate SBI error to the guest.
>                  */
>                 ret =3D kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp=
->a1,
>                                                        cp->a2, cp->a3, te=
mp, retdata);
> --
> 2.34.1
>

