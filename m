Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA7203738
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgFVMt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgFVMtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:49:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBAFC061794;
        Mon, 22 Jun 2020 05:49:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x16so5609001wmj.1;
        Mon, 22 Jun 2020 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KyLbHowE6Jr6ya5fF0rsMffz94nF0gU2x2NdsZwz5xg=;
        b=jSHOIfFO6zvVaNFqx8sLYnIxMZys6BSWItV9cExOZn7uRFt1usy6TniPiGY3Wpku4M
         cPiLnANrE5H89S/ajTkWTOtWY4oyKeG3L8sjRkvXMsyFtl9VLH1nfImE5cA84jiV6L30
         pm+xidmd+f6Ye1FRRv5Wlnr2y8j0KgljbWFlz3RQSNtMgwUeQ5mRc8UPu1WoFjza4n3m
         HNqkgQTlQ+9saGhaxYriNMDRTyjnOYpTho3Im5/Kyn9ArKh2/+LA7LaicydPqzEPjpRe
         rJTBS5xXRnrelHTMU/S8XtPt8AkGEgnEjgKA3jhqrfNGUaOBMSkaWLlctQHEzs+7J6/y
         UZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KyLbHowE6Jr6ya5fF0rsMffz94nF0gU2x2NdsZwz5xg=;
        b=MBILhs+qHkVHWAq6M2t4B8Y+fzNpLP0B23phOX1Ep29vnqlygd47k/W3O/sMrHOEr1
         61C71EfiMKzpt2sHLbh9Nttigp3eMQdIProsKlfYPXR/5BQDcweUSom8yZ3lFLmNZA4z
         sceZ6noVQWWpNn54fEjywjo+PzXqmp92EkT23/Js+SKg+5U4UwUZ438wOMgSEMOq5OyV
         GBD8X+q8TSoFloJizNCD0PZmtwz0prqK3AJOcUJ14lzOMIHsNvONwmgnuS9VtPXsd0yG
         6VkYU/55PMGFvQ/AeKBzjQVPM64sFjKjEyM/d3WBaR3fMg4B7h1jxylsh6wjZnX9Bkug
         YM1w==
X-Gm-Message-State: AOAM532XL8c0sqof4ueqtjjqnIKSrD1Ug5UrnjPkNJ7Yy7Xkm5jP+8gt
        NuX0rtkAuGT4tRCmbBk79tSsiUmyEe8=
X-Google-Smtp-Source: ABdhPJznXuUJEHfwe0EtG5zR7hb9qeM0wSlf8Zkg2rS6OhrasTx0vYRyo2FQTbcA9V7VXwBVsfXdMA==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr11963492wmm.156.1592830164484;
        Mon, 22 Jun 2020 05:49:24 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id a22sm9152512wmj.9.2020.06.22.05.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:49:23 -0700 (PDT)
Date:   Mon, 22 Jun 2020 13:49:22 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200622124922.GB15683@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
 <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200616154928.GF1491454@stefanha-x1.localdomain>
 <20200616160916.GC11838@xz-x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20200616160916.GC11838@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2020 at 12:09:16PM -0400, Peter Xu wrote:
> On Tue, Jun 16, 2020 at 04:49:28PM +0100, Stefan Hajnoczi wrote:
> > Isolation between applications is preserved but there is no isolation
> > between the device and the application itself. The application needs to
> > trust the device.
> >=20
> > Examples:
> >=20
> > 1. The device can snoop secret data from readable pages in the
> >    application's virtual memory space.
> >=20
> > 2. The device can gain arbitrary execution on the CPU by overwriting
> >    control flow addresses (e.g. function pointers, stack return
> >    addresses) in writable pages.
>=20
> To me, SVA seems to be that "middle layer" of secure where it's not as sa=
fe as
> VFIO_IOMMU_MAP_DMA which has buffer level granularity of control (but of =
course
> we pay overhead on buffer setups and on-the-fly translations), however it=
's far
> better than DMA with no IOMMU which can ruin the whole host/guest, because
> after all we do a lot of isolations as process based.
>=20
> IMHO it's the same as when we see a VM (or the QEMU process) as a whole a=
long
> with the guest code.  In some cases we don't care if the guest did some b=
ad
> things to mess up with its own QEMU process.  It is still ideal if we can=
 even
> stop the guest from doing so, but when it's not easy to do it the ideal w=
ay, we
> just lower the requirement to not spread the influence to the host and ot=
her
> VMs.

Makes sense.

Stefan

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7wqNIACgkQnKSrs4Gr
c8hI8gf/caTxzWohWdHk0/Kop0H0CHDO065rgRJxZWIoB6f9resPUp7w3XbfOSzJ
cSXRukN+jPVq04Wh30cOpxJKT1OvdWTr6qgEa2u8mKZPCM3tftAN6j15gum7wcm+
LQhpJaHes/xES7VI3MbqoOtxVzxQ+kS5ve7fDxWSxVbE8fi10WGll5lx4eH+AOqC
nWbqRXKCb67Ya4aPiW+HZrs4zxcDe0CjIPqYLsGIRhC03VbMetbzygcxa6jMvibS
zye/aP0RQysbVYVgWlVvuGXvBwvJEDWE2d6AsRrVsXuLI2Vgstarzf0ttUxQuVRk
gY8hL0ENtePg6Iub4OC/idFoMffoZw==
=EiVH
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
