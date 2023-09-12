Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3D79C1D7
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 03:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjILBqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 21:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbjILBpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 21:45:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186011A4BDD
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 17:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694479267; x=1726015267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nGMyOY1wn/OyMsRcgwc8H4FvyLZiWqof64aJqbk+680=;
  b=gkk7Ux3qfrNQxUsY+vRUSpSAT+niGh3cspeOQHm8XwpGi548BLI+p/iy
   4GK46ycRo7qVFi2rqe9w420DxailqLIUdEXjD4ARHcBU6/oMVFhOgZNaZ
   rkqLMIBoQfEIM5Wn4KZjfafY3h9LZeHe+Qb9Zvkw89QHYfiUOHaRlWVO/
   2fT8x/1I/eZXRE+MPf/I32eG0ee8UuArMnqWVataH3B8StJYAIRMO22wK
   8ibQTnYUsb+B/BbBtaYgJwzOBBr6IT7TfmfnS/qAe2DibMzgBbp+ATv1s
   YLPmh1A6dKv+57CmbI7isxo+OHBG11ujSTQ56xHaAIrzAfRpEwtSYfHtV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="380943997"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="380943997"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 17:35:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="867152452"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="867152452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 17:35:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 17:35:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 17:35:57 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 17:35:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSdtcXk/a+PhHKYiNBrYnkAt67wFaFjZuo7SktfvBV97rkcRWtrpbx+igznv7It+eBZfJf9TAmzJklyxqV04lGd3yYcyeZn2KwTchnxA1Bg4pMfwcKVu+umdnBC6j/39p6JdLW/DuLOZ13brQ1uNseaEOZ/M7gmXq9mw5luo3qvqow2q6S4MBeQ8cZvKnoy5a8x7VcbgVd1aFC91/o08F/QqcxdrC5ZNkJ79zs9IDS/Y6OeHzcZ67/mVkmaPxYGp/GhGe41i3kmdKGL7h/GwApZtcDLovzu6rSxwGTUDgKJr5l37BxO5aBgT2OEJhbON6kVc0mCw7On5Lyw4OoV42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGMyOY1wn/OyMsRcgwc8H4FvyLZiWqof64aJqbk+680=;
 b=kty8SKdHo1mDRyUEYU0huifHknKQPyjUaSY9ICk8YwVNjeqYYKiR7wytNol8NIpE8ZkzHNpuiVtRpKgJTTkpDzXbTlJ/YEMMHGi0HHdt/xt2Ovu63iu7l3Yv1+9AyjAR3CNJFypSEO2z2UW29NCwUUl4hqZCbFLrza+0GrFif83hrx5820eys5J1K+iElDJSdeKyrCK5oxcgYM3H/3eplcngq4G3kKCjZDMu3bN3rkr9p5bCj72j4CjW1tpHpuIVw2AeUA94wfS4ZozwS+QM9smU3dVZTNCelS6BgaAx7JxrVu5j+fJ/B5p4n0BYsR5nitimdMblclQzoIjk6uhzbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by CH3PR11MB8238.namprd11.prod.outlook.com (2603:10b6:610:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 00:35:54 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 00:35:54 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: RE: [PATCH 9/9] KVM: selftests: Add fixed counters enumeration test
 case
Thread-Topic: [PATCH 9/9] KVM: selftests: Add fixed counters enumeration test
 case
Thread-Index: AQHZ3KYny+yXM7En6UO+BR/6h6Qc9rAU/9iAgAFndfA=
Date:   Tue, 12 Sep 2023 00:35:54 +0000
Message-ID: <MW4PR11MB5824A7B9869C94A8E5D2064BBBF1A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-10-xiong.y.zhang@intel.com>
 <f94d2d9c-3f20-b024-bc7d-cb1611eae86b@linux.intel.com>
In-Reply-To: <f94d2d9c-3f20-b024-bc7d-cb1611eae86b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|CH3PR11MB8238:EE_
x-ms-office365-filtering-correlation-id: dd6036bd-fe64-4a63-b2be-08dbb328397c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uk7D1R5QdewEuiJ8gx/B8ApyUQ/7Mo5Koj+nUuGxQcfqQKkodz31l+RxoIUk9/HE0yTGV7utY9/Km/ok88RLWm+pM4FBDsT1i3LNPL1F06FQVWkFR1AsiZr9oC5Hd7+UKujlQkyyMmclIHO56uDzLf6IeAO9haL7D1rPFYZVmHmpCbA/Cow82tqioOwvmvw+jbMFVXF8YQgKxnjk8iH3LE+DsYRb2hN0NQpACYxwqdfnjJgFXeQp/EbBsMmBTDMgInMF1usrBowvmjcUuo5SkktmRAXZf/uSVYbpXtLdeqjFBBpL6kLj06pCeOuMYrgLOHmmQ550qYdtNZDDRPtykBXIpMdPeAQWBL+wZY1xD7xhJbP3e3qZcBLGXnBIptVWPXdSV6Sl+SqignU525G82/WwSvFj6xkT2KfDSW4vrOiQ/1mVWTh/S2eXTTD8yV/4sFqZDnI2nyUbc9HIUCETxDzP2vcKazyVHGSOVUpIRIo9ppcJK0L969QmEvMmHQ+J+VWONeYmIVilx1+LD5NtZ0WUYHqKCdksyGi/OeoYTPDWKqf6CatHeLwp1X6X5A9Sq4CZb7cmum3qdtYozOTARbc9Zt+NI2gocdtYCPbRl9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199024)(1800799009)(186009)(110136005)(53546011)(7696005)(6506007)(71200400001)(41300700001)(122000001)(52536014)(38100700002)(86362001)(38070700005)(82960400001)(55016003)(33656002)(2906002)(9686003)(966005)(478600001)(83380400001)(316002)(4326008)(5660300002)(8676002)(8936002)(66476007)(76116006)(26005)(54906003)(66446008)(66946007)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1RvcDQ5T1JseUJNKzRWdFBOV1ZhZitlMW16NUhXa2UreUVRVVpnNmEzZG91?=
 =?utf-8?B?NzdIK3liVE5wNm4vUEs0K3I5djMvUmtrU3pKMlRlekEwKzUzSDU2ZG1RenVG?=
 =?utf-8?B?Y00zU012b29WUHpXcERrMVlaWnNTVFh6L09hTEJTVmphRE1KVkk5QnBHdEx2?=
 =?utf-8?B?R3Q1R0VPWjk1Rkl5ZUwyL1lMdVZGeGY1bmhTRTZNNUIwNVhDaWhlaFdNKzJZ?=
 =?utf-8?B?ZFlUanFnQzY0ZjNoOHpGUUY3WGlZTlRUY2Y4azIzOGNFWXdsOUZPUzc5YVht?=
 =?utf-8?B?QUNkV0tjUy9kcVc3a1VycUU4QTA1dXM2V3JJS0xQYmJWaWl4ZE9GeUlObk9Q?=
 =?utf-8?B?NTk0bjR1Szh0S2w2SUM1RnAzOEZNdFlmNjFTTnRTNTYxVkZvNElZaFVDYWVW?=
 =?utf-8?B?Uy9UeUV3RVRiK0tBUS9TQXFiSUZSYitZMTk3ZnF5QjZwWVR3L24yTFNVYVBz?=
 =?utf-8?B?cGd1dkdlQVJxYWxQSGZaMkZZRnlja2NKa0VtcU1tejNISkNEWHhiaUo1WXQ1?=
 =?utf-8?B?citWZmFKTnpLOUV1cHJzekJ5ZDNlenJaVXppNjZINzNtUmcvNjV1MlNOVEd5?=
 =?utf-8?B?WjV4Yi83VzB6NitHbVBuWG0wZFNMQWlXU3BOQ2VXeXVSZjlGNHZBVUh4b252?=
 =?utf-8?B?Mm1nUmh0QzJoOXFYRjVqN250OVBLUWUwUmltVkl0ckQrM2dFN25kU3FxRmxF?=
 =?utf-8?B?YVp2UDFDYlZtNVFEREo5VnJtMDF4Wm1Udk5COHUyNmljMENjdDBNOVpDcXgy?=
 =?utf-8?B?TWZOK0M0Y1U1bGNQK3JBTTlDTk1jQ25zdXZTbTZteW1jbUwxQ2FQSmtaelZU?=
 =?utf-8?B?VkRnOWlXd04wRlRPSWIxc3JzbldsUGF3bVAwMXBCRllBK3V1WjFKdjZTOFJL?=
 =?utf-8?B?cnBiT1JFS3ZjcTdGcU4vRHh6NFhPWWpsMm9XWlBqY2hBMXg1L3F2SnZ3VVFI?=
 =?utf-8?B?aU5jVytlYnFqNVQ0cVgvcjJMSFRuZ1JaNFM5aWtVRjhtQVErcC9pUXN5MnBK?=
 =?utf-8?B?dEJUeVJUUnVkTXpWcXdYbDcwSEx4V2tjemNSd256alBSc1JqSytwWTd2NnNa?=
 =?utf-8?B?dlFMNjkvSmZQaWJZSGtQNERHcXNQdk1rS3JicjViSFRyNW5MYlFjeUZ1bGJm?=
 =?utf-8?B?aWVyUldKcWwrVE9wUmhtNVJNYXZvUWw4S3hXeXNCdWhHUHpaSGRldG90Qmpt?=
 =?utf-8?B?eUlqeUQyU3BRZDRhZnJ0dVh3OGJDdng4Rzl1S0R6L2toVG15aHhkSzdnNHdB?=
 =?utf-8?B?NFVLWWNGRHRCYnVjdXBSZzk0ZGZteUt5cnpzRjlmTTluNjZ4SlpWN20ySTE2?=
 =?utf-8?B?VzRPajZwU2JqeEFsMVh6eUl4a2s4cVVqSHlDSVRPNENrQWl1UC8yb1ByblUw?=
 =?utf-8?B?Z3AzUDE1OVREMEI5TWdOelVVK2kxWlMvNGdLMCtOYVd3Q0xZNzNQVWhidzZn?=
 =?utf-8?B?TGZMeXdLWW4rZEpsRDB1MVZzU0ppNVl0YnVBY01tNHhJckpkZVhMQm1ZSkRi?=
 =?utf-8?B?cFVnNlh2MFl0THZKK1AwNTFFaG8xWnY3cWpDckZabWpRY2x1NFI5Q0Q4eGlK?=
 =?utf-8?B?eXZXMUtRQ0NiY1N1SVEwMWduM3V2U3N4Y3RyaVhlb0VuZll0YjhGV3BoL0kz?=
 =?utf-8?B?bEphZ3ZMZUMzVGNhNXdhOTJ4MndmRVJsUUlGS2l2dlJYK0hGYjgzWmJCMkJX?=
 =?utf-8?B?R0lzenBGR1AzcElSbjBGSHorTXoxbG1yR2dQbnNrYUlBVGtZc2NlcnZIVjY2?=
 =?utf-8?B?c25jdzZUWDErR1ZoUUpheUlaQjJtOE1ZWkc2aGppV2Nsa25yKzhQZnpiRHVV?=
 =?utf-8?B?YjdHZFpSR2lpTnF6bjdzbUVINTY4QlFHbkozOE5POC9uUDdJU0JFd3czZ1ZE?=
 =?utf-8?B?Vjk1czZDS0l2cldWclNiK3hWNENqdDNVZDlJaC9CZWRHTDhOUXZJRHJVbGRB?=
 =?utf-8?B?NjVMMVZXRkZ4U05Fa0s2YkZhbGxwaENlL3BGRXNYQzQxNURiK3VTaWorR3hN?=
 =?utf-8?B?cEtJSXVSUmFGZEhyRkZ4ZmVQeUVRYXhkRXd2K1F4TllpR0RjNGttSkdIN01R?=
 =?utf-8?B?cHp4TmdSU1NoUmsvNFBQRzIwSEdhY1NXakRwcFROR3hWdDRJRkxQVVVFT2Qr?=
 =?utf-8?Q?peXxx/2HeQM6ZQhVzVYj3kkVW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6036bd-fe64-4a63-b2be-08dbb328397c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 00:35:54.7530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: US7jpz7xja1M7lsBM8kYJhCz30a70ZSBekb7MU9AzeXQJVlH5DYgl1VlWVnuzNUpeYO0SEKRHVUeOZ+ZXUL73w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8238
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

PiBPbiA5LzEvMjAyMyAzOjI4IFBNLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiB2UE1VIHY1IGFk
ZHMgZml4ZWQgY291bnRlciBlbnVtZXJhdGlvbiwgd2hpY2ggYWxsb3dzIHVzZXIgc3BhY2UgdG8N
Cj4gPiBzcGVjaWZ5IHdoaWNoIGZpeGVkIGNvdW50ZXJzIGFyZSBzdXBwb3J0ZWQgdGhyb3VnaCBl
bXVsYXRlZA0KPiA+IENQVUlELjBBaC5FQ1guDQo+ID4NCj4gPiBUaGlzIGNvbW1pdCBhZGRzIGEg
dGVzdCBjYXNlIHdoaWNoIHNwZWNpZnkgdGhlIG1heCBmaXhlZCBjb3VudGVyDQo+ID4gc3VwcG9y
dGVkIG9ubHksIHNvIGd1ZXN0IGNhbiBhY2Nlc3MgdGhlIG1heCBmaXhlZCBjb3VudGVyIG9ubHks
ICNHUA0KPiA+IGV4Y2VwdGlvbiB3aWxsIGJlIGhhcHBlbiBvbmNlIGd1ZXN0IGFjY2VzcyBvdGhl
ciBmaXhlZCBjb3VudGVycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpb25nIFpoYW5nIDx4
aW9uZy55LnpoYW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIC4uLi9zZWxmdGVzdHMva3Zt
L3g4Nl82NC92bXhfcG11X2NhcHNfdGVzdC5jICB8IDg0ICsrKysrKysrKysrKysrKysrKysNCj4g
PiAgIDEgZmlsZSBjaGFuZ2VkLCA4NCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL3g4Nl82NC92bXhfcG11X2NhcHNfdGVzdC5j
DQo+ID4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L3ZteF9wbXVfY2Fwc190
ZXN0LmMNCj4gPiBpbmRleCBlYmJjYjBhM2Y3NDMuLmUzN2RjMzkxNjRmZSAxMDA2NDQNCj4gPiAt
LS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L3ZteF9wbXVfY2Fwc190ZXN0
LmMNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L3ZteF9wbXVf
Y2Fwc190ZXN0LmMNCj4gDQo+IA0KPiBzaW5jZSB3ZSBhZGRlZCBuZXcgdGVzdCBjYXNlc8KgIGlu
IHRoaXMgZmlsZSwgdGhpcyBmaWxlIGlzIG5vdCBqdXN0IHRlc3QNCj4gJ3BlcmZfY2FwYWJsaXRp
ZXMnIGFueW1vcmUsIHdlIG1heSBjaGFuZ2UgdGhlIGZpbGUgbmFtZSB2bXhfcG11X2NhcHNfdGVz
dC5jDQo+IHRvIGEgbW9yZSBnZW5lcmljIG5hbWUgbGlrZSAidm14X3BtdV90ZXN0LmMiIG9yIHNv
bWV0aGluZyBlbHNlLg0KWWVzLCAgSSB3aWxsIG1vdmUgaXQgaW50byB2bXhfY291bnRlcnNfdGVz
dC5jIGFmdGVyIHRoaXMgc2VyaWFsIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvWk42c29w
WGE4YXc4REczd0Bnb29nbGUuY29tL1QvIGlzIG1lcmdlZC4NCj4gDQo+ID4gQEAgLTE4LDYgKzE4
LDggQEANCj4gPiAgICNpbmNsdWRlICJrdm1fdXRpbC5oIg0KPiA+ICAgI2luY2x1ZGUgInZteC5o
Ig0KPiA+DQo+ID4gK3VpbnQ4X3QgZml4ZWRfY291bnRlcl9udW07DQo+ID4gKw0KPiA+ICAgdW5p
b24gcGVyZl9jYXBhYmlsaXRpZXMgew0KPiA+ICAgCXN0cnVjdCB7DQo+ID4gICAJCXU2NAlsYnJf
Zm9ybWF0OjY7DQo+ID4gQEAgLTIzMyw2ICsyMzUsODYgQEAgc3RhdGljIHZvaWQgdGVzdF9sYnJf
cGVyZl9jYXBhYmlsaXRpZXModW5pb24NCj4gcGVyZl9jYXBhYmlsaXRpZXMgaG9zdF9jYXApDQo+
ID4gICAJa3ZtX3ZtX2ZyZWUodm0pOw0KPiA+ICAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIGd1
ZXN0X3Y1X2NvZGUodm9pZCkNCj4gPiArew0KPiA+ICsJdWludDhfdCAgdmVjdG9yLCBpOw0KPiA+
ICsJdWludDY0X3QgdmFsOw0KPiA+ICsNCj4gPiArCWZvciAoaSA9IDA7IGkgPCBmaXhlZF9jb3Vu
dGVyX251bTsgaSsrKSB7DQo+ID4gKwkJdmVjdG9yID0gcmRtc3Jfc2FmZShNU1JfQ09SRV9QRVJG
X0ZJWEVEX0NUUjAgKyBpLCAmdmFsKTsNCj4gPiArDQo+ID4gKwkJLyoNCj4gPiArCQkgKiBPbmx5
IHRoZSBtYXggZml4ZWQgY291bnRlciBpcyBzdXBwb3J0ZWQsICNHUCB3aWxsIGJlDQo+IGdlbmVy
YXRlZA0KPiA+ICsJCSAqIHdoZW4gZ3Vlc3QgYWNjZXNzIG90aGVyIGZpeGVkIGNvdW50ZXJzLg0K
PiA+ICsJCSAqLw0KPiA+ICsJCWlmIChpID09IGZpeGVkX2NvdW50ZXJfbnVtIC0gMSkNCj4gPiAr
CQkJX19HVUVTVF9BU1NFUlQodmVjdG9yICE9IEdQX1ZFQ1RPUiwNCj4gPiArCQkJCSAgICAgICAi
TWF4IEZpeGVkIGNvdW50ZXIgaXMgYWNjZXNzaWJsZSwgYnV0IGdldA0KPiAjR1AiKTsNCj4gPiAr
CQllbHNlDQo+ID4gKwkJCV9fR1VFU1RfQVNTRVJUKHZlY3RvciA9PSBHUF9WRUNUT1IsDQo+ID4g
KwkJCQkgICAgICAgIkZpeGVkIGNvdW50ZXIgaXNuJ3QgYWNjZXNzaWJsZSwgYnV0IGFjY2VzcyBp
cw0KPiBvayIpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCUdVRVNUX0RPTkUoKTsNCj4gPiArfQ0K
PiA+ICsNCj4gPiArI2RlZmluZSBQTVVfTlJfRklYRURfQ09VTlRFUlNfTUFTSyAgMHgxZg0KPiA+
ICsNCj4gPiArc3RhdGljIHZvaWQgdGVzdF9maXhlZF9jb3VudGVyX2VudW1lcmF0aW9uKHZvaWQp
DQo+ID4gK3sNCj4gPiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsNCj4gPiArCXN0cnVjdCBrdm1f
dm0gKnZtOw0KPiA+ICsJaW50IHI7DQo+ID4gKwlzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZW50
Ow0KPiA+ICsJc3RydWN0IHVjYWxsIHVjOw0KPiA+ICsJdWludDMyX3QgZml4ZWRfY291bnRlcl9i
aXRfbWFzazsNCj4gPiArDQo+ID4gKwlpZiAoa3ZtX2NwdV9wcm9wZXJ0eShYODZfUFJPUEVSVFlf
UE1VX1ZFUlNJT04pICE9IDUpDQo+ID4gKwkJcmV0dXJuOw0KPiANCj4gDQo+IFdlJ2QgYmV0dGVy
IGNoZWNrIGlmIHRoZSB2ZXJzaW9uIGlzIGxlc3MgdGhhbiA1IGhlcmUsIHNpbmNlIHdlIG1pZ2h0
IGhhdmUgaGlnaGVyDQo+IHZlcnNpb24gdGhhbiA1IGluIHRoZSBmdXR1cmUuDQpTdXJlLCBjaGFu
Z2UgaXQgaW4gbmV4dCB2ZXJzaW9uLg0KPiANCj4gDQo+ID4gKw0KPiA+ICsJdm0gPSB2bV9jcmVh
dGVfd2l0aF9vbmVfdmNwdSgmdmNwdSwgZ3Vlc3RfdjVfY29kZSk7DQo+ID4gKwl2bV9pbml0X2Rl
c2NyaXB0b3JfdGFibGVzKHZtKTsNCj4gPiArCXZjcHVfaW5pdF9kZXNjcmlwdG9yX3RhYmxlcyh2
Y3B1KTsNCj4gPiArDQo+ID4gKwllbnQgPSB2Y3B1X2dldF9jcHVpZF9lbnRyeSh2Y3B1LCAweGEp
Ow0KPiA+ICsJZml4ZWRfY291bnRlcl9udW0gPSBlbnQtPmVkeCAmIFBNVV9OUl9GSVhFRF9DT1VO
VEVSU19NQVNLOw0KPiA+ICsJVEVTVF9BU1NFUlQoZml4ZWRfY291bnRlcl9udW0gPiAwLCAiZml4
ZWQgY291bnRlciBpc24ndCBzdXBwb3J0ZWQiKTsNCj4gPiArCWZpeGVkX2NvdW50ZXJfYml0X21h
c2sgPSAoMXVsIDw8IGZpeGVkX2NvdW50ZXJfbnVtKSAtIDE7DQo+ID4gKwlURVNUX0FTU0VSVChl
bnQtPmVjeCA9PSBmaXhlZF9jb3VudGVyX2JpdF9tYXNrLA0KPiA+ICsJCSAgICAiY3B1aWQuMHhh
LmVjeCAhPSAleCIsIGZpeGVkX2NvdW50ZXJfYml0X21hc2spOw0KPiA+ICsNCj4gPiArCS8qIEZp
eGVkIGNvdW50ZXIgMCBpc24ndCBpbiBlY3gsIGJ1dCBpbiBlZHgsIHNldF9jcHVpZCBzaG91bGQg
YmUgZXJyb3IuICovDQo+ID4gKwllbnQtPmVjeCAmPSB+MHgxOw0KPiA+ICsJciA9IF9fdmNwdV9z
ZXRfY3B1aWQodmNwdSk7DQo+ID4gKwlURVNUX0FTU0VSVChyLCAiU2V0dGluZyBpbi1jb25zaXN0
ZW5jeSBjcHVpZC4weGEuZWN4IGFuZCBlZHggc3VjY2VzcyIpOw0KPiA+ICsNCj4gPiArCWlmIChm
aXhlZF9jb3VudGVyX251bSA9PSAxKSB7DQo+ID4gKwkJa3ZtX3ZtX2ZyZWUodm0pOw0KPiA+ICsJ
CXJldHVybjsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKiBTdXBwb3J0IHRoZSBtYXggRml4ZWQg
Q291bnRlciBvbmx5ICovDQo+ID4gKwllbnQtPmVjeCA9IDFVTCA8PCAoZml4ZWRfY291bnRlcl9u
dW0gLSAxKTsNCj4gPiArCWVudC0+ZWR4ICY9IH4odTMyKVBNVV9OUl9GSVhFRF9DT1VOVEVSU19N
QVNLOw0KPiA+ICsNCj4gPiArCXIgPSBfX3ZjcHVfc2V0X2NwdWlkKHZjcHUpOw0KPiA+ICsJVEVT
VF9BU1NFUlQoIXIsICJTZXR0aW5nIG1vZGlmaWVkIGNwdWlkLjB4YS5lY3ggYW5kIGVkeCBmYWls
ZWQiKTsNCj4gPiArDQo+ID4gKwl2Y3B1X3J1bih2Y3B1KTsNCj4gPiArDQo+ID4gKwlzd2l0Y2gg
KGdldF91Y2FsbCh2Y3B1LCAmdWMpKSB7DQo+ID4gKwljYXNlIFVDQUxMX0FCT1JUOg0KPiA+ICsJ
CVJFUE9SVF9HVUVTVF9BU1NFUlQodWMpOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBVQ0FM
TF9ET05FOg0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJZGVmYXVsdDoNCj4gPiArCQlURVNUX0ZBSUwo
IlVuZXhwZWN0ZWQgdWNhbGw6ICVsdSIsIHVjLmNtZCk7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJ
a3ZtX3ZtX2ZyZWUodm0pOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICAgaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKmFyZ3ZbXSkNCj4gPiAgIHsNCj4gPiAgIAl1bmlvbiBwZXJmX2NhcGFiaWxpdGllcyBo
b3N0X2NhcDsNCj4gPiBAQCAtMjUzLDQgKzMzNSw2IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFy
ICphcmd2W10pDQo+ID4gICAJdGVzdF9pbW11dGFibGVfcGVyZl9jYXBhYmlsaXRpZXMoaG9zdF9j
YXApOw0KPiA+ICAgCXRlc3RfZ3Vlc3Rfd3Jtc3JfcGVyZl9jYXBhYmlsaXRpZXMoaG9zdF9jYXAp
Ow0KPiA+ICAgCXRlc3RfbGJyX3BlcmZfY2FwYWJpbGl0aWVzKGhvc3RfY2FwKTsNCj4gPiArDQo+
ID4gKwl0ZXN0X2ZpeGVkX2NvdW50ZXJfZW51bWVyYXRpb24oKTsNCj4gPiAgIH0NCg==
