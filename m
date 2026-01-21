Return-Path: <kvm+bounces-68754-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QITYMDggcWmodQAAu9opvQ
	(envelope-from <kvm+bounces-68754-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:51:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 375935B8B2
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CBBA3A4F310
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4046E3A1E9D;
	Wed, 21 Jan 2026 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs53a3dz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE130CDBC;
	Wed, 21 Jan 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013394; cv=none; b=f0hgtM2b/0nROwovXffZTFVkt+5LK1KJ2YBrNg9/34vixu9tyjyTdG+t5bdV1WxbkV2iOUTa34vjc0hmIj4vXybZIg16wzFMxMKUDSTGotyqb02mc08tmM1TaIxIFdzwxSANLcDTC7V0Jp3E4qpPCaBNtp8tUtOo0l9o4weftwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013394; c=relaxed/simple;
	bh=jyOJK9Brcl5ZhV3njyf4Ouj8+fRI7j/5TDwpUrYhhXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZYU/6HDOPzGPf4HBkIEdC2JA7lY8uU0S2LUXE60lYgtZiiAaJKLoiNtUseUYrQxIgydxlhm00+NdhdCh3YSe07uPcPpebYB+gqTu1xeRZiPxxvqmxx2Op8cmSW70JqzEZaJJy55R9Jd+i8SX2UwrIJE0+3UcQktPAOxkUiUDlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs53a3dz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC97EC4CEF1;
	Wed, 21 Jan 2026 16:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013393;
	bh=jyOJK9Brcl5ZhV3njyf4Ouj8+fRI7j/5TDwpUrYhhXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zs53a3dzsy5r4PU1K9PbWEb29lqyMc8Z4LfVH4n2J6kl/zuNIeNgEJB8SAe4xCcab
	 y65vr7O65h02QXskM4MYait5EBO2A7Vcmg+k6p9I9bXjjF/ejdB/Z6iWohzEmIwaT7
	 VNhVHC3wWxUTaFNoKYxWnQKbdLgzvKVFTXoLehBsnWcr4Z5e7xBxC4vOPhRQ0RIy3z
	 0d3f/j3ufkuXBv0PZGyZVoNUm351ySV0cr9QbPO5WfkWBLnE3rjkj2q5N6oPRd73ar
	 xXYMgG+XGNU1PQkCuK8yNt6E/ZgwsiXRKn9Q1WfImTMQXo3jltfuO8wqYg5WmSNca6
	 R5q/Nl7u8fyjQ==
Date: Wed, 21 Jan 2026 16:36:26 +0000
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aXEAitvWkRWX_eiL@willie-the-truck>
References: <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
 <aXDbBKhE1SdCW6q4@willie-the-truck>
 <aXDn3iRXEtgaUtnp@e129823.arm.com>
 <aXD81LT6TX32vlTS@willie-the-truck>
 <aXD/YFNirTfoATvN@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXD/YFNirTfoATvN@e129823.arm.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68754-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[will@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:url,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 375935B8B2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 04:31:28PM +0000, Yeoreum Yun wrote:
> On Wed, Jan 21, 2026 at 04:20:36PM +0000, Will Deacon wrote:
> > On Wed, Jan 21, 2026 at 02:51:10PM +0000, Yeoreum Yun wrote:
> > > > On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> > > > > On second thought, while a CPU that implements LSUI is unlikely to
> > > > > support AArch32 compatibility,
> > > > > I don't think LSUI requires the absence of AArch32.
> > > > > These two are independent features (and in fact our FVP reports/supports both).
> > > >
> > > > Did you have to configure the FVP specially for this or that a "default"
> > > > configuration?
> > > >
> > > > > Given that, I'm not sure a WARN is really necessary.
> > > > > Would it be sufficient to just drop the patch for swpX instead?
> > > >
> > > > Given that the whole point of LSUI is to remove the PAN toggling, I think
> > > > we should make an effort to make sure that we don't retain PAN toggling
> > > > paths at runtime that could potentially be targetted by attackers. If we
> > > > drop the SWP emulation patch and then see that we have AArch32 at runtime,
> > > > we should forcefully disable the SWP emulation but, since we don't actually
> > > > think we're going to see this in practice, the WARN seemed simpler.
> > >
> > > TBH, I missed the FVP configuration option clusterX.max_32bit_el, which
> > > can disable AArch32 support by setting it to -1 (default: 3).
> > > Given this, I think it’s reasonable to emit a WARN when LSUI is enabled and
> > > drop the SWP emulation path under that condition.
> >
> > I'm asking about the default value.
> >
> > If Arm are going to provide models that default to having both LSUI and
> > AArch32 EL0 supported, then the WARN is just going to annoy people.
> >
> > Please can you find out whether or not that's the case?
> 
> Yes. I said the deafult == 3 which means that allow to execute
> 32-bit in EL0 to EL3 (IOW, ID_AA64PFR0_EL1.EL0 == 0b0010)
> -- but sorry for lack of explanation.
> 
> When I check the latest model's default option value related for this
> based on FVP version 11.30
> (https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Arm%20Architecture%20FVPs),
> 
>   - cluster0.has_lsui=1 default = '0x1'    : Implement additional load and store unprivileged instructions (FEAT_LSUI).
>   - cluster0.max_32bit_el=3 default = '0x3'    : Maximum exception level supporting AArch32 modes. -1: No Support for A32 at any EL, x:[0:3] - All the levels below supplied ELx supports A32 : [0xffffffffffffffff:0x3]
> 
> So it would be a annoying to people.

Right, so you can probably do something like setting the 'status'
field of 'insn_swp' to INSN_UNAVAILABLE if we detect LSUI.

Will

