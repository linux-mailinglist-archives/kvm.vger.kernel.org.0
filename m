Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCAC700600
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbjELKus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240186AbjELKuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:50:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BFC12E92;
        Fri, 12 May 2023 03:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683888617; x=1715424617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kzOS2IW4BvPJTaqsCmphobd2AadEB1Kq9yp0Iqgvl0A=;
  b=Nm1U5ShmGpCjj36mpJoSffUtLG8ZvXZZwKVx5BRJbhnNYp+I1/c2yZqZ
   sRw9tfjMhS0V26Lt6u++5hP+6pNIVoqmVgZ5z0gbMeXpEn+amMWELsnQZ
   jcmAZwCg11ceIlm84NdzoZZUeoRbadQ8xggetcP17iqqvK/tZPbOdAlO7
   pW1dtilHu4qMBmGMmrsUrlmTcbHfa8yJv13HRa8slI7ZPCgztRpGNkCRv
   rT+LRnyYZbuAImPNX3ICH5OuceX+JsKsYR92eO1iT6AfVAW2gw4c7lxPZ
   lHQ2ipaZwsHic9hQbMG2ao7M7uC6QRlE8KBiCflY3vait8AMQP2zt6lwL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="340075865"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="340075865"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="700139176"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="700139176"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 12 May 2023 03:49:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:49:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:49:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+Xr9WQpbe/7qrbVIbk+4nSbI6P1XuP3VVlAWoQW1Jv+kyzVWrfVUQdL1317DaTQSVNDe4J14slSacQfbCUCO0SeY333o3IHE3MTK2c6X2ZoO2gyVtmNTpZKMMznC9xD02TQL8BaWCV/w1FMwXHfEgpCOIj9ocgzZivutOmzEj9cJkv2S/kVRhfkCFAkWKz+4B0eEwA7lCWQKFZzAn1Tjexmnfk9WsOYxG4qC6NFqGkDanNKfV3HVupHN34v3SbUJC6ljF72p6EE85BxGyWPlyfLsTYdEM11BfAZks86I1ssrZulsN0eDjOqIkFxoA2BTxXk8fetXCzFC3b1QZwLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzOS2IW4BvPJTaqsCmphobd2AadEB1Kq9yp0Iqgvl0A=;
 b=fGz1eTsQtREZAD9sNQXmUxidYVj2KEShQy3mP6r5rfA+0oJS9C6ugqNGXm6QRufm+YP4EYGg4fkTUOONJm7+q0rpZ+0awtglnMghHciys2ZM9vvkK+tgNe1qT/S3g5dcPZ0qoNlLcJEDTaodUioI6ZsGVxaqy9O/USCcc1xhCcKuVpTzu6Cv5Iq/4H9uYQW/8pr0P3k8PtV6nbh7lbHIjesxTIT0EQ5btjmszwOe2MPGeuwXn66h2DpDAnVLxUpAWeYX9pb+EP+XjDR0GURK3EfXOjhlEgKXN91SOlHFDvR35Tbsp3v9usV6U6YY3+rhxVVK7zBI75/vnfNpdW9+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 10:49:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:49:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Topic: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Index: AQHZgwWcGoITj2apJUG2jRGbN3NxlK9VCGeAgADVMYCAAJs9AA==
Date:   Fri, 12 May 2023 10:49:36 +0000
Message-ID: <982ce5177647331b7b9f6526dfe064b76a921d06.camel@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
         <20230510060611.12950-3-binbin.wu@linux.intel.com>
         <67a20fe2a41fbe99de1470254b14f282f72571c7.camel@intel.com>
         <abbb7938-0615-8578-0072-a96d21df3b4d@linux.intel.com>
In-Reply-To: <abbb7938-0615-8578-0072-a96d21df3b4d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6805:EE_
x-ms-office365-filtering-correlation-id: 7f865378-e81f-41d8-758d-08db52d69455
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NTctQm5sQc/+5rUH47N/+LYj+OqknGHzB/4zLTZ/E0k3sp6/Vqffu/h+q8DlxhfO6i5ac3K1Y6iOZjM8wqLolOspNaesvrzaJZ5FWzGG3/YKyVUpAw0AtGIjQIPxTHDr1T3HrGqGtc6+7g7TW8voV8ypEknnnjB1pDIveD+FCJCphq7eUWZXq18k3Mz5D53Rfu88R/vFLRTUzdjDd8+ztj3hHhnyiotZTwF+XhbjUmhtMgxXV7RS23fgHbhO2+oxP0HdbmdhO/krf6phiKFjhhtuq0bKUB2Y4SHloq7dS2nLKfKwB+UUaU+h/NVtTOWvjfB0WGPY4OO1B/Iv2yyyer9FfQWcUJISl2SDwLVP/7wM12o+U2EkFCgPgQEti1xd1uiTvlTy8aSiNMZD9EC9RQ6kckNbpFPGFPhEy/IS3xJhGpf0S8YrE18iNte2qnrCQ/dnV5r0DG8+WP+Pw6gVsahv1ojmPLgDVhfo3S79mA52On5WYp6xwqk049A/zR7CoxdcSzADi2Y0vpnXidCSISiUB9RqOJngs/iLwxVKGR5rsFWQ2EB8QxKSUaqknO7wBUEOJoh/5n0QAb1V36DeWYytm2c5m22t0UqjC7feeN8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199021)(76116006)(66446008)(6916009)(66946007)(66556008)(4326008)(64756008)(316002)(66476007)(91956017)(478600001)(83380400001)(122000001)(41300700001)(82960400001)(54906003)(2616005)(38100700002)(8676002)(8936002)(966005)(6506007)(86362001)(6512007)(186003)(26005)(38070700005)(2906002)(5660300002)(71200400001)(6486002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmQ2M01YdDNtVGgzNWZCK2lhQWs4bzFVVWtFOERKdVAvWVg1Qld6d0EyZkUy?=
 =?utf-8?B?OEZGeWl1cHFONERBUFlKcTlReFpHczdVVVN6RU9CWUFuc3l4cTYwME1EV3Zu?=
 =?utf-8?B?M2xRRlhUckRvSlc0NUg3V2ltVGpqeTdJQXU4ZUl3ZVAxUnJIbHpSc0xqMWdx?=
 =?utf-8?B?TUtqZWFma1VIS2dXQUs1cW0vNUJ5UFpxd2pPZFcvWnhjYmlBaEtSNnpzVUsr?=
 =?utf-8?B?L2dHb1VDUlF3OWoxcStDUDFyVjJKZEcrTllRYnRNQ1BFNWRxNU9oQ3JpT3ZK?=
 =?utf-8?B?eHNlSytWTzBlRDdrZTVCOWphRTZjTUgxaWRzNzd3M1lkWEFIQlhRYmRDQjk5?=
 =?utf-8?B?NC9KSEV6cFZzMngyRVAvbzIxczZYNXRWTFo4Z3JBc0dyLzg0cUhQUDVJdXdj?=
 =?utf-8?B?blpRVXpPQ1NZT1kvS1UvL3NFcW9WUW5oUHE2VVNubUpkaWt3YkY3V1BBaWZh?=
 =?utf-8?B?Ry9VZnNjTTFsNDR6NlVYRE54ZlI5cUZveU53a0Q0RHVCdmU0TlFUQkJXOEc0?=
 =?utf-8?B?NC9EOGIxUi9LNXBXT2hkMW1FK1kvbjl0bERTajNHWnNybE9hUUNnVEJmbTZl?=
 =?utf-8?B?R2FJVkpveFVXNStiOS9rRHplR3pXQ2U0aEt0SnMrWjZVbjMrdVlmZ0tJaWJK?=
 =?utf-8?B?eHZsSTk5c0Z4ZHRvRGhsWlBCRkFxb0RPWDNvZTA1YlpCKzZ6ejdsNk1VM3FI?=
 =?utf-8?B?UENLTGVZRFl5R3RlSVdTajZFL0tCOUd5aDZJcTJqVHMwTVBqQlh6ZHFrOEdC?=
 =?utf-8?B?ODltUC9tbnUrTVpOaDVaOEIrN3ZGZ1l3VUtuYnlyWHFpbGdTNkNLMmNwd2E5?=
 =?utf-8?B?ODNoSE1aaEFMNm9tdDlLWEhWSkMxSlVGOWxnY3dQZC8rVTFGZ1BLc3J4a01R?=
 =?utf-8?B?MTZHK0VZd3hzZ1o2dmlsMk1rMmc1Mll3OUtqOUhYemlpK09SUFV6ZWN5L1lP?=
 =?utf-8?B?TCt1Z1RlbTBSc2F3blFVY0xMUWk5OEVMY24zTng1LzNPV25GNjNVakkxaTcy?=
 =?utf-8?B?ZzZPbDFKQjFHVE16eDlzM0IvbVVoekpXZ2N6TFpHUFdxWFV4bWErTjNWYjhI?=
 =?utf-8?B?UXBDMHRKaG9tTGlxZ041VngyeDhzSUxkZjRZcWZMRFFkNExUcVIrdGlVTEE4?=
 =?utf-8?B?RzRubllWTFg5bDUvZlpvZjdWR2FOVkZNRnNDbVFnZWU2ckVkMlUwVWI4T3JU?=
 =?utf-8?B?VU1nd0FSTDBGaFkrSVlHdm9tblBrZHEzUnJma2pxWjh2Tm1SOWtDLytLSmx4?=
 =?utf-8?B?L1ZtVWd2cE1XamZ3SUNvTC9PMllDZzF5S2ErRTFXUHFEc1NMR25oUUN1Q1Qr?=
 =?utf-8?B?L0VkRG53ZzFrckZSSmwvSExEaXVILzJoWXFYOFZtVDJrVjFUUjcxOVVLZVBI?=
 =?utf-8?B?NlVjT040eEdKOW5aVlRENVdwZlN1MDZja09Xb2UwMjE1UkpDQ2RrTmlVVDRV?=
 =?utf-8?B?VEZTMUJxdjVaaW01d3E0RlVRdEE1dGtFMXpXNnJTKzBUSUN1WWMrbzh0Tkhz?=
 =?utf-8?B?eUticjZoWHpSMTZTTU04cXBCejRTWjg3K1loTFQ2TXdTNWpscVNHNnJjenJ1?=
 =?utf-8?B?V0tXb1N5UGdVRnVHREhCWVRYbGdKREN3alNuaWttNjFWMWN2R2FCZmJmdWln?=
 =?utf-8?B?V0FIeE04TExxdW40ZytZRnZQWk03b3Q5OTNnL1M3VWhvdnlSaGdwZWYwWjIz?=
 =?utf-8?B?dmRFSWhvR3FnRE85YTVJSit5OUZtaEp3NEJWaTRlRm02U05kWGVyUEFkK0lr?=
 =?utf-8?B?Y2VUWTlNU1hEL2lvRHBib2tSZmdHd3k1Nm1lVlFvSGFUaGRDcjNTaUJwTTl5?=
 =?utf-8?B?V25ielkyazdZU1ZLclBxa0pBdEFWTEpHdmJOYW9ISmRUQkxpRHVtVEhQQkNi?=
 =?utf-8?B?M2E0eUtXVi9zSVJHTWtFQ09UV3dCaWZucERMaWZpRW5pdUpjZHY0cDRodHF5?=
 =?utf-8?B?dlNiM1dZMVNmVU9NZ0c1WDI3dklpekpoTHc4N0Vxb0Z6b3JDVUxKSWdvZlI2?=
 =?utf-8?B?WVQ1OFlFN3NJM0xCN0NkSWVMY1lPTzdxM0JYWG4xZEtWSXBEOUhpY2FXQm55?=
 =?utf-8?B?NlVlRmZGM2IwdysvZW1IeW9BdW5HQkgzT3Z3aWhxTUhNM2dod1NRYklxMEQz?=
 =?utf-8?B?L0VibllPa2xFdnM0amtiM1M5a1VxaitTcHg5bk9KQTI3T05KVWhpbm5ubkRP?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <392565EDCD2619459FB5E1EEC5CF5920@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f865378-e81f-41d8-758d-08db52d69455
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:49:36.7863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tWNjzX/Z/J9Rd2fCGD1VVLD3mBgiMDJLaQk5QfPNtxboljGhzMyPOvh66XhskfEC14buL8R30KEDDLiRrtm1DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gPiAgIA0KPiA+IExBTSBvbmx5IGFwcGxpZXMgdG8gNjQtYml0IGxpbmVhciBhZGRyZXNz
LCB3aGljaCBtZWFucyBMQU0gY2FuIG9ubHkgYmUgZW5hYmxlZA0KPiA+IHdoZW4gQ1BVIGlzIGlu
IDY0LWJpdCBtb2RlIHdpdGggZWl0aGVyIDQtbGV2ZWwgb3IgNS1sZXZlbCBwYWdpbmcgZW5hYmxl
ZC4NCj4gPiANCj4gPiBXaGF0J3MgdGhlIGhhcmR3YXJlIGJlaGF2aW91ciBpZiB3ZSBzZXQgQ1I0
LkxBTV9TVVAgd2hlbiBDUFUgaXNuJ3QgaW4gNjQtYml0DQo+ID4gbW9kZT8gIEFuZCBob3cgZG9l
cyBWTUVOVFJZIGNoZWNrIEdVRVNUX0NSNC5MQU1fU1VQIGFuZCA2NC1iaXQgbW9kZT8NCj4gPiAN
Cj4gPiBMb29rcyB0aGV5IGFyZSBub3QgY2xlYXIgaW4gdGhlIHNwZWMgeW91IHBhc3RlZCBpbiB0
aGUgY292ZXIgbGV0dGVyOg0KPiA+IA0KPiA+IGh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9k
bC9nZXRDb250ZW50LzY3MTM2OA0KPiA+IA0KPiA+IE9yIEkgYW0gbWlzc2luZyBzb21ldGhpbmc/
DQo+IFllcywgaXQgaXMgbm90IGNsZWFybHkgZGVzY3JpYmVkIGluIExBTSBzcGVjLg0KPiBIYWQg
c29tZSBpbnRlcm5hbCBkaXNjdXNzaW9ucyBhbmQgYWxzbyBkaWQgc29tZSB0ZXN0cyBpbiBob3N0
LA0KPiBpZiB0aGUgcHJvY2Vzc29yIHN1cHBvcnRzIExBTSwgQ1I0LkxBTV9TVVAgaXMgYWxsb3dl
ZCB0byBiZSBzZXQgZXZlbiANCj4gd2hlbiBjcHUgaXNuJ3QgaW4gNjRiaXQgbW9kZS4NCj4gDQo+
IFRoZXJlIHdhcyBhIHN0YXRlbWVudCBpbiBjb21taXQgbWVzc2FnZSBvZiB0aGUgbGFzdCB2ZXJz
aW9uLCBidXQgSSANCj4gbWlzc2VkIGl0IGluIHRoaXMgdmVyc2lvbi4gSSdsbCBhZGQgaXQgYmFj
ay4NCj4gIkNSNC5MQU1fU1VQIGlzIGFsbG93ZWQgdG8gYmUgc2V0IGV2ZW4gbm90IGluIDY0LWJp
dCBtb2RlLCBidXQgaXQgd2lsbCBub3QNCj4gdGFrZSBlZmZlY3Qgc2luY2UgTEFNIG9ubHkgYXBw
bGllcyB0byA2NC1iaXQgbGluZWFyIGFkZHJlc3MuIg0KDQpZZWFoIHRoaXMgZG9lcyBoZWxwLiAg
UGxlYXNlIGFkZCBpdCBiYWNrIHRvIHRoZSBjaGFuZ2Vsb2cuDQoNCj4gDQo+IEFsc28sIEkgd2ls
bCB0cnkgdG8gYXNrIEludGVsIGd1eXMgaWYgaXQncyBwb3NzaWJsZSB0byB1cGRhdGUgdGhlIGRv
Y3VtZW50Lg0KPiANCg0KVGhhbmtzLg0KDQo=
