Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0302923C2
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgJSIjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 04:39:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:53094 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgJSIjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 04:39:11 -0400
IronPort-SDR: k5gnsY/nU4yvjupMp78P5Gp0OQL5oSJ8aGL+WCUtImH7gK0pk2zWvEslcwvWLwuyNVl7VKqEUb
 y87ydukzy+fQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9778"; a="154782290"
X-IronPort-AV: E=Sophos;i="5.77,394,1596524400"; 
   d="scan'208";a="154782290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 01:39:08 -0700
IronPort-SDR: SsBi3BWk3Ipj4qUs3doUykY9IZajErQk63kzu3twvpUcVujzbzCxjfFHMeNzBg6S41DwAqJTuM
 Da6ntlXQYM8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,394,1596524400"; 
   d="scan'208";a="532541641"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2020 01:39:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 01:39:09 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 01:39:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Oct 2020 01:39:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 19 Oct 2020 01:39:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck/RBE1pjbICfVkZ99gJ6/9BDRDwPk9S1LnjZ/X1zGAVMcjBjR0E5Cjbj4l1hKqQGrE5f78o+mFQHEFlGeHY0zWqLaAkd920PjH008rNdMlCN78ImBYk3FiGCUPRGg3Z2Ht0Qsoce+5+OQHcGAqCILzxzuF+X3CPgZgNVYzay3SB6gFnvnxYtx5Hoe47Mut97Jaoczsb7pEQ6a5TZZWY3FCaIP7OR0GFmqRksaFI6TOWFl3Y36g34vpuy4EXWSgpt+FjbZfZ9IvbwNV0zDXxaAKbrqSKpICbbfWgROCuVeoAOik4DBt4ajd/Z3ZMj7KCIO2jnMERjrPCUjUEnhjQbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmSAepqYF/pPC5gZiNd9Ffs4Br7w51RWwDow8eWxobk=;
 b=DAhckdsO1FN3o3pyj+OGCHaXwSIqTPk/sOF87VqV8eQSNaF8EPTeVD9F2mr6LgSIEPh53g4wpAR+agxPFadgITm9HN4eeF/L3t51k8JZnLR1QR6WOePkpv7ENDMPJ05FJTRXwWFimhOuJ1q7xlmokw8aEWAWttZPB9UXlqnFDyv5PQFCd5rD0m46UpmtiG/MSdtv8U2No9PzlKCKu6f7CoI6l7KG8uHP6DG0wZlbKBO2C+H5urd/ySy7hqwSJDxalNdefGvVpnGBYWVpsxbDfJnvitEU0bN9yHdFxtC5ZCCxQgCYa2UdEaGrTEsSLAPaPArWPSOhPmvytMPgMcmbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmSAepqYF/pPC5gZiNd9Ffs4Br7w51RWwDow8eWxobk=;
 b=mMHcyOVZlF4+At5GF5Lxa6UWbakjmGaAa+8BKFh0yD1QQ6884F36VGUb4yE39Wq36R8ysVE0wbQNMzNjySEAOWDQvCbWrlmb3wpEV68zEIOwdTQSDxHlrab9vFBhnST8miTguN3AYHl8P4zi6uFZN2fTnTQKVNN5rNkEXAPkoJw=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB2857.namprd11.prod.outlook.com (2603:10b6:5:cb::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.23; Mon, 19 Oct 2020 08:39:04 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::a1ec:ba6b:5057:be2f%11]) with mapi id 15.20.3477.028; Mon, 19 Oct
 2020 08:39:04 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Wang <jasowang@redhat.com>,
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
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUABZWmqgAH60bgAAh22vsA==
Date:   Mon, 19 Oct 2020 08:39:03 +0000
Message-ID: <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
In-Reply-To: <20201016153632.GM6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [221.220.190.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8791266a-f74b-45aa-36f9-08d8740a6f6d
x-ms-traffictypediagnostic: DM6PR11MB2857:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB28578DFF31CF4434B2D021ABC31E0@DM6PR11MB2857.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: glSu/bh0k3Nvbgk8GNyxKvPCWgtq8TEdsBXANlRLuqUYGKh0BdtFK0MbYXub1Fuu+ek28r/Xz/4ujqHXPtX7HDI4jopTmshhaY84yYO/pqAuRfStNPc+XY3OF/cjZ4MCxM75AO5WyPPUrcgEzNHz06RggtJkIXuKDLnVut5IBPX1+XJyvDmaByQfuJPoyDooLdlXsjnn7RlhNT31UCfHQO4022Lui5LR6PNSJhiqCAwwWjrefQb/cCdNPAaVya9FOnW3GDIJ7KzqshfNCJ88FN3hr5hfF9KcPUAQMMowR1F4ejH9eQbVV2pWNW74nDu0qqLv78XWj9JddK3eQhlqWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(64756008)(66556008)(110136005)(66446008)(76116006)(54906003)(55016002)(66946007)(7416002)(316002)(66476007)(2906002)(83380400001)(86362001)(5660300002)(52536014)(71200400001)(8676002)(478600001)(4326008)(6636002)(7696005)(186003)(9686003)(33656002)(6506007)(8936002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Q1a/jVnmdE9L0gQ32ell9nkuP5N1++oQGnFKhD1XuNlT618HEm/JlnjObBgk+NIEEwGYShZ1e7Itjnl9GgZo+LdSlqUa7xCXgoYPWyVAxxV6dddZQ/tJnV9lVIOSgQjIofcbxEGLZGkblUVqG9y/Sd9eJs9tpbJob47lFTmtLfvXHekibPUFQQu9VHwuSB7Fj2oEVI2tfPGHJnMkTcuqczDeV0kBhXWgt3oBrvjTWYjOsLqkL30AdA5O83XlQxvOSTnJIRjHENcllk7ccHT17yeGssb5PUpr6LZytMabKuTOwjOjj5jsqWZ6yTbsi5v7DVfYCDW3r0LNsTuhv8/DwA+cRUgDvLDTwb1BCBjApWD+pijhFgwdpraT5Pe7du5xOl3V1OhNCDaj0qdIRdyMTu/noKkpxv2bn82A41+/EOPxWHuj7aRRu8zYlgJNayOLikiVE8SCfLkgQlykj7u1Z6bRG1YCPs14v6zYLMc+sZEUfKR/4O2Kj/uftyzFzteX8jZkVr6oyhnfMwfKQ6ybFfnqoygqHjmtVXJeUSAs+hvjM75DVoa9sp0opDUUM98TdmzeAFtZ/aK0MMlJeHjDOVPx6UY3/xqau6y+Vz+uyi4CGPcWhMGBsmnTyiLS7GZtFvbwpX5ZmJTw40UcKGcO6A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8791266a-f74b-45aa-36f9-08d8740a6f6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 08:39:03.8609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCftJPlY7Xz90ZdFnCY9RtDKsfufoGx7z8B8LctJWSY0P/uHBysSaDGTdISO4AtWdhE6VBWi7NbNc+VseulxOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2857
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

Good to see your response.

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 16, 2020 11:37 PM
>=20
> On Wed, Oct 14, 2020 at 03:16:22AM +0000, Tian, Kevin wrote:
> > Hi, Alex and Jason (G),
> >
> > How about your opinion for this new proposal? For now looks both
> > Jason (W) and Jean are OK with this direction and more discussions
> > are possibly required for the new /dev/ioasid interface. Internally
> > we're doing a quick prototype to see any unforeseen issue with this
> > separation.
>=20
> Assuming VDPA and VFIO will be the only two users so duplicating
> everything only twice sounds pretty restricting to me.
>=20
> > > Second, IOMMU nested translation is a per IOMMU domain
> > > capability. Since IOMMU domains are managed by VFIO/VDPA
> > >  (alloc/free domain, attach/detach device, set/get domain attribute,
> > > etc.), reporting/enabling the nesting capability is an natural
> > > extension to the domain uAPI of existing passthrough frameworks.
> > > Actually, VFIO already includes a nesting enable interface even
> > > before this series. So it doesn't make sense to generalize this uAPI
> > > out.
>=20
> The subsystem that obtains an IOMMU domain for a device would have to
> register it with an open FD of the '/dev/sva'. That is the connection
> between the two subsystems. It would be some simple kernel internal
> stuff:
>=20
>   sva =3D get_sva_from_file(fd);

Is this fd provided by userspace? I suppose the /dev/sva has a set of uAPIs
which will finally program page table to host iommu driver. As far as I kno=
w,
it's weird for VFIO user. Why should VFIO user connect to a /dev/sva fd aft=
er
it sets a proper iommu type to the opened container. VFIO container already
stands for an iommu context with which userspace could program page mapping
to host iommu.

>   sva_register_device_to_pasid(sva, pasid, pci_device, iommu_domain);

So this is supposed to be called by VFIO/VDPA to register the info to /dev/=
sva.
right? And in dev/sva, it will also maintain the device/iommu_domain and pa=
sid
info? will it be duplicated with VFIO/VDPA?

> Not sure why this is a roadblock?
>=20
> How would this be any different from having some kernel libsva that
> VDPA and VFIO would both rely on?
>=20
> You don't plan to just open code all this stuff in VFIO, do you?
>=20
> > > Then the tricky part comes with the remaining operations (3/4/5),
> > > which are all backed by iommu_ops thus effective only within an
> > > IOMMU domain. To generalize them, the first thing is to find a way
> > > to associate the sva_FD (opened through generic /dev/sva) with an
> > > IOMMU domain that is created by VFIO/VDPA. The second thing is
> > > to replicate {domain<->device/subdevice} association in /dev/sva
> > > path because some operations (e.g. page fault) is triggered/handled
> > > per device/subdevice. Therefore, /dev/sva must provide both per-
> > > domain and per-device uAPIs similar to what VFIO/VDPA already
> > > does.
>=20
> Yes, the point here was to move the general APIs out of VFIO and into
> a sharable location. So, of course one would expect some duplication
> during the transition period.
>=20
> > > Moreover, mapping page fault to subdevice requires pre-
> > > registering subdevice fault data to IOMMU layer when binding
> > > guest page table, while such fault data can be only retrieved from
> > > parent driver through VFIO/VDPA.
>=20
> Not sure what this means, page fault should be tied to the PASID, any
> hookup needed for that should be done in-kernel when the device is
> connected to the PASID.

you may refer to chapter 7.4.1.1 of VT-d spec. Page request is reported to
software together with the requestor id of the device. For the page request
injects to guest, it should have the device info.

Regards,
Yi Liu

>=20
> > > space but they may be organized in multiple IOMMU domains based
> > > on their bus type. How (should we let) the userspace know the
> > > domain information and open an sva_FD for each domain is the main
> > > problem here.
>=20
> Why is one sva_FD per iommu domain required? The HW can attach the
> same PASID to multiple iommu domains, right?
>=20
> > > In the end we just realized that doing such generalization doesn't
> > > really lead to a clear design and instead requires tight coordination
> > > between /dev/sva and VFIO/VDPA for almost every new uAPI
> > > (especially about synchronization when the domain/device
> > > association is changed or when the device/subdevice is being reset/
> > > drained). Finally it may become a usability burden to the userspace
> > > on proper use of the two interfaces on the assigned device.
>=20
> If you have a list of things that needs to be done to attach a PCI
> device to a PASID then of course they should be tidy kernel APIs
> already, and not just hard wired into VFIO.
>=20
> The worst outcome would be to have VDPA and VFIO have to different
> ways to do all of this with a different set of bugs. Bug fixes/new
> features in VFIO won't flow over to VDPA.
>=20
> Jason
