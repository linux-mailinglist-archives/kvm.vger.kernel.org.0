Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30A483B30
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 04:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiADDtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 22:49:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:41041 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbiADDtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 22:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641268152; x=1672804152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YZarZMLbNzj3D7p5Ket8v0wpuz/BJF5mJ6aeu9fmc7o=;
  b=DBcYcx64d5RD4lpOvXq4yhe7/qtaFiLe9zS0Hcjj2hrHpVsjKJzLny3W
   StgQG2zUkVAMyYYzk9U/ZAanR03ZkJB5H5VJYgh8R3p+nn9sjVcEpz5N0
   Te2qHel3+P4d5IePPeolRjbDuHxfrTpOGREMa8L9Au1wAySwwqZbQ+cqj
   uKjdLrqehZzzSDcf24mk/axdOwduogFZo+KSQAE4iMp3muKGNFFfbpiZ9
   zsVf7DvYGllD8z4vZLWA82tayS1azMzEHiayINqAtaU9dXQMu7VWT1zd1
   rZrnq8hcfC2EcP1o8JIEzfeczB9pcOzuJrU1+b5dmnn73b5SMlZ6jCadU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="305504744"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="305504744"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 19:49:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="610936452"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jan 2022 19:49:11 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 19:49:10 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 19:49:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 3 Jan 2022 19:49:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 3 Jan 2022 19:49:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTKOjoeV+sTkBC6mM9sJNmAx5qbuAFGW4VoI44yTlaFjCTqSYTqzyusbCxZdW+js0w8+L5D9TSFI3hSJOaAIcJBXZM9hanqEOR+5kegB+/hXbeNmevZ8WTO4L2b0xvoO8JPeGKjdZGJT8ZHyUl4ZODZ+vmRFEVeP9NY0rapTlUrQzte4LzEjWYgnhQP141j6HEa36dnbKVLgwAbXlaUNm/840WBCxIJeH3TxOHhvnFpbLdfZvbcKojJCp1OzBPriCU6cfLJc/UAACjme/ZwCJDESnbuprrY0CWqsUCWM6B2dM462gxn1/T93hqOPCs9M1JZ13/gB1XZHSOq9K2Vspw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l00R3RNk9m6DXRgoOHS/uWkaBpO6Qrk0L+S1KBii1tQ=;
 b=gwYnVfNI16IANxsXBEoIabRX0CIVMbj29/r1Vul2ztK7s7L6VApwdbuinbxh1/mUnb36RhfkFTcGJdfmZQ+JyZIAl0p4dqVN70YskWO7c9J9gej6n/42rudhLwwIUUwJ2MidoYUrt6FTBLMZZNiML+YF2JvIZnxFLM22EgSgkVVIbfKmpz78BPgjJZlhXu2YqnbFtNp4xLX25PXmJOeOVhs6+csEux3HZ1exqTwPl5zIZ/fpdT1mQI0K6vxErUUGXgWX8w/alA/jYJVg2fBg+TP5HkZPHJOyBB5jdQs73Jhtc5Z4IBbPPorSd64l7J4QxJzlixv3QjMX2/74afALnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3651.namprd11.prod.outlook.com (2603:10b6:408:81::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 03:49:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 03:49:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaA
Date:   Tue, 4 Jan 2022 03:49:07 +0000
Message-ID: <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
In-Reply-To: <20211214162654.GJ6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a15ee9e-3878-4781-3f57-08d9cf352909
x-ms-traffictypediagnostic: BN8PR11MB3651:EE_
x-microsoft-antispam-prvs: <BN8PR11MB3651B46C2105A6D32FE9C79B8C4A9@BN8PR11MB3651.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /BTTlJsbd3aZ/g4vxGsUpQwqH/NKnwBzVPNQk+PZ5kmYPKxTdGaVpT+JpNlUCTORgLxrgqSxT8lnC3xoiDWFEoJ358BCk0bq9eq+B5pyiu5SuVzkEtnrOyjabRwhJniLap0Duj2R6FHqxL52CkPiVdgCGweC5KrW3X5KjBEkuq1IcJhWQMw+dVLCWIfzw17X2K1biaxA7CJXjOMwe1RuNzG4J+rglUCV2YgdU9g35Vt4FOiHVwmLBipkrGY25P37FoEqtNxp7+nVb/gt+5idQjI+8E6rHbAXQMx/dNw/DLhne8HBwTwP+xrQoAn8HBzMDhof57jBh4ufzGGf1EJTqKcEkAgELnXPJ977eiCUKhRU5XgbqHi07K2quAvSjGuCI2ty6fSxwHlLcw+CtW5o6pqEVLUTJCb44u5WM3IF0gTZptP5SVXV2T6WlLsdwJj1KgoCRDhpspfmAtFN4KEec2VLCgwKdJVfytzez855kX35CHgMMN2BUcU1hRtFac1GV8p7eAy+BmhrTYJ29jRbUhHzHkZ/9pK9WJQfPiS4uY38/IkZp4XZEKZnwZ7FKxoGKM3T3PNMl67iiY0d6hj6QQrOWNxJe8qSv3cAnjzgaayWR+HgcIB+i0uFU6qEwDYHbY6dj6WjN9CaGLp/SmM8Iivc58p08tQA1xdOys7iTCrIt4rDpDlsrYc55pM/Pz0qOUoq93yuzqg3gFB7KB6eDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(66556008)(107886003)(64756008)(110136005)(76116006)(66476007)(8676002)(2906002)(66446008)(83380400001)(38070700005)(33656002)(82960400001)(15650500001)(55016003)(316002)(4326008)(5660300002)(26005)(186003)(6506007)(122000001)(9686003)(38100700002)(54906003)(86362001)(52536014)(508600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5019cbWJ9HUTMow36r8TzicTod0k81W1nK7ymRhm7PXHiJM6Qkp0PoC0zJh6?=
 =?us-ascii?Q?qP4JK8oJVHq3ySHJVlqjsZ337mW8D2B7Vgq9o+QiQJeUs0cauDkr5oQqyWVW?=
 =?us-ascii?Q?zlGBS7QFYGyrjKtGExwfCa4TG3eggNQL63Ri9KZRMyuniWuIOmiD8V7g2ydn?=
 =?us-ascii?Q?0SKdTWzk2KS5oP9LpAk0w748Ajsix1MBCR+IQlQKBwBuBqFwXpDL0zE8qVG1?=
 =?us-ascii?Q?Rrz6Wmbo/RfvCDriKs+/ANTdgvfZPfIL36CwSlYTmnK0lDw4oCRqhfyTl9yk?=
 =?us-ascii?Q?De0RVSj5he6PJTs7ihBLJh85RWdfytaDy07KQpuuLTFQzhj6yba5/rEvAXpW?=
 =?us-ascii?Q?a2tqb4G5QAkuaRbWBMrGv7jbtX/7J/gOMEga2LWP/5ksOQqAgvQFNP8c8T0N?=
 =?us-ascii?Q?hFHmJdAu1OUP5HAbEnOwu/PeN2McHKHvfabQYS8nA/Qcz3F2OPvfYGLXzwHf?=
 =?us-ascii?Q?NjdOD9PeRVa1CLz/7YSlSFoVazjLS7rFpw4SkWCHVj3RGYHlDiZPen+Xy1z9?=
 =?us-ascii?Q?tJvEO3LYpCLtQcav5J/gYowCFUL1O/m6fkBaR6UtrstxBuNqAQ5jq1jCdVk9?=
 =?us-ascii?Q?Kt0b3bsucuNjnY/Lhi8bEnD35kxMj6u1M+VNrAsI6LVkrAvfKMvkM4KAJurj?=
 =?us-ascii?Q?bWdw7AZD8A0uDtfq43Y2Mz11yLTvqvDvu3yTq/qaa4v6wH0lL442A3LUJvkX?=
 =?us-ascii?Q?wrRel+hsHbsqH5E+MImtW9dGq2b4T9bsZIknsWta+MPXtPEvhT7nvP8hRu/4?=
 =?us-ascii?Q?R7+wixBQaMAnE8O/7WhaEVQGYz8EJP6wqY9DzLNBTKniX3s6FJRNvkIH0k7l?=
 =?us-ascii?Q?wzEE5jBIFwqDVTUthn+EXPGa7uX3zpcQwO3Zx53fLx35Fkmv0v5gfgf0PVRi?=
 =?us-ascii?Q?oYQJK9hqHWtxaJf38p/aVBhi5j08lShSrwDTho4FDRsm+dJEiP/RpAAaxhkm?=
 =?us-ascii?Q?lQlBOOfcnFbJSmGKvvyUcWaIjh6ayJDCOiVYvjgcdVExFvfyOLhYM18m8LZv?=
 =?us-ascii?Q?85eqrNy322yCnozvwxoCPUs20kI/ED9JqNv8Ye9FhTzcNodM20PNkco2LD7S?=
 =?us-ascii?Q?RRG3kDn5qAgZ5eiyUNKSKbDG0GNHdrDhZkbOMdDWZOsH1ptCymScABMzi9lr?=
 =?us-ascii?Q?WXlNy/GpziU3q7c/IVOERyDSMk4g0pmCrFpLOkVSih66QJDd+mjwSm7awgTU?=
 =?us-ascii?Q?MqMQ98Ddmd+ehcfZVMpbL255FY0cilZYAAYbPrG2XWhCglXgiBfnyN07Mqd1?=
 =?us-ascii?Q?5npSvFV2jTn97YNRqRbX4bwhkd6Fm9+27pEbnadthamBpAXBO+EnBbj/K0Uy?=
 =?us-ascii?Q?JdTTRb9o4WGPMZngKwNbBT2YMZHTCqK0Y+SzcvUZ0U1IcjvOnn63uZm0vx6t?=
 =?us-ascii?Q?2ouCGHA95C/nOFWK4mRiZAjINAk9/YcHA8GbDpOKfxMYF97FxYeh2WBbYgWO?=
 =?us-ascii?Q?4jMBPBIwvLWbvpztac82GFlceNegNMinuAOZg1QZVqy1MRHEh0vYda71NeoI?=
 =?us-ascii?Q?ejr/hGcNlJc9KgfJNpjceQq0GBF8Byl71SIAM/vwjpnJav3KQauVNE5CqGBH?=
 =?us-ascii?Q?jmWxWOYW+owgOXQK6xXZcMFQkNtdJGvUIwIgKRp6x6zTVFoNmZu8qDdcFdLz?=
 =?us-ascii?Q?jyAn/RSe9jBjDVAmbeeserM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a15ee9e-3878-4781-3f57-08d9cf352909
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 03:49:07.7676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFnB0yxmuE8Ux754DQrYYDXvl1/Fu/m+fjszxselSP9qJg9Ah9mjQYfwSQze0hHdQRmstg4XLCEB3J7o1EueHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3651
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, December 15, 2021 12:27 AM
> > > > + *          complete any such outstanding operations prior to comp=
leting
> > > > + *          the transition to the NDMA state.  The NDMA device_sta=
te
> > >
> > > Reading this as you wrote it and I suddenly have a doubt about the PR=
I
> > > use case. Is it reasonable that the kernel driver will block on NDMA
> > > waiting for another userspace thread to resolve any outstanding PRIs?
> > >
> > > Can that allow userspace to deadlock the kernel or device? Is there a=
n
> > > alterative?
> >
> > I'd hope we could avoid deadlock in the kernel, but it seems trickier
> > for userspace to be waiting on a write(2) operation to the device while
> > also handling page request events for that same device.  Is this
> > something more like a pending transaction bit where userspace asks the
> > device to go quiescent and polls for that to occur?
>=20
> Hum. I'm still looking into this question, but some further thoughts.
>=20
> PRI doesn't do DMA, it just transfers a physical address into the PCI
> device's cache that can be later used with DMA.
>=20
> PRI also doesn't imply the vPRI Intel is talking about.

This is correct. PRI can happen on either kernel-managed page table
or user-managed page table. Only for latter case the PRI needs be
forwarded to userspace for fixup.

>=20
> For PRI controlled by the hypervisor, it is completely reasonable that
> NDMA returns synchronously after the PRI and the DMA that triggered it
> completes. The VMM would have to understand this and ensure it doesn't
> block the kernel's fault path while going to NDMA eg with userfaultfd
> or something else crazy.

I don't think there would be any problem on this usage.

>=20
> The other reasonable option is that NDMA cancels the DMA that
> triggered the PRI and simply doesn't care how the PRI is completed
> after NDMA returns.
>=20
> The later is interesting because it is a possible better path to solve
> the vPRI problem Intel brought up. Waiting for the VCPU is just asking
> for a DOS, if NDMA can cancel the DMAs we can then just directly fail

cancel and save the context so the aborted transaction can be resumed
on the target node.

> the open PRI in the hypervisor and we don't need to care about the
> VCPU. Some mess to fixup in the vIOMMU protocol on resume, but the
> resume'd device simply issues a new DMA with an empty ATS cache and
> does a new PRI.
>=20
> It is uncertain enough that qemu should not support vPRI with
> migration until we define protocol(s) and a cap flag to say the device
> supports it.
>=20

However this is too restricting. It's an ideal option but in reality it
implies the capability that the device can preempt and recover an
in-fly request in any granularity (given PRI can occur at any time).=20
I was clearly told by hardware guys about how challenging to=20
achieve this goal on various IPs, which is also the reason why the=20
draining operation on most devices today is more-or-less a waiting=20
flavor.

btw can you elaborate the DOS concern? The device is assigned
to an user application, which has one thread (migration thread)
blocked on another thread (vcpu thread) when transiting the
device to NDMA state. What service outside of this application
is denied here?

Thanks
Kevin
