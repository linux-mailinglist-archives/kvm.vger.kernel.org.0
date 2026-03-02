Return-Path: <kvm+bounces-72347-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IApSEHRMpWmt8AUAu9opvQ
	(envelope-from <kvm+bounces-72347-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:38:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DE36B1D4B7C
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 248053037154
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 08:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E23389E03;
	Mon,  2 Mar 2026 08:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="rM/ghumW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA05F30B50A
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 08:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772440620; cv=pass; b=Cekvcg0UXcK1ucFVEduunduXP+QguTbqszC2SWA4iqLmV4ZIx55wiisFGOxfAkw2omjFbYkKoG4xJWL5Bq9GnaIzYvIxuAiK07SioutwXuGqHr4vWYIWSL74mRt9ZPrEV0OcGlyOuGhCl6fWT88AMgutJmVALj3xdbnthhTcEds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772440620; c=relaxed/simple;
	bh=k1VIICxjU3vJnnytkXrYwQ4qIoKb+3MvgBDTAoyY6cI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QKISNaxR6g3assC169/oCwbMQFVFx7tQtHexkQCoBb+Bop7S6Jn1pDACGlAJmMCCrKjQd3V82gDL6cKtmPnulbm7/dHYL9ZMrTH5m+JX4xdfObQdbMxXveMCKh0uNWaPi7uZfmkz5gGA9TEkZcxs64adq0CVdBj2tTcDCgMHkyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=rM/ghumW; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4c65d772cso3767187a34.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 00:36:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772440618; cv=none;
        d=google.com; s=arc-20240605;
        b=CzN7vVQlLVujONAAPHaBKKa+LYawLPEsKW6kkxszWOrQnL+4rAX0BdAgVw/HGdmobN
         PF+LIkt6ZOfzNQCsjLr/6ym2Th1m/N7THBnwznmApJL2NtFGWhiG5oWQDQ6bWOUhu1ss
         Azjdq3u0TwjiOmP70gv744i5Ep9Cey88fvQm1nzfwnNuDG2bs8jeS5FjoqIVuLy4fGTu
         MgI7weYYmGIYcRrcCmZwf7pimJ5IizzGokpBuXt+PFv4tE/xuZGPgo+yJQ5CjCHKWZ5f
         IAo/HV/nNlDxJqIInm8MQdcbpVgkqn/FymgjdR4Eyd9ucZ78hBrUywPq4m17gz5ROicP
         cZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLKi8ai8IyE30Mtt9VN9pXVX/xYHa5xamiHmWLiG2yo=;
        fh=3C3l6/OmC4XlhwYf7hwMbXlLoPzZgE/rBV2NePN90ts=;
        b=hpF2bSb3EqG/6x7D/gGbfNGhr+2cqkiqMefn/0q/FGmu4/+VqF3OMIL+2VRnv+/F9C
         WWK3WgADZFXiSCXndUKy6rR5nCw/jsEoAyPAULNvghRNbkyhaRael10zLG33LGmoQd78
         Y0HJw0Juw21VaufXoMC8pzmmxQ6l/GhS6J1xSmYxaiKAjlxHeYXwZNrWcqIc06WpKPNn
         0+UK+dNkzxKGWnie6S3mMzDzSmbaDeDg5jqetUD+9HJRfxhqofdaX8pYU8Fy2vthhqDL
         vM/hDbkQCOpnFDE7WHRXMGZcaJQj5Yzx9PeRy83B+NWHWN3/ocaOr51Xki/p02ei2Iln
         0Fpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772440618; x=1773045418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLKi8ai8IyE30Mtt9VN9pXVX/xYHa5xamiHmWLiG2yo=;
        b=rM/ghumWos2J8kKk6CnXxAQqoe1szvw+rsJEJfuNOGnSg3T2q4Z+Z29w1LeWuhOdLR
         vdoUrF/df05AdRYFrJU0TmMWf4fs9B+r6xomEURzMlXdggxu2/C2Qd98tr8ts4y7rK07
         Yj9bSPFq60ZgLQYvLYwgW2DoJRB9yEKbZZnr6rLA8QP0EdmG6TuPEjPVlw13YsL6//sc
         qN6NLV7EsGADukRP7FglvDNa7tCkRJxPH0FB51C3ySf8GCSbEm4tyZxwfjaXqBz47CZv
         wlk2S1eYdfwGgwe34zpEtUXGmH+SQlQGvvsodJ6S1I2H8m8dvgp4yRuqwfko9bRBXHvZ
         /WBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772440618; x=1773045418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qLKi8ai8IyE30Mtt9VN9pXVX/xYHa5xamiHmWLiG2yo=;
        b=NoHJ3lQvUPFDx2frOuf35x8im6dm7FnFjGdO53QrQ0T3Exg9vjVjxkd4mzf06LEffd
         crZv0wNMieZ7P6/qgp8RyapyuKTD7eWlGUogZDGvu0uC9o7gOiolfOY8iy+wpyCbMoHW
         6xMuIQi6+nihtJ7Si1KoX0flU074d2DHpFSWpR9W7y1+MiscPP9zNOKRRlzAH3Qb+pVD
         V4R9c037ImGcZWZypuEH+FoJi0yqpkirNpvJOoq2lqmtNG1DKSnHFigwCIYEe7++ScMS
         n6sCnw/cxpLvZH+d33kNSGP8s00Jc9RAjSnhtgaxrZthITgidwFc2L52Ow6I3IuE1vU/
         OEJw==
X-Forwarded-Encrypted: i=1; AJvYcCXGpdhhNKehOGZA71vVW7PSxdHGHimIX0vKLlBmGUJmD4Q+9H+vUEpl4jSJpElZYJ2s6Ds=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Qzdkricwe+xb4RhQp9xNW4ijmX+AAchqzVcABmygOP+vQZPc
	l0KxlG9z+S+0pmUSlvS2zfAH7TFFbDrcNgVX0vtRS81FLwBhJvNT545I0M5oN2YH9k6ev18XJ//
	wIG+zraouiWUAWsjT9GPxuF0Ouozki3l/CysXP8WD+XWUncTnJa7AH3U=
X-Gm-Gg: ATEYQzw9TzKnl/hnr1RW2SJl7qPbJ4ZBHXoXdAEHteonjEwpzmeqpTXdmInoR+M3NEa
	srwNZ4T7fc2qtap316c7vlYa0kwWJZX/3sLnlMwY+BDQqcVmAxIpgWTVXxxOyS32Dg+1xG4Bc15
	3zqNBbo7ZIhZIm/a/ajZUeMU0Qzmp/cUKiGy3B6za69J1572BBCpvCMZWkovuS6fpvX1wdtRHAo
	o23SCjUi37Dw94QvGdztL5g+wgl8jFR3rVyGkYXrZpIYKu6BazdgZ2WPtPlGTKHobmJk3byMG8j
	pBaGBiHvzQJYlttwqdsmvg1FSzlZ35HiL6IysxxUlIB3W0uW4E1JN4WzxAUwQQ/JNFTj8aFhjB/
	k8LIz+hBzx4kwIhTsQw7j8m5y3p8=
X-Received: by 2002:a05:6820:4810:b0:679:8b1d:ba0f with SMTP id
 006d021491bc7-679faeff7c6mr5220357eaf.39.1772440618592; Mon, 02 Mar 2026
 00:36:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226085119.643295-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260226085119.643295-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 2 Mar 2026 14:06:46 +0530
X-Gm-Features: AaiRm51GI-DugvCRdiijwtodWGn36vtplbYEJJN6taqR6JPTEeVPaXB6mjwDWVE
Message-ID: <CAAhSdy1Ha31-bYFs2DknN00i_boP_2hyaXyqf2UQ+YypC3pefg@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_vcpu_aia_rmw_topei()
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72347-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,brainfault.org:email]
X-Rspamd-Queue-Id: DE36B1D4B7C
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 2:21=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn=
> wrote:
>
> kvm_riscv_vcpu_aia_rmw_topei() assumes that the per-vCPU IMSIC state has
> been initialized once AIA is reported as available and initialized at
> the VM level. This assumption does not always hold.
>
> Under fuzzed ioctl sequences, a guest may access the IMSIC TOPEI CSR
> before the vCPU IMSIC state is set up. In this case,
> vcpu->arch.aia_context.imsic_state is still NULL, and the TOPEI RMW path
> dereferences it unconditionally, leading to a host kernel crash.
>
> The crash manifests as:
>   Unable to handle kernel paging request at virtual address
>   dfffffff0000000e
>   ...
>   kvm_riscv_vcpu_aia_imsic_rmw arch/riscv/kvm/aia_imsic.c:909
>   kvm_riscv_vcpu_aia_rmw_topei arch/riscv/kvm/aia.c:231
>   csr_insn arch/riscv/kvm/vcpu_insn.c:208
>   system_opcode_insn arch/riscv/kvm/vcpu_insn.c:281
>   kvm_riscv_vcpu_virtual_insn arch/riscv/kvm/vcpu_insn.c:355
>   kvm_riscv_vcpu_exit arch/riscv/kvm/vcpu_exit.c:230
>   kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:1008
>   ...
>
> Fix this by explicitly checking whether the vCPU IMSIC state has been
> initialized before handling TOPEI CSR accesses. If not, forward the CSR
> emulation to user space.
>
> Fixes: db8b7e97d6137 ("RISC-V: KVM: Add in-kernel virtualization of AIA I=
MSIC")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch as fixes for Linux-7.0-rcX

Regards,
Anup

> ---
> V1 -> V2: Moved imsic_state NULL check into kvm_riscv_vcpu_aia_imsic_rmw(=
).
>           Updated Fixes tag to db8b7e97d6137.
> ---
>  arch/riscv/kvm/aia_imsic.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index fda0346f0ea1f..60917f4789d84 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -892,6 +892,10 @@ int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vc=
pu, unsigned long isel,
>         int r, rc =3D KVM_INSN_CONTINUE_NEXT_SEPC;
>         struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
>
> +       /* If IMSIC vCPU state not initialized then forward to user space=
 */
> +       if (!imsic)
> +               return KVM_INSN_EXIT_TO_USER_SPACE;
> +
>         if (isel =3D=3D KVM_RISCV_AIA_IMSIC_TOPEI) {
>                 /* Read pending and enabled interrupt with highest priori=
ty */
>                 topei =3D imsic_mrif_topei(imsic->swfile, imsic->nr_eix,
> --
> 2.34.1
>

