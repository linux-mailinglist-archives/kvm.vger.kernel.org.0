Return-Path: <kvm+bounces-60708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D2EBF8303
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 21:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 117A34EA770
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A0634A3DF;
	Tue, 21 Oct 2025 19:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blllrBLD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E460D2586C8;
	Tue, 21 Oct 2025 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761073456; cv=none; b=uv23e5RN9NSvbT/8DiZwmHgmmnVZN0KDUXrTs05o8IhAj3EARQHlUWRyDfkB/byeRVFVldkbbZIyaenuZXuwcIw2qRbk3pts5F1d7naoLw+F8W8hu8xkW1NUiwqOTAySh2YiiTRDkVbnC4eENBn69yXyOOx4B/hTL/CObwg6G/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761073456; c=relaxed/simple;
	bh=KQ7GCZyUQ06AYLCgiBy0Xwfy+0Jo93S9ayLySNkfnfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lF59TZICleBDiSJhH1n4KQkPgdR/Yvtz4waDDKhqdCyMti1J03IFsmAZ5ZjJ366yO0B3pjzggOsnJRGCJfqPK022XS705bPpSIRBOGrrNJMSSCWCHTha3hZXeXuvFXyv6B+S7x1hOBL8Yy/k6fO9Ke3EpZtVmD3DrGAaEwi6vpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blllrBLD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB262C4CEF1;
	Tue, 21 Oct 2025 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761073455;
	bh=KQ7GCZyUQ06AYLCgiBy0Xwfy+0Jo93S9ayLySNkfnfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=blllrBLD2H7ce7gHB0WQr5plPrbizlNv0VqjVI9vaywwvMUIkLmjMMU54xyNELBUm
	 XwjucDKYE3F9YCn0X0tchYfG2/hgRkEv36ASC6s2rpXkbtepBDxb/csNBzlYEaCOsH
	 XdUQAlGp8NM9SjQbeKvf6NHjSQ4zSxgr0glKpCpeBKYXgb+5cEcrvJD5uJiHR1zS2C
	 Z6BdtyTJ3ZSA/zy5/D9Q545xZgwazb25/u1G/38HvcCnmLuWWnuQ7Q8qXYsckD8pf3
	 W6vKNiEQvOU61kHKba/2ulZ/l3j4oQordBqIQQaLWoG4NquRjNGEqKzAvL5G58THHu
	 xGs+fZ/oO24VQ==
Date: Tue, 21 Oct 2025 20:04:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: Re: [PATCH v2 1/4] arm64/sysreg: Fix checks for incomplete sysreg
 definitions
Message-ID: <0ec40909-7ac7-4e55-931a-ad51a2e39726@sirena.org.uk>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
 <20251009165427.437379-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Xza11lcU7Zj4m7Qw"
Content-Disposition: inline
In-Reply-To: <20251009165427.437379-2-sascha.bischoff@arm.com>
X-Cookie: Accordion, n.:


--Xza11lcU7Zj4m7Qw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2025 at 04:54:47PM +0000, Sascha Bischoff wrote:
> The checks for incomplete sysreg definitions were checking if the
> next_bit was greater than 0, which is incorrect and missed occasions
> where bit 0 hasn't been defined for a sysreg. The reason is that
> next_bit is -1 when all bits have been processed (LSB - 1).

Reviewed-by: Mark Brown <broonie@kernel.org>

--Xza11lcU7Zj4m7Qw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj32SkACgkQJNaLcl1U
h9BQFgf/cXubnfy41U65GJJw3zBqgsTUgAmc/G1zDDoYxN41qy8RjEZM5nAwyr99
jyUVxJxmP3WD4++94cxSF99/+mddf4Ah93kj18UDBLRlqRJBypJifkG+Qvz9ToM2
nADMKTWjXNUXrD+DMd7FMTwS3wlEf0J1VT1wiFxuOHkSrddqJLF0z/5ODI1FiV+/
U1kXyGzSohXhBE35eyhJY+KwBP9PFOE6xJcdHqSoTLmhjH8yO/RJrB9UHRsHDukn
YOnkdD0ia/gR5hgSXuYnSyUsc2BwC7ZTIspc8dK0YyFo9p7PF/sB85UBDVMDcVAh
VhuRuO6P5jQG1JdJM4iqNey46ynDyg==
=uzmW
-----END PGP SIGNATURE-----

--Xza11lcU7Zj4m7Qw--

