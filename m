Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DF4E2738
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347751AbiCUNJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243574AbiCUNJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:09:11 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0326621E;
        Mon, 21 Mar 2022 06:07:46 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMZfS5ftbz4xL4;
        Tue, 22 Mar 2022 00:07:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647868064;
        bh=tbu3D2gjRxbxA3yHFInPEJ5xF+j9rXDaRl9Gx5/mNU4=;
        h=Date:From:To:Cc:Subject:From;
        b=WnHl/fsamo6q1eVJIb3NutxVMVEevfyjR9ij1XLym859kWeEeSMz67kw97weO3qvs
         Lp7uRZIo1S3o/W71EY8mgauH92qtIfqQctPZaGW/YypU0UVUPNhvdEwgvva6TfHYUn
         s96nq2fuctDFP/LXMa4uYtPKEdauZEOwhnEXyTtTNLvIbWEif48sZuCWkYTqnyZuuo
         XnrErt9M4i84NswO7aYUsLH50smFxEWS9jOuvBURTq7a51cvId9JU0zPrAtKUb3IN3
         FYuMnFRCAFp7iuP3cTprERMdDUc78G/SRDRAl5OzXSMoLfUjUhufgB+KDNYLuVZ98U
         tP1vhtFKKNrQg==
Date:   Tue, 22 Mar 2022 00:07:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20220322000743.11e43128@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rZGO1TK4T+f+CTFo/QOusvo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/rZGO1TK4T+f+CTFo/QOusvo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  92faa4a0bcd4 ("KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for get_mt_m=
ask")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/rZGO1TK4T+f+CTFo/QOusvo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI4eJ8ACgkQAVBC80lX
0GxC1wf/c7qGB1Edc48PstC7zBzJVKOtG/QCyoj3rcr7opDPDxXIoCDOo9ASCd2M
j2/6mm2MDQ7Eh3zuNtUjgvrwo15uKGCZBe/7o0aXzYyMdWONyhq/p1dpVVWpp1x9
zsOFqmpQaT146HrPOpe43gYfGbAAKXrY8JHFsHalrAWLCyRAFdG80Oc3/HESS0ij
/hJwg6ee+P80VfRa0zM4M0W5cVk3wyVM2La6OnpvCKXePiXxLahYd9TCg53nQSAC
HbTbG9W6E0mcWQ1PyIknBMwt2opP2HV+goPFyBNNclP0HAKjq/qY6B+c6GqtgEr8
YlvaSelR0wqDHgXyC0W9WhEndd7naw==
=zhld
-----END PGP SIGNATURE-----

--Sig_/rZGO1TK4T+f+CTFo/QOusvo--
