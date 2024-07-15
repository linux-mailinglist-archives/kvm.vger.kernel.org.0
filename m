Return-Path: <kvm+bounces-21652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5EC93186D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 18:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21185283CD0
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 16:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBDB22318;
	Mon, 15 Jul 2024 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoCCQ+TN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF22208D7;
	Mon, 15 Jul 2024 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721060472; cv=none; b=t7kEcX7OqRTQVZQTibPlE1q21+OTbCzCllzxxBtEe8kO9Y+NazyvA86zXK2N4isBHZ3x44d5jBg+AZoEFmA5exfwWUIK6P8AaE48rVqhxoH3JJpJIK973NMOHGF3rzTJnKqhjcL9PDm6UpbEiJAyYSvrZtjHTsJFEFAn3EpHBlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721060472; c=relaxed/simple;
	bh=3n0CxkXYMZj5Ccsl4uJvi6DkWhAkEYdeW2T81j4AM2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctI59hMBv8z/dgU8ehAI8vb9DSOBiqsQuc45hMPULI8hdOBg+nZp4xEviDPGEQgJLI3RYLYRYATnd6CzCJ+1ktBqDmd3Fvxrs64Hbwp9w4c1bEcHRbJn3A+3bfQ7c9hlj1NgfhW7wnv/lfMJ7NkWNmWoJ4WTx+rKmgZmt0qubYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoCCQ+TN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F120DC32782;
	Mon, 15 Jul 2024 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721060472;
	bh=3n0CxkXYMZj5Ccsl4uJvi6DkWhAkEYdeW2T81j4AM2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoCCQ+TNfFnrRDy/HbUaN2ryQOAS6D32gLdM9BsJGrs0Ryu/WQ0Q874AQKUiAmwP8
	 juZ2cu28HjbAX+ASWBN26XweT1y4NVy1Jx4Y16szA+2F28aUC+/srDEIl7V8QdhqGs
	 6dXr5+kE51Sg9UrSR+u4scBg3JHQ0zsx6WRUNJln90+fEyr9Nsr19+Im6WaQXTn4O+
	 xyPAqQ6Ewec6kl+ZXp0hiamUOq87Si5vtaxqucjSKue6rZgzXkBkgZhyXXWzEvQjfx
	 qSLcfUJif8BfLV8E6XKFzfZgWv+9xsWk49vAguqu2pbRPmkuSbCcA8WpZiVJ2wsAUq
	 D+ilwd0003Zqg==
Date: Mon, 15 Jul 2024 17:21:07 +0100
From: Conor Dooley <conor@kernel.org>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	greentime.hu@sifive.com, vincent.chen@sifive.com,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240715-diligence-corncob-5a2aa2c1d54b@spud>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VCHWytzjaQEVcX02"
Content-Disposition: inline
In-Reply-To: <20240712083850.4242-3-yongxuan.wang@sifive.com>


--VCHWytzjaQEVcX02
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 04:38:46PM +0800, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
>=20
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--VCHWytzjaQEVcX02
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZpVMcwAKCRB4tDGHoIJi
0pYjAQD7lOuEvrM+E9koJjDaPTVPoSEyZSsjZ/iYe2BXlgHJbgD8D52pbL/2Lvcm
VMEDapj3I4kaohFwN98VBpOvrFwMlwc=
=4MyQ
-----END PGP SIGNATURE-----

--VCHWytzjaQEVcX02--

