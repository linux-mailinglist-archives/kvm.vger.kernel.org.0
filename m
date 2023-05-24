Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0B070F014
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbjEXICQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjEXICO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:02:14 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD2493
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 01:02:12 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id BACFE132B029;
        Wed, 24 May 2023 10:02:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1684915327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wr+I3dKlpFyAiZ6C9ticwDZ/tyt9CIzBu4R3UVcn/DA=;
        b=eODaF4SjzKVzYAXoBhltFs2tuQHkBDan6ziOAdawT2mdFyAx0c0wz7mLu3tDHrYwlT3VA+
        V29WDHQCw7I8nR0MLKOnBN84BNJvl8zctHttnpvGzVmvJGf3e0PS/WuuieQxcrwY/fGt0g
        ANHW8JBHDvIZ0idiPd2dqKk2En0c8KU=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Cc:     clg@redhat.com
Subject: Re: [PATCH] vfio/pci: Also demote hiding standard cap messages
Date:   Wed, 24 May 2023 10:01:48 +0200
Message-ID: <2683252.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20230523225250.1215911-1-alex.williamson@redhat.com>
References: <20230523225250.1215911-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12214063.O9o76ZdvQC";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--nextPart12214063.O9o76ZdvQC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Cc: clg@redhat.com
Date: Wed, 24 May 2023 10:01:48 +0200
Message-ID: <2683252.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20230523225250.1215911-1-alex.williamson@redhat.com>
References: <20230523225250.1215911-1-alex.williamson@redhat.com>
MIME-Version: 1.0

On st=C5=99eda 24. kv=C4=9Btna 2023 0:52:50 CEST Alex Williamson wrote:
> Apply the same logic as commit 912b625b4dcf ("vfio/pci: demote hiding
> ecap messages to debug level") for the less common case of hiding
> standard capabilities.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_p=
ci_config.c
> index 1d95fe435f0e..7e2e62ab0869 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1566,8 +1566,8 @@ static int vfio_cap_init(struct vfio_pci_core_devic=
e *vdev)
>  		}
> =20
>  		if (!len) {
> -			pci_info(pdev, "%s: hiding cap %#x@%#x\n", __func__,
> -				 cap, pos);
> +			pci_dbg(pdev, "%s: hiding cap %#x@%#x\n", __func__,
> +				cap, pos);
>  			*prev =3D next;
>  			pos =3D next;
>  			continue;

Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Thank you.

=2D-=20
Oleksandr Natalenko (post-factum)
--nextPart12214063.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmRtxGwACgkQil/iNcg8
M0va/A/+J4t01m7tXqCN5pylPiBQ4M22aGi7ORrnaVQocpllZBE1FpaEpFp4EWog
Bw2LffO78PJMZFGPWS3CFuhDCzXcFX1X/xwYAgXvkeCfdF9g/FYoGGaT9kJ3sF3t
xCQJkTxi1uV2d57MMbaIM8coRHUiM7cz5yFCgIu0aMsw7kHICWyhF026VQ/fYZFl
c6RabTZ6mu3YnQ+lzv3CLe6DeS4CGOXYIJBrnJJU0eLOK0zUOWqZmouArMWhIhKl
F20qR331QSLgT7KLKsyaAhGghjN58LMnh3XAuq8nZDVqeGbPqDGTucAJRHicj7YA
IleAnYhGLSs8tfTLzkjqjW2UrPToJLxXG90+VWpWz8ARwNHd+s+pt6CSeas6Ikqp
SbV71Ze8aIoPA1SY/JjYHcxQeHimunVMnBRsGyhZeKEILaBUrQbm5Djz+xLOt8r6
rs2hU+5woAOHFaCPQDPUpIUOaG46Yrfv7IxRaisVQeEeDj1jvAaibuqOJe4y4zYy
eZq4i3SJ6sqH5h+qupf9NLcfzrgRlK84qJsoWS73ZRwCt2Xl6cd6RnjR4iUhkg9l
JSX7iS2HnQS+p9FxahiVl1MKL2/Uq6uIPaSha+xH2IQAXKQ7tDHqvUxZ2rGEZKPV
R1moqT/9s+kMtkL4gz8sKdzaXf19QaPEQajVFoDPcQZxeD++VAY=
=Lix6
-----END PGP SIGNATURE-----

--nextPart12214063.O9o76ZdvQC--



