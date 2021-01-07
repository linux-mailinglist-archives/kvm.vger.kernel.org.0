Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0CF2ECAB1
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 07:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbhAGG4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 01:56:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:46187 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbhAGG4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 01:56:00 -0500
IronPort-SDR: K1whbF2He8tzFabPkx7MmdkrQMvrJn3PyLqef5uqEyDrDn7yG5VbxN9eiyA/EcL5Z1zl8/U+PM
 PBgxEwXw3cQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="156573233"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="156573233"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 22:55:19 -0800
IronPort-SDR: ZhMr4JTS5EA/hTyu0PqVaWZnhMZo6fajE0jrHrZiFlNUUg9MuHbjSkpbJHps+5cxDqetdub/Ib
 uAKj/+xOL3jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="351155618"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2021 22:55:19 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 22:55:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Jan 2021 22:55:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 6 Jan 2021 22:55:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a30oNHY7F62v+ZqvZdwbkLzJK4EOm/x6BdqdazAQw+L2wOczr4gZkMeOtkfGFWWUKIeHER7+G+3ZhXQFs1Rjn9mM9dkzttMpkakwxW5MirOWjvManHv4G2MPh0A+EVj+rh7O/kzhPwWALbG2txSP0S3HpfZ+tATz5DwTxQs4TgY3zUUABDlmAvCxLEqhdYqsn6fUOL11V9mzDai/XtRiLdQQRhxguY1SNHsQn3uY13WuaMYwV3hf5K6czWvJd/cBV5uZVRR80Qp/GvV/BArhzIxYVIQINBDp8HVg4vCS60GKgfsK+FIRhUDVNuunv1X4IYQxNFHaISsR6pdF5CjWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IS1fEM3kSUlZmEZWJQVIEUGKTJcxaJIG2H3NTxbkpc0=;
 b=eY7cx7B4Mkd7VMJg0uLfOMt4be3gff4zyT1KZgzAYNouLHIMbIrUfHk90HwrKWZBwumbMjK//VBfpensKzmzzciImxSG5Pqr9zMbmV/eSpmdNfOKCAIfOP4NurvgTkShbIK93ZgS75bn1PbQRVgmRCzHscE5SkV+8W0SttLbXr7FxBq2R+c+UZtm7WZnRaQeXdh9iBdG2RnjS7ClP0Ro4U+NDbTp4qHERHN87qJLcSW/w/V0s6KSxH66M6YtOv0cXgfh69GP6yJD1cqhnjtN58FcSUijq3fs58V5vZUUH5iSRhX9DMPnhN2v1xaDagQZh9AZgZxEto25rDmzA37RVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IS1fEM3kSUlZmEZWJQVIEUGKTJcxaJIG2H3NTxbkpc0=;
 b=vx/P7Lw3i+LVXbqD8IugIXG76rdAEbFRi5QsM7ge9O4kwi55/uwCzmQNZNyS6QMALgVF8GUfb6VRJjeRtasCwlWgpffn5I1n+ymTMjbSt+ceFUsr5W87iISUSOraxB9ImZUIFzl7GTasHV/BMXB8BhNEBouYWryuAxFfihW6hJY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1550.namprd11.prod.outlook.com (2603:10b6:301:b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 06:55:16 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419%4]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 06:55:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH v2 1/1] platform-msi: Add platform check for subdevice
 irq domain
Thread-Topic: [RFC PATCH v2 1/1] platform-msi: Add platform check for
 subdevice irq domain
Thread-Index: AQHW49Su6SbTQ4wqJ0uR1rOXugZzS6oaHGmAgABEJ4CAAAhrgIAATyyAgAAKtQCAAKJjIIAASlkAgAAGRmA=
Date:   Thu, 7 Jan 2021 06:55:16 +0000
Message-ID: <MWHPR11MB188629E36439F80AD60900788CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal> <20210106152339.GA552508@nvidia.com>
 <20210106160158.GX31158@unreal>
 <MWHPR11MB18867EE2F4FA0382DCFEEE2B8CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210107060916.GY31158@unreal>
In-Reply-To: <20210107060916.GY31158@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0afa2a17-3b2e-4d41-e4ec-08d8b2d930a3
x-ms-traffictypediagnostic: MWHPR11MB1550:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB15506B862FAC5056D1B515AB8CAF0@MWHPR11MB1550.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uxevNbmJ6Y+e8GwAeFP2MxK5EAjEOuMDBl4MtJwDQq2/2NbeDWfkybkedVEsegNpeetxO4hcj8MpKuc+7h4s7/ahQmIPvuHCW++wf2EePTA2AN9E+ZZQL7v0raRzE5f7lUFAdgJsj5emt70szCAQEq+wzGmpN93vHgcWPho2WA6zvg/ARAR4AIJpkA3y+Gcw4aB6gxpNRKe6JjWGLHMPnv/0FOPtT0OYsLzpmgVZVt01l5PYlXIagePp2KIJAYNV145DaDtpYBdIsPgdrm2QEUjo/0dZUAQbz4Yi7AJW6dalLFIOwdaXy+NpmN3Lp9qPEtRNig16x6OuSpiOCn9YF0eyrXtwjrL7PiazD35A84No6R/yKEp0JFAsQKkTbBJAavJa+8TNqhfOHzTBlWNzOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(86362001)(6506007)(83380400001)(52536014)(4326008)(9686003)(71200400001)(110136005)(5660300002)(478600001)(316002)(45080400002)(2906002)(54906003)(7416002)(76116006)(66476007)(66946007)(33656002)(66446008)(64756008)(7696005)(66556008)(8676002)(55016002)(8936002)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/yzji7MKsFvHoRlWxNfpqSoMuKnsNPVWYY23VF9kK0Sg1qEQNLOnnmOW2ExT?=
 =?us-ascii?Q?gK7KhSAqXU1SxFNrJRdUFodAJ3YWTOCWIW5sm1lamdkb7YW5bNdjuV4upiot?=
 =?us-ascii?Q?6VvBFdwUZ2Xewl7OP/Lrxm8Z999tyyybb7ZYUzMMVICW7evXPMvVCgBtAaSV?=
 =?us-ascii?Q?69WMmNGFnSUbF5wlLg2gjcc9olMwb6GgbNIh8LY2aZ4XsBeIpkG0YU/E+9x5?=
 =?us-ascii?Q?zrExHcV2QKtuuHLlezDnOGThWGAHDjOU9iTj0DsYHaltlNikp+B1FAPqS4PW?=
 =?us-ascii?Q?lVdK7284IfPl/NmKM2RQFlu0Yttyqr1hi1prYAeeFWCyokLUEqApzSCTrNb7?=
 =?us-ascii?Q?E18yN0MDqeAHebR3uIsxY9gFHQsbv97FifWZerCEtd6MQnrso+soYSkSunle?=
 =?us-ascii?Q?3pjgiQEu4/JwpMRlJ6hNWijq8ufpZxQAAZFG3MMDj02/NA4HO/oblaMolr0j?=
 =?us-ascii?Q?yq44mvtB6Aj0P4dpo0iRpSgft30DePs4fLZsWa0IX0TQE9zj8JdB79m8jg/8?=
 =?us-ascii?Q?ZXpWWEUwIY+EG0keZRGLJW17Bd95ziEOSSWec/Z5QfedEHZRf1uid2g2ecSE?=
 =?us-ascii?Q?sQim6sDjGWYywpsCr4EwFYnMzuHtN3LaQrmi4NqUXxbYXeor6+fqWEo2ZWWc?=
 =?us-ascii?Q?JZIIIBau7rYBtjsdPy/gOIvT0H/d0rR9w6hMwV4s+uWkbWVd8c7XluFdntOv?=
 =?us-ascii?Q?9kT5dSPjGt2Z/FYBZvuMo6ARf2HVFMMLB10s0IRXea+t7+/bCtsSNGXUd/y9?=
 =?us-ascii?Q?E7DiBUhfoFEnBremmoQVzyKe34b9Ee8NojJxSk75TsjdMgIbdO/9aY++hinw?=
 =?us-ascii?Q?zPto52l4OCgVeI4fd15vNbmszoEsZpIb1r0LQ4By5x93qLrVBC1F82VqcXPT?=
 =?us-ascii?Q?sMc5dMQskmflMLV2/J3rwxn/G9XOnUMCCc9VJtjF8P8kA0fOWAf/VtlfALF3?=
 =?us-ascii?Q?iuLsDc6Gm0nmKhvi7TvhGiwORTwtiwgdEJGkCQ2jLJA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afa2a17-3b2e-4d41-e4ec-08d8b2d930a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 06:55:16.5540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PFsoHQpgFQC+4M1JgEIcwiytDADazF70BSCys62BIAdW4X8YUpEG8u6F8b+KteSc2GRbQmNPFRfxptYZr3wdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1550
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, January 7, 2021 2:09 PM
>=20
> On Thu, Jan 07, 2021 at 02:04:29AM +0000, Tian, Kevin wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, January 7, 2021 12:02 AM
> > >
> > > On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:
> > > >
> > > > > I asked what will you do when QEMU will gain needed functionality=
?
> > > > > Will you remove QEMU from this list? If yes, how such "new" kerne=
l
> will
> > > > > work on old QEMU versions?
> > > >
> > > > The needed functionality is some VMM hypercall, so presumably new
> > > > kernels that support calling this hypercall will be able to discove=
r
> > > > if the VMM hypercall exists and if so superceed this entire check.
> > >
> > > Let's not speculate, do we have well-known path?
> > > Will such patch be taken to stable@/distros?
> > >
> >
> > There are two functions introduced in this patch. One is to detect whet=
her
> > running on bare metal or in a virtual machine. The other is for decidin=
g
> > whether the platform supports ims. Currently the two are identical beca=
use
> > ims is supported only on bare metal at current stage. In the future it =
will
> look
> > like below when ims can be enabled in a VM:
> >
> > bool arch_support_pci_device_ims(struct pci_dev *pdev)
> > {
> > 	return on_bare_metal() || hypercall_irq_domain_supported();
> > }
> >
> > The VMM vendor list is for on_bare_metal, and suppose a vendor will
> > never be removed once being added to the list since the fact of running
> > in a VM never changes, regardless of whether this hypervisor supports
> > extra VMM hypercalls.
>=20
> This is what I imagined, this list will be forever, and this worries me.
>=20
> I don't know if it is true or not, but guess that at least Oracle and
> Microsoft bare metal devices and VMs will have same DMI_SYS_VENDOR.

It's true. David Woodhouse also said it's the case for Amazon EC2 instances=
.

>=20
> It means that this on_bare_metal() function won't work reliably in many
> cases. Also being part of include/linux/msi.h, at some point of time,
> this function will be picked by the users outside for the non-IMS cases.
>=20
> I didn't even mention custom forks of QEMU which are prohibited to change
> DMI_SYS_VENDOR and private clouds with custom solutions.

In this case the private QEMU forks are encouraged to set CPUID (X86_
FEATURE_HYPERVISOR) if they do plan to adopt a different vendor name.

>=20
> The current array makes DMI_SYS_VENDOR interface as some sort of ABI. If
> in the future,
> the QEMU will decide to use more hipster name, for example "qEmU", this
> function
> won't work.
>=20
> I'm aware that DMI_SYS_VENDOR is used heavily in the kernel code and
> various names for the same company are good example how not reliable it.
>=20
> The most hilarious example is "Dell/Dell Inc./Dell Inc/Dell Computer
> Corporation/Dell Computer",
> but other companies are not far from them.
>=20
> Luckily enough, this identification is used for hardware product that
> was released to the market and their name will be stable for that
> specific model. It is not the case here where we need to ensure future
> compatibility too (old kernel on new VM emulator).
>=20
> I'm not in position to say yes or no to this patch and don't have plans t=
o do it.
> Just expressing my feeling that this solution is too hacky for my taste.
>=20

I agree with your worries and solely relying on DMI_SYS_VENDOR is=20
definitely too hacky. In previous discussions with Thomas there is no=20
elegant way to handle this situation. It has to be a heuristic approach.=20
First we hope the CPUID bit is set properly in most cases thus is checked=20
first. Then other heuristics can be made for the remaining cases. DMI_
SYS_VENDOR is the first hint and more can be added later. For example,
when IOMMU is present there is vendor specific way to detect whether=20
it's real or virtual. Dave also mentioned some BIOS flag to indicate a
virtual machine. Now probably the real question here is whether people=20
are OK with CPUID+DMI_SYS_VENDOR combo check for now (and grow=20
it later) or prefer to having all identified heuristics so far in-place tog=
ether...

Thanks
Kevin
