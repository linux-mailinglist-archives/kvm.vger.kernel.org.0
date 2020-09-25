Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9727858F
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 13:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgIYLMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 07:12:07 -0400
Received: from mail.xenrox.net ([176.9.100.68]:41874 "EHLO mail.xenrox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYLMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 07:12:06 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 07:12:06 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E03425E0109;
        Fri, 25 Sep 2020 13:03:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xenrox.net; s=dkim;
        t=1601031820; h=from:subject:date:message-id:to:cc:mime-version:content-type;
        bh=n42F4EmkQtqdELNXsWOkrsRVMuIzhyJ3QdwhtwuQ8QA=;
        b=dXwM9kSM5YKl8+j/PsSx0K2nTqtFGaNB+H9nnfWWTHKyw1n59OPKlok/Oq2MQ9Xho/mcN6
        wsXEZxBdQudfAdqK1+WSJYA6AFfCYfteAdd37r92tcn6tTIzK54I7GA9vQvfQr3jqB90/D
        TzRmvjkJRKw1eP8iB12Lguomgzjs6kPOL7gKJ6yeIXetar++qaOqgCPbrmg0mvpMsi/IU5
        BKg+n/YsCk7/+Sxom0giToBIhRfuVHbs4QaVLZN92FxBP6pIqhkNcTpHEBAfxcn52f0L7L
        RElqW6l6fVoCkfyTiVJYi0fs3Fa5Bk3TiJWhHxr2srNK5YLTJaatxiCot2YvJQ==
Date:   Fri, 25 Sep 2020 13:03:29 +0200
From:   Thorben =?utf-8?Q?G=C3=BCnther?= <admin@xenrox.net>
To:     kvm@vger.kernel.org
Cc:     Drew DeVault <sir@cmpwn.com>
Subject: Boot freeze with nested KVM
Message-ID: <20200925110329.p5ziayi33ldmp6np@xenrox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3abka77bodeb6632"
Content-Disposition: inline
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3abka77bodeb6632
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I am currently investigating a bug on the builds system of sourcehut
(https://builds.sr.ht/). The owner and developer is cc'ed.

Sourcehut uses docker to build a statically linked qemu to boot images
of different linux flavours. These images get refreshed by building
themselves and doing a so called sanity check - that consists of using a
packaged qemu to start the image followed by a SSH connection.
The sanity check only fails on bleeding edge OS (e.g. Arch Linux, Debian
Sid): The boot process freezes with 100% CPU usage.
The same procedure works completely fine on my self hosted instance.

Sourcehut:
Alpine Linux
5.4.43 LTS
AMD EPYC 7281 16-Core Processor

Self hosted instance:
Arch Linux
5.8.10
Intel(R) Core(TM) i7-7700

In both cases qemu-headless 5.1.0 is used.

This is the failing qemu command: [1]
This happens during boot freeze: [2] [3]
strace: [4]
strace from beginning: [5]

If I leave out "-enable-kvm -cpu host" it works fine.

Kind regards

[1] https://paste.xenrox.net/~xenrox/29d28d1ea61a04f819819861266554ea42a0d11e#qemu%20command
[2] https://paste.xenrox.net/~xenrox/29d28d1ea61a04f819819861266554ea42a0d11e#boot%20freeze%201
[3] https://paste.xenrox.net/~xenrox/29d28d1ea61a04f819819861266554ea42a0d11e#boot%20freeze%202
[4] https://paste.xenrox.net/~xenrox/29d28d1ea61a04f819819861266554ea42a0d11e#strace%20running
[5] https://paste.xenrox.net/~xenrox/29d28d1ea61a04f819819861266554ea42a0d11e#strace%20beginning

--3abka77bodeb6632
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAABCgBMFiEE8S88GeQBs5H8ShuoQVzXeNjFr+0FAl9tzoAuFIAAAAAAFQAQ
cGthLWFkZHJlc3NAZ251cGcub3JnYWRtaW5AeGVucm94Lm5ldAAKCRBBXNd42MWv
7V44D/4kk8pKrt3BYInvNAkDhutTUSDEqMwFKWACCqLr7vQMXt8hEhub/2hw5h3c
HcnGCkfOGoVcL+dHErZjcfDSkB/SUPdht3DF9zMVUpnvXLfXUhUZERpW3iXKYoqO
zAAU4/3dKw6SgP6G+UmYtHVbZebVVCTwClh/3U3n2OC6shuNVRka3ZEohg42fRpG
MWootV6anKi1e+QB5Us/x3wr0zfqD1IL50CnQdRw3U2N83Aaa2AyNJ9R3P47mMJI
0qovIk7sblfSIUX9wKcooGB733GW0sK7LSlzvVLi6HkcPuCNxbcCK0wQLHamFeFE
tIpVmpuLr2H3KEz4XQq7z9RoSgz+p7725EyNWZqHwLQJPBUCqvbzAo7qKFdF+/dW
mU2kxUetnrpMU0eKlfRA+SCpTWqYnkTdlRbyAKTyzzeCpr1m57gl0DODNWMxUn8c
Mhpw8DzOilePEWJTjHST0jSCSgx9ezkSSLGXmA/FzFwPxyOemvJJ6FLE87/XElNU
i+t3cHVJbifcTcc2nqkCQbSiVdvmEOcC7xLqcNkBPhsW+Zae3gHUN9FqCUrlmUrA
Z+RTLV1Nw0LeDiozEymENmFPa+/rEvayvW2gFqICsPGOUy+kZu5ysjhMAM7V2XJD
Fjhq+Rx0YqW60eQ0hIvQ4bYm2XyVKI/+Pj6tB4Urk8A3CWl6Mg==
=m1pB
-----END PGP SIGNATURE-----

--3abka77bodeb6632--
