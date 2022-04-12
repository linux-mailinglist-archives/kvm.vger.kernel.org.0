Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285424FD60D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbiDLJ5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358157AbiDLITT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 04:19:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A15024BFA
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 00:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649749493; x=1681285493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vpmkWKOQA5KN5G2j2WoeQhABOk1zzOZZhxhKM2ovmOM=;
  b=D1mKo1ZHvs08/RJOxkhJ9GLhQQ7ZeGh3pWGWBsQwDAgsyUrAvuTk+Jfk
   OuoROAlR0kqM5vBWEXj3eoLn8vYqkxCvvYCPwIM+gBmLpaXp2bjU44JNK
   DfDQvqINyZ4DqwlRuFJtTopnbKaHBGpQyOqCTQqlaLhtEA4Yh4XO2urmU
   hKRNKFE/su8PtkKvyJm5pbZTHhVH9ClQ38oJC0kU6Bs3jfrsk+d+JP4U0
   OLR91NrH2HvDxYfpn3MkMzFggA/UZxqBo7GKYZFuJE/Wt1W0muubOkRr9
   8cYVBZzOL1cMOl59r5xFs7OOO3leaazYUbV+cD+pmNxrcGXVioDEp4lPk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="287317250"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="287317250"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 00:44:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="660381282"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 12 Apr 2022 00:44:45 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 00:44:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Apr 2022 00:44:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Apr 2022 00:44:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpqAYyFmdbi7gTU9fncTn+Cag20w2a5wmQuVSfnbhAUd2MhwVcEg07FdJt43MTX5tFetG42Yr2mxxOofX3hYbPMKkPEE6Tofa327oBeflTWUtewl9ejRxVdiItwCGy9rcEWJ2l3gM4jL9X+63l4Pucx0OPFnlZrYF/GXuiWa7OnI9lkQWriLntGZX/993PpRhv8Jeex5AjPDqA4nCVZ9q7oWTgcVodhMT2JODmBRjv3ptc6R4Q7uhvfeCVgS0RQF/ngQija6TcvAGWnnP0UIOYBk+tzLoji2lK7TanXBWUOFOenHA2xnrrdAJnSxZ97KsI9t8ublAYm+zzlgKWNxCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpmkWKOQA5KN5G2j2WoeQhABOk1zzOZZhxhKM2ovmOM=;
 b=hxE97/uxtb2+2cqXbSwkq2r3KehRMGMHRCvozgGU7hyechtW8Vw6eTYNGbUuhbCpwgOlk7SVP53WpFCpl2iyRzx/286FH5ZMeXBQASEhQ4aMQFMhKqzrfX8WdQnZVIFVTPjRhjwdQowK0Pvg+FRPi7sG+P63IKOowianiANzr8SIHpUtGKOKKWGwkxUNSPBljCZU1Xav32hKJAZlDm4Md+SQUl2e11Fbrg1LV1cnRdGdBoK2yDfQym9E6aMKn+ZLfhaQ/edTGfY23YOGVWwheP+mUieEawI9bJAfAnzNuU8xaQibIeEWMdv+PjCBVKqVmAWLxhuxPOzjuuAF8agL3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:44:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 07:44:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Topic: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Index: AQHYSpODjq97KCkZqE+HgacEjq1/gKzlqx6ggAHgngCABGEPsA==
Date:   Tue, 12 Apr 2022 07:44:43 +0000
Message-ID: <BN9PR11MB5276FD53286C0181B4987C958CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276796235136C1E6C50A5AF8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8df77a0f-55ee-bbc3-8ada-ab109d9323eb@linux.intel.com>
In-Reply-To: <8df77a0f-55ee-bbc3-8ada-ab109d9323eb@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9972d6c3-1342-458c-0198-08da1c584f39
x-ms-traffictypediagnostic: MN2PR11MB3615:EE_
x-microsoft-antispam-prvs: <MN2PR11MB36152F6753F32A35693ECBEA8CED9@MN2PR11MB3615.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e2SVw3A6EDUT/59zPwSLXUqVWtRoWEqLIWyXMHXeYT1fjf5EfgqN3kt77UPbHHlkLS+QQE4AZtKxRHD5zodCqzym8fQsK1iaRB3Qsq+EdPzVnUCnjeIhwbocwjrNsLmCIn+6rX0BFXMivYB6Wp78Q9U0c0sV4i7j9q0+M8JVyByYaNMoJkUxwn63yFOfKrZBskoz4AHcgxnV+TtBa8JH7BGDTgZoM5QWU/rEmMc9OXTzXmVHoLBNXIddL84pHTvMJ24OGFSLQbzH062bU2nsI7KN6pIZI9BFAbxtpCWklLD5jet6i2fvSNigckcMOpeiCMwh8Pb3fspJhjfO1f9FLQu2yedaNBkpUHY+DhnnI8jF80EuGivjJz/TDHSdYAALsFurZ9RHl8ya/0w0V/w1fxAhdwFahJ1FgFL3ZKWiVnVO/cCrA/THmS11+vmG/3BuWJoi3JgBlFDOgB4OdD/5HBy9l3NWMlgMI+otUPbA1bNjfWRu74pQtI5rP0SoIqwbd+TXNXmyq8o9YfjXm4z/AN4tE2705Hz36Ph4/ng3A7fJ8+of4CeQypzt6XrN3oRBBWPQHAq155yXPVMe/tBN0HUILkYJOjJci3vQdikZUAt3B0V9YAXjMuyEAepAGQKQx96C+VC+ut+Pb92O5trnbN4Ob9icu9Fa4W+p2tcL24QbGfNLIBzhM+RerlJ87JVwiDy8d+MnYcqazk/VkpyNEVDbbMqVfyLsffw1gvvIUaM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(82960400001)(122000001)(53546011)(9686003)(921005)(38070700005)(33656002)(2906002)(83380400001)(508600001)(86362001)(316002)(52536014)(38100700002)(71200400001)(7416002)(8936002)(5660300002)(66446008)(66556008)(66946007)(66476007)(76116006)(6506007)(7696005)(64756008)(110136005)(54906003)(8676002)(4326008)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkYwOWl4NGFNS0c5UGxYVStaVHp2SHI1NXdXV2d1a28vNmlaM2svaFgrdWg2?=
 =?utf-8?B?RG1ndlNkUG53dWVaa0pHOFJEVFl1WjNOR3hxVUwxL25oMTVSRXEyU3NnQU8y?=
 =?utf-8?B?ZmpDZzRDQkN1NjcySW93YVMvTHlIMlVRVHVtK2dkdWFhMzd0aVZxRjFFa1hL?=
 =?utf-8?B?MEgySGQ1NloycFFuVmFtTHZhaTBlemgwM21VbzR6OVFTWWFucDRqOFNnTCtz?=
 =?utf-8?B?VG51NlRjc1Q4a2Nxd2V1cjRSYlJyTGRiZXNhQVROVGxqVE8zRW4vUGlHTWk2?=
 =?utf-8?B?U2ZPVjVjOXZnanhhS3JyZU90OE9nVE9GVVVhMnY4cGxhM2xwbUY2cFAxSUtO?=
 =?utf-8?B?ZzBNVzFnam5Gd09sWllQVVRMS2Fjd0FYOC96TC93MFVsNEhZNVNMdmp6VWk0?=
 =?utf-8?B?Wk9UN2RRNWxEWjNVV2N1K05VRjAycXZMa25aZjBNTzdCcnl0YUJoTmFneEZz?=
 =?utf-8?B?QmhCelVVN1ZnZUtUZkk4WWgweFBwYkVqejlzcEZlNnNNMmlVMjQ1aEJiZGE5?=
 =?utf-8?B?M05pVXFkeHFVTzBha0NaQnoyczJMelVRWGNodnNNdXo3Szg2NnlkRjZFZE55?=
 =?utf-8?B?SXkwTXZ6V0NrcUFvdGpobkhCR1BnazV5aDlaZW1UN0FuNEU0VnlRdWVlK2Zi?=
 =?utf-8?B?SHJ3cXY1cjV4ZzVtSFR6Z1NHQ3o1K3JHYzVVYjEyVGdvZmxYT3ZTT1JEUGFQ?=
 =?utf-8?B?TndVZkM2QmdYUW1TdFMvNnZuL2lqem1OOFp0OHZ0MlU3T0hCQ3JOZ21sb3FK?=
 =?utf-8?B?VlgzV3NraHJvd2xhbzVuOWtvU2Z2TUl5em1CWWxZNzAza1daaGxZRUpqazlo?=
 =?utf-8?B?cGdoT01lUk1jaTBCaTZQdE56NmtyNFNvZG9MdzV1eE4wTVM2ZksrcDFVbDUr?=
 =?utf-8?B?S1AzNGpCVU5jRVNIM0ZYaStNM2wxUVRSZ0ZsZmFOclhDdlFEQUczd2JiYlE1?=
 =?utf-8?B?bkNTaGpXNmdWL3ozMGZaSlIvSjZoNlc1cVk5b2wvZ2dDdzNzQzBkZnBXRDJC?=
 =?utf-8?B?Zm5FV3pNc1lnTFpzcllhdEh6TXJlQlc0RjBoNUpTNHpHSHRaaEtRcEV4MnBQ?=
 =?utf-8?B?dHdVMHcyUmQxSXZQSE1ZWjhmN1BMdENwT3h1Nk1hVHFVbGQ4Ym1CWnIwUGQy?=
 =?utf-8?B?YmNhM1NjaG40Uk5IUSs1aEp4K0JmQWZOc1ZlUDM5VWx1cXdBNExlSnRkOVlW?=
 =?utf-8?B?TTA1NUlDRFNHMFFQeEwxRFIxN3JUbXRPcEhaY0J0Q0NXckl5aWN0cjFJa0Ji?=
 =?utf-8?B?a3UrZjNPTzRvMW40dHduYnNvdjFjd3ZGckpwbnZpOEJvSExMSzJnMnlsOStE?=
 =?utf-8?B?dG5NSmJmdVo2cUVQa1d6MVgxeis1ZVZXaFBvbjFzOHJXZk11M0tFeER4T3ZN?=
 =?utf-8?B?bXhTdWs5bGVyTmMwU1BINmdjTjlZbjA1NFpaMXVLK2lQOERJcmVuTThGWHJx?=
 =?utf-8?B?VWM5M0pVUi84NnZRcFpsa2R6bGUvSTloT2FicEFiZnRJdVU0Yjg3Q2FjUW9B?=
 =?utf-8?B?S1cwVzFzY2pyenc2RWlJbVpVZGcrN0F6a1RnV042UVcxbEgzTnBacHpxRzNn?=
 =?utf-8?B?Y0d1KzNIMTh6SFdxZi9xL0l0SjdKSHE3NUE2SWNFVTFYUWlzVHYyNDBHSXZF?=
 =?utf-8?B?NzFQWmE4ay95YUp3MVBUd21oM2E2Q1NhMENucVlaSG5oeVdHMTlKY3FxclhH?=
 =?utf-8?B?THNwM2xDcXFjZFc2aGRFRG5Bdld5UENYK0hNRExRcEJ6QnZ0L3dCb1BISzZI?=
 =?utf-8?B?NnY2MEhkN0FqbG9HQmozM1B6cGVwWjZGTW1MdkhGWEc3VWc1WEMxNGIxVDZ4?=
 =?utf-8?B?cHNHeVYxSzZzQ01LYjRsVnZaa043MmdRM0RxaC9ndEJaTytkdkZmWmhuVHlN?=
 =?utf-8?B?dzh1cVB1bkxEblBwbmZMZVZQTERnbWY0ZUVYd1JzVkRjWE5LQjZ6YW1tMGo2?=
 =?utf-8?B?dEpJL1UyRUJSTXFJMWIrZTVmc1YvN3JldW15akR4RCtDSFRWbHlyQUtQd1Jl?=
 =?utf-8?B?bGpKbG4yNW1ER1MvQlJYN2NzUVhockJGK1FZUmQ5YXI2QWViMXkxV2NIbEVM?=
 =?utf-8?B?MW1YVkpweTRYNFlMNDVVZVBMbWpzNjlHK1pQUVZ3ZTIvL3VKWEpWQmlZYzVz?=
 =?utf-8?B?R2VEdWEyb3J4OWh6cXNwUGRNQkhkK3ZzVjRsT1o3OUU1SDFpUGdOSjhOUXF2?=
 =?utf-8?B?UWRHckxhckx2SzdJL2ZuQkwrVUVLQm5TYzZnSTlSbisrd2Y4VXROamt5dlF4?=
 =?utf-8?B?MFlYU1BmeVpkRTVKQm5HcmZmalNiaS93WWE4bndOcXV5S0JGY3hhV3pka0pS?=
 =?utf-8?B?c0hTSm5HK25VVzNja3Q5VjJDWUFFRWQzZjlmSlpvblBHbmpwUGhsdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9972d6c3-1342-458c-0198-08da1c584f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 07:44:43.6776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyv5aXvsTgO4Z+6CKwN33DvzXXGYkgsDI5rxNz/zwA1fliXUwAhI7u2goDI0ArJG9WdKdkLiTLHoLn++J/Zr1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXByaWwgOSwgMjAyMiA4OjUxIFBNDQo+IA0KPiBPbiAyMDIyLzQvOCAxNjoxNiwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCA3LCAyMDIyIDExOjI0IFBNDQo+ID4+DQo+
ID4+IElPTU1VX0NBQ0hFIG1lYW5zICJub3JtYWwgRE1BIHRvIHRoaXMgaW9tbXVfZG9tYWluJ3Mg
SU9WQQ0KPiBzaG91bGQNCj4gPj4gYmUgY2FjaGUNCj4gPj4gY29oZXJlbnQiIGFuZCBpcyB1c2Vk
IGJ5IHRoZSBETUEgQVBJLiBUaGUgZGVmaW5pdGlvbiBhbGxvd3MgZm9yIHNwZWNpYWwNCj4gPj4g
bm9uLWNvaGVyZW50IERNQSB0byBleGlzdCAtIGllIHByb2Nlc3Npbmcgb2YgdGhlIG5vLXNub29w
IGZsYWcgaW4gUENJZQ0KPiA+PiBUTFBzIC0gc28gbG9uZyBhcyB0aGlzIGJlaGF2aW9yIGlzIG9w
dC1pbiBieSB0aGUgZGV2aWNlIGRyaXZlci4NCj4gPj4NCj4gPj4gVGhlIGZsYWcgaXMgbWFpbmx5
IHVzZWQgYnkgdGhlIERNQSBBUEkgdG8gc3luY2hyb25pemUgdGhlIElPTU1VIHNldHRpbmcNCj4g
Pj4gd2l0aCB0aGUgZXhwZWN0ZWQgY2FjaGUgYmVoYXZpb3Igb2YgdGhlIERNQSBtYXN0ZXIuIGVn
IGJhc2VkIG9uDQo+ID4+IGRldl9pc19kbWFfY29oZXJlbnQoKSBpbiBzb21lIGNhc2UuDQo+ID4+
DQo+ID4+IEZvciBJbnRlbCBJT01NVSBJT01NVV9DQUNIRSB3YXMgcmVkZWZpbmVkIHRvIG1lYW4g
J2ZvcmNlIGFsbCBETUENCj4gdG8NCj4gPj4gYmUNCj4gPj4gY2FjaGUgY29oZXJlbnQnIHdoaWNo
IGhhcyB0aGUgcHJhY3RpY2FsIGVmZmVjdCBvZiBjYXVzaW5nIHRoZSBJT01NVSB0bw0KPiA+PiBp
Z25vcmUgdGhlIG5vLXNub29wIGJpdCBpbiBhIFBDSWUgVExQLg0KPiA+Pg0KPiA+PiB4ODYgcGxh
dGZvcm1zIGFyZSBhbHdheXMgSU9NTVVfQ0FDSEUsIHNvIEludGVsIHNob3VsZCBpZ25vcmUgdGhp
cyBmbGFnLg0KPiA+Pg0KPiA+PiBJbnN0ZWFkIHVzZSB0aGUgbmV3IGRvbWFpbiBvcCBlbmZvcmNl
X2NhY2hlX2NvaGVyZW5jeSgpIHdoaWNoIGNhdXNlcw0KPiA+PiBldmVyeQ0KPiA+PiBJT1BURSBj
cmVhdGVkIGluIHRoZSBkb21haW4gdG8gaGF2ZSB0aGUgbm8tc25vb3AgYmxvY2tpbmcgYmVoYXZp
b3IuDQo+ID4+DQo+ID4+IFJlY29uZmlndXJlIFZGSU8gdG8gYWx3YXlzIHVzZSBJT01NVV9DQUNI
RSBhbmQgY2FsbA0KPiA+PiBlbmZvcmNlX2NhY2hlX2NvaGVyZW5jeSgpIHRvIG9wZXJhdGUgdGhl
IHNwZWNpYWwgSW50ZWwgYmVoYXZpb3IuDQo+ID4+DQo+ID4+IFJlbW92ZSB0aGUgSU9NTVVfQ0FD
SEUgdGVzdCBmcm9tIEludGVsIElPTU1VLg0KPiA+Pg0KPiA+PiBVbHRpbWF0ZWx5IFZGSU8gcGx1
bWJzIHRoZSByZXN1bHQgb2YgZW5mb3JjZV9jYWNoZV9jb2hlcmVuY3koKSBiYWNrIGludG8NCj4g
Pj4gdGhlIHg4NiBwbGF0Zm9ybSBjb2RlIHRocm91Z2gga3ZtX2FyY2hfcmVnaXN0ZXJfbm9uY29o
ZXJlbnRfZG1hKCkNCj4gPj4gd2hpY2gNCj4gPj4gY29udHJvbHMgaWYgdGhlIFdCSU5WRCBpbnN0
cnVjdGlvbiBpcyBhdmFpbGFibGUgaW4gdGhlIGd1ZXN0LiBObyBvdGhlcg0KPiA+PiBhcmNoIGlt
cGxlbWVudHMga3ZtX2FyY2hfcmVnaXN0ZXJfbm9uY29oZXJlbnRfZG1hKCkuDQo+ID4+DQo+ID4+
IFNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4NCj4g
PiBSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4NCj4g
PiBidHcgYXMgZGlzY3Vzc2VkIGluIGxhc3QgdmVyc2lvbiBpdCBpcyBub3QgbmVjZXNzYXJpbHkg
dG8gcmVjYWxjdWxhdGUNCj4gPiBzbm9vcCBjb250cm9sIGdsb2JhbGx5IHdpdGggdGhpcyBuZXcg
YXBwcm9hY2guIFdpbGwgZm9sbG93IHVwIHRvDQo+ID4gY2xlYW4gaXQgdXAgYWZ0ZXIgdGhpcyBz
ZXJpZXMgaXMgbWVyZ2VkLg0KPiANCj4gQWdyZWVkLiBCdXQgaXQgYWxzbyByZXF1aXJlcyB0aGUg
ZW5mb3JjZV9jYWNoZV9jb2hlcmVuY3koKSB0byBiZSBjYWxsZWQNCj4gb25seSBhZnRlciBkb21h
aW4gYmVpbmcgYXR0YWNoZWQgdG8gYSBkZXZpY2UganVzdCBhcyBWRklPIGlzIGRvaW5nLg0KDQp0
aGF0IGFjdHVhbGx5IG1ha2VzIHNlbnNlLCByaWdodD8gdy9vIGRldmljZSBhdHRhY2hlZCBpdCdz
IHBvaW50bGVzcyB0bw0KY2FsbCB0aGF0IGludGVyZmFjZSBvbiBhIGRvbWFpbi4uLg0KDQo+IA0K
PiBBbnl3YXksIGZvciB0aGlzIGNoYW5nZSBpbiBpb21tdS92dC1kOg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+IA0KPiBCZXN0IHJlZ2Fy
ZHMsDQo+IGJhb2x1DQo=
