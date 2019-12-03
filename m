Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C4510FA73
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 10:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLCJIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 04:08:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34591 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfLCJIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 04:08:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so2699371wrr.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 01:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RImsyZBOtf9GccCy7K3QNjHetVVlbzRYmCjU+YzgByw=;
        b=Y+EUYUusD4263RReQWWuYYQPM/zjKXNziIS9UVW+SCEpDB5uPex1wR/KAqIbJX6KK7
         B2QYt8zwVX16u5KpcFimXm8ybNfnu1IfupAS3nVDC2dJimPWCaNbMXV3Q63tGyc9vdKU
         t2PKMSVueXXeVUMwWWKMuojo1ecS/tAmrNwWE6cfVEyOTvJcGmYp1gBSsUi+BvVfUe7y
         zGkRjYnpHWPqOdOQDNKQMcTh2SEH0YWXIpB01kKB16ExApm7XY1J2HiJPLUqL8bkRCQm
         XTWKbdjXUXRmF9uyrGLRfJftV2wzTgSrRKVeLkC8t0P+BJh9h05n/8XHxRSb6mgSXBYr
         KMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RImsyZBOtf9GccCy7K3QNjHetVVlbzRYmCjU+YzgByw=;
        b=Qja6BJhZPO2jpNRm+9ZIb2BuuYCYD4l3SUKGBqSAYRElPVybY/xT5z9dIYpWEZSgyx
         ShS7U3MlFG85smVw+V5XSNkPgLYP6cSF1r4yBpz15H29iw5FKeYRtGKV56WmgTVwuOBp
         vsAwsyxqTFBZoQaw/T3Le/jf4nIZem/N4yob14tQPQWL2+TQiX8fDvyqZt6/9EZU7xWp
         Jv4zu99QbSCv+ijxoKZtjgCwsd/Jc/HqJuDVlp5qmDR9fzLzWqtyUT4kzbQFd9BdJIic
         R+lqThvhZkF8pvh0X1rr92OM5VZ/RlGjz+rpFmgYIsm3Y/PNpfmg0YXiFMeoHubOHlbs
         nHjA==
X-Gm-Message-State: APjAAAVDWk8SXuq2iA6ZPB+q15V8HGPa5tYr9GzeCDiXzivM3yVfoT9F
        2HP7p6jXbTh+o+LGFzYLEsNZ6WV8lMI=
X-Google-Smtp-Source: APXvYqzvKtgoHRUQEnVLQpQ0nxjXSKUhhwnf9wBUYBNNV+5x0IFTnbJp2ycwWLEQm0giunqfzPq3Pg==
X-Received: by 2002:adf:f18b:: with SMTP id h11mr3798801wro.56.1575364096184;
        Tue, 03 Dec 2019 01:08:16 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id f1sm2688283wrp.93.2019.12.03.01.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 01:08:15 -0800 (PST)
Date:   Tue, 3 Dec 2019 09:08:13 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 205655] New: kvm with cache=none and btrfs -> corrupted
 file system
Message-ID: <20191203090813.GA153510@stefanha-x1.localdomain>
References: <bug-205655-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <bug-205655-28872@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2019 at 09:24:48AM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D205655
>=20
>             Bug ID: 205655
>            Summary: kvm with cache=3Dnone and btrfs -> corrupted file sys=
tem
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 4.9   4.19    5.3.12
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: denis.ovsyannikov@gmail.com
>         Regression: No
>=20
> hello
> we use kvm with disks formatted in btrfs
> when we turned on the mode "cache=3Dnone"
> got data corruption
> other modes work well
>=20
> we tested it on three servers and the result is always repeated
> we tested on three operating systems(debian 9, debian 10, manjaro with ke=
rnel
> 5.3.12)
>=20
> fstab
> UUID=3Da49494f2-35a4-4a9c-aab0-1afc905c02c2 /mnt/test      btrfs   defaul=
ts 0 2
>=20
> dmesg
> [675174.887900] BTRFS error (device sde1): bdev /dev/sde1 errs: wr 0, rd =
0,
> flush 0, corrupt 2137, gen 0
>=20
> [102857.086874] BTRFS warning (device sdc1): csum failed root 256 ino 260=
 off
> 1735843840 csum 0xf69f8dd2 expected csum 0x96e71981 mirror 1

Please post your QEMU command-line.

What is the storage configuration on the host?  Which host file system
are you using?  Which image file format?

What test is being run inside the guest?

Is this a regression?  Which host and guest kernel versions worked fine
before?

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3mJf0ACgkQnKSrs4Gr
c8jIkgf/Yec6LMb7alH+EBiSGKzL/vYprgCx2We59exJ3s8k2YApiu2gKjlqWOHY
Fa5MT+PX/Id2Rw7cwgfa0JK8rt+k457/5sFPQJGPNs56aP20BgWqM03C/ZXFhOzD
5KPrO8412dYT+grka/vfdEue196wQGnDpEO4heJmQQFf+kLckQXvY2pLSPzu4Fgp
P+hjWmCxw+LUd9FeNEkVZEtDpH/CMwiiqbh7Fw137/ds1xdYuNz6BGt8//gS0G20
5aPQCl/NsA1xX+nuvoX3a1Y8p4lLAvXZhgQo6BmUyHk8Zz32iNp9AyGjGncBMP0j
7GTBPok+KQ0cQZa/BdyynLgS4Zk0nA==
=5A2r
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
