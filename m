Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CDE1EB67F
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgFBHSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 03:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgFBHSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 03:18:07 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EE9C061A0E;
        Tue,  2 Jun 2020 00:18:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bk0C2qSpz9sSc;
        Tue,  2 Jun 2020 17:18:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591082283;
        bh=MrJSykbWLAXwqJ9lxap8vVIzf19HCg++CsqikCUsi20=;
        h=Date:From:To:Cc:Subject:From;
        b=N8KtvWTZh5CwZEffJ51n/KOsacImwvPLrK9AW+eNpmYa1ENeYZBT5SeJEwXtbJVA5
         EHWrEMfEK6b3jqAL61+SxRAIZ1sNd0dFZHP3LksnZ4qGeLrlr4e6R8PGzq8QTBmRVg
         5+FBURqeV9tPWIP7+cAYDobKTC1jOnmojkB1kjTRYolnnvU1mIY2am4EeWxj8IDUFN
         h822MWaolaMXW025AKc4iTmG+OBr722pu97qlzexKF6Gd5xEM1cfU3AE2zsmkwIh/t
         IuEhMhJJc20rCtDnOWBNGlh0Ik7dgRXMFd4WnFwWMBQhZ15dArF5Fx0y7hbt1GJ8l+
         BnWSa0ygtakiA==
Date:   Tue, 2 Jun 2020 17:18:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Wei Liu <wei.liu@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Doron <arilou@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: linux-next: manual merge of the hyperv tree with the kvm tree
Message-ID: <20200602171802.560d07bc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/igm3LKsDwFb7/wFVMwSaniT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/igm3LKsDwFb7/wFVMwSaniT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the hyperv tree got a conflict in:

  arch/x86/include/asm/hyperv-tlfs.h

between commit:

  22ad0026d097 ("x86/hyper-v: Add synthetic debugger definitions")

from the kvm tree and commit:

  c55a844f46f9 ("x86/hyperv: Split hyperv-tlfs.h into arch dependent and in=
dependent files")

from the hyperv tree.

I fixed it up (I removed the conficting bits from that file and added
the following patch) and can carry the fix as necessary. This is now fixed
as far as linux-next is concerned, but any non trivial conflicts should
be mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Jun 2020 17:15:49 +1000
Subject: [PATCH] x86/hyperv: merge fix for hyperv-tlfs.h split

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/asm-generic/hyperv-tlfs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv=
-tlfs.h
index 262fae9526b1..e73a11850055 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -145,6 +145,9 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_SET_VP_REGISTERS			0x0051
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
 #define HVCALL_RETARGET_INTERRUPT		0x007e
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
@@ -177,6 +180,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
 #define HV_STATUS_INVALID_CONNECTION_ID		18
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/igm3LKsDwFb7/wFVMwSaniT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7V/SoACgkQAVBC80lX
0GxF2ggAomHYqBN3y2XJWtABsTskD12lp1J0U55o7KbIZoj4+rvuEjicl6/E6Bk9
x/RVJAuiR7RAknBnzd1pbzxddVz0i88/iPYPEutMq3dCba/092C6VVHp8ZYN4MAh
WVmqdS+ADXllcMGfpiVcOLSyUu6WvhAUb4tyootkfFu1o6IQ4a5log9kMEdtXS6G
uLG6lMFGk40MZGJXtBRKxWOd2RD3ZASrqaHbzUZMibFBuMsZAD9cZ1Z8+aKvHNNz
jozd+M/0N8zWg2DMnGcFd4mWxxYfvKBr+jn4Nb3FwE39rJqieSlgIZPpUa14parS
Up1NAZfWOHzFOJOr7CSUic4SUR1usA==
=Venw
-----END PGP SIGNATURE-----

--Sig_/igm3LKsDwFb7/wFVMwSaniT--
