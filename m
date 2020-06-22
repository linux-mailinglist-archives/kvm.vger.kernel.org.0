Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86ED203730
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgFVMtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgFVMtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:49:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E7FC061794;
        Mon, 22 Jun 2020 05:49:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c3so16497191wru.12;
        Mon, 22 Jun 2020 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGatUJxNTAw2tUiFEaNFWmvGzMlb5CEE+27h8ZbQoqA=;
        b=Fo0jCaebeHZeZRepyjDDO5l3PFS2O33eoeemUc7+TfVjsdW0PZh1jxiNqsbozvZ+/S
         WbwtPoO2/lKaDMExIygZ/rAUsJZnrnQpNutiLvWuLimsp+OhRyAfBdp5NsRSAThz5uKx
         63wl8EZq7CCRE1v387f86SlE6MhyIpQYjUrzcFdFeaWUz30gUNnloIJODOMqxXC2I/dH
         0hnhSV/v0ZA0i+h5a9r/Z0tZpFgmn/9kIalWhRtDb2eZWiVcAp1MBWs0EOyCMNMg8BmD
         XiGyMtxPjjT7otFsFPFJVrKjx0xjG75+Ny6hSK4vLaRlvtfg9Mr5clmipUCDINCpWCUF
         fGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGatUJxNTAw2tUiFEaNFWmvGzMlb5CEE+27h8ZbQoqA=;
        b=VgnCoufsJeYmjh171O0or1Dz7WcwIcXrdH9lVM9o0GdXh+PSxecDzRbGLYmfxzR/4D
         sUyimc8eDzrJZTUzYmssZmneqMUPB8jn/nmCeCc6R89gQ+KnNZNw+56M3RgIsCRM0CB+
         849CAF2FexdxF/IPbE3Z7wNRvrPKsxVV44mwA7yZxOoojqW/ABtYc2CG6UNLDCIKHcLH
         JLBEtFCP3v8U2rqXFCHPa8ENut5WUDp7MNFc6Ts0ghIW14Rg5bFCF2hzt82xDCygjbUe
         vaXsJW1pfBCN3TaU7cgK7GeI7/BeUx6q3WdldZUnD4GExtu89Bx9tJmQaWzfyO2F9zoO
         hbRA==
X-Gm-Message-State: AOAM5315iOfpR/j5m91qF+Qhtkicxud8TmovWVhbIIC01nutETQf/l7C
        sQKIvbf+X1RhAW5ps768s0i0+1QqFLc=
X-Google-Smtp-Source: ABdhPJzMLu4KRyVzvJP0bS2XiYGikCs23dmilk57dFnSrKScoyR4yDFMDMhiQJv/QXhrNjgLZ9TprQ==
X-Received: by 2002:a5d:6088:: with SMTP id w8mr3846805wrt.49.1592830146570;
        Mon, 22 Jun 2020 05:49:06 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id c201sm12510825wmd.4.2020.06.22.05.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:49:05 -0700 (PDT)
Date:   Mon, 22 Jun 2020 13:49:04 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200622124904.GA15683@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
 <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200616154928.GF1491454@stefanha-x1.localdomain>
 <20200616170016.GC34820@otc-nc-03>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20200616170016.GC34820@otc-nc-03>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2020 at 10:00:16AM -0700, Raj, Ashok wrote:
> On Tue, Jun 16, 2020 at 04:49:28PM +0100, Stefan Hajnoczi wrote:
> > On Tue, Jun 16, 2020 at 02:26:38AM +0000, Tian, Kevin wrote:
> > > > From: Stefan Hajnoczi <stefanha@gmail.com>
> > > > Sent: Monday, June 15, 2020 6:02 PM
> > > >=20
> > > > On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> > > > > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SV=
M) on
> > > > > Intel platforms allows address space sharing between device DMA a=
nd
> > > > > applications. SVA can reduce programming complexity and enhance
> > > > security.
> > > > >
> > > > > This VFIO series is intended to expose SVA usage to VMs. i.e. Sha=
ring
> > > > > guest application address space with passthru devices. This is ca=
lled
> > > > > vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/I=
OMMU
> > > > > changes. For IOMMU and QEMU changes, they are in separate series =
(listed
> > > > > in the "Related series").
> > > > >
> > > > > The high-level architecture for SVA virtualization is as below, t=
he key
> > > > > design of vSVA support is to utilize the dual-stage IOMMU transla=
tion (
> > > > > also known as IOMMU nesting translation) capability in host IOMMU.
> > > > >
> > > > >
> > > > >     .-------------.  .---------------------------.
> > > > >     |   vIOMMU    |  | Guest process CR3, FL only|
> > > > >     |             |  '---------------------------'
> > > > >     .----------------/
> > > > >     | PASID Entry |--- PASID cache flush -
> > > > >     '-------------'                       |
> > > > >     |             |                       V
> > > > >     |             |                CR3 in GPA
> > > > >     '-------------'
> > > > > Guest
> > > > > ------| Shadow |--------------------------|--------
> > > > >       v        v                          v
> > > > > Host
> > > > >     .-------------.  .----------------------.
> > > > >     |   pIOMMU    |  | Bind FL for GVA-GPA  |
> > > > >     |             |  '----------------------'
> > > > >     .----------------/  |
> > > > >     | PASID Entry |     V (Nested xlate)
> > > > >     '----------------\.------------------------------.
> > > > >     |             |   |SL for GPA-HPA, default domain|
> > > > >     |             |   '------------------------------'
> > > > >     '-------------'
> > > > > Where:
> > > > >  - FL =3D First level/stage one page tables
> > > > >  - SL =3D Second level/stage two page tables
> > > >=20
> > > > Hi,
> > > > Looks like an interesting feature!
> > > >=20
> > > > To check I understand this feature: can applications now pass virtu=
al
> > > > addresses to devices instead of translating to IOVAs?
> > > >=20
> > > > If yes, can guest applications restrict the vSVA address space so t=
he
> > > > device only has access to certain regions?
> > > >=20
> > > > On one hand replacing IOVA translation with virtual addresses simpl=
ifies
> > > > the application programming model, but does it give up isolation if=
 the
> > > > device can now access all application memory?
> > > >=20
> > >=20
> > > with SVA each application is allocated with a unique PASID to tag its
> > > virtual address space. The device that claims SVA support must guaran=
tee=20
> > > that one application can only program the device to access its own vi=
rtual
> > > address space (i.e. all DMAs triggered by this application are tagged=
 with
> > > the application's PASID, and are translated by IOMMU's PASID-granular
> > > page table). So, isolation is not sacrificed in SVA.
> >=20
> > Isolation between applications is preserved but there is no isolation
> > between the device and the application itself. The application needs to
> > trust the device.
>=20
> Right. With all convenience comes security trust. With SVA there is an
> expectation that the device has the required security boundaries properly
> implemented. FWIW, what is our guarantee today that VF's are secure from
> one another or even its own PF? They can also generate transactions with
> any of its peer id's and there is nothing an IOMMU can do today. Other th=
an
> rely on ACS. Even BusMaster enable can be ignored and devices (malicious
> or otherwise) can generate after the BM=3D0. With SVM you get the benefit=
s of
>=20
> * Not having to register regions
> * Don't need to pin application space for DMA.

As along as the security model is clearly documented users can decide
whether or not SVA meets their requirements. I just wanted to clarify
what the security model is.

>=20
> >=20
> > Examples:
> >=20
> > 1. The device can snoop secret data from readable pages in the
> >    application's virtual memory space.
>=20
> Aren't there other security technologies that can address this?

Maybe the IOMMU could enforce Memory Protection Keys? Imagine each
device is assigned a subset of memory protection keys and the IOMMU
checks them on each device access. This would allow the application to
mark certain pages off-limits to the device but the IOMMU could still
walk the full process page table (no need to construct a special device
page table for the IOMMU).

> >=20
> > 2. The device can gain arbitrary execution on the CPU by overwriting
> >    control flow addresses (e.g. function pointers, stack return
> >    addresses) in writable pages.
>=20
> I suppose technology like CET might be able to guard. The general
> expectation is code pages and anything that needs to be protected should =
be
> mapped nor writable.

Function pointers are a common exception to this. They are often located
in writable heap or stack pages.

There might also be dynamic linker memory structures that are easy to
hijack.

Stefan

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7wqL8ACgkQnKSrs4Gr
c8heuQgApuxvMLS3gRIfo/o5wq9Bk1pmP6BYlbH+zzsGCLuIHFmY4vMWAxjZxfX/
ThavBmvMFOSnJSzTxzDcM/kY1P5XfcTwdaEaELIn/Pvd1bnfo+1R3fxUZAL9wQeT
y1XqmdmqC8s8Gv38VLR6YhWuEs0ZkevIWCMkySxjkvb0VN0OdFBidJeroRJq/LTo
dlmZJQg138jFzeSJYHsT6sY+SHKZVjnLltBOZJxVHRLzEPeA0YfqPeLNmOZDUAA4
nSGknlEO5CUuWGo9NK0JNfA0CbRR+cWgUtIcGi3FS729MSKXoErHoNVTgKPxL992
KjDqf88bkzcwGigXGrKjmB2TOvbmAg==
=/67A
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
