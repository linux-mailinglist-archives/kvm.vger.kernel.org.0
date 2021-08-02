Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5A3DCEC4
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 04:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhHBCt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Aug 2021 22:49:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:32022 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhHBCt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Aug 2021 22:49:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="211498488"
X-IronPort-AV: E=Sophos;i="5.84,287,1620716400"; 
   d="scan'208";a="211498488"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2021 19:49:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,287,1620716400"; 
   d="scan'208";a="440346648"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 01 Aug 2021 19:49:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 1 Aug 2021 19:49:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 1 Aug 2021 19:49:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 1 Aug 2021 19:49:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 1 Aug 2021 19:49:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLKWBmyujwuAaEj5g3Qs7rHKbu8ntlLVIVYXZxB3xvutV+QCHIE5xhc1K+AGQTdg3baYp6Y/JRV/O+vHfoY/AgEhlijxrd3Kb+/6C+wt0cV57nnHBVRpKPOE2yhPxYyWbUgq+HUedzcwFzNaqQ26Jk0RnnGyz0CGjWnlLUyBva1+YpZ9wp/6C2IKM+gLp1ZZrqgppVnzEZ3lHEkLab6KMGxlrEqZACc30ayoDWm00pSgMxpeXBqVhrJtDukQBwThNnoos09ybCG634+tLMgt33zZ0K9NNQuFzYQB7FaB+xYO8q6baguSAvq4hi3ynQgxmdTTqehQqAR0v5nzbtExOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3H9okjLEqTjUGC6tW1StPvzyPunrUP7Fu5H1/4EEHE=;
 b=YQNIpngP8XEY3ZYd8r0o7f0YDop6BN2TNXoV0QmnN0i4A+6uCkRlKdXOtOolJ+vsEknGoZr6lqG0p/97rANFsG3p5Hx8wDvJ4NmMMwD0hWIRftdvzAwgfpsT8Lru0CRKEG2uFr8fyo4BYrxN9HjMe0Jj8H1BEKIXj04x+7a0NiUtytJwSODDD9mCgk/TXDyRu0/nYr7JeDGKMPFT6LJZPYWrHNnC+I4YgT+YIiya4GTePF4ET6N9EdvL30c4T9HY1v24FDNZqFRISEWeCRO3I38+ZMilTblOmneTJBThrM3VmiQaao0ISpYSWt0N7yWv+4uShvNrA3wD7VDvrbhGRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3H9okjLEqTjUGC6tW1StPvzyPunrUP7Fu5H1/4EEHE=;
 b=SdQFCUfoQvBC7408gfftwjqiOan7LDFUnTp0xiKjFvk/U6ajc6Fzc8JREHf7zXSvjpDIOaBuCgN4uDO0xxJhCaUR3QUZnOO7WpMTGuT8Mu7UpQCC4KQ/ElebQ8GIWMnUJDzu1zglupZNpfes5U90c+jjiUm7Guo+OtsnzhBUDZM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB2018.namprd11.prod.outlook.com (2603:10b6:404:4a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 02:49:45 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%8]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 02:49:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAN4kDIAAfDtbgA==
Date:   Mon, 2 Aug 2021 02:49:44 +0000
Message-ID: <BN9PR11MB5433C34222B3E727B3D0E5638CEF9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko> <20210730145123.GW1721383@nvidia.com>
In-Reply-To: <20210730145123.GW1721383@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65f6dafc-f0d6-4bde-b96a-08d955602f69
x-ms-traffictypediagnostic: BN6PR11MB2018:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB2018D05D0FD6089868505A1B8CEF9@BN6PR11MB2018.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgL0JjCfuhPkoY8MsJp9zEJ+TH9g4JJSxwL18oCFHOvmQSNlhG7kBDoSw1e3Yh8VayUFJ429qjfp/+UpBV+m697eCbCTaNwkN8DW7ehq2Sht0ZdJvXPF7OMWc+OlZ5IBUE7gy7BrYKSjF7ZPjtEopykcm7J7BqzEN3uNvTIipDTx6dALDyt1/tA39yMd08MDV2HCFL5WgP6AiM5N9pAdg792o2ua9GesfT9S4K65wA8K6vU2gcjYeMiUxiATwKR+RnTZtpGPYR/yTYtURXtYa35GI4rCvcd8sYLONM+343rO5KnttcvDxfft7sqE0O1Lq7nnh0s+PWZGNBO4TnK2HAzRRaupfUgvf1eqE4m4tn+JKdZm2MGR62hIyyF8jT8sRAs3ycF7qL0WgJrK+L/w7OxBZGUEk08g2rsN7VkskWDAyUpI0iMxd9czql5NLGlq2H0fq66M9T/897bP21X7Tq4bWxHI7pBWb0i5o38bglVVZdeYvp7ka7MfTrR2Kf+PXkPBT364bGDvCOPZCe1GXwqErJCGzr+YmAyXpNi1wSNnE9MqtxYoW1pOnEcl8d2xAazSwJV4/aKiSB9uw4cPSMM2YJOZKPiDZ3k3kj2M2eJO4HyaVrmKZZsGWsN2Mob1ZAODFy+URus9rJogItaeo7Y1m+fSBBXboWvxVu+5TTf4HXQces/wkJS2v3wp1vUJOD++QL7HUF5eMUrJ22wocg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(7416002)(2906002)(316002)(4326008)(6506007)(38100700002)(71200400001)(54906003)(33656002)(7696005)(110136005)(478600001)(5660300002)(8676002)(186003)(52536014)(8936002)(86362001)(66946007)(66446008)(64756008)(66556008)(66476007)(55016002)(122000001)(76116006)(38070700005)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3n3cX4nCDlpCt1I+3ZaAwGJqJkJ3Yc/AYD+Lm+/KlSm51elMXQYXc2MfJT6r?=
 =?us-ascii?Q?GnKZlRfFwlBMDLEcV4SDMax39eZNYHFZm+IGH9FrBc/OzPabFuLtdBzT1maX?=
 =?us-ascii?Q?iFtUpnnzHK+VLUMkfrw4BodEJRDr2AZNTVJaqYT21jihWTkFHQAx/cOcySeV?=
 =?us-ascii?Q?9tey+G3nNoBJGHWbfnZbUSX6moCCrsvvmgaMzPUTucFuV3jB3yS2rnJ/ywQl?=
 =?us-ascii?Q?r+fMwwp+yqdoMUN7sbs48TmZlTc7TTQBItzf/N+6HSjhgwYCtMiTOuT17Kmz?=
 =?us-ascii?Q?ItEo/Hba3Ze3Wo+2CxQQYR5QaD1FZPLH1UKSUf/jqSwwYZp0W5jy2tlsJf/w?=
 =?us-ascii?Q?yqmdWAOWJ1LkXSv85aADX2OC6rKkEitX7cI/wxX+ovamhq2HAvMtjoA18hKI?=
 =?us-ascii?Q?aviJtQ/sPNxe8UGhRK8KEZRBOX1Bx8wO8FMvYXKMgs8vpp/V7daPLoBg+FB7?=
 =?us-ascii?Q?+llsLiMReKo6/JP0uauJJzvYUbyodv7KzlQozMdsF9CftMwJNe40lxz2ORBf?=
 =?us-ascii?Q?60QawwfhNiQCwQ6LFCbYn5i5TpZX0zv1n1Nv5vzygnaSULs31s2936/yGieQ?=
 =?us-ascii?Q?tlsAmOKtanNWhPCMqcZJlGajLByQ3x+lorOy8U7oazSSNt++TqgFyLoEfra8?=
 =?us-ascii?Q?Me1CQwmViGOFKjhZSBvTf/t48d3jge64003nnzyLovNkqWvJJ5IyoYTJLO8X?=
 =?us-ascii?Q?bCo5Wdd9NLHSyRbWwWiAdI9OO2vxOss52XMQ1iLVxGN8/J5DjUs6L5pbr1qn?=
 =?us-ascii?Q?xIM64IXKUUxwnWFBXmhOl3H9J63r2nzxESKcHWRTcvxa+awoJ/6dfZIkUFTV?=
 =?us-ascii?Q?L2yck5eI40eYmSF6hnfwMaUBUF1RtNhLkBiCtYhIt+Vc5MpbL2YpIlJF72CV?=
 =?us-ascii?Q?IaxQZRhSmJwKSQHrXn7fuMo3NeGgABNTAfB++iAAzfkEmzJRwZpd+TwCFzQJ?=
 =?us-ascii?Q?JWzD1HarQHxLXDPQWeLmGijcxY8pVCWXsOrUNX72WwXXVt6NEimNQYj33kST?=
 =?us-ascii?Q?uCPp1SD0BhovMbiyRaeO1WWhYs25O+G204cDeTcNRH6PIEUnLNeoqVqWpxWl?=
 =?us-ascii?Q?RzxSYxYQ0sYi1sk18GctCD3zws/sglTV3DLS07YmCxe/BQTQ0xwHPSTuUmU3?=
 =?us-ascii?Q?l0utZQqAAynBpmuz9+jyJb9tvVZGDNakaDylT4xkxlnxSfrxrCD3lR1TYmL8?=
 =?us-ascii?Q?sz5Pd5dgDNyY0CTWNDN/WM2iP5QiM52RAMyH6eOVl+AQO9ywtzV4ZXgeuB5s?=
 =?us-ascii?Q?NORGbuEsrGnpiOHhIGfhTZ8n5yXKTt74xusV8NA4PItlMQEwO+EL7OUC+GGd?=
 =?us-ascii?Q?QtpR1G6UMqG9BnCOEOwkZPme?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f6dafc-f0d6-4bde-b96a-08d955602f69
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 02:49:44.8403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7E0Xf9LY2cW31wX+fYrbAP4xixD0BT5fF/ENp+7MrPGx0QZA+ayFxPnP86tZ0kTMzI5P4Xb9p8YcDMUp7PIXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2018
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 30, 2021 10:51 PM
>=20
> On Mon, Jul 26, 2021 at 02:50:48PM +1000, David Gibson wrote:
>=20
> > That said, I'm still finding the various ways a device can attach to
> > an ioasid pretty confusing.  Here are some thoughts on some extra
> > concepts that might make it easier to handle [note, I haven't thought
> > this all the way through so far, so there might be fatal problems with
> > this approach].
>=20
> I think you've summarized how I've been viewing this problem. All the
> concepts you pointed to should show through in the various APIs at the
> end, one way or another.

I still didn't get the value of making endpoint explicit in /dev/iommu uAPI=
.=20
From IOMMU p.o.v it only cares how to route incoming DMA traffic to a
specific I/O page table, according to RID or RID+PASID info carried in DMA=
=20
packets. This has been covered by this proposal. Which DMA endpoint in=20
the source device actually triggers the traffic is not a matter for /dev/io=
mmu...

>=20
> How much we need to expose to userspace, I don't know.
>=20
> Does userspace need to care how the system labels traffic between DMA
> endpoint and the IOASID? At some point maybe yes since stuff like
> PASID does leak out in various spots
>=20

Can you elaborate? IMO the user only cares about the label (device cookie=20
plus optional vPASID) which is generated by itself when doing the attaching
call, and expects this virtual label being used in various spots (invalidat=
ion,
page fault, etc.). How the system labels the traffic (the physical RID or R=
ID+
PASID) should be completely invisible to userspace.

Thanks
Kevin
