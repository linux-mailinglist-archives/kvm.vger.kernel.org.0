Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F753D343C
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 07:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhGWFDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 01:03:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:39637 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhGWFDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 01:03:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="297383934"
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="297383934"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 22:44:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="433552291"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 22 Jul 2021 22:44:19 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 22:44:19 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 22:44:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 22 Jul 2021 22:44:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 22 Jul 2021 22:44:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxfvURjewi7XOsbR9GeBmgQyP6Isy4CGL/+WDIdHXpr/Li9aRl99cQBYyLvJAjHxtBoB3XJu6nXrLZEaIkzjq9lvlYOVKn9WGbRxJzyRxSY4wUk037z81IFAj1khlX0QIytrvIkOegTXfiDmLaLxakYfbmCjZVW+4+T+cMS9RNlx5nfMiNgz6P27nHpipq4HzOPbMd03LhOEcMtX/4E36lIhwhjkqRwjikJOamJQGjx6/UPoFakWzTmkHKHkHiodiDHgwYxzgfV+3X2heKA6L7gEYPb+P/bov8FgSSTlOTE4DQhJ7yRhY1QpqC8MAs8pw5XmW3Ez4xL0QUGABhZ8kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW0HF5OJp/y6ZM1qDcbAIUkmyiaidr9IpVI8Un2VTFs=;
 b=cblK3Y64Zzo/M+byQdSpBeCMYbHANp79OGKkOD5L9oDSy9WUwuP4rJU+t5UfqyAD6laZnsXIO7rOmqDt9Lh6nOS1eQ89/l+db3jYZDUPzBZsAsr+zQkNESoG06tMR/KOcDNadK+EI0GJW/3/CKLHiisjRYegBbZU3b2/yVQxU83tpMqYycUxW5vC7WSRv2FilGBYNya0oEwcW2bYhaOGQZEZrSSiGutcK6bDvTGo8hKigvAMDHclOJ3voTJpJskmCW3JfJLhjxkgbDUXKaMFVYOD6uufEm30xhPEQEwHr8vQmpRNY7eXR5GQsE/slI1VaTNuBeT29zFgEut7L4soLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW0HF5OJp/y6ZM1qDcbAIUkmyiaidr9IpVI8Un2VTFs=;
 b=K6d+aROah+EsjS1v+7t9yYJvirSoPczfThPCpMazqvE5rm463LkMO8k+LUdDy4Q5xIeQBtbZzzV++pyxuSClQ6CRvRD6k9oA8i/mw7gfvGUsYaFeYN2pJuVddK1RRZoIqRNMmx2MVy+iu6ZhlC9ZdYqfrPBTvAfFZh8L4qCA3Zg=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4099.namprd11.prod.outlook.com (2603:10b6:405:82::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Fri, 23 Jul
 2021 05:44:12 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 05:44:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABJmdggAASuMCAAF5dgIAAAFGAgAAT44CABKOLAIAAAkEAgAAGdACAAAupAIAAIZMAgESRwUCAIwZ+AIABCmGQgAADmACAAABpcA==
Date:   Fri, 23 Jul 2021 05:44:12 +0000
Message-ID: <BN9PR11MB543361E060ECE78CEB005AE68CE59@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org>
 <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210722133450.GA29155@lst.de>
 <BN9PR11MB5433440EED4E291C0DCD44BA8CE59@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210723054106.GA31771@lst.de>
In-Reply-To: <20210723054106.GA31771@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 233e47f7-d0a8-4f26-e343-08d94d9ce657
x-ms-traffictypediagnostic: BN6PR11MB4099:
x-microsoft-antispam-prvs: <BN6PR11MB4099E925ED1897B592A7B9548CE59@BN6PR11MB4099.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9z6/qvN6OXLtzqV5/Gc0W65dQXJpbczfJIOdFAG6K5Vb/WOP7QzcjHP9eQQknacuu52PcxlpYWI4ON4p8F5wUSlA902PVwZ3dqbpItLbU3f0ky0tMqbxeRS9j9geFKCqpOi+FqxQaAJCE4MuS1PWH21jqB5Tdv9j8YzkmWAkxVw/A5GerCSTBXGmJr8OrI3au605G/Dlc6oW0cqKvyCDG7zkcLHGmwzU+b8GkyVt6yt6xov0Vwt3r4ngtc8VjexSg8SQFLf+pL+5V5jgH89kuzVGYb+Yv21JdJ4WB7dSpDnuHBFFQQn2DQJMXqfLqeePCc+PTgkLxvvOKL2Qdr9EYHTZZgNvGS/jfVvpCfbhSltEXD09qougkHipl0aSg366m0/QDk3HOxYa5IFmJ8caYpHZCmN7wZJpnTc+iKZLDpqRkdkNw9E1p0u3RnaY2Y1pMRd4ql5t+orUZhBCVwzxaonvnCT5BrywutB9IDFlECktL/j0sFHKOcg5yVJmmil3Lx3haMeHtS5TVWhSaM7AlLMFj+0ZB7cyIFHgxtn6yHe6H8wMV+4Fx1eGl2IxNKCrf35ABBHFdLqVsmyRaVqg9G5NBAkVteOTwh9C1LhMv2bT/ESb7Yd2hCuoGSHw6XF9o2d7LsMdjBY+/ciQESeoMJLNOZQy2afUCK2PxENoBicaj7SuubzL37s6UmbFlLtW6U/KvmR0hZD31aYlQWaSqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(186003)(83380400001)(26005)(71200400001)(6506007)(33656002)(55016002)(8676002)(7416002)(86362001)(9686003)(122000001)(7696005)(38100700002)(478600001)(4744005)(5660300002)(76116006)(316002)(4326008)(66946007)(6916009)(66446008)(64756008)(66556008)(66476007)(8936002)(52536014)(54906003)(2906002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWwvR1VLQ01zdldoVFFMcDh1ZUZlUlBUMXJFZ0VJanFrOEFkd3l0S0txdFRG?=
 =?utf-8?B?cDkzWmxLSlc0Nk1YU3UxT2VveXozZk1VRmkxdmxDdVlvYUluVmtVaUVmYUxL?=
 =?utf-8?B?QjlDc2w0L3V6N1BqUTZSSUNndmg2WTJPc05pc0Q4bE4rWGJVOFVjNHJ4cExx?=
 =?utf-8?B?aTNudUhObHNRKzgxT28veXlWL0w1ZVY1S0lLajF6S3BSaG5nbEdIZXZIanpl?=
 =?utf-8?B?empoUUpDOW41RDV6L2UzYXBJUzBiS1pYM21YTG9pbkZJZ3gvelVoM3lSWEZS?=
 =?utf-8?B?NHczWWx2MXpBNkI3N2hRNmtJR0ZVT1pSZmRCLzgxUzlXM3RLTmoydFR6d24y?=
 =?utf-8?B?dHd2aFJSWGdaTEtZckh5bnZXZDhkMXJ6OWFwYnJxQnVzSjVjNXJBZFN1VEgw?=
 =?utf-8?B?eFRoOG5FRFMvc0trc1RteXdMWTBtU05pTjJQZDdRUnFrSW1WQ3VGeENpOThD?=
 =?utf-8?B?eUxYcy9LZHRyNkE5cU5xTmhkTzM4RWxvQlZrb1N1SDVBd045VStQeFZ2akFs?=
 =?utf-8?B?NElGWGNXbUhiR1cxU3NyeGV5Q1hwdDdXb0FwaGtWQ0p3YThlM3BReHdFTXVk?=
 =?utf-8?B?SDMrODBXcDloZEtwT1JqTVVZd24vZXZZU0lvd3QyNUJxcHFvODNwdlpseG5M?=
 =?utf-8?B?bVRudzlKMTVSUWdJZ1M1blNxL3YrYm1xaDdsRVlqU0V3SDhUOVZ6S2lqK1lU?=
 =?utf-8?B?V08xd3c5aWMrS0dUMkpjazVra1ZUd05TT0NDWkI4STgvdWVhd1plaU9CMTNx?=
 =?utf-8?B?Smt0S1VrZnh1RjRwK3ZneFgrbU0rQTdOb0U3RGY3OUlFZ3gxQlUyMDFOTm8w?=
 =?utf-8?B?Ni95aDlBNVYxWVJqc1J1ZTVyS2xsTy90Y1pCUzVPZWxJTWpET2EwcFJEczVX?=
 =?utf-8?B?OG1mejFjWUxQMUplbFYzZ0NtclpHdmcxRGt2bmhKeWpiWERGZkdNbGdyL1N3?=
 =?utf-8?B?QkJsWWs3Y3V4ZzhndTZVN3FrWkdodWxnTWxIUUFFK3BLKzR1V3ZhNVN0NGpW?=
 =?utf-8?B?VHBIWldEYWtldWw1dm1HeCs0UHg0MTJnSG9WOGNYdWxaWGNlc0VCa2VNcHNL?=
 =?utf-8?B?RzlHUytSQUh1RFZraWZjNVk2UXh2emE0SmdienlTOFdiVmQ2cFpXVEYyREZ5?=
 =?utf-8?B?R1dWM1piYXRjOFB5dGpxSnhlWFhQMXhKeXBaMkdDRzUyRXhPWUZLd3hRcXpW?=
 =?utf-8?B?MVY5eTVURVFQMjNWamVST29Zc2xvVlFOZmhyaXp0OENJUjY5b00rVVN3WFI5?=
 =?utf-8?B?d2xiMWYwU2xPamlQU0N6Qm5TL0V1SnpaUnlheWJYbG9INE1saldsa0FrSHc2?=
 =?utf-8?B?K1F6V0lDUjRPUUF6NytHNHN1WDgxOUNBblRhRWZ5TmxLTWZtOWdwdU02b3M5?=
 =?utf-8?B?UW9mS3FuSUsrMUxlUE4vUW5VWmNQUnNTR3dLdVQ5d0FIZVpYZFJLd2ZHRVU4?=
 =?utf-8?B?MVNKc3pHdUd2SzFHbGtZT0Q3elVjVjRpOXQyT0haalRBSWpJY3MvVkUzQ2Zx?=
 =?utf-8?B?bzRNMWYrZmhiNDlRbDhqN05BdGpKYXJRWERTY01MSmNYSW1jODdDWkoyOHpH?=
 =?utf-8?B?c0h5TkJXTFkzWG5oTEdmMzhEdktDL2F1ZHBuSW81Vm1VRWVJaHpCdVFtZ3Nm?=
 =?utf-8?B?bUFQcjdiSGIwa25LRXRuRlVrMzhCZEcwcW9iNzFCVHdWWFFjejFLNEhxanRa?=
 =?utf-8?B?eWpMTTRsOUc1NzFQL0lKdytQMnd1ODFSL3VHVm1BaUZib20yZDJScUNCV3Fo?=
 =?utf-8?Q?Z1RK4ZeIkF6+ambh+ps7l8BL5QECG4Av7biBd4T?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233e47f7-d0a8-4f26-e343-08d94d9ce657
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 05:44:12.2530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5Dpi3eB3YsiKaDVkvHqEG4x+ZGdE0fN1/vJwbgFJFBZfh6YdXbqaQ+dwAgCchIp3cWxIMqRFrFQ2qOXIuJVJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4099
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gU2VudDogRnJpZGF5LCBK
dWx5IDIzLCAyMDIxIDE6NDEgUE0NCj4gDQo+IE9uIEZyaSwgSnVsIDIzLCAyMDIxIGF0IDA1OjM2
OjE3QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gPiBBbmQgYSBuZXcgc2V0IG9m
IElPTU1VLUFQSToNCj4gPiA+ID4NCj4gPiA+ID4gICAgIC0gaW9tbXVfe3VufWJpbmRfcGd0YWJs
ZShkb21haW4sIGRldiwgYWRkcik7DQo+ID4gPiA+ICAgICAtIGlvbW11X3t1bn1iaW5kX3BndGFi
bGVfcGFzaWQoZG9tYWluLCBkZXYsIGFkZHIsIHBhc2lkKTsNCj4gPiA+ID4gICAgIC0gaW9tbXVf
Y2FjaGVfaW52YWxpZGF0ZShkb21haW4sIGRldiwgaW52YWxpZF9pbmZvKTsNCj4gPiA+DQo+ID4g
PiBXaGF0IGNhY2hlcyBpcyB0aGlzIHN1cHBvc2VkIHRvICJpbnZhbGlkYXRlIj8NCj4gPg0KPiA+
IHBhc2lkIGNhY2hlLCBpb3RsYiBvciBkZXZfaW90bGIgZW50cmllcyB0aGF0IGFyZSByZWxhdGVk
IHRvIHRoZSBib3VuZA0KPiA+IHBndGFibGUuIHRoZSBhY3R1YWwgYWZmZWN0ZWQgY2FjaGUgdHlw
ZSBhbmQgZ3JhbnVsYXJpdHkgKGRldmljZS13aWRlLA0KPiA+IHBhc2lkLXdpZGUsIHNlbGVjdGVk
IGFkZHItcmFuZ2UpIGFyZSBzcGVjaWZpZWQgYnkgdGhlIGNhbGxlci4NCj4gDQo+IE1heWJlIGNh
bGwgaXQgcGd0YWJsZV9pbnZhbGlkYXRlIG9yIHNpbWlsYXI/ICBUbyBhdm9pZCBjb25mdXNpbmcg
aXQNCj4gd2l0aCB0aGUgQ1BVcyBkY2FjaGUuDQoNCnN1cmUuIGJ0dyBhYm92ZSBhcmUganVzdCBw
bGFjZWhvbGRlcnMuIFdlIGNhbiBjbGVhciB0aGVtIHVwIHdoZW4NCndvcmtpbmcgb24gdGhlIGFj
dHVhbCBpbXBsZW1lbnRhdGlvbi4g8J+Yig0KDQpUaGFua3MNCktldmluDQo=
