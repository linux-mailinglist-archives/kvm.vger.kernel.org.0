Return-Path: <kvm+bounces-29304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B589A7262
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 20:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40D38B21C00
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 18:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7D11FAC29;
	Mon, 21 Oct 2024 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsmBuPJs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CD3A41;
	Mon, 21 Oct 2024 18:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535538; cv=none; b=kOCIbLbfQc+dAF7ShLDzOy1NN1e4yFg2pML6smnFNbnx2USw4iWTIx9ju66mjzaSX7AWlkwE/0Qctmrst9Tohly3uxBFBviqUZJ3PRvdoDiDcMvJCAVFZ5ICj04hhoK7c3Vv7pIXZqVv/mHm1vy/lR0Bw+euu72A1HqEKC2oW4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535538; c=relaxed/simple;
	bh=pyzBm0CHxtwGCiTGX+R2MXyhePBYI6qHIcFJ4NEy704=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ly2p4FwhVksJj+Tmk9a/V920n8r+S32j1BERxXMhY47fNxGvOiU8FIdOPsYFfRXzvZAgVnR93Pthcd3iMqWGmVg6v/zRyiaqJFanC4X/AkXpKAg0jFmd2++lfkftZQ0me02nq6glceBoubSq0uxTNbLmUoHPMHqeFrZcb7sFeJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsmBuPJs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205D5C4CEC3;
	Mon, 21 Oct 2024 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729535537;
	bh=pyzBm0CHxtwGCiTGX+R2MXyhePBYI6qHIcFJ4NEy704=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YsmBuPJs5KQTszv56fUCa4qm/bfQeZggdOhOj6FpPImCqi9uTwz0HDGmeR5I2XDZO
	 0f4Uu3SlSN8HTCF+1wwH1tIDneP+Vo1ZjIuUqhexULDUMXQBSCIPD7C/MlMJfhWi4P
	 pwO13Gs7FcmsKn7A5+5czaAnt9yJbMFLd7MGa/qlbfNg2j4I6JnclcZEGDhLMMpm7O
	 RLMQ0C7Wf02lIskF6eA1yHNXMo6XvUvnxbxYTxtBtUwv/II/LI0+8GDh70BCFZcABx
	 jaQeCifmfo/MTtgi/moFcicb8+TpbbpQoVmG3jUHSZLIzCSrO2OtOWwNeYCtuylh1l
	 rh0el/PK2tOmg==
Date: Mon, 21 Oct 2024 19:32:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
Message-ID: <9a160e3d-501b-4759-9067-17cd822617ec@sirena.org.uk>
References: <20240920154422.2890096-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nKMoXBYbWb2e++RT"
Content-Disposition: inline
In-Reply-To: <20240920154422.2890096-1-vkuznets@redhat.com>
X-Cookie: Thufir's a Harkonnen now.


--nKMoXBYbWb2e++RT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 05:44:22PM +0200, Vitaly Kuznetsov wrote:

> Some distros switched gcc to '-march=3Dx86-64-v3' by default and while it=
's
> hard to find a CPU which doesn't support it today, many KVM selftests fail
> with

This patch, which is queued in -next as 9a400068a1586bc4 targeted as a
fix, breaks the build on non-x86 architectures:

aarch64-linux-gnu-gcc -D_GNU_SOURCE=3D  -Wall -Wstrict-prototypes -Wuniniti=
alized=20
-O2 -g -std=3Dgnu99 -Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFI=
G_64BIT
 -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset -fno-builtin-s=
trnlen -fno-stack-protector -fno-PIE -I/build/stage/linux/tools/testing/sel=
ftests/../../../tools/include -I/build/stage/linux/tools/testing/selftests/=
=2E./../../tools/arch/arm64/include -I/build/stage/linux/tools/testing/self=
tests/../../../usr/include/ -Iinclude -Iaarch64 -Iinclude/aarch64 -I ../rse=
q -I..  -march=3Dx86-64-v2 -isystem /build/stage/build-work/usr/include -I/=
build/stage/linux/tools/testing/selftests/../../../tools/arch/arm64/include=
/generated/   -c aarch64/aarch32_id_regs.c -o /build/stage/build-work/kself=
test/kvm/aarch64/aarch32_id_regs.o
cc1: error: unknown value =E2=80=98x86-64-v2=E2=80=99 for =E2=80=98-march=
=E2=80=99

This is because:

> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index 48d32c5aa3eb..3f1b24ed7245 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -238,6 +238,7 @@ CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitialized=
 -O2 -g -std=3Dgnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>  	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> +	-march=3Dx86-64-v2 \
>  	$(KHDR_INCLUDES)
>  ifeq ($(ARCH),s390)
>  	CFLAGS +=3D -march=3Dz10

unconditionally sets an architecture specific flag which is obviously
not going to work on anything except x86.  This should be set under an
architecture check like the similar S/390 flag that can be seen in the
context for the diff.

--nKMoXBYbWb2e++RT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcWniwACgkQJNaLcl1U
h9BYogf/eDE5fDBfcReAjReqJDkasaQLJfWc+Ak+v4uCbqw9mBLCPyaYWfEW0snN
cK13zFzB6Fr0KQa5+cGcdaCPIqSwc2YWX83ljaS8Q8x9PemPIU4K+sIH9NY/E9hE
gd6oGL2wSZIhe7kpL7D2U6yrx+ItFfg77kxMgc9MABuYPNN5QS0SRvs9UUVBkDYm
pZ3zZqI+9Z1FJMWUb4W9b5YRMjlKUDNz4pKvR6zTf8/935BAKV39ReatYrXjcFbW
xfVrnUDw9LjXza1P+mw0GL8572WgGrydF1sY32HYVAhL6Pxkx2dNE68i19sRDj1x
ZB0f0DIwsZU8XuD88KV44cZdoTphzA==
=/jnL
-----END PGP SIGNATURE-----

--nKMoXBYbWb2e++RT--

