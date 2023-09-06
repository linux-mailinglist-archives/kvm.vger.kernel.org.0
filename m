Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5F7946C7
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 01:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbjIFXD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 19:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjIFXDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 19:03:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFA519B2;
        Wed,  6 Sep 2023 16:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694041402; x=1725577402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4LKaBbgIf87SuWhPN4FzufliQCC15TYBtNVnoftD0cc=;
  b=Dkg7n91vGMnFs8FnE27cB+BXrICntN6fMTSjMU6MCFt/FKIrgoh3698I
   2MDONcZjwlSlGaYTezS5PJxjdoI2W8+mCRX2L+z756BLEM9DHZ+qzzUY8
   MhqTtYFubU7lNfFiWa3EirkWNq6vIShb3dn7OmB0oa0nkPqjP+gVGFiPt
   JENzY7h3r4J4cneZzMKezQer+Eohu3OdLJDeAKwVFijG3Ol3kruuER6Jv
   nXa8SQLCmn4PNUdDYw8AfkSxl+WAfO+/vzjKk4LDczGbt0zLRKjLIHLTD
   LaxR50Uy3vEPqqdLBBvaZTjOMDxuoL9LLGLLyiWKyi8lA5eEmr/Budl1O
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="408213151"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="408213151"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 16:03:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="744864734"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="744864734"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2023 16:03:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 6 Sep 2023 16:03:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 6 Sep 2023 16:03:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 6 Sep 2023 16:03:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLT82dExmoy4Al0VvThjHbRXRdclHw/YYJ8Fcr9bolICu9tvvM/sKP5Vf7Mz4XPCf+vcIKAkzwU2aOmSHEu3saoMXvbLgpQgfSW7kjKClMEq0UtnReP9V9kedGRWJB0A8SgxXbcn93iZv38loQGEXHjtMWjepHdPQxnCBYEDLOnr9cHddEKseeDs9R03Xg/YO+djwR2kF3eVE54nluvRp4wPFduudZFly5QYDwiemofG3JDNj0slCKRJrcLTPQ9jFMNrc/pLSZkCiSPDwELaY9BWyFsAgTdiZMCRTzT/P9tudkJOR+pl7zxDu9SF/ZNhPC8wSRRWqI9pBMZV7e/v/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LKaBbgIf87SuWhPN4FzufliQCC15TYBtNVnoftD0cc=;
 b=OpXAI7GsBr4Mjrt2T2O0jFAujhvjEmRpT0W38Vhi2l4hP+K6qLkXFa4Gxg9JFvf0NypNd0HqAEygYOGAtcCPxnKmys5uZKXuYZod1BEpxQGraauXDRtGs3fkZ8vdEfYLJuiDDfS7J7d7F/pcUtNI/0HmVG7MLGn9tGoHS0PZNuMJEUvs5GCk62xzANxRdZS9m/ocdFc5p9xaZ3dCs4rfWTCBze2/4KQMVWbs2/EBTNnWdYjagsQmC2Pn9mQMOwxlZUEF6vBsiEoqjbLzUiFRPDbOSnD64ZCFCDn0pBQiK04E07aAuUMHn95fW8FurcpV4yPCK3PG7lnj1lzWkTbY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Wed, 6 Sep
 2023 23:03:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 23:03:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Thread-Topic: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Thread-Index: AQHZ1vmsASee+tbEkESGNccmLbK5BLAOfqCA
Date:   Wed, 6 Sep 2023 23:03:06 +0000
Message-ID: <68859513bc0fb4eda4e3e62ec073dd2a58f7676b.camel@intel.com>
References: <20230825020733.2849862-1-seanjc@google.com>
         <20230825020733.2849862-3-seanjc@google.com>
In-Reply-To: <20230825020733.2849862-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5143:EE_
x-ms-office365-filtering-correlation-id: 409764c4-5252-4deb-b67d-08dbaf2d6e75
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T5IFjN8S4CFLqjeCQWHH0UJ9Qt2BKr1YErNb5KEuUPL92THEbOayZDnsTu9svHuv3aJsfUK82QmHwKENZKvgKNiAo0v8mdsfTUJNqLRKnXam6rToBRokolwqsRCeH5KOQg4/cc1ue1UWcT5W0rpbRqP7NcZ0J6zVC99PrRIH4KGrqlXQ/T+r2QsHB7nymXFUGsRkUxk2aejuA6ivsG6Dg57C9q3IoV3Y43phSAZWfiANedhcCZDsG0Y2vDH3KB4PQoX1poG/DzvYOlWfYTQYCSpmSYn+t3ksOeq1DdhpKGeA0knph1za/YS719g6lMMMFZ1ZWKrUWz61huLjpFKjI9UZuKpd4bzTGfZO7cxAsn5OuQKtvx7jlzp6VGwhT3VDULsUU55iKBrt+R5C/rOybombXW3JsTgPGcy5alMfelZgqmF+c6GqJWTmkrjLCIVVVmWOSh9aNAiHrVqetQJIL6oPMdcc4hXdeyXSYaZfSTfth0GIcUi5E0Ntm8Op54ke0GYDdSG6MEvsQWcY58fEsmkPkmJvcNBCJkKiW+fyItgQScUWlMCeQjHQb6h634Duv0xYqWG219ytjLA/Usr7A6Y5/ezTyQbQ0qRSVYeMY6s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(8936002)(8676002)(4326008)(2616005)(41300700001)(26005)(66446008)(107886003)(5660300002)(110136005)(2906002)(83380400001)(71200400001)(478600001)(966005)(316002)(6512007)(6506007)(6486002)(91956017)(54906003)(66556008)(76116006)(66476007)(66946007)(64756008)(36756003)(86362001)(38070700005)(82960400001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZElGR1FZRDI0L0xwWU9MQWY2cXBwVDV4bmJaVEptWlYyU0p6cWRYWXRQNUJC?=
 =?utf-8?B?ang2bm9XaDJ3b2dwTmhla0VMZVdXYWowbXZTYlRiVnlTOVljVlAzU3g2dTRH?=
 =?utf-8?B?aUhud29WaEpFRklxRm9hSGpzalp1R2NaSzgzT2xDbWtNcmIyV0Jhc3poZVh4?=
 =?utf-8?B?SGg4Rm41TXduUll5ZXljTFBzZ1IwNFdxQVZseVU1ZVErWmxwRWVwUzlOSnFZ?=
 =?utf-8?B?Z2lVRzlabFhhbG9KdFJYRU5iTGptM0RwRzduNUNvWFRmTitqcUErRW9CeUtT?=
 =?utf-8?B?LzJ4L3VpRTBzdzMwOTBEUHhHeHdTdmYxaGJsR0huWG00UXUxdTE5d1Z5TUZD?=
 =?utf-8?B?eEdYWXlRSGhKVVZBamphMXJ6S0tzbVZhYkhHZHRZbnVvMlRzVjZoRk9MWGh0?=
 =?utf-8?B?dStVTXo1Ym1YOFZhc2djeGRjK2xyVGNUdTU1aWVraUhRbFRWdDFHK2NTNFN2?=
 =?utf-8?B?cUdxeURrNVkzbEg2aXNXSnM3dDAzVzZkRW8xTzZtSXA3bm4wa2tZTytrRWlK?=
 =?utf-8?B?OU50UGszcWNPOEhzaHVjT3N6d0E4ZkNCQ2oyWkd0SitUNkxpSXBKVE40VXMv?=
 =?utf-8?B?a1h0U3BtZ05uZzVCOTJUbG5wRWhabDhOUzVkQXA1eUU3V1AxMXhYYTZkUWFJ?=
 =?utf-8?B?L3hwWkt4R0NNeUQ5Wk5Bd0Erc3Rub0ttTU5WWUR3M1I0OEMzWkZnUUpqa3hm?=
 =?utf-8?B?WENDMkVZT25XcDAzWGEzMFJPbCtnaUlPbmhFdEtIRGJnSWlrU20vR3M1TG9X?=
 =?utf-8?B?ZENxTUliWFBzdSsrQ2YvWit0bFduencxUVZZTTl1Qis2bzJJS2RKb1E4bnpC?=
 =?utf-8?B?M2JzaVNwNlFTUk1vTThic2pFcVpiY2xVL0FHdFAvUHhxN3I1THFEdHRuVzBj?=
 =?utf-8?B?bSsvSjBoczU5dG1NQUEzRm5PL0pHd2hmdkhCcnVWZThZYzMzWmp3OG8xTUsr?=
 =?utf-8?B?MHgwMGdKc1hHQVQwZWhzN2dhMFRRUlkvSnFkbkpXeE1iY1E1R1hDcXlTTmZ0?=
 =?utf-8?B?Z1pzZlZQbS9Wa3BVT2ZYcTRaMG5TUlBaQm1tbWRGaGN6ek1nSVRIUGVRNXRD?=
 =?utf-8?B?T3ZKbkhjVDJ6bkpOQzdQMDFUMmhpMHBIM0NPcjBkV2EyZ0xoczE1cDdkTUhx?=
 =?utf-8?B?eE9CWUcrdndNb2lOUllvVVpHTkVKY3NtTUdpc25mclFoUUkxSllTeGRyZDUx?=
 =?utf-8?B?ZCtyNUlFdEREZEdUaVNhU09yT2U4elQyVUNZUGNJM2NkUGc1Nmc0cFhvbzNp?=
 =?utf-8?B?SnpCQTc2eEE4Y2Q5VGUxZ09pY3Rpb281aXM5ZTZHRUE2Qy9BeXpSdkNkemxY?=
 =?utf-8?B?U2pDMVczNG1KZ21iaHZsdVJmZXgrT3I2NFkxUjl0ODdkaHNPK283VWJHZ2hY?=
 =?utf-8?B?aTlYb1VNRlZqSVVCeGdNSW9lbHRXbDE5RFIxYUd1YnZJNmNZYmxER3E0ek9K?=
 =?utf-8?B?ejdlU1hyVjRhTElXTmswcVNCR0QzOVZRbGg2SDhLL2pjVk1VaVRCcndLaytL?=
 =?utf-8?B?Sklhdm9rVm5JS3RtRzFteC9Mb3RyMy8yOW9zRlJFYzRjWFVjTkFkajR5dklx?=
 =?utf-8?B?Vm5aNjlCb2J5YkdPVUVNOXJjOTZPbzB6a1Awc0FYVW85K3BzS29lRk1KOW95?=
 =?utf-8?B?VTNvVnRZWGlwMkNwNW55ZjkyYXRET1VUb0FWZWNFREN6MHdHNXRUNTltb0R3?=
 =?utf-8?B?M2VXWmR3K2JWeFVhUllhbkQ0VUlQTDN1NnkyQlBpU1JYOHhFUDcwUXVaRThQ?=
 =?utf-8?B?Z0NiSzIrdGVha1FkWTVNMlN6bUQxbmM5WFJ4Yk80ZStWVXdZeXpCd1huOVB2?=
 =?utf-8?B?UVpJcURZaTkya2lVSTNWcmF4UGU3bVMxVTFVSTZuN3E0bVF3RmhvT05oUDRZ?=
 =?utf-8?B?bXlPd0I4UEt6elFOQ1VQcGRWQTFKdzZBc0kzenJqd1pOVXNSV0dLSDExOFNj?=
 =?utf-8?B?eTA1Q28rTk4zV21hbnl2aG1iYkZucXYvV3ZQbVRVeVBMZTcyN0dPa0ovWklJ?=
 =?utf-8?B?cDBoTWpocTRsT1BOOFV3U2Q5MWFSSThocjFZVXNCMUpKMWJJbWVIYStmZGkz?=
 =?utf-8?B?SnJSVTc0aWgrZzIrWThDL2xmNWZmUkVmUExONkRkQ1hnWkpPMkdvajJnOStD?=
 =?utf-8?Q?eLDObSWGSkFEYWIxfVDb5f+d6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F79F27DCE60314CBF71F0577B5488A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409764c4-5252-4deb-b67d-08dbaf2d6e75
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2023 23:03:06.4515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pvkx4ptTXNxiTkehc2a+I+ulzARfTy/X7G1eX8jnuQ187kTY4nqTgC750qrW4txIN6ML4MIEppYjf2Xc7BxnVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA4LTI0IGF0IDE5OjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXRyeSBwYWdlIGZhdWx0cyB3aXRob3V0IGFjcXVpcmluZyBtbXVfbG9jayBpZiB0
aGUgcmVzb2x2ZWQgaHZhIGlzIGNvdmVyZWQNCj4gYnkgYW4gYWN0aXZlIGludmFsaWRhdGlvbi4g
IENvbnRlbmRpbmcgZm9yIG1tdV9sb2NrIGlzIGVzcGVjaWFsbHkNCj4gcHJvYmxlbWF0aWMgb24g
cHJlZW1wdGlibGUga2VybmVscyBhcyB0aGUgbW11X25vdGlmaWVyIGludmFsaWRhdGlvbiB0YXNr
DQo+IHdpbGwgeWllbGQgbW11X2xvY2sgKHNlZSByd2xvY2tfbmVlZGJyZWFrKCkpLCBkZWxheSB0
aGUgaW4tcHJvZ3Jlc3MNCj4gaW52YWxpZGF0aW9uLCBhbmQgdWx0aW1hdGVseSBpbmNyZWFzZSB0
aGUgbGF0ZW5jeSBvZiByZXNvbHZpbmcgdGhlIHBhZ2UNCj4gZmF1bHQuICBBbmQgaW4gdGhlIHdv
cnN0IGNhc2Ugc2NlbmFyaW8sIHlpZWxkaW5nIHdpbGwgYmUgYWNjb21wYW5pZWQgYnkgYQ0KPiBy
ZW1vdGUgVExCIGZsdXNoLCBlLmcuIGlmIHRoZSBpbnZhbGlkYXRpb24gY292ZXJzIGEgbGFyZ2Ug
cmFuZ2Ugb2YgbWVtb3J5DQo+IGFuZCB2Q1BVcyBhcmUgYWNjZXNzaW5nIGFkZHJlc3NlcyB0aGF0
IHdlcmUgYWxyZWFkeSB6YXBwZWQuDQo+IA0KPiBBbHRlcm5hdGl2ZWx5LCB0aGUgeWllbGRpbmcg
aXNzdWUgY291bGQgYmUgbWl0aWdhdGVkIGJ5IHRlYWNoaW5nIEtWTSdzIE1NVQ0KPiBpdGVyYXRv
cnMgdG8gcGVyZm9ybSBtb3JlIHdvcmsgYmVmb3JlIHlpZWxkaW5nLCBidXQgdGhhdCB3b3VsZG4n
dCBzb2x2ZQ0KPiB0aGUgbG9jayBjb250ZW50aW9uIGFuZCB3b3VsZCBuZWdhdGl2ZWx5IGFmZmVj
dCBzY2VuYXJpb3Mgd2hlcmUgYSB2Q1BVIGlzDQo+IHRyeWluZyB0byBmYXVsdCBpbiBhbiBhZGRy
ZXNzIHRoYXQgaXMgTk9UIGNvdmVyZWQgYnkgdGhlIGluLXByb2dyZXNzDQo+IGludmFsaWRhdGlv
bi4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+
IENsb3NlczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pOblBGNFcyNlpiQXlHdG9AeXpo
YW81Ni1kZXNrLnNoLmludGVsLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVy
c29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCg0KTml0IGJlbG93IC4uLg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL21t
dS9tbXUuYyB8IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUv
bW11LmMNCj4gaW5kZXggMWE1YTFlN2QxZWI3Li44ZTJlMDdlZDFhMWIgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0K
PiBAQCAtNDMzNCw2ICs0MzM0LDkgQEAgc3RhdGljIGludCBrdm1fZmF1bHRpbl9wZm4oc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0LA0KPiAgCWlmICh1
bmxpa2VseSghZmF1bHQtPnNsb3QpKQ0KPiAgCQlyZXR1cm4ga3ZtX2hhbmRsZV9ub3Nsb3RfZmF1
bHQodmNwdSwgZmF1bHQsIGFjY2Vzcyk7DQo+ICANCj4gKwlpZiAobW11X2ludmFsaWRhdGVfcmV0
cnlfaHZhKHZjcHUtPmt2bSwgZmF1bHQtPm1tdV9zZXEsIGZhdWx0LT5odmEpKQ0KPiArCQlyZXR1
cm4gUkVUX1BGX1JFVFJZOw0KPiArDQoNCi4uLiBQZXJoYXBzIGEgY29tbWVudCBzYXlpbmcgdGhp
cyBpcyB0byBhdm9pZCB1bm5lY2Vzc2FyeSBNTVUgbG9jayBjb250ZW50aW9uDQp3b3VsZCBiZSBu
aWNlLiAgT3RoZXJ3aXNlIHdlIGhhdmUgaXNfcGFnZV9mYXVsdF9zdGFsZSgpIGNhbGxlZCBsYXRl
ciB3aXRoaW4gdGhlDQpNTVUgbG9jay4gIEkgc3VwcG9zZSBwZW9wbGUgb25seSB0ZW5kIHRvIHVz
ZSBnaXQgYmxhbWVyIHdoZW4gdGhleSBjYW5ub3QgZmluZA0KYW5zd2VyIGluIHRoZSBjb2RlIDot
KQ0KIA0KPiAgCXJldHVybiBSRVRfUEZfQ09OVElOVUU7DQo+ICB9DQo+ICANCg0KQnR3LCBjdXJy
ZW50bHkgZmF1bHQtPm1tdV9zZXEgaXMgc2V0IGluIGt2bV9mYXVsdGluX3BmbigpLCB3aGljaCBo
YXBwZW5zIGFmdGVyDQpmYXN0X3BhZ2VfZmF1bHQoKS4gIENvbmNlcHR1YWxseSwgc2hvdWxkIHdl
IG1vdmUgdGhpcyB0byBldmVuIGJlZm9yZQ0KZmFzdF9wYWdlX2ZhdWx0KCkgYmVjYXVzZSBJIGFz
c3VtZSB0aGUgcmFuZ2UgemFwcGluZyBzaG91bGQgYWxzbyBhcHBseSB0byB0aGUNCmNhc2VzIHRo
YXQgZmFzdF9wYWdlX2ZhdWx0KCkgaGFuZGxlcz8NCg0KDQo=
