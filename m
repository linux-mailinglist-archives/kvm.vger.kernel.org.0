Return-Path: <kvm+bounces-2536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFE37FACAE
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 22:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 384D0B2136D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E8F4653D;
	Mon, 27 Nov 2023 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gian3Wn7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA98D6D
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 13:41:41 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-357d0d15b29so1535ab.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 13:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701121301; x=1701726101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIiUOLs4B5FYCz4BIBDodRBLizz4WQxtB5imEZ+H1Ys=;
        b=gian3Wn7W3tsv5oiZuo/6dSuIE+2x8BsNSyq/SBASxG8/kGx7Vp87qXj3UkSx4TLho
         MWzK6Z1eaWckyuXVD1WFrOu0jKF/KK8FPh9fOSHdHI4iK+2qdyh/H2RfuF/akvjKR0Ek
         5aPiB3Kpjz5VGV1XbmDN5xctZEGE/OlpBRm04Ie/Z/IO/qOTxoTuOTzxORZhqCiqZ391
         KOIyHJKyNthhCE8iH8XdysMBwml9Khb4LK2Pgc5bMjPFt/EzOKgNz9bgwAk9CXeAhMg8
         /uNxTo4k4ct/Y6TgTEzm1NzkSLhe80Op3h//0MxZ+Zf/boq7+OeFBHFHRh05NRbq2nPi
         NB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701121301; x=1701726101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIiUOLs4B5FYCz4BIBDodRBLizz4WQxtB5imEZ+H1Ys=;
        b=V/+dEeSZdAbkJ2AFGcnuZjhvJJ8cGiEQhp5waWLGHiCmRGkmSkfx2ZqWnFqPZ4Oxqi
         Ro6CvxVHVmfcr+TYSGQVtdEol9ixn+5TtHtedpMyKHxidPKlmti7dNLXlro0GnZgk52A
         EoZFM2Wjo3OLC1jHIlxhrMpNpPM90Xphnak8nIIJvLqF/4PfhMiFb66m0WAMe1kH5ffd
         mcQhq3M4Y47ORqRSvt7dnY9g+KZUAkxmSjO2V0PZLx5C0iLSsU0kCqFf3rY2mbcgsTVu
         WnsQ4IWd1QpT2Zq7Fz5cgjEKtPuxE0JG0ACLicc7EyKdZLBJL6KPniEvyFI6+RbRSzbC
         LdrA==
X-Gm-Message-State: AOJu0Yyn347IqHEPOFi+Fp4AB4ZkEFZdOk/3HFZuIX4dMyv3RgqLCfgF
	hXaEpdu8XSX/5TVWfGbjibTzzc5bbjZzaElmO68yGA==
X-Google-Smtp-Source: AGHT+IGbIr/R+htW7xaVZXcb1VijRsa9rXR3s4S6dUyOEpmr2hZBOp1GOfigsseF1e08qY1EZCsyy9k88qjMupsCCfE=
X-Received: by 2002:a92:da04:0:b0:35c:e49d:3e65 with SMTP id
 z4-20020a92da04000000b0035ce49d3e65mr211441ilm.11.1701121301101; Mon, 27 Nov
 2023 13:41:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122221526.2750966-1-rananta@google.com> <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
In-Reply-To: <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 27 Nov 2023 13:41:29 -0800
Message-ID: <CAJHc60zinMfkjFF=QS5R6YO0B8_Anmyw2cZ2f0QEnW0i=hWHcQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: aarch64: Remove unused functions from
 vpmu test
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Wed, Nov 22, 2023 at 10:43=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com=
> wrote:
>
> Hi Raghavendra,
>
> Those functions might be useful for other pmu tests. Recently I just
> wrote a pmu_event_filter_test[1] and use the enable_counter().
>
> There may have more pmu tests which can use the helper functions, so I
> think we can keep it now. And in my series[1], I have moved them into
> the lib/ as the helper function.
>
> [1]https://lore.kernel.org/all/20231123063750.2176250-1-shahuang@redhat.c=
om/
>
Thanks for the pointer. If you are planning to use it, then we can
abandon this patch. However, disable_counter() may need fixing. I'll
comment directly on your patch.

Thank you.
Raghavendra

> Thanks,
> Shaoqin
>
> On 11/23/23 06:15, Raghavendra Rao Ananta wrote:
> > vpmu_counter_access's disable_counter() carries a bug that disables
> > all the counters that are enabled, instead of just the requested one.
> > Fortunately, it's not an issue as there are no callers of it. Hence,
> > instead of fixing it, remove the definition entirely.
> >
> > Remove enable_counter() as it's unused as well.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ---------------=
-
> >   1 file changed, 16 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > index 5ea78986e665f..e2f0b720cbfcf 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsign=
ed long val)
> >       isb();
> >   }
> >
> > -static inline void enable_counter(int idx)
> > -{
> > -     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > -
> > -     write_sysreg(BIT(idx) | v, pmcntenset_el0);
> > -     isb();
> > -}
> > -
> > -static inline void disable_counter(int idx)
> > -{
> > -     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > -
> > -     write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> > -     isb();
> > -}
> > -
> >   static void pmu_disable_reset(void)
> >   {
> >       uint64_t pmcr =3D read_sysreg(pmcr_el0);
>

