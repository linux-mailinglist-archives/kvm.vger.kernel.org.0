Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2324E6D783D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbjDEJ3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbjDEJ24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:28:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03560468F;
        Wed,  5 Apr 2023 02:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680686901; x=1712222901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aLX6+vqdQNVvF14fetM/8YAe4WRk9gZuo75cuAymbAw=;
  b=oq9jDHdOhWb8mK+/V9qQKPUdImnRpJIk2QVm1YqYX8ctCH1VxbIsn5GI
   aA30Th3OLiaNOinXEJUqeSiJ0AbQDPGyBGvVQPx82UCXKi7BVYlSQWZ2t
   u7z1ZSuF+C45QSLQ67FmmQ+kGmX3lC0tklEmMwQzWxGc4EE4AR5jSxYqX
   L8e2PbCvGsHjgFPtouhWk4PcfmgPnd9PAbTLsDLW7wXHi/sc0/WTS+0lp
   ij7pM666MtkDuJktA3LvOKAy82enej5+8kKYyKQldn+2JwZ6ciEycDtqF
   E/8JYmlSl3H9S+4SE5hBYN+gyprHMhzVyDjocslnyjQicsKcxmao0h+cc
   A==;
X-IronPort-AV: E=Sophos;i="5.98,319,1673938800"; 
   d="asc'?scan'208";a="219516254"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2023 02:28:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 02:28:19 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 5 Apr 2023 02:28:17 -0700
Date:   Wed, 5 Apr 2023 10:28:03 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andrew Jones <ajones@ventanamicro.com>
CC:     Anup Patel <anup@brainfault.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <bjorn@kernel.org>
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Message-ID: <20230405-icon-arrogance-62bf7d627a5d@wendy>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
 <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
 <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
 <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
 <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
 <20230404-5cfffb017198773dc3e81dab@wendy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6/ymYoyceqNd1+G4"
Content-Disposition: inline
In-Reply-To: <20230404-5cfffb017198773dc3e81dab@wendy>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--6/ymYoyceqNd1+G4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 12:58:41PM +0100, Conor Dooley wrote:
> On Tue, Apr 04, 2023 at 01:52:43PM +0200, Andrew Jones wrote:
> > On Mon, Apr 03, 2023 at 02:23:01PM +0200, Andrew Jones wrote:
>=20
> > > It's probably best if neither depend on each other, since they're
> > > independent, but otherwise the order doesn't matter. It'd be nice to =
call
> > > the order out in the cover letter to give patchwork a chance at autom=
atic
> > > build testing, though. To call it out, I believe adding
> > >=20
> > > Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> > >=20
> > > to the cover letter should work.
> >=20
> > I also just noticed that this based on "RISC-V: KVM: Add ONE_REG
> > interface to enable/disable SBI extensions"[1] and it needs to be
> > in order to pick up the KVM_REG_RISCV_SUBTYPE_MASK and
> > KVM_REG_RISCV_SUBTYPE_SHIFT defines. It'd be good to call that
> > patch out with Based-on.
> >=20
> > [1]: 20230331174542.2067560-2-apatel@ventanamicro.com
>=20
> I've been waiting for a review on that for a while.. It's been 3
> weeks, so just gonna merge it and see what breaks!

I did in fact break some stuff, but the output was no worse than if the
dependencies had not been specified...
I've fixed it (I think!) and told it to ignore the old state, so it'll
re-run against the stuff it missed.

Cheers,
Conor.

--6/ymYoyceqNd1+G4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZC0/IwAKCRB4tDGHoIJi
0llzAQD7CVUsawsm7wpvaamyFV3X2C65V7xha05w4L4rhlmyWAEAr3QHqpnSd9Pd
JL27yJCJfcvHvC6TY2wuWqeH5ArIAAk=
=jbmg
-----END PGP SIGNATURE-----

--6/ymYoyceqNd1+G4--
