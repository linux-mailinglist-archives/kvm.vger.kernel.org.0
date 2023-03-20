Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38EC6C15CE
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjCTO54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjCTO5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:57:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E328274BD
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679324119; x=1710860119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fukPmPRC7Rdv9VbzNLeqpzXj+z4ojMOPweVoyCaZe5c=;
  b=CDJtTBT9b3ezYVE+xR06nFGzLOrwbjxXBtpz5LQ2utH1ROZb7buTutae
   LcS7eVAbR6j/VpylT6e+dnSyswcqk51sULZ5PmHYB8AnC3m0vAk5z0Y1d
   M5NYEDMkfQ6qlSbVSFuX8iReYkYxnaxG1GvcsHD6zUSQwd9NHbJ2RLqsu
   Rvt5iaa352aEqPd1qV6iEk3xFpbC8uR5BPRzgmIAPiW+Gd1JZgchr/dHA
   YR2+BawkmL+ZPWSdWrnkfYXAnMhCQ/GLuv0hnSwXf26pENyHRnpYCpfTI
   7G/AgtNVJNM19y7yDOxdz8cjG58Aenlc9L5vtGf0BQIrms5lbSM9Yela+
   g==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="asc'?scan'208";a="205543541"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 07:55:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 07:55:09 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 07:55:07 -0700
Date:   Mon, 20 Mar 2023 14:54:37 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v15 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
Message-ID: <bcf933bc-b8d6-4b34-82ac-e6f542542e25@spud>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-9-andy.chiu@sifive.com>
 <456a8e61-c6b7-46d5-a25c-c466820912d7@spud>
 <CABgGipVf3eTc9pj58wMYQr7NBcic+-m3fECEttqvPcn9Zu3qJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YmzgdUOAV0nH57Cg"
Content-Disposition: inline
In-Reply-To: <CABgGipVf3eTc9pj58wMYQr7NBcic+-m3fECEttqvPcn9Zu3qJw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--YmzgdUOAV0nH57Cg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 10:46:57PM +0800, Andy Chiu wrote:
> On Mon, Mar 20, 2023 at 9:05=E2=80=AFPM Conor Dooley <conor.dooley@microc=
hip.com> wrote:
> >
> > On Fri, Mar 17, 2023 at 11:35:27AM +0000, Andy Chiu wrote:
> > > From: Greentime Hu <greentime.hu@sifive.com>
> > >
> > > Add vector state context struct to be added later in thread_struct. A=
nd
> > > prepare low-level helper functions to save/restore vector contexts.
> > >
> > > This include Vector Regfile and CSRs holding dynamic configuration st=
ate
> > > (vstart, vl, vtype, vcsr). The Vec Register width could be implementa=
tion
> > > defined, but same for all processes, so that is saved separately.
> > >
> > > This is not yet wired into final thread_struct - will be done when
> > > __switch_to actually starts doing this in later patches.
> > >
> > > Given the variable (and potentially large) size of regfile, they are
> > > saved in dynamically allocated memory, pointed to by datap pointer in
> > > __riscv_v_ext_state.
> > >
> > > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > > Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> > > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> >
> > I think you missed a:
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> >
> > Thanks,
> > Conor.
> >
>=20
> Yes, removed it on purpose because I changed some inline assembly in
> this submission. So I think you may want to take a look in case I did
> something silly.

Heh, inline asm is usually why I do "acked-by" rather than "reviewed-by"
as I am not particular confident in that realm ;)
No harm in being careful and dropping tags I suppose!

--YmzgdUOAV0nH57Cg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBhzrQAKCRB4tDGHoIJi
0mMRAP0ZcY7Sifv+CFgihncit9GeG67k7DvBV75qFFYjqobybgEA/DNDN+Bt0zf4
Bo/x9k/2RFH3d8pO1LC/yl5OT9sM0Q0=
=C2NE
-----END PGP SIGNATURE-----

--YmzgdUOAV0nH57Cg--
