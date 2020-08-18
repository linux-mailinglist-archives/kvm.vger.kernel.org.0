Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE224820B
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgHRJjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:39:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18877 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgHRJjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 05:39:35 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ba1660000>; Tue, 18 Aug 2020 02:37:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 02:39:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 02:39:34 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 09:39:28 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 09:39:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M54+LmnxCWbQa2VUqmR0kW08mN1MQL3WX8nzi3gF/ENHDv9uJgHV+ZE8gEqBVI8jPKYJ0Hw7woo5PHhGpJqt95cY+poQwRsf8G7ZUWaOHwitRTcYADeXyMvuPeaH56nSGnsYNIqsutxJ6LrLraBwAiE1l51+8B7Z6hvR8uDeUyKdBA4k7oG0s9ABJEOvjGCOj03R/O/zNn0Uc6o96b9PKUBkTLEUHzzoi4NrSI3iHTjNuBPCKu3TNOb9avHHDrgW394Z2j+YblgA4OyYMKCY49HVhNxBs0FiEyN1tCsZA4KK03spQ0DVEap6B0UglPuSqZIp6t1l6HdRkI/HTPuqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ks1lS7zRWDdVhiunhS911675AynRk4CQRx1Dt8G4XZc=;
 b=SVUB8Ij26eOsk4McVWhTGdozzqtiU2IP8ZtjQRkIT42gjSVGRNhgqcNRhw/HnEdRhtSu0+p5ZjWhLr2FXdxDZSlQVydEUWiuAiSV+JDmZSCue2w2uZr6Ej2hH1qNUhmZgh3Nvq4ogM2zpbQSrDFJELzikHLW9WqkMXeZv627M9gGBMLznNbjF7gS7ezDTrrXm/ZvsMEmXj8MfhRbcMeosJ1UfENPxDPwIhnxcFbjF/A9+kC9angnoSzCsHAXXQ9y6rkCa7IInUGlzZ6hq8yL1wMxT/JprrWFp0Fj1kUFtWPO8zsEGpmOl21dOOrxEB3d0DSG25SX85krqnzRnkQxIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.28; Tue, 18 Aug
 2020 09:39:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%8]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 09:39:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "xin-ran.wang@intel.com" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "shaohe.feng@intel.com" <shaohe.feng@intel.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "Parav Pandit" <parav@mellanox.com>,
        "jian-feng.ding@intel.com" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "hejie.xu@intel.com" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "smooney@redhat.com" <smooney@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: RE: device compatibility interface for live migration with assigned
 devices
Thread-Topic: device compatibility interface for live migration with assigned
 devices
Thread-Index: AQHWaxahY2KLNHS+kEetIX0F/1UfDqkw/oyAgAR+pQCAAaChgIAGKisAgABceICAAAHJgIAABBYAgAAFswCAAAB4cA==
Date:   Tue, 18 Aug 2020 09:39:24 +0000
Message-ID: <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200805075647.GB2177@nanopsycho>
        <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
        <20200805093338.GC30485@joy-OptiPlex-7040>      <20200805105319.GF2177@nanopsycho>
        <20200810074631.GA29059@joy-OptiPlex-7040>
        <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
        <20200814051601.GD15344@joy-OptiPlex-7040>
        <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
        <20200818085527.GB20215@redhat.com>
        <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
        <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
In-Reply-To: <20200818113652.5d81a392.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a44451ea-2074-4871-6492-08d8435a97ef
x-ms-traffictypediagnostic: BY5PR12MB4068:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4068061FB84134D4C98B545FDC5C0@BY5PR12MB4068.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FIDZAqcBWEZkQbvOU4f9RKMZKIfH+T/KUedaMwwRp7Yt0ulFKjqc1e6dQSXoKF6jJ89AjA1FVBHJZGqd4bgzJfVjG/5HkDSiGFDBJN8sYpkuraeO33pleMwg8nGGUtR4Ow3aSQjbb9ta0wjedKt6UY/E1jjIEANu9qpPHQxO52sEiHF1LhLlvkrQV4iuWShfkXmJfFBxi7+k+gevVnUCRhFlOd3XPOcjU+pkSG64YfPx3K0rushVBtGe4dkjnL2el0L+7i2Mpwm9+0IaQFZOcWOuJlkQt6mgtrh4h3VA5pjF/JWUQrlD9514uFXKE3EYg5Kt97x+pjtQy2LcDIjx/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(316002)(8936002)(2906002)(71200400001)(6506007)(8676002)(7416002)(86362001)(26005)(83380400001)(52536014)(5660300002)(55236004)(53546011)(110136005)(76116006)(55016002)(66476007)(64756008)(66556008)(4326008)(66946007)(33656002)(66446008)(478600001)(7696005)(9686003)(186003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FuPy2l8I7Z5WsgpqKz3goxdz6H1SuqtGp91sXCVBskzRBaVvhprW3XWM7goSwxumR5YXSy2+X3hsEvkDetyBJA1ghIULn+4kCnVo/lU3D/WQdJGS7zirmAMIfZge209hGkqZrIC7xIsmH0Pjnn2LpZCzNAs/YpVQcS64Qmv5htXYN+7C5hFx03/3fRxzBhPYOejdlCxWz9vAyLM6iOAAhZq9K16ERSRSCh+7aPrxCqhfFoguegRLOxUaKq1EskzV3O4S/diGFAZlvCGUFkGTsGzPp2EbAO3xe6y/v+e8uyGE/P2pxFIABj1BG/plTb4EPkiEG//esCl9cxZUHSkzL+Y+CVTN7/9mJwPjuXhhBdVXFVV/WwBfqeycgQ2RYNbaK/uCVKsNFmDeENtm14Yr/gbgi0t4ANP1akHsoPmZstU3JZB1lUGqysFcNlbJbds3cTV/9iPE4GIQswII52Kl5Sq1W0IhmNRalCpRTPvhFJkgLm9j56sDd+n5K0IBlFpIgp3AcSjSAAEZEDKVdhe5gJFNU2Qh/Bv3s66sqAsQZdPwtePuktsjdiOcHMoWgp/kkVAOjRH7CBDMymNMQp2LdLDxmnrDGYRQbnazhGKWO6oj1pD9xhqhgL1pslhq51beXKHVRo/s86H1BfIKOqmIAA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44451ea-2074-4871-6492-08d8435a97ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2020 09:39:24.6159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gR3WF7pYPA5jLW81cRhA1cUf4mz9SVov+Q9u+GRcu0danZCiAZVYq6QGspIKJHHJyG9YEXcb4nULiaTTky59vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597743462; bh=ks1lS7zRWDdVhiunhS911675AynRk4CQRx1Dt8G4XZc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Sjp6Jq+/R8Cc3rXP2yOcmiiYKt2fVxxGZPrDBqqV/snNHdnigdLrb30D6HqHbibaE
         x9x8l0Z95AmLoiExzGw6ueHV47dE0EwZIS0wKc9PVb/VxRFa4MKmNGPEeSjNawlCKV
         B7fMQvnbgKM1hB/sg8kdJ7EwLThYured0akoN0xfjMr1tHy+MUVxx/3i03XMT3rW6D
         DO7vYbeWF/zOLvSzr6274VKq1NVBGxYTr1xw0gLi+lZON6hgPy19ptGPR9cSFbHOKD
         6EdNT0x+aGClLhu+wd8YjsoebuE3ICIoCrH7EeWUkXcbXGwFuVceIq+t/yqrm5o6mx
         9NPzlsobG/tFg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQ29ybmVsaWEsDQoNCj4gRnJvbTogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+
DQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxOCwgMjAyMCAzOjA3IFBNDQo+IFRvOiBEYW5pZWwg
UC4gQmVycmFuZ8OpIDxiZXJyYW5nZUByZWRoYXQuY29tPg0KPiBDYzogSmFzb24gV2FuZyA8amFz
b3dhbmdAcmVkaGF0LmNvbT47IFlhbiBaaGFvDQo+IDx5YW4ueS56aGFvQGludGVsLmNvbT47IGt2
bUB2Z2VyLmtlcm5lbC5vcmc7IGxpYnZpci1saXN0QHJlZGhhdC5jb207DQo+IHFlbXUtZGV2ZWxA
bm9uZ251Lm9yZzsgS2lydGkgV2Fua2hlZGUgPGt3YW5raGVkZUBudmlkaWEuY29tPjsNCj4gZWF1
Z2VyQHJlZGhhdC5jb207IHhpbi1yYW4ud2FuZ0BpbnRlbC5jb207IGNvcmJldEBsd24ubmV0OyBv
cGVuc3RhY2stDQo+IGRpc2N1c3NAbGlzdHMub3BlbnN0YWNrLm9yZzsgc2hhb2hlLmZlbmdAaW50
ZWwuY29tOyBrZXZpbi50aWFuQGludGVsLmNvbTsNCj4gUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxs
YW5veC5jb20+OyBqaWFuLWZlbmcuZGluZ0BpbnRlbC5jb207DQo+IGRnaWxiZXJ0QHJlZGhhdC5j
b207IHpoZW55dXdAbGludXguaW50ZWwuY29tOyBoZWppZS54dUBpbnRlbC5jb207DQo+IGJhby55
dW1lbmdAenRlLmNvbS5jbjsgQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbT47DQo+IGVza3VsdGV0QHJlZGhhdC5jb207IHNtb29uZXlAcmVkaGF0LmNvbTsgaW50ZWwt
Z3Z0LQ0KPiBkZXZAbGlzdHMuZnJlZWRlc2t0b3Aub3JnOyBKaXJpIFBpcmtvIDxqaXJpQG1lbGxh
bm94LmNvbT47DQo+IGRpbmVjaGluQHJlZGhhdC5jb207IGRldmVsQG92aXJ0Lm9yZw0KPiBTdWJq
ZWN0OiBSZTogZGV2aWNlIGNvbXBhdGliaWxpdHkgaW50ZXJmYWNlIGZvciBsaXZlIG1pZ3JhdGlv
biB3aXRoIGFzc2lnbmVkDQo+IGRldmljZXMNCj4gDQo+IE9uIFR1ZSwgMTggQXVnIDIwMjAgMTA6
MTY6MjggKzAxMDANCj4gRGFuaWVsIFAuIEJlcnJhbmfDqSA8YmVycmFuZ2VAcmVkaGF0LmNvbT4g
d3JvdGU6DQo+IA0KPiA+IE9uIFR1ZSwgQXVnIDE4LCAyMDIwIGF0IDA1OjAxOjUxUE0gKzA4MDAs
IEphc29uIFdhbmcgd3JvdGU6DQo+ID4gPiAgICBPbiAyMDIwLzgvMTgg5LiL5Y2INDo1NSwgRGFu
aWVsIFAuIEJlcnJhbmfDqSB3cm90ZToNCj4gPiA+DQo+ID4gPiAgT24gVHVlLCBBdWcgMTgsIDIw
MjAgYXQgMTE6MjQ6MzBBTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiA+DQo+ID4gPiAg
T24gMjAyMC84LzE0IOS4i+WNiDE6MTYsIFlhbiBaaGFvIHdyb3RlOg0KPiA+ID4NCj4gPiA+ICBP
biBUaHUsIEF1ZyAxMywgMjAyMCBhdCAxMjoyNDo1MFBNICswODAwLCBKYXNvbiBXYW5nIHdyb3Rl
Og0KPiA+ID4NCj4gPiA+ICBPbiAyMDIwLzgvMTAg5LiL5Y2IMzo0NiwgWWFuIFpoYW8gd3JvdGU6
DQo+ID4NCj4gPiA+ICB3ZSBhY3R1YWxseSBjYW4gYWxzbyByZXRyaWV2ZSB0aGUgc2FtZSBpbmZv
cm1hdGlvbiB0aHJvdWdoIHN5c2ZzLA0KPiA+ID4gLmUuZw0KPiA+ID4NCj4gPiA+ICB8LSBbcGF0
aCB0byBkZXZpY2VdDQo+ID4gPiAgICAgfC0tLSBtaWdyYXRpb24NCj4gPiA+ICAgICB8ICAgICB8
LS0tIHNlbGYNCj4gPiA+ICAgICB8ICAgICB8ICAgfC0tLWRldmljZV9hcGkNCj4gPiA+ICAgICB8
ICAgIHwgICB8LS0tbWRldl90eXBlDQo+ID4gPiAgICAgfCAgICB8ICAgfC0tLXNvZnR3YXJlX3Zl
cnNpb24NCj4gPiA+ICAgICB8ICAgIHwgICB8LS0tZGV2aWNlX2lkDQo+ID4gPiAgICAgfCAgICB8
ICAgfC0tLWFnZ3JlZ2F0b3INCj4gPiA+ICAgICB8ICAgICB8LS0tIGNvbXBhdGlibGUNCj4gPiA+
ICAgICB8ICAgICB8ICAgfC0tLWRldmljZV9hcGkNCj4gPiA+ICAgICB8ICAgIHwgICB8LS0tbWRl
dl90eXBlDQo+ID4gPiAgICAgfCAgICB8ICAgfC0tLXNvZnR3YXJlX3ZlcnNpb24NCj4gPiA+ICAg
ICB8ICAgIHwgICB8LS0tZGV2aWNlX2lkDQo+ID4gPiAgICAgfCAgICB8ICAgfC0tLWFnZ3JlZ2F0
b3INCj4gPiA+DQo+ID4gPg0KPiA+ID4gIFllcyBidXQ6DQo+ID4gPg0KPiA+ID4gIC0gWW91IG5l
ZWQgb25lIGZpbGUgcGVyIGF0dHJpYnV0ZSAob25lIHN5c2NhbGwgZm9yIG9uZSBhdHRyaWJ1dGUp
DQo+ID4gPiAgLSBBdHRyaWJ1dGUgaXMgY291cGxlZCB3aXRoIGtvYmplY3QNCj4gDQo+IElzIHRo
YXQgcmVhbGx5IHRoYXQgYmFkPyBZb3UgaGF2ZSB0aGUgZGV2aWNlIHdpdGggYW4gZW1iZWRkZWQg
a29iamVjdA0KPiBhbnl3YXksIGFuZCB5b3UgY2FuIGp1c3QgcHV0IHRoaW5ncyBpbnRvIGFuIGF0
dHJpYnV0ZSBncm91cD8NCj4gDQo+IFtBbHNvLCBJIHRoaW5rIHRoYXQgc2VsZi9jb21wYXRpYmxl
IHNwbGl0IGluIHRoZSBleGFtcGxlIG1ha2VzIHRoaW5ncw0KPiBuZWVkbGVzc2x5IGNvbXBsZXgu
IFNob3VsZG4ndCBzZW1hbnRpYyB2ZXJzaW9uaW5nIGFuZCBtYXRjaGluZyBhbHJlYWR5DQo+IGNv
dmVyIG5lYXJseSBldmVyeXRoaW5nPyBJIHdvdWxkIGV4cGVjdCB2ZXJ5IGZldyBjYXNlcyB0aGF0
IGFyZSBtb3JlDQo+IGNvbXBsZXggdGhhbiB0aGF0LiBNYXliZSB0aGUgYWdncmVnYXRpb24gc3R1
ZmYsIGJ1dCBJIGRvbid0IHRoaW5rIHdlIG5lZWQNCj4gdGhhdCBzZWxmL2NvbXBhdGlibGUgc3Bs
aXQgZm9yIHRoYXQsIGVpdGhlci5dDQo+IA0KPiA+ID4NCj4gPiA+ICBBbGwgb2YgYWJvdmUgc2Vl
bXMgdW5uZWNlc3NhcnkuDQo+ID4gPg0KPiA+ID4gIEFub3RoZXIgcG9pbnQsIGFzIHdlIGRpc2N1
c3NlZCBpbiBhbm90aGVyIHRocmVhZCwgaXQncyByZWFsbHkgaGFyZA0KPiA+ID4gdG8gbWFrZSAg
c3VyZSB0aGUgYWJvdmUgQVBJIHdvcmsgZm9yIGFsbCB0eXBlcyBvZiBkZXZpY2VzIGFuZA0KPiA+
ID4gZnJhbWV3b3Jrcy4gU28gaGF2aW5nIGEgIHZlbmRvciBzcGVjaWZpYyBBUEkgbG9va3MgbXVj
aCBiZXR0ZXIuDQo+ID4gPg0KPiA+ID4gIEZyb20gdGhlIFBPViBvZiB1c2Vyc3BhY2UgbWdtdCBh
cHBzIGRvaW5nIGRldmljZSBjb21wYXQgY2hlY2tpbmcgLw0KPiA+ID4gbWlncmF0aW9uLCAgd2Ug
Y2VydGFpbmx5IGRvIE5PVCB3YW50IHRvIHVzZSBkaWZmZXJlbnQgdmVuZG9yDQo+ID4gPiBzcGVj
aWZpYyBBUElzLiBXZSB3YW50IHRvICBoYXZlIGFuIEFQSSB0aGF0IGNhbiBiZSB1c2VkIC8gY29u
dHJvbGxlZCBpbiBhDQo+IHN0YW5kYXJkIG1hbm5lciBhY3Jvc3MgdmVuZG9ycy4NCj4gPiA+DQo+
ID4gPiAgICBZZXMsIGJ1dCBpdCBjb3VsZCBiZSBoYXJkLiBFLmcgdkRQQSB3aWxsIGNob3NlIHRv
IHVzZSBkZXZsaW5rICh0aGVyZSdzIGENCj4gPiA+ICAgIGxvbmcgZGViYXRlIG9uIHN5c2ZzIHZz
IGRldmxpbmspLiBTbyBpZiB3ZSBnbyB3aXRoIHN5c2ZzLCBhdCBsZWFzdCB0d28NCj4gPiA+ICAg
IEFQSXMgbmVlZHMgdG8gYmUgc3VwcG9ydGVkIC4uLg0KPiA+DQo+ID4gTkIsIEkgd2FzIG5vdCBx
dWVzdGlvbmluZyBkZXZsaW5rIHZzIHN5c2ZzIGRpcmVjdGx5LiBJZiBkZXZsaW5rIGlzDQo+ID4g
cmVsYXRlZCB0byBuZXRsaW5rLCBJIGNhbid0IHNheSBJJ20gZW50aHVzaWFzdGljIGFzIElNS0Ug
c3lzZnMgaXMNCj4gPiBlYXNpZXIgdG8gZGVhbCB3aXRoLiBJIGRvbid0IGtub3cgZW5vdWdoIGFi
b3V0IGRldmxpbmsgdG8gaGF2ZSBtdWNoIG9mIGFuDQo+IG9waW5pb24gdGhvdWdoLg0KPiA+IFRo
ZSBrZXkgcG9pbnQgd2FzIHRoYXQgSSBkb24ndCB3YW50IHRoZSB1c2Vyc3BhY2UgQVBJcyB3ZSBu
ZWVkIHRvIGRlYWwNCj4gPiB3aXRoIHRvIGJlIHZlbmRvciBzcGVjaWZpYy4NCj4gDQo+IEZyb20g
d2hhdCBJJ3ZlIHNlZW4gb2YgZGV2bGluaywgaXQgc2VlbXMgcXVpdGUgbmljZTsgYnV0IEkgdW5k
ZXJzdGFuZCB3aHkNCj4gc3lzZnMgbWlnaHQgYmUgZWFzaWVyIHRvIGRlYWwgd2l0aCAoZXNwZWNp
YWxseSBhcyB0aGVyZSdzIGxpa2VseSBhbHJlYWR5IGEgbG90IG9mDQo+IGNvZGUgdXNpbmcgaXQu
KQ0KPiANCj4gSSB1bmRlcnN0YW5kIHRoYXQgc29tZSB1c2VycyB3b3VsZCBsaWtlIGRldmxpbmsg
YmVjYXVzZSBpdCBpcyBhbHJlYWR5IHdpZGVseQ0KPiB1c2VkIGZvciBuZXR3b3JrIGRyaXZlcnMg
KGFuZCBzb21lIG90aGVycyksIGJ1dCBJIGRvbid0IHRoaW5rIHRoZSBtYWpvcml0eSBvZg0KPiBk
ZXZpY2VzIHVzZWQgd2l0aCB2ZmlvIGFyZSBuZXR3b3JrIChhbHRob3VnaCBjZXJ0YWlubHkgYSBs
b3Qgb2YgdGhlbSBhcmUuKQ0KPiANCj4gPg0KPiA+IFdoYXQgSSBjYXJlIGFib3V0IGlzIHRoYXQg
d2UgaGF2ZSBhICpzdGFuZGFyZCogdXNlcnNwYWNlIEFQSSBmb3INCj4gPiBwZXJmb3JtaW5nIGRl
dmljZSBjb21wYXRpYmlsaXR5IGNoZWNraW5nIC8gc3RhdGUgbWlncmF0aW9uLCBmb3IgdXNlIGJ5
DQo+ID4gUUVNVS9saWJ2aXJ0LyBPcGVuU3RhY2ssIHN1Y2ggdGhhdCB3ZSBjYW4gd3JpdGUgY29k
ZSB3aXRob3V0IGNvdW50bGVzcw0KPiA+IHZlbmRvciBzcGVjaWZpYyBjb2RlIHBhdGhzLg0KPiA+
DQo+ID4gSWYgdGhlcmUgaXMgdmVuZG9yIHNwZWNpZmljIHN0dWZmIG9uIHRoZSBzaWRlLCB0aGF0
J3MgZmluZSBhcyB3ZSBjYW4NCj4gPiBpZ25vcmUgdGhhdCwgYnV0IHRoZSBjb3JlIGZ1bmN0aW9u
YWxpdHkgZm9yIGRldmljZSBjb21wYXQgLyBtaWdyYXRpb24NCj4gPiBuZWVkcyB0byBiZSBzdGFu
ZGFyZGl6ZWQuDQo+IA0KPiBUbyBzdW1tYXJpemU6DQo+IC0gY2hvb3NlIG9uZSBvZiBzeXNmcyBv
ciBkZXZsaW5rDQo+IC0gaGF2ZSBhIGNvbW1vbiBpbnRlcmZhY2UsIHdpdGggYSBzdGFuZGFyZGl6
ZWQgd2F5IHRvIGFkZA0KPiAgIHZlbmRvci1zcGVjaWZpYyBhdHRyaWJ1dGVzDQo+ID8NCg0KUGxl
YXNlIHJlZmVyIHRvIG15IHByZXZpb3VzIGVtYWlsIHdoaWNoIGhhcyBtb3JlIGV4YW1wbGUgYW5k
IGRldGFpbHMuDQo=
