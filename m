Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE6755DDE1
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiF0ITn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 04:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiF0ITm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 04:19:42 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85868E45;
        Mon, 27 Jun 2022 01:19:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LWgcp4plPz4xDB;
        Mon, 27 Jun 2022 18:19:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1656317979;
        bh=7g/3i3juQG76SYtldFCyXOFRWfeOFgQJvo6kNSgX9JI=;
        h=Date:From:To:Cc:Subject:From;
        b=kINRBB6qxfkklttarj7+0VGOt5rZIjAxq447Pa0H5xUJiTpA2lcfOp6nhvO09b0lh
         OMzTBBpfwxsqLxo5J4MmP1GSj2rJpl8ApTyQjlXvfH11k/eZdwPKVBj9hHXRCBVTiV
         kISKyB3igW0g7qalbY4BjreIly5e8uNBWjyjrsbK0dYLxE/JwBgvxWpsqdU4sXEOvv
         HDX7cqKS2onLozI/Lu75XBqhycFXBVXzDT48eDh9MUbzO24DMCGGvF8gnr+39UM9Td
         m3pzW26YIUMU7GgadRtMk76upq7YkUt5urTbv0yY3RPGtdBcZQ9D0Jr3zUo1uGLBhn
         0Qy5mDUJAOeTQ==
Date:   Mon, 27 Jun 2022 18:19:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20220627181937.3be67263@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+j5HvyYz1P499cVlhWwTAPs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/+j5HvyYz1P499cVlhWwTAPs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:8210: WARNING: Title underline too short.

8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
---------------------------
Documentation/virt/kvm/api.rst:8217: WARNING: Unexpected indentation.

Introduced by commit

  084cc29f8bbb ("KVM: x86/MMU: Allow NX huge pages to be disabled on a per-=
vm basis")

--=20
Cheers,
Stephen Rothwell

--Sig_/+j5HvyYz1P499cVlhWwTAPs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmK5aBkACgkQAVBC80lX
0Gz2HAf8DYtPt/dHj5EvB7SbRpRlmFjmtN3UB+bz7NtUsFXFXf0prtUCPDq9qBl7
ty4Pa0KPgEItbcgfBBldD8pvE/IWFfuNdjiu+Asz3NjURfLaQDhCB+N5wFl/GfbO
W4dK0fwbiADyLwvOanpwmNY/qkGdB53Kvi6XPad1sETaDEwVDZpZzKnewHaa6O6y
wqgubhL2NYWT1GIOXHopImATlA3il9LDwCB+krWgYrtV+HeWBRvZNmuO7H/SQNjU
UHaMIZ6XyfDeVndPGmdkZNS8Vp2CvHtOmA1aBEhGwBMoXpwZFkHeWSZuhsVGjUNn
E8S+FulQWwgPBIvQFdMCluczCcu1ww==
=tz3s
-----END PGP SIGNATURE-----

--Sig_/+j5HvyYz1P499cVlhWwTAPs--
