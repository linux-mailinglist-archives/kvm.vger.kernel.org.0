Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D046C597F5
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfF1Jxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:53:44 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:32787 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfF1Jxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:53:44 -0400
Received: by mail-wm1-f51.google.com with SMTP id h19so8979261wme.0
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 02:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=04xiGCjwKtalfzFHKvcZ2CGOE0X4TsPj68ZsmH1QQbg=;
        b=L6c3VribSQEdsUuII5wjTxSN/8F7PDYk9n/P/7QjPi29iokpZU0WhBI9PhxbgX/WnA
         EXebdCR9F0VAzzJsIjboLvFd+Qqe35YjqbgGTNt0O9Zq3L6Z+zXCJ7x2fG4Kn01DvE3q
         jydjvLangvp0t6x1TSEJuli5Yr3JbJ56UT0q3uEU0pV8YECAB6A6UdP8HybsAZqFTPhV
         a/Lf6eC8IHXysSyYpVkQHEG3OjSjxIfs4u0xQSUuK+FQBsvZuOkXs5ucTnzjpLOiiWAD
         XhyzVfL7tr70oFVAYnC5rt8QaVrv6iHoC6jO5CCNOMif7oVH34b3HADdz6UFYayDkijx
         5BNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=04xiGCjwKtalfzFHKvcZ2CGOE0X4TsPj68ZsmH1QQbg=;
        b=goVRi4mK0RibF7K0wKf9aYFEjsBMZi2fwPL/KpuT+QHXatP5Wq0SVhv170lzgHBBA3
         1pSlNWEYcfZhyoHi+61jn1R6btuGJ3pWkHKh2n3Ju64bTpX328AY0TL7Uri6zB0B46TX
         k4qLaBDNmwkqH8Bdooqt+P22CCSUr2HBVFuaW5uuoMqH2EZ/BttcN42Plsca72B2gFaH
         llXDRckT8SCxVchp0Hs0wYEHdkhNapILpc5ht9iq1fv0M50GxnLnVDMwlaH+HxgSBnm6
         aD26KdX7veyUzsrG2nT2IKSCV7684P7/1K6F2tXx2vvbL4RONJw4zedGfoC8MNkuvLN/
         eoGw==
X-Gm-Message-State: APjAAAWJB29Ne37JZ9RqXkCVLeRwUdHXCGOOP2s04J8EWdFW2h9+UW0Z
        rUqgZC71RV5EJPt7Z7m0DIh/pzCixAQ=
X-Google-Smtp-Source: APXvYqxQLAfzlpd4vUShwv9ToCthz5bmjcwP+QBIPUNHTdSTUpLHRl03Ugi9XE0rEGEVwd81qvCUSQ==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr6217182wmd.122.1561715621726;
        Fri, 28 Jun 2019 02:53:41 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id o2sm1992252wrq.56.2019.06.28.02.53.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:53:41 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:53:40 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Rainer Duffner <rainer@ultra-secure.de>
Cc:     kvm@vger.kernel.org
Subject: Re: Question about KVM IO performance with FreeBSD as a guest OS
Message-ID: <20190628095340.GE3316@stefanha-x1.localdomain>
References: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 23, 2019 at 03:46:29PM +0200, Rainer Duffner wrote:
> I have huge problems running FreeBSD 12 (amd64) as a KVM guest.
>=20
> KVM is running on Ubuntu 18 LTS, in an OpenStack setup with dedicated Cep=
h-Storage (NVMe SSDs).
>=20
> The VM =E2=80=9Eflavor" as such is that IOPs are limited to 2000/s - and =
I do get those 2k IOPs when I run e.g. CentOS 7.
>=20
> But on FreeBSD, I get way less.
>=20
> E.g. running dc3dd to write zeros to a disk, I get 120 MB/s on CentOS 7.
> With FreeBSD, I get 9 MB/s.
>=20
>=20
> The VMs were created on an OpenSuSE 42.3 host with the commands described=
 here:
>=20
> https://docs.openstack.org/image-guide/freebsd-image.html
>=20
>=20
> This mimics the results we got on XenServer, where also some people repor=
ted the same problems but other people had no problems at all.
>=20
> Feedback from the FreeBSD community suggests that the problem is not unhe=
ard of, but also not universally reproducible.
> So, I assume it must be some hypervisor misconfiguration?
>=20
> I=E2=80=99m NOT the administrator of the KVM hosts. I can ask them tomorr=
ow, though.
>=20
> I=E2=80=99d like to get some ideas on what to look for on the hosts direc=
tly, if that makes sense.

Hi Rainer,
Maybe it's the benchmark.  Can you share the exact command-line you are
running on CentOS 7 and FreeBSD?

The blocksize and amount of parallelism (queue depth or number of
processes/threads) should be identical on CentOS and FreeBSD.  The
benchmark should open the file with O_DIRECT.  It should not fsync()
(flush) after every write request.

If you are using large blocksizes (>256 KB) then perhaps the guest I/O
stack is splitting them up differently on FreeBSD and Linux.

Here is a sequential write benchmark using dd:

  dd if=3D/dev/zero of=3D/dev/vdX oflag=3Ddirect bs=3D4k count=3D1048576

Stefan

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0V46MACgkQnKSrs4Gr
c8jpdwf8Co7WqfAy9AvneYXB+JjvDgtZzxsWnurbliJbY2Kq0I36AVcQO85m3BQG
no9Wl1DPFds8VLCRL5hc7KjzmYSSchZh3WuIBSyQCH8L7bnNH4yMIAWOsw4oHnD8
+T+8SJIlAPs6EXjN5w5xpSxlrz9X30l31m/n9NMka0cR7JDM/4qxZrV75N6EZaBT
vdr4a0oEEPKMGyLkSqj0YnDdhlyglf7s1bcO8LOxhp4ORe39CpxITIU59jYHdNkU
3TnHz5FbUd/oiizrvWoTMirMNll8tiKzLs3zLNdwtvKk6sLLcd+8euGWvL+gM2zJ
qsZZsMCPRDLjWKH+DYkDgaWLyef1pw==
=aJfE
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
