Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B461CDBC4
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 15:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgEKNtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729743AbgEKNtl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 09:49:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06DC061A0C;
        Mon, 11 May 2020 06:49:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so18081017wmj.3;
        Mon, 11 May 2020 06:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RdmVAG4h2TTK6N6GlwwtgHg/wD3HGMTD56EkKtYvHNc=;
        b=EEGao2G0ia27wRwnHCco4HjQMtImSkEmNOXEqxvrc1xTbcJ9X0JJ0F5HXhcjV5kfqZ
         JFKyGi0h7EJA5DHCFbmqgD35wp2+SAKeYKBE9C7c2NmyoDT6c3Nh9f1L8GqBt1IQI50Z
         AKo2Jo6ocR2zpjAIGVjYQ/czTe2NJs7h9jcERusgtSbpshLD3T8TjruZvPfmLS1tFHLx
         OawsIZyvcr1CTQKIpKdCpdOJBjrdnGkTqkKc+7frGQAuwKLyvKcBSYv4KKQC2nanJTTq
         azoyDaJoKKaqW1qZExRjG8JvH9UdMRou64CF2WwldHTRhfispBTlWMFWY4NwnCUNcLeb
         A5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RdmVAG4h2TTK6N6GlwwtgHg/wD3HGMTD56EkKtYvHNc=;
        b=WoXpX5KF4rCtELDNzqKfwsu/X/A61YYINV3WWSGK8xcmF6JyQ+xTym8qFo+pHoCNYx
         TtrQH1HpThhqUCZUe42g2UTO9FZNPsNFN7eMGzL28O2U3QBJbtrqrC31zdjvfUGn/Ksu
         pLDejFfIroQ2FPgOB33XQpfN0jgUrY4xu/IighkK23YwFnBF0Sq1c/TmTFbWbCTdOWzI
         DjXiZYM9N9uCpjwu0tTvY6TrywmLoMmA6hQoiiECJBLe8Mo4SWMtzYCUqzEWBd6kW+31
         5Vf5cn3TRhykAT5Iakfpn/fkMgFnO3vpLjvO4g9w+3IMIEocYU1qXthfD8PzJXqnR2yR
         sbkQ==
X-Gm-Message-State: AGi0PubhRsZjyJzlwF2+XIXWIyFw/4SB6qTfjOnjMT290JgC9WuoRzQH
        j00+nSfsoKC64hHWorU7p2Q=
X-Google-Smtp-Source: APiQypI2iR53YjF4Z/gltGU091c+JKLWoSkOu20XvgwxtlTl1qgJSoytDdwgmV4uF1rbsQ9Q6RBMCg==
X-Received: by 2002:a05:600c:2157:: with SMTP id v23mr29946072wml.149.1589204980001;
        Mon, 11 May 2020 06:49:40 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id d1sm16645459wrx.65.2020.05.11.06.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:49:38 -0700 (PDT)
Date:   Mon, 11 May 2020 14:49:37 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Herrenschmidt, Benjamin" <benh@amazon.com>
Cc:     "pavel@ucw.cz" <pavel@ucw.cz>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "van der Linden, Frank" <fllinden@amazon.com>,
        "Smith, Stewart" <trawets@amazon.com>,
        "Pohlack, Martin" <mpohlack@amazon.de>,
        "Wilson, Matt" <msw@amazon.com>, "Dannowski, Uwe" <uwed@amazon.de>,
        "Doebel, Bjoern" <doebel@amazon.de>
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
Message-ID: <20200511134937.GA182627@stefanha-x1.localdomain>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <20200507174438.GB1216@bug>
 <620bf5ae-eade-37da-670d-a8704d9b4397@amazon.com>
 <20200509192125.GA1597@bug>
 <1b00857202884c2a27d0e381d6de312201d17868.camel@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1b00857202884c2a27d0e381d6de312201d17868.camel@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2020 at 11:02:18AM +0000, Herrenschmidt, Benjamin wrote:
> On Sat, 2020-05-09 at 21:21 +0200, Pavel Machek wrote:
> >=20
> > On Fri 2020-05-08 10:00:27, Paraschiv, Andra-Irina wrote:
> > >=20
> > >=20
> > > On 07/05/2020 20:44, Pavel Machek wrote:
> > > >=20
> > > > Hi!
> > > >=20
> > > > > > it uses its own memory and CPUs + its virtio-vsock emulated dev=
ice for
> > > > > > communication with the primary VM.
> > > > > >=20
> > > > > > The memory and CPUs are carved out of the primary VM, they are =
dedicated
> > > > > > for the enclave. The Nitro hypervisor running on the host ensur=
es memory
> > > > > > and CPU isolation between the primary VM and the enclave VM.
> > > > > >=20
> > > > > > These two components need to reflect the same state e.g. when t=
he
> > > > > > enclave abstraction process (1) is terminated, the enclave VM (=
2) is
> > > > > > terminated as well.
> > > > > >=20
> > > > > > With regard to the communication channel, the primary VM has it=
s own
> > > > > > emulated virtio-vsock PCI device. The enclave VM has its own em=
ulated
> > > > > > virtio-vsock device as well. This channel is used, for example,=
 to fetch
> > > > > > data in the enclave and then process it. An application that se=
ts up the
> > > > > > vsock socket and connects or listens, depending on the use case=
, is then
> > > > > > developed to use this channel; this happens on both ends - prim=
ary VM
> > > > > > and enclave VM.
> > > > > >=20
> > > > > > Let me know if further clarifications are needed.
> > > > >=20
> > > > > Thanks, this is all useful.  However can you please clarify the
> > > > > low-level details here?
> > > >=20
> > > > Is the virtual machine manager open-source? If so, I guess pointer =
for sources
> > > > would be useful.
> > >=20
> > > Hi Pavel,
> > >=20
> > > Thanks for reaching out.
> > >=20
> > > The VMM that is used for the primary / parent VM is not open source.
> >=20
> > Do we want to merge code that opensource community can not test?
>=20
> Hehe.. this isn't quite the story Pavel :)
>=20
> We merge support for proprietary hypervisors, this is no different. You
> can test it, well at least you'll be able to ... when AWS deploys the
> functionality. You don't need the hypervisor itself to be open source.
>=20
> In fact, in this case, it's not even low level invasive arch code like
> some of the above can be. It's a driver for a PCI device :-) Granted a
> virtual one. We merge drivers for PCI devices routinely without the RTL
> or firmware of those devices being open source.
>=20
> So yes, we probably want this if it's going to be a useful features to
> users when running on AWS EC2. (Disclaimer: I work for AWS these days).

I agree that the VMM does not need to be open source.

What is missing though are details of the enclave's initial state and
the image format required to boot code. Until this documentation is
available only Amazon can write a userspace application that does
anything useful with this driver.

Some of the people from Amazon are long-time Linux contributors (such as
yourself!) and the intent to publish this information has been
expressed, so I'm sure that will be done.

Until then, it's cool but no one else can play with it.

Stefan

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl65V/EACgkQnKSrs4Gr
c8ixDgf9G2NkzityHPlx7cfril8TnwwL7OBcubfkDwaDvi8JhzAfQwq8HIb8T34r
2425zIaswd+4VyzEMiFov3VCEVnvG/r5lPXo9LuWArfLUTHlk/XubjGuo8+86TcY
vn6aeuIZiEBSZ5oe86ORCxjvEJiev7hiJBIsHwMcfL2zmObl19dGvhDRFwKLR5yg
QIaLtzivB9ABTnVbnVmoxKqWvFWd7tHuwPosN156I/aJa32Xec6ajUL872Q7Ur+J
siVUZyr/EnA+0pqKk4Spz+aumR4RjWtgVpRzjXSn1KCXFlY5x8uRC/S+vajr3xKb
izI+sWVFvvBYGohLeUQTqg9bU8I1fQ==
=Y/jb
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
