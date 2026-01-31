Return-Path: <kvm+bounces-69775-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBKNAxvCfWk0TgIAu9opvQ
	(envelope-from <kvm+bounces-69775-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 09:49:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6283FC14C9
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 09:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5F93300C914
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 08:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD439306B37;
	Sat, 31 Jan 2026 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPJMDi4K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E02B2DB7AD
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769849353; cv=none; b=cfIYHf8u4bz0ftUpCHb+WZdnRRJqll/hqcUrcZa1fPP5Zt/eZCqhntiMLjEBVOR/N+xFY1XGHmE4b+6yhpB3kPJqJr5imd+ZnbHSWLx0eUN/KItYJDOVeWQ47OAkywmBJC7I1mFg0wEWhYX5u5RLiTo1eeP1Wz6NqQsRYytW1HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769849353; c=relaxed/simple;
	bh=dGpLK5EUCc7kxrIuKT+VIjH3dXIChnaZ7t34gz+6Iws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ovn+83ta2Mb7tNz3w7VeEWcmAxBARfIBeCo2kXK1njQ0YV5QNivccJPIqkyIX9L3/WftDonstSyFfwVR4SBsHdCkxFXCov6PQh4vtkdrA9BageVoDyM1CnJep9kyadhyTUdlkvdgyAhCAl0tUpfpmQ1eJlMKAZzz4W+UZiZJgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPJMDi4K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79A1C2BCB0
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769849352;
	bh=dGpLK5EUCc7kxrIuKT+VIjH3dXIChnaZ7t34gz+6Iws=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cPJMDi4KTOdp9mLdW89C0sAkKpBSvgv2Je/9qpAjg7VswkbD2HnopxOqP7jsSHu7V
	 n5v8ZjVuK2Ac4+jwBe1ALh0quh2HgUJqUcyZ2Dtn5ezFXuDmqIIX72fP3Ggnh7Rnpn
	 85Zp2Ntr5v4tQgJN5uLi09U9CyIoOJtBVYIUlsIZvtdKDQG2xZVkG7UlM/bS6Nc2nV
	 B63sd++L/Qep9CTy9MP0QrALBNjWtNzY1L3AfXGDAmcteEw3MCbnu1X4EmwQDp2lGC
	 bOVFYTlM5cRP7tTzgBKiDNpDJ9pJUb2KL1P0nRXwL7cMTtboVY58vmCB0lTJ62T7i4
	 Nk35roDsR6DpQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so4098121a12.3
        for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 00:49:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW886H766HciX1IJKfJr1RKS3geIbcCeR5MaIjwtpbpApUbPx4oSg0NbnZuYu7P1CM5GPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpxjY4UAsRHbDtmol1Mch1ekC1TgGsPTimq6jeSbSi36qWBEDt
	EdK7Y8TuTpp1Msni7KQVQLMJppCkbbDwfzJgTM7ZTsNV8kzPpj114RY5az3ZLHEVbMejZCYof3V
	pdMpm8CqehpYgHtRy10w2cwwToBTw+ag=
X-Received: by 2002:a17:907:3e1a:b0:b87:7485:b4a8 with SMTP id
 a640c23a62f3a-b8dff23aab3mr312380166b.0.1769849351173; Sat, 31 Jan 2026
 00:49:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131060600.169748-1-liushuyu@aosc.io>
In-Reply-To: <20260131060600.169748-1-liushuyu@aosc.io>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 31 Jan 2026 16:48:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7g4StjP5fnHVVEyR_xFx9=fg6S9UuHWnPpMV_k=ZVGGw@mail.gmail.com>
X-Gm-Features: AZwV_QgPxFoSfCmMU-FyVI71xlpOxVZW5UWuDu6-xVqczdI4YRz8mS_EVp-09Zw
Message-ID: <CAAhV-H7g4StjP5fnHVVEyR_xFx9=fg6S9UuHWnPpMV_k=ZVGGw@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: Zixing Liu <liushuyu@aosc.io>
Cc: WANG Xuerui <kernel@xen0n.name>, Bibo Mao <maobibo@loongson.cn>, 
	Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69775-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6283FC14C9
X-Rspamd-Action: no action

Hi, Zixing,

On Sat, Jan 31, 2026 at 2:07=E2=80=AFPM Zixing Liu <liushuyu@aosc.io> wrote=
:
>
> This ioctl can be used by the userspace applications to determine which
> (special) registers are get/set-able in a meaningful way.
>
> This can be very useful for cross-platform VMMs so that they do not have
> to hardcode register indices for each supported architectures.
>
> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
> ---
>  Documentation/virt/kvm/api.rst |  2 +-
>  arch/loongarch/kvm/vcpu.c      | 85 ++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 01a3abef8abb..f46dd8be282f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>  ---------------------
>
>  :Capability: basic
> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_reg_list (in/out)
>  :Returns: 0 on success; -1 on error
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 656b954c1134..ed11438f4544 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1186,6 +1186,73 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_=
vcpu *vcpu,
>         return ret;
>  }
>
> +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64 __user *ui=
ndices)
> +{
> +       unsigned int i, count;
> +
> +       for (i =3D 0, count =3D 0; i < CSR_MAX_NUMS; i++) {
> +               if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
> +                       continue;
> +               const u64 reg =3D KVM_IOC_CSRID(i);
> +               if (uindices && put_user(reg, uindices++))
> +                       return -EFAULT;
> +               count++;
> +       }
> +
> +       return count;
> +}
> +
> +static unsigned long kvm_loongarch_num_lbt_regs(void)
> +{
> +       /* +1 for the LBT_FTOP flag (inside arch.fpu) */
> +       return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
> +}
This function has only one line, I think it is better to embed it into
the caller.

Huacai

> +
> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
> +{
> +       /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
> +       unsigned long res =3D
> +               kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS=
 + 1;
> +
> +       if (kvm_guest_has_lbt(&vcpu->arch))
> +               res +=3D kvm_loongarch_num_lbt_regs();
> +
> +       return res;
> +}
> +
> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
> +                                         u64 __user *uindices)
> +{
> +       u64 reg;
> +       unsigned int i;
> +
> +       i =3D kvm_loongarch_walk_csrs(vcpu, uindices);
> +       if (i < 0)
> +               return i;
> +       uindices +=3D i;
> +
> +       for (i =3D 0; i < KVM_MAX_CPUCFG_REGS; i++) {
> +               reg =3D KVM_IOC_CPUCFG(i);
> +               if (put_user(reg, uindices++))
> +                       return -EFAULT;
> +       }
> +
> +       reg =3D KVM_REG_LOONGARCH_COUNTER;
> +       if (put_user(reg, uindices++))
> +               return -EFAULT;
> +
> +       if (!kvm_guest_has_lbt(&vcpu->arch))
> +               return 0;
> +
> +       for (i =3D 1; i <=3D kvm_loongarch_num_lbt_regs(); i++) {
> +               reg =3D (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
> +               if (put_user(reg, uindices++))
> +                       return -EFAULT;
> +       }
> +
> +       return 0;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>                          unsigned int ioctl, unsigned long arg)
>  {
> @@ -1251,6 +1318,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>                 r =3D kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>                 break;
>         }
> +       case KVM_GET_REG_LIST: {
> +               struct kvm_reg_list __user *user_list =3D argp;
> +               struct kvm_reg_list reg_list;
> +               unsigned n;
> +
> +               r =3D -EFAULT;
> +               if (copy_from_user(&reg_list, user_list, sizeof(reg_list)=
))
> +                       break;
> +               n =3D reg_list.n;
> +               reg_list.n =3D kvm_loongarch_num_regs(vcpu);
> +               if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
> +                       break;
> +               r =3D -E2BIG;
> +               if (n < reg_list.n)
> +                       break;
> +               r =3D kvm_loongarch_copy_reg_indices(vcpu, user_list->reg=
);
> +               break;
> +       }
>         default:
>                 r =3D -ENOIOCTLCMD;
>                 break;
> --
> 2.52.0
>

