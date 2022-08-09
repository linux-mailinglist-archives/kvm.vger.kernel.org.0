Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BA458D3F1
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 08:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbiHIGl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 02:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiHIGlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 02:41:55 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3DC201AC;
        Mon,  8 Aug 2022 23:41:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4M23Q51vQhz4x1J;
        Tue,  9 Aug 2022 16:41:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1660027309;
        bh=t7xPe4mFK0bZ6Qo96hN1grLRamjl9/fDy4qsW9o1yao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fEbx9fu5mU8mWYGSWVZ5+wtKaxv+E9YaCe1bRVLFHGRUXJhYWtWcwJrhk3CbrykJP
         TEQrShx2I6T8+g0npT8t9qDKmdmeyQlJr154kSxgYCKK8JniNX95FS5949rUHF8FZY
         2hPqrGWTw+HdjVFREU7egoRgdoJJLH5WaatNPs6ioJQLnhpG4yORiSs0f9XAnO4LFW
         Y486lKak2wAa6j8U4FDCjtZx45VQ7e2fhbocCJyjeulvX1zGzHv7fpS3dJLX7/4M+u
         H8nABk1lnFNM9OoKcoBbNl0pbBnHgni0OwlvrM91bPG0OZeE8zRNBNV3MIwsygOwg7
         f8ENTCNn++M3g==
Date:   Tue, 9 Aug 2022 16:41:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20220809164147.131f87d0@canb.auug.org.au>
In-Reply-To: <20220627181937.3be67263@canb.auug.org.au>
References: <20220627181937.3be67263@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/I9PiRdCK0D2PIzWbH9QXuTA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/I9PiRdCK0D2PIzWbH9QXuTA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 27 Jun 2022 18:19:37 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
>=20
> Documentation/virt/kvm/api.rst:8210: WARNING: Title underline too short.
>=20
> 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
> ---------------------------
> Documentation/virt/kvm/api.rst:8217: WARNING: Unexpected indentation.
>=20
> Introduced by commit
>=20
>   084cc29f8bbb ("KVM: x86/MMU: Allow NX huge pages to be disabled on a pe=
r-vm basis")

I am still seeing these warnings.  That commit is now in Linus' tree :-(

--=20
Cheers,
Stephen Rothwell

--Sig_/I9PiRdCK0D2PIzWbH9QXuTA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLyAasACgkQAVBC80lX
0GxzEAf8DP+uDFaAE+MwTdQRewbg4DOgLjJ6S87Udp7ChDA/l/VwhJcm8XSgZv84
on5HcTl70X6U8/8+yeU9EIn6tDNXOhM4cn9gRe/WgLkZ0ziOQ+WhOl7cny1NIqNO
MqmRU37tLuWwJLLprRjsL8T4ylnvonwpR0xPDo2WVksahg218nG6C2/IU5J0v1yn
1e/703shgbXHfkxBzEo11BUWPU0ALlKaVrdq9Sj34kU9NPBddA4xmrLuRX42D2QT
pj4bf4C5eRaMTVrbMOl8tZjSNtcReOuHCnWsmyTKvxANkCzZsg/QEvL0d8spq4Ug
kYwBn0VucKHXqvbu/7zKjXRM4LLg4Q==
=C1gV
-----END PGP SIGNATURE-----

--Sig_/I9PiRdCK0D2PIzWbH9QXuTA--
