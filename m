Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A714754DADC
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 08:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359234AbiFPGkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 02:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358699AbiFPGke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 02:40:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8771F56FA5;
        Wed, 15 Jun 2022 23:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655361633; x=1686897633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+nfco/YnimOw+M+FtBa9xY1hx0crAnA91SKxyclMgiM=;
  b=Bc6KrsN/zcfl8K0MgWUw3q8ljg5Vh6tfEZE+o6XJriYh0nDpzEd/hPaM
   zcJQjSzsRxwpAYjOsjQi6baDOBBX/hiVwVBEwxmGHXjkU8ACZx2s1n8UG
   9uThP2J7fKHgMoqARcC2gel4Guua6gk6n4+zMgeagcngeIJFRYH1tp9GQ
   tRK53ZHsyFlVxl//hzeHoWSjTWNixrv94WGkBf08XffvvEfhkw9xu6Dyr
   Ks4nkmvRRImUfKgmohO9M948mVcVIO8rG34qObSuSXsUKb1gyQBw0AVyV
   N5t1s4GfEmvItWYqmWZAso3wwgO6eio20hbgYAeL2y4boXfUqzDsQOoL2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="276754036"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="276754036"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 23:40:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="653028808"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2022 23:40:21 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 23:40:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 15 Jun 2022 23:40:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 15 Jun 2022 23:40:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/ZFAQu8/uGjO3oaWf6u5xWkafkt+Llp6LrJ4YOCzJDWJv9c5nXAmPsbqqGy/wWLZnw1IIOe9FOEbIQWPBFwZCDweK84487EdA5HlC54Ep3iBFtKJzOFkDwruY0dAMX3Bs8CKi1ZouGMOXiIItOcB/vv6rrGvPfneWQP95ILamzbVboBOoQuG/4pQwoujgBj8aGOzLQqr6nM6cD/LMppq6NvRiph+1guzA5AGADldJyQQKT2x0/ypHLJ1KQRIXl4YLN3ktqZTWPjiLoDYqTKsTjkestbDP5GosubuIaKSjKyH+eQjWjgZ+dCPMubFVgHEycLvgoSyzYwYmQDPbXjlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nfco/YnimOw+M+FtBa9xY1hx0crAnA91SKxyclMgiM=;
 b=hrgMab7/XWPwHoG1eUKrezuMx6nLWN21e+chzlYGPzdsiHR4eq6z3vSIHW/b4mx9VHDB582UFZEE/xio7PScXZaIRmBoYsqN4UFzEoJ2fVMqjkBYunPLGzyy8qtps0Auu8qp8l2MgqsnUYT1iHW2veE8t2c5IgJXCO9K7C8qmHJoyYfHGvQEXpJskH/FpvFQyB5BhsPfJLrPjbXlNn4aPH9Vj8P4kdpV6H+ueVxOoob0vv/f4gE0xYSWl33OD5fnhqHt53CdkW5C7eQRlAfmPqCM9/nr9B8KkeWSAOG1SqzrRt3DPo6xVVqaBig7ZzCkFfMx0TEmDTYkg7XMhCg5hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 06:40:14 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69%6]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 06:40:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Thread-Topic: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Thread-Index: AQHYgRSGh5VNWlGZFU2izdpXwolvG61Rkriw
Date:   Thu, 16 Jun 2022 06:40:14 +0000
Message-ID: <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
In-Reply-To: <20220616000304.23890-4-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e90be828-31a3-477c-0f8e-08da4f6311c8
x-ms-traffictypediagnostic: SA1PR11MB5921:EE_
x-microsoft-antispam-prvs: <SA1PR11MB592187D2F0591A20856F122C8CAC9@SA1PR11MB5921.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b4xcTcwz5eVBGFk74nCe1SGiehBd3y4jDK7nFvmL/w2fGxAzL6yCuDzLf4J6uR5DXKB6+PKq2P7RizRtfEL5HGP1tmAaIqxTmChypeWcVZNRkRw3BVJBNRoMVS6r7vmkiR8QrzXJ0Q1XGETndQY+hKqQGZ2N0vDOESDDOPQyVSmcVDcu89EfngRYR5Dfr7vtsWtS7cUwllH62vWRKDO56crBlHQBWtiYJs0Vbzz/uSV9P/4TyZinWzQQ27bM0cCxtglc0gs4Vek8bm/+SfjZzoTupY+vim6LsNRbJv5DzZWb4E4R3OvCuRR4eckTkve3UL5qTgh9jy6PhccDDcYo6B1AvupG0E4QThBy9dyKYn1j0jsj40OMMjt5kZHXYSbcqKKrlzofi2eQGX3p+nJASTaNWyFFYA+bScOd82FCArbffEftqdw4gAKUkRH/71sCCVBZ4tJubAjVZS17/oMhMOPAzvdI0sRoWE2BhQwmZsRNyNIg+Ucstb9MF/1QsJC6eUs9MoM4dQEDQ8KYHB1eUQdGhue7ZH2QfZyIzx4zUM9NHU2dYDmfNf52x8VOTfocmGgsPSk8s8ME+wfjC+Xkag5HxJMamViPL16bb3QgEvh7JBakAsmu6kTJgKlQ4kKi1TrQY5f7D+eO78TUDl69jssPIsmmI9/ZOo9mUKDnr2paZxmTPysCdTXwFdnsyTkifiV/9OStxHctuiT5lu/ZpWOxD+hm2JIev9txw5BTaQSnBgc73u+qTUvDVj9Lj6YvhXQNU8dhuk6X8NCCyYPI3QXYSYU9XfTTgHbY8UiquBgtGpn0GPYkgUNJSF0XUTPI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4744005)(54906003)(55016003)(76116006)(7406005)(7416002)(52536014)(33656002)(26005)(921005)(86362001)(122000001)(71200400001)(5660300002)(38100700002)(2906002)(82960400001)(8936002)(316002)(7696005)(64756008)(8676002)(66446008)(66476007)(66946007)(4326008)(6506007)(66556008)(9686003)(186003)(508600001)(966005)(38070700005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RThrTjhXekMrT1gxL3hnczhwTzFoSnh6OG8vcFRac0xScWRxb3pDaVY0cXhQ?=
 =?utf-8?B?VFlQQXpudTRCMzk4ajRxaTZrRnBRU1BCMVI5OWNkclhBckVzNEVXZFZmTEx2?=
 =?utf-8?B?bDNpbHJKNTYyN21sendMNXBvR3NJS2g2dFhOWU1kazVhaDJIMXV5NjM4V3p3?=
 =?utf-8?B?S2tPaWNoczhQTm96S0g3TlR2VmgwcXlLK0FjNm95ekRJWDVGQXp4WWduUVFN?=
 =?utf-8?B?K0xPSUVyNWxJamQvZ0YrTVpBMVBpQkR2Nzhya295bzFaYy91S2Z4OHhSUGR4?=
 =?utf-8?B?M1dSRkZyUUZFRHpyOG12Y2tNZllFVEpkWFpnM2tJTm5nUENpZUlYZWs1YlRN?=
 =?utf-8?B?VnJ4UldvcVV1OUNXNHFTZjBNQ0RHL1hXTUJOK1dOV3BLdnpISDVHTFZmQTR5?=
 =?utf-8?B?cmN6VWxldERNSnhjZW1mQVpHV01nRGNqQWFqZ3oxV0t1dkZZd3NOUXArN0ha?=
 =?utf-8?B?eGFpc2x5VDc0c0RPdG8xWW5Zc3pjVVgwK0NlQVBTYVFrQjdoZFZadklKVGJh?=
 =?utf-8?B?RldFL201d0h6c0dnd2xPY1QwR1paQmQ5Lyt0eWRqUWhscEQ0LzZNcFlCZXlr?=
 =?utf-8?B?OHA0L1lVdUJYdXFzUGtSVGpySTQ4aEZQSi9hN0hpVlpGSWlvcW1mVUFCSmE3?=
 =?utf-8?B?N29zbHNRdzlEVHVYeVBxdXdrZFdoUVNlVi9oMmVkMkpjdUhzVXVnUjNGcTNT?=
 =?utf-8?B?dkRIOGlGaG1pUVRBa3pleGFoNFZwSEVlVmcyR1pQU3IwM1F2OEw3Rk9yaVBY?=
 =?utf-8?B?ajAyQnZoQVlBbzBWWFVnWnEvL0JqRVBnVk1OK2h5SWFoOUczZmd2QzZJY1Zq?=
 =?utf-8?B?SU40STBhUy9xMTl2OXc3S3ZNZ2FkdUVETDIvOFpFZlR1WWVPQmlIOWdTaXJs?=
 =?utf-8?B?TCtUQzJvT090NXY2cFYrSDMzZnk5UkRxYktEQ2hMZUlvTFpKZ3pLRW9yZncw?=
 =?utf-8?B?UUFvU1RYc2lVcmZLZ2VFWVhSN2FpWThVaFhkWnM4eXQ0MFVwaCtDSTVWd1hm?=
 =?utf-8?B?NFBZb2tGVjE4OHZBQmoyUjVFODZrbUoxTmZTT1puSWw5NzlpWjEwMzE3UEhv?=
 =?utf-8?B?MDNFcDVFTldXZVd5UnVKTEtoWWtPZkgxeG83enF2UDRCZ1lKZW42aW5Xb0cr?=
 =?utf-8?B?Z2YvM0tkT1lpT2pXM1lYVzdZS2w2TDBUaE84dnJFemJqbzg4L1lvYUs1WFRG?=
 =?utf-8?B?YWF6TmlacTQvZTNnbG0yZjlMMnV5MElhUmFVWVJFaVdJNmY5N0d3dFg2TDls?=
 =?utf-8?B?bVN6czdtS2luZFFGTkNmOHhkRnFGZ0lkMEVnTzNJOGo0eGF5TmtQUkMwQ3Mw?=
 =?utf-8?B?YlQvZ0wvUnk5S0p6YlN2VWg1cERMaEM0bHJFYVI5WC9idWRNTnBNYUNPVkh6?=
 =?utf-8?B?WUt2RStxREFma1V3M3dpQjdJenFnWjNURSsvYU1ZbDI5bHlVN1JuZjZNanRD?=
 =?utf-8?B?ZUtsQm1UVE90aDVYYVdQTmdWNUQ5SzBISEUweWRZK2J6LzUyOUlHRWZOUGpy?=
 =?utf-8?B?RmtmNlZQRDlRZFlYcGlCQ3JVWGcvY2xvaStnVGY3eEJOSkFLOWFkUmlzdk51?=
 =?utf-8?B?blJWRHp4RjBCNnhBaWc5UEtsdWZzWU9sOVppNnZWL0lpV3ZSOGVUK0gwTXhv?=
 =?utf-8?B?VUlhamRYbHlEOURITE1rUFh3czdlazUzWjNlWFZLOUlQcmlJTzZ5by9qQTd1?=
 =?utf-8?B?d2RXWlNlQjNmV0lKNG1ocFNxVGNLOHJLejhyZzh4a2RZSkUvRVR5ZU5iVGpl?=
 =?utf-8?B?R2dGbXdvTFZsbHRVSXJjYW5aWnBRMmRScWovS2N1czJYcGFDeStkN3p1L1lv?=
 =?utf-8?B?ZDdPL0VPWFJPQ21YUFNpN3gyYThBYUhkb3pkTG1JTTBjUHV0emdJYlJLeUxC?=
 =?utf-8?B?Q2kvazBpUHZWUUVYTGpKZWdHY3ZSRnJkcURDMVRZOFREblRuMU1UZVVoMG5t?=
 =?utf-8?B?WnB2TmYwOUpXNjdQNERzUkh0cGI3MkVEL04zWFkzbElzWk9KejdqdElIbEdk?=
 =?utf-8?B?MWIyQk5LUzgzR2hNNmFHZ0M4QlExKzV0TFVrZXhoR2ZvMDZFMlpwVDNIY3pT?=
 =?utf-8?B?SitON2trd0lhTWxMN2VWblNjS2FZelgyZ2ViTUVqd052TXV2K2VWdjRlaUsv?=
 =?utf-8?B?cTRhWHBIYjcrbU4yZXNtTXlvRmRJbStDQkVKaWFpakpNMVQ1eXA3NFM3TkRJ?=
 =?utf-8?B?dDJ3ZktGc1hiam9TZ212L0J2YXVrVitpa3BsSGJia2xYT2tlUzcxSDNSMndN?=
 =?utf-8?B?Y1lHSXlFTHdWdlh5Sjl3bTJrK1paQ3RGeXo0bVgwMFBUWGEwQUxwRVJWRHNF?=
 =?utf-8?B?UjVxelYzUE4wS1ZtT2JzNGhkZDlZYVptblFzYm5BdlE3WGRRT2Nudz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90be828-31a3-477c-0f8e-08da4f6311c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 06:40:14.4558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o52ctLCHYJu68sj97+tHVQUANz93iJAl177OjS9u8/tVekxF53A/s2gA2/KFaEi5NF7kuXc2FWOfjCqG1ijaZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBOaWNvbGluIENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKdW5lIDE2LCAyMDIyIDg6MDMgQU0NCj4gDQo+IFRoZSBkb21haW4tPm9wcyB2YWxpZGF0
aW9uIHdhcyBhZGRlZCwgYXMgYSBwcmVjYXV0aW9uLCBmb3IgbWl4ZWQtZHJpdmVyDQo+IHN5c3Rl
bXMuIEhvd2V2ZXIsIGF0IHRoaXMgbW9tZW50IG9ubHkgb25lIGlvbW11IGRyaXZlciBpcyBwb3Nz
aWJsZS4gU28NCj4gcmVtb3ZlIGl0Lg0KDQpJdCdzIHRydWUgb24gYSBwaHlzaWNhbCBwbGF0Zm9y
bS4gQnV0IEknbSBub3Qgc3VyZSB3aGV0aGVyIGEgdmlydHVhbCBwbGF0Zm9ybQ0KaXMgYWxsb3dl
ZCB0byBpbmNsdWRlIG11bHRpcGxlIGUuZy4gb25lIHZpcnRpby1pb21tdSBhbG9uZ3NpZGUgYSB2
aXJ0dWFsIFZULWQNCm9yIGEgdmlydHVhbCBzbW11LiBJdCBtaWdodCBiZSBjbGVhcmVyIHRvIGNs
YWltIHRoYXQgKGFzIFJvYmluIHBvaW50ZWQgb3V0KQ0KdGhlcmUgaXMgcGxlbnR5IG1vcmUgc2ln
bmlmaWNhbnQgcHJvYmxlbXMgdGhhbiB0aGlzIHRvIHNvbHZlIGluc3RlYWQgb2Ygc2ltcGx5DQpz
YXlpbmcgdGhhdCBvbmx5IG9uZSBpb21tdSBkcml2ZXIgaXMgcG9zc2libGUgaWYgd2UgZG9uJ3Qg
aGF2ZSBleHBsaWNpdCBjb2RlDQp0byByZWplY3Qgc3VjaCBjb25maWd1cmF0aW9uLiDwn5iKDQoN
Cj4gDQo+IFBlciBkaXNjdXNzaW9uIHdpdGggUm9iaW4sIGluIGZ1dHVyZSB3aGVuIG1hbnkgY2Fu
IGJlIHBlcm1pdHRlZCB3ZSB3aWxsDQo+IHJlbHkgb24gdGhlIElPTU1VIGNvcmUgY29kZSB0byBj
aGVjayB0aGUgZG9tYWluLT5vcHM6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWlv
bW11LzY1NzVkZTZkLTk0YmEtYzQyNy01YjFlLQ0KPiA5Njc3NTBkZGZmMjNAYXJtLmNvbS8NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29saW4gQ2hlbiA8bmljb2xpbmNAbnZpZGlhLmNvbT4NCg0K
QXBhcnQgZnJvbSB0aGF0LA0KDQpSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBp
bnRlbC5jb20+DQo=
