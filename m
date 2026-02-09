Return-Path: <kvm+bounces-70566-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLgwKkpFiWkT5gQAu9opvQ
	(envelope-from <kvm+bounces-70566-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 03:24:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F15B10B0FC
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 03:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 616E8300FB4A
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 02:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3736125F7B9;
	Mon,  9 Feb 2026 02:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="EX0hk+Gs"
X-Original-To: kvm@vger.kernel.org
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C5B23D291
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 02:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770603758; cv=none; b=Q7w5HoUatFfYTm9hapy8K4EzAAB8vCkrRwzwboHC0Nzy55DNNhjGPdasoqz6Q/S4R2wx6BzoP9259/XxR7wtSt84h9REF+myAEApJCzpLKb2SHXchwUcgIM2SQGbC+1sUUX0vOJDZ+kGNv0Uer/QXw9TwExQJT4d7NST6gmMktA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770603758; c=relaxed/simple;
	bh=uEoAxL7Z0R6R42jyAePfMGOhe3kCV3QDCbGYYM4fPo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTJK0gmahoQWaFh9PGvwGwCAkyrY3k92U3tBmtA+CrzkGrx26Fk4zH6mM1CdB+9SmHUBAZEGhoMsV2R6aS384Ag314rIteE2kyo0iC9dfsqFLdAEe+IS2ThlB1ez4cfMYm1m9hG1TeYPzAiBBaG8NomWc9iqixlO38cuippiWCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=EX0hk+Gs; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1770603758; x=1802139758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uEoAxL7Z0R6R42jyAePfMGOhe3kCV3QDCbGYYM4fPo4=;
  b=EX0hk+GsgWDU1FbCFxv2dhS1d7q5m7aYx6yBFswdi8Q+wVGaVLibbiRw
   7bOfkSVQ9GUhqrfckJEKyE7sSiigrP7qHVSgbcEhhIFeaL06CWoQI50XL
   BLaoPsdB1fI2HsMrVSKHXCdB1bk1yylcbOT6XpIjMCLQyICeO0Thix71T
   7JgM4+KCpRdnaDrhnzMvHwaA5G3QrqQ9tSkOhWzqxvBg5RIvv4H3G6gBi
   mxRe0i/j9vKBuqi4Xu5m0bl1gmWOSyjQ7rzif26/eddWLO0Pf0ruX10Rf
   QLFgbGwIloxisE8yNbjKsH3Sy0ygIGLChhreXf5Ftjf4veh5JGAapEAJP
   w==;
X-CSE-ConnectionGUID: 3hvXy3YmT6eLnqGn4pcKSA==
X-CSE-MsgGUID: POJ0V0OLQIOk5kREOwbZUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="228975370"
X-IronPort-AV: E=Sophos;i="6.21,281,1763391600"; 
   d="scan'208";a="228975370"
Received: from unknown (HELO mail.fujitsu.com) ([20.61.8.234])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:21:28 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgr2.fujitsu.com (Postfix) with ESMTPS id 65F2D4DF4
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 02:21:27 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (az2nlsmom1.o.css.fujitsu.com [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 1BA1FC012B7
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 02:21:27 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 38D95829F2E;
	Mon,  9 Feb 2026 02:21:22 +0000 (UTC)
Date: Mon, 9 Feb 2026 11:21:19 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH kvmtool v5 0/7] arm64: Nested virtualization support
Message-ID: <aYlEn74Td8vHSmgJ@sm-arm-grace07>
References: <20260123142729.604737-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123142729.604737-1-andre.przywara@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fujitsu.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[fujitsu.com:s=fj2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org,lists.linux.dev,arm.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70566-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[fujitsu.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itaru.kitayama@fujitsu.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3F15B10B0FC
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 02:27:22PM +0000, Andre Przywara wrote:
> This is v5 of the nested virt support series, fixing a corner case when
> some maintenance IRQ setup fails. Also there is now a warning if --e2h0
> is specified without --nested. Many thanks to Sascha for the review!
> ========================================================
> 
> Thanks to the imperturbable efforts from Marc, arm64 support for nested
> virtualization has now reached the mainline kernel, which means the
> respective kvmtool support should now be ready as well.
> 
> Patch 1 updates the kernel headers, to get the new EL2 capability, and
> the VGIC device control to setup the maintenance IRQ.
> Patch 2 introduces the new "--nested" command line option, to let the
> VCPUs start in EL2. To allow KVM guests running in such a guest, we also
> need VGIC support, which patch 3 allows by setting the maintenance IRQ.
> Patch 4 to 6 are picked from Marc's repo, and allow to set the arch
> timer offset, enable non-VHE guests (at the cost of losing recursive
> nested virtualisation), and also advertise the virtual EL2 timer IRQ.
> 
> Tested on the FVP (with some good deal of patience), and some commercial
> (non-fruity) hardware, down to a guest's guest's guest.

Hi Andre,
I wonder if you have also tested this series with the latest QEMU which
has FEAT_NV2 support; I ask because when I tried to create a nested
guest with (again) lkvm it got stuck forever.

Thanks,
Itaru.

> 
> Cheers,
> Andre
> 
> Changelog v4 ... v5:
> - bump kernel headers to v6.19-rc6
> - print a warning if --e2h0 is given without --nested
> - fail if the maintenance IRQ setting attribute is not supported
> 
> Changelog v3 ... v4:
> - pass kvm pointer to gic__generate_fdt_nodes()
> - use macros for PPI offset and DT type identifier
> - properly calculate DT interrupt flags value
> - add patch 7 to fix virtio endianess issues
> - CAPITALISE verbs in commit message
> 
> Changelog v2 ... v3:
> - adjust^Wreplace commit messages for E2H0 and counter-offset patch
> - check for KVM_CAP_ARM_EL2_E2H0 when --e2h0 is requested
> - update kernel headers to v6.16 release
> 
> Changelog v1 ... 2:
> - add three patches from Marc:
>   - add --e2h0 command line option
>   - add --counter-offset command line option
>   - advertise all five arch timer interrupts in DT
> 
> Andre Przywara (3):
>   Sync kernel UAPI headers with v6.19-rc6
>   arm64: Initial nested virt support
>   arm64: nested: Add support for setting maintenance IRQ
> 
> Marc Zyngier (4):
>   arm64: Add counter offset control
>   arm64: Add FEAT_E2H0 support
>   arm64: Generate HYP timer interrupt specifiers
>   arm64: Handle virtio endianness reset when running nested
> 
>  arm64/arm-cpu.c                     |   6 +-
>  arm64/fdt.c                         |   5 +-
>  arm64/gic.c                         |  29 ++++++-
>  arm64/include/asm/kvm.h             |  25 ++++--
>  arm64/include/kvm/gic.h             |   2 +-
>  arm64/include/kvm/kvm-config-arch.h |  11 ++-
>  arm64/include/kvm/kvm-cpu-arch.h    |   5 +-
>  arm64/include/kvm/timer.h           |   2 +-
>  arm64/kvm-cpu.c                     |  64 ++++++++++++---
>  arm64/kvm.c                         |  19 +++++
>  arm64/timer.c                       |  29 +++----
>  include/linux/kvm.h                 |  47 +++++++++++
>  include/linux/virtio_ids.h          |   1 +
>  include/linux/virtio_net.h          |  49 +++++++++++-
>  include/linux/virtio_pci.h          |   3 +-
>  powerpc/include/asm/kvm.h           |  13 ----
>  riscv/include/asm/kvm.h             |  29 ++++++-
>  x86/include/asm/kvm.h               | 116 ++++++++++++++++++++++++++++
>  18 files changed, 394 insertions(+), 61 deletions(-)
> 
> -- 
> 2.43.0
> 

