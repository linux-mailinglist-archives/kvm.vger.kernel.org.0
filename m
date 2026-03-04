Return-Path: <kvm+bounces-72675-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GHy7AAcTqGnUngAAu9opvQ
	(envelope-from <kvm+bounces-72675-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 12:09:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6190F1FEB51
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 12:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 614B8306EC8A
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 11:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DD03A451B;
	Wed,  4 Mar 2026 11:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="wKVKucdm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B1371D02
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 11:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772622523; cv=pass; b=U07HsrK/+IvvNR4n+TnzStNPfSObUMY2soI8moPP6yJSxPxC22TBAHYS9flx95b1ssjTtzNTJCIOX33JAQA87EzjRBnxIsNh/O0z8M5YKhtponI0Uf/hgzQGJUvW0x0AN/R+PhNSQHE3eSqYq5h2MGHa0zm4IHRKksJ7xZc++qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772622523; c=relaxed/simple;
	bh=yPFRCqSpC1utRemlhmSQ/DbqYMDSKyFMjd3b8amLWOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iUoygX2vxFeun4JeJkgQrfeWhGP3EQ+uSCYb0NW3KUxt7knwyR0oAKCyM4kyjf3R1SVqTqdXromvnWvBhOw2FEM5KFh4e+jgXkzZwpAa79P2/kkt8udArnZIyzYv8/g854nJjSeumXGiEvV7zGAmQwCGS7pTo2dFexTdbWysNyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=wKVKucdm; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-66e3100515dso3973858eaf.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 03:08:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772622521; cv=none;
        d=google.com; s=arc-20240605;
        b=SbEAiMCZqHI6dDsUF1qTrbmdLGilfMfgoswDDAbNDfpmx7BPpwmlF5jtQ/xCSy5+i0
         3WBnC7ZBaUvhcbkhoW7oFpLxjdDvTjrlV12rIw2GbEyzNbto4Cz6dkU0dOCqXYHkoqpN
         Cgak9gwNiaEMFttEBxO3w9aJUbxdbyG2u6aJGRofdD15alcIauzsY7ymtJvG6P+SrkkM
         5BRdpbrYoV4ewSPgbshSOyIwVYjrocGqk6ZeXjataobVgKXnWaVOul6onk9fkA9OFnzP
         RzT/+f6WIiedLQ2Ol5dUsyiEDXFn5/walUBLf9i6R4CgmW9r+P7R4uQONYVQFICCEtvw
         SH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=20V0HsiRCM8u2CycbPAhWN5bAO7CHOUhSKzXrUPLlhE=;
        fh=Egwyma4Aa6Ajqf6t92DuIio1yeXsoBgKJNuqdR86xJc=;
        b=Wbc6PIg4tbJAmc8ckCI18Wo9zlBzlKbsHV9eT9CTotKWp+irEXiSrAqUV4fELOP9pr
         we1bkkIuxSJpNTE2gosOgLw/VDD0EiQBD6EVampFyyW2FeRiqekmW7XiTIUB8lKXHAYg
         YWVwTdqCpEtMlfoCUVwCYkxJHJJidZHMhpq7R+Fopa+LaoUsSXDeW6mK60rL2hUhdO4q
         C64iUT+MP4GAXajeqEyvi37ubVlz4YN+FAi66ZPyfZAC8sfjckf2soBGck8SCNGAnzmi
         JdbY7TujqFz4qYU57FMf/+3ydABAJzBCTE+ID6KlwNlXcsX4yqnb3dghOV8TCd+eXKxl
         A4fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772622521; x=1773227321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20V0HsiRCM8u2CycbPAhWN5bAO7CHOUhSKzXrUPLlhE=;
        b=wKVKucdmuxp9OT8acexSvWMJO8/D69tFdlU5p4Q1qyZBalQf+zRMqqMeoAApW6Onw8
         cfED1iH+kmPorVtvX+ZE/J/qUSPgtEA4O5KPTCnXjo8/Ht3IpfOoiF+8wmDXTr+Bxtrj
         +1IUPbYwKwKEiumXyur2y/3Abeo2Zlryvx4Bg/azkQIpm/TkCpgcuw4pfiliBbeq+959
         PVHY+oknbcg93FldGcj7LJGud/hm2jECsgRkuf4mU0/T+OPp3z7hCTBTgSzLjh7e5L7G
         MS8qgLv8/9MUKQINo+Tvt0Uxuwc11r+D1YWOxqcUrdJEHn1TP8dcrR3Qj8Q9MPex9v5y
         OGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772622521; x=1773227321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=20V0HsiRCM8u2CycbPAhWN5bAO7CHOUhSKzXrUPLlhE=;
        b=fB5fnHgu949o8jAJH7kgtp0Hk8Pq8DSlIjT4iLBCgZvbUbRGEh1YVh0ifPeSwkoV5Q
         ki7ycnlBp/RGFuAIFvyMiUkc9TLuxr9P1usROlfF8nLyOIU/ZDOIfnkwcMxsypdwBkDe
         N28RBdJ7LRbkzun4h+S/5bl1T33HNYCtEvK5ZokYEupLQGOCUD2eMPZj7qbKBJvJ4fsg
         gjxPHNB9sDcZMvrYCXCAIsaBWemsCwaehJ1U6a1ElNjsRvJ/umwqK1DbFY3/5rsRPYeZ
         A4rq4F7lxYO2HTcEsuddLtFNuFpiYMK5QvEYdzFc1mVVW4XHs/hntlgEYwTDSJJaxmDH
         fdow==
X-Forwarded-Encrypted: i=1; AJvYcCX7ih0DVeZIdCZvsJfKDHmHATskiGfpRchd9UH1UFn/T0pfZTAozVoaxwN+YD/WntePeSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YykDI4wgD/GivDfSQ31PokNRdyb6bymxiP6F3GYk7cCbqADL4fN
	MoMWvPndM4Aekf/jwSj7gb/kphjzZcpD5dI2v3yuaPwX6mx2QegvV494bREC4i6aNPb5Vd5sdyB
	w/rAZuJJe3Eeqis4tSwMgCuPrpM/xenq5AzgsDHDtYA==
X-Gm-Gg: ATEYQzxTyk/fTR30qcp89jVY5EWqtb8PhwC+n6RrMk4cF9LVM9tOhOg+lYe2Iu2XB/z
	iHUtz5IAW/0yrE0h08VI8Hw24G0Cl79z0eQEMId0n3KJ6l+i9d50JGr2TIKAp0L+EYD1glD89Gp
	qNMgofZuwpbKEKu/3/zbyrFPWTj1xkH24ZvG3WaP2x10cSBjafmcii2YvnyYyQE30NxO+dLm1EM
	TUqNrnouIUSQJda2f9sxw7Ltj6lqcPL2K6DG4nvj3VR+Ao9WAZhE8ESUnEdIn8hBbHi39D1Tv/W
	GjqwyCOKDp/7S3w/cgKgfx3l0XZiPHtvdb1+4BlnsWywQNtTKRXGTHLrxstovL7/TXcoNPCAQRR
	kwYRy30EcYU9KeTv+2IoOEAPYQlg=
X-Received: by 2002:a05:6820:f021:b0:679:a463:c933 with SMTP id
 006d021491bc7-67b1e932124mr914892eaf.71.1772622520701; Wed, 04 Mar 2026
 03:08:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
In-Reply-To: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 4 Mar 2026 16:38:29 +0530
X-Gm-Features: AaiRm50FApq9ik0ETo3HXP7rfW4o3U8qtmgzjhKd-QdWkzujkTa_K8xattka4x8
Message-ID: <CAAhSdy0nkke8sJR-wV9nrzc=VqdY4igYu9c8g14qudbEeR=27g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: riscv: Fix Spectre-v1 vulnerabilities in
 register access
To: Lukas Gerlach <lukas.gerlach@cispa.de>
Cc: Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <radim.krcmar@oss.qualcomm.com>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Daniel Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>, 
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck <jo.vanbulck@kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6190F1FEB51
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72675-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,cispa.de:email,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 7:49=E2=80=AFPM Lukas Gerlach <lukas.gerlach@cispa.d=
e> wrote:
>
> This series adds array_index_nospec() to RISC-V KVM to prevent
> speculative out-of-bounds access to kernel memory.
>
> Similar fixes exist for x86 (ioapic, lapic, PMU) and arm64 (vgic).
>
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
> ---
> Changes in v2:
> Add array_index_nospec() to four additional sites in vcpu_pmu.c
> (Radim Kr=C4=8Dm=C3=A1=C5=99)
>
> ---
> Lukas Gerlach (4):
>       KVM: riscv: Fix Spectre-v1 in ONE_REG register access
>       KVM: riscv: Fix Spectre-v1 in AIA CSR access
>       KVM: riscv: Fix Spectre-v1 in floating-point register access
>       KVM: riscv: Fix Spectre-v1 in PMU counter access
>
>  arch/riscv/kvm/aia.c         | 11 +++++++++--
>  arch/riscv/kvm/vcpu_fp.c     | 17 +++++++++++++----
>  arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++++++++++++--------
>  arch/riscv/kvm/vcpu_pmu.c    | 14 +++++++++++---
>  4 files changed, 61 insertions(+), 17 deletions(-)

Queued these patches as fixes for Linux-7.0-rcX

Thanks,
Anup

