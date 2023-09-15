Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A597A1419
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjIODCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 23:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjIODCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 23:02:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB812709
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 20:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694746949; x=1726282949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yqn3JJnxCOAOloWFh9cxV78DhyY4dbRnETfbLWgbwTQ=;
  b=XKPK3+CUYMWkkOQMj9dYRULm2ih00bKFD/Mp6RisZwtCBTIcrMt4mzvs
   9exBX/0WVqei0NSA3SPT6dLe8v2cF89Xjvb/uqWdSkwU7PYr/dq3tljcW
   EbcxzyCbvJY8vHE0JAuuwqbG2m6Q46V6opL8cMb8E+lBhuybVI10ShDhL
   ODAbKLfTtpHafNki9eACE7r7r4I1xEJnjodLxlBSAZeZmuod581KFHP77
   O1nQn/r8Q/OGM+THIg0Il/ZlKjXJCUPGm3wYXchOnOp4GSBxDq/YBZJZt
   l87QJpV5f5PHpgHu5Z75qRW6QV97AtzN0mIwMZ9rwEMx4YuvgSWxFgPb6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="382964969"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="382964969"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 20:02:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="779920844"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="779920844"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 20:02:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 20:02:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 20:02:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 20:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiXLVacKKlyAKn3S/mP/crOIrVlK2Xqdbd8Uv7AbnO2sLRRYQIzgacoa6tepK8KaFoW4A+P64UwntJom4mcgNyWAIACQAjOLfumMiSR+rFVc3id3DFkSfOz+NoJDdYTlpOZc8E6OOvsWv7W9+HfiQspfmMalUUD5bldwJaj97GFQByhfHm4A6yRzjoL38zet9UY7tH8YWWLBo1W3cbcv+qjHWlK6k869oH/7E/TaKs74v9HXKRprq6B5ieFptIwLg8gYsuFFfYjnxoZslhOPEmIxO0Jck4W+Wzw+V7g8UTU4M3j2Mu5w0a7WJ1znw0JgdziZM7JcX3YRQTuaJx4FwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yqn3JJnxCOAOloWFh9cxV78DhyY4dbRnETfbLWgbwTQ=;
 b=Zie/ee7qQ6yY1YPhSfdaTm/QW9uoBZ6+Ketz66YBsNzKNTJTZJsndJUCHEIxrE0cLiuyroUoll3Rk5i4weK5vfY0UTPVckGKT9W0uIfhfJqA73qi2MpFA+AK+eOoAjO6I9lAJ82SKMLrbJBuxpix/1gZ7NoqFqTmYqoDa9Tgj4Khdv+Rx+s7smqDQTcAr5UqJBpFOPg0ximls1uIjcRdhaB759j+e1Z2hA0aDz/GBNQMr9VS1VCkJym1qtJaRr5xDTDWGJWWiHyTd1r1OZL8mN17cvKbiaG0Eei3zDY3hR1AgbOLYe3L5MFAZnmgh+aTGnzxqO0gigU6p+Sl4bnvCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by SN7PR11MB6851.namprd11.prod.outlook.com (2603:10b6:806:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.36; Fri, 15 Sep
 2023 03:02:25 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::dcc5:b253:97d0:ff70]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::dcc5:b253:97d0:ff70%4]) with mapi id 15.20.6792.020; Fri, 15 Sep 2023
 03:02:25 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: RE: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
 hwpt alloc
Thread-Topic: [PATCH v1 02/22] Update linux-header to support iommufd cdev and
 hwpt alloc
Thread-Index: AQHZ2zAiRSEfZNgVY0KFJh4NW0O0irAafg0AgADLkaA=
Date:   Fri, 15 Sep 2023 03:02:25 +0000
Message-ID: <SJ0PR11MB6744FE3F0DBD0E5A69EC37FF92F6A@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20230830103754.36461-1-zhenzhong.duan@intel.com>
 <20230830103754.36461-3-zhenzhong.duan@intel.com>
 <c2fb72a1-2e83-d266-c428-72dcfcd95a75@redhat.com>
In-Reply-To: <c2fb72a1-2e83-d266-c428-72dcfcd95a75@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|SN7PR11MB6851:EE_
x-ms-office365-filtering-correlation-id: 19c183eb-fd6a-4539-a32f-08dbb598303a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rJ8ada7YQ2ML6+T0T7dl1xuwfuk+3L1uAYcGk3LfZi98ccuqV/i48uUDc6BMJcEdrbkrW3lt/hdazdSn8+Y9zTO8d/PM66ev8TkzgO7Jb0TzrhVZza4jLcyDha9D2ygzkSqPJlyUY+zLsQ1CuOTam5yMYIvUKDzToeytCJLqeM5m/Y7Qx2e2h9uglczdBNs/iPKY3+Du1DwpenuMmbg/j8bMd1AARpXYkywIk2I039DUyjv/DBRoVLQGoSJv6/QqnMl5oAGhnx/1imlJVeIC+H30xrQ6Jdgn6t588ntThsKyv2zV9bSX0LX25a+wL+FTu77PfDqlDax/3MdfWtmZZB+8GS6//W/KNFZ7OLGEsmtMLzb0SUOyXvDhXIeI74IQA/ygYri+6qj3E4UFI9b8E2bRMYJ2t6nYOxZqfMxNZE62qNtCHkR6XIz2RrWrUEKvbGxu7vk+1PjYAJU6vD6ihSRHUtRc4dqc1BMQW2khSG7UblgqmjisQVt1sPc2q0VNqSJOF5ZkfYlm8XwXWlKasCrwfq6/Bxz3vZPpLDDWujw3x9aMZ3nWIjy0J/XFiOnSUPWzDesJS/eQW0sqxIt9Yv6bwhIJpjqIuuhyzkgrlj4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199024)(186009)(1800799009)(54906003)(66446008)(4326008)(64756008)(52536014)(966005)(478600001)(316002)(76116006)(110136005)(66946007)(41300700001)(8676002)(5660300002)(8936002)(66476007)(15650500001)(55016003)(7416002)(66556008)(2906002)(122000001)(83380400001)(82960400001)(38070700005)(38100700002)(86362001)(71200400001)(26005)(4744005)(7696005)(33656002)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkd2dUxaWm12T3VLU0RUM2Jkb2pYemdXbWpQcHY1Q3VjL0FrYnh2dDVWckhh?=
 =?utf-8?B?R29PV3ZzODJOTk5ZUlI2MDFna085QTNybEszTWJ5NFQ2TytYR3ViMzZyQis1?=
 =?utf-8?B?aEQrQ1phZVB6ZmlCT28zblpCWWRPZUxpdEZVenJITWlCSjRLdzE2MVFCVVVB?=
 =?utf-8?B?VFgwMG9tR3NxRXdMRzFkbnVhcDQ1MXhMMGVjeDYwYnc1RmRLVXg3cEpDN2RX?=
 =?utf-8?B?U2ZhckYxL1JuOUFZT2FycERHMXBodVBicmhJaTJvSlA2TmxqT290cWpQNERQ?=
 =?utf-8?B?RGJEbFg0V2pRNEpqTjBxU3dubGNDYVNiUzdJbDlwc2FRQ2Q0eWRMTkc2VE9L?=
 =?utf-8?B?dnVsOEQ4eStnZmloYTkrZUl3bkpRSTF4bUpRcEtveVlPTkdmOVdMMjhLV2I1?=
 =?utf-8?B?RzFOdTcvNmRMVFpCQ0UzL3R4SEdxaTFUTUNtOWYyMEZXMkhVVHJVaHhJS0dN?=
 =?utf-8?B?L2NmWVB2cjFvMkhQNGI3K3l3Ykx6RWRtVEJ4Y0RzdjNUMkkvYytzSzVkWUc0?=
 =?utf-8?B?SWEvRmU4azJEcUpqQ01VYXI2aFp3SzZteERNV1hXc0tKN1QwUVl3U2ozT0sr?=
 =?utf-8?B?NkVnaUU4Znp1VFhjM2dXY2lRbXpyMThLNVlxLzkzVnJVVTNUQlNYRXNmbzdT?=
 =?utf-8?B?QkM1Y3ZEZjMrVjAxNm5xNHFLWFVMa1NjTlk5YXVJYTRqdDBzSW5mNGduTGp0?=
 =?utf-8?B?cFNaeEhXZXlYZlNTQ2Q0TFJlRWh0UENpSTdVYTduaXNxRjN0TnBnS3lkRjRC?=
 =?utf-8?B?eEFJSE16UGxQMVpMZW91ZUpzemROa1BnU2JRZm1mV3hONDNRaWgrUm51aHFF?=
 =?utf-8?B?RGNVS0lqRE9Gc1RqVkZJR2lRU01OTS9NRDVCV2tsd0swT0tDbjhQUldyeDZz?=
 =?utf-8?B?dDBFNUFCU2EvdldTOGQ0L1dtUDRWRWhiUFpqWDBnVGNqRHgyR3Q0UVdKVklW?=
 =?utf-8?B?NEwwWGV0YVJ2dzJDR1paSmtCM1pXV1JQcjhJZTVDQjBwbTFpMkNFU1Nnd1Yv?=
 =?utf-8?B?cmJra0QrUlEvQUY4cVozY25zQkVzTUh6SVgwSG0rZm14bWEzVFdwVnpRVHlJ?=
 =?utf-8?B?Njk0aCswRzlPQ2tKeHYxeitoTzF4K3hCcmFCdWxydzQ2VEo0QnA0ZnNQVkN5?=
 =?utf-8?B?Skw1UUVzT1ZNeUYyYnhSby9aRGRtZElKY0JTaG1kSW1pSitVWlZ2TFB5Qjh2?=
 =?utf-8?B?YWhYWG9pbXNLME9NWVkzRjBuVjBMSnhqYW9TejZsQW0wNXcwbXhuVUVkVDR5?=
 =?utf-8?B?eGhhd2ErUFJkV1BodVU4ZkFBZ3dKUkFudTdvRDdqQ3J1dGl0ZnpWMW9kU1Ja?=
 =?utf-8?B?K0RDc1g1UVY4OXFPb1pLb1pUTU9NSmlSS1hvVTQveXFVQzh1UFVjU0svV2pK?=
 =?utf-8?B?RCtBZlp2UUpKdFdTNjZpSlM1MG5xZTZlY09KYWF5Z0RicU1ibkg0eFAxMVpU?=
 =?utf-8?B?aXR1WTRsL1JBRmY1VW5ZQm5jZW9iaFZqajhqTWY3ajBudWFJTms5M1AxeG1S?=
 =?utf-8?B?aW9rbTVrZXJmZ245b1graUc5dXJTMS8zNWowdnRuQVBNK1BYak5OdGJSdDNz?=
 =?utf-8?B?MGVDQkFMcGgzUWRpOXF5bC92YnFrTWVPUGhHcVpxemMxRXpuMlNubmh2SXQ1?=
 =?utf-8?B?eDhHV3FlSDU1dVlsOWNlWTBud0JFSlI3cFJNT2xWc0E2U2JFdzdRRVdFb0hU?=
 =?utf-8?B?MklYaW4vNWNwZzlVc3o4K1pwL3U5RStrWFFuRmdObnR0bVdZKzNrbzY1ajJz?=
 =?utf-8?B?RWM3N2lOeWlVMjFKbG1LTEVkdjY3SEpiM281WnZKVmR3Sk9jMUZUcHlQWFRl?=
 =?utf-8?B?TWh0QldXOThrNVZoSjVaSjViZGlpQzlTSjJ3dFZvTHFoZFVpejFVV2MxaXlL?=
 =?utf-8?B?SHRJb1IyQmRtN0p0U1pPUDk3cHVmZW50UENRMUtVSUlsdlhtd0thWi9wRXd2?=
 =?utf-8?B?Z2twVGw3RTdtYXlqOURpczJ5Ty9HS0cvSW5INmt1Qml1SGFWQVQrMVhiVnY1?=
 =?utf-8?B?RnZXNGh1MDZpRUpBa2tsaVZud09YbDEvWVRPeVJYdkRDY0E5SHNWWG1mdExJ?=
 =?utf-8?B?SWRvVXRFM3JiK01sUG11RHdtTWlNb1RzTEFuc3E5MlJQaDdUWnYrd210WDJD?=
 =?utf-8?Q?XzjmyCX/nqEhnJkEnFy2BVDPg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c183eb-fd6a-4539-a32f-08dbb598303a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 03:02:25.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q30ZVHazrO/XIOAnprivMv6QqI6RLkmgEn10GkiKUClebYbleVCsiOgnyWn17FtzGtZVKBxapbIjjWDGFhQot3dbrV3ivk79Tal/lDz1PA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6851
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogRXJpYyBBdWdl
ciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPlNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMTQs
IDIwMjMgMTA6NDYgUE0NCj5TdWJqZWN0OiBSZTogW1BBVENIIHYxIDAyLzIyXSBVcGRhdGUgbGlu
dXgtaGVhZGVyIHRvIHN1cHBvcnQgaW9tbXVmZCBjZGV2IGFuZA0KPmh3cHQgYWxsb2MNCj4NCj5I
aSBaaGVuemhvbmcsDQo+DQo+T24gOC8zMC8yMyAxMjozNywgWmhlbnpob25nIER1YW4gd3JvdGU6
DQo+PiBGcm9tIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L2pnZy9pb21tdWZkLmdpdA0KPj4gYnJhbmNoOiBmb3JfbmV4dA0KPj4gY29tbWl0IGlkOiBlYjUw
MWMyZDk2Y2ZjZTZiNDI1MjhlODMyMWVhMDg1ZWM2MDVlNzkwDQo+SSBzZWUgdGhhdCBpbiB5b3Vy
IGJyYW5jaCB5b3UgaGF2ZSBub3cgdXBkYXRlZCBhZ2FpbnN0IHY2LjYtcmMxLiBIb3dldmVyDQo+
eW91IHNob3VsZCBydW4gYSBmdWxsIC4vc2NyaXB0cy91cGRhdGUtbGludXgtaGVhZGVycy5zaCwN
Cj5pZS4gbm90IG9ubHkgaW1wb3J0aW5nIHRoZSBjaGFuZ2VzIGluIGxpbnV4LWhlYWRlcnMvbGlu
dXgvaW9tbXVmZC5oIGFzDQo+aXQgc2VlbXMgdG8gZG8gYnV0IGFsc28gaW1wb3J0IGFsbCBjaGFu
Z2VzIGJyb3VnaHQgd2l0aCB0aGlzIGxpbnV4IHZlcnNpb24uDQoNCkZvdW5kIHJlYXNvbi4gVGhl
IGJhc2UgaXMgYWxyZWFkeSBhZ2FpbnN0IHY2LjYtcmMxLCBbUEFUQ0ggdjEgMDEvMjJdIGFkZGVk
DQpJb21tdWZkLmggaW50byBzY3JpcHQgYW5kIHRoaXMgcGF0Y2ggYWRkZWQgaXQuDQpJIGFncmVl
IHRoZSBzdWJqZWN0IGlzIGNvbmZ1c2luZywgbmVlZCB0byBiZSBsaWtlICJVcGRhdGUgaW9tbXVm
ZC5oIHRvIGxpbnV4LWhlYWRlciINCkknbGwgZml4IHRoZSBzdWJqZWN0IGluIG5leHQgdmVyc2lv
biwgdGhhbmtzIGZvciBwb2ludCBvdXQuDQoNCkJSLg0KWmhlbnpob25nDQoNCg==
