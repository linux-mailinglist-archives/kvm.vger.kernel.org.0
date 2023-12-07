Return-Path: <kvm+bounces-3791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7266C807F2F
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 04:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C3061C20D07
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 03:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD838524D;
	Thu,  7 Dec 2023 03:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LWZneiE0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF009A4
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 19:36:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-28670a7ba84so436700a91.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 19:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1701920191; x=1702524991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpmyb8tDOuDjxZZHw+pAqD3DpIEuP7kLjd1VsjqScDM=;
        b=LWZneiE0sVbTuYRr0VnkCfVEoechHb+NZjJtzuzOIv4+IhSILyqkKtd3G3A+OCWU0A
         Btw0DTJqub+l9YXxiq1FFFDfc3M1bs4sNlq4UzafUshIb6x2KVts8K5I9RqUHs1RXUPC
         ywQjqRzfWQpYVR9qMZAOgCPqaIuq348bLIBEE7SXkHiUNByqaiqnOjxSLU2Adcv2Bgxq
         3iTbdgypBN5dodxzcHrMzeKf7peMF76TlvUlvdWsSfp5Ms+cteMuD2YxKqQyEgl7y/ak
         7P/QCg3GzTiJdYo4aKUI3dSgDdzgqkxTSuxml5ucSXup1dnWYyofLA6mMxPfSs7UYPbR
         n8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701920191; x=1702524991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpmyb8tDOuDjxZZHw+pAqD3DpIEuP7kLjd1VsjqScDM=;
        b=kojAnaK/CqMgKRMUjo/O2VW7OKa/j2uBMy9bulWRqKyQbqNqS2so4srcQU2iyNLo7K
         1pYvoCoa2fvW3RZNxA5p3klRZ9U0SYZ8ORShOzkmtkOyfIHJpr+HvOl7ZvVucTPWPLID
         iSC67dHTypPpOSv+YLfjwwo/OzZTEH2Los9bKRT7kxvUWt9p0Gl3LuFbLeEz46hdx3Jc
         MKd8a9AM4NVnmx/2Lo4tBEiP8yeVcciS5+MMsgLcVp6RNO20Q9IjuQPtuMXkQlrl3SNN
         sSLEDeBayoJYhg7d/C1duoi/zGIh1bkMWJc+NuPua0fbf5G9hfzA++66vkjazwF4DkNk
         BTZg==
X-Gm-Message-State: AOJu0YwfcW72EmFVrWiFjFmOxvbosdD2xJ41Lano5HuQV/vLWut1GrOZ
	xANVphe0TUbBt063nc2nLiqz8+h70tuck4Ppe2lTNg==
X-Google-Smtp-Source: AGHT+IEM4PIqu4evLMzttRYz5xZTrBv9JHEOwZBZ3TDAZtsFijg+WwQhl3hMrZaWSpNq3AZG1PYrXsmc8rNBgQGb8ck=
X-Received: by 2002:a17:90b:4a11:b0:286:6cc0:b90b with SMTP id
 kk17-20020a17090b4a1100b002866cc0b90bmr1378337pjb.66.1701920191109; Wed, 06
 Dec 2023 19:36:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com> <20231206170241.82801-10-ajones@ventanamicro.com>
In-Reply-To: <20231206170241.82801-10-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 7 Dec 2023 09:06:19 +0530
Message-ID: <CAAhSdy1b8z2Vo8fig3O-kHHY0R+D=Y8g0WBDF4uagkQ7meak+Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: selftests: riscv: Remove redundant newlines
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 10:32=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> TEST_* functions append their own newline. Remove newlines from
> TEST_* callsites to avoid extra newlines in output.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
>  tools/testing/selftests/kvm/riscv/get-reg-list.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/te=
sting/selftests/kvm/lib/riscv/processor.c
> index d146ca71e0c0..b3082da05c76 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -327,7 +327,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned in=
t num, ...)
>         int i;
>
>         TEST_ASSERT(num >=3D 1 && num <=3D 8, "Unsupported number of args=
,\n"
> -                   "  num: %u\n", num);
> +                   "  num: %u", num);
>
>         va_start(ap, num);
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index 6bedaea95395..4355e33c0cec 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -112,7 +112,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu=
_reg_list *c)
>
>                 /* Double check whether the desired extension was enabled=
 */
>                 __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> -                              "%s not available, skipping tests\n", s->n=
ame);
> +                              "%s not available, skipping tests", s->nam=
e);
>         }
>  }
>
> --
> 2.43.0
>

