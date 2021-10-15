Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B463F42E886
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 07:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhJOF4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 01:56:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:40420 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhJOF4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 01:56:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="227809584"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="227809584"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 22:53:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="488017967"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 14 Oct 2021 22:53:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 22:53:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 22:53:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 22:53:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENvfIprnAXHbnbpff8qOv3OHvOer1atLr9pa1CyuhmX2sgToJ/1d2tKxAbSBG+qrzNIXaZn5RNOcsaoelaEZQQ2PKgiFeECFIgNo3w88LX497w/BXURewLn7rAnhxOcsGHwJU85OFahhhYmizIcE9yJSXZxAgPZJqnZFfFDJ4dqy47bCJ405kYhR1Um5umhX927hnu/8oi3BLTx3GROwAv3AO+gHqRlFtSGocjuWz9TV4cyPSgoQm4PI07ueBqnOG7Kw/fVTJ0966i35jIUkGjmNnRlUndrmH2J9U4s6W6LiiZsZ0hX0pue51HzYwXCzsbJwTT/veu7NL16bVsSSSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKvFJ1x9qAA8upBOK74w6rmJnSliM5KFM9nPss1XoVc=;
 b=f97uIzhmfsH+XJrIGtBuSGC9XXkZYPef2Ob2Ik57oS0ujPcVKe2qq191bB2XKCIpZmMPUVZMpUUesYDLDPadmpOKOfdhzeO+d45emQ2iMErYZGNylC6Q9ZhtmJQk3DmJ9Ni5CJuS37/+IE4sh7zNh+DvqlxKjwfMhJJ4hvOfsKabE0ce3VYXykaUez2cpoxg6aRvRSAtfgGTuo+VyvzWSn8sGS3dwL5veW5XnGGKSABdZWK/PlfH5KJqu0+TRSrzyfeOCJLbHWA5aZZqIJNWhC+uL69KnCAGG3WwcJ5Z2dFyuK6nOkzeUuDtU26RgiZJu5Z/WJvt1fhb1at8Bpt7Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKvFJ1x9qAA8upBOK74w6rmJnSliM5KFM9nPss1XoVc=;
 b=yz+ptudNXUFceZtacJt88+ioSW46526+bdPk6PaQoNooGayzWof6/TidrPlu3wk+qnpYK8OHfVhTe4peeE+Ft9rt6rtNme8CWyI2U8MiWdBzRrir3Sb36HTsYgqNLpk2DxIsVP8c+a1hR9mkp4AFLWydHGJqyK596CU+ylnPwfA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3842.namprd11.prod.outlook.com (2603:10b6:408:82::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 05:53:52 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 05:53:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Topic: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHXqhc5lUNcPisp4UyTMpTu0c9BsKu6db8wgABPxQCAAAa9IIAABOGAgAD+1fCAAGZQgIAXhuXQ
Date:   Fri, 15 Oct 2021 05:53:52 +0000
Message-ID: <BN9PR11MB5433164D17BB4C30EAEAC41F8CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <2e0c062947b044179603ab45989808ff@huawei.com>
 <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a128301751974352a648bcc0f50bc464@huawei.com>
 <BN9PR11MB543384431856FEF80C1AA4C58CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <61274f6497424f039397677fb5d003d0@huawei.com>
In-Reply-To: <61274f6497424f039397677fb5d003d0@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 638a70c7-125e-41ea-b33a-08d98fa02ac2
x-ms-traffictypediagnostic: BN8PR11MB3842:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB384207A881533E6134C6AAAC8CB99@BN8PR11MB3842.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t4ARodXmXHmhrxh7SqxNppfEd8QfBPdx4vHxFZPaFhUk08AMmom6vkQtDJ5eCp/rr/ik0hsjfpmOCh1P4oXI1vUvjuRgM5vEkmCz/PNNqTYPjKSEelhPJOj+B9iTbdOS1/Ke1BSSEKVho5urtMMfwFOyLS5fzP5xxLorcj2yxKBT1OX27QXPtrF8A8X0ujuCgy0zQ3Wk85bfVZ3PpR2eMnNFU6VOk3rxFjqTnO/nUsAtgiWUDJQCi55D7np1a1KnYLb+rL03ZxgEiS37rP1jgB0cKmnVTE91l0fPfB1CRrTmGo8octsKahqg93yOzJuL3ttIIxFqKrC5MRWWrnolazAGLVsFTmokzohwDmVatBwd0poO2locochUV56Ng+HBQbguxQczeFdvgHWL14clYTHb5t1JPp+Y5SN04fUsg6xYHSI5W2Pzg6pYM0Avwh/KZ/fOGlDw9nQ6qfPTojYhfCra2pkTL5SHOHp4u49MbNymJJ9RHXwzVXPKdSGrZoRIwv4KjLdgFR+C5doql/FYTplyQHHuCqwCubGds1jhxPZsxNAT5mNuzEbWpS0gyNEhEIGBTZGGMTqFfiCJDvo9WOy7GtNwe9MKn6oP+xl8tq1da1ytfWB++0W35o+9+9BrnGcby+RZyWwSepAZRRJr0qmpq3v0ztCLzaUy6cA0a7uwmG92N9pCwK0jPma2UwWRCj2jA8Tt/+428KY3PvhEeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(7416002)(54906003)(76116006)(66946007)(508600001)(5660300002)(122000001)(316002)(6506007)(2906002)(110136005)(38100700002)(4326008)(83380400001)(82960400001)(52536014)(55016002)(38070700005)(186003)(66446008)(7696005)(26005)(64756008)(8676002)(8936002)(66556008)(86362001)(66476007)(9686003)(107886003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWpKcXpSRG4zWE9xaW5XZGZEbFVYd005UHFzQSt4UGYzblE1Y0t5WTM3anpj?=
 =?utf-8?B?b2tYbkQxRFUwNkFLNHc0SzdFNGRNMUJTUlk5VHhUaVFiNkpkMUw1bnVLcTZp?=
 =?utf-8?B?ZW9QOVFTZ1RhUUJRa0xsblYyUXdxeW5Cek8xZjZoODN2YTZFYXU3cUIxbHhm?=
 =?utf-8?B?L1g3OHphNUdCS25QR1R2VjVMNU9iaVVEVk9haU1YNmIyV1pFY0V0cWNvb3Ja?=
 =?utf-8?B?RHU2dVQvWFZTeHgwL24raGE2U0FZdDJCNSt4b25XUWlEeWtZY29DNmRDUFly?=
 =?utf-8?B?NmFjVE9qQWlpK0x2Ry9mczFtQm1YR0Z4ZnZZcmZNTHhpRHBZdytFeUlrUGsy?=
 =?utf-8?B?OUVyVkhFME15bDJnSUduRm5KbUNraHlQaVRxbGpncnVpV2lVVWE1TGdpQ0NS?=
 =?utf-8?B?cnBvWWRwYmZRcG1Kd1VibWlTalYyUEVzakFJc1BmVVZQN2xXcmxCKzRwc0JQ?=
 =?utf-8?B?dytYbzg1VGpiZnFHQ2t5MFFzb0t6NEc4cms2Q2dWVHBqbjdqalFDcmNoNG1k?=
 =?utf-8?B?b29GWXU2ZnpuSXBKMW16aDA0YXBWOVlhV1Rad3hWSWhPZTM3ME5ZR0g5MUwy?=
 =?utf-8?B?T3dBK1JDVEFCZTErNFlrVlBmdjAwNFJwRUhFRmVML3Y5VUFpTDZwUWg2Vlhs?=
 =?utf-8?B?U1BVcFpheDgwNlpLVGJobkJOZi9GUVJZekJsL2VkYlhYZG8vQjZYbFppUGp6?=
 =?utf-8?B?VWZwTUtuR2J5eXIwL1NLN0VDN1RFRG43QmhUU3BIQWpRYjlxaUFuWFZTclFp?=
 =?utf-8?B?bHh1UzJRTUdTeW1USTRTbVZQNGVYUkpyNzJNU1BwQXdMK2tyVThOY3ptdXBr?=
 =?utf-8?B?UUhPUTJHY1NVTnYwb2R6azNqVSthNmE2U2YvQ0hTcXVXYkZDT0ZUblNCR1Jz?=
 =?utf-8?B?WVR6TVdyMy9UbFRveXVLRjV0RWUvNzg1RGVVVWJLaGlXNzZPQjdPUW0yUlRY?=
 =?utf-8?B?RmZWU2Nva0VrVDhSaDZFb3pjR1pnRXFzc290TnVoSjRUTFRLakx2UGxTN1Zr?=
 =?utf-8?B?STBlVmdzZjZMZmdOc2syQjIrMkZUeGUyRkRyZDZ4UkJjZkh0Z0IxQU1nYjFs?=
 =?utf-8?B?dzQxMUFJbUlhQ2NCenZKRHdnYWZMbkplclJzQXVuZFpwM2V0cE5pZkhlQUpa?=
 =?utf-8?B?VGRMMjZYck1oVFZrWitUMFJDUmwzSUorZVdFdGR2SXhlcXZUK2U3bHEvTDUx?=
 =?utf-8?B?TUhkN21lQzdtRUdqVmFBWm5kL1piakY4eE51eFRJWFRSRG12NVF2SGRHNllr?=
 =?utf-8?B?ZEd6L2dheXkzZWhJRTFFWVdUVk9FSS8xNXU0NzM1NjBPYVJ6SG8rWjhuV1RE?=
 =?utf-8?B?M1lDMmpQKytENk1NZU9PM0piUkhjeWZyUVU3U3JOR0lRSHRQeklRNjlFUUxK?=
 =?utf-8?B?SUNicHAyWFJQZUNIVk1wSnFtSy9HVzhZcmxuaXdCWk9DMjk2RjZKNGEyNkJD?=
 =?utf-8?B?N3M4ekxmY2kxV0FnY2Yxalk2Q1RxZjBGejhXQ0c4RU54TkhoWUNNWndvOXYr?=
 =?utf-8?B?YmV0NTE3cng3U0JIaGtpNysxVjBJVVhXNTRYUFp5QUx0dFhjcEVmZ3o0Ky83?=
 =?utf-8?B?UG8xQ1l2QWhMZFBEVW1jdThmSElzUHU0My8zUjgvSERkZHBmS1lJR2sySU16?=
 =?utf-8?B?TDlOYWV5WjE5a0lhcFRnYUthSllmZFpBZTU0bHI1KzFwbDRaRnd0cmlaQ1Fo?=
 =?utf-8?B?OGZibmU1TkNCRDVjNGtGQ1JpZ2QxQVBidjdXVVA3MFdYZmo1NXd4YkhZUjcv?=
 =?utf-8?Q?00suzXuG5vJyAbHdli60B3yhjZlw/RlVAE6MOG0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638a70c7-125e-41ea-b33a-08d98fa02ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 05:53:52.3014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utCGZ0u7EGXSVCmfrI5oJCFMlWxgqOVhAGbIGVLxeFCzQvgOOoa0JRTTxdC2bOg4k1QlLxW0/NFpupwCq+EmZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3842
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpIDxzaGFtZWVyYWxpLmtvbG90aHVtLnRo
b2RpQGh1YXdlaS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMzAsIDIwMjEgMjoz
NSBQTQ0KPiANCj4gPiBGcm9tOiBUaWFuLCBLZXZpbiBbbWFpbHRvOmtldmluLnRpYW5AaW50ZWwu
Y29tXQ0KPiA+IFNlbnQ6IDMwIFNlcHRlbWJlciAyMDIxIDAxOjQyDQo+ID4NCj4gPiA+IEZyb206
IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gPiA+IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRo
b2RpQGh1YXdlaS5jb20+DQo+ID4gPg0KPiA+ID4gPiBGcm9tOiBUaWFuLCBLZXZpbiBbbWFpbHRv
OmtldmluLnRpYW5AaW50ZWwuY29tXQ0KPiA+ID4gPiBTZW50OiAyOSBTZXB0ZW1iZXIgMjAyMSAx
MDowNg0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkN
Cj4gPiA+ID4gPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gSGkgS2V2aW4sDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEZyb206IFRp
YW4sIEtldmluIFttYWlsdG86a2V2aW4udGlhbkBpbnRlbC5jb21dDQo+ID4gPiA+ID4gPiBTZW50
OiAyOSBTZXB0ZW1iZXIgMjAyMSAwNDo1OA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEhpLCBT
aGFtZWVyLA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gRnJvbTogU2hhbWVlciBLb2xvdGh1
bQ0KPiA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tPg0KPiA+ID4gPiA+ID4g
PiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxNSwgMjAyMSA1OjUxIFBNDQo+ID4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiA+IEhpLA0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBUaGFu
a3MgdG8gdGhlIGludHJvZHVjdGlvbiBvZiB2ZmlvX3BjaV9jb3JlIHN1YnN5c3RlbQ0KPiBmcmFt
ZXdvcmtbMF0sDQo+ID4gPiA+ID4gPiA+IG5vdyBpdCBpcyBwb3NzaWJsZSB0byBwcm92aWRlIHZl
bmRvciBzcGVjaWZpYyBmdW5jdGlvbmFsaXR5IHRvDQo+ID4gPiA+ID4gPiA+IHZmaW8gcGNpIGRl
dmljZXMuIFRoaXMgc2VyaWVzIGF0dGVtcHRzIHRvIGFkZCB2ZmlvIGxpdmUgbWlncmF0aW9uDQo+
ID4gPiA+ID4gPiA+IHN1cHBvcnQgZm9yIEhpU2lsaWNvbiBBQ0MgVkYgZGV2aWNlcyBiYXNlZCBv
biB0aGUgbmV3IGZyYW1ld29yay4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gSGlTaWxp
Y29uIEFDQyBWRiBkZXZpY2UgTU1JTyBzcGFjZSBpbmNsdWRlcyBib3RoIHRoZSBmdW5jdGlvbmFs
DQo+ID4gPiA+ID4gPiA+IHJlZ2lzdGVyIHNwYWNlIGFuZCBtaWdyYXRpb24gY29udHJvbCByZWdp
c3RlciBzcGFjZS4gQXMgZGlzY3Vzc2VkDQo+ID4gPiA+ID4gPiA+IGluIFJGQ3YxWzFdLCB0aGlz
IG1heSBjcmVhdGUgc2VjdXJpdHkgaXNzdWVzIGFzIHRoZXNlIHJlZ2lvbnMgZ2V0DQo+ID4gPiA+
ID4gPiA+IHNoYXJlZCBiZXR3ZWVuIHRoZSBHdWVzdCBkcml2ZXIgYW5kIHRoZSBtaWdyYXRpb24g
ZHJpdmVyLg0KPiA+ID4gPiA+ID4gPiBCYXNlZCBvbiB0aGUgZmVlZGJhY2ssIHdlIHRyaWVkIHRv
IGFkZHJlc3MgdGhvc2UgY29uY2VybnMgaW4NCj4gPiA+ID4gPiA+ID4gdGhpcyB2ZXJzaW9uLg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoaXMgc2VyaWVzIGRvZXNuJ3QgbWVudGlvbiBhbnl0
aGluZyByZWxhdGVkIHRvIGRpcnR5IHBhZ2UgdHJhY2tpbmcuDQo+ID4gPiA+ID4gPiBBcmUgeW91
IHJlbHkgb24gS2VxaWFuJ3Mgc2VyaWVzIGZvciB1dGlsaXppbmcgaGFyZHdhcmUgaW9tbXUgZGly
dHkNCj4gPiA+ID4gPiA+IGJpdCAoZS5nLiBTTU1VIEhUVFUpPw0KPiA+ID4gPiA+DQo+ID4gPiA+
ID4gWWVzLCB0aGlzIGRvZXNuJ3QgaGF2ZSBkaXJ0eSBwYWdlIHRyYWNraW5nIGFuZCB0aGUgcGxh
biBpcyB0byBtYWtlIHVzZQ0KPiBvZg0KPiA+ID4gPiA+IEtlcWlhbidzIFNNTVUgSFRUVSB3b3Jr
IHRvIGltcHJvdmUgcGVyZm9ybWFuY2UuIFdlIGhhdmUgZG9uZQ0KPiA+IGJhc2ljDQo+ID4gPiA+
ID4gc2FuaXR5IHRlc3Rpbmcgd2l0aCB0aG9zZSBwYXRjaGVzLg0KPiA+ID4gPiA+DQo+ID4gPiA+
DQo+ID4gPiA+IERvIHlvdSBwbGFuIHRvIHN1cHBvcnQgbWlncmF0aW9uIHcvbyBIVFRVIGFzIHRo
ZSBmYWxsYmFjayBvcHRpb24/DQo+ID4gPiA+IEdlbmVyYWxseSBvbmUgd291bGQgZXhwZWN0IHRo
ZSBiYXNpYyBmdW5jdGlvbmFsaXR5IHJlYWR5IGJlZm9yZSB0YWxraW5nDQo+ID4gPiA+IGFib3V0
IG9wdGltaXphdGlvbi4NCj4gPiA+DQo+ID4gPiBZZXMsIHRoZSBwbGFuIGlzIHRvIGdldCB0aGUg
YmFzaWMgbGl2ZSBtaWdyYXRpb24gd29ya2luZyBhbmQgdGhlbiB3ZSBjYW4NCj4gPiA+IG9wdGlt
aXplDQo+ID4gPiBpdCB3aXRoIFNNTVUgSFRUVSB3aGVuIGl0IGlzIGF2YWlsYWJsZS4NCj4gPg0K
PiA+IFRoZSBpbnRlcmVzdGluZyB0aGluZyBpcyB0aGF0IHcvbyBIVFRVIHZmaW8gd2lsbCBqdXN0
IHJlcG9ydCBldmVyeSBwaW5uZWQNCj4gPiBwYWdlIGFzIGRpcnR5LCBpLmUuIHRoZSBlbnRpcmUg
Z3Vlc3QgbWVtb3J5IGlzIGRpcnR5LiBUaGlzIGNvbXBsZXRlbHkga2lsbHMNCj4gPiB0aGUgYmVu
ZWZpdCBvZiBwcmVjb3B5IHBoYXNlIHNpbmNlIFFlbXUgc3RpbGwgbmVlZHMgdG8gdHJhbnNmZXIg
dGhlIGVudGlyZQ0KPiA+IGd1ZXN0IG1lbW9yeSBpbiB0aGUgc3RvcC1jb3B5IHBoYXNlLiBUaGlz
IGlzIG5vdCBhICd3b3JraW5nJyBtb2RlbCBmb3INCj4gPiBsaXZlIG1pZ3JhdGlvbi4NCj4gPg0K
PiA+IFNvIGl0IG5lZWRzIHRvIGJlIGNsZWFyIHdoZXRoZXIgSFRUVSBpcyByZWFsbHkgYW4gb3B0
aW1pemF0aW9uIG9yDQo+ID4gYSBoYXJkIGZ1bmN0aW9uYWwtcmVxdWlyZW1lbnQgZm9yIG1pZ3Jh
dGluZyBzdWNoIGRldmljZS4gSWYgdGhlIGxhdHRlcg0KPiA+IHRoZSBtaWdyYXRpb24gcmVnaW9u
IGluZm8gaXMgbm90IGEgbmljZS10by1oYXZlIHRoaW5nLg0KPiANCj4gWWVzLCBhZ3JlZSB0aGF0
IHdlIGhhdmUgdG8gdHJhbnNmZXIgdGhlIGVudGlyZSBHdWVzdCBtZW1vcnkgaW4gdGhpcyBjYXNl
Lg0KPiBCdXQgZG9uJ3QgdGhpbmsgdGhhdCBpcyBhIGtpbGxlciBoZXJlIGFzIHdlIHdvdWxkIHN0
aWxsIGxpa2UgdG8gaGF2ZSB0aGUNCj4gYmFzaWMgbGl2ZSBtaWdyYXRpb24gZW5hYmxlZCBvbiB0
aGVzZSBwbGF0Zm9ybXMgYW5kIGNhbiBiZSB1c2VkDQo+IHdoZXJlIHRoZSBjb25zdHJhaW50cyBv
ZiBtZW1vcnkgdHJhbnNmZXIgaXMgYWNjZXB0YWJsZS4NCj4gDQo+ID4gYnR3IHRoZSBmYWxsYmFj
ayBvcHRpb24gdGhhdCBJIHJhaXNlZCBlYXJsaWVyIGlzIG1vcmUgbGlrZSBzb21lIHNvZnR3YXJl
DQo+ID4gbWl0aWdhdGlvbiBmb3IgY29sbGVjdGluZyBkaXJ0eSBwYWdlcywgZS5nLiBhbmFseXpp
bmcgdGhlIHJpbmcgZGVzY3JpcHRvcnMNCj4gPiB0byBidWlsZCBzb2Z0d2FyZS10cmFja2VkIGRp
cnR5IGluZm8gYnkgbWVkaWF0aW5nIHRoZSBjbWQgcG9ydGFsDQo+ID4gKHdoaWNoIHJlcXVpcmVz
IGR5bmFtaWNhbGx5IHVubWFwcGluZyBjbWQgcG9ydGFsIGZyb20gdGhlIGZhc3QtcGF0aA0KPiA+
IHRvIGVuYWJsZSBtZWRpYXRpb24pLiBXZSBhcmUgbG9va2luZyBpbnRvIHRoaXMgb3B0aW9uIGZv
ciBzb21lIHBsYXRmb3JtDQo+ID4gd2hpY2ggbGFja3Mgb2YgSU9NTVUgZGlydHkgYml0IHN1cHBv
cnQuDQo+IA0KPiBJbnRlcmVzdGluZy4gSXMgdGhlcmUgYW55dGhpbmcgYXZhaWxhYmxlIHB1Ymxp
Y2x5IHNvIHRoYXQgd2UgY2FuIHRha2UgYSBsb29rPw0KPiANCg0KTm90IHlldC4gT25jZSB3ZSBo
YWQgYW4gaW1wbGVtZW50YXRpb24gYmFzZWQgb24gYW4gb2xkIGFwcHJvYWNoIGJlZm9yZQ0KdmZp
by1wY2ktY29yZSBpcyByZWFkeS4gTm93IHN1cHBvc2UgaXQgbmVlZHMgcmV3b3JrIGJhc2VkIG9u
IHRoZSBuZXcNCmZyYW1ld29yay4NCg0KK1NoYW9wZW5nIHdobyBvd25zIHRoaXMgd29yay4NCg0K
VGhhbmtzDQpLZXZpbg0K
