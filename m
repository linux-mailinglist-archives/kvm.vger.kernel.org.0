Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF230A2EE
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 08:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhBAH5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 02:57:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:58105 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBAH53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 02:57:29 -0500
IronPort-SDR: 7C94F8Els12F4mnvL+4iyR/Geqk6TbFV31f+g+jIojUlfLOKQHLp0UDVK5Jz3Mp6/PcQb6EOGZ
 lq8ArazSWS+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="180793218"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="180793218"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 23:56:47 -0800
IronPort-SDR: r0fVCklJLq/jepBp4Msd2YEqcSJeAAtCeKxfREJu9Z7ZX8XNbkoqPiXkEtDWsqQyINiNhTeXD3
 JnHovf1XkiVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="371456696"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 31 Jan 2021 23:56:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 31 Jan 2021 23:56:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Sun, 31 Jan 2021 23:56:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 31 Jan 2021 23:56:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wg/njT7ImNERjYH7sQVLNjBKyoeSbio9I7rleMKRtU7mwb86j1a4r+tdOnbsF/JBGUyMK0dHRlQJZv8zxp8ZM4pVufuyzOVK2P4+B/FTO1sk0qmFGTB9uMAVfPAjHyL8VIy2j1ucJ1nHd28/dvOQbvaTI84QXEezyhOYWuA2f5K+EQDNfRzEgnr3DKOGhA15zlLhTGYpYO2bgvlUQ4+nRmFb4o13gTrxBuaY3xcL/f+WQhNJZ7FdjOuWcsMoAhVeIPhirs+UY3dzjgVP0V0p7mu5UBckK3775afSymfzHO0f394QEva/diOOXTW8Kuc0zx7d749kwgW0nKmQaIO3Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ6hzNltq1AfEMj9LjcQZmnLM2MWIsJCILjVWp/UuU8=;
 b=B1gEVF/moxcVxGl06da5Gfc3OGr6b9i1DvCtZRHV7rte9lVcQGVqo3dMBn8XcSUcp9wCz+zh+50DVdy4umEmKBb72YL6NNvEdpG9btGLKJNyt1GoH2peVarG9AARa+qcmOtdV2K0SW1g8bAs1sF0xoKBvxvwVNQ0mIO3u2qXTlc7UAuCOjIUulxWyXdmNNRj8oLDBMwyGTR5memahYgjBSbzGYyuFYcxxcaSdrpc+CG/qyH8VpYhsZfHS5Jv7RB9UHQ3Ta+IQRK3ShXCdmmRHV8wFaxGY/Yce0TiIx91OvIE6iArba/VD7LSnoqxgtFRAKun2DmE81Ks5YI151r80w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ6hzNltq1AfEMj9LjcQZmnLM2MWIsJCILjVWp/UuU8=;
 b=mwdNwUBwFlJIBwMs/6GZSLsVqySb4iaXSePP9j6pFOGCk+DnnEyNwt5pTcJD7TskjYx/wE+dbiXhPKe89oz32BQqUw6rATeWDvhTqAFug4QDKIjYL+iRLOBhVd30Te4PPlxVMcpzZDWm6OhWq/aASLgktYn0Mu65J8SU3IoHLiU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB2063.namprd11.prod.outlook.com (2603:10b6:300:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Mon, 1 Feb
 2021 07:56:45 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46%6]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 07:56:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shenming Lu <lushenming@huawei.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW8vkytb+JKYXDyUeYG8HWtmg34ao/PksAgAOljRA=
Date:   Mon, 1 Feb 2021 07:56:45 +0000
Message-ID: <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
In-Reply-To: <20210129155730.3a1d49c5@omen.home.shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 154f989c-8c31-469b-1460-08d8c686ebaf
x-ms-traffictypediagnostic: MWHPR11MB2063:
x-microsoft-antispam-prvs: <MWHPR11MB2063D7F8E6CB239A96CD89768CB69@MWHPR11MB2063.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KhaNy8AR22dmX4HQ+Y+rKRn2bRNGhFJ+GyvkIe5o31Ypu7rIOIum/xDzwZK11Xyu4Kef7k0d99aGSPB/m6gCa3nzE1YBBJxL1kQ2bvDfCHJXjMUcXLAVyM31KygofQ+VacUDELLP35NKdTYsPAYWR6f/NW+TPsNBhklCwxdugndGJz82ezk/fx+WwpDZBgRMKYsvodjvg+dmR6hOqZdw5EkNd9E09gPt2650DzK0bdKbhvJzlEypZ3ODMdUSyqcfvZaBbzYWYSBkPXR/prgn0KUv3pUNnRnRWBSaeGEa1fM2veVJQBsVu6khu7fOJcLp10X/1BQdhfVk+bqY7qRpO3CRlWHfgdquhVt1E/7qlbo8aRgGnR09oE7T40+MeVOLZQQl9RxFEKOvy9lvVtcnsp4haXsjaNZy/bCtWjlSiiIEdYw67ItK/l0VurFCg3fx8ZAX6fZrVKs7Wveqp48R5BerrH262H0wg7+NsObY8KhQ+vWCVtlrzKpMCR90adX15Ys2Td3QQY+1gBaSfjjlD3S8ZQF9YshqcaCb+dAimnN+oe9Di8sQiCuJqe2To0jnMFhkBEHlJUKPDY2WlIgP/fiz0vy1uH/dUEOW4Z678Iw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(26005)(83380400001)(186003)(8676002)(5660300002)(478600001)(33656002)(7416002)(8936002)(52536014)(66476007)(55016002)(54906003)(66446008)(6506007)(71200400001)(76116006)(4326008)(316002)(9686003)(86362001)(64756008)(2906002)(7696005)(66556008)(110136005)(966005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FNE09W+LiX80GHBR+Kzj0QPg/bwWidcucME8CvdqpB79wGh+yiF7PvHKkEB0?=
 =?us-ascii?Q?p3wqSNlu1+vvoOxzcfaiuOZHONJyYaOqF1aGyZHQmKkq7UPj4S1rE4tT2meK?=
 =?us-ascii?Q?qG1h3rIk0+fSCFEN8Ob0IxxXpwKbOIA63+W+QF5hfVqUITTjySuixcJdSeqP?=
 =?us-ascii?Q?OOwR438/nlepfmuCvUpAWfBtp0kLWKdVmUg9nXAnwa3g1oMZAo+G2QyKYQp+?=
 =?us-ascii?Q?K0oSrqaktAJxUflkEXcp5BrKttri5dDQXbt6B6aFYJWaWnxiQZHmRuon9VVb?=
 =?us-ascii?Q?3+ewITvrrYEBrU+rmd9Xq6pk9POH9M/s+e8NdEKdrZTIWkoF/kHCnr3BWvRW?=
 =?us-ascii?Q?ZG+hPfwdHwY79mfdhfHiVMPq3ZfKmbxT+gkW+C5GEaVi2buE08j2lLSR1C8f?=
 =?us-ascii?Q?ufpSY6UJusSODzEYC/d8qdtYtFHSOD4tI9NBsxJYX3QYwPbA1efEs0mwmtvK?=
 =?us-ascii?Q?ROL3lyrzNqPjHD9MTPafJLPPqAipc6kuxo6E1eIjCe+5ZObNK85kYuBmHN+W?=
 =?us-ascii?Q?/GkU8GiEc/2mZ/GRqoyHwvTX4G3FTYGUSS8kZGJl84itGJeCMJzV1bumIXhv?=
 =?us-ascii?Q?CPilsPRN8Mx/DiSYuEoH5YZIuMqeUX09l4WYpQshmAM8IE1U8/GOSANTvQ37?=
 =?us-ascii?Q?ZNvf4ptWPM5LCtM/MGNbMzFXzM7E51AiE1SuBnIEwWq707py/xHnFRlD2L3o?=
 =?us-ascii?Q?YutW7SiA3Im2F8kfKLYMw+GdE42dZW8cC8ohXzLbVpM8YKUO4kFYU/MEDfrJ?=
 =?us-ascii?Q?XH8dQDxWy9CHfsqP/fM8oVNxoYICBsd17wgac1Yl98R2jMR5Moa4xTqtFIFI?=
 =?us-ascii?Q?fk5+dUC2DAoK8p5HiuQK0AABVD8XEfdgNRW0ityZvJ6qYJHvSw22LAEtQsTB?=
 =?us-ascii?Q?VoqJ7V4b/nC/Fuq3Ei/PldS2LJS4MTs9o18smJdxRyIoydMBdw/PM4u+jfef?=
 =?us-ascii?Q?D73JavsBBpl8Qb9vOgL6iDwjY4jHoftGYxcKE4lXk+SAj4C8fGV9pchw8XKL?=
 =?us-ascii?Q?MDaqzhbo/733MnM5oJAEjHertnaCjdJRhj009uH5VAyvYoP+dPweg5iiM3p5?=
 =?us-ascii?Q?5BS/b399?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154f989c-8c31-469b-1460-08d8c686ebaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 07:56:45.3632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vn2Dq/6vDsXC5cjWpOlR6TXv62RvP0XXTxgRZLrEaU90Ubqp6a0BsS+N1wSnE8jbidaQ0mv/4+QNQzupWzbc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2063
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, January 30, 2021 6:58 AM
>=20
> On Mon, 25 Jan 2021 17:03:58 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
>=20
> > Hi,
> >
> > The static pinning and mapping problem in VFIO and possible solutions
> > have been discussed a lot [1, 2]. One of the solutions is to add I/O
> > page fault support for VFIO devices. Different from those relatively
> > complicated software approaches such as presenting a vIOMMU that
> provides
> > the DMA buffer information (might include para-virtualized optimization=
s),
> > IOPF mainly depends on the hardware faulting capability, such as the PC=
Ie
> > PRI extension or Arm SMMU stall model. What's more, the IOPF support in
> > the IOMMU driver is being implemented in SVA [3]. So do we consider to
> > add IOPF support for VFIO passthrough based on the IOPF part of SVA at
> > present?
> >
> > We have implemented a basic demo only for one stage of translation (GPA
> > -> HPA in virtualization, note that it can be configured at either stag=
e),
> > and tested on Hisilicon Kunpeng920 board. The nested mode is more
> complicated
> > since VFIO only handles the second stage page faults (same as the non-
> nested
> > case), while the first stage page faults need to be further delivered t=
o
> > the guest, which is being implemented in [4] on ARM. My thought on this
> > is to report the page faults to VFIO regardless of the occured stage (t=
ry
> > to carry the stage information), and handle respectively according to t=
he
> > configured mode in VFIO. Or the IOMMU driver might evolve to support
> more...
> >
> > Might TODO:
> >  - Optimize the faulting path, and measure the performance (it might st=
ill
> >    be a big issue).
> >  - Add support for PRI.
> >  - Add a MMU notifier to avoid pinning.
> >  - Add support for the nested mode.
> > ...
> >
> > Any comments and suggestions are very welcome. :-)
>=20
> I expect performance to be pretty bad here, the lookup involved per
> fault is excessive.  There are cases where a user is not going to be
> willing to have a slow ramp up of performance for their devices as they
> fault in pages, so we might need to considering making this
> configurable through the vfio interface.  Our page mapping also only

There is another factor to be considered. The presence of IOMMU_
DEV_FEAT_IOPF just indicates the device capability of triggering I/O=20
page fault through the IOMMU, but not exactly means that the device=20
can tolerate I/O page fault for arbitrary DMA requests. In reality, many=20
devices allow I/O faulting only in selective contexts. However, there
is no standard way (e.g. PCISIG) for the device to report whether=20
arbitrary I/O fault is allowed. Then we may have to maintain device
specific knowledge in software, e.g. in an opt-in table to list devices
which allows arbitrary faults. For devices which only support selective=20
faulting, a mediator (either through vendor extensions on vfio-pci-core
or a mdev wrapper) might be necessary to help lock down non-faultable=20
mappings and then enable faulting on the rest mappings.

> grows here, should mappings expire or do we need a least recently
> mapped tracker to avoid exceeding the user's locked memory limit?  How
> does a user know what to set for a locked memory limit?  The behavior
> here would lead to cases where an idle system might be ok, but as soon
> as load increases with more inflight DMA, we start seeing
> "unpredictable" I/O faults from the user perspective.  Seems like there
> are lots of outstanding considerations and I'd also like to hear from
> the SVA folks about how this meshes with their work.  Thanks,
>=20

The main overlap between this feature and SVA is the IOPF reporting
framework, which currently still has gap to support both in nested
mode, as discussed here:

https://lore.kernel.org/linux-acpi/YAaxjmJW+ZMvrhac@myrica/

Once that gap is resolved in the future, the VFIO fault handler just=20
adopts different actions according to the fault-level: 1st level faults
are forwarded to userspace thru the vSVA path while 2nd-level faults
are fixed (or warned if not intended) by VFIO itself thru the IOMMU
mapping interface.

Thanks
Kevin
