Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F4E3A74C7
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 05:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhFODP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 23:15:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:63354 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhFODPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 23:15:24 -0400
IronPort-SDR: CD7pDBvxFB4qKPWQ2h9rrv3+nEuYl/JLuhN1FAHOAjjtbuShLUUgw7EyAZGH8yiLCE0jRezrlD
 C2TL7p60immQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205723838"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205723838"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:21:39 -0700
IronPort-SDR: fzThmB/vHEAEuaCpZsmTNArn/P7Oc1usNQsBWcizvHaN9fclJhAXrqNSuUE3YnDHR0tVdB5R0w
 Fmza1Yua1Feg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="404058976"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2021 18:21:39 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 18:21:38 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 18:21:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 14 Jun 2021 18:21:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 14 Jun 2021 18:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc/xJltCYMESrrAuIFta3OsRQtDEhEql16fanbi59XcqknzRm6luiCdHhWE1rvjPLblM8aW1j5RLL8rHSH9zvc66iW/i1k2lqPRtkM3FACIXLiBDue+H8HoFSDwC+bu1E8wUuO4/i9wt02ZKB5u3fikFeh2tanFQu37KH7eMswxiV2mfebqkfJsYCjFlWxFqUu26TexMML/H46B6um5kUJqqZTf6opX8EAJnzvda9EjsImp5FQouRQJjDVDJWmpSJC+VmOWInC4xVMglsgAk3fN6E3YZ6bxScBdUo6nJW3zpaOYws9Ohici5NiPTZDqCjkC0VwlAIdYkdvzSXJSVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRjCvwYBxTW7/UbPkFrYjvIQrWsxedbS2/ImGO/YZyM=;
 b=RMmzQcBGVCAikFsGT1VUkVLD37NZ1hmFrPzeiZNYWel+mS0eSJ+XjgSgubCyMWAcEwV8DWQPauDXpbWtWKAGffBHXBIFBE+d/2TDARI8gRWYXSKQ9K/gl4IYup2nkojuILZdjFYJ3L7x1/8Q0y/LrqvRFmfkJhWIDnngmBB/MAmkBKeXF4VkNPoKC6pEveWOHGgVenswW/LLrRC5vdKnzuvEvFFSOIWLn/iE78goDzwn5TQlnJ5DCadvstmAnNK0VZLCKPJBV9eqKPnQijrZzS6uDAj1A7r4eaRBWhsWoZy6FeI5qjnbXTzNKUJaGUB4mS0JaXCIzULRTb4uqTvQFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRjCvwYBxTW7/UbPkFrYjvIQrWsxedbS2/ImGO/YZyM=;
 b=Vb3D3/bjceEdUexvh0kSqxzajJk7SC6XpZEcylcdnzcr7zOckiBAcBYTKbY6SQo0ELBRO9tlxb+QCxMiOl2yrsQMz6nqCeNW46kMKvuCpfpiTJa6lsYZCGFd1FkWMR5U2uuamIM9hTKnI3hb20hTNIctN6HZ5RvkqeUC+JclHyw=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2080.namprd11.prod.outlook.com (2603:10b6:301:56::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Tue, 15 Jun
 2021 01:21:36 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 01:21:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAAR+AnQACzmaQAAbNgBMAAZP6eAABgIaTA=
Date:   Tue, 15 Jun 2021 01:21:35 +0000
Message-ID: <MWHPR11MB1886A6B3AC4AD249405E5B178C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com> <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
 <20210611153850.7c402f0b.alex.williamson@redhat.com>
 <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210614133819.GH1002214@nvidia.com>
In-Reply-To: <20210614133819.GH1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09a332c7-5b4e-4edf-13a2-08d92f9beb13
x-ms-traffictypediagnostic: MWHPR1101MB2080:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2080494E4EC7F089F9D5963D8C309@MWHPR1101MB2080.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ziKQ0t9KrPJVBdY2A2SdJ4iqzhKnpTXqChnFN39rHOBivfJ4cpD6INYE0kHwJj0JLbdcAahgZv13DCUytUy/R/oReMDrsrZ3zNqxsZGhxVqN0WT3VdYd2zoTzgfwOd2IHDnUHc6V8/5CorSLujSN2Ob64DkN+UTCaYDa42PTFIxLTh7j8RPLqKjv+awg3ws/Uclqaq4j5Smn5iF2m0k5Nf8VCVoB+1ZUz+0+rViQCGvzRqdA3n+hedbuMMOKoLYmRU9+VyBL9YTBgpOiq8YbuOCK9rkBwvUeuTRfERlY0NY0blTDIZW/Jx315wcO0tF1N+1qCYJF1g/0yseJdjkCRYYAOXulFmTRlbVSY65Ezb3aP/qQJ4r7LNEqBOYITiNwlg6kMkoG95sbFL1E2WJQoxArJnlDXI52pKyQgl7+rqGuVmjhalZzuiyQv/DLhCTrC+73Q2mwMJmPWlXURLQBA1c2qCWmrG2OTSNHxioO7jFh2PM2jV7zumDlJ3xPPH8zWVjYGDKxSEPrP4Ci+jOHWUblOSAb/st58ezJ2XN5x0tVg5nLjCB8HIk0pKDfo0DHiPjPvuTA3nxZSjZKIyvm0S5Uz4wR+QB/Nw2Wrbxz37s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(366004)(396003)(122000001)(8936002)(66556008)(64756008)(4326008)(38100700002)(2906002)(6506007)(71200400001)(52536014)(6916009)(66476007)(33656002)(8676002)(7416002)(26005)(186003)(7696005)(478600001)(316002)(54906003)(66446008)(83380400001)(5660300002)(86362001)(55016002)(9686003)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3vI2bWGBDf05cC9gLfMPWPA5VR/FcOZo+8E7JnTJfCMRvxwDCXV1KUcIFobi?=
 =?us-ascii?Q?vZsiTleoIIVnHm03j7Lsz2ltHDkXK3ShFweGDLy9jB14XFURtNpWLGPvlMZq?=
 =?us-ascii?Q?1LrrenNTFuNiSiyE63MMQRd10iGgMx947dgFZdSZxrcI13UrR6MnReGg+dT7?=
 =?us-ascii?Q?bb2CYIjmxz/1IeBVMjbJiwyjNi+iNraPHPhzineakCkITyUVmjmGLgDEDGN5?=
 =?us-ascii?Q?TAnDEnRejjEmlL9j6LJlaHm9I4Ecb9H1gphg5JBQvCZ2mck6wuWujjJnrm0z?=
 =?us-ascii?Q?FMhJ2li0Qqg17Xj5woBg/dIoELMKGY81q8Kd+voqvC/7bBhhBD509RMlK5Zv?=
 =?us-ascii?Q?QJljP/BjHjutel1rbnQ07oi7ArpgnEuknbfPg0FGkFQjVi94F+jzPtiTZ4Xh?=
 =?us-ascii?Q?veLpnCNkq9xMlTha27sUJAbPh0YKBJx/0sc07wRU6MURgzJPBo5sJv4kdJGE?=
 =?us-ascii?Q?sNyZtlaVYYv1lI3oqD3Taq8IBg2Xoaij8w7Sckv5fBYTIq99HTspu2XLhN64?=
 =?us-ascii?Q?b65PHJTpLNZ5QWEmZVHbFMnmBT2AGichoSP+AsjPoJyN3VErJMhtbp2Unitm?=
 =?us-ascii?Q?jTnzprd37UQqwehxZW36udHetnpoH7gpPuLKkYmeYx7csktVK1A2hRX1vLzq?=
 =?us-ascii?Q?FLg0VreUKagYc6+qnaL76Rr9Xkzf+hd5ZL7+P1Q4eiOcBIB85ZUoEXXmNwGq?=
 =?us-ascii?Q?LmiMKSvdOgOdb47SNkaP1bPR+gIrEeQjv8wCzvIeZdCgCGd/eRYoCQWjmoi0?=
 =?us-ascii?Q?tm3XX9L1p1qWWXBAPV94naapX/2Uzg8rZEzyX0EeTV1ChucKRwa9DIUZEIbu?=
 =?us-ascii?Q?cTQ9tOJrDhKlZtK/Mkm5YYFLGZImPEATyyD7sS06ipVZC6e9jh4Oa3peb91k?=
 =?us-ascii?Q?Z/4dJKMJRKs7XWavVS/zeYXq0/9z0uewGneZYzLCxq5Lk/p9W4VysGI7ZA6E?=
 =?us-ascii?Q?b7zgFp6i+MKW1upRTF/QDK5QakLqnOe5sMwZURjcHtr6hMlhD9SCtiW0g4VL?=
 =?us-ascii?Q?xnnzKoRVNXZquCSeB1MUeIMUIGTbryQqV9BFGxWyFJYoyTOESj5pirCRqI7Z?=
 =?us-ascii?Q?MgO7/9KpnpNnQ0xVPkj2AMNpeApfQ4YAOkl4qnhG+wBCZ3osj2a7BIJciit4?=
 =?us-ascii?Q?S1DdelTb2Hh1Qinr+joAWHsUukrLQ4hQbI0dcN6ODf6pf5mPejdLpiJ8TR8g?=
 =?us-ascii?Q?Q/vJa1D9HzC+vpX7cWLqMIX6GDn466ylXjAaSxBDCkxqfsSeYOeBLNiKIEzd?=
 =?us-ascii?Q?FyT86dfsdnIY5hBwPz5ZsJAed32LNmTIR5aKQ8LpEVYfut0o6xdY1PdzAvA2?=
 =?us-ascii?Q?KBuLxkm7R40rljAZ+0tr9gVV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a332c7-5b4e-4edf-13a2-08d92f9beb13
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 01:21:35.7569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRRMhtS7QAT35wrm98+JVULGPMuY/tu5hSljtAQ0IGP7lJr+nT6wNBeIP+ZVum5RRFjtzmr+r0xKVbHAuW3cuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2080
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 14, 2021 9:38 PM
>=20
> On Mon, Jun 14, 2021 at 03:09:31AM +0000, Tian, Kevin wrote:
>=20
> > If a device can be always blocked from accessing memory in the IOMMU
> > before it's bound to a driver or more specifically before the driver
> > moves it to a new security context, then there is no need for VFIO
> > to track whether IOASIDfd has taken over ownership of the DMA
> > context for all devices within a group.
>=20
> I've been assuming we'd do something like this, where when a device is
> first turned into a VFIO it tells the IOMMU layer that this device
> should be DMA blocked unless an IOASID is attached to
> it. Disconnecting an IOASID returns it to blocked.

Or just make sure a device is in block-DMA when it's unbound from a
driver or a security context. Then no need to explicitly tell IOMMU layer=20
to do so when it's bound to a new driver.

Currently the default domain type applies even when a device is not
bound. This implies that if iommu=3Dpassthrough a device is always=20
allowed to access arbitrary system memory with or without a driver.
I feel the current domain type (identity, dma, unmanged) should apply
only when a driver is loaded...

>=20
> > If this works I didn't see the need for vfio to keep the sequence.
> > VFIO still keeps group fd to claim ownership of all devices in a
> > group.
>=20
> As Alex says you still have to deal with the problem that device A in
> a group can gain control of device B in the same group.

There is no isolation in the group then how could vfio prevent device
A from gaining control of device B? for example when both are attached
to the same GPA address space with device MMIO bar included, devA
can do p2p to devB. It's all user's policy how to deal with devices within
the group.=20

>=20
> This means device A and B can not be used from to two different
> security contexts.

It depends on how the security context is defined. From iommu layer
p.o.v, an IOASID is a security context which isolates a device from
the rest of the system (but not the sibling in the same group). As you
suggested earlier, it's completely sane if an user wants to attach
devices in a group to different IOASIDs. Here I just talk about this fact.

>=20
> If the /dev/iommu FD is the security context then the tracking is
> needed there.
>=20

As I replied to Alex, my point is that VFIO doesn't need to know the
attaching status of each device in a group before it can allow user to
access a device. As long as a device in a group either in block DMA
or switch to a new address space created via /dev/iommu FD, there's
no problem to allow user accessing it. User cannot do harm to the
world outside of the group. User knows there is no isolation within
the group. that is it.

Thanks
Kevin
