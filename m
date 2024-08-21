Return-Path: <kvm+bounces-24735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F081495A002
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F1891C226E8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1470D136E37;
	Wed, 21 Aug 2024 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7jmxiwB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC51607B0;
	Wed, 21 Aug 2024 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250852; cv=none; b=dWlr+p5ulRktZiO6q6gR3VZYcvo1AlnX2WOYp7PeE+FErk/H93bKcU0gPlb9wImev+Y3IZuLOortNEBqaWlukOnYG2EPHQFy22RHjEt6o4jV2nFnJGS9HzRKlHhXFu4RCiwUI6tsF8dCJ1s3D6GgRw5ECHiv3WHfiFTHvMHdd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250852; c=relaxed/simple;
	bh=P0mlLXIUnVQlyK7lCZO60213nO6YY8Dwxta1Sdk/oZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4eDqu0WXkbh2XMgYnTpI82h9pFiFXhf9R2TXWDZF1vNWo5+7pW4TT8HA8O6GqiF26J55WsxyqKaGr7JVYzI4cb29iRYihIe+sABPbsY5zfL1qjYzwLs7Pu4gVnQ7/Y6qPw3zDASD640I24ihD6jq2E50FXyLtp45B+prOkxyf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7jmxiwB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ECAC4AF11;
	Wed, 21 Aug 2024 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724250851;
	bh=P0mlLXIUnVQlyK7lCZO60213nO6YY8Dwxta1Sdk/oZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g7jmxiwBKeJoRalYN/a72ZO1Zfrr07mXXETNlAsIo65Wc9BJB22kMvFBWqhhXGZJK
	 9n5ZptCK3paVUy9mP4lPz5p00fgv/OjVBgC2hJdbTKSxHJWalmydSQBTiaLmdBa4tK
	 8Cr8E5MwG9y8x2tOxviPXhPS0gwhrL72CI8c7wV/vHEhORlS+kdiAlz6/kAgDri+9F
	 8CNH+hKbQlLpu2zazeQdwhRetUNY4UpFAuDDVg52IbLibprmQjOGLTB80L6Tvm/CRO
	 mocsk/2V8DlIggF2WCq/OUrZmLKcjsr4IQ56hIGv3/I7wIKTIG02EV/RojpOk8gaDk
	 66fAoPBxRlACw==
Date: Wed, 21 Aug 2024 15:34:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v4 0/8] KVM: arm64: Add support for FP8
Message-ID: <8113b175-054d-4793-80b9-c9fe20fa9f9f@sirena.org.uk>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WCIAYnmD4iBdUtKW"
Content-Disposition: inline
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
X-Cookie: You are false data.


--WCIAYnmD4iBdUtKW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2024 at 02:17:54PM +0100, Marc Zyngier wrote:
> Although FP8 support was merged in 6.9, the KVM side was dropped, with
> no sign of it being picked up again. Given that its absence is getting
> in the way of NV upstreaming (HCRX_EL2 needs fleshing out), here's a
> small series addressing it.

The code looks good to me and I didn't spot any problems in testing so:

Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>

--WCIAYnmD4iBdUtKW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbF+t0ACgkQJNaLcl1U
h9BN8gf/ciUedK7TLd2mdnpzZCKzRTnE44AFDMf9meFAzv0B94LnQAYh97UIawGg
pignxgeyyMqbfwRlvsM087vghJt+irapXgHuOs9I82CNDcQEzDK/s59WUr+VSf/3
JvA8e1w/rsmPAq4EM8wz+2rAWbfxVeb5vCzikY2QjRPEty0rXSUhMzF4HsGlwIti
7Njp4Z6wBo0DKEcyaBahI1g7EAjCX3guGgFL5E3E+3kb2FXVX5n15ZwiooFaGUJ9
u+kEzxnnViD7JEwIOzFI3FRVucY0rn/ERDPiSGLzaDxaTxqb+K/PptkDNBKSQs7c
cid6Lq/3yXFM2C7c51OZHLeAQqTEWQ==
=xYtS
-----END PGP SIGNATURE-----

--WCIAYnmD4iBdUtKW--

