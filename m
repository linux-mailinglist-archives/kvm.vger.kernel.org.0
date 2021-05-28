Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F01E39462D
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 19:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhE1RFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 13:05:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35232 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhE1RFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 13:05:31 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CC6D8218F5;
        Fri, 28 May 2021 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622221435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=75k4PzEdZ0gZHKGAzYY0eGe+iK3UwaMHqUnwkJx5A5o=;
        b=p0ARH8HnTCoDZKNlR2G8JzDiltgNQ/38DRIGApzt/122CNNJNpWqcoGWZi1g1C3ACls/K9
        mQf6RAtU2WwGlxS9eHqbdqQd2eVUoYCUQ70TJXWai5Md2YokoeqwyTocI8XN0MN1wSRirW
        6t3OmjUrMnrz2YHNl7yl7CP1MWqsb1g=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 5F710118DD;
        Fri, 28 May 2021 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622221434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=75k4PzEdZ0gZHKGAzYY0eGe+iK3UwaMHqUnwkJx5A5o=;
        b=QsMY2SGmsOXIGTUj4XR6QkJj2BSObFNlA3M1MbphGYha+o+o/Xs3RteuhtyWmcynM6nsz7
        fSrgvW4/blvMCtwp4rgioNT5kxlMWX5QHLyMIbiQPeOj1nrSqNJ7Ql66wy52inepVB1Xqs
        KfFmSt2XMM7ZAq5rNjtI3XlYJDuVMJk=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8FxJFHoisWDcQgAALh3uQQ
        (envelope-from <dfaggioli@suse.com>); Fri, 28 May 2021 17:03:54 +0000
Message-ID: <9e9a9aeefd288c70bdf493601f99820e10dd9eea.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        rostedt@goodmis.org, y.karadz@gmail.com
Date:   Fri, 28 May 2021 19:03:53 +0200
In-Reply-To: <YK0j6MrOCFeQSHCa@google.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
         <YKaBEn6oUXaVAb0K@google.com>
         <5e6ad92a72e139877fa0e7a1d77682a075060d16.camel@suse.com>
         <YK0j6MrOCFeQSHCa@google.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lih3obsWUBZETTFOvlzL"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: -0.60
X-Spamd-Result: default: False [-0.60 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         RCPT_COUNT_TWELVE(0.00)[12];
         SIGNED_PGP(-2.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[];
         FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,redhat.com,tencent.com,google.com,kernel.org,zytor.com,goodmis.org]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-lih3obsWUBZETTFOvlzL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-05-25 at 16:20 +0000, Sean Christopherson wrote:
> On Fri, May 21, 2021, Dario Faggioli wrote:
> > >=20
> > Indeed. So, do you happen to have in mind what could be the best
> > place
> > and the best way for documenting this?
>=20
> I didn't have anything in mind, but my gut reaction is to add a new
> file dedicated
> to tracing/tracepoints in KVM, e.g.=20
>=20
> =C2=A0 Documentation/virt/kvm/tracepoints.rst or
> Documentation/virt/kvm/tracing.rst
>=20
Ok. Well, FWIW, this seems a good idea to me. :-)

> I'm sure there are all sorts of tips and tricks people have for using
> KVM's
> tracepoints, it would be nice to provide a way to capture and
> disseminate them.
> My only hesitation is that Documentation/virt/kvm/ might be too
> formal for what
> would effectively be a wiki of sorts.
>=20
Yeah, understand the concerns, I think. However, it seems to me that
how to interpret the kernel KVM tracepoint (i.e., this fact that they
mark the rather the beginning of the "logical" entry and exit sequences
rather than the actual instructions) does belong in the kernel's own
documentation, i.e., where you proposed above.

Surely when we'll have something like that, it seems natural that we'd
want to have more stuff there, and we'll have to judge what's best
suited for it and what should perhaps be somewhere else... But I think
it's worth a try, and I probably will try to put something together.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-lih3obsWUBZETTFOvlzL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCxInkACgkQFkJ4iaW4
c+4RdQ/+Nq2BF+hDkOT90KQ7ZGukQK1799sigxVBv6WpqyxNDVRUM5QuKoq6fzqn
qLjYGJxH2gkl2lK6EajdD0caG/UM2aUQqnnDtHLY5Bizank6Yc/nv00/PDpqewne
M6zhtnm/ymF3fCAc9rIU+lTr2h1dmrcS8qORzLs6506xu7EQNeHTzH1yO3Zi7ZDZ
BlzE6c94nBccFpq/kSbXITc0IdSSRvNPjTaaNZttK5do+pD9vBhRpOvmKZPYhFoT
z7CfQtByWrLp8KXVG5l6P2Wbn0gdigkbjpOAbgh/FwomScRn6YUitWAvy5feb7/E
N5YbSPH4ELgg63bFb4Q7YoBLQDYLtY9Sqt1RCE0qOMi5nf7b5on9tiKLd1Y1RHzN
bETtOBpUvG4mCVKpSKsAl20dx4eI+EzgFRdltN12RQJhCj68TV/1NAdC2yyRx5Q+
A8uLSewkbE7ErsIrqPG4QsKo7frFhOMUJScjVXXlhZaYSlQkzytUixVUsYF6d5MX
uOerne26fXdwfuGMfQ8C98qWTB7bT11l967QbbiBBte72umC1yQR4SY5b3slJlID
79NY/17Zb1Bwrb/5T10tlDzYBYbN2HBVNrc4jQ2YjmVzcEXgXaKeB8Dal+KulJ+e
WRzsb6cgvSEtBYFNangOo6ru/uHpQJyMUAtFGFRjtpA5EWVKI+M=
=Kvo0
-----END PGP SIGNATURE-----

--=-lih3obsWUBZETTFOvlzL--

