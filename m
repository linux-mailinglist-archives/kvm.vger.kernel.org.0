Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC4494CB9
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 12:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiATLU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 06:20:26 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:58747 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiATLUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 06:20:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jfg6G5dSqz4y4j;
        Thu, 20 Jan 2022 22:20:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642677623;
        bh=iqUsG87yfMvfv/IQ2eoQRriRKCriolP8xFdQ7tWzCgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qLZCdAbn8YMTxOtWrZ0AEN/zGrCozq9hLO28DhSJhE58gPeXB/Yri080pEkr8riia
         UTDBpoTm/XXu7hduTigllV0d+vdgJgPf5ep+afAi40/8N/MuN9orPIZuu14lMd5OEt
         cO0rPut7XmbI4xUTWp7PPdukTdAD2zVCTHFwj08xhxxF+TVTgY9D40Tk7uIg/2NLVs
         1U3azKnZLVDMg/NFkOsqvC1hDMKdunl9GHMFLU8kIbZE9oMFzKGwcmIT4ic7h8I9JD
         p5f1Va6Wuy++AzumqJQQsnH0CsN0d4GChWqB2xZHgrw8m7uXho2Wa7lT0jR99/YocI
         laUEwx9+2ocLQ==
Date:   Thu, 20 Jan 2022 22:20:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: kvm: fix WARNINGs from api.rst
Message-ID: <20220120222021.59ed67ae@canb.auug.org.au>
In-Reply-To: <20220120045003.315177-1-wei.w.wang@intel.com>
References: <20220120045003.315177-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Id.9yeainmpCH4b7QRU=QLm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Id.9yeainmpCH4b7QRU=QLm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wei,

On Wed, 19 Jan 2022 23:50:03 -0500 Wei Wang <wei.w.wang@intel.com> wrote:
>
> Use the api number 134 for KVM_GET_XSAVE2, instead of 42, which has been
> used by KVM_GET_XSAVE.
> Also, fix the WARNINGs of the underlines being too short.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  Documentation/virt/kvm/api.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index d3791a14eb9a..bb8cfddbb22d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5545,8 +5545,8 @@ the trailing ``'\0'``, is indicated by ``name_size`=
` in the header.
>  The Stats Data block contains an array of 64-bit values in the same order
>  as the descriptors in Descriptors block.
> =20
> -4.42 KVM_GET_XSAVE2
> -------------------
> +4.134 KVM_GET_XSAVE2
> +--------------------
> =20
>  :Capability: KVM_CAP_XSAVE2
>  :Architectures: x86
> @@ -7363,7 +7363,7 @@ trap and emulate MSRs that are outside of the scope=
 of KVM as well as
>  limit the attack surface on KVM's MSR emulation code.
> =20
>  8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
> ------------------------------
> +-------------------------------------
> =20
>  Architectures: x86
> =20

Thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/Id.9yeainmpCH4b7QRU=QLm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHpRXUACgkQAVBC80lX
0GxZXQf/YsxH1YdREFm5eoVnPU+9ktPp726YUre6oPhAEOU7KHSmISD+Zk/x0ue0
Vira0f1Vl9el9ChfVVycVVAb0gwqLIt/bgCJVRaiflkPyugwO5xuKWsjIrQcJaCG
GMFLMp9aCbo79MkbrY1fFmJa3te424Lb2oaDyTDUq2q0LxAfyTnsyWWBUoh6RZQZ
m44+9Ba5K6DmoC6rMuFiraRkCLalV3NIUnzxmvz7bA2ZGoV6zyTKp+0yqbWDVpOj
P9qA8exj9Um3pxxrJCjcVmx+nQCN3BI46lT2+aZFYTrHKEwndcToPBngmDy705g+
B3yCuQJZ0PIUuO2eOLHVIy/I3dxZ+Q==
=opJj
-----END PGP SIGNATURE-----

--Sig_/Id.9yeainmpCH4b7QRU=QLm--
