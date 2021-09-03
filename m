Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9283FF882
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 02:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhICA5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 20:57:39 -0400
Received: from ozlabs.org ([203.11.71.1]:51527 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhICA5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 20:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1630630598;
        bh=XXRA9E9bkfiMuArjbNTfx+r3Un7G6QIyGWXT2AEimqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/oOJX4wVez+0NVv34NrPleBWRl5YwYrRYxkIYCYr2DBSXFoQW3ujaLS8VYNkCkdh
         k+y3JMpbgn9tPsrOUDPXq+7t9kf9MvRy3873T3nWL9uuJ/xjlikC8YswJYUk9vfu76
         vduXzNxO6Vij/+kbOiSMh1QGiktvH/h6gdwa0iwg=
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4H0zrk2QpHz9sCD; Fri,  3 Sep 2021 10:56:38 +1000 (AEST)
Date:   Fri, 3 Sep 2021 10:49:20 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 20/30] target/ppc: Restrict has_work() handler to
 sysemu and TCG
Message-ID: <YTFxEPkY6Eq1+Xe/@yekko>
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-21-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6Kw+8nBbrWcu5Nha"
Content-Disposition: inline
In-Reply-To: <20210902161543.417092-21-f4bug@amsat.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6Kw+8nBbrWcu5Nha
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 02, 2021 at 06:15:33PM +0200, Philippe Mathieu-Daud=E9 wrote:
> Restrict has_work() to TCG sysemu.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <f4bug@amsat.org>

Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  target/ppc/cpu_init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> index 6aad01d1d3a..e2e721c2b81 100644
> --- a/target/ppc/cpu_init.c
> +++ b/target/ppc/cpu_init.c
> @@ -8790,6 +8790,7 @@ static void ppc_cpu_set_pc(CPUState *cs, vaddr valu=
e)
>      cpu->env.nip =3D value;
>  }
> =20
> +#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>  static bool ppc_cpu_has_work(CPUState *cs)
>  {
>      PowerPCCPU *cpu =3D POWERPC_CPU(cs);
> @@ -8797,6 +8798,7 @@ static bool ppc_cpu_has_work(CPUState *cs)
> =20
>      return msr_ee && (cs->interrupt_request & CPU_INTERRUPT_HARD);
>  }
> +#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
> =20
>  static void ppc_cpu_reset(DeviceState *dev)
>  {
> @@ -9017,6 +9019,7 @@ static const struct TCGCPUOps ppc_tcg_ops =3D {
>    .tlb_fill =3D ppc_cpu_tlb_fill,
> =20
>  #ifndef CONFIG_USER_ONLY
> +  .has_work =3D ppc_cpu_has_work,
>    .cpu_exec_interrupt =3D ppc_cpu_exec_interrupt,
>    .do_interrupt =3D ppc_cpu_do_interrupt,
>    .cpu_exec_enter =3D ppc_cpu_exec_enter,
> @@ -9042,7 +9045,6 @@ static void ppc_cpu_class_init(ObjectClass *oc, voi=
d *data)
>      device_class_set_parent_reset(dc, ppc_cpu_reset, &pcc->parent_reset);
> =20
>      cc->class_by_name =3D ppc_cpu_class_by_name;
> -    cc->has_work =3D ppc_cpu_has_work;
>      cc->dump_state =3D ppc_cpu_dump_state;
>      cc->set_pc =3D ppc_cpu_set_pc;
>      cc->gdb_read_register =3D ppc_cpu_gdb_read_register;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--6Kw+8nBbrWcu5Nha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmExcRAACgkQbDjKyiDZ
s5IeEBAAv3cpcInuLFJXsDvzVly7wSr5p5Tp9oNaBy8UvvGyoBX2eesw8Om/A3+P
S/tu8jqAI/GRfxWwBaE+wNg+Fmpdl3CK+ThR/6t9NA5BhoBwy5rwsM4V32BYkawN
NS5jP+L14XMC5MMa9o1IbnrNIPcpSA7kLTxq6sZxP1UaSvLecauVW2a14q630sUN
0mQEVEq0V/dO9bB01U775VN8Nzwxc6khrC8oufvhvSL22oYCjQTvOTslr7LEN5Ro
Bb/6zxAXhGR1A8aBLekm7RSlqY767gZjEtIdn1zjx6g/owGyARjDez0rzwhiBL8C
WqVsrRndk6jLRe1SJSRpZvgCx0EybrQyITVbeyMM4A/lXZYmDD2HKvOuXpUtnNZg
frxhAADG1KW6Y1Ufvklqyz9YGnFpztZL6XevPw1xfXXFvC3jyZpBNYP5XrilV44G
Sl7xomR8sRiJqzvJ2fWj475h07KiQ5NjXVvX5NvWy4okv9IphyXh8JoxyQsrA2b5
zIuqvUOy4GNPsunnxcNha90XiMsN6i5ds/ibiTyMwKbllU/hgUI3GEKVICncvbGt
LmIo3UFw/vTG7+lqCUxRZUtGBBgDZlsyxpkAGXfiBf+aISLrhsCHQeXxbD18AGBO
tECHtorVH7MbCNLHks/1Ey6DsZyaJnMdBoNjA+d4GpSUzASXzxI=
=o8a9
-----END PGP SIGNATURE-----

--6Kw+8nBbrWcu5Nha--
