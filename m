Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04C4D0B49
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfJIJcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:32:53 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37090 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJIJcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:32:53 -0400
Received: by mail-wm1-f51.google.com with SMTP id f22so1736628wmc.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y/X7QhKZj+nhiHe0CGkpGzEy53sX749PipgilVay7xA=;
        b=a1f85pHXwUF9s0YOmjJUauwnNYQH02RP2SYKyrxTUeESRdhUpOwoyNPPD6EYbXs8XZ
         60BG6/63rMP66yq3mPl3ilmarjmMkloqmz/pw0o23G3IoexBUDdeBq0qxWuDPurqJ8gp
         ppXC3QbRKjbbk5cvz1gRMH1K7E6Q72Hp9LCtaYbJhDyAovk3nE0VTfpIRyUeevZLH52z
         gDO7+RjfjBgyBFgEP+7Xfm+B0iumC2GpwmI6s/OKqsWbdLXsfJH1CrCoK+ioLuZgTUwH
         xUFebWcBPM+iSDa+UghVEOmVppIEYLT2lwoneEnPxeu5J2F0HDvP4R89wFkeP75LtRL9
         R0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y/X7QhKZj+nhiHe0CGkpGzEy53sX749PipgilVay7xA=;
        b=SSCmfZRLqIu0waHE0yuIzfvI2yMduXwCE5WW1zcpSnyb0AWSZb0vuh/Qa+TiiNNY0q
         oB4CelXq5JhXlOdQ0zxBMWZxlhJgHf0klRCPiFYMoO/m7h6Tce5xzix7UpKiWO8bMSRv
         CLWxCG9ZfgcXXM8ITVYw/x3knCYl8cvTG5xAO56fDK7iHVHFmwgYe6winWMC4IEuzIpF
         iaIvfoNoaHFcpN3lEZ5gVY2OFpZQFPfAaoFEfUHYrdvL1NNPMdzSgMEhWwxWmKf/DvWc
         DPO1YtwGAT6qoicdtpu0fzfJd0QjbhzFms9+Ya+/aYDPUMtuBa62DQSmKrtERBknfR+d
         FGDw==
X-Gm-Message-State: APjAAAUQmRqPb/frBV0Na+0t9QQMRdx+yNKeQmHkY4vDbxI0gJpC6EJB
        PrK07yuKp1dZtJnqXg4idUY=
X-Google-Smtp-Source: APXvYqzN9MloznbIOox6twjsiPBAphjsK/elbss9npzb5arAL6bnpxsSLEZuhUaXDbk/AZJ8d78NVA==
X-Received: by 2002:a1c:8148:: with SMTP id c69mr1927111wmd.41.1570613571124;
        Wed, 09 Oct 2019 02:32:51 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id t203sm1736139wmf.42.2019.10.09.02.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 02:32:50 -0700 (PDT)
Date:   Wed, 9 Oct 2019 10:32:49 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     freebsd@tango.lu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>
Subject: Re: Easy way to track Qcow2 space consumption
Message-ID: <20191009093249.GA5747@stefanha-x1.localdomain>
References: <ab1bd1a234b7b9d18433d539f179f602@tango.lu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <ab1bd1a234b7b9d18433d539f179f602@tango.lu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2019 at 08:01:11PM +0200, freebsd@tango.lu wrote:
> Hello List,
>=20
> I'm using a fairly old KVM version
>=20
> ii  pve-qemu-kvm                          2.2-28
> amd64        Full virtualization on x86 hardware
>=20
> don't see much point upgrading either since everything works but I could
> still use a feature to keep track of the actual space used by the VMs
> without SSHing into all of them and doing a df -h.
>=20
> The VM images (especially the DBs with high rw operation will just grow a=
nd
> grow with time), for this to free up space the standard process was:
>=20
> 1, Zero-fill the drive (dd if=3D/dev/zero of=3D/some/file until you run o=
ut of
> space)
> 1B, sdelete -z c: < windows VM
> 2, Shut down the VM
> 3, cd to where the images for the VM are kept and run qemu-img convert -O
> qcow2 original_image.qcow2 deduplicated_image.qcow2
>=20
> I wonder if there were any improvements done in the KVM for addressing th=
is
> space issue. A lot of us using qcow2 because it's easier to backup due to
> the small size (eg: a basic configured webserver might only uses 3-4 Gb v=
s a
> 40GB preallocated empty image full of 0s).

Hi,
I'm CCing the QEMU mailing list and Kevin Wolf, the qcow2 maintainer.

QEMU and qcow2 have support for the discard/trim command that allows the
guest to report unused regions of the disk.  virtio-scsi and recent
virtio-blk devices support this feature.

Set the -drive discard=3Dunmap QEMU command-line option in order to enable
discard.

Run the fstrim(8) Linux command inside the guest.  Other operating
systems may have equivalent commands.

You should find that the qcow2 file has fewer allocated blocks after
this operation.  Consider this an efficient replacement for zero filling
the device.  It is still necessary to shutdown the VM and use qemu-img
convert unless you want to switch to a fancier online backup process
using block job commands.

Stefan

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dqUAACgkQnKSrs4Gr
c8hN9ggAl/t7FZcEs1kfWHdFrgsfEYH7eDLGdWtg2BqBEqx7IcFo1ObGd5EhEgyF
YPUeqAeZ1U4jtoAhedvozgg9rLZROfFuisduIZqaJOxvSChGZaweK0WYyb7/xu3m
5yOhV1tfA6UnzXI7KdZO21TrI5O6zlQ78GrRbG22BskOPCHYIiNlh6l14Iq5NxMh
dhS+gdIGjxUmXKvHqGWN0tox0I5lKUHp2eE6NlSFCGHkIfucYtXRvvV6Mo17kRd+
6Dm1Eq58StBt6SrMYKtR0QSHXGYRFt24+YvzLbZxBveFY8VS39pXqR1s+s0zB2/q
8GFlIaptHRLBxrOI2UwzdFE/31eSXw==
=XlrS
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
