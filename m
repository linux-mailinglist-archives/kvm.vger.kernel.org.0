Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5582D093A
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 03:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgLGCpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 21:45:55 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:46265 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgLGCpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 21:45:55 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Cq72d3llFz9sVx; Mon,  7 Dec 2020 13:45:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607309113;
        bh=TC0GOGaKbPAwP2EkbRQ9BPtcqZhEMWFvPmP9ecxIISo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NUcv192BLmiuo8zL9otdtQLt0UfmEo9EO574qHkkb6rjQT6zTr7LJVVf2p3ucpts5
         7cCe77CeGg6dbknawRx9okhPJam/pPRWj1UOXXKDU9Ofz0d7yY7SUKIGVn6xqTuM1f
         BBPukzLSjLblB+Cwg8oG8n6FG6BUR8UK014fAN+4=
Date:   Mon, 7 Dec 2020 12:38:38 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
Subject: Re: [PATCH 6/8] gitlab-ci: Add KVM PPC cross-build jobs
Message-ID: <20201207013838.GA2555@yekko.fritz.box>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-7-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20201206185508.3545711-7-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 06, 2020 at 07:55:06PM +0100, Philippe Mathieu-Daud=E9 wrote:
> Cross-build PPC target with KVM and TCG accelerators enabled.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> ---
> later this job build KVM-only.
> ---
>  .gitlab-ci.d/crossbuilds-kvm-ppc.yml | 5 +++++
>  .gitlab-ci.yml                       | 1 +
>  MAINTAINERS                          | 1 +
>  3 files changed, 7 insertions(+)
>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-ppc.yml

Acked-by: David Gibson <david@gibson.dropbear.id.au>

> diff --git a/.gitlab-ci.d/crossbuilds-kvm-ppc.yml b/.gitlab-ci.d/crossbui=
lds-kvm-ppc.yml
> new file mode 100644
> index 00000000000..9df8bcf5a73
> --- /dev/null
> +++ b/.gitlab-ci.d/crossbuilds-kvm-ppc.yml
> @@ -0,0 +1,5 @@
> +cross-ppc64el-kvm:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-ppc64el-cross
> +    TARGETS: ppc64-softmmu
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index a69619d7319..024624908e8 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -15,6 +15,7 @@ include:
>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
>    - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-ppc.yml'
> =20
>  .native_build_job_template: &native_build_job_definition
>    stage: build
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d41401f6683..c7766782174 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -397,6 +397,7 @@ PPC KVM CPUs
>  M: David Gibson <david@gibson.dropbear.id.au>
>  S: Maintained
>  F: target/ppc/kvm.c
> +F: .gitlab-ci.d/crossbuilds-kvm-ppc.yml
> =20
>  S390 KVM CPUs
>  M: Halil Pasic <pasic@linux.ibm.com>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/Nh5wACgkQbDjKyiDZ
s5LYEhAA36/x+ZVjKjbCR9cpbx/bxHW9hRFzSUsSkrFIx/72fqe7yXS0+kSyiZXE
yZw9xCYqyHNWkGbRdPbWWeICzn7uKP4JrKOGXhIWYmuAdCmRoodf95DLaEEsgyW1
kJswja2Od7ZqPytGo3Ybe540knkUj6a/Hae5nskOMw6f3RfjC1sLeCLz5Dfzup3F
0tbSKBXobELtf0AP7PIut9DQZKdorQXf4OO0gJDOkCqHUsvkuL0HqJ7mARHu0ca2
oFCZaO5Ko8frdptD5ik/n77Nqi+MqJrp81LvkiJrLRCSZPoex8RUWcAg/gDcQfoL
3nd92ZnOyWmuo72Pz0LK3jQCaIyvxVzikuWqpdeYK1/fQ3wx3em2S1vaksXmSbRJ
RXgIE/zSbZhbKSqpeQyowhJ1N0MxgrTiAwXJMapfwoA0z7rOvMFNAhhX2RLEIPYC
G/9c/KHEtBod2tp0GSUtMkIM2k/Dq9jobShxZubJOV3Z2bMsuILrPBccYIaEjjzT
eA8OCWafnik+e2Rqi9SOrTbVqgsVqOmhw1Muu5zrgRLBahI9FQx9XKC2Wji6mbTB
3/+qZ67nkzA29J4wfMi+WDpGUztqt6Ee65opWx8tTmOUMB2ReWYovhh34IbtsL4s
5RwEYP5Fm5CbUoZ0m/O2dsUXPt66NDALXeP51FDZuup1HQXp5y4=
=Obzg
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
