Return-Path: <kvm+bounces-68711-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6C0oDRHJcGkNZwAAu9opvQ
	(envelope-from <kvm+bounces-68711-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:39:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF6D56EDD
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F2B9C9C946C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302A3481A9D;
	Wed, 21 Jan 2026 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMUFHYYp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D7313268
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998756; cv=none; b=DLJLgbBT55mcsfJNJXFKhYz+8Zx15brQVLETIDj1M4t2RRcBnEiPh1bj2XCuDDgu9fOmga5W0PmQ/l+jAnGdv7UQGfEQsyfY5yk6jSfcsiL9HEq6BJjEQKEqkGNB7ro/JX+rVO5c1QWol+KPMUHhbXYBbdGg6TidfGYV/mm4zM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998756; c=relaxed/simple;
	bh=9INNlyYJIxn6FYma2m4J/etePBze8DGUW7xkS+dhtwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgZR5Id+DEi84qFUN9fyCK9piSME8jc4hqi2N5QxU7rDmGvfB6G1lxER9g0JPHnpuv6h/GdveEyP6Sjxsg96jJkjvQcCs5ICR0D3AQH12IAK8YqR0//wEZTI+S7NcT9A7FqTgmNbfeiCyL531A0c/O9Zb18Oh1hmOthykqV9BoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMUFHYYp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693B3C19421;
	Wed, 21 Jan 2026 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998755;
	bh=9INNlyYJIxn6FYma2m4J/etePBze8DGUW7xkS+dhtwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eMUFHYYpQYjG++XvtHjgtl57q/JLvzJfeYv0vnez0SVrZt8uGC+w/jyh7Glw5tmfs
	 mhacbxniDsT2XABiw7u4VXGfke5Sp9fkcpJkC4Q53cV+/n+yYw1ejwTLK0HHDKfq8X
	 N8zhMPxrh5Zo+kKxiHuDVoOjsCHnveo2ppXNippvvje3l6pInVFFpnS1Mx54/Lq/Lu
	 hKMhc1CEcdaWKSH1aYx4ftrx2RHpLWCpBIwCqp1ImfjImErvnaDvG87E//RM+uastH
	 iYf9n9jd82K+wBdZRRM+acSIQ/GdhRmYpJEp+ZghXPKZ71gsJCeJ/y6w6JjdxnntFk
	 AoSOeuyvJ2NPA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8C905F4006B;
	Wed, 21 Jan 2026 07:32:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 21 Jan 2026 07:32:34 -0500
X-ME-Sender: <xms:YsdwaThAp0pgqZnDgZv2f8w4JnWDamz9dQUDUr1b6UXdsDzpfehhaQ>
    <xme:YsdwaY0XnCdmGBdznGa4tEa8p73u1zd3ygzZPGLeKspwBPFfxqB99Bdr9ahSHFibj
    mezAs_ORMdOtIsnlWhlGKujM3a2ZxyDEsXcqL8GPbgoSJwbcUWzTvM>
X-ME-Received: <xmr:YsdwaaBvbxjBCmHLVmvEWg_XPBz5muZV1h4U3pRuSvkpQziw2kony68d4yQQPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehsvggrnhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepthhglhigsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopegurghvvgdrhhgrnhhsvg
    hnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepphgsohhniihinhhisehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:YsdwaZ18r_dH1XzSzL0_KTcs4sr_cV4EpVgb9PQ7EaD1Tc4LRmtuFQ>
    <xmx:YsdwaZoUN4Nu0fIjhQoGx6K1bUWIQ1HAZADKknSKmKv6mxf44bIjQQ>
    <xmx:YsdwaVUEe8LHQFW-hzS8_z3Bs8WB1u1x38wmE0v9tTAg48se990-Mg>
    <xmx:YsdwaVh3AgjM4_caT7rjvPBfv4I9Cd7226oL__H6bUqpMjrMASNzvg>
    <xmx:Ysdwac_-ZgVPOGCqNSVfQIOALWuciIu6x8OXTYrNV-Tah3oMAyvep2e8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 07:32:32 -0500 (EST)
Date: Wed, 21 Jan 2026 12:32:27 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH] x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's
 0-based level
Message-ID: <aXDHR2dS8fW_Xxir@thinkstation>
References: <20260120203937.1447592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120203937.1447592-1-seanjc@google.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68711-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kas@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9EF6D56EDD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 12:39:37PM -0800, Sean Christopherson wrote:
> Rework the TDX APIs to take the kernel's 1-based pg_level enum, not the
> TDX-Module's 0-based level.  The APIs are _kernel_ APIs, not TDX-Module
> APIs, and the kernel (and KVM) uses "enum pg_level" literally everywhere.
> 
> Using "enum pg_level" eliminates ambiguity when looking at the APIs (it's
> NOT clear that "int level" refers to the TDX-Module's level), and will
> allow for using existing helpers like page_level_size() when support for
> hugepages is added to the S-EPT APIs.
> 
> No functional change intended.
> 
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

