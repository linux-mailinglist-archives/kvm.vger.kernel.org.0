Return-Path: <kvm+bounces-71939-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GA6oIuYDoGl/fQQAu9opvQ
	(envelope-from <kvm+bounces-71939-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:27:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E431A287C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8635A3016245
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86155392813;
	Thu, 26 Feb 2026 08:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LysNGSM9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA12C030E
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 08:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094427; cv=pass; b=GaRM6yfGlMzHhjjH37xKsQ4NrXxlNEeZxJpIc2tf2VttHpEsQx6lUHaEAy4odmz0iXc8cRDNfdoymAjDc8t8/jyFjX4gj0K4F/TkJi+/fHMVw8s/uFQ+VOegtBx3in2gd0F8Pr58Mmj/u/PQfxolbW+yC/J8IMTt4oFNmavXvF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094427; c=relaxed/simple;
	bh=2o+bjei2Cc1VfUeXi4VoXfkTh3LWWyXCHammR1eAMng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYtZDE/PK8C4W/opl0JR1ROaP24neD9CxoZP1+GJchlqpWzwX1b4pHb1eJbJGrdRsNEvBFg2sOfp6HIBfWg66cs69fciWcMjM2DgqRmtvYCvGdMWtzG4aRIKPiPA2/JGtGErnG4kdCwKt47P9q7hIGRKaplCfSH6c3zGNprvjeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LysNGSM9; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4638e6bb8a5so241818b6e.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 00:27:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772094425; cv=none;
        d=google.com; s=arc-20240605;
        b=hIRQ7PvMrebN644r/CNCZeLPo9PG/xNc5jU33ZRC6xbAi6awZSWPezh4gikZN0F9nc
         RWp/A0Q6qz4irLHYhhtO6r4dBX2KNkJsE9OBr2I6yZWyap7GyohtFyR9C6Yf5DL0fRer
         yNPAJ8th9sgFDHy/pIn0Y3RPEZen0c12PiaS5g00OxTFqUcHlQLgwRqr+vuBVmRpAzb1
         Oiv+yhyO08bAAQ9x5cxuIXQLsoLaCwjGSjGMQ5KgMb256RD7UszrB2ToZ/Yl5nDTAA7w
         NDnczn5nrUYmeycAS+K0Bn/8ARKI+HfW8cy9J61GTAjAEwFFTwxk59tGSxCpHrvhhkLT
         T8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c/ICbugoA6WizD9YzJqu5d/QsSy74tGoyiRxnjKunfQ=;
        fh=fVNW1LBEXw1/cslpjUJ4D69iBbqzP8+P4+ICyeSBbRk=;
        b=HCe++hPuLTqg4MaHVKrUyNrEagATieDBtq6NtADD7PcFhORdYVNU78xj1iMWShIVAc
         EVogCCRgSqlEsJdgJGs20JYIXYnothVoBX/Ux7LwunYm/TBuWZMfqB0ElIihhwlGsQwk
         t4bAEa4ZXSafqU8TfVS0l6SKafWHDfChGbPGmPc4Kr4+1VXtu3AJJrAzow15vyJknD2B
         uv4Jero4XZqdzLjOLH45Kedj6updREub1ntvVOETL57YaVzl3lL+l2weumPawSFa85K0
         w0rLkTmH5BzWGnk2JpYT2Arq6fFDyacKJ9ThBFGwx+9wpuHlVerA+9FKznLT3i95sUhW
         LFzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772094425; x=1772699225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/ICbugoA6WizD9YzJqu5d/QsSy74tGoyiRxnjKunfQ=;
        b=LysNGSM9Sjc31FF252stWBg1ObEmJEocO+93PSAfQCdBw8mmd/kXQdi646lVsxcXE+
         iumX80e/Cwd4v1nx9N8V4BT6WmtwVnPr51vfNd/pQ4iW0aJ2WNDcNE+ov7+N/CN+lgKJ
         NpgNYXECY2c17JuUXCXpQLz2oHwgQFSgkhkZ0DXKY/DDKPJbCQx1KUjawAr/U5jXrasF
         WO/Ywj+0JgAgI1qe3jpAoGoNKgzuAm0QRTYsL88A9pgIrAh03W6dktpkY0Z1mS+p+8aB
         85Ymr8ymWQuFDEDI9ju8eix/2DU1Uhl+OhkE+kIOnwUfQq52pg3uNQHNxDRYFwq6HjmI
         vz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772094425; x=1772699225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c/ICbugoA6WizD9YzJqu5d/QsSy74tGoyiRxnjKunfQ=;
        b=UksndaG1MPq/N4kZqxXlQfbJ0ucMh0HuNZ6FlPpcLnbTFx1GJex4oaLyIZ1SqnDJzU
         se2Uu2N4/00NIhOYpQ5WJ2z/FMJQx5WjwhPUsEYPNeCiQq2vwXTy6QdC0kSNpBP1IpbH
         V9fRr6Z4sbJ35/Hrj2iMSXMlKE/LyR1f5luYJ32rdnuNyMn7aMt1rESosKSjAzCr/5zM
         cuDEwyzIzKENyXYXV1y9D1MVD5IqOBHJE5S0IsznwQd4lq4gr5rrHbbKKMF1AXWgR76F
         rlSIkD9bO9suGBXqCSP+vHQ+viF7i+Wv/unKt/Lbd5/aJaV3nRunhXOURJJGMemlKFkX
         92SA==
X-Forwarded-Encrypted: i=1; AJvYcCXZdpqG98FeDkPVyAUjefukLc4N8IcK2n5hCvZwlYK1rqpbeqXXQ+knD3pwxNWX2n5F3pk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsVceQhDNEBj3VYoe+G5p3zBVzdAr0Lvk2+m2QWSJx0oWKLLEC
	dZsW6aKdrUGp5btt0z3jmkfevJh8ogdsoaqAYKYIbc2DKTTaOUZ++LMXu88A6l+6Nne/X3gIZSm
	Y6SGaKDKnEF9QVfn3ozrfrUhhC+7UmG8fzvCl6Uscvb2F0cVyVOJkeOK8YA==
X-Gm-Gg: ATEYQzwKFsOk9IwTEMPYU2hvuuCFCL4BApeiKqunmJ3HdvEQ1kp25dmylbcgVYvBRhr
	EM8BbLL8Umr08Zh38CGr9ey+T8ifQrNGxee9dbR3e3Mu48qvzpLCxngMbC+QY/C/+lq905njuld
	FXIQUTxR5+cP+eYdl+IJJr86uXtjZe6LsdrhqLvvtGql9E0QJtq1kdrI6/CmL9pLbTLd9u1qvtl
	hrVXVs2Lov3gp7sxXtB7O0o+b8c1vW4bk4Ks0h/bAQKToMQTcAGsfg/S8bZD9hPt7r+3Lzu1bOx
	+cXgCugHoFz/TkSHWmfX1dSBhDUT4RvX/8IiW10OoLI3hf4BaWfeTvY/pQeC1VwgrpREpeZPydn
	qB2dFa/uoJSXzTrApYKC9puXyaqE=
X-Received: by 2002:a05:6820:3089:b0:662:e066:73a1 with SMTP id
 006d021491bc7-679ef99f2b5mr1441047eaf.57.1772094425138; Thu, 26 Feb 2026
 00:27:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202040059.1801167-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260202040059.1801167-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 26 Feb 2026 13:56:54 +0530
X-Gm-Features: AaiRm50zPpJQ_8TX6H_H2wb8v6zCwRfi4OTEl3SKr95vU0yOnW4cyE4K-Z1oy2I
Message-ID: <CAAhSdy3V2kipH8sPzXkmnXP=Sh=7wwqhHaAWDyucJnytbL+qtw@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Fix use-after-free in kvm_riscv_gstage_get_leaf()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atish.patra@linux.dev>, Jiakai Xu <jiakaiPeanut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71939-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 02E431A287C
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 9:31=E2=80=AFAM Jiakai Xu <xujiakai2025@iscas.ac.cn>=
 wrote:
>
> While fuzzing KVM on RISC-V, a use-after-free was observed in
> kvm_riscv_gstage_get_leaf(),  where ptep_get() dereferences a
> freed gstage page table page during gfn unmap.
>
> The crash manifests as:
>   use-after-free in ptep_get include/linux/pgtable.h:340 [inline]
>   use-after-free in kvm_riscv_gstage_get_leaf arch/riscv/kvm/gstage.c:89
>   Call Trace:
>     ptep_get include/linux/pgtable.h:340 [inline]
>     kvm_riscv_gstage_get_leaf+0x2ea/0x358 arch/riscv/kvm/gstage.c:89
>     kvm_riscv_gstage_unmap_range+0xf0/0x308 arch/riscv/kvm/gstage.c:265
>     kvm_unmap_gfn_range+0x168/0x1fc arch/riscv/kvm/mmu.c:256
>     kvm_mmu_unmap_gfn_range virt/kvm/kvm_main.c:724 [inline]
>   page last free pid 808 tgid 808 stack trace:
>     kvm_riscv_mmu_free_pgd+0x1b6/0x26a arch/riscv/kvm/mmu.c:457
>     kvm_arch_flush_shadow_all+0x1a/0x24 arch/riscv/kvm/mmu.c:134
>     kvm_flush_shadow_all virt/kvm/kvm_main.c:344 [inline]
>
> The UAF is caused by gstage page table walks running concurrently with
> gstage pgd teardown. In particular, kvm_unmap_gfn_range() can traverse
> gstage page tables while kvm_arch_flush_shadow_all() frees the pgd,
> leading to use-after-free of page table pages.
>
> Fix the issue by serializing gstage unmap and pgd teardown with
> kvm->mmu_lock. Holding mmu_lock ensures that gstage page tables
> remain valid for the duration of unmap operations and prevents
> concurrent frees.
>
> This matches existing RISC-V KVM usage of mmu_lock to protect gstage
> map/unmap operations, e.g. kvm_riscv_mmu_iounmap.
>
> Fixes: dd82e35638d67f ("RISC-V: KVM: Factor-out g-stage page table manage=
ment")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V1 -> V2: Removed kvm->mmu_lock in kvm_arch_flush_shadow_all().
>
>  arch/riscv/kvm/mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index a1c3b2ec1dde5..1d71c1cb429ca 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -268,9 +268,11 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm=
_gfn_range *range)
>         gstage.flags =3D 0;
>         gstage.vmid =3D READ_ONCE(kvm->arch.vmid.vmid);
>         gstage.pgd =3D kvm->arch.pgd;
> +       spin_lock(&kvm->mmu_lock);

Unconditionally locking mmu_lock over here cause following crash
when powering off the KVM Guest.

[   88.985889] rcu: INFO: rcu_sched self-detected stall on CPU
[   88.986721] rcu:     1-....: (5249 ticks this GP)
idle=3D9184/1/0x4000000000000000 softirq=3D175/175 fqs=3D2223
[   88.987816] rcu:     (t=3D5250 jiffies g=3D-791 q=3D31 ncpus=3D4)
[   88.988993] CPU: 1 UID: 0 PID: 78 Comm: lkvm-static Not tainted
7.0.0-rc1-00002-gf242f3f353e6-dirty #3 PREEMPTLAZY
[   88.989294] Hardware name: riscv-virtio,qemu (DT)
[   88.989401] epc : queued_spin_lock_slowpath+0x54/0x474
[   88.990144]  ra : do_raw_spin_lock+0xaa/0xd0
[   88.990182] epc : ffffffff80bc7404 ra : ffffffff800893ea sp :
ff200000003bb8d0
[   88.990213]  gp : ffffffff81a32490 tp : ff60000002360c80 t0 :
616d6e755f6d766b
[   88.990231]  t1 : 00000000fffff000 t2 : 70616d6e755f6d76 s0 :
ff200000003bb8e0
[   88.990286]  s1 : 00007fff7f600000 a0 : 0000000000000000 a1 :
ff600000047b7000
[   88.990304]  a2 : 00000000000000ff a3 : 0000000000000000 a4 :
0000000000000001
[   88.990322]  a5 : ff600000047b7000 a6 : ffffffff81876808 a7 :
80000000fffff000
[   88.990341]  s2 : ff600000047b7000 s3 : ff600000047b7a90 s4 :
0000000000000000
[   88.990359]  s5 : 00007fff8f600000 s6 : 0000000000000001 s7 :
0000000000000001
[   88.990378]  s8 : 0000000000000fff s9 : ff600000047b7488 s10:
ffffffffffffffe0
[   88.990396]  s11: ff60000003b8e050 t3 : ffffffff81a49eb7 t4 :
ffffffff81a49eb7
[   88.990433]  t5 : ffffffff81a49eb8 t6 : ff200000003bb728 ssp :
0000000000000000
[   88.990451] status: 0000000200000120 badaddr: 0000000000000000
cause: 8000000000000005
[   88.990581] [<ffffffff80bc7404>] queued_spin_lock_slowpath+0x54/0x474
[   88.990696] [<ffffffff80bc704e>] _raw_spin_lock+0x1a/0x24
[   88.990917] [<ffffffff01ab4a58>] kvm_unmap_gfn_range+0x98/0xc8 [kvm]
[   88.991415] [<ffffffff01aa5d22>]
kvm_mmu_notifier_invalidate_range_start+0x17e/0x324 [kvm]
[   88.991608] [<ffffffff8027f6da>]
__mmu_notifier_invalidate_range_start+0x62/0x1bc
[   88.991635] [<ffffffff8022d554>] unmap_vmas+0x120/0x134
[   88.991654] [<ffffffff8024cc0a>] unmap_region+0x76/0xc0
[   88.991675] [<ffffffff8024cd18>] vms_complete_munmap_vmas+0xc4/0x1c0
[   88.991695] [<ffffffff8024dd5e>] do_vmi_align_munmap+0x152/0x178
[   88.991716] [<ffffffff8024de24>] do_vmi_munmap+0xa0/0x148
[   88.991736] [<ffffffff8024f4b2>] __vm_munmap+0xaa/0x140
[   88.991757] [<ffffffff802389c8>] __riscv_sys_munmap+0x38/0x40
[   88.991778] [<ffffffff80bbb048>] do_trap_ecall_u+0x260/0x45c
[   88.991812] [<ffffffff80bc87a0>] handle_exception+0x168/0x174

Instead, we should only take mmu_lock if it was unlocked previously.

Something like this ...

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 0b75eb2a1820..87c8f41482c5 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -245,6 +245,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
        struct kvm_gstage gstage;
+       bool mmu_locked;

        if (!kvm->arch.pgd)
                return false;
@@ -253,9 +254,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct
kvm_gfn_range *range)
        gstage.flags =3D 0;
        gstage.vmid =3D READ_ONCE(kvm->arch.vmid.vmid);
        gstage.pgd =3D kvm->arch.pgd;
+       mmu_locked =3D spin_trylock(&kvm->mmu_lock);
        kvm_riscv_gstage_unmap_range(&gstage, range->start << PAGE_SHIFT,
                                     (range->end - range->start) << PAGE_SH=
IFT,
                                     range->may_block);
+       if (mmu_locked)
+               spin_unlock(&kvm->mmu_lock);
        return false;
 }

I have take care of this and queued as fix for Linux-7.0-rcX

Regards,
Anup

