Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF6047BC55
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbhLUJBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:01:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:59382 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhLUJBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640077268; x=1671613268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zn3VRsL0RsZD0/Q+Uto8PpdD6/o/nFqjELHlj/4RhFA=;
  b=TBi7OyEymEIWDJk/R0PXZUmWQqDC2K5dOm3IPJs2kvZ6sRayfhLcUCX2
   2WE5kXOJiqPUgV5sbQrGvETozN8XdFnbiDkMspYE1YY+QTkTARGRuZWo4
   A6UxvyhWh5w6h+iYZNbDjw71pEABUoFTIU2nITst/VOcEsA7al5i+Fr5Y
   1rl2cl9BI4xkYT6a6ftRGyzTWTPLs9s62ZdePhSJC4q2KpI4wEUIfyysV
   /rdJSEQEUzl3ze9slNVpF637Pnwmgf/izAF9c8la2ue5EVcN42WaA0rKA
   oQZRvUPhzKBkagLfczP6UH705Ehy7gmPsWFRVAU9CeLTC0ecHvTMIlRRb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227207999"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="227207999"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 01:00:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="613402745"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 01:00:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 01:00:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 01:00:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 01:00:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 01:00:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSQtLXam/Fqqt3T0L7RhKaZ3nTagSaPGh2EVBpCg84HJE2lHMKcwiMnN0hAoMRJ02HBZ/16fi7u0nvOn1aALP7TtEONY+QSgbdOP6lXJgxmSiYuFZ+z5qFJzZnGkDYqaTSGLX9BwWVMXxOse/UMcVhQcP5yPVIzq/lUmlgdGjGw3C20uUDlclXNnKywcEA1OXugbmaHLYwR7r4fOV6uQpsxUh6GtTSik7h0vU2/bxWJdjivoxuyAgrb4QZ6poORkNQSSi0YNPZl7OK7VL5VIfehgCzmIEJtl8Ga6aUNXgnrNuq1vErQxx6WFgbDEvzOf8kpt435QsWC1wJA40og9GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zn3VRsL0RsZD0/Q+Uto8PpdD6/o/nFqjELHlj/4RhFA=;
 b=M0pKbhtJ5XkOpaxK7dAxnN0Qn1bHRBKqjCg5+fIduayi0nR4YyYD8Y3PuXL+VKuJLg4grLnOGFgRtKCS/j05+SF4yKtjtoe4oXm4EpBuQCb+smadAxjK+66licQnWWLDPPnIptWM6SkCua+z1RQnquNgz87Rxss3NnpRwxS4ZBe2iZGbyWDEZ2MU2oZEbfs6UetQwSsx44OXmW9ooRlphc1XQmrigR+xjkCEbgemwFuNwHPH6Txd90HqeIvDI8vVTkZOauBr5tmGqZbXAaSJ6X8rhnaBLfOTFJUldk7P401iNcAsSO3I9hOX5QjwFtQXtSjLMZp8xmGIqa2OWEysgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 09:00:40 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::c9f6:5be9:f253:6059%12]) with mapi id 15.20.4801.020; Tue, 21 Dec
 2021 09:00:40 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Thread-Topic: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Thread-Index: AQHX81sJtssEIr/APEmXmcVUJc1dj6w7G7CAgAFWU4CAADZVAIAAAlDQ
Date:   Tue, 21 Dec 2021 09:00:40 +0000
Message-ID: <MWHPR11MB1245CA82DBCE3D660CDE4756A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-24-jing2.liu@intel.com>
 <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
 <MWHPR11MB12451924FE9189E4B69E78A4A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
 <f465ec18-4a0d-2e1c-239e-cc93aa43226f@redhat.com>
In-Reply-To: <f465ec18-4a0d-2e1c-239e-cc93aa43226f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34d06f7b-cfad-4d95-0cc3-08d9c4605cf0
x-ms-traffictypediagnostic: MW5PR11MB5810:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW5PR11MB5810A674AA5B2A73E28DE430A97C9@MW5PR11MB5810.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qa3keuqrMP53coE5AxaypEH7BJvDtWXEL7PjHFrPczZkWk1y7iJ7jr+2VcI96U3mElhY849TtfCwegvFHHTIG5LywCOCyW50zvP0E6ePPRmRJfE6zAob2SP8TqQ+Jm+hAxdVrPNJYWmP98KVd0E7ODWVW+Nsgd7xtMy8sFMqlaS0cLmalR7T/KbVsfXlgDUdb9ztc14ahVAdvIFAs5Fuh9LkWSYJzNTQm1/ETqsumNb55mmJw7d2GIOHO4q8ynjjQ9LCLyp1Q+Qic/JETxPm+pkdf6fnrlQMq0bLGsvcV1lMBTZKhe6oa99XpTbwwFEQiVzd+7+eF3LLUsqE7XqsQSY5zXZaMRihrvF1TDbRRUAFjkJpWc91xboFVA1LQtatC2pUPw7a6SBO5xrs8XQW5Ph7FI7kIFXmUjbR+e8ReXssrUkpGVDor1/rpibnsYmZc80P0bixD3L1hpr0jm0Rr1nnrj3KswjpYigEIR/otbELPBaqtObAAcpkexvGSs/zlx1pEvvX5bZSSfXc0Q16lsnw6vzpu8rzVyNkGWQn9iNaK94+g45ZqxRUl0iLkIMyA1sXR7BFg1QW8n+3ueST2bIyS4bSYfxaQEz5BVU9his1sFXZ3vb4hnqB1XBU+g7mMMLrgZ3MpFSut6ZLZDVarY8QHfRY1BoaHKE3wDhKwxKlzE3O/l8QPpG7cZmIESXGcvwhsNVW0kFuGzsg2EVN7/HPWr3lBuatra0MXQgUbjA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(186003)(55016003)(9686003)(86362001)(7696005)(6506007)(76116006)(38100700002)(316002)(5660300002)(110136005)(8676002)(26005)(71200400001)(508600001)(4326008)(54906003)(122000001)(38070700005)(53546011)(7416002)(52536014)(8936002)(2906002)(66476007)(64756008)(66556008)(66946007)(82960400001)(66446008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDFtbHM1dmtkVHJ2akIxdDRnb2hUdzFCQlZyQ2NqSEUycVVMcFlxZm83dm1M?=
 =?utf-8?B?U2Nlcnpkb2dLSDRiU05JbG9iSHBkNFhiOUlnU1p3T01TMzB5MHpsZE1TbTVp?=
 =?utf-8?B?WFNkS1FmQXNpd3ZVdTNkRCtkQXdqbVh6QUhPeTNCeG5NOThOVkZKZnd1SFo5?=
 =?utf-8?B?eFRBMzFsZmNGTU9XTS80VkJlUDlKeHVONjhlS0J2QUYrdUs2KzZsTjlnYzh3?=
 =?utf-8?B?N0JXSVp5QjFmNzhBcG45S3RzZjA1Y1EvSmN4MHZMUEd0SkREL1lrdUhJZHFH?=
 =?utf-8?B?SWIyUkVVUklTR3ViQVdWeDBOZ2ZOcEJrUS9qR2phaU4yZ0ZhNW9yZTZjVk5E?=
 =?utf-8?B?V3lOMEhmRkRzcndrMTBJV3JxM09yRmFmOFFEMG8rRzl3UlZtWVdkN2dTTGJh?=
 =?utf-8?B?aDJpUzJ3RDk2dVBwbmRrZVAyU1pJU0dvRGNiSnNZZHlqb0pHZEdpZVloS044?=
 =?utf-8?B?M0t3VU4xTXE1WTVKcVJWbFpiN2c5ckd0OW5NZTRuM1ZkQVpJVHdBLzF3eklj?=
 =?utf-8?B?dkpteVVXcHhHU0RXdmxSZ1lEZnNyazRvTVpYeFlDTkRTYU8wOXZEcXBGMm0y?=
 =?utf-8?B?a0VJUFh0VXNDL3hVL09GRlZmdTZYbnJTQ1F4c3c2MW1TSC9Pc3Z0cDRVZnkr?=
 =?utf-8?B?emd6cHlxaHF0TmxnNFhCNnhtVjdOOFBocEdjdDI2eXk5U0ZzSkdHRnFvTnpM?=
 =?utf-8?B?MHhWdkJzYWxqUEdnM01NYURPdlhEazNkMWtyV29hc0x6WmFJeC9UakJkQ0d6?=
 =?utf-8?B?VXNmSUI4T3VtaHJoYlJwOFlaNmdGUUJSYjFNYnFKMUhId2tQdVJQWkFQaW9X?=
 =?utf-8?B?QjgwWUFuL0VJWkJzSzFmU0RRS0pEZVpiK0FkYVNKRXh6enlBWkQrRjhMVjFU?=
 =?utf-8?B?d0VqY1FsS0VkcnNvZTBwSThycnplYWlORStGb09SYWNxM2pvclBvNTBNUjJx?=
 =?utf-8?B?bmRnMHJWcVRiS0dSYjhyek5PbmR6MjZ0S09SQnhzQ0haZU9WMEJvVlNzaFJV?=
 =?utf-8?B?Mjd1cFFTbjdoRTFVQTVXbnE1a1JLVVV1ckJaU0NXV3hQZWxuYUZ4VjBKMklS?=
 =?utf-8?B?U3ZvYTF3RVpPa0twQ0VOU2lGK1ErYkl0Vi9MTG5NMGxoVHJLWVlKR0hudEw5?=
 =?utf-8?B?ZGZ1a0c5dWhRSEJ3OGJQbDl2OU9QR1I4MUh1TUl3alhrV2xmNVVNVFF2VzFE?=
 =?utf-8?B?UEhnOU1lSFdKRWZkdEZvbVRCb0NkSEx0dUlnRktvdXlsd0I1dEt5R2hZYktP?=
 =?utf-8?B?T3Q2aDdEN0ZGVGdoVE1rRmxON1VTRmRhdXQ1Z0FoYVhGd3FtNUQ2eWlId1BV?=
 =?utf-8?B?NjdmVGMzWnNpdzNpNVVqdDhEMUx6dFhEK2tkRXlyWlZFUFJjZzJpMW1NTzFh?=
 =?utf-8?B?ZTdBYW9BMndKL0VzVW1zeHByWUkvRVhXZHo0cS9OTG5hQTJxTWl6a01SK3NB?=
 =?utf-8?B?ejloVkk5K1BYMWZBc1BubzF1eTFqZm50MVdvYzVvQ1htcGNObk9CZjdGc29U?=
 =?utf-8?B?NTYrU2JGZ0paQVFkR1VMUVJGMWhnVlM1ZCs2WnBBVWdVT1N5WEZ2dU1QTXJD?=
 =?utf-8?B?bXBOUDAvalNYUEFhbVc3WE5vYnlGSnc1WFNPOXdRWmxNTFFaRVFJZWRPWEJU?=
 =?utf-8?B?SnJrczd6OGl3R0E0OVNoZURNSC8zd25lZThaWGFHWTdETzdhRWxDRUVhZTkz?=
 =?utf-8?B?MWZJWndsVk5tV0k2UWViK0ZScFkyenVuZDJGbVlvTHZTTUJMeGs4V0YvdFZY?=
 =?utf-8?B?aXBPbUxVRW5VaDBLN0VpUjFZbGNkNkt4MmxjQzVSY0pqTHc4dG04dkZHWmhC?=
 =?utf-8?B?UVAxOW5TVm1TeGxrQThmcEYrTWF1cjFhMFN6ejEyYUJBRDBmTzlFZ2g1clRr?=
 =?utf-8?B?dUFjeEJzZ092MStPc0VyWUM0SjNpajRBUE1PYXhqWlkxWE9yUElLRm9PbmpJ?=
 =?utf-8?B?SEl0Z1FCMmxZT2NLZjdKRnM4elRNUCtqR2Rxb3RFcFNRU3ltT0diK0RmaEZq?=
 =?utf-8?B?ODdHNExTNlgyVXBJbWQ2RDlRVklUNEFNSmRPeWZXVDI4OWJZdDBxRndvMEVI?=
 =?utf-8?B?MS9SU0dJVG0reFozUFp4ZE9sUkJLaUMzR21OUlU5YnUyL1JPRzBPY2RKdW5Q?=
 =?utf-8?B?MHhqaW1qOGtnMVNWSndsVmNzWHhRb1Y5QXZwQnpMT01FUnFTWTRNQk1ZeXBy?=
 =?utf-8?Q?D4/GQAFm/M+zrJCi/b1ND5k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d06f7b-cfad-4d95-0cc3-08d9c4605cf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 09:00:40.3213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zulXjynbDrt7aQrZy+ZfJGmhnPDB0IccJfsESEUPHoJvGP5GzE2BZaRQrrQMwuL6HF+my3/qswMQmigkJXlYcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5810
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMi8yMS8yMDIxIDQ6NDggUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IA0KPiBPbiAx
Mi8yMS8yMSAwNzoyOSwgTGl1LCBKaW5nMiB3cm90ZToNCj4gPj4NCj4gPiBUaGFua3MgZm9yIHJl
dmlld2luZyB0aGUgcGF0Y2hlcy4NCj4gPg0KPiA+IElmIGRpc2FibGUgdW5jb25kaXRpb25hbGx5
IGluIHZteF9jcmVhdGVfdmNwdSwgaXQgbWVhbnMgZXZlbiBndWVzdCBoYXMNCj4gPiBubyBjcHVp
ZCwgdGhlIG1zciByZWFkIGlzIHBhc3N0aHJvdWdoIHRvIGd1ZXN0IGFuZCBpdCBjYW4gcmVhZCBh
DQo+ID4gdmFsdWUsIHdoaWNoIHNlZW1zIHN0cmFuZ2UsIHRob3VnaCBzcGVjIGRvZXNuJ3QgbWVu
dGlvbiB0aGUgcmVhZA0KPiBiZWhhdmlvdXIgdy9vIGNwdWlkLg0KPiA+DQo+ID4gSG93IGFib3V0
IGRpc2FibGluZyByZWFkIGludGVyY2VwdGlvbiBhdCB2bXhfdmNwdV9hZnRlcl9zZXRfY3B1aWQ/
DQo+ID4NCj4gPiBpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1hGRCkgJiYgZ3Vlc3RfY3B1
aWRfaGFzKHZjcHUsDQo+IFg4Nl9GRUFUVVJFX1hGRCkpDQo+ID4gICAgICAgICAgdm14X3NldF9p
bnRlcmNlcHRfZm9yX21zcih2Y3B1LCBNU1JfSUEzMl9YRkRfRVJSLCBNU1JfVFlQRV9SLA0KPiA+
IGZhbHNlKTsNCj4gDQo+IEV2ZW4gYmV0dGVyOg0KPiANCj4gCWlmIChib290X2NwdV9oYXMoWDg2
X0ZFQVRVUkVfWEZEKSkNCj4gCQl2bXhfc2V0X2ludGVyY2VwdF9mb3JfbXNyKHZjcHUsIE1TUl9J
QTMyX1hGRF9FUlIsDQo+IE1TUl9UWVBFX1IsDQo+IAkJCQkJICAhZ3Vlc3RfY3B1aWRfaGFzKHZj
cHUsDQo+IFg4Nl9GRUFUVVJFX1hGRCkpOw0KDQpUaGFua3MgUGFvbG8uDQoNCkJUVyBkbyB3ZSB3
YW50IHRvIHB1dCB0aGlzIHRvZ2V0aGVyIGludG8gcGF0Y2ggMTMgb3IgMTQsIEkgZ3Vlc3MgeW91
IHdlcmUgc2F5aW5nIHBhdGNoIDE0IPCfmIoNCltQQVRDSCB2MiAxMy8yM10ga3ZtOiB4ODY6IElu
dGVyY2VwdCAjTk0gZm9yIHNhdmluZyBJQTMyX1hGRF9FUlINCltQQVRDSCB2MiAxNC8yM10ga3Zt
OiB4ODY6IEVtdWxhdGUgSUEzMl9YRkRfRVJSIGZvciBndWVzdA0KDQpUaGFua3MsDQpKaW5nDQoN
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IFBhb2xvDQoNCg==
