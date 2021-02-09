Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC62314DEB
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBILJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 06:09:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:22915 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232343AbhBILGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 06:06:55 -0500
IronPort-SDR: J70i7zP8R7xRV0n5MTucMYNKNL45wf3edb8SUVzsul7m03fW80aVPIEw0nKBrvobFAfsg34wz/
 z5z73vui+5jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245931592"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="245931592"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 03:06:13 -0800
IronPort-SDR: om0LR8pKGAep5mhjBYeR8lIhQ4fGwC7gUDVXYtDGYAFIK8UXJu2a6SRS6GIONBvKsO4UT6JQL/
 Ud9CwPSRr8dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="398749446"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 09 Feb 2021 03:06:13 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Feb 2021 03:06:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Feb 2021 03:06:12 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 9 Feb 2021 03:06:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDcLCxEwP+8/MB8UDHSFNzNZnzoKlESGpoo/zHvW11u8HNwj0I9R4+P/jTa55bR/iAiSO9XSDBBpbxp8pNorLjgAjAj9LCjEey4X3UJOkSwFeezgD/++89PBxxCAnmfiOqPaJmgUH0xreheaSYcU5sdG1bOog8kiGkJkmkLc7VDLxejW1KOOgX1lqdDTXXEaSpABpCtp9n13rAFlLSj2lkv5Qw8vaD0OKJTFIc7TkrkO3mbT7GVchnh/nZ1tgLWHfxKat1DqY5R8nC6/euLlcM2Mdc3HMTixogk3N/SJAmWtsaWVcRYGhemwiCuxtcr6uETSoVDTGiZLFrB4bwWuUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdEitYfvsfDyFE4ZBf7W4MWF3SyPtkzFo8VrFykSoUY=;
 b=NRUmbpJzdeAcLaV6Y3ZerHzNc+YPB6A2F4LQQ0E2tactA9HS9K5BoRlHDn4AUJ0ihLKAIQDMFE+CWte75mrlcNKPQpBhtrOb4BBlwqNRVEqlyFLIKpPIq8HVf1jdi8IHp4NCzxVsREzChcUJ2A5MMggHvhuAwRyIm0ZK5IM3RM5cvtEgz/QsP9NU8AHZkfK7kj0Sx+Wxm9RkiB6VAvi94USc1qRUasO50TFqzrvZBnuC48K/u5ymzWF+wem4b6WwYNvvLhcSneYbM5bPjhRuGca8ro8DHBolMAUXPssMJTtYcB7s3JQbOukN8tgcQIRJDq5DR1vEHV+qGLB6/493Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdEitYfvsfDyFE4ZBf7W4MWF3SyPtkzFo8VrFykSoUY=;
 b=FoDgRjw1xdUotPWcNdnaXe4Q2gcJkeeLYzWRsNE0QkzRg9e8+S6y+DecRxmtLix0E0dkcbAi1F8akWgb/iTHNIzQ0mFfvrhmITAun1Sn9lrKoiqu9JAMeYiK18d3NLiKHG6kXbewItVfnzh1vPTHB//mUapxY20+kWjL6XASLO0=
Received: from CY4PR1101MB2328.namprd11.prod.outlook.com
 (2603:10b6:903:b6::22) by CY4PR11MB2021.namprd11.prod.outlook.com
 (2603:10b6:903:2e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 11:06:11 +0000
Received: from CY4PR1101MB2328.namprd11.prod.outlook.com
 ([fe80::44be:d2be:b576:df9b]) by CY4PR1101MB2328.namprd11.prod.outlook.com
 ([fe80::44be:d2be:b576:df9b%6]) with mapi id 15.20.3846.026; Tue, 9 Feb 2021
 11:06:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW9CIWgXulU7v2Ok+njn/tUoPVaao/O/kAgAO7VICAAX1XgIADJ5wAgAghgwA=
Date:   Tue, 9 Feb 2021 11:06:09 +0000
Message-ID: <CY4PR1101MB232892F595111A53803F6DBFC38E9@CY4PR1101MB2328.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 981f1cbd-5f6b-47c9-0562-08d8cceab4d4
x-ms-traffictypediagnostic: CY4PR11MB2021:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB20217BF861A21B4FF289EF62C38E9@CY4PR11MB2021.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +7bXqh0QFAPb9ZhmtIK9dg3LNad4E/ffCiEHANbgNlrkF4Q7VVrA6NOjO1QLXma3TKO9ewxTOkQ1Bl3c4vF5Mze62f195EqPsk51zNrgKF+UgCSbu1kjX2eWbknxk+lBEIGAQGkZMatAeBrLZ4TrGRnZQExO8+qw+Bch8bBbVHzLJWKBDUFWfWxJxHUKf8bQqiOSwqigKC8T6sotyVLxIb3JIR7OLIRJ0lkpiVEoo/GVd9TDWf6EgZizQGFXMfiMLWHFI2ONE+Q1C5E2pray9herS4AR2ZGZ0Oai5xSVORYGMceZ4aRblImhUYA+mI8g5bzmCSTOhlQXPl9CiIx+ESnZF5Mp8WFRm2Wo1+lg/z8zV3nlbN6IA0qbnUin4Awfg2sEEHKCxjLV8NQy8xeL6UdWil+x3mESRk3gekkWo9kWK4fFGJDWKBJ07naeFu0vuoTWzSs2pUKRAHbFNgLqg4S4b0+OGSSHW3cWMQlqm7W+8nOr/a/ha3m/0E8dxZ0JCDln56FozO77JZHIXOH4Yrl+wOC5c1HaHOu/QfcqCmEdksZwOm9dyhMsfjh+QYvNRVaBDi+7zqdV8gwCi239H2sn42tniaL4oUgqPKO8YMI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2328.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(396003)(136003)(66556008)(64756008)(66476007)(55016002)(66446008)(7696005)(2906002)(76116006)(83380400001)(26005)(5660300002)(66946007)(9686003)(478600001)(966005)(71200400001)(6506007)(4326008)(186003)(7416002)(33656002)(8676002)(110136005)(52536014)(316002)(53546011)(86362001)(8936002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TE5iWnFmR0t3MDY4VUo5em04SU1MQmdjZjlRQXFnaVBXcTNoWHpvOFhDbTBj?=
 =?utf-8?B?eFY0MUtwSHRzU3lvVmJxeWhxck9jdlphMG1vMkt0NUtVWUdXWjlRM2VJLzJR?=
 =?utf-8?B?ZTIvdit2Q0x1eDUwWE9zNC9RbFVUQmFpcGNRZXNObENLWXo4RzNqQk92RFA3?=
 =?utf-8?B?cWZVeW9IVjlhQUlRUEx0UWY1T3JkUTZCa3JjRnJVbkZ1anpoVEFpTFZMdThm?=
 =?utf-8?B?QXlTaTJSVFNkb1VjL0lPWlB6UUxqN2hsazgyakpZSVlhaExHMHJEeEN1N2Rn?=
 =?utf-8?B?bjl4aFh2U1JsRW85cHFzeGt2YzVmTjV6NkhtdDZvVGY5TFZMdkhtRmp3K0pw?=
 =?utf-8?B?R3d3WXdZVFJKeFpNVUp4Qkc1V1FzbjRncUNkOGZqZTlTZnQ5K2VxcGFKRWdK?=
 =?utf-8?B?bDR6WmdLRm5IVGFwdkJnODNKbGpPS0NsVWJza3ZYaEtFeTZtUXRyZC9LK0dO?=
 =?utf-8?B?WTAxRmtwM0M0bzM2c2dtYnU4cFZNNlNHWHhnUzZOS0d3Nk4xL3NQSEMzeDhK?=
 =?utf-8?B?SHVKRkFvTnduVjFPcWMwc1MrcGdmcVpaaWFXSXNDSXVGQnUyekMvcTMrb2xy?=
 =?utf-8?B?RmlIOWNkcE9rSVlaWDF4d1A0Ym9kN3JIOG91Y2srdDVPck5lckwydVIrUCti?=
 =?utf-8?B?b2c0UWZNdW9XVWZJTFQ4bGlMQjZyWHhudUppaEdHbkhSd01Wc0owcDhjR3FR?=
 =?utf-8?B?ZWkvWE0vVDBteFloQmdhOFQvNW5Qb1EyMGxPMDY2L2IwRXpsL3Q3WGNqaEZV?=
 =?utf-8?B?MjYrbkZ5SXVkUEtHMDdydzdwUVB0cWdvVFNnR2dURGxUVXFEOXd5NzMvQitx?=
 =?utf-8?B?L294RjR4MWZ3NlpaSDZ0U1NTeGg3eFIxOHgzM25JcVFuKzFzSUFlWm5MVFRW?=
 =?utf-8?B?TzBEejgxTVh4Ym1EOGJsc0VHY0ovMlZIcHFGSWdWZ25QRno3bHpQNFBxaTAw?=
 =?utf-8?B?VzdqcFIzbllTcVhJaWVIQUJRZkV6YjZvYWZRSC92MmE3cmFGYlVpM0F4aTda?=
 =?utf-8?B?V09Oam9EMVBCcnBtSGI0K0d5UkhVSEQ5VSt1WXREenovV1ZwcGg0bzBlZHJk?=
 =?utf-8?B?YkF2cy9TL2xPWFU2b1BwUm0xWG9FMitkZkdJWEhHb09KSTNYL05LSnl1RWhJ?=
 =?utf-8?B?amlCT3JMYUJZV05Iblc5NTY2QkVwT05zVlg0QlIvRnA0ZDlNRGVJS1FzRm5i?=
 =?utf-8?B?R0haTUdpU3F6a0g3MVlFUkFsUEk2TG13YU91ZFF1WElaNEdyWmpWT1J0ZFY1?=
 =?utf-8?B?eXdtS0h5UVY2dkdzbU9EVXhMYlphR1ZraUQ2OWgrT1F5RjVaMzRHclZMbE8r?=
 =?utf-8?B?dGJFQjR1czlZbU4xbjB3cjRhNFN6U3E1eWsrWmd4ajNRTlljNDVyZVk4TmlM?=
 =?utf-8?B?dWdSM2l3TXlMTXJ6T3RTK2x1cGFQZEFtQStwRGs3S25PcjhMWEJwUHh0ZW96?=
 =?utf-8?B?c2xFelZFQnEzZkQrQnpITHBTU2NkNERpRklQd1p1RTcrVFJvRnJhaURnaTZR?=
 =?utf-8?B?VkRxMmhIMnlBMmdpc1ExUmxoNVM1U1BnU2g5U29iQ256UnFFVkdQS245L1p4?=
 =?utf-8?B?d1lzNktKSDVubE9MVGVMaGxXaGZjVjZRTElud1B1czk4enAwZWwxMyt4UGJh?=
 =?utf-8?B?MnQzeE5iRkZSdktmdm15TVkrWjJhUm1xbzNOaGt1WWRVNWFmN3pDbHQ4V01o?=
 =?utf-8?B?K291bkVXV2JjalFuejRPQ3F1eHV4M2Y1K1p2M2hlSTF4dkg2Umx3bW45ZDVM?=
 =?utf-8?Q?Nab/7M1O0byxlgXs3v2zs80Y6mFs6JA/BgGJP1c?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2328.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 981f1cbd-5f6b-47c9-0562-08d8cceab4d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 11:06:09.9593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8CWHEc79S3JDZZ87ygI1hgcmTsj3ILoyiT3oTJYIHNGDJ7cmXjVR2mZQ5PTeCxez4QKEvVu/Z88pmEA3xDsJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2021
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBGZWJydWFyeSA0LCAyMDIxIDI6NTIgUE0NCj4gDQo+ID4gRnJvbTogU2hlbm1pbmcgTHUg
PGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4NCj4gPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAyLCAy
MDIxIDI6NDIgUE0NCj4gPg0KPiA+IE9uIDIwMjEvMi8xIDE1OjU2LCBUaWFuLCBLZXZpbiB3cm90
ZToNCj4gPiA+PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQu
Y29tPg0KPiA+ID4+IFNlbnQ6IFNhdHVyZGF5LCBKYW51YXJ5IDMwLCAyMDIxIDY6NTggQU0NCj4g
PiA+Pg0KPiA+ID4+IE9uIE1vbiwgMjUgSmFuIDIwMjEgMTc6MDM6NTggKzA4MDANCj4gPiA+PiBT
aGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPiB3cm90ZToNCj4gPiA+Pg0KPiA+ID4+
PiBIaSwNCj4gPiA+Pj4NCj4gPiA+Pj4gVGhlIHN0YXRpYyBwaW5uaW5nIGFuZCBtYXBwaW5nIHBy
b2JsZW0gaW4gVkZJTyBhbmQgcG9zc2libGUNCj4gc29sdXRpb25zDQo+ID4gPj4+IGhhdmUgYmVl
biBkaXNjdXNzZWQgYSBsb3QgWzEsIDJdLiBPbmUgb2YgdGhlIHNvbHV0aW9ucyBpcyB0byBhZGQg
SS9PDQo+ID4gPj4+IHBhZ2UgZmF1bHQgc3VwcG9ydCBmb3IgVkZJTyBkZXZpY2VzLiBEaWZmZXJl
bnQgZnJvbSB0aG9zZSByZWxhdGl2ZWx5DQo+ID4gPj4+IGNvbXBsaWNhdGVkIHNvZnR3YXJlIGFw
cHJvYWNoZXMgc3VjaCBhcyBwcmVzZW50aW5nIGEgdklPTU1VIHRoYXQNCj4gPiA+PiBwcm92aWRl
cw0KPiA+ID4+PiB0aGUgRE1BIGJ1ZmZlciBpbmZvcm1hdGlvbiAobWlnaHQgaW5jbHVkZSBwYXJh
LXZpcnR1YWxpemVkDQo+ID4gb3B0aW1pemF0aW9ucyksDQo+ID4gPj4+IElPUEYgbWFpbmx5IGRl
cGVuZHMgb24gdGhlIGhhcmR3YXJlIGZhdWx0aW5nIGNhcGFiaWxpdHksIHN1Y2ggYXMgdGhlDQo+
ID4gUENJZQ0KPiA+ID4+PiBQUkkgZXh0ZW5zaW9uIG9yIEFybSBTTU1VIHN0YWxsIG1vZGVsLiBX
aGF0J3MgbW9yZSwgdGhlIElPUEYNCj4gc3VwcG9ydA0KPiA+IGluDQo+ID4gPj4+IHRoZSBJT01N
VSBkcml2ZXIgaXMgYmVpbmcgaW1wbGVtZW50ZWQgaW4gU1ZBIFszXS4gU28gZG8gd2UNCj4gY29u
c2lkZXIgdG8NCj4gPiA+Pj4gYWRkIElPUEYgc3VwcG9ydCBmb3IgVkZJTyBwYXNzdGhyb3VnaCBi
YXNlZCBvbiB0aGUgSU9QRiBwYXJ0IG9mIFNWQQ0KPiBhdA0KPiA+ID4+PiBwcmVzZW50Pw0KPiA+
ID4+Pg0KPiA+ID4+PiBXZSBoYXZlIGltcGxlbWVudGVkIGEgYmFzaWMgZGVtbyBvbmx5IGZvciBv
bmUgc3RhZ2Ugb2YgdHJhbnNsYXRpb24NCj4gPiAoR1BBDQo+ID4gPj4+IC0+IEhQQSBpbiB2aXJ0
dWFsaXphdGlvbiwgbm90ZSB0aGF0IGl0IGNhbiBiZSBjb25maWd1cmVkIGF0IGVpdGhlciBzdGFn
ZSksDQo+ID4gPj4+IGFuZCB0ZXN0ZWQgb24gSGlzaWxpY29uIEt1bnBlbmc5MjAgYm9hcmQuIFRo
ZSBuZXN0ZWQgbW9kZSBpcyBtb3JlDQo+ID4gPj4gY29tcGxpY2F0ZWQNCj4gPiA+Pj4gc2luY2Ug
VkZJTyBvbmx5IGhhbmRsZXMgdGhlIHNlY29uZCBzdGFnZSBwYWdlIGZhdWx0cyAoc2FtZSBhcyB0
aGUNCj4gbm9uLQ0KPiA+ID4+IG5lc3RlZA0KPiA+ID4+PiBjYXNlKSwgd2hpbGUgdGhlIGZpcnN0
IHN0YWdlIHBhZ2UgZmF1bHRzIG5lZWQgdG8gYmUgZnVydGhlciBkZWxpdmVyZWQgdG8NCj4gPiA+
Pj4gdGhlIGd1ZXN0LCB3aGljaCBpcyBiZWluZyBpbXBsZW1lbnRlZCBpbiBbNF0gb24gQVJNLiBN
eSB0aG91Z2h0IG9uDQo+IHRoaXMNCj4gPiA+Pj4gaXMgdG8gcmVwb3J0IHRoZSBwYWdlIGZhdWx0
cyB0byBWRklPIHJlZ2FyZGxlc3Mgb2YgdGhlIG9jY3VyZWQgc3RhZ2UNCj4gKHRyeQ0KPiA+ID4+
PiB0byBjYXJyeSB0aGUgc3RhZ2UgaW5mb3JtYXRpb24pLCBhbmQgaGFuZGxlIHJlc3BlY3RpdmVs
eSBhY2NvcmRpbmcgdG8NCj4gdGhlDQo+ID4gPj4+IGNvbmZpZ3VyZWQgbW9kZSBpbiBWRklPLiBP
ciB0aGUgSU9NTVUgZHJpdmVyIG1pZ2h0IGV2b2x2ZSB0bw0KPiBzdXBwb3J0DQo+ID4gPj4gbW9y
ZS4uLg0KPiA+ID4+Pg0KPiA+ID4+PiBNaWdodCBUT0RPOg0KPiA+ID4+PiAgLSBPcHRpbWl6ZSB0
aGUgZmF1bHRpbmcgcGF0aCwgYW5kIG1lYXN1cmUgdGhlIHBlcmZvcm1hbmNlIChpdCBtaWdodA0K
PiBzdGlsbA0KPiA+ID4+PiAgICBiZSBhIGJpZyBpc3N1ZSkuDQo+ID4gPj4+ICAtIEFkZCBzdXBw
b3J0IGZvciBQUkkuDQo+ID4gPj4+ICAtIEFkZCBhIE1NVSBub3RpZmllciB0byBhdm9pZCBwaW5u
aW5nLg0KPiA+ID4+PiAgLSBBZGQgc3VwcG9ydCBmb3IgdGhlIG5lc3RlZCBtb2RlLg0KPiA+ID4+
PiAuLi4NCj4gPiA+Pj4NCj4gPiA+Pj4gQW55IGNvbW1lbnRzIGFuZCBzdWdnZXN0aW9ucyBhcmUg
dmVyeSB3ZWxjb21lLiA6LSkNCj4gPiA+Pg0KPiA+ID4+IEkgZXhwZWN0IHBlcmZvcm1hbmNlIHRv
IGJlIHByZXR0eSBiYWQgaGVyZSwgdGhlIGxvb2t1cCBpbnZvbHZlZCBwZXINCj4gPiA+PiBmYXVs
dCBpcyBleGNlc3NpdmUuICBUaGVyZSBhcmUgY2FzZXMgd2hlcmUgYSB1c2VyIGlzIG5vdCBnb2lu
ZyB0byBiZQ0KPiA+ID4+IHdpbGxpbmcgdG8gaGF2ZSBhIHNsb3cgcmFtcCB1cCBvZiBwZXJmb3Jt
YW5jZSBmb3IgdGhlaXIgZGV2aWNlcyBhcyB0aGV5DQo+ID4gPj4gZmF1bHQgaW4gcGFnZXMsIHNv
IHdlIG1pZ2h0IG5lZWQgdG8gY29uc2lkZXJpbmcgbWFraW5nIHRoaXMNCj4gPiA+PiBjb25maWd1
cmFibGUgdGhyb3VnaCB0aGUgdmZpbyBpbnRlcmZhY2UuICBPdXIgcGFnZSBtYXBwaW5nIGFsc28g
b25seQ0KPiA+ID4NCj4gPiA+IFRoZXJlIGlzIGFub3RoZXIgZmFjdG9yIHRvIGJlIGNvbnNpZGVy
ZWQuIFRoZSBwcmVzZW5jZSBvZiBJT01NVV8NCj4gPiA+IERFVl9GRUFUX0lPUEYganVzdCBpbmRp
Y2F0ZXMgdGhlIGRldmljZSBjYXBhYmlsaXR5IG9mIHRyaWdnZXJpbmcgSS9PDQo+ID4gPiBwYWdl
IGZhdWx0IHRocm91Z2ggdGhlIElPTU1VLCBidXQgbm90IGV4YWN0bHkgbWVhbnMgdGhhdCB0aGUg
ZGV2aWNlDQo+ID4gPiBjYW4gdG9sZXJhdGUgSS9PIHBhZ2UgZmF1bHQgZm9yIGFyYml0cmFyeSBE
TUEgcmVxdWVzdHMuDQo+ID4NCj4gPiBZZXMsIHNvIEkgYWRkIGEgaW9wZl9lbmFibGVkIGZpZWxk
IGluIFZGSU8gdG8gaW5kaWNhdGUgdGhlIHdob2xlIHBhdGgNCj4gZmF1bHRpbmcNCj4gPiBjYXBh
YmlsaXR5IGFuZCBzZXQgaXQgdG8gdHJ1ZSBhZnRlciByZWdpc3RlcmluZyBhIFZGSU8gcGFnZSBm
YXVsdCBoYW5kbGVyLg0KPiA+DQo+ID4gPiBJbiByZWFsaXR5LCBtYW55DQo+ID4gPiBkZXZpY2Vz
IGFsbG93IEkvTyBmYXVsdGluZyBvbmx5IGluIHNlbGVjdGl2ZSBjb250ZXh0cy4gSG93ZXZlciwg
dGhlcmUNCj4gPiA+IGlzIG5vIHN0YW5kYXJkIHdheSAoZS5nLiBQQ0lTSUcpIGZvciB0aGUgZGV2
aWNlIHRvIHJlcG9ydCB3aGV0aGVyDQo+ID4gPiBhcmJpdHJhcnkgSS9PIGZhdWx0IGlzIGFsbG93
ZWQuIFRoZW4gd2UgbWF5IGhhdmUgdG8gbWFpbnRhaW4gZGV2aWNlDQo+ID4gPiBzcGVjaWZpYyBr
bm93bGVkZ2UgaW4gc29mdHdhcmUsIGUuZy4gaW4gYW4gb3B0LWluIHRhYmxlIHRvIGxpc3QgZGV2
aWNlcw0KPiA+ID4gd2hpY2ggYWxsb3dzIGFyYml0cmFyeSBmYXVsdHMuIEZvciBkZXZpY2VzIHdo
aWNoIG9ubHkgc3VwcG9ydCBzZWxlY3RpdmUNCj4gPiA+IGZhdWx0aW5nLCBhIG1lZGlhdG9yIChl
aXRoZXIgdGhyb3VnaCB2ZW5kb3IgZXh0ZW5zaW9ucyBvbiB2ZmlvLXBjaS1jb3JlDQo+ID4gPiBv
ciBhIG1kZXYgd3JhcHBlcikgbWlnaHQgYmUgbmVjZXNzYXJ5IHRvIGhlbHAgbG9jayBkb3duIG5v
bi1mYXVsdGFibGUNCj4gPiA+IG1hcHBpbmdzIGFuZCB0aGVuIGVuYWJsZSBmYXVsdGluZyBvbiB0
aGUgcmVzdCBtYXBwaW5ncy4NCj4gPg0KPiA+IEZvciBkZXZpY2VzIHdoaWNoIG9ubHkgc3VwcG9y
dCBzZWxlY3RpdmUgZmF1bHRpbmcsIHRoZXkgY291bGQgdGVsbCBpdCB0byB0aGUNCj4gPiBJT01N
VSBkcml2ZXIgYW5kIGxldCBpdCBmaWx0ZXIgb3V0IG5vbi1mYXVsdGFibGUgZmF1bHRzPyBEbyBJ
IGdldCBpdCB3cm9uZz8NCj4gDQo+IE5vdCBleGFjdGx5IHRvIElPTU1VIGRyaXZlci4gVGhlcmUg
aXMgYWxyZWFkeSBhIHZmaW9fcGluX3BhZ2VzKCkgZm9yDQo+IHNlbGVjdGl2ZWx5IHBhZ2UtcGlu
bmluZy4gVGhlIG1hdHRlciBpcyB0aGF0ICd0aGV5JyBpbXBseSBzb21lIGRldmljZQ0KPiBzcGVj
aWZpYyBsb2dpYyB0byBkZWNpZGUgd2hpY2ggcGFnZXMgbXVzdCBiZSBwaW5uZWQgYW5kIHN1Y2gg
a25vd2xlZGdlDQo+IGlzIG91dHNpZGUgb2YgVkZJTy4NCj4gDQo+IEZyb20gZW5hYmxpbmcgcC5v
LnYgd2UgY291bGQgcG9zc2libHkgZG8gaXQgaW4gcGhhc2VkIGFwcHJvYWNoLiBGaXJzdA0KPiBo
YW5kbGVzIGRldmljZXMgd2hpY2ggdG9sZXJhdGUgYXJiaXRyYXJ5IERNQSBmYXVsdHMsIGFuZCB0
aGVuIGV4dGVuZHMNCj4gdG8gZGV2aWNlcyB3aXRoIHNlbGVjdGl2ZS1mYXVsdGluZy4gVGhlIGZv
cm1lciBpcyBzaW1wbGVyLCBidXQgd2l0aCBvbmUNCj4gbWFpbiBvcGVuIHdoZXRoZXIgd2Ugd2Fu
dCB0byBtYWludGFpbiBzdWNoIGRldmljZSBJRHMgaW4gYSBzdGF0aWMNCj4gdGFibGUgaW4gVkZJ
TyBvciByZWx5IG9uIHNvbWUgaGludHMgZnJvbSBvdGhlciBjb21wb25lbnRzIChlLmcuIFBGDQo+
IGRyaXZlciBpbiBWRiBhc3NpZ25tZW50IGNhc2UpLiBMZXQncyBzZWUgaG93IEFsZXggdGhpbmtz
IGFib3V0IGl0Lg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+PiBncm93cyBoZXJlLCBzaG91bGQgbWFw
cGluZ3MgZXhwaXJlIG9yIGRvIHdlIG5lZWQgYSBsZWFzdCByZWNlbnRseQ0KPiA+ID4+IG1hcHBl
ZCB0cmFja2VyIHRvIGF2b2lkIGV4Y2VlZGluZyB0aGUgdXNlcidzIGxvY2tlZCBtZW1vcnkgbGlt
aXQ/DQo+IEhvdw0KPiA+ID4+IGRvZXMgYSB1c2VyIGtub3cgd2hhdCB0byBzZXQgZm9yIGEgbG9j
a2VkIG1lbW9yeSBsaW1pdD8gIFRoZSBiZWhhdmlvcg0KPiA+ID4+IGhlcmUgd291bGQgbGVhZCB0
byBjYXNlcyB3aGVyZSBhbiBpZGxlIHN5c3RlbSBtaWdodCBiZSBvaywgYnV0IGFzDQo+IHNvb24N
Cj4gPiA+PiBhcyBsb2FkIGluY3JlYXNlcyB3aXRoIG1vcmUgaW5mbGlnaHQgRE1BLCB3ZSBzdGFy
dCBzZWVpbmcNCj4gPiA+PiAidW5wcmVkaWN0YWJsZSIgSS9PIGZhdWx0cyBmcm9tIHRoZSB1c2Vy
IHBlcnNwZWN0aXZlLiAgU2VlbXMgbGlrZSB0aGVyZQ0KPiA+ID4+IGFyZSBsb3RzIG9mIG91dHN0
YW5kaW5nIGNvbnNpZGVyYXRpb25zIGFuZCBJJ2QgYWxzbyBsaWtlIHRvIGhlYXIgZnJvbQ0KPiA+
ID4+IHRoZSBTVkEgZm9sa3MgYWJvdXQgaG93IHRoaXMgbWVzaGVzIHdpdGggdGhlaXIgd29yay4g
IFRoYW5rcywNCj4gPiA+Pg0KPiA+ID4NCj4gPiA+IFRoZSBtYWluIG92ZXJsYXAgYmV0d2VlbiB0
aGlzIGZlYXR1cmUgYW5kIFNWQSBpcyB0aGUgSU9QRiByZXBvcnRpbmcNCj4gPiA+IGZyYW1ld29y
aywgd2hpY2ggY3VycmVudGx5IHN0aWxsIGhhcyBnYXAgdG8gc3VwcG9ydCBib3RoIGluIG5lc3Rl
ZA0KPiA+ID4gbW9kZSwgYXMgZGlzY3Vzc2VkIGhlcmU6DQo+ID4gPg0KPiA+ID4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtYWNwaS9ZQWF4am1KVytaTXZyaGFjQG15cmljYS8NCj4gPiA+
DQo+ID4gPiBPbmNlIHRoYXQgZ2FwIGlzIHJlc29sdmVkIGluIHRoZSBmdXR1cmUsIHRoZSBWRklP
IGZhdWx0IGhhbmRsZXIganVzdA0KPiA+ID4gYWRvcHRzIGRpZmZlcmVudCBhY3Rpb25zIGFjY29y
ZGluZyB0byB0aGUgZmF1bHQtbGV2ZWw6IDFzdCBsZXZlbCBmYXVsdHMNCj4gPiA+IGFyZSBmb3J3
YXJkZWQgdG8gdXNlcnNwYWNlIHRocnUgdGhlIHZTVkEgcGF0aCB3aGlsZSAybmQtbGV2ZWwgZmF1
bHRzDQo+ID4gPiBhcmUgZml4ZWQgKG9yIHdhcm5lZCBpZiBub3QgaW50ZW5kZWQpIGJ5IFZGSU8g
aXRzZWxmIHRocnUgdGhlIElPTU1VDQo+ID4gPiBtYXBwaW5nIGludGVyZmFjZS4NCj4gPg0KPiA+
IEkgdW5kZXJzdGFuZCB3aGF0IHlvdSBtZWFuIGlzOg0KPiA+IEZyb20gdGhlIHBlcnNwZWN0aXZl
IG9mIFZGSU8sIGZpcnN0LCB3ZSBuZWVkIHRvIHNldCBGRUFUX0lPUEYsIGFuZCB0aGVuDQo+ID4g
cmVnc3RlciBpdHMNCj4gPiBvd24gaGFuZGxlciB3aXRoIGEgZmxhZyB0byBpbmRpY2F0ZSBGTEFU
IG9yIE5FU1RFRCBhbmQgd2hpY2ggbGV2ZWwgaXMNCj4gPiBjb25jZXJuZWQsDQo+ID4gdGh1cyB0
aGUgVkZJTyBoYW5kbGVyIGNhbiBoYW5kbGUgdGhlIHBhZ2UgZmF1bHRzIGRpcmVjdGx5IGFjY29y
ZGluZyB0byB0aGUNCj4gPiBjYXJyaWVkDQo+ID4gbGV2ZWwgaW5mb3JtYXRpb24uDQo+ID4NCj4g
PiBJcyB0aGVyZSBhbnkgcGxhbiBmb3IgZXZvbHZpbmcoaW1wbGVtZW50aW5nKSB0aGUgSU9NTVUg
ZHJpdmVyIHRvDQo+IHN1cHBvcnQNCj4gPiB0aGlzPyBPcg0KPiA+IGNvdWxkIHdlIGhlbHAgdGhp
cz8gIDotKQ0KPiA+DQo+IA0KPiBZZXMsIGl0J3MgaW4gcGxhbiBidXQganVzdCBub3QgaGFwcGVu
ZWQgeWV0LiBXZSBhcmUgc3RpbGwgZm9jdXNpbmcgb24gZ3Vlc3QNCj4gU1ZBIHBhcnQgdGh1cyBv
bmx5IHRoZSAxc3QtbGV2ZWwgcGFnZSBmYXVsdCAoK1lpL0phY29iKS4gSXQncyBhbHdheXMgd2Vs
Y29tZWQNCj4gdG8gY29sbGFib3JhdGUvaGVscCBpZiB5b3UgaGF2ZSB0aW1lLiA/Pw0KDQp5ZWFo
LCBJIHNhdyBFcmljJ3MgcGFnZSBmYXVsdCBzdXBwb3J0IHBhdGNoIGlzIGxpc3RlZCBhcyByZWZl
cmVuY2UuIEJUVy4NCm9uZSB0aGluZyBuZWVkcyB0byBjbGFyaWZ5LCBjdXJyZW50bHkgb25seSBv
bmUgaW9tbXUgZmF1bHQgaGFuZGxlciBzdXBwb3J0ZWQNCmZvciBhIHNpbmdsZSBkZXZpY2UuIFNv
IGZvciB0aGUgZmF1bHQgaGFuZGxlciBhZGRlZCBpbiB0aGlzIHNlcmllcywgaXQgc2hvdWxkDQpi
ZSBjb25zb2xpZGF0ZWQgd2l0aCB0aGUgb25lIGFkZGVkIGluIEVyaWMncyBzZXJpZXMuDQoNClJl
Z2FyZHMsDQpZaSBMaXUNCg0KPiBUaGFua3MNCj4gS2V2aW4NCg==
