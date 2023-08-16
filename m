Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C477977DDB1
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbjHPJrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243592AbjHPJrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:47:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0226BA;
        Wed, 16 Aug 2023 02:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692179235; x=1723715235;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kusc8bzaXYgVGheEzk7SlaVgvo4jLyBjlMquMf8p87M=;
  b=bvqGFOtw1HgxJwyUa9idBBfZzcO1Stw4ink5ioUTK51oJI386gDx23S5
   i4rvUnYz1mng7c2P6iNLXjjilw11XVvwhDYRmi+zgCxSE/i9l+jiQHs2D
   a5TnG3YpuIV13yYiHf4UGl99UTehSjQA8o93MuOWVmr126YGi40VSyA88
   hyKdyLjdm48CkL4RY4jPw8aQORd4R1Bo5VAAuf3a9UCQS6SPYlJuChnwQ
   Bp1bhtGkOwifLAaer5SZTE2jzPmUPIT1ZTgSZvilOpSsaqwnYEHsEGQqy
   UU8KBLpQY6GgskStDF+z5F0IETsaMFKTaCons4HyF1EJpBIqPBRAZRoc+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375259925"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="375259925"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 02:47:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="877722536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2023 02:47:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 02:47:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 02:47:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 02:47:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 02:47:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+mNgpgMH+cd9npHIN5H/2pNVicp2YemSENqUl7dpP0llebKRBU15+6WysiYelSqZSewdleWuZ6HhizXLnXojYiAWUWXyYsrVuvtzTLxXhptGfdYd32WWta5M6FlX3wVjJtMSsEaQleEVDpWIw0XqVDeuIwPX1snYmyusDY1i2c7UJrOZ/NNZpESwrTsQcObiBW83mDHriKZFGIfpoH/15z/i10BjCXy5WTdpxnxnZL5dHlTZDAPpOs3uMVrvfWHJCsOTucqtVyWSBhx4XfO0BqzRorVHhwVoGhAKM9HcnFhx5xyzCd9/7U7MaXgRlQCRfE+H6cSO8n+72Sc6b9JTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kusc8bzaXYgVGheEzk7SlaVgvo4jLyBjlMquMf8p87M=;
 b=A0AIg98x/CA/pb8SwRgyO+a6PkZmxPPuHUlfE6IJN+dpt6D4/Wb1ztIRJW6vPBMXS3mtqPXrU2vQxa0ig4dumrWW1DDKolNuoWAl7hzE50FHmpE1gkF5yW9UsGI7MB0wWF4tHf0J7iA58UI93ZXze13tETdrsHtwLPvwWROkBGyl6W4RWEe4l7ZA6SGDNC4wmQGqFUd/bjB0LiMZ9mATygP1TJyx5+mxGz5PkVhW2/YnzTVYP58zZrNlr7wUz3fFwtdQD3nOmFuXmoExDPLW0EzEfQya9igcZTpJM9HlC/OhBIfK8FAPz/AQaWjUGWpnlAfhnWSNOEFAo8TcfhR/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4658.namprd11.prod.outlook.com (2603:10b6:5:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Wed, 16 Aug
 2023 09:47:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 09:47:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Topic: [PATCH v10 3/9] KVM: x86: Use KVM-governed feature framework to
 track "LAM enabled"
Thread-Index: AQHZuk8pOpXGo6/5yUqsQMQAFLsPwq/sc/uAgAA4bYCAACw3AA==
Date:   Wed, 16 Aug 2023 09:47:11 +0000
Message-ID: <aa17648c001704d83dcf641c1c7e9894e65eb87a.camel@intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
         <20230719144131.29052-4-binbin.wu@linux.intel.com>
         <c4faf38ea79e0f4eb3d35d26c018cd2bfe9fe384.camel@intel.com>
         <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com>
In-Reply-To: <66235c55-05ac-edd5-c45e-df1c42446eb3@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4658:EE_
x-ms-office365-filtering-correlation-id: 2c3f8a96-22f9-4d84-86a2-08db9e3dc366
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6oEFc8Ca0EPm65ZIPln9zt1wcaaLLUY8uEOV/pknOIm58cIky6UVbG92Dt73+pinBUDNWK2f0SuWZhyumu6W498fktg4UOd1C9pECFX7JkHmrvsILkQk5Jx6wIOAUomxgiiLITdYmX4V0UGEAUhGuEjHwtO4wIzTZZ5n1CZxxKPRM7SPzXYfFvOkdCdDCzrTlJwa5Q4O/iInJ0HI3CurhJwPh+AsIa06Nfxm9yAHSPEzRthhTcHqDf3GhFNckg3gqpecrDi6F5Bhg8FDCbDsW+nQvz9+V1swqzY98ndUcaTXx5S/Ffstb/GN1DiJpsEjMX6YrHBkfGNnohSTSdHFNdvfj02WG+6Mg7cI5Slkx7zb4t25cJkV8zmxsrE4mr2btkGU/aN//c/0vTfUZOe2K6j/8hAQNz0KhFRATbFpH2KkWxk7oOvOZFM2q53tTafF1I3+nNlX4a9SyNcT9yH+KvvTqwkHTcAxId2LMXJ5g2oVGfO52ffwDtI9YbcjGach3YJCypCL/DpIaL/Ju9OO85Og8ul6/UxVKuPM3AeLc2XWc6/DYLvwNfE/Ln113kOu2n8OYB1Iu1gVTHlbXhXxAT4qW3tCJPj6ww8AnnMP4zw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(346002)(376002)(1800799009)(451199024)(186009)(54906003)(316002)(6916009)(76116006)(91956017)(66946007)(64756008)(66446008)(66476007)(66556008)(122000001)(966005)(41300700001)(5660300002)(38070700005)(38100700002)(8936002)(4326008)(8676002)(82960400001)(2906002)(26005)(478600001)(86362001)(6512007)(6506007)(71200400001)(36756003)(6486002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzViRktZNHJ0c2g2c3VYbXdoWUtKQUtRSklSMGpuczA1THUxNnVtWWpFeEQy?=
 =?utf-8?B?cWs2WklrYWx4Y1F4N0RoN1QrZEYrbUd2L3V1ekpjVXVjZHZGWmp0M1BCZFAv?=
 =?utf-8?B?UnhSMlFXZHl0Tk9PWDhJeHB4Ymt6QnkrME5qVkFXbHlSdDFNK3ROZ3NrODJQ?=
 =?utf-8?B?SW94T0NXWmhnTXdvbDlQeXg2Ly9ITk1jSTA3QmwvRlpHdVRERGkrdnlLd1RI?=
 =?utf-8?B?WDMvV0xsQ2Ntd3YvM0dOdXdJcTVaSVo2SXpGMXd2RFVGMWJSVnJZU1pGOWtL?=
 =?utf-8?B?MVhaanJuUkdzQ0RwNHgvYTBlM1NSS2JtTW1nQWNOY0luK3FvR2wwVnRWRzBj?=
 =?utf-8?B?cVJVTFRYaWc2MkhzS252U1RwWGtsdlBOYkFpVDg0bkx4SVhCSHhBVGFQRHA1?=
 =?utf-8?B?ZE5rSlpRWlQ4WUJpc0lVWFhZblRjUDN0d3B2OWVtaTRuOVhBQ1RBK0dnOHo5?=
 =?utf-8?B?UXBaWHdLRlVPU0cwZ0llUlpHVkxFaTVzdVl6dTNFSVhBdmpXcUs3Zjl0SFRy?=
 =?utf-8?B?YjgxMlBmNFd6Q2FTdUVMZ0UwZk85eHpwakpOc0FQWnd4b0QyL0lIYmU2b0Nr?=
 =?utf-8?B?Q3hkdUxUclhQR0tGUDQ2YjU0QjFUTnQrenNHUWZML3FOYW1GckhXRmlYZlJi?=
 =?utf-8?B?aXQzNlNPQzYveHRQYmxqM1MyVzJ6MzlZWm40emhoUHo1b2pEYjdnRmxSWmpZ?=
 =?utf-8?B?UVY3RHNXUWZkbGg2ZVlUd3lHalJ2emU0WjVQV0MyQUNucklTQjJqc0pzYUNp?=
 =?utf-8?B?eHhaTnQ5Ti95T1dFQ21LdHhZak5ueG5kSTFod2VzU2RUTlQ2bnVJMyswZVFr?=
 =?utf-8?B?QWpkYUZQUkMvNmFaUThLbGZEQWk5ZXh3QWZXOXA1SjlycDBDWjJQSW5ESEhv?=
 =?utf-8?B?S1MrS3BHWHhlRFYzdTgvV1ZNdE40bmhqY1gzTUFkMVdCNWlmK2s0eEs4ZjRq?=
 =?utf-8?B?aFVQaHl1cFoxNitvRFdVZEhJU0ZJQ1BtY1J6QUp6amFDRWw4RzhMMWFVbzlu?=
 =?utf-8?B?OURiME90dE9PaUxpYzlvdHRVNysrYlBObTVhZEtQZHhKbHMra1ZveEoxUWNq?=
 =?utf-8?B?bWw5ZHd4RnBqM1ZUcUZQY1FSbnRTejVRaDhlRnk2dmNKMmRWaHFSTUcvd0FE?=
 =?utf-8?B?M0lUampKV3BpdkxHMVpNb0NZVnQvbTc0Skxmb3pHYmU2TW5HS1FRMDhTV1Mx?=
 =?utf-8?B?bGZmU2N5TjFFME5aZU1mbzFhRU90TnhkOVlLb2ZtT21WRDFTaWF1MUpocGVE?=
 =?utf-8?B?LzAzbjZpbm5OL2Uxb1RCR1l3bWFlWS9lbDJ4R2hRaGgyR20wd1lTS3NsRFBu?=
 =?utf-8?B?dmVQNEFPdjNBaVp1QXBlRm85d3FqNHpVMTlHQWNXUGk3R2pMY1lsK3lCV0ZD?=
 =?utf-8?B?OFRtcXpkRVkwWjE4UHhSM1lPZ0M0ZmVHY1pWbk5MT2tXcWVmSlA5cmhtNDVN?=
 =?utf-8?B?eUtFUzY4ZzA4NUNXdUNqNWpNUkp5YkhrUVpOU05naVE0elM5UjNYVTF2QVJN?=
 =?utf-8?B?OWVZaWdPREtsTExhdGxQdzlXWWFlSUordU1FUVNRTTJDRFJmVkxlUzNCOUFa?=
 =?utf-8?B?RDNxOTQxeVlyWkVuSk5UclJoRVlkQzRGZW8yZjRkTWdaRFZ6UXpvUDZubXo5?=
 =?utf-8?B?bG5NeFZOM3prQkNsbzdRUWdVOVM3U2RNNS96cUhud3E2RGloS3NhYXcvMEZE?=
 =?utf-8?B?b3BhUzN1WHV2RUViRlBhVk1oWXgrK293c2tid3NhaVZqNWZzLzNNeFY2TjdZ?=
 =?utf-8?B?c29vcGlOdUJsbXZVcEZVUUN0Smd5VDdnNXpsWkdWZ3U2Z2tCY0RTS0tPcHIz?=
 =?utf-8?B?RC9zSk9NZ3BUSThWS3ZSSm9jQnVvcVBobVZFeGVLc0d0VzhKbE1PQVdPdWNR?=
 =?utf-8?B?TFdVcFlSY2xYYkVQMVlyaHRQclkwR2xyY2diQ3BmTHByTm93enVzaEZVc2Jx?=
 =?utf-8?B?MEt0MG1tdUxIZEk5ZkVFaXo4T3huMmNRVFVoVTdmL1l4ZTd0UUZySVVXb2hJ?=
 =?utf-8?B?cU13dWxmTUtXMlhDSGpJOGhNWFF6TkJKUjB3aHM2YzFONGlwcVhkT1JDTFBH?=
 =?utf-8?B?ekF6Y0hlTi9FYTNKbjBIdkljV2paR1FqZ3BNWjdNckpKZlM2MmFBK2RaR0Np?=
 =?utf-8?Q?7K/vza2l3SlBi+wfepzQx9gAx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D6136DD4EEC0841B6970AEA1D1F4170@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3f8a96-22f9-4d84-86a2-08db9e3dc366
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 09:47:11.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pxq+af/3gxeFY4zE8iGrIOUrW7i/xc8P4NUF1TXZ8w0HOMMvrvMsTd8pQEXR1dXTXBqx/JV1/NF+SR6GXDhbnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4658
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiArKysgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiBAQCAtNzc4Myw2ICs3NzgzLDkgQEAgc3RhdGljIHZvaWQg
dm14X3ZjcHVfYWZ0ZXJfc2V0X2NwdWlkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+ICAg
CQl2bXgtPm1zcl9pYTMyX2ZlYXR1cmVfY29udHJvbF92YWxpZF9iaXRzICY9DQo+ID4gPiAgIAkJ
CX5GRUFUX0NUTF9TR1hfTENfRU5BQkxFRDsNCj4gPiA+ICAgDQo+ID4gPiArCWlmIChib290X2Nw
dV9oYXMoWDg2X0ZFQVRVUkVfTEFNKSkNCj4gPiA+ICsJCWt2bV9nb3Zlcm5lZF9mZWF0dXJlX2No
ZWNrX2FuZF9zZXQodmNwdSwgWDg2X0ZFQVRVUkVfTEFNKTsNCj4gPiA+ICsNCj4gPiBJZiB5b3Ug
d2FudCB0byB1c2UgYm9vdF9jcHVfaGFzKCksIGl0J3MgYmV0dGVyIHRvIGJlIGRvbmUgYXQgeW91
ciBsYXN0IHBhdGNoIHRvDQo+ID4gb25seSBzZXQgdGhlIGNhcCBiaXQgd2hlbiBib290X2NwdV9o
YXMoKSBpcyB0cnVlLCBJIHN1cHBvc2UuDQo+IFllcywgYnV0IG5ldyB2ZXJzaW9uIG9mIGt2bV9n
b3Zlcm5lZF9mZWF0dXJlX2NoZWNrX2FuZF9zZXQoKSBvZiANCj4gS1ZNLWdvdmVybmVkIGZlYXR1
cmUgZnJhbWV3b3JrIHdpbGwgY2hlY2sgYWdhaW5zdCBrdm1fY3B1X2NhcF9oYXMoKSBhcyB3ZWxs
Lg0KPiBJIHdpbGwgcmVtb3ZlIHRoZSBpZiBzdGF0ZW1lbnQgYW5kIGNhbGwgDQo+IGt2bV9nb3Zl
cm5lZF9mZWF0dXJlX2NoZWNrX2FuZF9zZXQoKcKgIGRpcmVjdGx5Lg0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMjAyMzA4MTUyMDM2NTMuNTE5Mjk3LTItc2VhbmpjQGdvb2dsZS5jb20v
DQo+IA0KDQpJIG1lYW4ga3ZtX2NwdV9jYXBfaGFzKCkgY2hlY2tzIGFnYWluc3QgdGhlIGhvc3Qg
Q1BVSUQgZGlyZWN0bHkgd2hpbGUgaGVyZSB5b3UNCmFyZSB1c2luZyBib290X2NwdV9oYXMoKS4g
IFRoZXkgYXJlIG5vdCB0aGUgc2FtZS4gwqANCg0KSWYgTEFNIHNob3VsZCBiZSBvbmx5IHN1cHBv
cnRlZCB3aGVuIGJvb3RfY3B1X2hhcygpIGlzIHRydWUgdGhlbiBpdCBzZWVtcyB5b3UNCmNhbiBq
dXN0IG9ubHkgc2V0IHRoZSBMQU0gY2FwIGJpdCB3aGVuIGJvb3RfY3B1X2hhcygpIGlzIHRydWUu
ICBBcyB5b3UgYWxzbw0KbWVudGlvbmVkIGFib3ZlIHRoZSBrdm1fZ292ZXJuZWRfZmVhdHVyZV9j
aGVja19hbmRfc2V0KCkgaGVyZSBpbnRlcm5hbGx5IGRvZXMNCmt2bV9jcHVfY2FwX2hhcygpLg0K
