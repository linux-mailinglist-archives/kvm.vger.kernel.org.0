Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C351FB648
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgFPPeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 11:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgFPPen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 11:34:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28302C061573;
        Tue, 16 Jun 2020 08:34:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x13so21236614wrv.4;
        Tue, 16 Jun 2020 08:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=heeKT585/GdJnkdDzmupKcXSMWfb3JfA/9n//HJB8KI=;
        b=cVYrNLNBPz0x7FpNz+U7hpChITwYsvE8DuKNm4jFWi++FFsx9Oy5FGkGG7EMAeixt5
         U3WtXC/XYWsXL42lruWiNAMIaRDKlzVff8qoSZ6PoHK8XWLzziskLvOWnmeVBWIZHREj
         CLvmtD80NhJ1D3CeNego+GCMSfHpbodVfLy68PkArxZaBkTttH9eFkxIviYNo08PweY8
         sS3ZAV6yrqnkiOElaGZ4qLNldl23QnU4OchQd0QTff25M+gljt2uNkwy5AgCTYni49N3
         NPLLKrZrawdCqgE+FotClWohXnwxarw70eHiR7UTtByQZ6/I8ry/BGO43Iok3f9zc6iT
         ZDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=heeKT585/GdJnkdDzmupKcXSMWfb3JfA/9n//HJB8KI=;
        b=YNZDwyxupcP++IpDYgee3U0DRKGNhrfylg5QMqsAeVUTTr6mmYFqOXT8/nGvouY/YQ
         BZMSzh9J1MTZdleeX5sVKERcOjy3Vr1Rvq2xh5wLfjJ/ErEIfSla1iSljhXuhxGmxvLg
         GI3RzxTBtkCjvO8WDSfFdvqSFtxy04QEOb/TaWKgfNkqjw/iZ8IvVPwa4P3tyuNFCuVn
         PPeIpP/NIgiN/JMf/BTDDT8dpuNjs9oGHnt97Fl17r7thTnKkR6hlx/Ef8YUTAJt5LSx
         caL1uUpaapN1URn+IxfFrQviaW4CQd2ElFkR9zL0IGSc6y+Flu9coYxLfO9bwOV3GEry
         OQeg==
X-Gm-Message-State: AOAM532etjRxO0PXpBO8ZhLrjZaPpVWctlg0dIlBkqnKA48ZAW4GVbFs
        a2zHYQ4I8ZpHwRtBKqyIddQ=
X-Google-Smtp-Source: ABdhPJw/GEtHnCh8n9ATBH9qJvvqoxLPRCt8puQyiC7D6fMHA7H4jA6wx0SyNiBrwSUDVP8LvdB0DQ==
X-Received: by 2002:adf:e692:: with SMTP id r18mr3503560wrm.192.1592321681879;
        Tue, 16 Jun 2020 08:34:41 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id j4sm4815947wma.7.2020.06.16.08.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:34:41 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:34:39 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20200616153439.GE1491454@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
 <DM5PR11MB143598745517132685DF1D09C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <DM5PR11MB143598745517132685DF1D09C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2020 at 12:39:40PM +0000, Liu, Yi L wrote:
> > From: Stefan Hajnoczi <stefanha@gmail.com>
> > Sent: Monday, June 15, 2020 6:02 PM
> >=20
> > On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> > > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> > > Intel platforms allows address space sharing between device DMA and
> > > applications. SVA can reduce programming complexity and enhance secur=
ity.
> > >
> > > This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
> > > guest application address space with passthru devices. This is called
> > > vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> > > changes. For IOMMU and QEMU changes, they are in separate series (lis=
ted
> > > in the "Related series").
> > >
> > > The high-level architecture for SVA virtualization is as below, the k=
ey
> > > design of vSVA support is to utilize the dual-stage IOMMU translation=
 (
> > > also known as IOMMU nesting translation) capability in host IOMMU.
> > >
> > >
> > >     .-------------.  .---------------------------.
> > >     |   vIOMMU    |  | Guest process CR3, FL only|
> > >     |             |  '---------------------------'
> > >     .----------------/
> > >     | PASID Entry |--- PASID cache flush -
> > >     '-------------'                       |
> > >     |             |                       V
> > >     |             |                CR3 in GPA
> > >     '-------------'
> > > Guest
> > > ------| Shadow |--------------------------|--------
> > >       v        v                          v
> > > Host
> > >     .-------------.  .----------------------.
> > >     |   pIOMMU    |  | Bind FL for GVA-GPA  |
> > >     |             |  '----------------------'
> > >     .----------------/  |
> > >     | PASID Entry |     V (Nested xlate)
> > >     '----------------\.------------------------------.
> > >     |             |   |SL for GPA-HPA, default domain|
> > >     |             |   '------------------------------'
> > >     '-------------'
> > > Where:
> > >  - FL =3D First level/stage one page tables
> > >  - SL =3D Second level/stage two page tables
> >=20
> > Hi,
> > Looks like an interesting feature!
>=20
> thanks for the interest. Stefan :-)
>=20
> > To check I understand this feature: can applications now pass virtual
> > addresses to devices instead of translating to IOVAs?
>=20
> yes, application could pass virtual addresses to device directly. As
> long as the virtual address is mapped in cpu page table, then IOMMU
> would get it translated to physical address.
>=20
> > If yes, can guest applications restrict the vSVA address space so the
> > device only has access to certain regions?
>=20
> do you mean restrict the access of certain virtual address regions of
> guest application ? or certain guest memory? :-)

Your reply below answered my question. I was wondering if applications
can protect parts of their virtual memory space that should not be
accessed by the device. It makes sense that there is a trade-off to
simplify the programming model and performance might also be better if
the application doesn't need to DMA map/unmap buffers frequently.

Stefan

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7o5o8ACgkQnKSrs4Gr
c8g6Tgf/Van2m7eceyvVRw03HdeF1bB30zQNxTLZWlAYDwU8aW2VTupF58Qp/21A
SqcR20C9LsPofsXKrbhWfK+6FVu/HxqQTR2cNtRLGE6/lSMB892d4YC/wEgMPWyb
h+bHpwTOxse5/ywwglCtapKMgTpLdtvFWXGRAF5/g4BLM19dEji5JoSZf1oQEIT6
g8aCbxYoaD9GyE7HpYazYL1xPawp67YQNIp833WVsNky/9F/b9qnJxsg9QcVVJyq
2wcW/9L18xKbM2lEBHgIkJp/6tumX0x02wn5E+TsLj5l1X5FxMC5VDqUY4dovBvu
yzWMCyrcU+JnPV6o2VOhBqNiZf4SZQ==
=jhcy
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
