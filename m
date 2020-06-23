Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE0204EEA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbgFWKRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbgFWKRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:17:54 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6EFC061573;
        Tue, 23 Jun 2020 03:17:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49rhzt60Frz9sRf;
        Tue, 23 Jun 2020 20:17:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592907471;
        bh=51NGv3klwUMIQque9QEeRxsT484NcqIVmv5bJ8240n0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h2qXYk8D8AXp8AKqLEsgL8Tm33Eca1Nh3+P+VR3T04djzj3AQFvRip0Ceijke8/Pk
         mUtvfdSAlrD2cGa0cURTIoK3Gl75Ti0hO7Xpv0J+DF/lgJ4nDlPaQyPLyVPhTt/yGI
         Q8Omp6hWB2WOsXwBg/GhtpQr6cPhK/qX0uOV2D7nR7yTUf2YsCIHx6wq8jVV69j3QN
         3WwYVhspCaytT5BwWIcUaa2DxGrmKbu2J3OuCBNWc5afgqIZBY2LvTf/TPrmW+E42w
         Ub0qTF1UQ7mWTi36ugn1vxWcHwCOKuLYlDU+aL/lMQr6xHcaqISxKgoprGxS9AsxMx
         x2wXfaBpuvaOQ==
Date:   Tue, 23 Jun 2020 20:17:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, elver@google.com
Subject: Re: linux-next build error (9)
Message-ID: <20200623201730.6c085687@canb.auug.org.au>
In-Reply-To: <20200623093230.GD4781@hirez.programming.kicks-ass.net>
References: <000000000000c25ce105a8a8fcd9@google.com>
        <20200622094923.GP576888@hirez.programming.kicks-ass.net>
        <20200623124413.08b2bd65@canb.auug.org.au>
        <20200623093230.GD4781@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.jBQgqJbruxCXR9TGfnbpGd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.jBQgqJbruxCXR9TGfnbpGd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Tue, 23 Jun 2020 11:32:30 +0200 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> I suppose the next quest is finding a s390 compiler version that works
> and then bumping the version test in the aforementioned commit.

Not a lot of help, but my Debian cross compiler seems to work:

$ s390x-linux-gnu-gcc --version
s390x-linux-gnu-gcc (Debian 9.3.0-13) 9.3.0

--=20
Cheers,
Stephen Rothwell

--Sig_/.jBQgqJbruxCXR9TGfnbpGd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7x1roACgkQAVBC80lX
0GxY8Af/XGxeY48bC9/qnGUVZknEFGDIcTw3WU0xZvWFtUuMEcsOXzZMovrrnc+2
/LVoAnCwwgV6dA5oamCw7XT64/RY3Hs2re1FLKj7vANGeehucftZscVlfQ7qU5ax
sxBRASh2KK+gr4a2kBHit8gZwFVvWJnjlqRq/JmSYoSdC2Mxrg1I0sm7pE2ekBn3
z5mhtG2kRdk4u0tVrwjt3JtkQNDaNnUnQpfvlfLJCsSZZPcAswhCDQF5LS34hyfx
Yh5qlDmMG0s4oWCkSNlrGNBkMAuDc3+4KJ/22RZO5AebA4Jssu4CrcKmiUtqk8Mg
pIFf6KjU/OvbbWdw51jo36QXk99QKg==
=cTbJ
-----END PGP SIGNATURE-----

--Sig_/.jBQgqJbruxCXR9TGfnbpGd--
