Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE3253001D
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 02:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348667AbiEVAw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 20:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiEVAw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 20:52:57 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD022BC4;
        Sat, 21 May 2022 17:52:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L5MPz09fzz4xXj;
        Sun, 22 May 2022 10:52:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653180775;
        bh=3gkcarpBsg8B0PJslz0L+4gUs/4VG6lvkZ8za1+rT5I=;
        h=Date:From:To:Cc:Subject:From;
        b=IoRApmRtRTDehfKhGWGafrKAN+kUAvpHqivsjhym3IMj7ThD0nrwwCWd7yMCQ2g2H
         KBOlU6hqgOWQOgU9QanmW/YjEOVMxWGH1BMZN4LLZai32/ENBKBl0vxBXuAuQEfPJa
         seAyHhCrHnkVCe3QtMwJonApcweodeRqAIcXLYDxVlhschIU0ItqoubMFdq+bRYGaW
         AYCLbq6upspCQcNHA2gwePomTNLzcRzaky2oR7xhClUzq6YcJmxbfUFbZH7RtFtDQO
         3CbIXQYiQwibFuYuHfzugySSs/oK5cLOfvmRd9D94JqUwZZ1L9xIbjyRopQVYlNf+H
         IaWX4HuNauEHg==
Date:   Sun, 22 May 2022 10:52:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the kvm tree
Message-ID: <20220522105253.0d8fcb5a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zhhe5XcUE8EY6vejhjY8XQd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/zhhe5XcUE8EY6vejhjY8XQd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  e7b0b98c7fcb ("KVM: x86/pmu: Update global enable_pmu when PMU is undetec=
ted")
  32bf991699ee ("KVM: selftests: x86: Sync the new name of the test case to=
 .gitignore")
  af86c314f050 ("KVM: x86/pmu: Move the vmx_icl_pebs_cpu[] definition out o=
f the header file")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/zhhe5XcUE8EY6vejhjY8XQd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKJiWUACgkQAVBC80lX
0GyAwQf8CY0NY/stF5ir/UGK+BwDGT47yyjrpAbm12SRuuJVZnZL0z32/XeSGR0x
oU65qn+NHcgVOl+mLFLNl4cJYiB5vZTbpZdnu0Tp5ftqPnHofHdg332ocLlGPoZZ
wiFqyJkl0YUgdSScKBhRIJOU7MftSMI3QhfV6yvQkIqMfoO5FpHFfjN4uu9GK9Co
IexvSwBT3C0sGDMzrLZaXxr6IlpWbCQfXy7V8tDeYIMPZ6O3J4Oqmtr6HP1kmwtr
ipY5QGm5hvkX/1gDJ8zcnHoKAZPdJov7x0hx4SF7IMQ67j1rB3YFi1in3yXtXbLo
RzXwrqlGjyDm6gfAThP2jYmculHe5Q==
=PbqU
-----END PGP SIGNATURE-----

--Sig_/zhhe5XcUE8EY6vejhjY8XQd--
