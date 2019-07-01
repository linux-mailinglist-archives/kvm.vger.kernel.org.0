Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7265B861
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 11:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfGAJtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 05:49:01 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37982 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfGAJs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 05:48:58 -0400
Received: by mail-wm1-f42.google.com with SMTP id s15so15136204wmj.3
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 02:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CvcT0w1jzP9eTOCyPf4pCthO4g7CTShM5Ixk+VI/AKo=;
        b=ahA2dteTvry9nfyph7bVUwroYcCuhLbtQQhL39h55FojHjpWTnJYTcpVPLWHhqdXxL
         VSYW5cis2BsTEubzHjFadV4Lh0Dlr6ACIfR2oUBHeZ+xvzfM9e6T+QYX2SZKFbAZCQNI
         vFqliN0vJfcJ0TmhnIBEVlu5pDbWzYXhvmB4EtQoJNtEN2AZeqeHBf3zmdSUjSKlnt//
         wbYuGzry1YEglyDJ/2/a7SPYlPPjcE2+zLN9sxLEio9szAX71CZihrlb1g6myR8MUvLe
         fJuBt9SWQwxyRn6xpVOzziyPiVGSNxTQfIIe6ZeKNBg+Ob88YkzjzX41VEBKe2ksGLal
         Qa7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CvcT0w1jzP9eTOCyPf4pCthO4g7CTShM5Ixk+VI/AKo=;
        b=YiYVHZULqnfdtTiQif12KXLnJ2gA7ypMSlMhqwYbaLdxXJAH9M7ESfUHl24GZ6RdsG
         ZF/zLIdqZACdbAcZpbpmTsnrUSvXJ2X4M5dkej6qeghBh1H3qe37zJwuHQnbb5/iCWLN
         26jokvY6atgZR4iqyGlP4ICoekoKp6yBmAd5yu1kZvQ57JQDxTx+XsctfIhHHFWSFDmU
         Hsm8zaoFJfjItCd6ON1mHdiBZlqfWvH2pXiD7hWWoE++LrfrdjiTroLLlS7TSemwq8Sp
         WaE2THJRXNJwIuS60g+RpPAREonIzX0HeMqHhSLiiG0TID61xsLzrbaxXMyzD0VCknRW
         BzGQ==
X-Gm-Message-State: APjAAAWxZq5eqxlamcPeTR1q9Gwt41n8BX6TMfVjOiB09dug6BJnQ/ps
        ZD9ndnJxCd+vsDJrPzFSegTBmT3inAMt+Q==
X-Google-Smtp-Source: APXvYqylxiOq3sieXkk8/mYd4Hyt6cdZfhQg8eleD8yggF7ws8xZknrBtbjW8eSYO4/YlTwcPpqZnA==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr16244566wmc.13.1561974536692;
        Mon, 01 Jul 2019 02:48:56 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id q193sm8702016wme.8.2019.07.01.02.48.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 02:48:55 -0700 (PDT)
Date:   Mon, 1 Jul 2019 10:48:55 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     rainer@ultra-secure.de
Cc:     kvm@vger.kernel.org
Subject: Re: Question about KVM IO performance with FreeBSD as a guest OS
Message-ID: <20190701094855.GB19263@stefanha-x1.localdomain>
References: <3924BBFC-42B2-4A28-9BAF-018AA1561CAF@ultra-secure.de>
 <20190628095340.GE3316@stefanha-x1.localdomain>
 <b76013f0d3ed9c3eec92c885734a6534@ultra-secure.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <b76013f0d3ed9c3eec92c885734a6534@ultra-secure.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2019 at 03:51:04PM +0200, rainer@ultra-secure.de wrote:
> Am 2019-06-28 11:53, schrieb Stefan Hajnoczi:
> > On Sun, Jun 23, 2019 at 03:46:29PM +0200, Rainer Duffner wrote:
> on advice from my coworker, I created the image like this:
>=20
> openstack image create --file ../freebsd-image/freebsd12_v1.41.qcow2
> --disk-format qcow2 --min-disk 6 --min-ram 512 --private --protected
> --property hw_scsi_model=3Dvirtio-scsi --property hw_disk_bus=3Dscsi --pr=
operty
> hw_qemu_guest_agent=3Dyes --property os_distro=3Dfreebsd --property
> os_version=3D"12.0" "FreeBSD 12.0 amd 64 take3"
>=20
>=20
> This time, I got a bit better results:
>=20
>=20
> root@rdu5:~ # fio -filename=3D/srv/test2.fio_test_file -direct=3D1 -iodep=
th 4

I think iodepth has no effect here.  It applies to asynchronous I/O
engines like ioengine=3Dlibaio.  It's ignored for psync.

> -thread -rw=3Drandrw -ioengine=3Dpsync -bs=3D4k -size 8G -numjobs=3D4 -ru=
ntime=3D60
> -group_reporting -name=3Dpleasehelpme
> pleasehelpme: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
, (T)
> 4096B-4096B, ioengine=3Dpsync, iodepth=3D4
> ...
> fio-3.13
> Starting 4 threads
> pleasehelpme: Laying out IO file (1 file / 8192MiB)
> Jobs: 4 (f=3D4): [m(4)][100.0%][r=3D1461KiB/s,w=3D1409KiB/s][r=3D365,w=3D=
352 IOPS][eta
> 00m:00s]
> pleasehelpme: (groupid=3D0, jobs=3D4): err=3D 0: pid=3D100120: Fri Jun 28=
 15:44:42
> 2019
>   read: IOPS=3D368, BW=3D1473KiB/s (1508kB/s)(86.3MiB/60005msec)
>     clat (usec): min=3D8, max=3D139540, avg=3D6534.89, stdev=3D5761.10
>      lat (usec): min=3D13, max=3D139548, avg=3D6542.68, stdev=3D5761.00
>     clat percentiles (usec):
>      |  1.00th=3D[   13],  5.00th=3D[   17], 10.00th=3D[   25], 20.00th=
=3D[ 1827],
>      | 30.00th=3D[ 3032], 40.00th=3D[ 4555], 50.00th=3D[ 5538], 60.00th=
=3D[ 6718],
>      | 70.00th=3D[ 8160], 80.00th=3D[10290], 90.00th=3D[13829], 95.00th=
=3D[17433],
>      | 99.00th=3D[25822], 99.50th=3D[28967], 99.90th=3D[37487], 99.95th=
=3D[40633],
>      | 99.99th=3D[51643]
>    bw (  KiB/s): min=3D  972, max=3D 2135, per=3D97.21%, avg=3D1430.93, s=
tdev=3D55.37,
> samples=3D476
>    iops        : min=3D  242, max=3D  532, avg=3D356.10, stdev=3D13.86, s=
amples=3D476
>   write: IOPS=3D373, BW=3D1496KiB/s (1532kB/s)(87.6MiB/60005msec)
>     clat (usec): min=3D13, max=3D46140, avg=3D4174.36, stdev=3D2834.86
>      lat (usec): min=3D19, max=3D46146, avg=3D4182.13, stdev=3D2835.08
>     clat percentiles (usec):
>      |  1.00th=3D[   40],  5.00th=3D[   90], 10.00th=3D[ 1012], 20.00th=
=3D[ 2008],
>      | 30.00th=3D[ 2474], 40.00th=3D[ 3097], 50.00th=3D[ 3949], 60.00th=
=3D[ 4555],
>      | 70.00th=3D[ 5145], 80.00th=3D[ 6063], 90.00th=3D[ 7439], 95.00th=
=3D[ 9110],
>      | 99.00th=3D[13435], 99.50th=3D[15401], 99.90th=3D[20055], 99.95th=
=3D[22152],
>      | 99.99th=3D[36439]
>    bw (  KiB/s): min=3D  825, max=3D 2295, per=3D97.26%, avg=3D1453.99, s=
tdev=3D66.67,
> samples=3D476
>    iops        : min=3D  206, max=3D  572, avg=3D361.90, stdev=3D16.66, s=
amples=3D476
>   lat (usec)   : 10=3D0.03%, 20=3D4.14%, 50=3D3.47%, 100=3D2.29%, 250=3D2=
=2E04%
>   lat (usec)   : 500=3D0.06%, 750=3D0.51%, 1000=3D0.71%
>   lat (msec)   : 2=3D7.38%, 4=3D22.88%, 10=3D44.07%, 20=3D10.86%, 50=3D1.=
55%
>   lat (msec)   : 100=3D0.01%, 250=3D0.01%
>   cpu          : usr=3D0.11%, sys=3D2.08%, ctx=3D83384, majf=3D0, minf=3D0
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%,
> >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
> >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
> >=3D64=3D0.0%
>      issued rwts: total=3D22092,22436,0,0 short=3D0,0,0,0 dropped=3D0,0,0=
,0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D4
>=20
> Run status group 0 (all jobs):
>    READ: bw=3D1473KiB/s (1508kB/s), 1473KiB/s-1473KiB/s (1508kB/s-1508kB/=
s),
> io=3D86.3MiB (90.5MB), run=3D60005-60005msec
>   WRITE: bw=3D1496KiB/s (1532kB/s), 1496KiB/s-1496KiB/s (1532kB/s-1532kB/=
s),
> io=3D87.6MiB (91.9MB), run=3D60005-60005msec
>=20
>=20
>=20
> Which is more or less half (or a third) of what I got on CentOS.

Are you using the exact same fio command-line on CentOS?

Have you tried virtio-blk instead of virtio-scsi?

Are you able to post the QEMU command-line from the host (ps aux | grep
qemu)?  Since --property os_distro=3Dfreebsd was used to create the guest
it's likely that the guest configuration is different from the CentOS
guest.  Let's compare the two QEMU command-lines.

Stefan

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0Z1wYACgkQnKSrs4Gr
c8ji3AgAic76HSJISFSeYcBO7XsytjLs+v4GlcRMGQ+DwzHFExf/bSM9ZxVmx3vU
3G6e3YquuDagGKJni7GddvJx/o0MdhVs4lTLvmVeBKQNO8BX8MlRXJTiaWLhrVkE
sornVrENAr679L/3ELVlnuBiR4NFi7CLWWTCnSnDeC/dItniuokVjAvdqzBhYBb2
3rBu42t/pe6I4m4pShEZbcv5ahnYHOZPDkfAlykD7m2Cml/ufLCNPy0cWd34tOgF
AHS4xcnOuFiT1JAUWW4gvZM5V6NSGRUSpnRg4n55lakfw1uDpCQn9EixhzRLf6at
8ki+rFEFPkcfye8G7pK/YPIqhPUGRQ==
=QJDf
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
