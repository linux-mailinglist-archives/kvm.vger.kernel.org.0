Return-Path: <kvm+bounces-69543-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEI0NElWe2k0EAIAu9opvQ
	(envelope-from <kvm+bounces-69543-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:44:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F5DB020C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFCCF3023A61
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEE1388863;
	Thu, 29 Jan 2026 12:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igaD58Gk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713B3876D2
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769690684; cv=none; b=qzQMcqEdyHUKPbANXAAK+CvJqGgXIsxQnG9yRnM4903UhzD4ksT+iqf530o9JwrMynENiNVJPEH/bnpL2fgPBUMgGJkS2AwqUbFN87WRL1gOmOvKqR+i/OlYQZIK09VlFZmtrz1dhT8IEGyIujXrf1e3i/xgcfi8SUW13S4tA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769690684; c=relaxed/simple;
	bh=sItoRfinWc5/6cVlJRK4RojKxBdMuHNZCqTy0Zi2CbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N2FS20A9f8tk1OZlx+QpscsSXXf72iw7wN7xL8ONM8AON5jOegvMAHYhIUEWbpUiPl/+Jbwl6sG0lwfSEgPSY/reQuWLon/HbV6GUSLtsWFZnpx424JOz3l8WSFYJ9WVw19jssvHepafcZMyOkOCkxKf3EIX6Y2V39HzKWhUVAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igaD58Gk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAD4C2BC86
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769690684;
	bh=sItoRfinWc5/6cVlJRK4RojKxBdMuHNZCqTy0Zi2CbE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=igaD58Gkx1L90B/9A/e6y93bkZWSSe9jbXLgnQrpvYDaQKiQ1trMUT+jWqVAKP+cS
	 bcS5YBbcUUyny1DMPmX4rWF60kiTJMIA+dImLWU3IOX9jwA9jvVdqtzsGYxWf8cfMV
	 qf+V5GCqLneMJtu6lCu5fQVYzuaB/NtKEAvCxOpfzM9t8YGVQO+gSycIFFnMsOEHsL
	 YkEUdLWpW8DFDtro3/IRhirJnkYINv9aTR9l9+XAXhNPJtFRSBNZeWeHmOQRfVO8Eg
	 njTK+Yl0cftEOPZh75Jnbb4UQMJcLV8LP0b5cX4+Y+OdoJTlYbyusp4TMNg9THoAxH
	 d7NWdju1qS4Lw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b883787268fso142917266b.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 04:44:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV7WyMr2D90D+e232WT9I4jy0OkpP2av0oLnmGcAZJ0IwizLw0TVO4GM44V7ZJMrhi3BC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8/4t6bBFs4Suz3NFmOFTsPRO6oUQK4rdgh5waCsf2ZjiSqqml
	0VW6azFXoy/ddEg2iiQo6yYWNsg7xXjjWg9dMObJObVDNQJLeDOQ/pOlKfVBKCdlrWjbMn4QSqK
	HBQTna4ccbItEX2j2DzLmXxFioI3Npv4=
X-Received: by 2002:a17:907:2d26:b0:b87:7042:9aea with SMTP id
 a640c23a62f3a-b8dab1b52d7mr621702366b.18.1769690682563; Thu, 29 Jan 2026
 04:44:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210025623.343511-1-maobibo@loongson.cn>
In-Reply-To: <20251210025623.343511-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 29 Jan 2026 20:44:31 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5pTS0A54gW9mOZxjqXYXcjGx=EXFH6-QO-75T0XoqYsA@mail.gmail.com>
X-Gm-Features: AZwV_QiPqQ9kRNKchDbcYmp9gqeC1OFIctCFcq6d0-KTxXksmGuit15wLsmvaRo
Message-ID: <CAAhV-H5pTS0A54gW9mOZxjqXYXcjGx=EXFH6-QO-75T0XoqYsA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Set default return value in kvm IO bus ops
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69543-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 47F5DB020C
X-Rspamd-Action: no action

Hi, Bibo,

On Wed, Dec 10, 2025 at 10:56=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> When irqchip in kernel is enabled, its register area is registered
> in the IO bus list with API kvm_io_bus_register_dev(). In MMIO/IOCSR
> register access emulation, kvm_io_bus_write/kvm_io_bus_read is called
> firstly. If it returns 0, it shows that in kernel irqchip handles
> the emulation already, else it returns to VMM and lets VMM emulate
> the register access.
>
> Once irqchip in kernel is enabled, it should return 0 if the address
> is within range of the registered IO bus. It should not return to VMM
> since VMM does not know how to handle it, and irqchip is handled in
> kernel already.
>
> Here set default return value with 0 in KVM IO bus operations.
If you are sure that both the good path and bad path should both
return 0, please check whether mail_send() and send_ipi_data() should
also change.

Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 28 ++++++++++++----------------
>  arch/loongarch/kvm/intc/ipi.c     | 10 ++--------
>  arch/loongarch/kvm/intc/pch_pic.c | 31 ++++++++++++++-----------------
>  3 files changed, 28 insertions(+), 41 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index 29886876143f..7ca9dfea7f39 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -119,7 +119,7 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int=
 irq, int level)
>  static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarc=
h_eiointc *s,
>                                 gpa_t addr, unsigned long *val)
>  {
> -       int index, ret =3D 0;
> +       int index;
>         u64 data =3D 0;
>         gpa_t offset;
>
> @@ -150,30 +150,29 @@ static int loongarch_eiointc_read(struct kvm_vcpu *=
vcpu, struct loongarch_eioint
>                 data =3D s->coremap[index];
>                 break;
>         default:
> -               ret =3D -EINVAL;
>                 break;
>         }
>         *val =3D data;
>
> -       return ret;
> +       return 0;
>  }
>
>  static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>                         struct kvm_io_device *dev,
>                         gpa_t addr, int len, void *val)
>  {
> -       int ret =3D -EINVAL;
> +       int ret =3D 0;
>         unsigned long flags, data, offset;
>         struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         offset =3D addr & 0x7;
> @@ -208,7 +207,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *v=
cpu,
>                                 struct loongarch_eiointc *s,
>                                 gpa_t addr, u64 value, u64 field_mask)
>  {
> -       int index, irq, ret =3D 0;
> +       int index, irq;
>         u8 cpu;
>         u64 data, old, mask;
>         gpa_t offset;
> @@ -287,29 +286,28 @@ static int loongarch_eiointc_write(struct kvm_vcpu =
*vcpu,
>                 eiointc_update_sw_coremap(s, index * 8, data, sizeof(data=
), true);
>                 break;
>         default:
> -               ret =3D -EINVAL;
>                 break;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>                         struct kvm_io_device *dev,
>                         gpa_t addr, int len, const void *val)
>  {
> -       int ret =3D -EINVAL;
> +       int ret =3D 0;
>         unsigned long flags, value;
>         struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         vcpu->stat.eiointc_write_exits++;
> @@ -352,7 +350,7 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcp=
u,
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         addr -=3D EIOINTC_VIRT_BASE;
> @@ -383,21 +381,19 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *=
vcpu,
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         addr -=3D EIOINTC_VIRT_BASE;
>         spin_lock_irqsave(&eiointc->lock, flags);
>         switch (addr) {
>         case EIOINTC_VIRT_FEATURES:
> -               ret =3D -EPERM;
>                 break;
>         case EIOINTC_VIRT_CONFIG:
>                 /*
>                  * eiointc features can only be set at disabled status
>                  */
>                 if ((eiointc->status & BIT(EIOINTC_ENABLE)) && value) {
> -                       ret =3D -EPERM;
>                         break;
>                 }
>                 eiointc->status =3D value & eiointc->features;
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.=
c
> index 05cefd29282e..311cbb66821d 100644
> --- a/arch/loongarch/kvm/intc/ipi.c
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -174,7 +174,7 @@ static int any_send(struct kvm *kvm, uint64_t data)
>         vcpu =3D kvm_get_vcpu_by_cpuid(kvm, cpu);
>         if (unlikely(vcpu =3D=3D NULL)) {
>                 kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> -               return -EINVAL;
> +               return 0;
>         }
>         offset =3D data & 0xffff;
>
> @@ -183,7 +183,6 @@ static int any_send(struct kvm *kvm, uint64_t data)
>
>  static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int le=
n, void *val)
>  {
> -       int ret =3D 0;
>         uint32_t offset;
>         uint64_t res =3D 0;
>
> @@ -211,19 +210,17 @@ static int loongarch_ipi_readl(struct kvm_vcpu *vcp=
u, gpa_t addr, int len, void
>                 if (offset + len > IOCSR_IPI_BUF_38 + 8) {
>                         kvm_err("%s: invalid offset or len: offset =3D %d=
, len =3D %d\n",
>                                 __func__, offset, len);
> -                       ret =3D -EINVAL;
>                         break;
>                 }
>                 res =3D read_mailbox(vcpu, offset, len);
>                 break;
>         default:
>                 kvm_err("%s: unknown addr: %llx\n", __func__, addr);
> -               ret =3D -EINVAL;
>                 break;
>         }
>         *(uint64_t *)val =3D res;
>
> -       return ret;
> +       return 0;
>  }
>
>  static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int l=
en, const void *val)
> @@ -239,7 +236,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
, gpa_t addr, int len, cons
>
>         switch (offset) {
>         case IOCSR_IPI_STATUS:
> -               ret =3D -EINVAL;
>                 break;
>         case IOCSR_IPI_EN:
>                 spin_lock(&vcpu->arch.ipi_state.lock);
> @@ -257,7 +253,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
, gpa_t addr, int len, cons
>                 if (offset + len > IOCSR_IPI_BUF_38 + 8) {
>                         kvm_err("%s: invalid offset or len: offset =3D %d=
, len =3D %d\n",
>                                 __func__, offset, len);
> -                       ret =3D -EINVAL;
>                         break;
>                 }
>                 write_mailbox(vcpu, offset, data, len);
> @@ -273,7 +268,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
, gpa_t addr, int len, cons
>                 break;
>         default:
>                 kvm_err("%s: unknown addr: %llx\n", __func__, addr);
> -               ret =3D -EINVAL;
>                 break;
>         }
>
> diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/=
pch_pic.c
> index a698a73de399..773885f8d659 100644
> --- a/arch/loongarch/kvm/intc/pch_pic.c
> +++ b/arch/loongarch/kvm/intc/pch_pic.c
> @@ -74,7 +74,7 @@ void pch_msi_set_irq(struct kvm *kvm, int irq, int leve=
l)
>
>  static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t add=
r, int len, void *val)
>  {
> -       int ret =3D 0, offset;
> +       int offset;
>         u64 data =3D 0;
>         void *ptemp;
>
> @@ -121,34 +121,32 @@ static int loongarch_pch_pic_read(struct loongarch_=
pch_pic *s, gpa_t addr, int l
>                 data =3D s->isr;
>                 break;
>         default:
> -               ret =3D -EINVAL;
> +               break;
>         }
>         spin_unlock(&s->lock);
>
> -       if (ret =3D=3D 0) {
> -               offset =3D (addr - s->pch_pic_base) & 7;
> -               data =3D data >> (offset * 8);
> -               memcpy(val, &data, len);
> -       }
> +       offset =3D (addr - s->pch_pic_base) & 7;
> +       data =3D data >> (offset * 8);
> +       memcpy(val, &data, len);
>
> -       return ret;
> +       return 0;
>  }
>
>  static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
>                         struct kvm_io_device *dev,
>                         gpa_t addr, int len, void *val)
>  {
> -       int ret;
> +       int ret =3D 0;
>         struct loongarch_pch_pic *s =3D vcpu->kvm->arch.pch_pic;
>
>         if (!s) {
>                 kvm_err("%s: pch pic irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: pch pic not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         /* statistics of pch pic reading */
> @@ -161,7 +159,7 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
>  static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t ad=
dr,
>                                         int len, const void *val)
>  {
> -       int ret =3D 0, offset;
> +       int offset;
>         u64 old, data, mask;
>         void *ptemp;
>
> @@ -226,29 +224,28 @@ static int loongarch_pch_pic_write(struct loongarch=
_pch_pic *s, gpa_t addr,
>         case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
>                 break;
>         default:
> -               ret =3D -EINVAL;
>                 break;
>         }
>         spin_unlock(&s->lock);
>
> -       return ret;
> +       return 0;
>  }
>
>  static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
>                         struct kvm_io_device *dev,
>                         gpa_t addr, int len, const void *val)
>  {
> -       int ret;
> +       int ret =3D 0;
>         struct loongarch_pch_pic *s =3D vcpu->kvm->arch.pch_pic;
>
>         if (!s) {
>                 kvm_err("%s: pch pic irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: pch pic not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return ret;
>         }
>
>         /* statistics of pch pic writing */
>
> base-commit: c9b47175e9131118e6f221cc8fb81397d62e7c91
> --
> 2.39.3
>
>

