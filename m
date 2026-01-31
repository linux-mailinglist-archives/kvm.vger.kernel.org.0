Return-Path: <kvm+bounces-69778-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCbcKwMHfmmVUwIAu9opvQ
	(envelope-from <kvm+bounces-69778-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 14:43:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FEEC20F9
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 14:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8CEDC300335F
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 13:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BB02FDC27;
	Sat, 31 Jan 2026 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F32G58Bs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3961F4611
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 13:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769867007; cv=none; b=kpptS25LkOXrVg1pdg3P586kNA6g/Dgum7QCqUHeIcrs9ezSt264xxX98bswbLuMzkEWGdJrQKw0rDp3X4xWT6IaxhT1Plmxpiatbl68lAIXZoMi4rTcqn9uHX+Vo5IGmulkZJZmR84ZVEbM4KXH0S+cV5FbATnOsgolX342oNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769867007; c=relaxed/simple;
	bh=0FQXyzSpmEXk104G6tz4sOpj2YHkOPl5HXkDNBBbL3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X32VKCZwwT3WerluJ6yVxcagqcNZYTiGiIZjgMSMabGQZBH1W1yOeI146w/oF9aOUsZqDL9KtQeGwv4YWt9GswzdnoDUVUCpIWoB/IIJWBZVN3X9J2kdB2yCC29xJkufTrRDij65TWx8uB0ImuUjV9uQIT6wwHRVjprqV+JlPHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F32G58Bs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24DAC16AAE
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769867006;
	bh=0FQXyzSpmEXk104G6tz4sOpj2YHkOPl5HXkDNBBbL3o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F32G58Bsp4i842oc5uQkpoi7RqOhD6Je6kX5E2six/zGSs9q68PQB/vFV7XRT12v4
	 I1KGrnpRz3eds3IYxqhb6J5003Kv5CSe+AuoDypo8wE0TLYVREqviSf8oEyYcgsnIX
	 ymjCAzZJnUtnjWmj5Ezl2gP0nggAQ4QmEF8+ppRuBAcH4iKRWPnjjcqI9Io7rhFjBf
	 Oibm9OKcb77MYWrcTFvTIQRb5J0vEGZRxCDkVTnaeLnkn7fscmCbIpU1+QIVZCcc+y
	 aFptKePElDNW85eOohVCSZtoqpfs+eMSAtrRO/Pv/DEhgZSZboKTTQQ2matEwQxi2Q
	 TjYr7ZA7HKZBw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-658ad86082dso5338523a12.0
        for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 05:43:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWv0pmNZNa+IHo2b84PNOImNAbTeVAi/stfH65KT63KAQf6XUYYMlJ9Vko6bEIFhDDO7rw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd81tlGw7olZWE16fEJYA6z2A6CeOYCP/M3sethGzQQcmfrX2+
	Q5RZWZ3HgdVwuo7dhbxOsWCR4+MwBQihi7urTZD6JUZMay9rtOLpkmM6HtS+cJTNNW3XSBj4GlM
	KWx9vSzhuG5YxzsTRjUMd2hEAsMtE0h8=
X-Received: by 2002:a17:907:3ea6:b0:b87:6f7c:6094 with SMTP id
 a640c23a62f3a-b8dff7a300bmr372696466b.41.1769867005353; Sat, 31 Jan 2026
 05:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130031705.3929925-1-maobibo@loongson.cn>
In-Reply-To: <20260130031705.3929925-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 31 Jan 2026 21:43:04 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7=exv1ZNqzus4R7CTQHqJRbJf48fwmT0x-JMQxC4DKew@mail.gmail.com>
X-Gm-Features: AZwV_QjFginuVxdgzkp-X46Mq8FlLM15K0rNweUjawnwusYvkqgOw8mEA1VWC1c
Message-ID: <CAAhV-H7=exv1ZNqzus4R7CTQHqJRbJf48fwmT0x-JMQxC4DKew@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: KVM: Set default return value in kvm IO bus ops
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69778-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55FEEC20F9
X-Rspamd-Action: no action

Applied, thanks.

But since this patch is applied together with others, you may need to
check whether everything works as expected.


Huacai

On Fri, Jan 30, 2026 at 11:17=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
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
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
> v1 ... v2:
>   1. Set return value with 0 in function mail_send() and send_ipi_data()
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 43 ++++++++++++-------------------
>  arch/loongarch/kvm/intc/ipi.c     | 24 ++++++++---------
>  arch/loongarch/kvm/intc/pch_pic.c | 31 ++++++++++------------
>  3 files changed, 42 insertions(+), 56 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index dfaf6ccfdd8b..e498a3f1e136 100644
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
> @@ -150,40 +150,36 @@ static int loongarch_eiointc_read(struct kvm_vcpu *=
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
>         unsigned long flags, data, offset;
>         struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         offset =3D addr & 0x7;
>         addr -=3D offset;
>         vcpu->stat.eiointc_read_exits++;
>         spin_lock_irqsave(&eiointc->lock, flags);
> -       ret =3D loongarch_eiointc_read(vcpu, eiointc, addr, &data);
> +       loongarch_eiointc_read(vcpu, eiointc, addr, &data);
>         spin_unlock_irqrestore(&eiointc->lock, flags);
> -       if (ret)
> -               return ret;
>
>         data =3D data >> (offset * 8);
>         switch (len) {
> @@ -208,7 +204,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *v=
cpu,
>                                 struct loongarch_eiointc *s,
>                                 gpa_t addr, u64 value, u64 field_mask)
>  {
> -       int index, irq, ret =3D 0;
> +       int index, irq;
>         u8 cpu;
>         u64 data, old, mask;
>         gpa_t offset;
> @@ -287,29 +283,27 @@ static int loongarch_eiointc_write(struct kvm_vcpu =
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
>         unsigned long flags, value;
>         struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         if (addr & (len - 1)) {
>                 kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         vcpu->stat.eiointc_write_exits++;
> @@ -317,24 +311,24 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>         switch (len) {
>         case 1:
>                 value =3D *(unsigned char *)val;
> -               ret =3D loongarch_eiointc_write(vcpu, eiointc, addr, valu=
e, 0xFF);
> +               loongarch_eiointc_write(vcpu, eiointc, addr, value, 0xFF)=
;
>                 break;
>         case 2:
>                 value =3D *(unsigned short *)val;
> -               ret =3D loongarch_eiointc_write(vcpu, eiointc, addr, valu=
e, USHRT_MAX);
> +               loongarch_eiointc_write(vcpu, eiointc, addr, value, USHRT=
_MAX);
>                 break;
>         case 4:
>                 value =3D *(unsigned int *)val;
> -               ret =3D loongarch_eiointc_write(vcpu, eiointc, addr, valu=
e, UINT_MAX);
> +               loongarch_eiointc_write(vcpu, eiointc, addr, value, UINT_=
MAX);
>                 break;
>         default:
>                 value =3D *(unsigned long *)val;
> -               ret =3D loongarch_eiointc_write(vcpu, eiointc, addr, valu=
e, ULONG_MAX);
> +               loongarch_eiointc_write(vcpu, eiointc, addr, value, ULONG=
_MAX);
>                 break;
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
> -       return ret;
> +       return 0;
>  }
>
>  static const struct kvm_io_device_ops kvm_eiointc_ops =3D {
> @@ -352,7 +346,7 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcp=
u,
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return 0;
>         }
>
>         addr -=3D EIOINTC_VIRT_BASE;
> @@ -376,28 +370,25 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *=
vcpu,
>                                 struct kvm_io_device *dev,
>                                 gpa_t addr, int len, const void *val)
>  {
> -       int ret =3D 0;
>         unsigned long flags;
>         u32 value =3D *(u32 *)val;
>         struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
>
>         if (!eiointc) {
>                 kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> -               return -EINVAL;
> +               return 0;
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
> @@ -407,7 +398,7 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vc=
pu,
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
> -       return ret;
> +       return 0;
>  }
>
>  static const struct kvm_io_device_ops kvm_eiointc_virt_ops =3D {
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.=
c
> index 1058c13dba7f..b269c249e037 100644
> --- a/arch/loongarch/kvm/intc/ipi.c
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -111,7 +111,7 @@ static int mail_send(struct kvm *kvm, uint64_t data)
>         vcpu =3D kvm_get_vcpu_by_cpuid(kvm, cpu);
>         if (unlikely(vcpu =3D=3D NULL)) {
>                 kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> -               return -EINVAL;
> +               return 0;
>         }
>         mailbox =3D ((data & 0xffffffff) >> 2) & 0x7;
>         offset =3D IOCSR_IPI_BUF_20 + mailbox * 4;
> @@ -159,10 +159,17 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa=
_t addr, uint64_t data)
>         idx =3D srcu_read_lock(&vcpu->kvm->srcu);
>         ret =3D kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
>         srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +       /*
> +        * There is no way to forward new IOCSR addr and CPU ID to user
> +        * mode VMM, since anysend IOCSR is emulated in kernel already.
> +        *
> +        * Assuming that anysend IOCSR is only used on eiointc routing
> +        * setting
> +        */
>         if (unlikely(ret))
>                 kvm_err("%s: : write data to addr %llx failed\n", __func_=
_, addr);
>
> -       return ret;
> +       return 0;
>  }
>
>  static int any_send(struct kvm *kvm, uint64_t data)
> @@ -174,7 +181,7 @@ static int any_send(struct kvm *kvm, uint64_t data)
>         vcpu =3D kvm_get_vcpu_by_cpuid(kvm, cpu);
>         if (unlikely(vcpu =3D=3D NULL)) {
>                 kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> -               return -EINVAL;
> +               return 0;
>         }
>         offset =3D data & 0xffff;
>
> @@ -183,7 +190,6 @@ static int any_send(struct kvm *kvm, uint64_t data)
>
>  static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int le=
n, void *val)
>  {
> -       int ret =3D 0;
>         uint32_t offset;
>         uint64_t res =3D 0;
>
> @@ -202,28 +208,23 @@ static int loongarch_ipi_readl(struct kvm_vcpu *vcp=
u, gpa_t addr, int len, void
>                 spin_unlock(&vcpu->arch.ipi_state.lock);
>                 break;
>         case IOCSR_IPI_SET:
> -               res =3D 0;
> -               break;
>         case IOCSR_IPI_CLEAR:
> -               res =3D 0;
>                 break;
>         case IOCSR_IPI_BUF_20 ... IOCSR_IPI_BUF_38 + 7:
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
> @@ -239,7 +240,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
, gpa_t addr, int len, cons
>
>         switch (offset) {
>         case IOCSR_IPI_STATUS:
> -               ret =3D -EINVAL;
>                 break;
>         case IOCSR_IPI_EN:
>                 spin_lock(&vcpu->arch.ipi_state.lock);
> @@ -257,7 +257,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
, gpa_t addr, int len, cons
>                 if (offset + len > IOCSR_IPI_BUF_38 + 8) {
>                         kvm_err("%s: invalid offset or len: offset =3D %d=
, len =3D %d\n",
>                                 __func__, offset, len);
> -                       ret =3D -EINVAL;
>                         break;
>                 }
>                 write_mailbox(vcpu, offset, data, len);
> @@ -273,7 +272,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu=
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
> index 4addb34bf432..a175f52fcf7f 100644
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
> base-commit: 4d310797262f0ddf129e76c2aad2b950adaf1fda
> --
> 2.39.3
>
>

