Return-Path: <kvm+bounces-69115-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0B4/Is5Jd2mLdwEAu9opvQ
	(envelope-from <kvm+bounces-69115-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:02:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E099B87740
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C39613024116
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9C63321A5;
	Mon, 26 Jan 2026 11:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="mdGSIquF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57CB32ED4C
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769425308; cv=pass; b=QjTykYZJ7vAmfLS/9AJnAYqqNiphfnnkHfLyUvvhkTZAxHvUTp5YZfvHPLlFaHfWbQKghc//YpgW86MNbfBtBMRJtM+sqHVioGDS+WR3K/NF2fshaLvi67AvqH24RfXS/vLV/mUBzmKfzDAbs+czFsaBLFlO4ZMj91qVNscKjVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769425308; c=relaxed/simple;
	bh=qLctU6SvVR1jLtU8xijHCqW+3sEv+VWsnAikdIL7wxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=knSpTbeikOfUDBjJ4p2zQhLkZS4gCTXNXQ6YhLXNDa2phh9zfuDN4u6nU6z9U7FakQaftvOMJNwpHrC5hBQhNrLxAA6hYAmZbZYt5ZuDm1GbxNiHAPP7BYtHctHm4pyHoEGrk7a730eulWisxrD8HAts2ZMB3jtXDK7rvGLIAi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=mdGSIquF; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6610c5b014cso2206637eaf.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 03:01:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769425306; cv=none;
        d=google.com; s=arc-20240605;
        b=ZasuFS8W+llLlySG1hCWyxRrQNwSzJ/g0tKAO5jIzRvBhpCmgE0Oxd8Wapno+31Y25
         uPTR+BQPYkgsO6wULuqULQAo7X06M+ZE8BKVLEgH/INFYAFQ/WSpX/rb/iUapaBGx/dn
         P/PUMo/KRLeBRyzxSL9tUpl5Fq8SscmZSCU6YjAqbjHweieX0Jja0WhBjj0Rn79jNRro
         797GQOUNdgRhKu3aX8K1IqLhGFPyPH70RPG1FVJ00JI78mcyO2NXOZGD6GORGaG8EEES
         FAoF1nXi55iiYkwPN7e9u5AyKH+I9UpMdMSCq+yrUvnd3dFg+zajBLyym0ESzh2MCv+Q
         OUYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yNQC2GhUUe78LWTdamvuxQ+2JSUG6qZ/+66tSASqYfI=;
        fh=MH976/6sy9F8cCCIXCvah76WWgb7Lm/NbL1zaZ/exnM=;
        b=PFioT45cKPpd8fmXc0tl7BqaceJ2VVNOSxuYhOBRMPdzeuac/bw8BVJneKILTF48bQ
         IS/r9AlEolf3Wh1oxy/jMgdSXj9TQDOAjqJB2ACCPC+YwaUlGy8du/V1oKOz7Bjpicm3
         CVhlLiZYYL0KT1tMwcDLPN3euDw7O3nXYCCG1/XbMkhdCGfvI3otNsRm+GWF68MqvZap
         gllbnDBCeo0PXHf/Tl3e6jCLgPiTA0l+tM3fUC3NBQvB78X1U1S6bPE1aHQTEJP4xDux
         876aBflheLW4FkvuwS6+hAFQq9OgBEOz+stzINM3EJuY6i7lHPWv7NfCwCtm3sbE9hvr
         l9VQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1769425306; x=1770030106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNQC2GhUUe78LWTdamvuxQ+2JSUG6qZ/+66tSASqYfI=;
        b=mdGSIquFQnaiB1qf9cua31fLpfK2tGzr56Vgm91KU/4OQ7hKKVawmk0ux0pHgczrpt
         Gc2YsRdBn5oeIj7UtrGBBAoazbrDmXbEkYVjiIT0jGnY8OkUUdEinUHO6gDAmrVVNQ2l
         Rxwrcjjncjv4uUlqOda2hiwpqVUIRga+QFdre1aO92M02m5XdxjMNpDxEi1gxhBgPzxB
         QCALaP1eRzHGX46Yjnq5gDGYn2aUhAWphMtCrRqZVoLE51SEpA415JNsfJ3eIcH7rO1A
         M+n7dlvIoptxDmlMRVO9rnEvO1xc1B1IwYP0d3OVr/gjR9ZJhGUofhUOOJQElEMBIwFO
         B4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769425306; x=1770030106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yNQC2GhUUe78LWTdamvuxQ+2JSUG6qZ/+66tSASqYfI=;
        b=ZscGa0m5a3ZmJGd6uZlVuNxtCcHPInT30Za2KEE8uN6eWVDFU1fbwkOvPMsS7sbrIe
         zhoDXfAWg2bB9nTx3xkOvLwV+XKxfs2+W1HzgOIwWviSd4kLcLEuitcxARMsgG+Advyj
         oqZi3u4JKk3nkUbDCE4GItf7RKdyL3FhONv0XiIKAAweSv0KOmgQEWKz/PEqQA11GYnR
         CX9KOAXvRgnrvLClQhZCerAgadJk7DlyFbFCnz+mMkGBJsNFxwLlyjHzAIkgNuZBMTLh
         E7WIdKB82gSbbGNvbDXLn+NsZ9RVlMvlyPsqUHDeV3LcXRDj3LYgFx7iZqd3Hy8OHEWT
         Arrg==
X-Forwarded-Encrypted: i=1; AJvYcCV+KxM8VRqQ6BD2IiI76iTMrHrvpkkEa9c6RfRzJCvKhCkFn6QfqQID0ewrgvyiLEiYBWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2JTQNp2Q4JHlvu/yYNVV78yV9CZ/0NdhcinEnHhhYwYdod2CI
	LB78eY1Vfm3Wta5OYzECpNWNxYniJntv9NDezD44nWGhm3GOqn7r8PWV7So4EK5DmvBoyg+Dzq+
	ZN52FumLrOLgTUqzXEMilVlVLGwTGHwGPw3lx1aAi9g==
X-Gm-Gg: AZuq6aKXQGr77fdDL37Dr84ed5I3OMsQHqJycjXtTVkideknVgOyipX6+rdLGmWzERT
	0P6MrPlY83nff2LtDnZ9gSncpsX1kbT0xqY5EF1Q5FMnLk2fDWSzgnRSAYB6efYsCnzSpKz+Zum
	VVJFxggfncTjiqiuUzODxXQfiJnR/6q8jGB1Cznp126pfBxs5ejwA0cK3JsmqpmmcXDx6iCjajT
	5N39+THgClo/6hTSdhAglkG+Uqf3W3gKbve6Kd/M5rY6H8hd3k//SIJO4MBc2fRTML8RseP8eQB
	IbCkbUdD9RUYT0MGE/+dpXaWC3QJytQZjKcGblVX1zcp72f7za3DJ7yb6A==
X-Received: by 2002:a4a:e84a:0:b0:659:9a49:8f99 with SMTP id
 006d021491bc7-662e03daedamr1690050eaf.18.1769425305682; Mon, 26 Jan 2026
 03:01:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125143344.2515451-1-xujiakai2025@iscas.ac.cn>
In-Reply-To: <20260125143344.2515451-1-xujiakai2025@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 26 Jan 2026 16:31:32 +0530
X-Gm-Features: AZwV_QhwclxTcj0A8174pE-hkh_gKAJoKfsUQlzQMfllaSIpHrjIxI6lcFRhMeg
Message-ID: <CAAhSdy03Ujgn0K7xQNFoydWDiohU5PE6bbSt=tPLCBHd7BaZYw@mail.gmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Atish Patra <atish.patra@linux.dev>, 
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
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
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-69115-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,iscas.ac.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,brainfault.org:email]
X-Rspamd-Queue-Id: E099B87740
X-Rspamd-Action: no action

On Sun, Jan 25, 2026 at 8:03=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> Add a null pointer check for imsic_state before dereferencing it in
> kvm_riscv_aia_imsic_has_attr(). While the function checks that the
> vcpu exists, it doesn't verify that the vcpu's imsic_state has been
> initialized, leading to a null pointer dereference when accessed.
>
> This issue was discovered during fuzzing of RISC-V KVM code. The
> crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
> AIA IMSIC device before the IMSIC state has been fully initialized
> for a vcpu.
>
> The crash manifests as:
>   Unable to handle kernel paging request at virtual address
>   dfffffff00000001
>   ...
>   epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e
>   arch/riscv/kvm/aia_imsic.c:998
>   ...
>   kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
>   aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
>   kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
>   kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
>   ...
>
> The fix adds a check to return -ENODEV if imsic_state is NULL, which
> is consistent with other error handling in the function and prevents
> the null pointer dereference.
>
> Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes o=
f AIA irqchip")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.20

Regards,
Anup

> ---
> V3 -> V4: Fix typo in Signed-off-by email address.
> V2 -> V3: Moved isel assignment after imsic_state NULL check.
>           Placed patch version history after '---' separator.
>           Added parentheses to function name in subject.
> V1 -> V2: Added Fixes tag and drop external link as suggested.
>
>  arch/riscv/kvm/aia_imsic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index e597e86491c3b..cd070d83663a9 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -993,8 +993,11 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, un=
signed long type)
>         if (!vcpu)
>                 return -ENODEV;
>
> -       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>         imsic =3D vcpu->arch.aia_context.imsic_state;
> +       if (!imsic)
> +               return -ENODEV;
> +
> +       isel =3D KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
>         return imsic_mrif_isel_check(imsic->nr_eix, isel);
>  }
>
> --
> 2.34.1
>

