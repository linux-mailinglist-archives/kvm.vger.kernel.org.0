Return-Path: <kvm+bounces-70586-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +O3COAKTiWlj/AQAu9opvQ
	(envelope-from <kvm+bounces-70586-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:55:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5092B10CA92
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0090F300D95C
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 07:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6252F339B2D;
	Mon,  9 Feb 2026 07:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AWqn5DA6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67942339853
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623708; cv=pass; b=Z0Chx0D+8tyCGndyh5KxL65BLlpaUlia6v9Aooyxi64NxoupgtD9zSAeLmT34gtjheof3YIxjQ5iYjkdNxI9sujttrNeHi3+xeH+3INvQNrOYUoTOwdFprIS3cVTVwLQKlUkiQJpNEMSDNDUCmAgtvLy9tR8+Pa0iJLQH7gwDMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623708; c=relaxed/simple;
	bh=BNgryngJw2u1QstkCu3izzlLr8n1gdpbTZu0FT2ckjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/b5t3FbT/AtmZPwukXtluDJy4cyDnHmRbjjsYXKeme/Li3wA/mh4HCXiITk1QuJbebIjuuQoMJIwNL0F5vfZ1Vq7OnAzbEItXEpYmxdox20QRIIPVW16f23LMF5Y+DKFNEVkHYEcZqALzrqTrA436m4ykxXg8sydHH8byYyWQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AWqn5DA6; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso805751cf.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 23:55:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770623707; cv=none;
        d=google.com; s=arc-20240605;
        b=CgX0R5l0YOAE2j9S5tbfhQcmnIy37wy+iq8qEEZTstTxtvB+z9WfpF5+WTIIMLxvyZ
         Z5qrtakWquPgpG7vTf2pSofFiIC51EAfSu2EPnVfs0yo5vVwPOxynKSpKcOj++4mmVEo
         b9ir8YxBHtErtNTR19DaHS8A86R10+BDHUkxF4JGxgjA1qOloxFwrjv3Sk2S8Ht1OSKP
         lW+TlhEaJBALiG/3pKwOkWMDfHoPGlbrrzRBmNdXY9bBI8I6+DZEZSUN/BdknFLVh2Hq
         Sd12Qyq71DZ8pHt44BqISrpvVGndaDYO9Fon/4OPruGpW/4u7zf0a6T/C7X8U9qMpusS
         YSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        fh=fbtqCWPuOsvC5mE3VPCAm1bRaAOjE8Zfj7H+jJSOqCs=;
        b=Sbczcbi1AYh0lXWiQcvCCurZ4jYG6Z6uAfCoXLgr7qAFy8JG9Fw3MzTBSOQtf1BrNb
         LGyxrU/WaKDkdJSyu9r548oIesLcyaAgfooAMc7+t2vMu0CuS35B76BFqDM3nusFycx9
         CX1iQzLGpXzDenAmU44u1c8lRQVIIawbf4tePmcnwfPIH6+5oFri9mrECI/kgAKqMPYw
         SNkXISEr7/fVdq8gA3N9GONABiCgJr0dBhIvX/8LxirrBGzDzuvlDf2MAih/6bHvbZHQ
         m7ESziTKXpvFFKsp7lXxvZhq70AaIALmZhX91PbLscogQX46YNQP+3cR85vHH1dNacCe
         +w9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770623707; x=1771228507; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        b=AWqn5DA6c6tXw58txJUOVc3xoCnby/JOVH7DH1VFQsrvoIvgumDMG0auvH6/Ru3oXk
         0KVGepmmNf7sLra+nRcWsC+2kYys8UJmbnj7SdacrRiiJeVkKyiNH9E0mD2+38yWztbf
         kBfOwVASGVLFIsSS8CS5p8/78h/Qp+N/uxOKocj2vImsTMnE6zRM/pE/DaM+cr9njhAc
         rHMehei7bNQFmylk6Mhwki89YnEAePhdmNv6GuKv9M+/ihl4QAvS4SBdmeIkmzKfihrI
         Ydi0Xk8MF/bLT8HELoRcqs9gAun+ID5UGVMpesObJZ0fFiyqEg6ry+9JolSag46QbjMK
         66PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770623707; x=1771228507;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        b=GPLZvSYZowyKbLdNjVOUs7MbjRBL9rwS8wbcLSDC8KWWIvvLvRQPF4WA/cVgd5gvDX
         QivW4+OFTU7CFAqpuJbLwBvkFthWY001Zbf9N7V3n1P/4gM1olBdsiNNJhONW5iFwTfz
         jSS7nAMdgDVh3Im1fPwIaAKkmi748PEBfWmEh7AkChN3V8ZMYvfIZjobLY9iwToFAINX
         0MEtExXvmr7v8DUBgkcvWlsQHHW1yWv6zIDX0YvuxvpDCQmJRMbHhK5P8kLxUEvcXEDq
         M7A3f02IFCMFcKoLBDYufKLe2jE7lb0Z+XiGXr+2puoZwqh7nHHV86TSKUrLMGQVHv7L
         PnlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVkntP8KG9BoNiwuWVomwRM6DL3gJZt+j8a7ryKMgpS7akVqIZjHSari1irwSB9jM5iaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcoon82J04cSAYDCC+LllF3UjU0vGajuWfiFee4lzS5Vq4Ze0H
	MJNTMz9HF2fYloRXla6K6mlOQOApInDF3MqnuXRg1lCrZ6eDsq0P1thdtYVhHY8rqz9eAg4YARV
	IxkQfD1DuS4C6uiWHVKz2qP9QW1yJKsModhpS9w34
X-Gm-Gg: AZuq6aLhRI5S+8msA1d4hdgpBM7UGCqPfLZQNWAneyz/kBFkg3sp6rUa/IE2rEw1q+5
	cZZ6GCXGG4RDfGmyoj3q4HtacrVdW44zkGjh7LpAn6mldcMSBgqBILbUubAcsKqjPXxv+l2jKj6
	0ASP2Z3O+Hhb5Tp7U9rLL0+k5LowCZYQSTT1EX9DBZu0DeZtT4tiV6wHFaPjjbGez5EP/ehyBP8
	lzker2H3M0TVkvCPghqfRmWG8WL93y0AcrqBfhS0KYo9ExK2KZTvyE7rNDAwK+fMSOBrrpPIiKO
	/ku7Vko=
X-Received: by 2002:a05:622a:190f:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5064b037245mr5687441cf.17.1770623706972; Sun, 08 Feb 2026
 23:55:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
 <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com> <0015e5ecd6e9170184ae7309c48f09ae5d64645f.camel@arm.com>
In-Reply-To: <0015e5ecd6e9170184ae7309c48f09ae5d64645f.camel@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Feb 2026 07:54:28 +0000
X-Gm-Features: AZwV_Qg_ig_q9lhC9p681Uohkb4hSAHj_Y9px81RoSgO1zhvrj9J-6CbFicBHg4
Message-ID: <CA+EHjTxX4Ag0kq7tvNZGs4XMRNaaKxwuSXjN-+B3AjC=r7mVkQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>, 
	"will@kernel.org" <will@kernel.org>, nd <nd@arm.com>, 
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-70586-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.linux.dev,arm.com,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:url,arm.com:email,mail.gmail.com:mid,atlassian.net:url]
X-Rspamd-Queue-Id: 5092B10CA92
X-Rspamd-Action: no action

Thanks Sascha,

On Thu, 5 Feb 2026 at 18:24, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> On Thu, 2026-02-05 at 10:58 +0000, Fuad Tabba wrote:
> > Hi Sascha,
> >
> > I would like to review and test this series. Do you have it in a
> > branch somewhere, since it's not trivial to apply it to kvmtool
> > master
> > as this is based on the nv series.
> >
> > Cheers,
> > /fuad
>
> Hi Fuad,
>
> Thanks a lot for taking a look - that's really appreciated.
>
> I've pushed this series (based on v4 of the NV series) to:
> https://gitlab.arm.com/linux-arm/kvmtool-sb/-/tree/gicv5_support_v2
>
> I've also pushed the my latest version of the changes (based on v5 of
> the NV series) here:
> https://gitlab.arm.com/linux-arm/kvmtool-sb/-/tree/gicv5_support_next
> Currently, the only noteworthy change is that --help now mentions gicv5
> & gicv5-its for --irqchip.

Got it, and it builds fine.

> As I've said in the cover letter, you'll need to only apply this series
> up to and including "arm64: Update timer FDT for GICv5" if you're
> working with the posted GICv5 PPI patches. Going beyond that results in
> a UAPI mismatch as more of the GICv5 support is added to KVM.

Ack.

> I've pushed v4 of the GICv5 PPI KVM series to:
> https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_ppi_support_v4
>
> There is a more complete but WIP set of KVM changes (GICv5 + IRS + ITS
> w/ PPIs, SPIs, and LPIs) at:
> https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_support_wip
> This latter set can be used with the complete kvmtool series to run an
> actually useful guest.

Ack.

> Lorenzo Pieralisi has created a useful page on how to run with the FVP
> (but note that you'll want the 11.30 release for virtualisation
> support). https://linaro.atlassian.net/wiki/x/CQAF-wY

I set that up recently. I had to make a couple of changes to the
gicv5.yaml, but it boots fine.

> Please let me know if you have any issues, and I'll do my best to help.
> Thanks in advance for any review comments you have, and for your time
> in general!

Thank you!
/fuad

> Thanks,
> Sascha
>
> >
> > On Fri, 16 Jan 2026 at 18:27, Sascha Bischoff
> > <Sascha.Bischoff@arm.com> wrote:
> > >
> > > This series adds support for GICv5-based guests. The GICv5
> > > specification can be found at [1]. There are under-reiew Linux KVM
> > > patches at [2] which add support for PPIs, only. Future patch
> > > series
> > > will add support for the GICv5 IRS and ITS, as well as SPIs and
> > > LPIs. Marc has very kindly agreed to host the full *WIP* set of
> > > GICv5
> > > KVM patches which can be found at [3].
> > >
> > > v1 of this series can be found at [4].
> > >
> > > This series is based on the Nested Virtualisation series at [5].
> > > The
> > > previous version of this series was accidentally based on an older
> > > version - apologies!
> > >
> > > As in v1, the GICv5 support for kvmtool has been staged such that
> > > the
> > > initial changes just support PPIs (and go hand-in-hand with those
> > > currently under review at [2]). As of "arm64: Update timer FDT for
> > > GICv5" the support is sufficient to run small tests with the arch
> > > timer or PMU.
> > >
> > > Changes in v2:
> > > * Used gic__is_v5() in more places to avoid explicit checks for
> > > gicv5
> > >   & gicv5-its configs.
> > > * Fixed gic__is_v5() addition leaking across changes.
> > > * Cleaned up FDT generation a little.
> > > * Actually based the series on [5] (Sorry!).
> > >
> > > Thanks,
> > > Sascha
> > >
> > > [1] https://developer.arm.com/documentation/aes0070/latest
> > > [2]
> > > https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@arm.com
> > > [3]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv5-full
> > > [4]
> > > https://lore.kernel.org/all/20251219161240.1385034-1-sascha.bischoff@arm.com/
> > > [5]
> > > https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm.com/
> > >
> > > Sascha Bischoff (17):
> > >   Sync kernel UAPI headers with v6.19-rc5 with WIP KVM GICv5 PPI
> > > support
> > >   arm64: Add basic support for creating a VM with GICv5
> > >   arm64: Simplify GICv5 type checks by adding gic__is_v5()
> > >   arm64: Introduce GICv5 FDT IRQ types
> > >   arm64: Generate GICv5 FDT node
> > >   arm64: Update PMU IRQ and FDT code for GICv5
> > >   arm64: Update timer FDT IRQsfor GICv5
> > >   irq: Add interface to override default irq offset
> > >   arm64: Add phandle for each CPU
> > >   Sync kernel headers with v6.19-rc5 for GICv5 IRS and ITS support
> > > in
> > >     KVM
> > >   arm64: Add GICv5 IRS support
> > >   arm64: Generate FDT node for GICv5's IRS
> > >   arm64: Update generic FDT interrupt desc generator for GICv5
> > >   arm64: Bump PCI FDT code for GICv5
> > >   arm64: Introduce gicv5-its irqchip
> > >   arm64: Add GICv5 ITS node to FDT
> > >   arm64: Update PCI FDT generation for GICv5 ITS MSIs
> > >
> > >  arm64/fdt.c                  |  22 ++++-
> > >  arm64/gic.c                  | 179
> > > ++++++++++++++++++++++++++++++++---
> > >  arm64/include/asm/kvm.h      |  12 ++-
> > >  arm64/include/kvm/fdt-arch.h |   2 +
> > >  arm64/include/kvm/gic.h      |   9 ++
> > >  arm64/include/kvm/kvm-arch.h |  30 ++++++
> > >  arm64/pci.c                  |  16 +++-
> > >  arm64/pmu.c                  |  23 +++--
> > >  arm64/timer.c                |  20 +++-
> > >  include/kvm/irq.h            |   1 +
> > >  include/linux/kvm.h          |  20 ++++
> > >  include/linux/virtio_ids.h   |   1 +
> > >  include/linux/virtio_net.h   |  36 ++++++-
> > >  include/linux/virtio_pci.h   |   2 +-
> > >  irq.c                        |  16 +++-
> > >  powerpc/include/asm/kvm.h    |  13 ---
> > >  riscv/include/asm/kvm.h      |  27 +++++-
> > >  x86/include/asm/kvm.h        |  35 +++++++
> > >  18 files changed, 416 insertions(+), 48 deletions(-)
> > >
> > > --
> > > 2.34.1
> > >
>

