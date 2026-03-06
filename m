Return-Path: <kvm+bounces-72993-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DifNAl9qmkqSQEAu9opvQ
	(envelope-from <kvm+bounces-72993-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:06:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC6121C46B
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 08:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9616309877E
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 07:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611AA371076;
	Fri,  6 Mar 2026 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="wVJ31CiO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECCC371D1C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772780691; cv=pass; b=gpVxDZ2+b6ccmIgOOpo9SQmbBRSyWdoxQvDQ7u2d23Hq4QRzGEdeU5S4XExlNFIxVos16OdztwHjPEFNyAevdT1Depl6R+nZpwd4D+vVIEfudar335OfMssYApA1U1YOrWcxd91nDwnAO5GRN48xBWCIdHfuljvGiSmv3rGcPyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772780691; c=relaxed/simple;
	bh=+nlpLSj6Acf1T5Fy14+xUwvr2HwA2i3QvZ87SqnoJ6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nvlq95MqQX8UwaShL9eprZqbt3WTunHOose5XTKTS+DZ/DF3roCB6OixEbz8cNwa1rhLx8yqxE99NmKvUB9cwIiFskTapIc1c2kPQtTTyM7zXMB0POjb5pjuBeHFz4jjDzpWcahUtODBREcVF3/MlE4/cTPgTPsapN1PcGkASHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=wVJ31CiO; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-66307e10d1dso5695594eaf.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 23:04:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772780688; cv=none;
        d=google.com; s=arc-20240605;
        b=CA/OG17zJ40Se9Vp59MI3BB5YfOcgDZO8E/iSAXNTYZWqPiMp3HMTzIv5NDWT5P0WK
         R9yD40xIbXrObapyAQUJx1bSjXv3UBXQScVBHUcVAEwEUFXZCa4fM4j1UMJybK1vzefm
         NUGjyE5FKVNrCoQUbe2HTLDBi8+ZY5mMZLIqh3wSn0HHdoQVBfI2TTaAdmY90zlkG02o
         5sc5nzhgGOTx6sKC3TtwoketRuhgf8Iuy/akymF1JAY3QTym2/obGhFtHuYFkmdX4GVk
         vNQNz/luWIvgq5O6hwEardFj2yKg0YQ1S70OoqW4seqgu7HP587IOkLyLeHnO70OAWkW
         xb8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVySQsieckJFK9NwiXNz9/fIecprCPpUdU69L33AQGM=;
        fh=mS5KXmcEh9H573eUqOKn7szYAcNAiSA7Q+EbDb1fZf0=;
        b=IvyhzKyIVsxnYJV05TnVvO3wy3Wo5Iz2+qtQ+QKLyLuXI/WDNqeskzyO+gE93zMKu9
         g3T4Szd9+AkGTdS4o2T/JC7N8syF/lf+RW7Rhj8MnlyhbD3pSPWJkeAXswvBhNyRGiFZ
         Rzy9OPWdWvML1mLyvuQjtyt90Bo4gK6HCmEOKIbAlLKKFntFrXW6GEiuTUDloh5ITarW
         p7EZ+qJvC0wlaB/eR3t+zIwd8r10N2FhdnpOIDxok0ZBAWVqy8hnvXAhbxjKAx5Kyb10
         NyFVjN73Xh69uvW1XVfo3Z1Za4vyXLcOXmZPx9kR/HO/IZ54jCdUM1uoKmbwbwqy8ggM
         EGZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772780688; x=1773385488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVySQsieckJFK9NwiXNz9/fIecprCPpUdU69L33AQGM=;
        b=wVJ31CiOIRxdh8damH5PXG8QZ1Cr7wuq16FajrZ7UqLseitFXtou+nXkK9xL9A0hN2
         jYPhNxgdL8RPkWlFJTuA5cASfi4J/yZPfnLu1YC4kisvcnvS1LRXR/0BYglZWWrRikvS
         Rie+jrJX3QV91eu4Ra4+H0UT+rCb/jqgWHOn/QxK7QmgmqyTKDT9NORZA09a9lK3jAEJ
         kg5dawT9fojV0KGRILyVvKEqvE8Pe4WDwxLjc4UYtkhgAS6WXIvmMY7DeiQXdt0NqHcq
         3Zx6ffO52qFPIt4lwXYb1C0CA3TeGoxqbe0mb3TE0L9WQaHNqjuJqeUB/6ZJxQPynJZE
         /waQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772780688; x=1773385488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HVySQsieckJFK9NwiXNz9/fIecprCPpUdU69L33AQGM=;
        b=C8+f346vYSAvYbVFTl90oPp8CYh4YZURueESCvRlxIJ+iMuQoBzUwqKHzHK7NA829d
         +3XdDTX2vM3+plrepovBqorK2XIEsndgPqaf8Lo4ebyP02Uy++yWKcqJa2vuXD4mgtGV
         06UWT5tb+i+0ArkNYH9w0vPznoVaSNUSIFze1GZxMB+1v5s4K12q6ASRdCKYKlPN7HQX
         E9l1WLSn70qJn7FC/JLY0pH3dYRT9mvNf0BcVWFFOafNCPiumVAj1OWLElaAd9CSGiqM
         EUr4RX0A0jlM1Z0Km4QgEAa/pSlAfdajDH2SULBVH92Sa6snrBxVbAQPuySilo597U2F
         pkog==
X-Forwarded-Encrypted: i=1; AJvYcCV3af9cPgbhGnM3BBmzi43UQeRYi50Cy3eJorUD+Lf3u5CDAu6qx0ROCeUwwvkEw3LCct4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzOEAX7wK/s8b8+TNDnW5Z3S5OqKsG6pqt3zIQ6c8qXpjD+DZ2
	kkna77CWOWt4hLRNA09ow38awaVEmLMam1jPKCYMl4eNYM/alXr8FIytVmM3HuJl2j3x+P1eRd+
	JE0CcfgJV3cQCYKktrSHv3McWG7cLqbygtNLnBpXAjg==
X-Gm-Gg: ATEYQzxQhktVAEUrOTQ5JDDJ9dKJkiGShnwt6ofB9rehORyg8ykMB6NwGPYFhEzCxKh
	mc88A23yMeGAKbUjmeilAWXyAHuYThhDwAZW5+jEUkJ43nfGyfzJfgG3rZFsn+3brXsaNA5oM2E
	DzOrp06Py4HOr69+YqL9abs5i25IQBUYEaBpDXntFy1BFWFt1xXLW98/E5B0mTfiH+w0vUW4LMf
	P8qF8C1yByv8ZM2kvTutgj7jLxZML20u375jr990phrXA4N5yxfyqCu40C0CLuCH1fmCPUyiQiB
	8mJMOJ/s1thiFffCRc6dya8+AX++JxCPBNNId5Qv3EPJrRlKRW4hybPQz2dEiJCrBQTEq+v2juv
	05UydXUtP3lHgNDL1IkdDR2RZhw==
X-Received: by 2002:a05:6820:1ca3:b0:67a:3dd:3fe7 with SMTP id
 006d021491bc7-67b9bd2ef0fmr746008eaf.47.1772780688470; Thu, 05 Mar 2026
 23:04:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120080013.2153519-1-anup.patel@oss.qualcomm.com> <20260120080013.2153519-4-anup.patel@oss.qualcomm.com>
In-Reply-To: <20260120080013.2153519-4-anup.patel@oss.qualcomm.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 6 Mar 2026 12:34:37 +0530
X-Gm-Features: AaiRm52vplQjZIJ_yYHgtG1kWnM8unoFggovyMF3JIYyAr9uZDY-IpREqe4Zs_A
Message-ID: <CAAhSdy1jeJVHgABQxEzKCqYKLQteVkzM6p5mz2vJBY5A0gmFkg@mail.gmail.com>
Subject: Re: [PATCH 03/27] RISC-V: KVM: Check host Ssaia extension when
 creating AIA irqchip
To: Anup Patel <anup.patel@oss.qualcomm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Shuah Khan <shuah@kernel.org>, Andrew Jones <andrew.jones@oss.qualcomm.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0CC6121C46B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72993-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,qualcomm.com:email,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 1:30=E2=80=AFPM Anup Patel <anup.patel@oss.qualcomm=
.com> wrote:
>
> The KVM user-space may create KVM AIA irqchip before checking
> VCPU Ssaia extension availability so KVM AIA irqchip must fail
> when host does not have Ssaia extension.
>
> Fixes: 89d01306e34d ("RISC-V: KVM: Implement device interface for AIA irq=
chip")
> Signed-off-by: Anup Patel <anup.patel@oss.qualcomm.com>

Queued this as fix for Linux-7.0-rcX

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_device.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index b195a93add1c..bed4d2c8c44c 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -11,6 +11,7 @@
>  #include <linux/irqchip/riscv-imsic.h>
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
> +#include <linux/cpufeature.h>
>
>  static int aia_create(struct kvm_device *dev, u32 type)
>  {
> @@ -22,6 +23,9 @@ static int aia_create(struct kvm_device *dev, u32 type)
>         if (irqchip_in_kernel(kvm))
>                 return -EEXIST;
>
> +       if (!riscv_isa_extension_available(NULL, SSAIA))
> +               return -ENODEV;
> +
>         ret =3D -EBUSY;
>         if (kvm_trylock_all_vcpus(kvm))
>                 return ret;
> --
> 2.43.0
>

