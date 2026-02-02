Return-Path: <kvm+bounces-69821-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NFOHqxngGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69821-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:00:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4868C9D9D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81A8C300DA70
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 09:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73624354AE2;
	Mon,  2 Feb 2026 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BMxJ69Tf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40C28689A
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022824; cv=pass; b=dlnSAkY6oOCh96QE6A5FDPujNOihTpi54LkPF6xd7zBHD0azYJD3m47hrs9WX6iRIIaqbZAGmU98WkB15ubsvBtVHB5TLiYKx0QQ7Tn1m4IOEJB6IsGKUOKY7jwJdfsDDHPJ7ur6dLlYucDmV0/GfM06K3WyEffAeUsHddlsxbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022824; c=relaxed/simple;
	bh=JEodHyy2alK2xyjbCAZvg8FB9ORG/DynBi9KzfpnERc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kt5oPL38iyBuTEZYPrmG/USG+YAAPsOh/yr0jX7kF1STjFbKUVTHJTnfAzNqkZoblpCuIoaV9lcaDWR1kHU10IhPsou/StnkgOgettOrmemo90RN1bJcgTDX1w2Sy4DaKFckuF0CEjqrtOkPmiVJdFCgd1Lopcc94tAt8S2RgOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BMxJ69Tf; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b64256dso756311cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 01:00:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770022822; cv=none;
        d=google.com; s=arc-20240605;
        b=Aq4Q2zb+OBlOmK/xDLNd7g/MAZiqnirEpRK+wWTt5+ECX00U++nEHcxZtNL+67lyym
         ME1M8ye1xNnSlpLuDGkqNoh4PZ8e0ZJdljglhuRFjYaWm1W39T5d+uMuw4sUBQJfQ7qA
         l7D7exO9SZowa/BnqAETWOI/frPmuwuknM0z2PH/SUOX4I/P1hpaWZ4PGqhoDx7bdba9
         vxxNmrGRwTTQMSZLwEGmlT3i4+t+got3lGOrhhuWBDSjZW+I+pYQYguDUbjd0O1qwkAK
         K8lPKH931sjW98qpqfXd6X9cu4LwPD17lji7ZlSn9xDLnpg+MwB8rSjGfEPsb/vZZ2Nm
         MaTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        fh=/aJzioEWBnqKuh86Ps8yR5KpFE9bqjPOfJOZSWDCgzk=;
        b=hBgGgH1q+SZaBt8/G2u8FACy1x40JEYeBkI+zDL62eyh/Bi2mAs66WFLXk0iblgWTO
         0baKL+NP6EOT1A6N/sZLJbwgwqYfDB00RyILQokg2I7L+Wzo4EytZkR2Myn4S9lnGn5Y
         ib5btABNHBYWKhiG1UqB1ieQPnWAhDzQBexR75rO5lS7n4Im41147Omk/+yISTdoQcaT
         WGH6EdNCC7wYdj8XDNT/RiBVu0NdWueQKvjLjvDubO/qTZFIXIhdsnAorpcW2452qfth
         iBb98FOOdZTVbPym/P42/1kHMuENvO7O+KUe3EDMA/vwBkKUXRsessyCCM4VSxwOoTUP
         NqLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022822; x=1770627622; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        b=BMxJ69Tf7jAyxrQqLY2SVLR7+M/gnP9DexSzAoK5XlUpchtpM5ceqANqnjr9XtKARA
         fglKJoV+y7kk1LZY3krE3tFv91GInWhQVlRyKiV8V7Sk9lG8OGGJ//np7wFFR1Dv8J8b
         BrNwRzCekHMv/IyZgFZd3M2UGTOrWTh1vN0p3OAFsKHW3r0HBN7njm3Nk+0wb/pVlBvR
         B2yVam2YU5AcwerL6Fs96QEia55jQjyMW6od1iRLL+KCG5C0xYtzWJxa68IWH7GZ8XRO
         1xHKSirWi8lhKuUmCzRBxLuIz1OUnNuSIEN2QkYVlBmWlTdUdnQSPOo7ccAgcSaa7h/F
         5AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022822; x=1770627622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCcD9bj7awZZLZPuAnMOEAmooVssTLmcQS2kNDZinC8=;
        b=ANMXPogaFAUsKhZhu04bDYFCVqmaZq4VRgeXHnZyG4rchSu7IKuU8bZzkr0cxRJ8L8
         JTeUHsuOU377SiYkIJ4GwuhMzgyuemj26ALKJg4O/4tkUnZo+Nc2eVhT8gMXP6x2Gk5l
         RaWKBLRnGAsoa6weYk2OBxNjNjwCbPgxIpFhmSE5VXEqd/F9fPm3TrFaDR9Vl2Gb7SjO
         XaBJ2U+E06I3Ddvbx/QTeFJ6jC1/ZWiYqzEq57AF4NnA7cqIE1kxkaMr+8arr37x5YSL
         spCfuvs+iV+LGRZuVnhPNpoZLaqB2i2ItIh0J2WTQ6H2HoPmAZQBpjgM7BTfzgW3hsj2
         4JXg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ1XtLxhLUy8dQ/+hbIAkt3bfVSEhS0rUEEOOw0zj5qeQMo9jTsRbnK+2PLb0tD925re4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhW9k+eWO/sn5khuq1FoDJcgExPhTuN/0Fn0EVA9D+8P7TuzK0
	3JF17Rlt9TI7q7Phg5t6g5L+7iQkcyBsWUfa2TtfFL+C3FRswzfNwNhPsZuZx5h0TVaXHRPNrk+
	7UO/XpjR8n6iCMxH2b8s/+k6lSvABgD07BTUPTc8P
X-Gm-Gg: AZuq6aK9jO7QiPc9BE2UPhPMCCWJii0YWBdagUySN8wWwYJFqaQ6lOgAaUtNNgg+rBN
	UyqZZq05rSEMUlNo7s+w9NBmhF7lRKl9MXc1Ny+/XYrm/zIrj0WTHdOSpmyP/G3ZaJ+JIj2fFv3
	vaAmasp7mmr9MLjCBVI5GFN+B6ibNZLS8+DGyP2GEPTDF7zx6SNm9agappu4x6mbtLPeUxVgUNu
	mI2UpVgWv1oZdEKO6fJ3kjSja3jgpOudmtA0qxyo4qhiCMNp+Pa79zyYCCedKo4cdcW+ENa
X-Received: by 2002:a05:622a:3d1:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-505dfb30e91mr17084781cf.9.1770022821656; Mon, 02 Feb 2026
 01:00:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-21-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-21-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Feb 2026 08:59:45 +0000
X-Gm-Features: AZwV_QiYpw-7eH_Ok5Bnjv2eot8sO20awaRxhk21veOJg4c86-z9Wey20QWTlg4
Message-ID: <CA+EHjTxAEah7N1myCgc-XRDjSFLiQcYHQtNjLWt=Ns_Rag6vPw@mail.gmail.com>
Subject: Re: [PATCH 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69821-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: E4868C9D9D
X-Rspamd-Action: no action

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Computing RESx values is hard. Verifying that they are correct is
> harder. Add a debugfs file called "resx" that will dump all the RESx
> values for a given VM.
>
> I found it useful, maybe you will too.

I'm sure I will :)

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 98 +++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c82b071ade2a5..54072f6ec9d4b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -375,6 +375,7 @@ struct kvm_arch {
>
>         /* Iterator for idreg debugfs */
>         u8      idreg_debugfs_iter;
> +       u16     sr_resx_iter;

Storing `sr_resx_iter` in `struct kvm_arch` effectively makes this
debugfs file exclusive (returning -EBUSY on contention). Standard
`seq_file` implementations should be stateless, using the `loff_t
*pos` argument to track the index. This allows multiple users to read
the file simultaneously without blocking each other.

>
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 88a57ca36d96c..f3f92b489b588 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5090,12 +5090,110 @@ static const struct seq_operations idregs_debug_sops = {
>
>  DEFINE_SEQ_ATTRIBUTE(idregs_debug);
>
> +static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
> +{
> +       unsigned long i, sr_idx = 0;
> +
> +       for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +               const struct sys_reg_desc *r = &sys_reg_descs[i];
> +
> +               if (r->reg < __SANITISED_REG_START__)
> +                       continue;
> +
> +               if (sr_idx == pos)
> +                       return r;
> +
> +               sr_idx++;
> +       }
> +
> +       return NULL;
> +}
> +
> +static void *sr_resx_start(struct seq_file *s, loff_t *pos)
> +{
> +       struct kvm *kvm = s->private;
> +       u16 *iter;
> +
> +       guard(mutex)(&kvm->arch.config_lock);

My understanding of `guard()` is that it releases the lock as soon as
the current scope ends (i.e., when `sr_resx_start() `returns). If the
intention was to protect the iteration, it seems like `sr_resx_next()`
and `sr_resx_show()` would end up running unprotected. That said,
converting this to a standard `seq_file` implementation should remove
the need for locking altogether.

I guess you based your code on the existing code for the idregs
debugfs. I had a look at that, and at vgic-debug, and I think they
both can be simplified and made more robust [1]. I also have a diff
that converts this to use `seq_file`. It's pretty similar to what I
have for idregs in the series I sent out [2]. Let me know if you'd
like me to share it.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260202085721.3954942-1-tabba@google.com/
[2] https://lore.kernel.org/all/20260202085721.3954942-2-tabba@google.com/




> +
> +       if (!kvm->arch.sysreg_masks)
> +               return NULL;
> +
> +       iter = &kvm->arch.sr_resx_iter;
> +       if (*iter != (u16)~0)
> +               return ERR_PTR(-EBUSY);
> +
> +       *iter = *pos;
> +       if (!sr_resx_find(kvm, *iter))
> +               iter = NULL;
> +
> +       return iter;
> +}
> +
> +static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +       struct kvm *kvm = s->private;
> +
> +       (*pos)++;
> +
> +       if (sr_resx_find(kvm, kvm->arch.sr_resx_iter + 1)) {
> +               kvm->arch.sr_resx_iter++;
> +
> +               return &kvm->arch.sr_resx_iter;
> +       }
> +
> +       return NULL;
> +}
> +
> +static void sr_resx_stop(struct seq_file *s, void *v)
> +{
> +       struct kvm *kvm = s->private;
> +
> +       if (IS_ERR(v))
> +               return;
> +
> +       guard(mutex)(&kvm->arch.config_lock);
> +
> +       kvm->arch.sr_resx_iter = ~0;
> +}
> +
> +static int sr_resx_show(struct seq_file *s, void *v)
> +{
> +       const struct sys_reg_desc *desc;
> +       struct kvm *kvm = s->private;
> +       struct resx resx;
> +
> +       desc = sr_resx_find(kvm, kvm->arch.sr_resx_iter);
> +
> +       if (!desc->name)
> +               return 0;
> +
> +       resx = kvm_get_sysreg_resx(kvm, desc->reg);
> +
> +       seq_printf(s, "%20s:\tRES0:%016llx\tRES1:%016llx\n",
> +                  desc->name, resx.res0, resx.res1);
> +
> +       return 0;
> +}
> +
> +static const struct seq_operations sr_resx_sops = {
> +       .start  = sr_resx_start,
> +       .next   = sr_resx_next,
> +       .stop   = sr_resx_stop,
> +       .show   = sr_resx_show,
> +};
> +
> +DEFINE_SEQ_ATTRIBUTE(sr_resx);
> +
>  void kvm_sys_regs_create_debugfs(struct kvm *kvm)
>  {
>         kvm->arch.idreg_debugfs_iter = ~0;
> +       kvm->arch.sr_resx_iter = ~0;
>
>         debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
>                             &idregs_debug_fops);
> +       debugfs_create_file("resx", 0444, kvm->debugfs_dentry, kvm,
> +                           &sr_resx_fops);
>  }
>
>  static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *reg)
> --
> 2.47.3
>

