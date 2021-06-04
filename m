Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9E239B28D
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDG3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 02:29:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:18122 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhFDG3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 02:29:09 -0400
IronPort-SDR: JWQRYOoyJQvlP6yuJ7RisGjaRexoqj2MYZqXyYSQaAad1NCZZ3Y2gGREwh7z5F5ePiZMA2iSqW
 TuCR0TvUptSQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="204045170"
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="204045170"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 23:27:23 -0700
IronPort-SDR: HpViV7ik/XiakjeqxpPWU22Dy0qKoZmTIYwU5tAaM3emcvwwZDIRisnDPsn7U0U5r7/izUjpPk
 ApuaokJHpCZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="417658956"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 03 Jun 2021 23:27:23 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 23:27:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 23:27:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 23:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kz3xeAf2vzN5NISSpCd4wVRBPgFM5KhH16Wl2dLf+3hCG8728IZFE5WajBaSYbcrKN3BHE+CkQbWhZFYfParQ8v2r87zJJeLPaxYztSW6Ojd4O511DeaeK6bg7WGYJf6cC/UmAoj469LPpFS/cAdD2pC11o9fyPB84SsX+vWeBaPigwc2654G3+u5RrBtcTM7yvasSsGx3xOG3626RbNgqKjmrPe3SpW4GXfst1tI9o2GtTxJFwGFlGG0YaKSBKlkxQioN6DqDyELGLxp23Sacb0Z+/go2ueVWe1n0cUCO+TklgjLGB/PX8LTbVzJaC3rwexesUxoGHLCf4UbtZIxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lin0GO3ygdGux8d38cx9aQ/zIeCdrWM4ZbvGOOpwecQ=;
 b=dVRSrS9ErhafNwpbFEC5oZazHbndO2eZYt8fcglqqvhZHAj2mVTD0CcwTFttcLkD4cB7q+FRU9ILZtrdjsO35rxnwrDlUdDCZGw/+OxqxDcCfBTrZvqlhA2WDOHq/9YkL+ZmsZD0tEiPXno8LIiHL0prdezw4iowWDGpbdggNfdUrNO8zXXykPn/7ee1kucpndy096DMGJabFgzGucTVwhjha6r7VLRoVKnNTeepWWBbAvV/IxI3qxGzNyM8IR1VBtqTYuvLIccBvNBMbZ0lfcm8xVGFDF/sLdLkY3KZkG4MnXRlQ09/033O+Usf/1vhrqFJ55Y3UnAP/a0QrlOnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lin0GO3ygdGux8d38cx9aQ/zIeCdrWM4ZbvGOOpwecQ=;
 b=TMpree9odCIl+a5Sra5m/bXeOVfMzDV+P/4KtkdLG/kGHoihmbrTuEVsnHKRdiHISXs4l0D+bETIKTpVBCHWf7Q0cu5wPvNdzHfh6sT+9UGb3N57ojna4KjYGs/ereSyJsxjMgRSYsVqR8M4IB0GIssE2iGiwcV1dV2hOySgzXg=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1405.namprd11.prod.outlook.com (2603:10b6:300:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 06:27:17 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 06:27:17 +0000
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
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwEqZK+AABc0DAAAG3kNAAANRVGAACT84AA=
Date:   Fri, 4 Jun 2021 06:27:17 +0000
Message-ID: <MWHPR11MB1886487F2AEEDAEF298D04F98C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko> <20210602171930.GB1002214@nvidia.com>
 <YLh2APcZFpDoqOKG@yekko> <20210603124607.GV1002214@nvidia.com>
In-Reply-To: <20210603124607.GV1002214@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 6f2eb016-225c-42b1-c03d-08d92721ccc8
x-ms-traffictypediagnostic: MWHPR11MB1405:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB14053244C92992DB98FAE8A08C3B9@MWHPR11MB1405.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b7xCWaXIvU8qF8MpoPlEKTODRwA/wo4ktnX8pUz0Hz4yTAFqpJryMZx/mf3dAjOPx/L/80kqXAGKRgFKGQzzA0bRjtSKRVgB5Rjr5GM4ONy9zAYKvOsDZy+z+zN3/B+se2QNP5mwAXUx3oU+8V4NwBFjiSZEPp2TMqy3mOQBuvyR46bJtK0+2kjZToPDkkOU6Cv2+N9Maiye9dMcDYbJiDsVmilcvP17eQE5RmIAmM3gnw+269J+d2GIQtjK2Si9K93mqs4S09M28uZX4QpKwS7Ge0ow16cOPf2ujjwzdhgF3F/+yNRUVarX/lXB6e4zH9Uedfun4cQliuoh6Kt2YtM+Hmd7u4gvYaLnGaWJTHWKY8bZa0zzNgPnSV8RfBC1wYRO2QXK/7XMNx9dAGUZBiTxDPnWL/FVDN5HDspfgxflInItDt/fkID6LwiV3M0pFwwmzaaRidDcX1gC3RvfN89drkeYwNtPgsCvMV3ylGtF2dkDsvF7OFLsV60hmwkDm9swkpl/BEgCRjj0EGLvCoCa4xIxOX0t+dyx7+GkafZ11GBLyN2ugOEuZ6iCfhY2FyTKUuGqaXby5VDirmyLxLGvpC0wjGMq/x4H4yhrNBw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(6506007)(4326008)(66946007)(316002)(76116006)(83380400001)(122000001)(38100700002)(7416002)(86362001)(54906003)(71200400001)(33656002)(110136005)(7696005)(478600001)(66556008)(9686003)(8676002)(5660300002)(186003)(26005)(2906002)(55016002)(52536014)(66476007)(66446008)(4744005)(64756008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rN64yIIutRrIRN7hU8GnKjAX0fYOEFJCFY1HQHrBy4qSIKb3vj2WEdKdRfIL?=
 =?us-ascii?Q?FK7lysPJhdIUE5WUENlswtWn0q1Dv7Dp9dbBiTywRTyTSKaSyQmbbIvElyJX?=
 =?us-ascii?Q?1gsfDLg2EUcCrSxm78vQ9DGQwWBQpbmZWcVskIg4RB707rr8gB9kN4YtiDGV?=
 =?us-ascii?Q?ax6voaNSn4F9IoI5XsmtTGEziGgt/jPaY9pcGVniNYr15gFV+lzznaTxLCID?=
 =?us-ascii?Q?wAvwDjTZdgcRy9x+CjkUdqLNYn8E4zqaphKT4ZqdlD/YS4XEZV+qqte/FS8C?=
 =?us-ascii?Q?/1wok5yThXn8VTQIH2l71r5N/CUPtakapYPM6oyihMwWjo41YVTGEQX47hD6?=
 =?us-ascii?Q?u11sw3OA69lazvmNffPasocwrgo/Lj2H50jHcSCCCtse/+kpfWaqjVjV87HP?=
 =?us-ascii?Q?RCn5iAFgux8lAGUuGBEU0beJ5RaGicWo/I3+uVaCA6CObpV11GPEQYRmfFCA?=
 =?us-ascii?Q?L7IktTDjMdcQ/kf0dx44730tWp+NmQNTj9j3hwYrLn1MdSNV6jEa06Fqzfbo?=
 =?us-ascii?Q?BKPDVBC7VsQm4I046uH6xH4QFhBk9OyU55HKcTJ5NXNUFQgukCkWBNTAiWMe?=
 =?us-ascii?Q?VLCQq2LlfwrwcC91d9i7oPD3Of4sAHbi6YO4teu9fschQukiKn1Eq4M4Rp2z?=
 =?us-ascii?Q?T444j+nNZH/hQpJx9fQ0T3n/J/bNJkqBduL0l5h3Q8bc+qZxrp/he9UK01VK?=
 =?us-ascii?Q?yDfnQYoMRTKQLOiAvruu99Xnw6f9fwivCuCJTB9zl82n1KFSeoYuH5RQotfb?=
 =?us-ascii?Q?lvN1nMxCL5kQ1gt5VFgR+9VCXCzAh7fgDGtQ9rEmsXHP/kR8LxUU0hfwevrr?=
 =?us-ascii?Q?aDdwvTlkcP6pbfho+vIj86zy0cRdLZUKcdHJaAi0NGEEyVPW4tVsyZPcOEkK?=
 =?us-ascii?Q?iIrc+/9rJ4jpfWac8mWyWEoTlZMNZY6HWORwVMprJZ8aYU1zu/rx4741Irt+?=
 =?us-ascii?Q?QRoAqgFG+7sPHkFBsR6AUlGGjEOukwI16s1BgyzNtoPT1eA/bcxeg2V3QwIB?=
 =?us-ascii?Q?gQnsdHmKiGY3L3xHP+q9P3bvQtomNKzFMg/T0vAThoYe82pbNdTUe00PgeYF?=
 =?us-ascii?Q?q+naPkNeZQf4MqA9bpZvJ/C4frGPACP3Xe8ZatDdVOqtMhzy8+MXJxdbIFmb?=
 =?us-ascii?Q?QiZQAb41WUNoa2TVpzQHltpAWxabobNSyqerSTwPdZyF2b42awGnyJ1aosJN?=
 =?us-ascii?Q?k5/zF3100yaGEnBBhq1nLE73ZjVEbbd3QijhI9JxmHulx5obnt3RrxM/5flO?=
 =?us-ascii?Q?tBDEx/rh91pGycZ348yuBcdWBVStYmVsQz63nnkEyY+1CybaEKHI6WIhblgx?=
 =?us-ascii?Q?y7QBzD2DeXANTKArDjXCwbQ5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2eb016-225c-42b1-c03d-08d92721ccc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 06:27:17.0819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPMykOLsaJqNzjP1n+/XZ99i8RI7Msp/OG7ugMa46zXZA7Yi2chs5YTL9MqCQq3EU35lIjU+TvUIC2ZumzvYlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1405
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 3, 2021 8:46 PM
>=20
> On Thu, Jun 03, 2021 at 04:26:08PM +1000, David Gibson wrote:
>=20
> > > There are global properties in the /dev/iommu FD, like what devices
> > > are part of it, that are important for group security operations. Thi=
s
> > > becomes confused if it is split to many FDs.
> >
> > I'm still not seeing those.  I'm really not seeing any well-defined
> > meaning to devices being attached to the fd, but not to a particular
> > IOAS.
>=20
> Kevin can you add a section on how group security would have to work
> to the RFC? This is the idea you can't attach a device to an IOASID
> unless all devices in the IOMMU group are joined to the /dev/iommu FD.
>=20
> The basic statement is that userspace must present the entire group
> membership to /dev/iommu to prove that it has the security right to
> manipulate their DMA translation.
>=20
> It is the device centric analog to what the group FD is doing for
> security.
>=20

Yes, will do.

Thanks
Kevin
