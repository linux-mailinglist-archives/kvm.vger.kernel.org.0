Return-Path: <kvm+bounces-70318-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHkQOSR5hGk23AMAu9opvQ
	(envelope-from <kvm+bounces-70318-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 12:04:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 412B4F19EC
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 12:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 864283049709
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 10:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A4B3A9D9B;
	Thu,  5 Feb 2026 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jG0lM977"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7543A9D83
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 10:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289129; cv=pass; b=T683cx9pzrP1krci4EBcWEgRW1tJEbHRkB2OEvptruOeVB1Cp0ZLYpQUsHjhbWCPMyXhBOr+MZCiEJvaYjOeb/REFf7PsP8uQu7H4Vp3EPhvX1Mv1AJ7IiH1L9TSqef7zv2cbTd7sqt24uw4lckjVSFyyL1G0OeapA0Z9qGaIuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289129; c=relaxed/simple;
	bh=eInnJKMahFR6g+uDKXbFT99Bh2LRk+v2OWPd769Xq2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JhVqsgQiBxBfZTP6wHzZsL29alCGpzt0xsUev0bgA7123fD9GmKSaGiA+v392hqVNdgaBqfUEVsvRMswKQkzwTf29l0r9jc1fzeG7Oso+02dg1n8MRLU7Eqrp5KJdrOYVWHJ27lTtGg0Zg84Qp+Q55ErJgyXwJPASlSrgE3bfQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jG0lM977; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014b5d8551so335391cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 02:58:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770289128; cv=none;
        d=google.com; s=arc-20240605;
        b=dEzyIVTL6W7rwqi/PxsjjRLySzP7VJj9q14JvyaQHABy1KeTjw04oDNQE5Z2CsduoM
         C6XJQBk0n1ilsEBExQMsTwOJb4EGg9lcWCYzhAGTyZgzKtIDmbdKpR4T5mbbHJ6IbGf1
         eEMEiJMmHWQVdENd5pJHfl+uxW1vMH3TsxLZe9UCSpn5aPtiYp2olRNhqGVIkTs7oylt
         O94ZZFkEKyLdEI38hRT2rfvvx9lqCzM2sQBC8LcDSPFkT2g5eao0teRIhhCrwOYrcdKX
         GlJqacyWpTa3uoOH16NeiE37XuDlbDzflk1P4oJr72bp/2u35k1J6S9amHwgXYBr9IgI
         Dfjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        fh=9TVMu45Pi0zBFKqMqBux14Bc9Ys3uazMEFzVURRsUaA=;
        b=U0aCnT3zWVsfI0LQvlMB4odOIp18kxA9uoIva6jUeswLn9JeVkkHN2A9cXm4qrShtS
         wXvyDt3z/TeoO5EsuoYIUPLN7x3PYvlzWDrpyqiwd0dxqxvULNE0aQR3EWawQ3MKgBNx
         7LPY0c69DwEmDN2oDh6fotlWdMfrCD9MKyrX+MrONVQGmCi2c9qUiiTskz6P7JbHvg5E
         gA546W0UFdpfqHSA6gz+pZqS+UqwG/3oqZMG7/8Io+PyQWijh7s+h3QHIex9iHMfBDgY
         mzJBnBY7NVKw81ZYmCAdhxLiE8mGILEgojHuC0xCSA+WrU5xpG+2JKcML1DmgmYexE63
         W7mA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770289128; x=1770893928; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        b=jG0lM977AgU4k4a3NUw2sqizKRC290Y1gHjmForcDH6xHiXGSGNlvcYv6eo8BrcX5W
         JGylmlS5DVKZvrLnX0jfnv4q9ympM1pDuryMuu+DhJSdylXBUWWp61QJg07zrimaS72I
         djPSqDrbMSaKZ2ZsJAPDqYQu14CPmc+gfJoXdzs47hiJfJ+gPVeIsM13zk3fsUPF4JwI
         tPhXOI1MEakE0ASSoYyc+PwZOmBHOXV3VKR8+iYcqF9FLOYpblQ5FMJ3Qi+JbaUB5krO
         m1sOuZee46r4fU29N0gkDUuq21fUI9brAXQtogw7GlNs36+1a6I6WZ+swHGciE8h3Tdp
         przA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770289128; x=1770893928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        b=ozS3kOk9qQ4TlYJjgmxDiBkTMl+gvNqYnR7oJNgCaI7OX0qCp8yZiV+zJUJYvLldvn
         R7cXNeNFuaPOY87bdgfveBS71k0xE7aHVSKTjsFyhbaDOOz1uj+zg4UwkqvaVRLQkPtD
         CSwyWzn+zePtOk+i8uh8F4+J6xrBY3/BQNzGSBS35RJO1+1AW6avkFKNkDSootP7ZSRZ
         fnFI6M6cW8I/W98EPmDoVdUGLo8XWQLQQW6Re4eIjOQQgftk7borQP7OhTSl5W4TpqzF
         ZXsSfdIrN6K1Y6Cx+k2SnbCDGxHYrJLn//cZKx4Ya8wjROsIEyjR/Kt4gpl7McWtCNGP
         Uvfw==
X-Forwarded-Encrypted: i=1; AJvYcCV5JBQTivyIrTVWlWYtuLRSD2dvn1Ic3I4M0OesiZ8moQEyb8/Hb+qESn9VWn0LGUVT5YM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCaf0qWMAx6npawvPvCMaxUyq9/0IzjySnR2cBW9Bcczq+bHsM
	64MoC+OkpRccyYP4ibDmJXRtCHvIgJ/CO87acUnvQTW/eq98RmFfA2PwwlYTRnF5daAtJtKkEnN
	YuB4H/Zy25a3RxAmHRAbggihxzX0D4FShmZIj8bD1
X-Gm-Gg: AZuq6aIPJXHG/yuAauyMFtcfHlnn4WS6qZpE3MT7uUyjApgQI43Cry6PUtVp2kCEqpN
	hyfOMYqM+1826RX7kHMT4Usp2nQBHGSmDlvLZpcGYzEgwoJdGX+/KMqIpNCKBfhpUPoJWivs39B
	cpRO1FMZeIdcXc08PHi+hmFTB9ugWqVO8U1X2Od6QBO8+RWLW5BFhbMtWrQxOGE7t3xLWhIh9/M
	uqbEgoXyX4YOCkeYydQ7zrrHtEDLIvec5VkVMrd5PgNNtwuGFOcN/iak93M90Ke2g4NglmB
X-Received: by 2002:a05:622a:1a9e:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-5062b0a3b84mr6534461cf.6.1770289127426; Thu, 05 Feb 2026
 02:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Feb 2026 10:58:11 +0000
X-Gm-Features: AZwV_Qj2DbaENVW72ogYB2HV7TiFDfYeQJXErbOTc52O5rdL0EP2dF1kO889FaM
Message-ID: <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "will@kernel.org" <will@kernel.org>, 
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70318-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,arm.com,vger.kernel.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:url,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 412B4F19EC
X-Rspamd-Action: no action

Hi Sascha,

I would like to review and test this series. Do you have it in a
branch somewhere, since it's not trivial to apply it to kvmtool master
as this is based on the nv series.

Cheers,
/fuad

On Fri, 16 Jan 2026 at 18:27, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> This series adds support for GICv5-based guests. The GICv5
> specification can be found at [1]. There are under-reiew Linux KVM
> patches at [2] which add support for PPIs, only. Future patch series
> will add support for the GICv5 IRS and ITS, as well as SPIs and
> LPIs. Marc has very kindly agreed to host the full *WIP* set of GICv5
> KVM patches which can be found at [3].
>
> v1 of this series can be found at [4].
>
> This series is based on the Nested Virtualisation series at [5]. The
> previous version of this series was accidentally based on an older
> version - apologies!
>
> As in v1, the GICv5 support for kvmtool has been staged such that the
> initial changes just support PPIs (and go hand-in-hand with those
> currently under review at [2]). As of "arm64: Update timer FDT for
> GICv5" the support is sufficient to run small tests with the arch
> timer or PMU.
>
> Changes in v2:
> * Used gic__is_v5() in more places to avoid explicit checks for gicv5
>   & gicv5-its configs.
> * Fixed gic__is_v5() addition leaking across changes.
> * Cleaned up FDT generation a little.
> * Actually based the series on [5] (Sorry!).
>
> Thanks,
> Sascha
>
> [1] https://developer.arm.com/documentation/aes0070/latest
> [2] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@arm.com
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv5-full
> [4] https://lore.kernel.org/all/20251219161240.1385034-1-sascha.bischoff@arm.com/
> [5] https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm.com/
>
> Sascha Bischoff (17):
>   Sync kernel UAPI headers with v6.19-rc5 with WIP KVM GICv5 PPI support
>   arm64: Add basic support for creating a VM with GICv5
>   arm64: Simplify GICv5 type checks by adding gic__is_v5()
>   arm64: Introduce GICv5 FDT IRQ types
>   arm64: Generate GICv5 FDT node
>   arm64: Update PMU IRQ and FDT code for GICv5
>   arm64: Update timer FDT IRQsfor GICv5
>   irq: Add interface to override default irq offset
>   arm64: Add phandle for each CPU
>   Sync kernel headers with v6.19-rc5 for GICv5 IRS and ITS support in
>     KVM
>   arm64: Add GICv5 IRS support
>   arm64: Generate FDT node for GICv5's IRS
>   arm64: Update generic FDT interrupt desc generator for GICv5
>   arm64: Bump PCI FDT code for GICv5
>   arm64: Introduce gicv5-its irqchip
>   arm64: Add GICv5 ITS node to FDT
>   arm64: Update PCI FDT generation for GICv5 ITS MSIs
>
>  arm64/fdt.c                  |  22 ++++-
>  arm64/gic.c                  | 179 ++++++++++++++++++++++++++++++++---
>  arm64/include/asm/kvm.h      |  12 ++-
>  arm64/include/kvm/fdt-arch.h |   2 +
>  arm64/include/kvm/gic.h      |   9 ++
>  arm64/include/kvm/kvm-arch.h |  30 ++++++
>  arm64/pci.c                  |  16 +++-
>  arm64/pmu.c                  |  23 +++--
>  arm64/timer.c                |  20 +++-
>  include/kvm/irq.h            |   1 +
>  include/linux/kvm.h          |  20 ++++
>  include/linux/virtio_ids.h   |   1 +
>  include/linux/virtio_net.h   |  36 ++++++-
>  include/linux/virtio_pci.h   |   2 +-
>  irq.c                        |  16 +++-
>  powerpc/include/asm/kvm.h    |  13 ---
>  riscv/include/asm/kvm.h      |  27 +++++-
>  x86/include/asm/kvm.h        |  35 +++++++
>  18 files changed, 416 insertions(+), 48 deletions(-)
>
> --
> 2.34.1
>

