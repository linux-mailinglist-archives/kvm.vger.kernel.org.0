Return-Path: <kvm+bounces-58037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FA2B8656F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 19:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 367CFB616F1
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB0C286430;
	Thu, 18 Sep 2025 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPlLuA/1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08BC283FD6;
	Thu, 18 Sep 2025 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218273; cv=none; b=b8UORS9ot/I52SYqXLxw+XXEV3gfspCz5lmIDxVzsaiJEFxLavvux4vd+kXhSam2Sr+D05QuEsIf+0cZGfSQa8n35xQYqxnn4wAwxv0CR5+Rhn/684KxMbW/5+/jQlL6S3my/2kInNMAvd2C0VSulC1A/1IjgWUvC8KYtLtHA7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218273; c=relaxed/simple;
	bh=4pw2A6YDxLmBSVcnB2iHeL3gyvvav/DPCrUGQzUCrMA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kmjgu0kTCV1ASVMZbSyi1CJi3ZBwzkoKjTXTLujTtTimTxpTWFqNnqLE61fKjszsIfsn0zl8chm57hDn97qwc2OGz55C6zWX6a/qzXj7GlB1pmoV1Znm+H1rX16N6XGHk3EqhmljkWYExqzhjQiSLL/89l0CVzmNiGUBrIvA2t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPlLuA/1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45C3C4CEE7;
	Thu, 18 Sep 2025 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758218273;
	bh=4pw2A6YDxLmBSVcnB2iHeL3gyvvav/DPCrUGQzUCrMA=;
	h=Date:From:To:Cc:Subject:From;
	b=UPlLuA/1GPIU30NRIU+gOkzOv8pUErGSYbIyCe2FALK+e7LsZS/TgdvMOV93ru/X+
	 1lTmxafaSIru/hndnLAPtiMyADy/Eb4cuHG9pN5mpiP9IM3IaHtiNk8/ANzIvyyM16
	 0U7A8akKcq9pgWlAgYUK6oZdKf8MSc0dtmZJ1vf5ZsnXKZnT9YdqjaUuoF0zLOIlzA
	 WRGsouaEh6YnWYl/bN/J0DKh7y95sbLk5EetORgDTLZ5rsiQhumjZtUezYbjyaXEnY
	 jNV+QO6dUF8hlsES2SfW6PISwVEGs8ipmWCJjx97pjnLapuE/Qm+Sz1TrYZ3QaQL4j
	 uUl10N6IXgcmQ==
Date: Thu, 18 Sep 2025 18:57:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Message-ID: <aMxIHORf_QtgwyCj@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="98i5RO1+y+Bu5kYh"
Content-Disposition: inline


--98i5RO1+y+Bu5kYh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/arm64/kvm/mmu.c

between commit:

  51d165e92a701 ("KVM: arm64: Remove stage 2 read fault check")

=66rom the kvm-fixes tree and commit:

  638ea79669f8a ("KVM: arm64: Refactor user_mem_abort()")

=66rom the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/arm64/kvm/mmu.c
index 7363942925038,a36426ccd9b5e..0000000000000
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c

(used the version from kvm)

--98i5RO1+y+Bu5kYh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjMSBwACgkQJNaLcl1U
h9AOjQf8Clc+Dc889W4qluq7/Z3Uzo6nrRk+n7rezBDWhjTsh4YkndeApQxBGpRE
FqVRozpV6l37ENq5veGQSeEgQAxKXWwYsxynQvbJMBtIwQuiBNtwvUppsfxxIYWc
Spg2FrbC74N9SBeEjYIDCR4SlGfkLgd7uLGzhXzSdEYkMKeCSb2kzIWdeMzJmlFT
bb65lZDORLWIeN3bJCAUJAm9FXJOt6BUazruFqYHgJrm9ehL3dSf9tWHC27ZlzGN
jxAK7eO/RRC8hq9MihnNNldHIZyTmer/Z9EYvMto7YOdyPC8C1YjuLU1oChHVtn6
MeUsZjDbE5UyJaIzWKfdr6JRk5hE+A==
=X3Tg
-----END PGP SIGNATURE-----

--98i5RO1+y+Bu5kYh--

