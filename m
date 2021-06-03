Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC2439985F
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 05:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCDFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 23:05:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:8855 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhFCDFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 23:05:42 -0400
IronPort-SDR: eWRhQzTZh2/4KbufM4h4h6JdZs7yiALICg4uu9eHvvwLePR5hUxxLcxTMmgWlWt6japkGrBIiq
 /Dt9bzMbOSlg==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="184322263"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="184322263"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 20:02:11 -0700
IronPort-SDR: gZpWgS8cqtHosbdq12Ii7OTYCoqlbOW+nkfBuL8BX8bQ2eWfhYmEo1VF0A9bSczsv96ulbu1DZ
 VlhDULPEui3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="479989623"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 02 Jun 2021 20:02:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 20:02:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 20:02:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 20:02:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQOJYQYroEvLMt9cRw4rzaLMH0kRraA+p9BkgAxFEOIicLp8Lg/+qPXuwxrXwFByHulO4AIb20RfC6vnmqIsOkp6VgAGvq4djFhmUyscnzdsKLVE+E0K1pwPe/8eIT4FdI4/D9xhfPIC1xqFHyNyh8hRdsaNtlLdQBzbg5logeNvv0Iy6bcwTOtXjiplEGO1bCgJT8zIF4pxolEV2yxljopRCSm+iw5/Luq7PzJFbdmc9At2t5XaeZZS24H8DVimajGth275IkAp1/5EhKyPcMCck0gs3XqPkX1X3EOnZ/HlIBr2u4GWykizY4KPY4cfS5z48C4hcYnWPJOX2gec8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moxj2sRdG7GOoYHIThIOGijquZOQbadeY2DJ5JjmmRI=;
 b=btEbyaVgR1PxCCScML1osY6cZXiuve9OzJ8lC3yziOMS9bjz8XY18OXXMZ9qGgbT+d1TJRF95/D2wMjTCCu1jAasYlNtuDJJvj3AI8IBLivX5fwxz4mXII18cI2fSvwqyn25N7esY6H83UsjZBdJf6HFmr7y2XfKaPcrst4Piq4WUmLgVgrmCur/H+RIOqkMmvRLs7XDf5w2nZLhHEKG2tKvIWiumEs/eZe7w8iUq0IAyWLGcnRtRqeLa4dXjUAg3MSYrcvyMcsH+dkx9EXQsuk5YGJdQ6oVnk93X5DiRNUK9EVFj+bM8/Gx6izv88cuDIMGGIUFTYYEXdgWGQC8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moxj2sRdG7GOoYHIThIOGijquZOQbadeY2DJ5JjmmRI=;
 b=J8oenfg3ewU5A18QrZnqKfwEQvjbI5/ytMx02iVUA82q0CVwL83ceQzyWuKpr0Dpg9WNtz8b3/LQk8uUrUWQgAuOrgUdQenrvLO2Lhz6JzTANxD8qM024iSp+N3z7nZdu1WHrHIz9XY7ikNI6QXcEYthhgacX5wBlRxWc5vpM0E=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4521.namprd11.prod.outlook.com (2603:10b6:303:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 03:02:06 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 03:02:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwEqZK+AABc0DAAAFBnbgA==
Date:   Thu, 3 Jun 2021 03:02:05 +0000
Message-ID: <MWHPR11MB18862A625FD6BED5ABE2D21E8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko> <20210602171930.GB1002214@nvidia.com>
In-Reply-To: <20210602171930.GB1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42661e75-c7d3-4c1d-e8e6-08d9263bf85b
x-ms-traffictypediagnostic: MW3PR11MB4521:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB45211B29BD623AEBA660061D8C3C9@MW3PR11MB4521.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WTr4mIzYHyHVjLkPUpo1AeiiC+zLqBF8lYBmrd+3LxDDWCDOJFf84f74ytMCJXDJvo4XUKjXLiulnpkAvCx4avTTDacyD3r4stfZIvRBjLUtmUGNwHvE0/a4+xq8W2Jy8cZ+obZsoVRxyuEqbuwc1I1XB25+EAdnYJ0oAJncC57AUVTQWWF/jJeth8GW8sTxVX0egd4WPjCJu12xVf7o+8CpwsjHFTM0Y4IUxbpolhUSvm5S1x53ITiutiaz7cMi8jcoHtfRjam2cFk0AXNYOtMqBw2M5AkfCMicsxHCS74mDyMpqb0Zie4WxGLHAI9gGMhFGJyg7FTHHf/BNiQBSfq2kUx0Qxfawpoxxpjjt5fzssOmj4HEIo5wbSi4UjEcbntHjxZnxC7zKRj8/McoWeVgFTGgamEOFJH0g+ZqDmqNm3yRiWZC1Y7HlrFUc10IJJH1nkTLkdYJNET92nonXzce+0Pz+OKSf3MKuwkDNvQ/0iBdJK+nRsN4WASBpF1qhSIsbjXzuZTRMTDG5IXq0zkrekBNJ2/4aY2wcYB6LhZp1vzdOg0mYJo0XKj/R/WeeabdtHGdj/WJxdgVP7RQEr6wWcKZvElRG/TUNOK2aic=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(346002)(366004)(4326008)(54906003)(9686003)(83380400001)(2906002)(71200400001)(8676002)(55016002)(38100700002)(110136005)(26005)(7416002)(122000001)(33656002)(5660300002)(76116006)(66946007)(86362001)(186003)(66556008)(66476007)(316002)(66446008)(64756008)(7696005)(6506007)(52536014)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/mS0boCdgUOmVzF1W3DSNlfdlyoDNM9GcT7kh/qCCzlNKMSNhBX0AHowcFa+?=
 =?us-ascii?Q?foxDY7yC7q3ZdHF7D2kIU2Bdbppm7fjkvENGgdnsZd+feeWLXqZ/N4tdXgg8?=
 =?us-ascii?Q?Ml/WjvR7Cld7sBbFsG8LZ9H+ugoF2WsV1Dhwl/lP5afC9chR3GUYmFIOY2s/?=
 =?us-ascii?Q?cAj2lYZeBN3GFHhk+ArLsZ+oWkmtuYm9Y+9/EoZBjY941aXGEU8lMr8LnwrH?=
 =?us-ascii?Q?Z6DSywlYmwbWOkf/N3Imuzb8U7byNWsiRn6aDPN5AqGJFk1OoqXg/aV9Kn5W?=
 =?us-ascii?Q?HJw1YmVHxb+u8BPwEQffVizfpWuF0iffxbNd4MwmgmnKEcKD8eVwrpog6Yy2?=
 =?us-ascii?Q?5hG9q+I6kfwTtA5pxooF8Oyl+9rCJxjIsfNNv+bjdn6g6/1aIuFSMZEJNV24?=
 =?us-ascii?Q?BvMtgEbTh7Ah9LNUEIXTSW2KLuEOMvdYghiMXGsohzGEJOiVnTOAesbPtnTC?=
 =?us-ascii?Q?seog+TI9NugCXwpBfvGe28E2gGZyQWRIlC8QNbitFWXHStZ71hGRYjeKpIjl?=
 =?us-ascii?Q?Pv1PhQBzLY+GSjdvwjEHaVS/F3FvrwmZPOEwA5QhP9vsb+r/rqaORr3Z31C1?=
 =?us-ascii?Q?02c7NBxocGnJ0KMvBryh4fdaIwdKGG/Cwyidge2YT949yz/G/C21wMp6m/F+?=
 =?us-ascii?Q?3XF0n9/JOJu4BJnyV8KNEPir/VS9Cy6BbdzlHxawwgNZUnEnM7D6WcYZwaox?=
 =?us-ascii?Q?ZJLBUAXdbWMVxgLq6v6hBNv24ZopsRVoL8QCC/p4q0J92wy7l12Lq9OTC9Hb?=
 =?us-ascii?Q?CIkqQQjmx1KDwZePqdgEEi2kE38rwSvh5qVerU6JOpEbYL2nwNuAWvWbmWuP?=
 =?us-ascii?Q?tjoay9DKhG6nf19Ib/BMeJkWf1DZO52GK5Qpbe9N1V9SwJHl3QvnserIPi6e?=
 =?us-ascii?Q?0AFGh7WZx46jNXWrDbXQXmqGcEVZ5/boEvEKW09rBIfot25IA+03G3Na4gI7?=
 =?us-ascii?Q?z9MIcWzRGrArV9a+spB2M+qggf3Syi+Cy93aoRTX+4C4r8NxvmsKk0mmWPPU?=
 =?us-ascii?Q?X1MWkSKRX83xsnwWMOoxH4jMa7Btd/tF+y4PK5ginaSkDStqyeAqpbIKO9sy?=
 =?us-ascii?Q?FwipO/ofRoqbgCZFTqvjdicMTCJqlwf/R+bmS93S1Om0ICqjezu23UGGRm0A?=
 =?us-ascii?Q?EnSBkvq1XTNXA+3eELLywl4ti9AC/MT3yUCIOKMsOJNBUGLxBPhtXiovUdjS?=
 =?us-ascii?Q?3UjN2yUtzshTvZd6Jj0pfrVLnx/wmdXPuyiGNDkobBIk6NFXcguwtZbYWU7N?=
 =?us-ascii?Q?oEQdS9YIeUkP13ZexjkBL62dIBHv/5HXqavjwJXG3bOTAowbIKXdmpoL/PuH?=
 =?us-ascii?Q?oO8NEXqz7oMPdIzotcsbE5XF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42661e75-c7d3-4c1d-e8e6-08d9263bf85b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 03:02:05.9595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YwYGhevC/J09TtnLrZvZRTqTZBDm1DclkMxCeo2IC3tXP9bmdGNFrRerfEiFaFYiqZ98/AydflFUsVgfqBamg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4521
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 3, 2021 1:20 AM
>=20
[...]
> > I wonder if there's a way to model this using a nested AS rather than
> > requiring special operations.  e.g.
> >
> > 	'prereg' IOAS
> > 	|
> > 	\- 'rid' IOAS
> > 	   |
> > 	   \- 'pasid' IOAS (maybe)
> >
> > 'prereg' would have a kernel managed pagetable into which (for
> > example) qemu platform code would map all guest memory (using
> > IOASID_MAP_DMA).  qemu's vIOMMU driver would then mirror the guest's
> > IO mappings into the 'rid' IOAS in terms of GPA.
> >
> > This wouldn't quite work as is, because the 'prereg' IOAS would have
> > no devices.  But we could potentially have another call to mark an
> > IOAS as a purely "preregistration" or pure virtual IOAS.  Using that
> > would be an alternative to attaching devices.
>=20
> It is one option for sure, this is where I was thinking when we were
> talking in the other thread. I think the decision is best
> implementation driven as the datastructure to store the
> preregsitration data should be rather purpose built.

Yes. For now I prefer to managing prereg through a separate cmd
instead of special-casing it in the IOASID graph. Anyway this is sort
of a per-fd thing.

>=20
> > > /*
> > >   * Map/unmap process virtual addresses to I/O virtual addresses.
> > >   *
> > >   * Provide VFIO type1 equivalent semantics. Start with the same
> > >   * restriction e.g. the unmap size should match those used in the
> > >   * original mapping call.
> > >   *
> > >   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
> > >   * must be already in the preregistered list.
> > >   *
> > >   * Input parameters:
> > >   *	- u32 ioasid;
> > >   *	- refer to vfio_iommu_type1_dma_{un}map
> > >   *
> > >   * Return: 0 on success, -errno on failure.
> > >   */
> > > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)
> >
> > I'm assuming these would be expected to fail if a user managed
> > pagetable has been bound?
>=20
> Me too, or a SVA page table.
>=20
> This document would do well to have a list of imagined page table
> types and the set of operations that act on them. I think they are all
> pretty disjoint..
>=20
> Your presentation of 'kernel owns the table' vs 'userspace owns the
> table' is a useful clarification to call out too

sure, I incorporated this comment in last reply.

>=20
> > > 5. Use Cases and Flows
> > >
> > > Here assume VFIO will support a new model where every bound device
> > > is explicitly listed under /dev/vfio thus a device fd can be acquired=
 w/o
> > > going through legacy container/group interface. For illustration purp=
ose
> > > those devices are just called dev[1...N]:
> > >
> > > 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);
> >
> > Minor detail, but I'd suggest /dev/vfio/pci/DDDD:BB:SS.F for the
> > filenames for actual PCI functions.  Maybe /dev/vfio/mdev/something
> > for mdevs.  That leaves other subdirs of /dev/vfio free for future
> > non-PCI device types, and /dev/vfio itself for the legacy group
> > devices.
>=20
> There are a bunch of nice options here if we go this path

Yes, this part is only roughly visited to focus on /dev/iommu first. In lat=
er
versions it will be considered more seriously.

>=20
> > > 5.2. Multiple IOASIDs (no nesting)
> > > ++++++++++++++++++++++++++++
> > >
> > > Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> > > both devices are attached to gpa_ioasid.
> >
> > Doesn't really affect your example, but note that the PAPR IOMMU does
> > not have a passthrough mode, so devices will not initially be attached
> > to gpa_ioasid - they will be unusable for DMA until attached to a
> > gIOVA ioasid.

'initially' here is still user-requested action. For PAPR you should do
attach only when it's necessary.

Thanks
Kevin
