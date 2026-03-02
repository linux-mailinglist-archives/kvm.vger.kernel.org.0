Return-Path: <kvm+bounces-72340-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMJ2HOIxpWli5gUAu9opvQ
	(envelope-from <kvm+bounces-72340-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 07:44:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAB91D38AF
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 07:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AA0403012B61
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 06:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1FF37BE64;
	Mon,  2 Mar 2026 06:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="cLbPb6NX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8200B21D3CC
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772433887; cv=pass; b=Gav4upeVdw7Fjod/sDwvaB1338xflmC2j28dIzniA4z4l8hJEPv4hmabcqPGXr6nDQIV218mJPnBfQVvFPazYW5l2QIZxcxxeNPIpetTLnc2T2ySPjw01OyyzvKEDfYST9Tl/9ohOy5NGcnfMIZlcAJQsy35erTTJIRpz4L5Kqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772433887; c=relaxed/simple;
	bh=eZAD/6SPiyEYf2e1MUESovq0UQJfZEJgZobJj2rE++8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R77ncry1umMtK3D90SMEq+PKtp+ckKOldLJ39y5JDEWVimE79qngtAbDhaAqVDp8Ow9u5004wQue7Q3dlI9i7ZET6ndADvWLTWmB8qHPsUVAx6bGkWflPec+FSA7vVrQF1NO0M6QMgmwIPaNtr3EHbIju7ESl4pC4YE35PD2/mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=cLbPb6NX; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d18c654458so1954450a34.3
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 22:44:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772433883; cv=none;
        d=google.com; s=arc-20240605;
        b=JloBNqdObBqMWxqTWFuHypLF7acLCa1RLVZ0sxm2JEqE4/R4EuljkXg/96+v5GEW0X
         ZHP+tiAKoxPYqkEeMjw93CWGC2cV9WohPXrFp8IVlCYDBGUJZEdrRgTOUTtNlMfl/rsn
         FvAx5r6+A+4lp8qi+AFlKgShbS/qqPFMSju6nYq3fjfG9CtoztUHvkdEvfsYZHkTbK4x
         8yipI7X8RSfbOnp/ysBFUeTXDEuOw3IW8QTw4A0JIegx4oaY3orKTu1eGE8UaY2O8Un4
         vlc5OixuEdsGHorCOz8LNdja/mRZPmqNEiom7BAcRJHYXi228HJgkrDp1R+ouMv99N4w
         fUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3RopwkNMdoSs/liXGJ2jIDDoeSA3z3pzaorR9wzyeyc=;
        fh=WLNNpbSYOf35gjQQ44EfvhJnM9VvroawDOzakaNcMpM=;
        b=jGi6AIGKVEGdzSBSNuUWkIXxuRLnbMptQSK5q+M1RXApLN8zXm5P6dZhrdzKwb5CJN
         bcuegQIg3tgQ8t0SNKRA1tujCe/v0jsBcsfbVVSUan5c07gRUNd1U6UNKxKmTGjqrkCz
         fThIOIRh4g6nszrENRAnv2cSK7SXeRJTFyVi5lmcQ+TQgOFnO1ASeDVzSx8klWQ8NflO
         BLh8h+h6Sq2qWlo/d7+3AKwixRCOQ7tKv1JJlJRnpLslmaBwkwpdz1sr4u1a8Tdw8VEm
         jgfBME8Ve/JdxrCvigNHgdvhh1pGYU9fhqFJqZ7ApVl8txuscv8Kl6Bdm6wDaHL7Cnvt
         eYoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772433883; x=1773038683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3RopwkNMdoSs/liXGJ2jIDDoeSA3z3pzaorR9wzyeyc=;
        b=cLbPb6NX3/Es7LLdFJzhuFaK2SdtSJ+fI0wERbzUFLR8zuVQ0Dt43dPmKPKnRX9oX+
         jKEPCIulbLI7fPnhGn+wtDPZeRMRz46O8k8se3KFGjeRdqf3hLLAHQcNIvtlX7vjy/El
         n/WO3m9qGg9wS+f0uq4uqlY0Bo5cftHitWZKUC16070Ps5MAeeb+tHpkmOJ6YeTKLC1y
         zU+bYi4Qgr3uIttjS/AZFypVWzwbkKU62v1mrEndQfZHezeIJ0ec8LzOrbjTRc3xiZAc
         uLPz46Voe2xSLFx7LT8XFeEG47mBZzCy7A5it3rjeVsrqMMrYBYtGdTvLEHtYTA5oSqR
         /yTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772433883; x=1773038683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3RopwkNMdoSs/liXGJ2jIDDoeSA3z3pzaorR9wzyeyc=;
        b=h9LyOFyhIY2AZEnoNDss9SVL6bka4bfIPbPtqU9UcbA9/s48j7wFUZ5KDXdkQ3LFB2
         YpLI2hnil+B5G/8/KCvaA3sX+Gg24IZPCuq67w7LSDL+IXY00SXtQKqOWitR8zhMQH4E
         TOgYyTmf+zBI8c2NFj1QMtexxpNm3/lfR4X5h4AUfNLARkXM6Q11QaM96w7HXshQnzCi
         P/TCH73zA4Br0JIakGFn2y0CAWnS68a1e957/inFY3sKSQmbzeRkd4hnZVciSG4XwOM5
         CDev0rB9yszanM9xZfcR7c/+idR+HGZKT56NV0/a5XCjFaT2at8W3DgK5KgGa9e+PM0o
         4knQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqmhtYmci6LanmakYdBdDIFgmaKqX4ounTXs/OxuoFGGb+9RngmcUes9ddZIihn/Zeurg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjaS9gKowvZvyXtSbsuxNdmm/dEIGw0v5upT5PKvo/XmtBl1AO
	R8ORyyrXFY2hoSh40zRNNBXgp+swrTtWbsca7EPqMvoTzdSlsWcJr+84X0QUI0GH7+4RfsGO99m
	+voyHj0bc7g9ofW4VoCgaoWagxrIvQctsU6BVjtLCUg==
X-Gm-Gg: ATEYQzwvZnSNH4iUbFTvB7NMJfRIRTLlrNCOcFdP7uQlBaraGrBVHIYVwkhcfVuLdlJ
	6R9Ca0NM3Bpf6Rm9o41ry0l93qpe4PPxp5l0Ft2xtxIT+1SApVtnXepIvnvAcsWTDGRgkGpgfJz
	sezqzqgHZF2Rl2aMcSKs+JslnZCAhe7cI3wYFVVESR5H3IISzJ2LboBVdBTJvjHDGXkgJwqQMDv
	KDustfDxIPvQl8H0bf9VP9YoP3mV3/asDLbnc0qfJ2aGxjieCsXKmAjTFdMLT18sHiVTLtSzzDz
	kDIGqhKBn2zbTiK9e+nhpEnhbJp5v/cVGIVLXZQQacPbzgtL973a/8fZuzKYbyhZbVfL+9InL/3
	Z08pVtAv7IqnaQy2zXVwlY6dIUmg=
X-Received: by 2002:a05:6820:228a:b0:66f:6d5e:76c3 with SMTP id
 006d021491bc7-679faf197f4mr6237763eaf.42.1772433883297; Sun, 01 Mar 2026
 22:44:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131025800.1550692-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260131025800.1550692-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 12:14:32 +0530
X-Gm-Features: AaiRm51UWawvMQ4W_XFS-euBUvc7zaH49mHMd54aVoS7NYUqeGJ1N7c5kzY8Sjc
Message-ID: <CAAhSdy1x=4J2fZA-U_nB2yvFP38rmdcwVqYsR7c_6kHQw56+ew@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Change imsic->vsfile_lock from rwlock_t to raw_spinlock_t
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atish.patra@linux.dev>, Jiakai Xu <jiakaiPeanut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72340-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.992];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0CAB91D38AF
X-Rspamd-Action: no action

On Sat, Jan 31, 2026 at 8:28=E2=80=AFAM Jiakai Xu <xujiakai2025@iscas.ac.cn=
> wrote:
>
> The per-vCPU IMSIC context uses a vsfile_lock to protect access
> to the VS-file. Currently, this lock is an rwlock_t, and is used
> with read_lock_irqsave/write_lock_irqsave in multiple places
> inside arch/riscv/kvm/aia_imsic.c.
>
> During fuzz testing of KVM ioctl sequences, an
> "[BUG: Invalid wait context]" crash was observed when holding
> vsfile_lock in certain VCPU scheduling paths, for example during
> kvm_riscv_vcpu_aia_imsic_put(). Log shows that at this point
> the task may hold vcpu->mutex and scheduler runqueue locks,
> and thus is in a context where acquiring a read/write rwlock
> with irqsave is illegal.
>
> The crash manifests as:
>   [ BUG: Invalid wait context ]
>   (&imsic->vsfile_lock){....}-{3:3}, at:
>   kvm_riscv_vcpu_aia_imsic_put arch/riscv/kvm/aia_imsic.c:728
>   ...
>   2 locks held by syz.4.4541/8252:
>    #0: (&vcpu->mutex), at: kvm_vcpu_ioctl virt/kvm/kvm_main.c:4460
>    #1: (&rq->__lock), at: raw_spin_rq_lock_nested kernel/sched/core.c:639
>    #1: (&rq->__lock), at: raw_spin_rq_lock kernel/sched/sched.h:1580
>    #1: (&rq->__lock), at: rq_lock kernel/sched/sched.h:1907
>    #1: (&rq->__lock), at: __schedule kernel/sched/core.c:6772
>   ...
>   Call Trace:
>    _raw_read_lock_irqsave kernel/locking/spinlock.c:236
>    kvm_riscv_vcpu_aia_imsic_put arch/riscv/kvm/aia_imsic.c:716
>    kvm_riscv_vcpu_aia_put arch/riscv/kvm/aia.c:154
>    kvm_arch_vcpu_put arch/riscv/kvm/vcpu.c:650
>    kvm_sched_out virt/kvm/kvm_main.c:6421
>    __fire_sched_out_preempt_notifiers kernel/sched/core.c:4835
>    fire_sched_out_preempt_notifiers kernel/sched/core.c:4843
>    prepare_task_switch kernel/sched/core.c:5050
>    context_switch kernel/sched/core.c:5205
>    __schedule kernel/sched/core.c:6867
>    __schedule_loop kernel/sched/core.c:6949
>    schedule kernel/sched/core.c:6964
>    kvm_riscv_check_vcpu_requests arch/riscv/kvm/vcpu.c:699
>    kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:920
>
> Therefore, replace vsfile_lock with raw_spinlock_t, and update
> all acquire/release calls to
> raw_spin_lock_irqsave()/raw_spin_unlock_irqrestore().
>
> Fixes: db8b7e97d6137a ("RISC-V: KVM: Add in-kernel virtualization of AIA =
IMSIC")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

This patch breaks KVM guest booting when the underlying
KVM host does not have any guest files.
E.g. "qemu-system-riscv64 -M virt,aia=3Daplic-imsic ..."

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_imsic.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index fda0346f0ea1f..8730229442a26 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -47,7 +47,7 @@ struct imsic {
>          */
>
>         /* IMSIC VS-file */
> -       rwlock_t vsfile_lock;
> +       raw_spinlock_t vsfile_lock;
>         int vsfile_cpu;
>         int vsfile_hgei;
>         void __iomem *vsfile_va;
> @@ -597,13 +597,13 @@ static void imsic_vsfile_cleanup(struct imsic *imsi=
c)
>          * VCPU is being destroyed.
>          */
>
> -       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         old_vsfile_hgei =3D imsic->vsfile_hgei;
>         old_vsfile_cpu =3D imsic->vsfile_cpu;
>         imsic->vsfile_cpu =3D imsic->vsfile_hgei =3D -1;
>         imsic->vsfile_va =3D NULL;
>         imsic->vsfile_pa =3D 0;
> -       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         memset(imsic->swfile, 0, sizeof(*imsic->swfile));
>
> @@ -688,10 +688,10 @@ bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct =
kvm_vcpu *vcpu)
>          * only check for interrupt when IMSIC VS-file is being used.
>          */
>
> -       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         if (imsic->vsfile_cpu > -1)
>                 ret =3D !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei))=
;
> -       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         return ret;
>  }
> @@ -713,10 +713,10 @@ void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *=
vcpu)
>         if (!kvm_vcpu_is_blocking(vcpu))
>                 return;
>
> -       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         if (imsic->vsfile_cpu > -1)
>                 csr_set(CSR_HGEIE, BIT(imsic->vsfile_hgei));
> -       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>  }
>
>  void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
> @@ -727,13 +727,13 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vc=
pu *vcpu)
>         struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
>
>         /* Read and clear IMSIC VS-file details */
> -       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         old_vsfile_hgei =3D imsic->vsfile_hgei;
>         old_vsfile_cpu =3D imsic->vsfile_cpu;
>         imsic->vsfile_cpu =3D imsic->vsfile_hgei =3D -1;
>         imsic->vsfile_va =3D NULL;
>         imsic->vsfile_pa =3D 0;
> -       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         /* Do nothing, if no IMSIC VS-file to release */
>         if (old_vsfile_cpu < 0)
> @@ -786,10 +786,10 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu=
 *vcpu)
>                 return 1;
>
>         /* Read old IMSIC VS-file details */
> -       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         old_vsfile_hgei =3D imsic->vsfile_hgei;
>         old_vsfile_cpu =3D imsic->vsfile_cpu;
> -       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         /* Do nothing if we are continuing on same CPU */
>         if (old_vsfile_cpu =3D=3D vcpu->cpu)
> @@ -839,12 +839,12 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu=
 *vcpu)
>         /* TODO: Update the IOMMU mapping ??? */
>
>         /* Update new IMSIC VS-file details in IMSIC context */
> -       write_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>         imsic->vsfile_hgei =3D new_vsfile_hgei;
>         imsic->vsfile_cpu =3D vcpu->cpu;
>         imsic->vsfile_va =3D new_vsfile_va;
>         imsic->vsfile_pa =3D new_vsfile_pa;
> -       write_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         /*
>          * At this point, all interrupt producers have been moved
> @@ -943,7 +943,7 @@ int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsi=
gned long type,
>         isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>         imsic =3D vcpu->arch.aia_context.imsic_state;
>
> -       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>
>         rc =3D 0;
>         vsfile_hgei =3D imsic->vsfile_hgei;
> @@ -958,7 +958,7 @@ int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsi=
gned long type,
>                                             isel, val, 0, 0);
>         }
>
> -       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         if (!rc && vsfile_cpu >=3D 0)
>                 rc =3D imsic_vsfile_rw(vsfile_hgei, vsfile_cpu, imsic->nr=
_eix,
> @@ -1015,7 +1015,7 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu=
 *vcpu,
>         if (imsic->nr_msis <=3D iid)
>                 return -EINVAL;
>
> -       read_lock_irqsave(&imsic->vsfile_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->vsfile_lock, flags);
>
>         if (imsic->vsfile_cpu >=3D 0) {
>                 writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
> @@ -1025,7 +1025,7 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu=
 *vcpu,
>                 imsic_swfile_extirq_update(vcpu);
>         }
>
> -       read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->vsfile_lock, flags);
>
>         return 0;
>  }
> @@ -1081,7 +1081,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *=
vcpu)
>
>         /* Setup IMSIC context  */
>         imsic->nr_msis =3D kvm->arch.aia.nr_ids + 1;
> -       rwlock_init(&imsic->vsfile_lock);
> +       raw_spin_lock_init(&imsic->vsfile_lock);
>         imsic->nr_eix =3D BITS_TO_U64(imsic->nr_msis);
>         imsic->nr_hw_eix =3D BITS_TO_U64(kvm_riscv_aia_max_ids);
>         imsic->vsfile_hgei =3D imsic->vsfile_cpu =3D -1;
> --
> 2.34.1
>

