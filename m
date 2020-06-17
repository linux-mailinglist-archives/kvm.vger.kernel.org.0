Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D842E1FC629
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 08:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgFQG1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 02:27:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:65167 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgFQG13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 02:27:29 -0400
IronPort-SDR: yjhJcLeVAbbITBIv9SMbJH8MMMfUpdyi9F5y9z3OWD043pjlG5taCQ0HGapbIdv9amjgirDy3K
 FsSpjr/CaYkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 23:27:29 -0700
IronPort-SDR: XE9NAGzZ8JQAlku/+wioO38caPeKCDHPw27B0UmFkyWp8gYZPa2C4PDFg6dy0d4gjRbC7YVhKi
 QJKLq7nCqlVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,521,1583222400"; 
   d="scan'208";a="299181901"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jun 2020 23:27:28 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jun 2020 23:27:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 16 Jun 2020 23:27:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3LXhi7xlUfFV9xzB/m5hNJKSy7Gkjgd5oNXSVeqHWrR9MXFsICZmkin4ZdyKu+9df3a69ybOSSCZBSOvWqGTJbQRMLVnIK/AQkIk1dpDPO9aku5HvsU5TkYEKABx1097wJv94Al4OMDL+SRt5VgLfm3IKXtVg4IQdY5eu6AYyrSNrENMY3HDidgerI20Wlo+tj6MZXs3FxW56bdV1yPlyhdTVaQ+SwCzKH7Hfx4kNnpKaUXZNgGNJAmMAGFaXrP1obtUoUtT2i6dIuBYfNjsSqcau2Hmv719QofplSf+PkP7pXOJQJ4LPRfjLp4K3G+5HK4HD8wRhPc44xsEvjqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0JiwUCQVTepmUn2KexbyYEuiuD8MO2aiBdztGTzhEg=;
 b=UKZa9LJ9edB7JE8WvUhSCRVsxp2qgntIIpI8FxQjjLkpJKtLUxr6F61eOnaQLSWKIHoEUkFhJmKgFVxv97nnrvNM+j0wqhFHUmUWO6CrwpPCeXrYCwgI1NjAg0f4ZMxUlGK29BCDVlQMELF/XahcjDXdvozedNmX/w0E7NFzxNBYgR1sOybVBgB+d7sQl4uGpydlDJ9KParAUL1v51538LurHCj6M24qSPQ4nDsNC3oEzp6FnUi/8QHTVMMMFOJCPkrcsQrr7wXpixAomcNVs+Kjlw4dzLcVZWD3DTB/9M3C2v0bJMSgwxICsYIpoY87lc+zaWNpVjnNMBIBCYkOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0JiwUCQVTepmUn2KexbyYEuiuD8MO2aiBdztGTzhEg=;
 b=sGetO+NtU2Sjana8Y0n+2khPl/gH7BGK2RXGdDXsbr8LRqj/p78+m3OquD/tAPVRSrrg6Z191dfop636o1vA0c9oViTsKOEFb/2lQG4HgV54+zOj72EB3GlzE66+d9mSEQSgdgwv8lbmLkWXMRhtwcRkaX3Heoz5XKh0S7yjbUc=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.23; Wed, 17 Jun 2020 06:27:27 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 06:27:27 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v2 14/15] vfio: Document dual stage control
Thread-Topic: [PATCH v2 14/15] vfio: Document dual stage control
Thread-Index: AQHWP+klJ2WDrhzcJUGl5z7dUgTydqjZcnYAgALkw9A=
Date:   Wed, 17 Jun 2020 06:27:27 +0000
Message-ID: <DM5PR11MB1435C484283BDCD75F19EDB5C39A0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <1591877734-66527-15-git-send-email-yi.l.liu@intel.com>
 <20200615094128.GB1491454@stefanha-x1.localdomain>
In-Reply-To: <20200615094128.GB1491454@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f14b7d07-9df1-4e1d-343a-08d812878191
x-ms-traffictypediagnostic: DM6PR11MB3420:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3420AABEFCD6ADF2E0561318C39A0@DM6PR11MB3420.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1cMbFOsHoIRCLhhuq86iq2ZXyC/2jdhbGSA4EZpYg9YqZglN7gcierquuN5MZ0pTxXiP/WcP3I85gFe2K7JKZXqTODLl9JFl1mb67Y8eEOeri1t75MX7qJD02RVbZYGu45INWH0A3Ot1qLFDMgf4X76RSpO0I7MI+mv2FZPlr/URZvwubfR2rR4zgkQG9BfyUIcTHB/We2Kvhh6R3cCd2HHgEowzMkgrvLJWhd6y3bRBclXSOhtrsMoETAmmgTULjUbE6QQS8FOWT+cMv1g9l8KgX9UVqv9+Tix/PeDB4UbuxI1T8A7R447EJzUIHQjrherBTlxX9nByVsgvf6pCdvBLq7MSfzLPMoaB6hgJDXDEmH5N2gYDFCw6+YIeIoSg7HQF2t4I3hSSerZIZwbuqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(86362001)(4326008)(966005)(55016002)(52536014)(33656002)(83380400001)(5660300002)(26005)(2906002)(6916009)(9686003)(316002)(66556008)(66446008)(64756008)(66476007)(76116006)(6506007)(8676002)(71200400001)(186003)(8936002)(7416002)(7696005)(54906003)(66946007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sESDsWao/X94nMQu9tHhm3dNnCqb2K+fCMOSo5V4ngUyhTaMpbIJTfnWHbWaFcfGlc9RNnFY6ktqIajxCnv6IYUiAfdwIZQ/AD9r2sO5aX7L18cpKhVCWD828EG+JBdYL7mPwk8qGTfqtWXx9K3H3/k67nIAN30p5dO8mC9IulMfnHejrvXdI5aiIWPKhMI0Pwkbgz7VvgcJPr54hKAVirQPRkBWD4LJv/kXiCjeC4Zbclfv6qKbxGCpoN968vEu8A894pYuPl5nttS9AR2bKzD2aAH95XCpxXJi9eqCHWjZEvY+QKCmAkdi3cZLppVvIm7B8MgvUh9J0JAOwgWyQySG7fwiGV+4giLysvl4bJvQ5MF6NL8lFfFf8+hLvsVHiyAs45booTYFWu1o4QTf9BAtgobT43Us3DC4cCRmlnVaHhwhWcyx5HcXED999QhsHV58I1KYTVjAfeskzuMLsyreHJ5eS8+1evytWujmRWArrwC99dBOvDjDKLdCJfP1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f14b7d07-9df1-4e1d-343a-08d812878191
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 06:27:27.5347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MS7jmkSQ+jI3FANen0CxfieoM+81rL9gnV02vzZ8SCkmqIAKgtujI24/MS2kCB9PYqwb9oAdPE35lLfObR7LKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3420
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 15, 2020 5:41 PM
> On Thu, Jun 11, 2020 at 05:15:33AM -0700, Liu Yi L wrote:
>
> > From: Eric Auger <eric.auger@redhat.com>
> >
> > The VFIO API was enhanced to support nested stage control: a bunch of
> > new iotcls and usage guideline.
> >
> > Let's document the process to follow to set up nested mode.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> > v1 -> v2:
> > *) new in v2, compared with Eric's original version, pasid table bind
> >    and fault reporting is removed as this series doesn't cover them.
> >    Original version from Eric.
> >    https://lkml.org/lkml/2020/3/20/700
> >
> >  Documentation/driver-api/vfio.rst | 64
> > +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 64 insertions(+)
> >
> > diff --git a/Documentation/driver-api/vfio.rst
> > b/Documentation/driver-api/vfio.rst
> > index f1a4d3c..06224bd 100644
> > --- a/Documentation/driver-api/vfio.rst
> > +++ b/Documentation/driver-api/vfio.rst
> > @@ -239,6 +239,70 @@ group and can access them as follows::
> >  	/* Gratuitous device reset and go... */
> >  	ioctl(device, VFIO_DEVICE_RESET);
> >
> > +IOMMU Dual Stage Control
> > +------------------------
> > +
> > +Some IOMMUs support 2 stages/levels of translation. Stage corresponds
> > +to the ARM terminology while level corresponds to Intel's VTD terminol=
ogy.
> > +In the following text we use either without distinction.
> > +
> > +This is useful when the guest is exposed with a virtual IOMMU and
> > +some devices are assigned to the guest through VFIO. Then the guest
> > +OS can use stage 1 (GIOVA -> GPA or GVA->GPA), while the hypervisor
> > +uses stage 2 for VM isolation (GPA -> HPA).
> > +
> > +Under dual stage translation, the guest gets ownership of the stage 1
> > +page tables and also owns stage 1 configuration structures. The
> > +hypervisor owns the root configuration structure (for security
> > +reason), including stage 2 configuration. This works as long
> > +configuration structures and page table
>=20
> s/as long configuration/as long as configuration/

got it.

>=20
> > +format are compatible between the virtual IOMMU and the physical IOMMU=
.
>=20
> s/format/formats/

I see.

> > +
> > +Assuming the HW supports it, this nested mode is selected by choosing
> > +the VFIO_TYPE1_NESTING_IOMMU type through:
> > +
> > +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> > +
> > +This forces the hypervisor to use the stage 2, leaving stage 1
> > +available for guest usage. The guest stage 1 format depends on IOMMU
> > +vendor, and it is the same with the nesting configuration method.
> > +User space should check the format and configuration method after
> > +setting nesting type by
> > +using:
> > +
> > +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> > +
> > +Details can be found in Documentation/userspace-api/iommu.rst. For
> > +Intel VT-d, each stage 1 page table is bound to host by:
> > +
> > +    nesting_op->flags =3D VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> > +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> > +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> > +
> > +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GP=
A.
> > +GVA->GPA page tables are available when PASID (Process Address Space
> > +GVA->ID)
> > +is exposed to guest. e.g. guest with PASID-capable devices assigned.
> > +For such page table binding, the bind_data should include PASID info,
> > +which is allocated by guest itself or by host. This depends on
> > +hardware vendor e.g. Intel VT-d requires to allocate PASID from host.
> > +This requirement is available by VFIO_IOMMU_GET_INFO. User space
> > +could allocate PASID from host by:
> > +
> > +    req.flags =3D VFIO_IOMMU_ALLOC_PASID;
> > +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
>=20
> It is not clear how the userspace application determines whether PASIDs m=
ust be
> allocated from the host via VFIO_IOMMU_PASID_REQUEST or if the guest itse=
lf can
> allocate PASIDs. The text mentions VFIO_IOMMU_GET_INFO but what exactly
> should the userspace application check?

For VT-d, spec 3.0 introduced Virtual Cmd interface for PASID allocation,
guest request PASID from host if it detects the interface. Application
should check the IOMMU_NESTING_FEAT_SYSWIDE_PASID setting in the below
info reported by VFIO_IOMMU_GET_INFO. And virtual VT-d should not report
SVA related capabilities to guest if  SYSWIDE_PASID is not supported by
kernel.

+struct iommu_nesting_info {
+	__u32	size;
+	__u32	format;
+	__u32	features;
+#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
+	__u32	flags;
+	__u8	data[];
+};
https://lore.kernel.org/linux-iommu/1591877734-66527-3-git-send-email-yi.l.=
liu@intel.com/

Regards,
Yi Liu
