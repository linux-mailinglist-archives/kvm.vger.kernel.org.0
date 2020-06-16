Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E81FB97F
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732303AbgFPPtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 11:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732519AbgFPPtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A94C061573;
        Tue, 16 Jun 2020 08:49:32 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so21311505wrp.2;
        Tue, 16 Jun 2020 08:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5DdpumczYer1vzyYLEBjn6HNhUmet7Q95lmH6nZR+oA=;
        b=EgiFdnxTeJY8cjznp6PQXqvoiOqDIzX5Mu+fGi9ZJUX+5sY9Uq2jcVuL0batMqbDI1
         o8Xu+jBcSc3ETlLA5o0LHy88Akoz9OzZqHJszjVUmR2V9Mbmxjbs4l7xJgTDicnCcQeH
         6gQ2+2Q1+cxDgafp07cueNU47muxQs5tbiMsLF2CrEvN5HtVSw1ITaA8WiAQ1o5vOO+A
         CtoXHJdHuZvWoIlAszBkT2K7gRkl9AwVHI86EVB/sgy4tUu8iSIFHS1MsC/3V+yz5Nzm
         n6U1RRqhogNORJ1iFN4FVwsJ+QhE4d5mwq3YjdeXkIXM3lC6uaMoXS31SDuhuNmVGfe2
         u2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5DdpumczYer1vzyYLEBjn6HNhUmet7Q95lmH6nZR+oA=;
        b=GiF7ptmXu+aYQ4MlHf9eswExySL9mc4qNlJ4diYjvYYbU5LgPQKkL6XTeA+qMSmW3p
         pTDfDoVf8CCPJeAp/p9vf4o0/nSYMY0xMpwuV0IT4NtBUdaBxoAcXyBDmzzNP0jMHoPl
         VDowdxDuADn52JlZoX3iRe5GDUn4a3BjTd4kybx7tv1TssaeCP5Q6YziBwp4tt5pdukW
         /NrZLvpjGllmPYHVJc495P/QAJ5KCyOQfz959OgHvDEsMBuKa6PRNK3eCVkbLGHIO3+G
         QkHLmmsgXLBX96lsnovj6RPE2+aW0wfcNLf2U/VLHAh3DscxUO8WIvtd/G7xvEslfswa
         O7mA==
X-Gm-Message-State: AOAM531ZiKPN2jf5YZoGOWeqpp3IxFPX0O1++ICL22xsfk8VLSXgHhXy
        EoBW0gguZozVLGjexLu/mgI=
X-Google-Smtp-Source: ABdhPJwV7EoNU1H3o082LpYH1XlfkrVKA4HXT5i+T2TIXgDIWRTkvvImYhC/z6iTop1auSEsn/oH8g==
X-Received: by 2002:adf:f882:: with SMTP id u2mr3978022wrp.40.1592322571413;
        Tue, 16 Jun 2020 08:49:31 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w10sm29855176wrp.16.2020.06.16.08.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:49:30 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:49:28 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Message-ID: <20200616154928.GF1491454@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <20200615100214.GC1491454@stefanha-x1.localdomain>
 <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16451F1E4748DF97D6A1DDD48C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2020 at 02:26:38AM +0000, Tian, Kevin wrote:
> > From: Stefan Hajnoczi <stefanha@gmail.com>
> > Sent: Monday, June 15, 2020 6:02 PM
> >=20
> > On Thu, Jun 11, 2020 at 05:15:19AM -0700, Liu Yi L wrote:
> > > Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> > > Intel platforms allows address space sharing between device DMA and
> > > applications. SVA can reduce programming complexity and enhance
> > security.
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
> >=20
> > To check I understand this feature: can applications now pass virtual
> > addresses to devices instead of translating to IOVAs?
> >=20
> > If yes, can guest applications restrict the vSVA address space so the
> > device only has access to certain regions?
> >=20
> > On one hand replacing IOVA translation with virtual addresses simplifies
> > the application programming model, but does it give up isolation if the
> > device can now access all application memory?
> >=20
>=20
> with SVA each application is allocated with a unique PASID to tag its
> virtual address space. The device that claims SVA support must guarantee=
=20
> that one application can only program the device to access its own virtual
> address space (i.e. all DMAs triggered by this application are tagged with
> the application's PASID, and are translated by IOMMU's PASID-granular
> page table). So, isolation is not sacrificed in SVA.

Isolation between applications is preserved but there is no isolation
between the device and the application itself. The application needs to
trust the device.

Examples:

1. The device can snoop secret data from readable pages in the
   application's virtual memory space.

2. The device can gain arbitrary execution on the CPU by overwriting
   control flow addresses (e.g. function pointers, stack return
   addresses) in writable pages.

Stefan

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7o6ggACgkQnKSrs4Gr
c8i4Dwf+Ja8+o4M38hy+I+mda6ZTLNogJhW1RTV2lBBk35XwDmYv+WqLnD/PrUNA
NSu0+o9RXtM9lj0HS1KkRvJGpFs1Q/YtBH1p8vlpxXjyCglRIJdw2uAVejCPUxip
Oez+BhKteh3v0betTZYyQsgAog/HcMU+0mZRGx2O1c9dcyz2+qq5xyKSO5OBjpd4
mcV4DNabPK85TNquyyU3Di88H1A4VdGuDmKOoU5rER7W07c0nfbPgU+V/CEB1Fww
LZ7G8QRQydGuZRyBROl9VhYI6YjMeKs8YxIDoJddQQOycSOgUZJxAZazPe9h4G78
VlimM2C+wn7w/KXE5mbKg9CjbMkh7g==
=cjRe
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
