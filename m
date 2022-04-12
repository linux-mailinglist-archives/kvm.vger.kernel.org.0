Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91314FEA7F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiDLXaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiDLX3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:29:31 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021CC1689CA;
        Tue, 12 Apr 2022 15:31:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KdJ9N0RBTz4xQq;
        Wed, 13 Apr 2022 07:03:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649797416;
        bh=43F2n8ZF8f0D66CEZPb3P5tM901K5nloVPs1SCTfIvA=;
        h=Date:From:To:Cc:Subject:From;
        b=aq9STt5Ug3eFGkQ9HqCAnBixDZyW6JnY3UNwVaH+OTgyePOizASFml2S+qRIt1yzo
         QC8K5PyxWVEtDbkeRLGTPVEeIs03hOgaa/eROVr/cg1KlZg3JRctj0JRFU/5zCzLkx
         COoDl4/rII+KacbbNOQMPTQIqMr66KFKKlAixnlCBSaZjsuAktf182jScadlXlbBX+
         EBtdil13sBu22T5pDU4XlMv8YPbxS8D8INxfCbQnJvqwpp/mUshHsnal1w9MYjIO3q
         k67L7Ly0dd8J8yHhtwdfelzpH2X41rFO2bBMgMHwlwVvVzfuAypQ1RFuT1cUpOgm+0
         OR0u+7iR3+hfg==
Date:   Wed, 13 Apr 2022 07:03:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20220413070335.22d5a7cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_kPAQOkQiQTxX+u6CIbB2MN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/_kPAQOkQiQTxX+u6CIbB2MN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  42dcbe7d8bac ("KVM: x86: hyper-v: Avoid writing to TSC page without an ac=
tive vCPU")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/_kPAQOkQiQTxX+u6CIbB2MN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJV6ScACgkQAVBC80lX
0GwBDAf+PDRiVDJB31puKlpHDwl76t1PAgh/T6OgSmL/LFKcFZdqtNE8EhizkLMn
RUtZgsqOArIa6jSWF32ANOHmtEg6aZYB0UJp9EOKxOtFcEHtztJzIcxTb8W6VVRl
2SwkVCS3aNx4EUTyobAAcsbkbZqgf9cSSSA0/gdJVVrac6iRcQWEnSBGEuhI0K3G
3+47vom2FlqoBJnYQH5KgHnBEHgfVHtJBtr4lqWzl7Ty6JMHtjNPNBG8P2czxBrp
mN1ZQzDwtiZ8kWecHOCGl1+K4xJFzbz53pNEpuc8pnYsnqAaMH56y8LIC9cJOCea
ixG4HSdWhx/OToua1Fo9s4l9lRe62g==
=fBwR
-----END PGP SIGNATURE-----

--Sig_/_kPAQOkQiQTxX+u6CIbB2MN--
