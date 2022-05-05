Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A1051BDA9
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 13:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356347AbiEELHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 07:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242160AbiEELHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 07:07:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C9B47AEA
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 04:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651748603; x=1683284603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=imZP5E107Sb2qfiHkkU7dGC7YDCBJBD7OmK+mbOipXI=;
  b=RhiO15V7A4IZ1+GQo0/zHi6VzEVQSuysTNnxZVLW1zUAK5xlqaDDVF9r
   76FFANkASqERAAwjFt091DL7E/ozbKG1NZwI2pYVtS2vQSGG79p0DMfuC
   773H+5m6sblpQoyJTJQrUsW1El6s6fPL7LP69YTU991TXUwYWxVYDYgdQ
   o/i/U92srjRaGs+SHcEFjulA7N/Q3hXstBCxWHnGlOyBuRYp7Hs+xyPYX
   MaxD/Q5yQaxFywQkyjH5dTklcevSdrY+uC10nQfvVGHirjI24wSJ5t36P
   qxQ0q5ne6l0aKksc4aCY/ZRYOL3O/5RyiTG4nq5T7fve7F6ba5r2/uu3I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248610832"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="248610832"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 04:03:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="734848552"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 04:03:22 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 04:03:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 5 May 2022 04:03:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 5 May 2022 04:03:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0brs1E9MKCH369BSDi/LospYimfS6RfgYPq5DHe8muLBR0i4EMr4Qm67QPyJAN4kZJ0jPrcG1cl6HlAjEyuC1Bmux8PwoWFsM+hFSB+6203cry13OheIeyDO6vpghGBE/VaC/mocYz3eUAelbAt54f+hROYRAfUnGwY7U3k8e82+4iuWZ1C33jGXpjHLZf6vrLn2lCPEDZUO+Pr2M6V8MrirEp4DRYWfkaTCuQafFc6EAsY35YevzVkTAQ38yL9IdskcEHG9q4wHNOI8ggrmkkS8zt7LFwITOMIOWbvxmyBeFT/2/x0+NY1uZvggNIuu9cuvm/kzEUcaGIOIFoJVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imZP5E107Sb2qfiHkkU7dGC7YDCBJBD7OmK+mbOipXI=;
 b=CyJdkvy9XNETa8GJEmZ0OArwFtHc2t0HW4oVN00D7ALZ371F5nQW5MTUMMrl3qGXaLklcAKyRuhKDK+7oQQCbgWkLIwTEmbn7T3sdUX/Emt9mPZhy3z8dJnZRhzXToXf2UeAoLJEO2/NrzLPPhdHZPSQVNM/NbeB/Gd/h2UEXDWtbeaROyfCLvpMIiIvI4DKP9U7npqyNJYHphn27SIpL9aqYD7ydVH9f3PlgYSlCcgYIz6a9VQ9y96Yq3cxEXj+IET3Q8BhGVDSCTgFNWzXbuRWI68zMsSDs3tSqPumJztGSfS8eo7R0gEceIfvNRC3qdETZRttUR6PFBH9GEo7dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3933.namprd11.prod.outlook.com (2603:10b6:208:13d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 11:03:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 11:03:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAWwCICAAAubgIAD+0BQgAAo1oCAAA4PYA==
Date:   Thu, 5 May 2022 11:03:18 +0000
Message-ID: <BN9PR11MB527662B72E8BD1EDE204C5538CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
 <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
In-Reply-To: <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27193284-7123-4db4-96d7-08da2e86dc99
x-ms-traffictypediagnostic: MN2PR11MB3933:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB393323ACA1E5769DF7FD4EF28CC29@MN2PR11MB3933.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x6kxOK1TtgRrOBuVZkXs5L7sNLh5kiqn2Hu+ldfZfaly3wdqRbRXbFlsedWpA3+IG+jT2BVjlPyImhEJR0Hcpf3VpOtz2rqLGHtF6QQGJdNaThGon7Hq+jnlHtc+7AfzBB/xMr+/3TmnPVFzeWpn4HrFDLTMw3ht5C3zV67ZrGB7k482Aqfot34ot5bH1NTTCJ0gqsaFD1fHPFLKptyhQq3ER/o1q0S7tlcQhTh+1TAcd144fIzFrg4LLCfPtq8xljc8Io8f7wNhhBhgg8VDtStNWyFGeLigoAd7irjacnNb7h74y/koPjhZmxtgQzQRkGyUGNYc6MGa706I5ihe6E+7gN/AW4swDkJzZMqtSveWLl+JQuVY+uh+BAof9fosZJZT+05BRS2fhQuN+tweWMxCOs5QqiAWwqwSznb5ZZc9i/Cwz0gf/IO4QbS+CrXUo82juB+RFR/Y1q6Zgl8lKZbNT1sMoNGint2YjJBtc2GMQFwmY+pKUaw0lsG4SSE60UtI78VWXmK7oXGCaDi1EaWgn6FNX514OApKz8DYzB0wsaRrLhykpgQmhXz3g1M8rdJvRSIDtjPxg2GzpiSgbG2ZsxcrCtHPy5PM3fz2Ht/AcFg32+gsT1SJOcZvAOHeIOQ4yiznkksbY+NWMUf9ZYi7exSmcPpFX7t8JvkzWAF5t3P/jdzhX3XK+7hNzIdREOVVLWObWWmpizcDYUh76WcATyQaYhun56onloW6oO8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(83380400001)(66556008)(66476007)(66446008)(64756008)(66946007)(33656002)(4326008)(8676002)(7416002)(110136005)(186003)(316002)(54906003)(2906002)(86362001)(26005)(9686003)(55016003)(53546011)(6506007)(71200400001)(5660300002)(82960400001)(7696005)(8936002)(122000001)(508600001)(38100700002)(38070700005)(52536014)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTVFUG45YWY0aTdzME55dzFqWEZQOXV6Kzl6bWMwK1NIUmxlaU41bldhL3NO?=
 =?utf-8?B?S0hUUWJ0OGtsN2kyNXdNQXVqZ1FIZU0rTXlqWWRtQ2xia0hNcm8xYm9ycXVV?=
 =?utf-8?B?NDl4ZVFIaXdMRGJMM2pvdm9oTENCMm5leEh1ZXp0UHd4TEIzbVkzWnUrK2d4?=
 =?utf-8?B?dHI1S2FTVVpKN012bmZFcWoreGk0b3VQR3pOcTVuRmlxS2NBVXJibW5xZTVm?=
 =?utf-8?B?ZDh0b2FqQU4vT3lFcjFoY25kd05uNVI0ZU1RWDRFcU5qc2hYN2d0UzZOTUhL?=
 =?utf-8?B?NmpTRlk5MGgyZVBmRXhJSS8vR3paQVZKMWJ2QlQ5SzBSN0pCZnRvaHY1TExw?=
 =?utf-8?B?OEFzN2RaSEIzVkR3cTF6ZXVNQllnRWJJZG9IclpqUjY4OWZwMm5oc0RrK2o2?=
 =?utf-8?B?d2ZNZVJ4cFlvSWZlWUZvRzVwWE80Syt4NzhrV0pZM1FDSllYdi9LajJlS2NX?=
 =?utf-8?B?MkxCUVF1bGVlZG5GVElxbmtZNXNBbVg4QWQxMTlTTk5GUWZwdWVXdHFwSTJ2?=
 =?utf-8?B?Z0ZnQXBGMDlYekVhSi9mUDd0bldtSVpPRzJCYmVnRzMzTExiSU5SYUFJNVNK?=
 =?utf-8?B?b1JhaVFNR0dJSFNKbFJVeW9aMXlBeENHTnh6UTNkUjNzQ0MxM2hqYnBCNDVM?=
 =?utf-8?B?NG1IaFJuMFdFNThLT1VTUVR2Y1pweTFCYmtNSjhMK1BLd0s1QjFRandtdkE4?=
 =?utf-8?B?dGZtT3hveGJRNVZQYmVZNmFzOHRlVlJLN2ZPb1pQRGtSTHpiMXlRNmFZS3hG?=
 =?utf-8?B?Q2IyN0R0RlBzQzUrZm5lTnB3VVdoUVMwdUZkek1tKzUyU2lUcVVqckFOSHE3?=
 =?utf-8?B?SnVHdCtxc0pGOGl0NnFLK0RHeDhOOWhvOXVMTktEQlc4MW5nL0M5S0VwMXRW?=
 =?utf-8?B?dExxS2hXWDJqVmxqdk5LbzQ2NWU3cG1vR3c4ZkJTeVN3K05pd1B5NWdzWEhm?=
 =?utf-8?B?d29DQ0E2ZUVxcWt4Rk55cGZYWjVZTVczUGlIMExqSWxEUkw1eFczWVRCTGpM?=
 =?utf-8?B?SUhDMS9ZcHRPK1Awd2g1MUJIb2tOWDF0djVsaEpuWEFXOHkrWFVkUHVta0dW?=
 =?utf-8?B?R3RNUnVNNXNHMVRRUGU1cStRWXNQQlZ4aVJkLzVZeTU0WmJTcGlIR29tSUhl?=
 =?utf-8?B?b0NZUjNnbHNIbU9SeFoxeHlyTHNhNHE3QzQyQzJKTHpoWklsZVowYWc4UndF?=
 =?utf-8?B?MC92cHpjeTAwd0hjbThXdkpDVFBYbkk0Q1dTNDAwWVBmdWxRTytRVmtJM2Q0?=
 =?utf-8?B?Q1VBc2NHVzY5UXdBMTlGWk9MaENJRXYyWE5zVWxuNVdxczVNeCtxZkUyM1Q5?=
 =?utf-8?B?UVpJOXhVYko4amlsZk1US0J6RW5ZblRWTUo4cVVXbVRUSUZQdXNDM2RUWEZ2?=
 =?utf-8?B?RDljQWx6WWF1dDRpQlVJS3puZ3k2SXl4aTNueDNBcEVhNUw2V284dDlzSFVG?=
 =?utf-8?B?Qi9Gd3BXcnArbTZoVGhBT2dzcEltcGFiZzVBNUFTMFA0U2xiN0VxcjZBTGlz?=
 =?utf-8?B?V3g5N2RMWGhYdis4U3J1RDNnWXpOQ3l1WFI0aEJxcW9DbEd1bGt0dHpWbXVt?=
 =?utf-8?B?endFOTgyRFJKcEQxWXM0ZTZmUGJyV1h0Q3Q5Y3RQVU1JMzNMN0RIeFhQQmo4?=
 =?utf-8?B?N05xN1dDbHZHTlZXS3RVMW12QVpBSGlCa2N2aGUwMHlFS21zUUpiMHgxYW9K?=
 =?utf-8?B?QzMwcDhFakVJVzVYeXVNdXo0a1NmcmZSZG1ITzA0VHhRYjBGRXZvck5PUnJy?=
 =?utf-8?B?WGZFaHczdnBNWDZpZUIxNTNYWXJ6RnhJM0JnUWV0bXJHOWdzaGQrWXMwYzEw?=
 =?utf-8?B?M1NlRk9QdVFyZmRySWM0QUJDREtKY1F4Wnh0WlkvT1ZydzNPLzZXVEM4RjBh?=
 =?utf-8?B?OEE1SlBYNDdTc01EeUFrbTlKUUJXejAxdDkzQ0VMY0o1bW1XMXdoUHZ6KzNZ?=
 =?utf-8?B?UThkSUphSlhsNUpGbEFNWVRTZ2hFWWdraEkxaU1FZXpHZ2FMNlhVdHVTNGpP?=
 =?utf-8?B?N1RmUnlHNHJvR1dzbDVjR01RL1k5MlE0TExJSWZUdTBrSEgxNGw0T0JiUnp4?=
 =?utf-8?B?cmF0SllVTUJxWUhmc0dibGlteEI2YUE5OWVMYnNPZllzN0J6K1FXS0hWK1RB?=
 =?utf-8?B?ZjNqRmF0TG5ndE9EOEMrd21MUnpnSlJ5YVN0Vnh6SnZKM1VyWXQvWFVEOWpx?=
 =?utf-8?B?N29IK2psR1hNNmpnWWUzRkpuY3dpUkVzZzBiUDZHQmt6WDZUYUJSREVIdUhT?=
 =?utf-8?B?eGtqL0JNQWN6NzcvdDFXcytKRk02TjlrRE5CR0g3UTlqeTFKeFRWVFk4RUpy?=
 =?utf-8?B?WStFSkRsaVphQUNJWThhcUZIeEdJR3NWT1o5N0U3WUN5V0tMank2dz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27193284-7123-4db4-96d7-08da2e86dc99
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 11:03:18.7426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rWzbiicw9nQ5VbOCG/lND6IXLO1AE3LHLavg5rglogqJnqJAJuoDOoSuxInv1cDOqxFQ8DU3SG7wGl2C3XY8OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3933
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6
IFRodXJzZGF5LCBNYXkgNSwgMjAyMiA2OjA3IFBNDQo+IA0KPiBPbiA1LzUvMjIgMDg6NDIsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEu
Y29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBNYXkgMywgMjAyMiAyOjUzIEFNDQo+ID4+DQo+ID4+
IE9uIE1vbiwgTWF5IDAyLCAyMDIyIGF0IDEyOjExOjA3UE0gLTA2MDAsIEFsZXggV2lsbGlhbXNv
biB3cm90ZToNCj4gPj4+IE9uIEZyaSwgMjkgQXByIDIwMjIgMDU6NDU6MjAgKzAwMDANCj4gPj4+
ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPj4+Pj4gRnJv
bTogSm9hbyBNYXJ0aW5zIDxqb2FvLm0ubWFydGluc0BvcmFjbGUuY29tPg0KPiA+Pj4+PiAgMykg
VW5tYXBwaW5nIGFuIElPVkEgcmFuZ2Ugd2hpbGUgcmV0dXJuaW5nIGl0cyBkaXJ0eSBiaXQgcHJp
b3IgdG8NCj4gPj4+Pj4gdW5tYXAuIFRoaXMgY2FzZSBpcyBzcGVjaWZpYyBmb3Igbm9uLW5lc3Rl
ZCB2SU9NTVUgY2FzZSB3aGVyZSBhbg0KPiA+Pj4+PiBlcnJvbm91cyBndWVzdCAob3IgZGV2aWNl
KSBETUFpbmcgdG8gYW4gYWRkcmVzcyBiZWluZyB1bm1hcHBlZCBhdA0KPiA+PiB0aGUNCj4gPj4+
Pj4gc2FtZSB0aW1lLg0KPiA+Pj4+DQo+ID4+Pj4gYW4gZXJyb25lb3VzIGF0dGVtcHQgbGlrZSBh
Ym92ZSBjYW5ub3QgYW50aWNpcGF0ZSB3aGljaCBETUFzIGNhbg0KPiA+Pj4+IHN1Y2NlZWQgaW4g
dGhhdCB3aW5kb3cgdGh1cyB0aGUgZW5kIGJlaGF2aW9yIGlzIHVuZGVmaW5lZC4gRm9yIGFuDQo+
ID4+Pj4gdW5kZWZpbmVkIGJlaGF2aW9yIG5vdGhpbmcgd2lsbCBiZSBicm9rZW4gYnkgbG9zaW5n
IHNvbWUgYml0cyBkaXJ0aWVkDQo+ID4+Pj4gaW4gdGhlIHdpbmRvdyBiZXR3ZWVuIHJlYWRpbmcg
YmFjayBkaXJ0eSBiaXRzIG9mIHRoZSByYW5nZSBhbmQNCj4gPj4+PiBhY3R1YWxseSBjYWxsaW5n
IHVubWFwLiBGcm9tIGd1ZXN0IHAuby52LiBhbGwgdGhvc2UgYXJlIGJsYWNrLWJveA0KPiA+Pj4+
IGhhcmR3YXJlIGxvZ2ljIHRvIHNlcnZlIGEgdmlydHVhbCBpb3RsYiBpbnZhbGlkYXRpb24gcmVx
dWVzdCB3aGljaCBqdXN0DQo+ID4+Pj4gY2Fubm90IGJlIGNvbXBsZXRlZCBpbiBvbmUgY3ljbGUu
DQo+ID4+Pj4NCj4gPj4+PiBIZW5jZSBpbiByZWFsaXR5IHByb2JhYmx5IHRoaXMgaXMgbm90IHJl
cXVpcmVkIGV4Y2VwdCB0byBtZWV0IHZmaW8NCj4gPj4+PiBjb21wYXQgcmVxdWlyZW1lbnQuIEp1
c3QgaW4gY29uY2VwdCByZXR1cm5pbmcgZGlydHkgYml0cyBhdCB1bm1hcA0KPiA+Pj4+IGlzIG1v
cmUgYWNjdXJhdGUuDQo+ID4+Pj4NCj4gPj4+PiBJJ20gc2xpZ2h0bHkgaW5jbGluZWQgdG8gYWJh
bmRvbiBpdCBpbiBpb21tdWZkIHVBUEkuDQo+ID4+Pg0KPiA+Pj4gU29ycnksIEknbSBub3QgZm9s
bG93aW5nIHdoeSBhbiB1bm1hcCB3aXRoIHJldHVybmVkIGRpcnR5IGJpdG1hcA0KPiA+Pj4gb3Bl
cmF0aW9uIGlzIHNwZWNpZmljIHRvIGEgdklPTU1VIGNhc2UsIG9yIGluIGZhY3QgaW5kaWNhdGl2
ZSBvZiBzb21lDQo+ID4+PiBzb3J0IG9mIGVycm9uZW91cywgcmFjeSBiZWhhdmlvciBvZiBndWVz
dCBvciBkZXZpY2UuDQo+ID4+DQo+ID4+IEl0IGlzIGJlaW5nIGNvbXBhcmVkIGFnYWluc3QgdGhl
IGFsdGVybmF0aXZlIHdoaWNoIGlzIHRvIGV4cGxpY2l0bHkNCj4gPj4gcXVlcnkgZGlydHkgdGhl
biBkbyBhIG5vcm1hbCB1bm1hcCBhcyB0d28gc3lzdGVtIGNhbGxzIGFuZCBwZXJtaXQgYQ0KPiA+
PiByYWNlLg0KPiA+Pg0KPiA+PiBUaGUgb25seSBjYXNlIHdpdGggYW55IGRpZmZlcmVuY2UgaXMg
aWYgdGhlIGd1ZXN0IGlzIHJhY2luZyBETUEgd2l0aA0KPiA+PiB0aGUgdW5tYXAgLSBpbiB3aGlj
aCBjYXNlIGl0IGlzIGFscmVhZHkgaW5kZXRlcm1pbmF0ZSBmb3IgdGhlIGd1ZXN0IGlmDQo+ID4+
IHRoZSBETUEgd2lsbCBiZSBjb21wbGV0ZWQgb3Igbm90Lg0KPiA+Pg0KPiA+PiBlZyBvbiB0aGUg
dklPTU1VIGNhc2UgaWYgdGhlIGd1ZXN0IHJhY2VzIERNQSB3aXRoIHVubWFwIHRoZW4gd2UgYXJl
DQo+ID4+IGFscmVhZHkgZmluZSB3aXRoIHRocm93aW5nIGF3YXkgdGhhdCBETUEgYmVjYXVzZSB0
aGF0IGlzIGhvdyB0aGUgcmFjZQ0KPiA+PiByZXNvbHZlcyBkdXJpbmcgbm9uLW1pZ3JhdGlvbiBz
aXR1YXRpb25zLCBzbyByZXNvdmxpbmcgaXQgYXMgdGhyb3dpbmcNCj4gPj4gYXdheSB0aGUgRE1B
IGR1cmluZyBtaWdyYXRpb24gaXMgT0sgdG9vLg0KPiA+Pg0KPiA+Pj4gV2UgbmVlZCB0aGUgZmxl
eGliaWxpdHkgdG8gc3VwcG9ydCBtZW1vcnkgaG90LXVucGx1ZyBvcGVyYXRpb25zDQo+ID4+PiBk
dXJpbmcgbWlncmF0aW9uLA0KPiA+Pg0KPiA+PiBJIHdvdWxkIGhhdmUgdGhvdWdodCB0aGF0IGhv
dHBsdWcgZHVyaW5nIG1pZ3JhdGlvbiB3b3VsZCBzaW1wbHkNCj4gPj4gZGlzY2FyZCBhbGwgdGhl
IGRhdGEgLSBob3cgZG9lcyBpdCB1c2UgdGhlIGRpcnR5IGJpdG1hcD8NCj4gPj4NCj4gPj4+IFRo
aXMgd2FzIGltcGxlbWVudGVkIGFzIGEgc2luZ2xlIG9wZXJhdGlvbiBzcGVjaWZpY2FsbHkgdG8g
YXZvaWQNCj4gPj4+IHJhY2VzIHdoZXJlIG9uZ29pbmcgYWNjZXNzIG1heSBiZSBhdmFpbGFibGUg
YWZ0ZXIgcmV0cmlldmluZyBhDQo+ID4+PiBzbmFwc2hvdCBvZiB0aGUgYml0bWFwLiAgVGhhbmtz
LA0KPiA+Pg0KPiA+PiBUaGUgaXNzdWUgaXMgdGhlIGNvc3QuDQo+ID4+DQo+ID4+IE9uIGEgcmVh
bCBpb21tdSBlbG1pbmF0aW5nIHRoZSByYWNlIGlzIGV4cGVuc2l2ZSBhcyB3ZSBoYXZlIHRvIHdy
aXRlDQo+ID4+IHByb3RlY3QgdGhlIHBhZ2VzIGJlZm9yZSBxdWVyeSBkaXJ0eSwgd2hpY2ggc2Vl
bXMgdG8gYmUgYW4gZXh0cmEgSU9UTEINCj4gPj4gZmx1c2guDQo+ID4+DQo+ID4+IEl0IGlzIG5v
dCBjbGVhciBpZiBwYXlpbmcgdGhpcyBjb3N0IHRvIGJlY29tZSBhdG9taWMgaXMgYWN0dWFsbHkN
Cj4gPj4gc29tZXRoaW5nIGFueSB1c2UgY2FzZSBuZWVkcy4NCj4gPj4NCj4gPj4gU28sIEkgc3Vn
Z2VzdCB3ZSB0aGluayBhYm91dCBhIDNyZCBvcCAnd3JpdGUgcHJvdGVjdCBhbmQgY2xlYXINCj4g
Pj4gZGlydGllcycgdGhhdCB3aWxsIGJlIGZvbGxvd2VkIGJ5IGEgbm9ybWFsIHVubWFwIC0gdGhl
IGV4dHJhIG9wIHdpbGwNCj4gPj4gaGF2ZSB0aGUgZXh0cmEgb3ZlaGVhcmQgYW5kIHVzZXJzcGFj
ZSBjYW4gZGVjaWRlIGlmIGl0IHdhbnRzIHRvIHBheSBvcg0KPiA+PiBub3QgdnMgdGhlIG5vbi1h
dG9taWMgcmVhZCBkaXJ0aWVzIG9wZXJhdGlvbi4gQW5kIGxldHMgaGF2ZSBhIHVzZSBjYXNlDQo+
ID4+IHdoZXJlIHRoaXMgbXVzdCBiZSBhdG9taWMgYmVmb3JlIHdlIGltcGxlbWVudCBpdC4uDQo+
ID4NCj4gPiBhbmQgd3JpdGUtcHJvdGVjdGlvbiBhbHNvIHJlbGllcyBvbiB0aGUgc3VwcG9ydCBv
ZiBJL08gcGFnZSBmYXVsdC4uLg0KPiA+DQo+IC9JIHRoaW5rLyBhbGwgSU9NTVVzIGluIHRoaXMg
c2VyaWVzIGFscmVhZHkgc3VwcG9ydCBwZXJtaXNzaW9uL3VucmVjb3ZlcmFibGUNCj4gSS9PIHBh
Z2UgZmF1bHRzIGZvciBhIGxvbmcgdGltZSBJSVVDLg0KPiANCj4gVGhlIGVhcmxpZXIgc3VnZ2Vz
dGlvbiB3YXMganVzdCB0byBkaXNjYXJkIHRoZSBJL08gcGFnZSBmYXVsdCBhZnRlcg0KPiB3cml0
ZS1wcm90ZWN0aW9uIGhhcHBlbnMuIGZ3aXcsIHNvbWUgSU9NTVVzIGFsc28gc3VwcG9ydCBzdXBw
cmVzc2luZw0KPiB0aGUgZXZlbnQgbm90aWZpY2F0aW9uIChsaWtlIEFNRCkuDQoNCmlpdWMgdGhl
IHB1cnBvc2Ugb2YgJ3dyaXRlLXByb3RlY3Rpb24nIGhlcmUgaXMgdG8gY2FwdHVyZSBpbi1mbHkg
ZGlydHkgcGFnZXMNCmluIHRoZSBzYWlkIHJhY2Ugd2luZG93IHVudGlsIHVubWFwIGFuZCBpb3Rs
YiBpcyBpbnZhbGlkYXRlZCBpcyBjb21wbGV0ZWQuDQoNCip1bnJlY292ZXJhYmxlKiBmYXVsdHMg
YXJlIG5vdCBleHBlY3RlZCB0byBiZSB1c2VkIGluIGEgZmVhdHVyZSBwYXRoDQphcyBvY2N1cnJl
bmNlIG9mIHN1Y2ggZmF1bHRzIG1heSBsZWFkIHRvIHNldmVyZSByZWFjdGlvbiBpbiBpb21tdQ0K
ZHJpdmVycyBlLmcuIGNvbXBsZXRlbHkgYmxvY2sgRE1BIGZyb20gdGhlIGRldmljZSBjYXVzaW5n
IHN1Y2ggZmF1bHRzLg0K
