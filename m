Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60DE2F28A5
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391700AbhALHAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 02:00:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:31808 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbhALHAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 02:00:35 -0500
IronPort-SDR: NcDZyInpNejTPdlfoQV6nJ4STF7QnGYqteH9xTSMCLV3fgp9YRAm5hPAiGiDfY/LFYIv8Vkz2A
 eqw2K33O/+cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="165674958"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="165674958"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 22:59:53 -0800
IronPort-SDR: u++/jGkuZkOn3ljo7cvyyrwVGs6XfnnwKx1GJd+W6M6x2Sdc0i4f88KYk3CvtRgvcXHua1wuPN
 IfictUA8C2xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="567414733"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 11 Jan 2021 22:59:53 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 22:59:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 11 Jan 2021 22:59:52 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 11 Jan 2021 22:59:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JO8HdoJ6b/6S8Y813Dxm2RE16fX4JUqSZ8VRfc8lWOnXYBQ4cOnFM9cCEkLMBLOdIAFo18JA1oWw82T7Jmvt+OeIrGLUL/FOy6qJMJf3PvUQhtCmyT/5ICFrXTayfCuFkX+9Q3jV89U0FKG+npXROoNF8x8ffTe308jZVxmkB6+ordb/34Yuo+9zVCBMOh3oW5p9DsbVO101e3u+GnseNQ+P5amSCRa/c9lAHBvZ9viZu/i0xg8Itd669Zgp9ObIwm8PHfwEeqS8rBL6KWCXHWlcd3n2gwigbmOnl1+aQXPQgVkR01K4qYjnINmE8bXsqmLN7kVA/vthEiCT1pla+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+icgA+2cSGzs6MjB923vsuIzt5o2OhUExPpiIUhKu/E=;
 b=Bo/8DgSHsvBn5CN5c8L95RHK2qgg18v2tZWmUjq7Qn1ryRptHsqmur/mqsiFnxpy/BLfWT3xgV8id8YzSQDcY4hcoRLEblPbW+VlFWN/QoAZztbEGNTIJ2zwitmPSlXiClMyTsZcPnSO1FJlZKdaXAizS1fSZ5d42Eqq6T3GT+PxtH8vVBdIpNMlxA4PqDoylz2dccP8LTaZyUQMdGIGAphLwF7zvRZJz3pQgH+QHH2DMtVXXj0adK1RvrBUAQd8v06vNmUWGo/UDOURmPuhuIgD1NyaSmx5HqXsrlwtzKB5LyBdmA9UC0d9ULj1xpZfaj5nlwFqneo3BRQZuo7kpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+icgA+2cSGzs6MjB923vsuIzt5o2OhUExPpiIUhKu/E=;
 b=vxtSpA6OlmvL4S+ejIabCvJ2OTni2x8/X9WDvBwvPLvp6hjLUSSysOYjIPiRr/0gJDfviOdmTooe45IRXuxsVKMGi0m1e6Fg3QLNmGwXx29krE4t4BVfrG+6Qf/+SU9LnDULiG5CgfBwE6K4aS2HphzXLx8OxdMmPyHedrMfnRc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4715.namprd11.prod.outlook.com (2603:10b6:303:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 06:59:35 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419%4]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 06:59:35 +0000
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
Thread-Index: AQHW49Su6SbTQ4wqJ0uR1rOXugZzS6oaHGmAgABEJ4CAAAhrgIAATyyAgAAKtQCAAKJjIIAASlkAgAAGRmCAAAxyAIAHumKAgAAKHACAABIU0A==
Date:   Tue, 12 Jan 2021 06:59:35 +0000
Message-ID: <MWHPR11MB188672D9BB76B2C5E04934138CAA0@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal> <20210106152339.GA552508@nvidia.com>
 <20210106160158.GX31158@unreal>
 <MWHPR11MB18867EE2F4FA0382DCFEEE2B8CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210107060916.GY31158@unreal>
 <MWHPR11MB188629E36439F80AD60900788CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210107071616.GA31158@unreal>
 <dfda8933-566c-1ec7-4ed4-427f094cb7c9@linux.intel.com>
 <20210112055322.GA4678@unreal>
In-Reply-To: <20210112055322.GA4678@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa9c70c8-a31a-4244-5f74-08d8b6c79efc
x-ms-traffictypediagnostic: MW3PR11MB4715:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47158F4E6DB76AFBA24E6D248CAA0@MW3PR11MB4715.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1I/3etOKYQ6gpwsSclOa8pRZzmN4IXp6bvWus4voSJ6NcJDlzoj6CI+jcJW9IeN70vj9bIcGh6vr0fS09lC0bR1HIrdRsEVCzeGi+on0DmGR02uUHUBjeYpxgtMthIhHpHwf7b9WQ6alGIVTKMEwPTDhQFY/RAo9G0IWOuqMduYnYGPzDr7peNovEDwsj57woTr/8TlvOZEACX9VZqmyZ8CizSA3OMrplylPdLLWDJ6aT7mrCoTFrCmPX3XdRocxb4ZAeCW2ywrV0Ech5m7lfL53aGXPxybPRrbhEgnxS+Gbz70Rfy11gHDSYvgQZ7C8CKRJRl9Ot0QvJJtwip3QQDwx91cwuQKjl1ni+EYs9XTmqfo67w9Cv/fOK2G9OjvpXNVORGi1bL12u3E2aR5rQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(8676002)(71200400001)(26005)(7696005)(6506007)(53546011)(55016002)(316002)(186003)(478600001)(4326008)(45080400002)(33656002)(2906002)(54906003)(86362001)(66556008)(64756008)(66446008)(66476007)(7416002)(9686003)(66946007)(52536014)(76116006)(83380400001)(110136005)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pYFLhOgQCeGWakOdmxFiJF4uTG4QPn+E70K3p7JeBbgy/pRswiRoZ0w1KGwq?=
 =?us-ascii?Q?ZconljcqZZ2O/ZgoART2nXT7d3kNUliE8XjROV856hwb/YansSM9VWQZVXZL?=
 =?us-ascii?Q?Imr09AUSTr7OkkzcMODNa1vJE6MCDbIhM7z5x9j27cQNb2NV5zemXz2xmKdR?=
 =?us-ascii?Q?uJzluZGtQFSmHn+5x5Axc0J81YXBcviNo4pvnbJSRb1KMAk+QfVlyPiJFR8Y?=
 =?us-ascii?Q?rH6NV9ZFlAzNg62N4LwtOktH7LGuh/J03yk18VWejmMZDzJiVJ0jGKNxbScO?=
 =?us-ascii?Q?GYQzIz3XJCOkzrt6WttY+9+htya6mRA61kFKIAOL66LD8ElSLnFH4zGYBejK?=
 =?us-ascii?Q?CeLPx4Fchs/l/WyqAnm+SseOhnWLdeVP5A5oAQU7UMp5lJ5JjkFY6LzMBBoJ?=
 =?us-ascii?Q?3qcE9fcIa9NqEZP1Ppq0r0dgLKHBleW8ADmBjEoXy4Btd6uRqhVF48PAE3yW?=
 =?us-ascii?Q?3PuS7mY8Rgvii64NnwUmFb/RzZ/tQdcG5risvdmhLDz0Gct/vQrqexZDg3/w?=
 =?us-ascii?Q?CbYrzHc5TVFjpR4KjbCgYjHVTeiYtRGLIAW+3OuxsXpA9EuShqN1qoXjvgrL?=
 =?us-ascii?Q?McJ7fKF20ms9eOwJuZkWRl1m8BL2QWbHyVV3jRFN/jHbg/PgtG5xONDdUJEF?=
 =?us-ascii?Q?p+jj1ifhZNODDRpVcuLLGc3AeC4XKFL3VGETewBuZJiox9OgpkW0madO15Yq?=
 =?us-ascii?Q?0sYR7lUc1+FsYmhHamRsx/ieOnRbT2O4S1sYzyEm52LEqz0ybci/yK8VHKN1?=
 =?us-ascii?Q?svJPYkGKMF6yTjNXeSgrBK/jUBUSMidOhn3D0LpG6lUEMlFhUtDSG0ZX0ynU?=
 =?us-ascii?Q?o0+EhARihZ6koycdjMATixk8e5t2Ksa6bxGPOjC2FMnR32LlFI7dHuoKj/8a?=
 =?us-ascii?Q?7it2wf9IL+CELI0Y/WJxJ402Tpfhlbp7OsLw1ezGMaIDGghjAVfMVYTKsxfI?=
 =?us-ascii?Q?3hokqfC7QIJhmyvRj14/g1g3GNmUH/C9YE2zIHOSPSU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9c70c8-a31a-4244-5f74-08d8b6c79efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 06:59:35.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0U8zA1g3mFvz0CQoDTGn2zi747+R/5DuY47H26/pWf04pYqx8p1Vxn4N4/T0LOZsBfBo01QMfAfdPMEAMs+4aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4715
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, January 12, 2021 1:53 PM
>=20
> On Tue, Jan 12, 2021 at 01:17:11PM +0800, Lu Baolu wrote:
> > Hi,
> >
> > On 1/7/21 3:16 PM, Leon Romanovsky wrote:
> > > On Thu, Jan 07, 2021 at 06:55:16AM +0000, Tian, Kevin wrote:
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Thursday, January 7, 2021 2:09 PM
> > > > >
> > > > > On Thu, Jan 07, 2021 at 02:04:29AM +0000, Tian, Kevin wrote:
> > > > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > > > Sent: Thursday, January 7, 2021 12:02 AM
> > > > > > >
> > > > > > > On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe
> wrote:
> > > > > > > > On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky
> wrote:
> > > > > > > >
> > > > > > > > > I asked what will you do when QEMU will gain needed
> functionality?
> > > > > > > > > Will you remove QEMU from this list? If yes, how such "ne=
w"
> kernel
> > > > > will
> > > > > > > > > work on old QEMU versions?
> > > > > > > >
> > > > > > > > The needed functionality is some VMM hypercall, so presumab=
ly
> new
> > > > > > > > kernels that support calling this hypercall will be able to=
 discover
> > > > > > > > if the VMM hypercall exists and if so superceed this entire=
 check.
> > > > > > >
> > > > > > > Let's not speculate, do we have well-known path?
> > > > > > > Will such patch be taken to stable@/distros?
> > > > > > >
> > > > > >
> > > > > > There are two functions introduced in this patch. One is to det=
ect
> whether
> > > > > > running on bare metal or in a virtual machine. The other is for
> deciding
> > > > > > whether the platform supports ims. Currently the two are identi=
cal
> because
> > > > > > ims is supported only on bare metal at current stage. In the fu=
ture it
> will
> > > > > look
> > > > > > like below when ims can be enabled in a VM:
> > > > > >
> > > > > > bool arch_support_pci_device_ims(struct pci_dev *pdev)
> > > > > > {
> > > > > > 	return on_bare_metal() ||
> hypercall_irq_domain_supported();
> > > > > > }
> > > > > >
> > > > > > The VMM vendor list is for on_bare_metal, and suppose a vendor
> will
> > > > > > never be removed once being added to the list since the fact of
> running
> > > > > > in a VM never changes, regardless of whether this hypervisor
> supports
> > > > > > extra VMM hypercalls.
> > > > >
> > > > > This is what I imagined, this list will be forever, and this worr=
ies me.
> > > > >
> > > > > I don't know if it is true or not, but guess that at least Oracle=
 and
> > > > > Microsoft bare metal devices and VMs will have same
> DMI_SYS_VENDOR.
> > > >
> > > > It's true. David Woodhouse also said it's the case for Amazon EC2
> instances.
> > > >
> > > > >
> > > > > It means that this on_bare_metal() function won't work reliably i=
n
> many
> > > > > cases. Also being part of include/linux/msi.h, at some point of t=
ime,
> > > > > this function will be picked by the users outside for the non-IMS=
 cases.
> > > > >
> > > > > I didn't even mention custom forks of QEMU which are prohibited t=
o
> change
> > > > > DMI_SYS_VENDOR and private clouds with custom solutions.
> > > >
> > > > In this case the private QEMU forks are encouraged to set CPUID (X8=
6_
> > > > FEATURE_HYPERVISOR) if they do plan to adopt a different vendor
> name.
> > >
> > > Does QEMU set this bit when it runs in host-passthrough CPU model?
> > >
> > > >
> > > > >
> > > > > The current array makes DMI_SYS_VENDOR interface as some sort of
> ABI. If
> > > > > in the future,
> > > > > the QEMU will decide to use more hipster name, for example "qEmU"=
,
> this
> > > > > function
> > > > > won't work.
> > > > >
> > > > > I'm aware that DMI_SYS_VENDOR is used heavily in the kernel code
> and
> > > > > various names for the same company are good example how not
> reliable it.
> > > > >
> > > > > The most hilarious example is "Dell/Dell Inc./Dell Inc/Dell Compu=
ter
> > > > > Corporation/Dell Computer",
> > > > > but other companies are not far from them.
> > > > >
> > > > > Luckily enough, this identification is used for hardware product =
that
> > > > > was released to the market and their name will be stable for that
> > > > > specific model. It is not the case here where we need to ensure f=
uture
> > > > > compatibility too (old kernel on new VM emulator).
> > > > >
> > > > > I'm not in position to say yes or no to this patch and don't have=
 plans
> to do it.
> > > > > Just expressing my feeling that this solution is too hacky for my=
 taste.
> > > > >
> > > >
> > > > I agree with your worries and solely relying on DMI_SYS_VENDOR is
> > > > definitely too hacky. In previous discussions with Thomas there is =
no
> > > > elegant way to handle this situation. It has to be a heuristic appr=
oach.
> > > > First we hope the CPUID bit is set properly in most cases thus is c=
hecked
> > > > first. Then other heuristics can be made for the remaining cases. D=
MI_
> > > > SYS_VENDOR is the first hint and more can be added later. For examp=
le,
> > > > when IOMMU is present there is vendor specific way to detect whethe=
r
> > > > it's real or virtual. Dave also mentioned some BIOS flag to indicat=
e a
> > > > virtual machine. Now probably the real question here is whether peo=
ple
> > > > are OK with CPUID+DMI_SYS_VENDOR combo check for now (and grow
> > > > it later) or prefer to having all identified heuristics so far in-p=
lace
> together...
> > >
> > > IMHO, it should be as much as possible close to the end result.
> >
> > Okay! This seems to be a right way to go.
> >
> > The SMBIOS defines a 'virtual machine' bit in the BIOS characteristics
> > extension byte. It could be used as a possible way.
> >
> > In order to support emulated IOMMU for fully virtualized guest, the
> > iommu vendors defined methods to distinguish between bare metal and
> VMM
> > (caching mode in VT-d for example).
> >
> > I will go ahead with adding above two methods before checking the block
> > list.
>=20
> I still curious to hear an answer on my question above:
> "Does QEMU set this bit when it runs in host-passthrough CPU model?"

Yes, the bit is also set in this model.

Thanks
Kevin
