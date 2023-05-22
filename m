Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE12370CE94
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 01:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbjEVXOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 19:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjEVXNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:13:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC90DB;
        Mon, 22 May 2023 16:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684797220; x=1716333220;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kqIxjPNTQQx4Te1WIGbbaE1j/0QOTOUB3W0SviyTPqk=;
  b=ky60YEWDZf2mQk5Uit7axULyE80LO02LDsmhhtVbpj59pky5g/CGON+G
   RXICVx1F2sHSQ6klyPta0o8+f2A48lTvF/hcoZLrwoeO6SzpVFVVHV7Wi
   ApgKQTKmWGcK8V7WfNV/E1UKdtTMQyekdJ9k897uFWyGcJpn1Jfbr1qv2
   4tMqQRCK/nYcyGoFvBXdSLSbx5HxB7UOASTw7Vj9DadgblMXr0hHoLzyJ
   ZZU3cbD0L+EINRb2LlAJlCwtHbvuax1bE6PU1dKmDzLOekGev5DZ4uoJ2
   2jd/KlzR2zt5kk6p7YXwPA/ygz1PTcJSUQ+LIEX0cpeD92CquDGu7f34p
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="353094926"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="353094926"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:13:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="877954410"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="877954410"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2023 16:13:12 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:13:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:13:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAjye3AZ7qFI511A3OhobXEWmAoaLOhYoszLxQx41yXmrS2uzZEOj+MvwgjWwdBvPenejkB+Qe+infls8J8YRT/QLGbfvPqlMbSrJvdOQmnpTuWf2U//IpxT3O8KW2unSmVWpQHKYyual7dWzkCUHR591xi9Qoi9lKDpe9OmBoWPb8ww2dLXeiz8xjzx6v6BNWU2lfENkUqoCYXuvRfg36uC1UmQVMsZLzxFbOWBiJeWb6hxUft3N/eIQGCEL585nLNXDnYqE6nAqcOOOPbAXcyhmTyroCiqclIlnqqYc7uipcJ6/0Oel9lRmsqt5zigjwMzNfZm0rtimwC93dXfDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqIxjPNTQQx4Te1WIGbbaE1j/0QOTOUB3W0SviyTPqk=;
 b=N3JXiWsEwsZLU5oPiz1NrM5MXQ2/ADbx50Cdf3rmp+PZ5BrBuFJHK9Tg9u9XG/akfqMlo4KZHRijtqSr3ZakHYXHnbn/jLAps9mMWUTLObIYXH6QCEMgPJkDo8zNCHViuthl0nv0gP4+GDpxI1htd3/Ijw6NnWXh+bgK0n7WJfldBMuRzjfLBa42fgBxhTJYUZADY1ruvANFkCafP8z3JZnjzHoCs2LTYwG9dyZnSPiOEi/3mSzMD0yyXSYbGYvR7EbEkY4i9Xe79ln0oS75Zd6ZEZPfKPH/BVxfY2h6MrJnCQzX/CjHsAWNqsU2qGGuApFomN/xMNx7CSyeye6a/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4847.namprd11.prod.outlook.com (2603:10b6:a03:2d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:13:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:13:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 05/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
Thread-Topic: [PATCH v3 05/18] x86/reboot: Disable virtualization during
 reboot iff callback is registered
Thread-Index: AQHZhSyU1W7vpFnI9EqujWhEh9FvLq9mUZEAgABQNQCAAFnNgA==
Date:   Mon, 22 May 2023 23:13:08 +0000
Message-ID: <0fa281a2628a4ab3fde5994379a0c1bc66bec123.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-6-seanjc@google.com>
         <babc4cb3856dd5fc1bc6fa742e484667dc02c054.camel@intel.com>
         <ZGurrDEdMj6rJ6dU@google.com>
In-Reply-To: <ZGurrDEdMj6rJ6dU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4847:EE_
x-ms-office365-filtering-correlation-id: c02b0bd7-9885-4849-1518-08db5b1a1af3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MBK1y5jq44KTHEJVPKdCALAFWTgDsKd0+mry2NnOoQ5wjBNwb7xaODvD1NU5uupn31BpJAolFlfL3aNaSiryFSCwuFHjzCw4zjOMpu2pgCImRR/ZabgOWx9mIgILOltgUPGW8mAjFFDmZNYymzluUomclOS/FQke572MzqcvpEQJq2V4LqlL+ph5CDIV/ZR+IJQbrOvXj1zPjN3VZxKkwho1AXiJvSWKudtXGy2AQL26FXYewZT7aUoYAtFqqkU+EGIgWU4RXuwR7hOfiMgsJPVSgEwm/IsEP34Y7zSv1efniFPamQWqbe60CyjKeDxU5pTQ2WZbYxEz0AEwFQm592Rb16D5KOCXawOt4OVfTcdOpS0HPOD7ETX+5hz8MjalS+2wzid/RWfowE6nTGhQeStGWJ7p9EYfgCxBHp3OAgUtnfOpm64PrwXHNcXwa+kAAIsrbecA+MDBYLtEx/1Xs4B5uVNT3UFEN3vcMRg/pg/Q1VsMPfujuzoi3sioVfIK9kdO4I3ABKneWUSgN3IU+jTuK58WpOrggrDVUvHJ24rrknds/aOr4yTzcS6XYhMnQV4rp2PfZ0Y0tZ3RwgzcJdBA3xiGY1zNcc7NNYcSx57Dtrlnm8cRw6qa5ziAbvq7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(2906002)(5660300002)(83380400001)(8676002)(8936002)(91956017)(66446008)(76116006)(36756003)(66946007)(66556008)(6486002)(66476007)(6916009)(4326008)(54906003)(316002)(41300700001)(478600001)(71200400001)(64756008)(86362001)(26005)(2616005)(122000001)(82960400001)(6512007)(186003)(6506007)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THZzRGFsQXM0U2tvdFE3ekN6dE4xQ0dEMzlEbUtvZlRmdXRoN2lld28vWExi?=
 =?utf-8?B?bk9nZUdNOVJWVHoyL1k3OUF1WlBhS2lkU2hLS09DZFREU2ZCMkY5SmdsMWo2?=
 =?utf-8?B?a3RlazBOVzBNQU9BRUJKRmV6QzUxSnJqL3NBQmRTTDEyQ3FxME93Um0vb1g3?=
 =?utf-8?B?cGxUcGF2ZnZvek5oamY2blhKcDZYS2VqdkZOd2orRFhXYmR2UmZVYks0NUNF?=
 =?utf-8?B?RlBxcXF2RFZtVzFhdHJYRXd2RHo2TG5ONlE2SnhWSE4rVVZXSjdnazk1VHJR?=
 =?utf-8?B?V0YzK1ZTZVpML1plSHZlWjQ5V1g4UnBBYVZxZk83YXBTcitJVjBpZytlMlpW?=
 =?utf-8?B?dHpCYTlZa1pZR0cybTM4ZGhkZDF4UWd0RWpaVDJoMHltbWJSbmswZEFWamR3?=
 =?utf-8?B?WHY4R0pEb0dwaUdrdXNqWUxaQTI5WDJMUG0zNXByMHE1djlFM05GNllRaFZw?=
 =?utf-8?B?U2RhbnBMczdpeDdjditoV0VoYldLamg1TGR2MSs0Q2hmbngrR0ZhdHRCM0pL?=
 =?utf-8?B?OFNydTN4VUZCMTF3UnQzNytWb0xodFhyTmZyd3NmMUYySUpxb21yWllrQ0sx?=
 =?utf-8?B?UE42Tm15eGZCVERLOWpxTU5lM2twM2Eyd29mSTk5NG1GeTBPS1FKMWxURGU0?=
 =?utf-8?B?SjgydVlERzV4dVZqNzN6Wkc4d2FKOHRUWWFGUnN1RUlWRllwL3I4VGl2SW9h?=
 =?utf-8?B?OVI3YTdmU3RnRGE3M2s4eU1MTTA0MDZCWVdEVFJaRE1lbVY4SWphTjIrZlMv?=
 =?utf-8?B?anJJWHNFb3RTSTFHVytWNWIrZ0pXdk12YVVDTVJ1N1FOaEU1aHVFY3pUUEdu?=
 =?utf-8?B?UjdSQk1jaGFiNzZsd29PeGZZR3UzbSt6WlRsMVUvRDFBRnhLL0xrQ21HdmZk?=
 =?utf-8?B?aXBwelBoK2xCNmtEYjdQajV6SFdDVit6R3dnSy9pM0J3cDd5U2NUc280SEEr?=
 =?utf-8?B?eFhkK3RTalNCakltc0g3enJweHdJeGtQM1dhcjB3Z3ROYk1rMUJnK0V5OGZD?=
 =?utf-8?B?aVJqRU1xRSttRVpyZWdZVUdrYWliTTU2V2VIREFuNXpuS1RiUm5VZ0x6TUVz?=
 =?utf-8?B?RlZ2TW9VMEZxV2NGdHkrNFF6Zlk2aVpxamE2U0QvT2t0d3U2YW9uM241WU9k?=
 =?utf-8?B?SHV5bXhnZ0tDWkVvWTZSK2NTYVlpUXo4Z0I2TStnenZONlpSQTQzcDA4Q3FO?=
 =?utf-8?B?WHEzNlhBVEpWem9sb1hvbnFqaUY1MkVXZTloMVhnWXJZNHZRdzFjcVd4azN6?=
 =?utf-8?B?NGgwcjVHOHF6V3FVTEJqKzh3dXdsenBLSjdiTFJiSTVVem10SU5VTXcyeURn?=
 =?utf-8?B?ZjdTandDU3lJZC9tTXQ5M3M5enJRL3FrWmVJckR0c1RORHYrYjVMd2swa05q?=
 =?utf-8?B?QW1HeWdlckQ5Y1REVnJiYjUxNk9nMDROQVBqcVBpeG5mNjVRUUlRN3g4dGZ6?=
 =?utf-8?B?Zmx4RDhva1FYUTZ1SkhMdlVQbDRHc29EM0RHSUVFM1B2T1pPQkdqWjNTOUJR?=
 =?utf-8?B?Z1EzMlZ2d3BSOWxYM0FDZEM4akNqSUM4dVgrd0NycDVwcGh3NnhBODE4Y2tG?=
 =?utf-8?B?ME1uUzF1NUxUSEVPZDFhbWc0bjZ5LzZzMXZSS1RNREl3a285ODAySlQwWDg4?=
 =?utf-8?B?TkhpendqYnZ1Z3ZEMzdtVldWdS9qR2hlZW1QNTFzSE1oRkhJbmMxVDRUVjY4?=
 =?utf-8?B?WTNBRThzWkRreCt3RFJiNEhGU3RmQWQ5eW8vcWMzdnBjMDk3akZLN1ZlU21T?=
 =?utf-8?B?dTE2eVNsZmJSZ0hMWVZxR1RHbUJBeW9pOXhsdlg5Q0NreHdUdnVnL2hIVzRV?=
 =?utf-8?B?a2hDZ2JHd245Q3NEaUVDMmkwVTl0T2o2MEVrcGszTEpGWmgrTWhhRitXc1Ew?=
 =?utf-8?B?T1kxcVVsSUJGVmZZd0QrSUZtamlNZFdxRHQwRkxFN3JPSy9mMHJVeGxnVnd0?=
 =?utf-8?B?T1B3dDl6Y0diQVBqNGVYZXdpVFp3MTVhMTE1ZHBUTk5DT0szL3VRV1g5OVZx?=
 =?utf-8?B?SEE5U2tiVWRwbmYwZGVLOXNGU2NtMGRZSGt2ZEI2MWF0dlJFWmtEMFU4NE5o?=
 =?utf-8?B?OXNWNXJQbFRQclZaYldsRERSN25FU2Z5YllLdXV4eENnc0Fjb0NJTnJEVlgw?=
 =?utf-8?B?b3hoVUUvSmxXbVNsYVNKTUIvcGRybm1FbVN1a1RBdUl5em5EaVF2ZDQ1M3Ro?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C5C107B31C78544BD31EB6B9B9FF69C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02b0bd7-9885-4849-1518-08db5b1a1af3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:13:08.2340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zfG2RdmfsVYe2C2pjf59tyszBrUbqOfia1fpPzxs/fL32OgSs8Not7vbted1re4rTjm7fr/wsD77sVdW0qwVLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA1LTIyIGF0IDEwOjUxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1heSAyMiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyMy0wNS0xMiBhdCAxNjo1MCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEF0dGVtcHQgdG8gZGlzYWJsZSB2aXJ0dWFsaXphdGlvbiBkdXJpbmcgYW4gZW1lcmdl
bmN5IHJlYm9vdCBpZiBhbmQgb25seQ0KPiA+ID4gaWYgdGhlcmUgaXMgYSByZWdpc3RlcmVkIHZp
cnQgY2FsbGJhY2ssIGkuZS4gaWZmIGEgaHlwZXJ2aXNvciAoS1ZNKSBpcw0KPiA+ID4gYWN0aXZl
LiAgSWYgdGhlcmUncyBubyBhY3RpdmUgaHlwZXJ2aXNvciwgdGhlbiB0aGUgQ1BVIGNhbid0IGJl
IG9wZXJhdGluZw0KPiA+ID4gd2l0aCBWTVggb3IgU1ZNIGVuYWJsZWQgKGJhcnJpbmcgYW4gZWdy
ZWdpb3VzIGJ1ZykuDQo+ID4gPiANCj4gPiA+IE5vdGUsIElSUXMgYXJlIGRpc2FibGVkLCB3aGlj
aCBwcmV2ZW50cyBLVk0gZnJvbSBjb21pbmcgYWxvbmcgYW5kIGVuYWJsaW5nDQo+ID4gPiB2aXJ0
dWFsaXphdGlvbiBhZnRlciB0aGUgZmFjdC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTog
U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+
ICBhcmNoL3g4Ni9rZXJuZWwvcmVib290LmMgfCAzICstLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0K
PiA+ID4gaW5kZXggOTJiMzgwZTE5OWEzLi4yMGY3YmRhYmM1MmUgMTAwNjQ0DQo+ID4gPiAtLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9y
ZWJvb3QuYw0KPiA+ID4gQEAgLTIyLDcgKzIyLDYgQEANCj4gPiA+ICAjaW5jbHVkZSA8YXNtL3Jl
Ym9vdF9maXh1cHMuaD4NCj4gPiA+ICAjaW5jbHVkZSA8YXNtL3JlYm9vdC5oPg0KPiA+ID4gICNp
bmNsdWRlIDxhc20vcGNpX3g4Ni5oPg0KPiA+ID4gLSNpbmNsdWRlIDxhc20vdmlydGV4dC5oPg0K
PiA+ID4gICNpbmNsdWRlIDxhc20vY3B1Lmg+DQo+ID4gPiAgI2luY2x1ZGUgPGFzbS9ubWkuaD4N
Cj4gPiA+ICAjaW5jbHVkZSA8YXNtL3NtcC5oPg0KPiA+ID4gQEAgLTU0NSw3ICs1NDQsNyBAQCBz
dGF0aWMgdm9pZCBlbWVyZ2VuY3lfcmVib290X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkN
Cj4gPiA+ICAJICogRG8gdGhlIE5NSSBzaG9vdGRvd24gZXZlbiBpZiB2aXJ0dWFsaXphdGlvbiBp
cyBvZmYgb24gX3RoaXNfIENQVSwgYXMNCj4gPiA+ICAJICogb3RoZXIgQ1BVcyBtYXkgaGF2ZSB2
aXJ0dWFsaXphdGlvbiBlbmFibGVkLg0KPiA+ID4gIAkgKi8NCj4gPiA+IC0JaWYgKGNwdV9oYXNf
dm14KCkgfHwgY3B1X2hhc19zdm0oTlVMTCkpIHsNCj4gPiA+ICsJaWYgKHJjdV9hY2Nlc3NfcG9p
bnRlcihjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJhY2spKSB7DQo+ID4gPiAgCQkvKiBTYWZlbHkg
Zm9yY2UgX3RoaXNfIENQVSBvdXQgb2YgVk1YL1NWTSBvcGVyYXRpb24uICovDQo+ID4gPiAgCQlj
cHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24oKTsNCj4gPiANCj4gPiANCj4gPiBJ
SVVDLCBmb3IgY3B1X2VtZXJnZW5jeV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKCkgaXRzZWxmLCBs
b29rcyBpdCdzIE9LIHRvIG5vdA0KPiA+IGhhdmluZyB0aGUgcG9pbnRlciBjaGVjaywgc2luY2Ug
aXQgaW50ZXJuYWxseSB3aWxsIGRvIHJjdV9kZXJlZmVyZW5jZSgpIGluc2lkZQ0KPiA+IFJDVSBj
cml0aWNhbCBzZWN0aW9uIGFueXdheS4NCj4gPiANCj4gPiBCdXQgbm1pX3Nob290ZG93bl9jcHVz
X29uX3Jlc3RhcnQoKSBpcyBjYWxsZWQgYWZ0ZXINCj4gPiBjcHVfZW1lcmdlbmN5X2Rpc2FibGVf
dmlydHVhbGl6YXRpb24oKSwgYW5kIGhhdmluZyB0aGUgcG9pbnRlciBjaGVjayBoZXJlIGNhbg0K
PiA+IGF2b2lkIHNlbmRpbmcgTk1JIHRvIHJlbW90ZSBjcHVzIGlmIHRoZXJlJ3Mgbm8gYWN0aXZl
IGh5cGVydmlzb3IuDQo+ID4gDQo+ID4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8gIElmIG5vdCwg
aXMgaXQgd29ydGggdG8gY2FsbCB0aGlzIG91dCBpbiBjaGFuZ2Vsb2c/DQo+IA0KPiBObywgeW91
J3JlIG5vdCBtaXNzaW5nIGFueXRoaW5nLiAgSSBhZ3JlZSBpdCdzIHdvcnRoIGEgbGluZSBpbiB0
aGUgY2hhbmdlbG9nLg0KPiBEcm9wcGluZyB0aGUgInNwdXJpb3VzIiBOTUkgc2hvdWxkIGJlIGEt
b2ssIGJ1dCBleHBsaWNpdGx5IGNhbGxpbmcgb3V0IHRoZSBzaWRlDQo+IGVmZmVjdCBjb3VsZCBi
ZSBoZWxwZnVsIGZvciBkZWJ1ZyBpZiBzb21ldGhpbmcgaXMgc2lsZW50bHkgcmVseWluZyBvbiB0
aGUgTk1JLg0KDQpZZWFoIG15IHRoaW5raW5nIHRvby4gIFRoYW5rcy4NCg==
