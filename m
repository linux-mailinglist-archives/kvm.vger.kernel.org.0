Return-Path: <kvm+bounces-31392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DEC9C34B2
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 22:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB5A41F221CF
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 21:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90AC155757;
	Sun, 10 Nov 2024 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="hGXTMhsb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D31531C5;
	Sun, 10 Nov 2024 21:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731272829; cv=none; b=Fbhf7PWySRzGRqjeLtkp9IYbyzPcEvq8Ul/fqF/jK+XcPU8yWPO0NXngeqQsx2FYoe4tjYvh+3/bixh/YixdFRN6qUOPoefIGB9nuMzsGPGwoYALGFHR+8y2IucjVGfyFT8NH1VNkQ/OOm2rHhXydoQ0WHOiJkGXT6b+7MyAJd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731272829; c=relaxed/simple;
	bh=e4bhIlqSmzoreoABky4hRFGDDd3xhqOr9evl0Ug0trk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=cHjKhcdf2C2r+lEXGUvOCqSRmrRRKCOgtSeUmg0LwZbif1TzXzDw9CxvJ7ipqQL5EPU3huR3ty8WsleasP5vRWJAUZpIkck3Wu7APQk/L/nQhMxTRmFt/XZeBvMmQVxBM1g/GT16ntIebWfvSSZ4nAaVo6/ZGYvJfW5yvgrUzYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=hGXTMhsb; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1731272822;
	bh=PTS0ogbTlTcrdot10CqPoG9xoSvtcchg64FHPVoIvrM=;
	h=Date:From:To:Cc:Subject:From;
	b=hGXTMhsbjLQVGbOVOwk2MM/8h1NrRwVvFut0q51fqDy3gfNOLFUObMqb1RBKhMbQ+
	 7w5VRh4eqQYwu+3gWGDvyY9HhyHiFLP/gvjX2eHt9e20gvvcZsoa3J6Mq/JXsPgeEg
	 sYVUXRMHVeh3f0Y5sMsbNNzPC+fq9OVXY3qWahQN+SA2BBoSGgloR7HXidbl/R6HTq
	 PndlLCvQ0GObMNVGKIIKPPDclIbna18n/QTrYN0+xBW45gQtYlaarOeDoMatVVHtuz
	 qThRiFvq/DJy/9HNHN/hl/bMiklqR78iWRqAQvz9c2MsEqYV6XhEo80htDtkzzBjVE
	 ODE703jOou+IQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Xmlc63R6Gz4xFg;
	Mon, 11 Nov 2024 08:07:02 +1100 (AEDT)
Date: Mon, 11 Nov 2024 08:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: John Sperbeck <jsperbeck@google.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20241111080704.705b2050@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SLIa2pi.J/wzZtR97rM3=RT";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/SLIa2pi.J/wzZtR97rM3=RT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  10299cdde869 ("KVM: selftests: use X86_MEMTYPE_WB instead of VMX_BASIC_ME=
M_TYPE_WB")

Fixes tag

  Fixes: 08a7d2525511 ("tools arch x86: Sync the msr-index.h copy with the

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/SLIa2pi.J/wzZtR97rM3=RT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmcxIHgACgkQAVBC80lX
0Gy7rgf/VbpoGOhDjymYizlxOGYuGplYWbrKViDto581SVQT3DZaYdzwgkfUPGKI
J2Z76rxFXivlSM48wVBVJIY6GFSwIJTStO24ErGRzY+tZ1esF/ES24ljugyb9ZS6
2E3C8BjNXZHDCzSXhxpqke4fIqeggYLyAATkeL4OgEcpRvduILhq3/gZDuznOGhT
WE+piUKmbARmxyrM78a3gtxaHaSkFn4GEUvyprl3vFEDjnSmVtdVva/+VlfWtlSH
3v+9QT1pETRDBPviFUQTkCo/gRhabh97soX4GWW28zMMtfnNwiTiNpo8jkM0fAIU
d8LWkoddH9XKnWSMYtuIRCN9RUEJwA==
=X0lS
-----END PGP SIGNATURE-----

--Sig_/SLIa2pi.J/wzZtR97rM3=RT--

