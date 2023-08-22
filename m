Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E24783BEE
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbjHVIkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjHVIkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:40:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE011AE
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692693608; x=1724229608;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lzMOwOGXcELv/zBPrSJqS0qBBQZUceAH5lhl0UT7cnY=;
  b=fthvU+oEWK4wVpw+4v/RSu882Rz/lCrks+yoMHU2GlscG59Xbn7sSMYF
   X72+7cWgKxL3owe/SMlm/EpkK5Cgtq094PEDsC1aHh1PYpCBk9E2+Clni
   BDlN73MoSpp79PZfvjgJNOtXqflkJ3s7udhRHXf6J3rsR9YW/1M6ytKYl
   UzjUPZKPFKnjgRN2I6UJxTvsx55DoO2dzazDYqcLz2MGu6fe4ZMG6aOKu
   LqAS0/JsJKPVXjzhUZqE++WjI9pGb+J+y7HagzbzOZ9uqqrViYu5AXKeO
   PeXJL/wtt/FD9CoiY0zmpNvsltFErPpfMctW3gsOmNcrXeA9s48h+dzcq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="354157034"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="354157034"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:40:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="713073984"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="713073984"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2023 01:40:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 22 Aug 2023 01:40:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 22 Aug 2023 01:40:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 22 Aug 2023 01:40:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEU1XN/PkVDHPR2ul44eNW8XqYkT1rNWc0z78ibBdiC9I7Lw2UrKOO7xb9HWD6UP57vFRUdceViRYpt2quSfay3to+oXbfBTwbUerpwB+FE6BFa6zY355KkbSPYGdrbXWhOmvuRGTVca6WHS6wOSwskhZHrxi+HnLWJ9SLkbxSTqEp/pHUs5SullEbV+zLBoCjVdEPus1cKVDLZe4eYFz6ExlrNgIjpfa9JLPuZz0VEGATghRxA/G2lqiv03cQTY/YtTgtnEXq1aon6lkkOk3SE/B2s4AKLmJaLQqgVuvnEHhvk/D5+4n+6QFZhqSExPDlBn3x48fBzHp5u+EPtRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lzMOwOGXcELv/zBPrSJqS0qBBQZUceAH5lhl0UT7cnY=;
 b=iQn3Mz4js0Ry2VXQxRq0gyU78DoYY/q6EKoY4wQ2xzp/9EyBgKFWLALhswu4JzvcFcq4a5WdBR0XKJBWfKYTjvvkyrX3adP+W1nANYkkG48oUS+bfcJw2h/ghOCOVadln5N3G1Z5gyaSa8vtS5yciHspHrzNN+YXVMn+u5FxosmRrlKAcpK12n3kvWa0iLVrlITSQ/QB+KgfoORm99T2nusfHxj/RSpkrdWhReuRUCwYtH8+pkSZlDGsOIZUe/cAHmhcHEqDmJfnq/roHo+0fbYZ+/+cCH7l4b7Maf5lu6FJ7kIPkkzgMUYe5RWr6o6Dy2i8oQy+Td+AXRKt+ALIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 08:39:58 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 08:39:58 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "kvm list" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Thread-Topic: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Thread-Index: AQHZy03ysjRqNj7MIECcVRCn8aJ38K/0TX4AgAHByzA=
Date:   Tue, 22 Aug 2023 08:39:58 +0000
Message-ID: <MW4PR11MB5824CADB6BC89E031231E4DDBB1FA@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230810054518.329117-1-xiong.y.zhang@intel.com>
 <cee16915-b5a4-c4ba-8f9e-3d79c1c0d2c0@gmail.com>
In-Reply-To: <cee16915-b5a4-c4ba-8f9e-3d79c1c0d2c0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|BL1PR11MB6051:EE_
x-ms-office365-filtering-correlation-id: eeced36c-ed6b-46ad-fa96-08dba2eb5e68
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NAwVXFl7DEkDQouk05RIiLjAEyPQlZUuamN61yaBi9bIm9VjY4VykqYJ1rCRsiOb34E6fj1btbHm+FE3O0K676nhsQeS9xJov1xGwgc2X5dwm1ibkDqEeqjd7bTj5X5B2Yow7Faun4gE0F4ZgKZQ/dvS3ls70hY081pu2B2HjyfzJlsDAvtQeAE2sRB73HkWTxEuRQSnsSjJvOhinTGeVAtPGbn/WcJi2FufjPDqzaaSlAsyFrJtmA8B+vXCQXrBXvRYakJXX/ne2VBP1YLd8jhy8NSZYn7ryYPiavlGqfCigCmp9zqqIzpXQrPwCcQiZrnRxRdMCmEm6iMGjTQbrJjXmo5vHcS1dTj2SxGj/zLF8XTFLlhM0evDkagC+Nrr0SoQw4u53Vuy7JpVpY0dG/C2HZ0CugwurW08adTkaf37tAM8Ipzh5yAIZwe8ULXTzT1duph5jTrFHCYgodJsZ/GCQHmVIxeoGs/ssxXjp0s4byBvtol4KlsvP+wGBCxvQtxAQjaqyw5aRY8kwIsOW9u7DWTqUewAs2NkkktVTSGZI4uMZWemhES8v7oThnup+F8tJZMMda5j/fSzXI/zG7GfgNIIuJ9LqqV67qZdXS8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(376002)(366004)(1800799009)(186009)(451199024)(54906003)(76116006)(66446008)(6916009)(66476007)(66556008)(64756008)(316002)(66946007)(9686003)(82960400001)(8676002)(8936002)(4326008)(41300700001)(122000001)(966005)(478600001)(55016003)(71200400001)(38070700005)(38100700002)(53546011)(6506007)(83380400001)(84970400001)(2906002)(86362001)(7696005)(5660300002)(26005)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGljUXI0c2ZHeDRTcTAwek51Z0ZxUkMwcGlkNFZaWlYzWnorMjlPaUYvTDBN?=
 =?utf-8?B?YW54SHhTQWhFbHpKK0NmREVKai9OOUhFZGlycUo4ZGVaK2ZWaVFXdWhkN1Ft?=
 =?utf-8?B?MUJiNzJkcVcwQUNBMmZ6cFowQmNaZWVGU1ZCQ1FmOWw5MFNlanFwRzVlZisz?=
 =?utf-8?B?MU41RURlQm1XdkFDTHppSE11WkRzMys4eTJ6cHN4YVRkY09UYXlXT1NCK0lH?=
 =?utf-8?B?VHg4dldINTk0QVFqM2l0ckQzVzY1cGlkTUpMaEE5U2ZIaWxrVnpPejJVSG9i?=
 =?utf-8?B?d3Z1UHJ5L1UrTUdjVGd5MVZ6cTVuRXMzYTJSellBbkZVaGFSek5kMGsxWW93?=
 =?utf-8?B?VEwxSmF2THh3V1c2NXdxSHJaS3ZrQjFDVlFScDB0MjZyVEN4bFJpYVV0ekIy?=
 =?utf-8?B?VVpCMVZOVmEvOXJsaXgvRThiTVgzVlVWa1RxNXdmWmxOQ1BCb1JUcDQ2dEhp?=
 =?utf-8?B?Ulc1Nks4SUE4bjZ0a1hrTDM3bHg5Zi9YbUNSajU3WTgvTzNUTmJWZTlNOXFR?=
 =?utf-8?B?dkZHR0ovSHpVWkZ6d01ZdDNJT1VCelltV2R1T3M1aC9pVDIyS2hlUE5aMitV?=
 =?utf-8?B?VWhLWkt6V296N2FoR1RPSGJVbUcrZWdXczU1VHZrM1AyeXJEZWJxRnVtUXFw?=
 =?utf-8?B?UjBPZ0E5SmRSbmVZWXUvczNCSlBCNHV3V2t1US9QbldXWDlOY0tVc3I2N2kw?=
 =?utf-8?B?SHNXVTcydEV6Y2xPc2hQbXJvNm5WUUlXcHNwbWxZY2FCUlYrNU16ZjZUN3Zr?=
 =?utf-8?B?RFRvTWZucDJEdmRLdkwrRkxpRlhyeDY1bnlFRGxUQ3EwcnU0eVFDb2YwRHlz?=
 =?utf-8?B?cnlGLy9IVUpuWVVMdXpWUytvaXczMDRibWs0TUx1MHhyN0UvZlFwamo4K2di?=
 =?utf-8?B?ZC9LRXpqVnhhWTFxUnliOHpSWHI1dVFpK09QR1RyTzA2Tm9vS3JEampJcXBD?=
 =?utf-8?B?UDJKdkhwUW1lSlluTkJkV0FHaXFXVVAwdGp4bTRxRUU3MWhXcFhJV2JrZ1FQ?=
 =?utf-8?B?SllhcDhmOEc4a09kUUdMR3ZPOC9Ma29IcFU4Nm1oejluTXRNeWRma0N4SUVB?=
 =?utf-8?B?c3hhMEMycWRGTW50NlpyQWN4MG1aZURhNk5DekFXakw3WmZiblkyZ0orZ0hk?=
 =?utf-8?B?Nk05VmU0TVJ6c2hZMWxrU0hNVGo5MnpXeENqY2s5Y1R4K0pFNTlyckFldXRw?=
 =?utf-8?B?S0pHOUdTQ0xnNlVwdHVaK0hvOGFlM2RBbnFvblVtdnZDaHRKekRpeVN1a3Fz?=
 =?utf-8?B?eitwcC9GeHQ0cVBMRUtHVFF1elBCNThKakkzN2ZBbnB5eFd5ZTVBaGl1dU4w?=
 =?utf-8?B?ODJ5eFJrdnVpd1NNc3FDSURYUmdKQ0orTUo2eFF6QTdFZEhVVUxmZ0xVVit5?=
 =?utf-8?B?bTI4eVhGc0dqbDFFSWtwWlV5Qzl2QWhvYkdOM3AvQXZYOFJhR0ZiL0lGNmQr?=
 =?utf-8?B?UHk2TkJLeVQ5UHVqZzZTOTh0Tk9CQ3BwYlovZ1QySGtSMjJ3d0ZVU2VWc0tx?=
 =?utf-8?B?QmRuWkRFVGZ1U3k2M3BXM0piM0NYa1NrZG5TcWhYTHNkLytZV2R2dmdlenpB?=
 =?utf-8?B?NFVmRUxoWFh0aVJRb3dVNVdQSWJQL1paNlBzak9INFdleks1WHhhaTBMQm5o?=
 =?utf-8?B?enpPcitCcGQzNnd3MFFNazNwcllweEFraWR3Sk13bjE1S05rVGdvU0ZadHNa?=
 =?utf-8?B?S3NEY0F3eGpmc08vSTJSMUQrNGxhV3JyT0o0bDhGUmNjZ0IwSDg4UTZITU9k?=
 =?utf-8?B?SnNFVE1QTitLL3hEeDIyMTlrb3pmWWxDeVE0c2xqamZrSmtzcFVJSzUxOFg4?=
 =?utf-8?B?U3JhRWxpdTU4dkpPc09EaGpwYlVjTHpHeW1JcUtqU3JRSFltdG9oY1ZIZ1hN?=
 =?utf-8?B?VFl3K2RmN3M0MUF6REY5TFZLejlQOUJtZktlekRCS1hyRnU0VWlLQW4zV2dP?=
 =?utf-8?B?bXpiNjJFeUxxY3ArcFZpV21lWVJ5d3BSSHh1SzJ3eFdDZys2QXRNdkRJWXJP?=
 =?utf-8?B?cmR3eDJGazdjMWhHK0hTRExXemF4UnNsR2V4REtJTyt2aE1ISVlleHZzZWpL?=
 =?utf-8?B?MEljdUxuVHlmak9Jb00wK3RRRW5IUUdFTGE1SVJpVmJVU0E1cUVqeUNUVDZV?=
 =?utf-8?Q?iaWrajBNco2Lhzxp6k0/hBCP5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeced36c-ed6b-46ad-fa96-08dba2eb5e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2023 08:39:58.7676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBsAXriBn09m9pclMYauQ/VfKt0oSuh+tZ0QP7xG4YPwGwhATP6IFFkyyGsABzpuElQWVkOmk3QqhJHD1nl1qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gMTAvOC8yMDIzIDE6NDUgcG0sIFhpb25nIFpoYW5nIHdyb3RlOg0KPiA+IEFkZCBh
IHZQTVUgaW1wbGVtZW50YXRpb24gYW5kIGdhcCBkb2N1bWVudCB0byBleHBsYWluIHZBcmNoIFBN
VSBhbmQNCj4gPiB2TEJSIGltcGxlbWVudGF0aW9uIGluIGt2bSwgZXNwZWNpYWxseSB0aGUgY3Vy
cmVudCBnYXAgdG8gc3VwcG9ydCBob3N0DQo+ID4gYW5kIGd1ZXN0IHBlcmYgZXZlbnQgY29leGlz
dC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpb25nIFpoYW5nIDx4aW9uZy55LnpoYW5nQGlu
dGVsLmNvbT4NCj4gPiAtLS0NCj4gPiBDaGFuZ2Vsb2c6DQo+ID4gdjIgLT4gdjM6DQo+ID4gKiBX
aGVuIGt2bSBwZXJmIGV2ZW50IGlzIGluYWN0aXZlLCBpdCBpcyBpbiBlcnJvciBzdGF0ZSBhY3R1
YWxseSwgc28NCj4gPiBpbmFjdGl2ZSBpcyBjaGFuZ2VkIGludG8gZXJyb3IuDQo+ID4gKiBGaXgg
bWFrZSBodG1sZG9jIHdhcm5pbmcNCj4gPg0KPiA+IHYxIC0+IHYyOg0KPiA+ICogUmVmYWN0b3Ig
cGVyZiBzY2hlZHVsZXIgc2VjdGlvbg0KPiA+ICogQ29ycmVjdCBvbmUgc2VudGVuY2UgaW4gdkFy
Y2ggUE1VIHNlY3Rpb24NCj4gPiAtLS0NCj4gPiAgIERvY3VtZW50YXRpb24vdmlydC9rdm0veDg2
L2luZGV4LnJzdCB8ICAgMSArDQo+ID4gICBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL3g4Ni9wbXUu
cnN0ICAgfCAzMzINCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gICAyIGZpbGVz
IGNoYW5nZWQsIDMzMyBpbnNlcnRpb25zKCspDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9j
dW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvcG11LnJzdA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0veDg2L2luZGV4LnJzdA0KPiA+IGIvRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS94ODYvaW5kZXgucnN0DQo+ID4gaW5kZXggOWVjZTZiOGRjODE3Li4wMmMxYzdiMDFi
ZjMgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvaW5kZXgucnN0
DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvaW5kZXgucnN0DQo+ID4gQEAg
LTE0LDUgKzE0LDYgQEAgS1ZNIGZvciB4ODYgc3lzdGVtcw0KPiA+ICAgICAgbW11DQo+ID4gICAg
ICBtc3INCj4gPiAgICAgIG5lc3RlZC12bXgNCj4gPiArICAgcG11DQo+ID4gICAgICBydW5uaW5n
LW5lc3RlZC1ndWVzdHMNCj4gPiAgICAgIHRpbWVrZWVwaW5nDQo+ID4gZGlmZiAtLWdpdCBhL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0veDg2L3BtdS5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vdmly
dC9rdm0veDg2L3BtdS5yc3QNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAw
MDAwMDAwMDAwMC4uNTAzNTE2YzQxMTE5DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0veDg2L3BtdS5yc3QNCj4gPiBAQCAtMCwwICsxLDMzMiBAQA0K
PiA+ICvvu78uLiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiANCj4gV0FSTklO
RzogTWlzc2luZyBvciBtYWxmb3JtZWQgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXIgdGFnIGluIGxp
bmUgMQ0KPiAjMzQ6IEZJTEU6IERvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L3BtdS5yc3Q6MToN
Cj4gK8OvwrvCvy4uIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+IA0KPiA+ICsN
Cj4gPiArPT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiArUE1VIHZpcnR1YWxpemF0aW9u
IGZvciBYODYNCj4gDQo+IEZvciBJbnRlbCA/DQo+IA0KPiBNYW55IG9mIHRoZSBkZXNjcmlwdGlv
bnMgYmVsb3cgYXJlIEludGVsIGZlYXR1cmVzLCBzbyB5b3UgZWl0aGVyIGhhdmUgdG8gYWRkDQo+
IEFNRCBwYXJ0IG9yIGxpbWl0IHRoZSBzY29wZSwgb3RoZXJ3aXNlIHRoZSByZWFkZXIgd2lsbCBi
ZSBjb25mdXNlZC4NCj4gDQo+ID4gKz09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4gKw0K
PiA+ICs6QXV0aG9yOiBYaW9uZyBaaGFuZyA8eGlvbmcueS56aGFuZ0BpbnRlbC5jb20+DQo+ID4g
KzpDb3B5cmlnaHQ6IChjKSAyMDIzLCBJbnRlbC4gIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQo+ID4g
Kw0KPiA+ICsuLiBDb250ZW50cw0KPiA+ICsNCj4gPiArMS4gT3ZlcnZpZXcNCj4gPiArMi4gUGVy
ZiBTY2hlZHVsZXIgQmFzaWMNCj4gDQo+IEkgd291bGQgc3Ryb25nbHkgc3VnZ2VzdCBtb3Zpbmcg
dGhpcyBzZWN0aW9uIG91dCBvZiBLVk0gc3Vic3lzdGVtLCBUd28NCj4gcG9zc2libGUgbG9jYXRp
b25zOg0KPiANCj4gLSBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL3BlcmYNCj4gLSB0b29scy9w
ZXJmL0RvY3VtZW50YXRpb24vDQo+IA0KPiBPciB0aGUgYmV0dGVyIG9uZSwgdGhlIG1hbjIvcGVy
Zl9ldmVudF9vcGVuLjIgcGFnZSBpbiB0aGUgbWFuLXBhZ2VzIHByb2plY3Q6DQo+IA0KPiAtDQo+
IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9kb2NzL21hbi1wYWdlcy9tYW4tDQo+IHBh
Z2VzLmdpdC90cmVlL21hbjIvcGVyZl9ldmVudF9vcGVuLjINCj4gDQo+IEl0J3MgbW9yZSBnZW5l
cmljIGFuZCBzb21lb25lIG1vcmUgYXBwcm9wcmlhdGUgY291bGQgdXBkYXRlIGFuZCBtYWludGFp
biBpdA0KPiBmb3IgbW9yZSByZWFkZXJzLg0KPiBIZXJlIHdlIG9ubHkgbmVlZCB0byByZWZlciB0
byBpdCBzbyBhcyBub3QgdG8gYm90aGVyIHVzZXJzIHdpdGgNCj4gb3V0ZGF0ZWQvbWlzbWF0Y2hl
ZCBjb250ZW50Lg0KPiANCj4gPiArMy4gQXJjaCBQTVUgdmlydHVhbGl6YXRpb24NCj4gPiArNC4g
TEJSIHZpcnR1YWxpemF0aW9uDQo+IA0KPiBIb3cgYWJvdXQgb3JnYW5pemluZyBpdCB0aGlzIHdh
eToNCj4gDQo+IDEuIFBNVSBPdmVydmlldw0KPiAyLiBDYXBhYmlsaXR5IEVudW1lcmF0aW9uDQo+
IDMuIEJhc2ljIENvdW50ZXIgVmlydHVhbGl6YXRpb24NCj4gNC4gSW50ZWwgUEVCUyBWaXJ0dWFs
aXphdGlvbg0KPiA1LiBJbnRlbCBMQlIgVmlydHVhbGl6YXRpb24NCj4gNi4gS1ZNIFBNVSBBUElz
IEd1aWRhbmNlDQo+IDcuIExpbWl0YXRpb25zIGFuZCBUT0RPcw0KPiA4LiBSZWZlcmVuY2UNClRo
YW5rcyBhIGxvdCBmb3IgcmV2aWV3aW5nIGFuZCBnaXZpbmcgc3VnZ2VzdGlvbnMuDQpJIHdpbGwg
aW1wb3J0IHlvdXIgb3RoZXIgc3VnZ2VzdGlvbnMgYW5kIGFkb3B0IHRoaXMgb3JnYW5pemluZy4N
Cg0KDQo=
