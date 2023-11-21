Return-Path: <kvm+bounces-2204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C7797F34DF
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC9DAB2196D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042D45B1ED;
	Tue, 21 Nov 2023 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKpUi+Hb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD3168BD
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 17:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D246C433C8;
	Tue, 21 Nov 2023 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700587394;
	bh=A1AiSQpqc9fSmXMRgtqpneZpzFCfm1C+I4tLcYy9+1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rKpUi+HbhkedgyawXuAgVWI8M32Lb0+oSiTHmpElgAGaUGuQZLK/6LQOni/4vFo5L
	 QRfE/wnyvfauMSciswNkc1mumPWA1jh/QqckcBAOFt8cqno538OYYYfULcnChDJgV0
	 midvg34doNwwxtRTKdI+tnsyzChDeDSU6fNYq/myf7/06CuZED0S0yPu2xxdXtwa1X
	 4Gr7Y/L32XSkUtEj8ZJnFWTpcI5OwAQ+94lCyc3DVrOMMjBTuB8Meagra15dBunzYy
	 ie56rkJjkAWF5b0ubvmH65O2PUvC9owO9GobraqpnpqLmxQsED27zCVxj5lOIS/Hqm
	 TvAYrLIwZDlpg==
Date: Tue, 21 Nov 2023 17:23:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] selftests/kvm: fix compilation on non-x86_64 platforms
Message-ID: <ZVznfV5SshVSNo5W@finisterre.sirena.org.uk>
References: <20231121165915.1170987-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p0jBt5KgZ6HnGNEY"
Content-Disposition: inline
In-Reply-To: <20231121165915.1170987-1-pbonzini@redhat.com>
X-Cookie: Slow day.  Practice crawling.


--p0jBt5KgZ6HnGNEY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2023 at 11:59:15AM -0500, Paolo Bonzini wrote:
> MEM_REGION_SLOT and MEM_REGION_GPA are not really needed in
> test_invalid_memory_region_flags; the VM never runs and there are no
> other slots, so it is okay to use slot 0 and place it at address
> zero.  This fixes compilation on architectures that do not
> define them.

Tested-by: Mark Brown <broonie@kernel.org>

Thanks, this'll make my CI and work's a lot happer!

--p0jBt5KgZ6HnGNEY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVc53wACgkQJNaLcl1U
h9BA3Af/dWbj2WKnUQYaHRAqg4nALwzxtfblwa2g67kTovBfJyYus9h2EBUgIqiI
yb/glPQ12njZ5sdKFYdQhAHtcIH+wYKbqSDg/Ux7bTCkIhhT8LsSfQ9MS5d2tDCz
OG9tSD3SFPIgCWAH1kOXuzjwcBStWHy1e23zACSNho8ruZgTJUN5HlYABOIndvKD
jTxQVFhPDwuZdgZlRuGl7nXXSWS+xH4kBa2NMLD2J7KSfs0QlYoNyHdDP5pBBr9u
ZD+f82/n8i/WimCsRQBYBjxRZw3sjrJoU8EhAdxTG3GzluRbVd1Gs20Z9Sqty0qq
FeXklR1hVd+fGDtBT6oHtPesmxvHug==
=UUpO
-----END PGP SIGNATURE-----

--p0jBt5KgZ6HnGNEY--

