Return-Path: <kvm+bounces-71923-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMRzBYThn2lLegQAu9opvQ
	(envelope-from <kvm+bounces-71923-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:00:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F8C1A12F9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF75630530D0
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E375738B7B4;
	Thu, 26 Feb 2026 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="TrcK5QuN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B24275861
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772085616; cv=pass; b=EmDtPuCyGWaQV4iR4SJ3q4yJ8RRcaJvuBmpDmAwY+xG7MviRb/+YqqCvHWALfsWtmeveIZ58qoZocG86yRe79IY0VKfxdAziPil3NDyar4FNGUH1+eIMXGCmVaEAufGS/b8B0aJzf7/BnYsiw6Nt4Eye9EwTwbdBcu5vD8gRcH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772085616; c=relaxed/simple;
	bh=2WgJ+rsw1uOs2bVa4GzraWY8ffn2xDflBFr12Yxv98Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtR9keSKWnNd+vLbdytdcYN5YaUFPguoz86QbN85q/fD8AAvQC0/w5+RpaRamAouBa1C8lH9cMFi8fPzdy5kGGPankoJDQsy6DX53JGlwxlfire6wQbWLMdzeAvNzQeGtvZaIQI+IW6IPGgphnBw3cSINWj+Aoh2k+jTy4llrA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=TrcK5QuN; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-662fe3ff6f6so400752eaf.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 22:00:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772085613; cv=none;
        d=google.com; s=arc-20240605;
        b=MD7RF+2aR+dZDCGqIwcdNx2nxyhdXM47rAEJ1Dw3He/MQDMOCJNGp620NlemmGzKtl
         qmor+IqxesGn0HYffOcK1zCG6sjSg8Eb8cl2fftZc7L00lFs+KCPfeUTsz0lwOU/9aDH
         YyZP9+h0vc/mIAoeLvSifbNFeVX7apdv+JB2eILLDbXuFBQguGJboX4Fxslo5qaAf29D
         PdMBoL9K9PYJhtoCxnKbomRB6Dw35xwC7b8zGEH/knPBbkIPpU5Pvtd2ryKN2PaV8qBy
         onIoFfjJsOPIDWi0jMKq+be23fXypNhhnC7JYH2UVngbBiMvWsOPo3oVTKEc9rK3llGB
         gbJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aaBkiCbKFk+jtOcOhydSv18/ATIpNF+APtbum9WdzSk=;
        fh=hDSP9cbIUO5VCKXxcSRa+RZtSy1NJ8DIdRNigRPSYFY=;
        b=iz3bVKg6dzIZzRVIY4OcPyMeJzwvtx2OFuKLhDt9s32EV2CXjj/3Cul0r93nfamKgA
         Ft8I4bN7ILmioCddUD66Pq9RFyX3CJNIzRrfo7jKXW8rV8QpbL5gz1I2jbKsK6j4WlPp
         dkCnpKgaaDNgfhqnNlyy6JieziQhvoQ0ktIALu/xX8YUGLn9cpzc5+/EGrJfOI4QR5eh
         O3OP2ldkLl4thn3t6+f/iWSqpNtYQE/Y/zqzwrA7Fgw5uWS/4KiySGKgjzMW+8MwIdaL
         b0cTk2gl9BP6SUzPqmYPJCLHBAL2HHTUslpFocUc5mwarXPD38+K95XM09UHLEaUliUp
         PW1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772085613; x=1772690413; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaBkiCbKFk+jtOcOhydSv18/ATIpNF+APtbum9WdzSk=;
        b=TrcK5QuNnpV8L9ezYdDJ33jIFyNqjzHmwpGPZMUFamXJD5hsFzOdlz9b0Bg+TWHd1J
         pbBkdZdrOcemNdKlOZApkIh1SslraICjFQeBQ2b7YMqHlJcasOd3FM6lYy5Bxxkl2Iiw
         S8VljDDSJewB/RRA3ebaOZ3ZcWKCO+aI93VkdXattiLJZWSRf1XZYLO085ziE1p2AxUr
         cJSeGgpH6SJbA9PlYtoMXNlmip7/bCjK7t7hzAIqnNQaAbJ2I/F59Uf7kUdG9I/o+w2R
         BsTyU4JlQONnOd5bySolw9ZuueNDbgmvk0c3smUXAfETO6HnTOlKybcap2W/PwJ2pDkL
         eO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772085613; x=1772690413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aaBkiCbKFk+jtOcOhydSv18/ATIpNF+APtbum9WdzSk=;
        b=k6QhdvqNtPOEATb9BfQxDxYfB+r+yRh9PIk8NKfMeehFDCyVRuthnDETMfWiODkWcl
         FYz7GBeeNLViSa+ZOFgO/mH14NE0TSq3hnVE2dqwMjY/PFBcUdjE6+RR6Vvdg1+YyEoN
         qG91Jhyvf7B0lWya6+yfaBLBJzjNz8LxiU8epsALBoKgusLDicWm5R/goipYmHEu9lFv
         xoTzNHIGKQJc35mY8ULqZV7peTux2e58FbvnlvjN5rWzHhnYH0tYIcZhxoi3+XLBGWzv
         pNIw8tX1iHYp3fXjPu1UcAuWNzcx1oHSbo3/MqqXZ9PaYogJe7ZKV3578s37IXbWXWwh
         Sr+w==
X-Forwarded-Encrypted: i=1; AJvYcCX3W+CSBa1TUmW3fi5IfOM+pURG9VwJWs2zsKP+GfEjCJVAztjDmwqsSa2MbJ34qsGEntg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKhERzXTQoXNSS/rLORvbP1/z09HIaoaPkTbcFfPBzkNr7AP3n
	ND3n0cIqM21mY6bRU4GsH/UgYhTymnUCdkxbnGn4oUUOf5hQHmvciV15N4Ztk8ZnaQQNzEaTmFD
	g3X+xu1gALFUdthQ1f4/553h6BcFDN8yOWyaz0lhBhA==
X-Gm-Gg: ATEYQzz0jUd9QgBqDsjQMR6G3B3ZG6lVe6O4rczFCcX222K8U+rkjxeTGTBTnSAs3DN
	9ydAWf1AqoR67GYOxI2z5yt2xVZQrMgLUI/o9lKzNgoGhNdhn8DTnLQoqf34WBezxSshOj3+Mxj
	FXUlVrOSK/5gWXP4cLyZHVocNDfIgdVMw29g6oi0aQlUmOa7Nnfo2nnmwjcQ4vtZV1giYN8XnlD
	qSMxdvLLd99JrtUzqLASgPmVZCga/JGVhyXTDUPM0VvwKTs8qh5lPJk9MP0tSE3lDWw7A1DnIo7
	i75OcmV3fVUAzL+tS/l+Yh2Anryf3law9iqiBxiZJGRSrZ3i0I2+9vkVqM+jM56AZKUn1qr9xXp
	8+EqP6TRzsfHIkFY3EoW6vxpMn70=
X-Received: by 2002:a05:6820:4611:b0:679:9646:69c1 with SMTP id
 006d021491bc7-679c47190e0mr7255747eaf.74.1772085612488; Wed, 25 Feb 2026
 22:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130101557.1314385-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260130101557.1314385-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 26 Feb 2026 11:30:00 +0530
X-Gm-Features: AaiRm512q56kQGlC9Rn6Aq0NKfEpD-2Lh4341PKjku_mYqRwWUtpAEUYZ2k0hbU
Message-ID: <CAAhSdy2e4UYBRfU_m6RX-pWBBEv+Wu2Sqngg05FEG195odwhNw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_vcpu_aia_rmw_topei()
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71923-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:email,mail.gmail.com:mid,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 69F8C1A12F9
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 3:46=E2=80=AFPM Jiakai Xu <xujiakai2025@iscas.ac.cn=
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
> Fixes: 2f4d58f7635ae ("RISC-V: KVM: Virtualize per-HART AIA CSRs")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>  arch/riscv/kvm/aia.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad3181856600..c176b960d8a40 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -228,6 +228,10 @@ int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vc=
pu,
>         if (!kvm_riscv_aia_initialized(vcpu->kvm))
>                 return KVM_INSN_EXIT_TO_USER_SPACE;
>
> +       /* If IMSIC vCPU state not initialized then forward to user space=
 */
> +       if (!vcpu->arch.aia_context.imsic_state)
> +               return KVM_INSN_EXIT_TO_USER_SPACE;
> +

This should be part of kvm_riscv_vcpu_aia_imsic_rmw().

Also, Fixes tag should point to:
db8b7e97d6137 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")

>         return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, KVM_RISCV_AIA_IMSIC_TOP=
EI,
>                                             val, new_val, wr_mask);
>  }
> --
> 2.34.1
>

Regards,
Anup

