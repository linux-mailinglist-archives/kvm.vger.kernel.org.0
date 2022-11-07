Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFBD61F503
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 15:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiKGOMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 09:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiKGOMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 09:12:42 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB371C11F
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 06:12:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B2F801F891;
        Mon,  7 Nov 2022 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667830358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SELBd3TBEsnsUKwCSaZp4nrbGKqc1tLA/0ZcqX6bnZQ=;
        b=L2DrxOKQxv3iljCGdElXMIDwPJ+n62U0pyoYRaPcXuw8QE6aX2z68KDnTOfnNknHMnUZ9p
        4TG6YJclvghcYl5/TOq7PkeUxCffc9731svpUJAaQX22XagLIPYdfwtTJOjsNwFjLZd0Qi
        IxWr/sSnJ8meeWLtaqyCE2uv6fNnxwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667830358;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SELBd3TBEsnsUKwCSaZp4nrbGKqc1tLA/0ZcqX6bnZQ=;
        b=rK+WIxuApdqeBGaqwrMU/fmY/YTGGrN/TvPjISqa34KHFFhIKbvaUwKq5dENzHvOFCMlho
        LCpWILhxv96ZL/CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A7C9B13AC7;
        Mon,  7 Nov 2022 14:12:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zZ/sKFYSaWPNdAAAMHmgww
        (envelope-from <matthias.gerstner@suse.de>); Mon, 07 Nov 2022 14:12:38 +0000
Date:   Mon, 7 Nov 2022 15:12:37 +0100
From:   Matthias Gerstner <matthias.gerstner@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
Message-ID: <Y2kSVrt7sNelmvLv@kasco.suse.de>
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
 <f308e60a-9874-429b-ace9-463fa94cb739@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KA9M0K9Do+Pd+UbL"
Content-Disposition: inline
In-Reply-To: <f308e60a-9874-429b-ace9-463fa94cb739@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--KA9M0K9Do+Pd+UbL
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 7 Nov 2022 15:12:37 +0100
From: Matthias Gerstner <matthias.gerstner@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts

Signed-off-by: Matthias Gerstner <matthias.gerstner@suse.de>

On Sun, Nov 06, 2022 at 09:43:04AM +0100, Paolo Bonzini wrote:
> On 11/3/22 14:59, Matthias Gerstner wrote:
> > The fix is simply to use the file system type field instead. Whitespace
> > in the mount path is escaped in /proc/mounts thus no further safety
> > measures in the parsing should be necessary to make this correct.
> > ---
> >   tools/kvm/kvm_stat/kvm_stat | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Matthias, both this patch and the one you sent to linux-afs need to=20
> include a "Signed-off-by" line, for example:
>=20
> ###
> ###	Signed-off-by: Matthias Gerstner <matthias.gerstner@suse.de>
> ###
>=20
> The meaning of this is visible at https://developercertificate.org/.
>=20
> For this patch you can just reply to the message with the above line=20
> (without the "###" in front) and I'll accept it.  However, for linux-afs=
=20
> I suggest that you just resend it.  Just committing your patch with the=
=20
> "-s" command line argument will include the line for you.
>=20
> Thanks,
>=20
> Paolo
>=20
> > diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> > index 9c366b3a676d..88a73999aa58 100755
> > --- a/tools/kvm/kvm_stat/kvm_stat
> > +++ b/tools/kvm/kvm_stat/kvm_stat
> > @@ -1756,7 +1756,7 @@ def assign_globals():
> >  =20
> >       debugfs =3D ''
> >       for line in open('/proc/mounts'):
> > -        if line.split(' ')[0] =3D=3D 'debugfs':
> > +        if line.split(' ')[2] =3D=3D 'debugfs':
> >               debugfs =3D line.split(' ')[1]
> >               break
> >       if debugfs =3D=3D '':
>=20

--KA9M0K9Do+Pd+UbL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE82oG1A8ab1eESZdjFMQFyXGSNVMFAmNpElYACgkQFMQFyXGS
NVMEpQ//Xf5SVdZFM8qVWZJFuo4/c82g+1sXWDU22zyIjnJDc+Morj/fMY8eEm93
5SAu4I8t5yec2ZJTc+NTiHLfqMnosrHdvS5DxnC/lLHSrYcnOAYPE73uZJ35dhli
dudXiC8B+a3axt60akAmxh94ABs0RQcosqZDQjpkx+GB9EuaLW6nfNj3slbe2a6R
+U8eUSLc0VfDpRVQ51rqx+I4NmUXAthbo9TAkJwbqJi/2sbDNP5/KDWdK8hm5paD
t5NBhCvczEBZ/ITWGVleUVnD3SgfAP6fpWHb65u7ldgK5zbjNHpXOZ+L+kt2mxjh
Fu6oCUrHGBeQ+MNPftIAH7ty+fljVKLMVx0uePf6I2Dgar+XkpZPsYiggS2lVImL
JkJMg7eZCWMRuKJ+nZ2ZCRK5KfjkoDYliGl3c0cZpt5fFi3QPq4dMYGWu8xOGV27
Sz37sWRtYRmUsVKFNOwReLZTrP0ByBKg7Kv6TEzPzN7b9t58qXYnPMAOrcsbI3dP
jkhKFW8z3wFAIAn+BYJEWRAkwWvmJ8TFZDzuMdy7/RxWpJdyx2+ROMTjQ3hYdhop
USv9CtKU2G2lhBP2BOmn6yrLn8c9cithDaLSD0ivQqvHQ0basY0AHFMTpXfN3EOc
NOsd2xtzkjSx8KUJhdjlTnIODp6UKQsVUGqikh03WELxYsIxGJ8=
=NwBZ
-----END PGP SIGNATURE-----

--KA9M0K9Do+Pd+UbL--
