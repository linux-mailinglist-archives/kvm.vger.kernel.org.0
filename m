Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919354552D0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 03:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbhKRCm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 21:42:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:60296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhKRCmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 21:42:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="232823384"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="232823384"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 18:39:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="587026245"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Nov 2021 18:39:54 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 18:39:53 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 18:39:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 18:39:53 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 18:39:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9SH7h6aCY2OvHP3pjPCbhJsZ1G7VF5eb/94A7+F5NXEm8u4/FiYi8LoiJkxG3IRuEoQklsTvL8jBeYouQNCZd1sFRlLQXcOAPO900cjY/XVtCKBa1L7PfRqAMjGgV8JNZfiuG2qd0QjmYoKOqWh+cgwAXW28JTOFxfTteOs+gqbtq7EDJYIeEEgDvo060Io0VduUit9hAsZQG66Wg1aej+6H/nFpUWLqJeIGrwHrBkgtVpBKDBa5ZiTOn+VYhnxOMCWyEiRzlwA/n8XbGmsd0irP3SOx8DqPvEWwZ6kIVeCTp6c15BIGjvATRjiBcVI0odwMQc5vF6xicMgVMXDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpnFiToFMEay4q1VI7uINhjj9LIC+w3hpG78j2j3aN0=;
 b=MsX6GEwKRszyBFnLsPDeAEHOU4Lhs4BFZEWZoENmRR5i3GlsLmc2QrnG6qHIbGJx4TgpQ6yhvVkHj/GFCgdgD5Ln//GK2rAHRJVReGtmufyoePb4+lqFvU4yDqiHFTVpG+fIQQiFF3X+TTVzEHrRunlc2jsjpgWawSrJhBuAFjdYuS2aoPP1XTAudDj8NtNdHZtCeZzOlPCWuzPme4JHp2eRju++3D9zbECYgKzToZRgVe/C2YVdbzby/bREt6hdYuvyh982ob9c4/XbsoNnA6+sIfkt/X4xEM6e509PZ530nAIAVh3/MD+mplHJhvyYUjbLA/ylGiNsubImGVWNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpnFiToFMEay4q1VI7uINhjj9LIC+w3hpG78j2j3aN0=;
 b=rrYGhvsH+hWucdWm/sRvPRgojysx1X9x+iEe0OvIJCV36aJGEmOxMAURHjLYoXPes/EsIVrVwm0LkIIxhXWHIoFqTboLp5kpZ1dKuOudS87M7DR+Hoxrb4IKWk6KazEUo1A2aGly0lFzf/NOdGCSrPdwKHapXKCN1/MH5r5fR9U=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2595.namprd11.prod.outlook.com (2603:10b6:406:b1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Thu, 18 Nov
 2021 02:39:46 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%9]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 02:39:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Will Deacon" <will@kernel.org>
Subject: RE: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Thread-Topic: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Thread-Index: AQHX2cX72SW3lNH8302ZqE4v8PTHlawEkdAAgADVRACAAMX3gIACZvYQ
Date:   Thu, 18 Nov 2021 02:39:45 +0000
Message-ID: <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
In-Reply-To: <20211116134603.GA2105516@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dc830db-49dc-44d2-e58f-08d9aa3caf04
x-ms-traffictypediagnostic: BN7PR11MB2595:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB25954A88AA7800AD6ECF106E8C9B9@BN7PR11MB2595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R1RdvQjty1butWAgD0fdlK2OZLABsj2GRrzdx0GbL+P/ojagtaC3LpVZvPwOryiHNhl3mYHq5ZDazoBGGUY4QHFehDi9C7hyrGRTcQhrL5MxeEi2FjI5mvoCqDnpb8qpdYFrXipBM4JzYVoUsBJXh8J8biysfxvTkctkJClRo7UiNuxqpawm9euPrrCuuZ3UN2Pcm+G+3A/YpncantjLAkLX1Mftu8Gv6vo/dDJ+fCUeHGehzqXoELS+PeZ1ghwRZ4QX07BmGsDl4OTxE5bkTsnbZUfjBtJB6fIFhfQdn6Wt7pcUj/78irfl7XAcSdyX236aVBmFevfLXPrBFjlWZZ58Jnl663XpUIz8kr1+2o6TNW7ZZlp3bbs66SIbxuraCVx3cS2SyGzxvsFHZbDNBwfltbCsl6vkqbW32AGZiV3SEnCLZ62//Ihx+YLyPB4XL7Mj8oDvJj7k3wxZ/DW470OgU9lRfU8lN3PdPmCwU6q3rEuIcqMmFZ9IuLpGUFIdwaVxdHjLPGJV66zmpJ8gKaVdMwW8S+bzHozadwo2nKioZcS8/F8kHplK4lHaUiEXZk3FvitIN1C3cTRte1jiFalRp1Sh3a8TbUHZ/zo3ExA8zUFh8G8IDMxaNmGwW41ryq7qVnMWf2HjmecHWTYtSwa8A/3pUmlewpTFKPcfOReiiCxIoe1tQRp9LPF+B+2u+8UXDVRZ2nIfpU/xP10vjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(86362001)(4326008)(508600001)(186003)(82960400001)(122000001)(55016002)(9686003)(8676002)(76116006)(5660300002)(53546011)(54906003)(38100700002)(6506007)(7696005)(26005)(38070700005)(64756008)(66556008)(66476007)(71200400001)(110136005)(66946007)(2906002)(52536014)(7416002)(66446008)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LjfjAD/yGDubydGd9jMgvPZttgo2BJf1Mz9OaIeNoKdVCYUhYIKgVY7SyJwH?=
 =?us-ascii?Q?r0/mex3zFCPt4x3OJZuzPWhj5fsfqC1WJz1qk0PG1wC04FImrRH7J31yxdFY?=
 =?us-ascii?Q?VaitiXzLkXrhIq/k3MT+fFwAmWdiIQYk8On/YATH1qHEIE44pOVUlcx8/mOr?=
 =?us-ascii?Q?hsBpNErNSnuYvgBsRVFQQOO+HzRM2OB1ei+a2QdHxbGXvIZUwmN38nbeSjKZ?=
 =?us-ascii?Q?Bg5UKXa3pLPUI8RbBLc0v8h6ea2yt0Qj9NA2rux4tAVhpUTizkgal26mEZrp?=
 =?us-ascii?Q?vr+HGl90+e4nhRYRWqQ1KNxFSYAwY+E9Z79yyu60IgUZvWWreDbwhD9fEG+U?=
 =?us-ascii?Q?jSeMb0wlcnMezuX2UKVwN2fZC9mtb3eunyMMCixiZFeMGellgiQkAyxGnln2?=
 =?us-ascii?Q?cRcGliDXHHgBsh65iuwZ+r5RB4UNpHm9CxawBoouI1xXuNcU1KWZG9uE1Nti?=
 =?us-ascii?Q?K+BkH1tk+8ti/ejhmlRSKj53aANlE8gbjaVPwf7EutxeO4P/AKkOX6C56nvS?=
 =?us-ascii?Q?JZ8KJclutr74MTGqe7aUxgL8d96YEvLxT2mpWPOj0zM+xsGlZWTG9C8ckqdz?=
 =?us-ascii?Q?Jzu6sBVuO8nHpGBq3TPKG/1KS0BUhpB5jsva/OWTAID19G8qfulx13c9/SJv?=
 =?us-ascii?Q?SjioTAIPhzRW6M4ynkog4X8lGbuhTW/hHqyatTsDjgVdxYJORO2Sh5fmpouD?=
 =?us-ascii?Q?UGmEuFGP+oazJ5PsBbJl8rG9m8NBDDOMnYEvuwzOVh6vecn9Vzgvns4d0AH4?=
 =?us-ascii?Q?P2mTRBndTYnPJz2272R7ijfeKms8+C8QkUZzSw3qM9FFjvH5Pzt9lHrVGAOu?=
 =?us-ascii?Q?fKoYYMmFIdWoXh2Ry/XLbEI6CzHv7pd+YLkcCJQ1/Ha6FLbNfVanTWjP1A8l?=
 =?us-ascii?Q?DnyTnrw0zNJNUmSPYCrmDxGpmA/xmeSnws++dJM3vEKUzFnNf55+WKnYhOGm?=
 =?us-ascii?Q?7wsYg2KgZJnX4t5ZtaQ3pbeLHugOqHDFfwENY+YEH01v3nApCVScTtwk6r2S?=
 =?us-ascii?Q?aYfIds66i6Fjyv4hU8OwQMbap4fMPPcfCG/DvUWH7X2xwg9q8b3Mpt2CPW5T?=
 =?us-ascii?Q?VhENff7VXgVNtFnE4h7GtYhc+xxGC6RecgotJ9ni5Qv1NLCEv2GyVM7eegNZ?=
 =?us-ascii?Q?bA1/q4QPzMPMUBED4G/wRZlc1VacMtlwtKbEbKVhcEsm0XWlGOA9OwJzGbzh?=
 =?us-ascii?Q?RIaptVc9i/YckeoEv8XhCyuKauX1GHmou97l2CBWN28TtgR7Bd3V7rjILx+n?=
 =?us-ascii?Q?daC8yta1FNgRgPJrdsOJ9YItVd/MQGhBnFNR30QXgQSuW6ddLa9HPvmykzT3?=
 =?us-ascii?Q?gaTn+HfAZxbS8gilutsMmI6E/pIjQJgMfo7/d3eWN7W7LN/PnWTDOKIOhHQQ?=
 =?us-ascii?Q?EZCbKSWe2sRvMfELbK1fwP8mzJrHoAzAIDB/BcE1pH9T1wCGD0eDi/4m81OF?=
 =?us-ascii?Q?xayd2N8/DqiIu42ceS6Z+IN1JbJN0e8ykCynZIg/xi6LsoacT2M3JLaM10Me?=
 =?us-ascii?Q?I9N+dueb1uNIdSwInXTLycOmB7EjuYwzGkbv9oKRnUYAybaV7vc12WFxv1RS?=
 =?us-ascii?Q?+Sgtn25RdLJMztUHwdl1ySI5TLiCValN5zGyuVkTTz573em6aTf+BGlD1gJg?=
 =?us-ascii?Q?LWKawstl09SluqLY2skGOBI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc830db-49dc-44d2-e58f-08d9aa3caf04
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 02:39:46.0072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dFB7M00jl6Mm8mZeHxXlwzr3G/kEnssc6MwCQgWe7yWu6LF/SjPbVX7HOfZu4BrTkeDl+e0CJ7QxG4FpzSrfdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2595
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 16, 2021 9:46 PM
>=20
> On Tue, Nov 16, 2021 at 09:57:30AM +0800, Lu Baolu wrote:
> > Hi Christoph,
> >
> > On 11/15/21 9:14 PM, Christoph Hellwig wrote:
> > > On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> > > > +enum iommu_dma_owner {
> > > > +	DMA_OWNER_NONE,
> > > > +	DMA_OWNER_KERNEL,
> > > > +	DMA_OWNER_USER,
> > > > +};
> > > > +
> > >
> > > > +	enum iommu_dma_owner dma_owner;
> > > > +	refcount_t owner_cnt;
> > > > +	struct file *owner_user_file;
> > >
> > > I'd just overload the ownership into owner_user_file,
> > >
> > >   NULL			-> no owner
> > >   (struct file *)1UL)	-> kernel
> > >   real pointer		-> user
> > >
> > > Which could simplify a lot of the code dealing with the owner.
> > >
> >
> > Yeah! Sounds reasonable. I will make this in the next version.
>=20
> It would be good to figure out how to make iommu_attach_device()
> enforce no other driver binding as a kernel user without a file *, as
> Robin pointed to, before optimizing this.
>=20
> This fixes an existing bug where iommu_attach_device() only checks the
> group size and is vunerable to a hot plug increasing the group size
> after it returns. That check should be replaced by this series's logic
> instead.
>=20

I think this existing bug in iommu_attach_devce() is different from=20
what this series is attempting to solve. To avoid breaking singleton
group assumption there the ideal band-aid is to fail device hotplug.
Otherwise some IOVA ranges which are supposed to go upstream=20
to IOMMU may be considered as p2p and routed to the hotplugged
device instead. In concept a singleton group is different from a
multi-devices group which has only one device bound to driver...

This series aims to avoid conflict having both user and kernel drivers
mixed in a multi-devices group.

Thanks
Kevin
