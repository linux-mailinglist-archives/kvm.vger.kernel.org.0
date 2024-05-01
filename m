Return-Path: <kvm+bounces-16328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 374A18B882B
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62441B226A4
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C7E6F067;
	Wed,  1 May 2024 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoyiRHvD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417250A93;
	Wed,  1 May 2024 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714555997; cv=none; b=B+5rAdHb8Uraba46btqqdf3+zw3P1xGKgSmt5lj7uUH2sWbqpEfIemowGC9UODYQuyyW62AgVqwR8IrhGzMNQLt3Cp8rdl+tQ+tniMQ+cV+17Yhb+oMXlMsdKoROcVynda7Qu6Z2pdAOzOLwuWAt36l/fPvp4bQ+nINdpmcgob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714555997; c=relaxed/simple;
	bh=DclVSrlrdkcZr1ObaRHJvxosciV2uhyezrUD7sSt2m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/d6TQoBKXFIeO6fU63SGIf14uwSNYKB8ifK2DRvkof+IfCAKsxKzvzU14130vtcy32wEwANlc4+l9+QXyuLtZm/KzUwxw3iXuikhooK6f82eZuWLzA8C+zUB8xvML3fgY58exw8jvehLUZcKmzijmFWViIYeHd+6HFpcQ8ft+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoyiRHvD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4761AC113CC;
	Wed,  1 May 2024 09:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714555996;
	bh=DclVSrlrdkcZr1ObaRHJvxosciV2uhyezrUD7sSt2m4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IoyiRHvDC5flpZ/DSE5pjSTFZXfBhn4045k0KTJ2GdINO/K0dfQxuXvQ5kJZfrD2v
	 zL49ouEdNeCtucCnhGMrmZkG15cOO7qk9mBV54mj239E15LuSBe9cq3rZ7spKvn3GK
	 VSXpB50YRUGC1ZMAJQ+k+sLgnkFRjs1yHiZHn/4XPj5XlJRFp3sIjpi5+3L96p9g5/
	 yS2a87JFuJ74y9SHIjU2dLti59i3PuPdtwAzE9Jl1eF/N9xRuFbq7o7V3tc4UtHhZB
	 ZrHR5OSOp8VgPnkuKNMXPlDLsN9lK3nuGgFO5KQSeEVnEDOwIXdOSZ/EAkM6mxNuq6
	 1Q2e+LF8TG+lQ==
Date: Wed, 1 May 2024 10:33:11 +0100
From: Conor Dooley <conor@kernel.org>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 08/11] riscv: add ISA extension parsing for Zcmop
Message-ID: <20240501-dazzler-sandworm-defb8d7345e1@spud>
References: <20240429150553.625165-1-cleger@rivosinc.com>
 <20240429150553.625165-9-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bzCcwQgeWm10dOJ9"
Content-Disposition: inline
In-Reply-To: <20240429150553.625165-9-cleger@rivosinc.com>


--bzCcwQgeWm10dOJ9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 05:05:01PM +0200, Cl=E9ment L=E9ger wrote:
> Add parsing for Zcmop ISA extension which was ratified in commit
> b854a709c00 ("Zcmop is ratified/1.0") of the riscv-isa-manual.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <cleger@rivosinc.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.


--bzCcwQgeWm10dOJ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZjIMVwAKCRB4tDGHoIJi
0qS2AQDd5pQQV1Lo9gk6mG0PPGVg8VQ3JQTP3B6Td3sgZ3TSUwD/VRGQ9RYmks2d
95wqK6MMvSBVf0bbdPHFZ7rwAOMKXAw=
=7zWw
-----END PGP SIGNATURE-----

--bzCcwQgeWm10dOJ9--

