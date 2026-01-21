Return-Path: <kvm+bounces-68727-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mL0KExngcGnCaQAAu9opvQ
	(envelope-from <kvm+bounces-68727-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:18:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E48635847F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4B72EA4E144
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A1E4A33E9;
	Wed, 21 Jan 2026 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7BMdWss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E13BC4EF;
	Wed, 21 Jan 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769003788; cv=none; b=aisVROiIHgTv0jraIsBsqbmvWCelppldxbYrUbU/24rNN3y4/UaG54rwoZxVqL+McjOrhRZmZTLK95VbcYoxFL9tEuwwq+XEwpbUilRLScHdYi310nzb/nsyUXi1hDynUbowNnhUISac5iTcncIvX9CFzMOjaEMlsCLji23oKow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769003788; c=relaxed/simple;
	bh=lbBz6UOMJpiAg21QC6WCb59iTGSeHK+XaQZanHQt5+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bl1TaN/kBUcGF/n7BRrKnjzFv6RmhI6QQ1bj39VxS71CA3R10BT8ralO0lJzr0ZBNAuozWy5JqOcDY1WRsxg2B/q5fCRFcO6+AdmLEHsvqoSvUjbrHW63kDitwDo9irWKrg74SyJl+DzOrtEHjx/5OqUtxeYnuT2ieY1PIDhRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7BMdWss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6934CC4CEF1;
	Wed, 21 Jan 2026 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769003787;
	bh=lbBz6UOMJpiAg21QC6WCb59iTGSeHK+XaQZanHQt5+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T7BMdWsscuprZQVqjgOlNMHQ95GLHAGfSruDk8Hm1EMwxIKP96InkuM3UMB7u5rYV
	 HmvbfCjC3dF3OtyAqUAGXRrOEG+6qNhEap/BNJSlBkGCK4BHHWr9hqNpbxq+i6IO0T
	 2ihErp/aMr/i01amz4uGoEOIRafJCwUjPZiVZSYo/r3Sp++Ui8WJJsESZqSn4SxkdN
	 JhO7HLuehfbTUyTtffFTnlW4eHwvTQANZr0qQrnavK1cDJa6e27sMJdmuGVwAGVsMN
	 ReeS9iIu+0tK0KErkKI0/LYvUkmH2uwk2TY/Oca1gdt6kwb5t7T3NWjrgzaMam25hx
	 0bNTu3WicJiGA==
Date: Wed, 21 Jan 2026 13:56:20 +0000
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
Message-ID: <aXDbBKhE1SdCW6q4@willie-the-truck>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-10-yeoreum.yun@arm.com>
 <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW/Ck3M3Xg02DpQX@e129823.arm.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68727-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: E48635847F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> On second thought, while a CPU that implements LSUI is unlikely to
> support AArch32 compatibility,
> I don't think LSUI requires the absence of AArch32.
> These two are independent features (and in fact our FVP reports/supports both).

Did you have to configure the FVP specially for this or that a "default"
configuration?

> Given that, I'm not sure a WARN is really necessary.
> Would it be sufficient to just drop the patch for swpX instead?

Given that the whole point of LSUI is to remove the PAN toggling, I think
we should make an effort to make sure that we don't retain PAN toggling
paths at runtime that could potentially be targetted by attackers. If we
drop the SWP emulation patch and then see that we have AArch32 at runtime,
we should forcefully disable the SWP emulation but, since we don't actually
think we're going to see this in practice, the WARN seemed simpler.

Will

