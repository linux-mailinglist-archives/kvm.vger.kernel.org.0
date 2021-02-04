Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31B130E9E2
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhBDCE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:04:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:22323 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhBDCEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:04:15 -0500
IronPort-SDR: OlWZMc07NOmxMx/25Uq+Q+jCqdo4D4E3V4PTl3Vs7ytJOBvv8Y34CMNXv3eP34Frfx6vIF+R+g
 +WR7dosyYKXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="160912519"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="160912519"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 18:03:22 -0800
IronPort-SDR: uA73ZDLew+hYz7luCdUYFF7mAWAb/yK1kuDdvbo4tF+N1bYKVcIhwrhVMj2jKNJM2flJEmMgJO
 7g2MORpNGRrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="480700880"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 18:03:19 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 18:03:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 18:03:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 18:03:18 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 18:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdFmR7YDci1VrM5Zz1jeMoShkddh4u8LGAkpR8cHa5v5INHKRqGiiYA+LSk9PEkXsVh6vwOaiLuVP6gYuWRQ22ulpL/z12B2nXxeuHBjDcbnTUkIBQA6ho9Jtc73VcoV+LAjC9xZH2wDo40yuEzkSpVXpTgLbPRnve+m4E/up7BLyCJicu9oY6SCr5EwkFZNeF5xLUX9PO574osnMo37x1xcOCr06MHNUwKyxCIr9WgW0SF/kPaRU+J72R71iMo4u9OT1bAlT07U35PM41S/gCmrAgGpKlmKwdI+NJKGltnkTozmTGngJ4kfRat9sO1mTAFKaZLvo953BD/k3HR/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oa2Z6pv0cMbe6baevUoo1oyk+f7oZb1+6aOfUm94KA=;
 b=IkLEVziNbWV5O3sMDJyq3OsXe3PEQZccDKLvMqcgisUJ4njjAU3jVXgYu+t4TYdEL0bRigDClydWKT+Xu2HfbA2C9INWAAwpDLr6HcaWCj3YrTbP5nPXeT9sU10POgQzmJN75B6wra9XGPb+/kgyZXUvQgIiK6Q1liUzRFbXdC4reP7/0jRl1hjppn9If6Q7XV1cG7zn8i+Osg4HfNLZ4DYKIA03q7RqaZEChvjPNrfgTHZVnUCXCMVaD/xD3Q1rj5cUvBtPADrZx3+YWpjXWJpHwmHZq98AEh84fy4UlIq3lyDKupP7bFMW4B6YKifhTt/lYZPts4nilu2wJg6tjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oa2Z6pv0cMbe6baevUoo1oyk+f7oZb1+6aOfUm94KA=;
 b=i+IPxNG7d0BVB6JPb41hQJETOPLXyFt9KhzOSXhMMPJ/HWniySbX45Mfqw3QlGOTuan0YrwjO6C0WpZ7nrR+NJLWgUNuQpYYNX9s6meg9hm88nE0xGsb0YaZbWupZP1Vcg9fjnW+WI5RseWIVo0UBiudmWC6ZfAMzMoOu23QU2o=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB3375.namprd11.prod.outlook.com (2603:10b6:805:c0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.21; Thu, 4 Feb
 2021 02:03:17 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 02:03:17 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Thread-Topic: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Thread-Index: AQHW+omuBE5yjAcpaU+GTJSpysfjUapHPrkA
Date:   Thu, 4 Feb 2021 02:03:16 +0000
Message-ID: <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
References: <20210204000117.3303214-1-seanjc@google.com>
         <20210204000117.3303214-8-seanjc@google.com>
In-Reply-To: <20210204000117.3303214-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3 (3.38.3-1.fc33) 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c37abce-3fea-4d6a-35fe-08d8c8b109b3
x-ms-traffictypediagnostic: SN6PR11MB3375:
x-microsoft-antispam-prvs: <SN6PR11MB33759C802C7F5D19B56C6839C9B39@SN6PR11MB3375.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1tzESNCRMVP2CsCpLzqovJxCTI1ja3u01isdxLvAusiLiFGwl6TDQ2NBhsfsh6fhb+aIMOdgQRZ4E5gDOHhReFBAo1Sa3/7dYZ9zLdKIEJ4Y6lLcjN6roQec4RPMEKUDxBveEXOA0BAJjKM8CUElau11N5pCkwfGzbSm9awo/umXcINcOKsEJxjqLS8i1YumZmgtNpLMyqARGKgnvKsIKhqgtoV3vowbi1z1HPW6DLjjjyb3WVGdyRdEwzcvbIVU4Y0MqH2qtudDjspwS93cIhjf1+o1NBNGHs/4bsswDWHBa3SeLE2pnm+PSL6bKB95qABfYkM2/oECn2vhs5Uvk9U6v375CD/Zbvxz5AbyiFK61x0v+6zNNhPg5WLAXokWybDbVeQxJa4yRwRJY4t8/YyyD3ggvrOXMDaWZgXiFeNOidbHYO1D27EDyN20BIQ+TfFIB2e+EtcSN7s5cIo/s6kX7TOr8TS2Igy6xh6OKWPLrOraElklPNZyPA+7jG4kYHdyTuZN7AZ/RapgCI7oyR41NkEs54dDZXWbAvk+r0ZFbZjtLLpi/Nf9pkbJmgYi5knLCfa9O8c+cNS3q5/UfgCgCHh0bAUQWsybFf0td9M21kiS1pNB8qTRrM8KosnS7Aad9FCX8NSGMAdg+IUxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(136003)(366004)(8936002)(66946007)(36756003)(4326008)(8676002)(966005)(26005)(4744005)(83380400001)(66476007)(86362001)(66446008)(64756008)(71200400001)(6506007)(2906002)(6512007)(316002)(5660300002)(7416002)(186003)(54906003)(2616005)(6486002)(76116006)(478600001)(66556008)(91956017)(110136005)(26953001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Eu3fsbzgcTziCIwg7EoMTJLUcRcM/xk5KZkz/vLqY3Eet/CbXMVgH+UY3jRhqIsFN0XiKtU1P8ffSV1CHKfMZq28TUiS/zg7/IOEENWvd4M5yV47KLZoos4N4ZOBT/c4tzTMJaqpISW2US/Fftx2GhHF0EV5Mn64L89Gwxky9l+J3Bs9GBg484pgyxUVye86E95vLb8vCd//Cml4kBupK0qsRNKhn5NBnx/+WpxBlrWckren/PzIWeBu1GFgAK5hsca0tWHXpPklE6H7iY4aOjnn1p7TKPZmbNYoX41ZHmM3dBwoRCjUETimU6/Ei2imMsE/VRxgeBVLSaNKKhr8S5JMZICjdBtgWwXR7jSyC9dKH2mighRbppUo9ecxQStheorL0HSnGSu0ol1SIilXL3hhPzi/wkf0Cul1YR7iEkuhfK89898TqA6dTR4Z1JvAGl5t++tEP2LDLXUBM+pVPYLHnLgBA5JvT++k0i4FkwlWc8YivVFRlP0ybK8/Od1KyWVYeBMarsMsoEUvXRPpbB0KDkfy7n+NuUQu47wHAxuGBWTZKnkEMWQs2mJb57z1Q1A+Ue0xKs7/KgDyD3YSZjJ32UJkKZAV049WdubpAOJTiIVsogLN87kiJoXrMM6hxkTNFymFpkvChRxCj1Ia+UrZcioupqfsLcZSZ7znSJpfLtctzMxw/Rx3J59nH3IvqmnVs+a107eZCSrKRrqufnvD4krA6fNobw6dUY/UVSMf7l2rwLFjSUtEAP69ZSGj
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <696647994DD37449AE13E0D2CE45C5A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c37abce-3fea-4d6a-35fe-08d8c8b109b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 02:03:16.9422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQHpstsXlBpy42ZMj7Ll07JZqVkL0Kzud5Z8fjdSple6sceq4U1yws4seugGv3nWVKf7484QWjwzwXhpwk6XkGD2d1oJ4nXD0mEBweWEmjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3375
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTAzIGF0IDE2OjAxIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiDCoA0KPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIGNyM19sbV9yc3ZkX2Jp
dHM7DQo+ICvCoMKgwqDCoMKgwqDCoHU2NCByZXNlcnZlZF9ncGFfYml0czsNCg0KTEFNIGRlZmlu
ZXMgYml0cyBhYm92ZSB0aGUgR0ZOIGluIENSMzoNCmh0dHBzOi8vc29mdHdhcmUuaW50ZWwuY29t
L2NvbnRlbnQvd3d3L3VzL2VuL2RldmVsb3AvZG93bmxvYWQvaW50ZWwtYXJjaGl0ZWN0dXJlLWlu
c3RydWN0aW9uLXNldC1leHRlbnNpb25zLXByb2dyYW1taW5nLXJlZmVyZW5jZS5odG1sDQoNCktW
TSBkb2Vzbid0IHN1cHBvcnQgdGhpcyB0b2RheSBvZiBjb3Vyc2UsIGJ1dCBpdCBtaWdodCBiZSBj
b25mdXNpbmcgdG8NCnRyeSB0byBjb21iaW5lIHRoZSB0d28gY29uY2VwdHMuDQoNCg==
