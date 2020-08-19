Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3F249461
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 07:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgHSF1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 01:27:08 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7453 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgHSF1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 01:27:07 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3cb81d0000>; Tue, 18 Aug 2020 22:26:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 22:27:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 22:27:07 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 05:27:03 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Aug 2020 05:27:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU+JdrIEWlR5fKV7MP8aucNuH1mBWIJSfoCGSQ11jQ4bKz1+1BaPo1yh96VDsVQegby6OMZJ7DWdIC8ppi+0ZU8jdxMATghblb4wt8Mp0e4pLV/Gm15QGiKMsVhfrshYIrgB8KnxYKoaXWqRZso3DBO8l+BOr6o5bxXXYWRBlAwtgPKSf0/PzPacH+s7UdymfOip11YRU1wrDW7mUUg6+g1gImHr1c93KnCEbGyK3a5BVXOD/aQTdTI78G5LzRJn+VbaenFXnfoxiuSLXZYt3N77RzyRGp+rfI3tj7c/is0qk5sxnHtuKCgQjk23rg24TFHqkgYEhh9YKHtLsjXe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JGlPk/Cggpo62zoK0DFn7WKAfO3iwyIzFlmIZ8VdFQ=;
 b=F6UbLOI5nuU8kKLBdSsz9DLA90UNVE7QnTHGzKV4tSCT/MLJq0MEFy+L+0HPGv1ufCO1Mm0cndzm9+WXeytiP55IsXr6OHTWFG+TcOdsTAerc4MjGoxO4aqL/s3ooQLwty1VXRCwvrGpY5AfwCucnjH24by9DypJyAfJrRxNHuYREcOGVWAuAULAisEkuq/o/wpPoeUf4FAHj7EqElAAdWojXL/zrbiFf9Dym5P11WFjKgZkibQ8as4Ju2pRNOupjwddB8bavbWLlCWiFCOXFV/9Mb8nTA52Uzr1t2QmKYCyfIWMRNbgMS2qX5ApvBxDv26ytv164hEOILIGZL+/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3559.namprd12.prod.outlook.com (2603:10b6:a03:d9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Wed, 19 Aug
 2020 05:26:58 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%8]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 05:26:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>,
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
        Parav Pandit <parav@mellanox.com>,
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
        Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: RE: device compatibility interface for live migration with assigned
 devices
Thread-Topic: device compatibility interface for live migration with assigned
 devices
Thread-Index: AQHWaxahY2KLNHS+kEetIX0F/1UfDqkw/oyAgAR+pQCAAaChgIAGKisAgABceICAAAHJgIAAAlhQgAEm94CAAChrMA==
Date:   Wed, 19 Aug 2020 05:26:58 +0000
Message-ID: <BY5PR12MB4322CD6B3C697B6F1807ECBFDC5D0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <BY5PR12MB43222059335C96F7B050CFDCDC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <934c8d2a-a34e-6c68-0e53-5de2a8f49d19@redhat.com>
In-Reply-To: <934c8d2a-a34e-6c68-0e53-5de2a8f49d19@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bebd922-5edd-4385-c364-08d844007eaf
x-ms-traffictypediagnostic: BYAPR12MB3559:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB355933DD67C25ED54CD45D6DDC5D0@BYAPR12MB3559.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Crwnx/icE3ZogKQ/ahp3ySoCJVutDpPRS9BHruvKr1FbLz8tDxUJgUc+csbDewH4utqs37x0G7Bfx7wKhDiQlRwOSwniCJBmEoQyoX0sGRsZLbTyjC0ke/mcsSmGWupTR8eSvC9A9sMiLFxlHs9Hgl4SKqPTN6Q6WETo2WHpK5sI8o2fMxf5FLvXyBIda9CeAvsC7EDdFBVuJbbFoWjgmURmJ7R9vmNHqi5vVakNUalUEvOIZUR9KWzJ/ZtcrGNG6C8xaT46EXdGyuaBGPasnmRAuzqvZq8RD5ye7BJkgzyw3dBcLSXqf8IJUFAyIDJr2BALEaXvDzwjeuRjKep0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(9686003)(83380400001)(55016002)(5660300002)(7416002)(54906003)(4326008)(52536014)(33656002)(478600001)(8936002)(8676002)(7696005)(110136005)(2906002)(64756008)(66946007)(86362001)(55236004)(66476007)(66446008)(76116006)(26005)(66556008)(316002)(71200400001)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: s6vKVmRvo2x98BMQID0vDq93el1q11m7G3JdWyGG/GpJ261AKrPp2sTEQNJf0oklWnwOl9vcUyjzIRTpE4h1An1+UzRyi4SYneBODyAfDMdxG77Xap1bfRkIm4wvm4opALIi1zWh4k9aBXmrt930RuF2ClI5v8Dwm3ectLd+zZf6nR244HZ6kPIs1x0x6gfawcj/ubAuX/yLGG0l9FaarBIUsQz5RtGLiaIYp3phJpIjlYZsvWY6U23Wq6iMVGJXGkDVKaMBkueGgUBJHe4JeskihELEdvUP5EVrsJE1ID6Ub63Wq9A8jS7aC+kcW/ytCSW2KFscapSl6YfDbXbfMLHWMV7EavD9XL/6gFOvAoe+j4G/DuGbFSk4XLBISK8G5C4M6FeBiUT0bzbgkPNh012Q1l/5yDnGbIEDbFkDwHJmjiMn2OhuINNHxAkhPKipSnaXsYKeHXH7yvExjm2qq/qEyVoGtC5ToWL4u+5A+w//9qpkopV0C2t6px+vCh0F3oBVVVFiR5cBwGU4ZuDnoXq3AJHrkXcU6LiHKjLQgYyfDpP0x2cCWJhRodPTFVJNdUiy1ZPZ52za3Npq1X+LdQrAwIkC4xATIDMAhs0CZywpypsLWOMu3ReWZ0lKLDrvv4W24ZKSa3ANcyHxzA9V0Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bebd922-5edd-4385-c364-08d844007eaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 05:26:58.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vGe1BUDMiXY+XMW+FEromnhjsQcVkm7uJUBmV0wdwS5rbkoH0bqTv6OVL1yYnb0Pcq/oadavHdPZlHtae0EGyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3559
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597814813; bh=7JGlPk/Cggpo62zoK0DFn7WKAfO3iwyIzFlmIZ8VdFQ=;
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
        b=fRkMFitmb1SlJIlZ3te+Bo4vBK25ievykoOlxA/oEgtpWxlfC5RE/7h8CahFfEn0r
         Kj5oG1CthEtk4AgKEbvLXIw6R7EpmTh4fGhOqoqguFKqsbVwniGgdPuZhl1Yt8+vC0
         tPo931QzMP1oiGZi607tLtwoaGpk52NwExEbiEny+7Y5Vg/dJXNad9b2W+FTo4EYYj
         kr5Z4zAkOPdrwtetpcPxbPmW9fm+wufZoEuY4e6Iqcm9vvzSlacp6iIyV3h8Hx22X6
         ytknr+Dp09eH3ms5ghZQXUiS9hzakhIUvkjoPU8dpQkFAxf0FDElPKmVT5FQCNjgp9
         yS6vfN+SWLdTQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBBdWd1c3QgMTksIDIwMjAgODoxNiBBTQ0KDQoNCj4gT24gMjAyMC84LzE4IOS4i+WN
iDU6MzIsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBIaSBKYXNvbiwNCj4gPg0KPiA+IEZyb206
IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgQXVn
dXN0IDE4LCAyMDIwIDI6MzIgUE0NCj4gPg0KPiA+DQo+ID4gT24gMjAyMC84LzE4IOS4i+WNiDQ6
NTUsIERhbmllbCBQLiBCZXJyYW5nw6kgd3JvdGU6DQo+ID4gT24gVHVlLCBBdWcgMTgsIDIwMjAg
YXQgMTE6MjQ6MzBBTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiBPbiAyMDIwLzgvMTQg
5LiL5Y2IMToxNiwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gT24gVGh1LCBBdWcgMTMsIDIwMjAgYXQg
MTI6MjQ6NTBQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiBPbiAyMDIwLzgvMTAg5LiL
5Y2IMzo0NiwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gZHJpdmVyIGlzIGl0IGhhbmRsZWQgYnk/DQo+
ID4gSXQgbG9va3MgdGhhdCB0aGUgZGV2bGluayBpcyBmb3IgbmV0d29yayBkZXZpY2Ugc3BlY2lm
aWMsIGFuZCBpbg0KPiA+IGRldmxpbmsuaCwgaXQgc2F5cyBpbmNsdWRlL3VhcGkvbGludXgvZGV2
bGluay5oIC0gTmV0d29yayBwaHlzaWNhbA0KPiA+IGRldmljZSBOZXRsaW5rIGludGVyZmFjZSwg
QWN0dWFsbHkgbm90LCBJIHRoaW5rIHRoZXJlIHVzZWQgdG8gaGF2ZQ0KPiA+IHNvbWUgZGlzY3Vz
c2lvbiBsYXN0IHllYXIgYW5kIHRoZSBjb25jbHVzaW9uIGlzIHRvIHJlbW92ZSB0aGlzDQo+ID4g
Y29tbWVudC4NCj4gPg0KPiA+IFsuLi5dDQo+ID4NCj4gPj4gWWVzLCBidXQgaXQgY291bGQgYmUg
aGFyZC4gRS5nIHZEUEEgd2lsbCBjaG9zZSB0byB1c2UgZGV2bGluayAodGhlcmUncyBhIGxvbmcN
Cj4gZGViYXRlIG9uIHN5c2ZzIHZzIGRldmxpbmspLiBTbyBpZiB3ZSBnbyB3aXRoIHN5c2ZzLCBh
dCBsZWFzdCB0d28gQVBJcyBuZWVkcyB0byBiZQ0KPiBzdXBwb3J0ZWQgLi4uDQo+ID4gV2UgaGFk
IGludGVybmFsIGRpc2N1c3Npb24gYW5kIHByb3Bvc2FsIG9uIHRoaXMgdG9waWMuDQo+ID4gSSB3
YW50ZWQgRWxpIENvaGVuIHRvIGJlIGJhY2sgZnJvbSB2YWNhdGlvbiBvbiBXZWQgOC8xOSwgYnV0
IHNpbmNlIHRoaXMgaXMNCj4gYWN0aXZlIGRpc2N1c3Npb24gcmlnaHQgbm93LCBJIHdpbGwgc2hh
cmUgdGhlIHRob3VnaHRzIGFueXdheS4NCj4gPg0KPiA+IEhlcmUgYXJlIHRoZSBpbml0aWFsIHJv
dW5kIG9mIHRob3VnaHRzIGFuZCBwcm9wb3NhbC4NCj4gPg0KPiA+IFVzZXIgcmVxdWlyZW1lbnRz
Og0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IDEuIFVzZXIgbWlnaHQgd2Fu
dCB0byBjcmVhdGUgb25lIG9yIG1vcmUgdmRwYSBkZXZpY2VzIHBlciBQQ0kgUEYvVkYvU0YuDQo+
ID4gMi4gVXNlciBtaWdodCB3YW50IHRvIGNyZWF0ZSBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZXMg
b2YgdHlwZSBuZXQvYmxrIG9yDQo+IG90aGVyIHR5cGUuDQo+ID4gMy4gVXNlciBuZWVkcyB0byBs
b29rIGFuZCBkdW1wIGF0IHRoZSBoZWFsdGggb2YgdGhlIHF1ZXVlcyBmb3IgZGVidWcgcHVycG9z
ZS4NCj4gPiA0LiBEdXJpbmcgdmRwYSBuZXQgZGV2aWNlIGNyZWF0aW9uIHRpbWUsIHVzZXIgbWF5
IGhhdmUgdG8gcHJvdmlkZSBhIE1BQw0KPiBhZGRyZXNzIGFuZC9vciBWTEFOLg0KPiA+IDUuIFVz
ZXIgc2hvdWxkIGJlIGFibGUgdG8gc2V0L3F1ZXJ5IHNvbWUgb2YgdGhlIGF0dHJpYnV0ZXMgZm9y
DQo+ID4gZGVidWcvY29tcGF0aWJpbGl0eSBjaGVjayA2LiBXaGVuIHVzZXIgd2FudHMgdG8gY3Jl
YXRlIHZkcGEgZGV2aWNlLCBpdCBuZWVkcw0KPiB0byBrbm93IHdoaWNoIGRldmljZSBzdXBwb3J0
cyBjcmVhdGlvbi4NCj4gPiA3LiBVc2VyIHNob3VsZCBiZSBhYmxlIHRvIHNlZSB0aGUgcXVldWUg
c3RhdGlzdGljcyBvZiBkb29yYmVsbHMsIHdxZXMNCj4gPiBldGMgcmVnYXJkbGVzcyBvZiBjbGFz
cyB0eXBlDQo+IA0KPiANCj4gTm90ZSB0aGF0IHdxZXMgaXMgcHJvYmFibHkgbm90IHNvbWV0aGlu
ZyBjb21tb24gaW4gYWxsIG9mIHRoZSB2ZW5kb3JzLg0KWWVzLiBJIHZpcnRxIGRlc2NyaXB0b3Jz
IHN0YXRzIGlzIGJldHRlciB0byBtb25pdG9yIHRoZSB2aXJ0cXVldWVzLg0KDQo+IA0KPiANCj4g
Pg0KPiA+IFRvIGFkZHJlc3MgYWJvdmUgcmVxdWlyZW1lbnRzLCB0aGVyZSBpcyBhIG5lZWQgb2Yg
dmVuZG9yIGFnbm9zdGljIHRvb2wsIHNvDQo+IHRoYXQgdXNlciBjYW4gY3JlYXRlL2NvbmZpZy9k
ZWxldGUgdmRwYSBkZXZpY2UocykgcmVnYXJkbGVzcyBvZiB0aGUgdmVuZG9yLg0KPiA+DQo+ID4g
SGVuY2UsDQo+ID4gV2Ugc2hvdWxkIGhhdmUgYSB0b29sIHRoYXQgbGV0cyB1c2VyIGRvIGl0Lg0K
PiA+DQo+ID4gRXhhbXBsZXM6DQo+ID4gLS0tLS0tLS0tLS0tLQ0KPiA+IChhKSBMaXN0IHBhcmVu
dCBkZXZpY2VzIHdoaWNoIHN1cHBvcnRzIGNyZWF0aW5nIHZkcGEgZGV2aWNlcy4NCj4gPiBJdCBh
bHNvIHNob3dzIHdoaWNoIGNsYXNzIHR5cGVzIHN1cHBvcnRlZCBieSB0aGlzIHBhcmVudCBkZXZp
Y2UuDQo+ID4gSW4gYmVsb3cgY29tbWFuZCB0d28gcGFyZW50IGRldmljZXMgc3VwcG9ydCB2ZHBh
IGRldmljZSBjcmVhdGlvbi4NCj4gPiBGaXJzdCBpcyBQQ0kgVkYgd2hvc2UgYmRmIGlzIDAzLjAw
OjUuDQo+ID4gU2Vjb25kIGlzIFBDSSBTRiB3aG9zZSBuYW1lIGlzIG1seDVfc2YuMQ0KPiA+DQo+
ID4gJCB2ZHBhIGxpc3QgcGQNCj4gDQo+IA0KPiBXaGF0IGRpZCAicGQiIG1lYW4/DQo+IA0KUGFy
ZW50IGRldmljZSB3aGljaCBzdXBwb3J0IGNyZWF0aW9uIG9mIG9uZSBvciBtb3JlIHZkcGEgZGV2
aWNlcy4NCkluIGEgc3lzdGVtIHRoZXJlIGNhbiBiZSBtdWx0aXBsZSBwYXJlbnQgZGV2aWNlcyB3
aGljaCBtYXkgYmUgc3VwcG9ydCB2ZHBhIGNyZWF0aW9uLg0KVXNlciBzaG91bGQgYmUgYWJsZSB0
byBrbm93IHdoaWNoIGRldmljZXMgc3VwcG9ydCBpdCwgYW5kIHdoZW4gdXNlciBjcmVhdGVzIGEg
dmRwYSBkZXZpY2UsIGl0IHRlbGxzIHdoaWNoIHBhcmVudCBkZXZpY2UgdG8gdXNlIGZvciBjcmVh
dGlvbiBhcyBkb25lIGluIGJlbG93IHZkcGEgZGV2IGFkZCBleGFtcGxlLg0KPiANCj4gPiBwY2kv
MDAwMDowMy4wMDo1DQo+ID4gICAgY2xhc3Nfc3VwcG9ydHMNCj4gPiAgICAgIG5ldCB2ZHBhDQo+
ID4gdmlydGJ1cy9tbHg1X3NmLjENCj4gDQo+IA0KPiBTbyBjcmVhdGluZyBtbHg1X3NmLjEgaXMg
dGhlIGNoYXJnZSBvZiBkZXZsaW5rPw0KPiANClllcy4NCkJ1dCBoZXJlIHZkcGEgdG9vbCBpcyB3
b3JraW5nIGF0IHRoZSBwYXJlbnQgZGV2aWNlIGlkZW50aWZpZXIge2J1cytuYW1lfSBpbnN0ZWFk
IG9mIGRldmxpbmsgaWRlbnRpZmllci4NCg0KDQo+IA0KPiA+ICAgIGNsYXNzX3N1cHBvcnRzDQo+
ID4gICAgICBuZXQNCj4gPg0KPiA+IChiKSBOb3cgYWRkIGEgdmRwYSBkZXZpY2UgYW5kIHNob3cg
dGhlIGRldmljZS4NCj4gPiAkIHZkcGEgZGV2IGFkZCBwY2kvMDAwMDowMy4wMDo1IHR5cGUgbmV0
DQo+IA0KPiANCj4gU28gaWYgeW91IHdhbnQgdG8gY3JlYXRlIGRldmljZXMgdHlwZXMgb3RoZXIg
dGhhbiB2ZHBhIG9uDQo+IHBjaS8wMDAwOjAzLjAwOjUgaXQgbmVlZHMgc29tZSBzeW5jaHJvbml6
YXRpb24gd2l0aCBkZXZsaW5rPw0KUGxlYXNlIHJlZmVyIHRvIEZBUS0xLCAgYSBuZXcgdG9vbCBp
cyBub3QgbGlua2VkIHRvIGRldmxpbmsgYmVjYXVzZSB2ZHBhIHdpbGwgZXZvbHZlIHdpdGggdGlt
ZSBhbmQgZGV2bGluayB3aWxsIGZhbGwgc2hvcnQuDQpTbyBubywgaXQgZG9lc24ndCBuZWVkIGFu
eSBzeW5jaHJvbml6YXRpb24gd2l0aCBkZXZsaW5rLg0KQXMgbG9uZyBhcyBwYXJlbnQgZGV2aWNl
IGV4aXN0LCB1c2VyIGNhbiBjcmVhdGUgaXQuDQpBbGwgc3luY2hyb25pemF0aW9uIHdpbGwgYmUg
d2l0aGluIGRyaXZlcnMvdmRwYS92ZHBhLmMNClRoaXMgdXNlciBpbnRlcmZhY2UgaXMgZXhwb3Nl
ZCB2aWEgbmV3IG5ldGxpbmsgZmFtaWx5IGJ5IGRvaW5nIGdlbmxfcmVnaXN0ZXJfZmFtaWx5KCkg
d2l0aCBuZXcgbmFtZSAidmRwYSIgaW4gZHJpdmVycy92ZHBhL3ZkcGEuYy4NCg0KPiANCj4gDQo+
ID4gJCB2ZHBhIGRldiBzaG93DQo+ID4gdmRwYTBAcGNpLzAwMDA6MDMuMDA6NSB0eXBlIG5ldCBz
dGF0ZSBpbmFjdGl2ZSBtYXhxdWV1ZXMgOCBjdXJxdWV1ZXMgNA0KPiA+DQo+ID4gKGMpIHZkcGEg
ZGV2IHNob3cgZmVhdHVyZXMgdmRwYTANCj4gPiBpb21tdSBwbGF0Zm9ybQ0KPiA+IHZlcnNpb24g
MQ0KPiA+DQo+ID4gKGQpIGR1bXAgdmRwYSBzdGF0aXN0aWNzDQo+ID4gJCB2ZHBhIGRldiBzdGF0
cyBzaG93IHZkcGEwDQo+ID4ga2lja2Rvb3JiZWxscyAxMA0KPiA+IHdxZXMgMTAwDQo+ID4NCj4g
PiAoZSkgTm93IGRlbGV0ZSBhIHZkcGEgZGV2aWNlIHByZXZpb3VzbHkgY3JlYXRlZC4NCj4gPiAk
IHZkcGEgZGV2IGRlbCB2ZHBhMA0KPiA+DQo+ID4gRGVzaWduIG92ZXJ2aWV3Og0KPiA+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gMS4gQWJvdmUgZXhhbXBsZSB0b29sIHJ1bnMgb3ZlciBu
ZXRsaW5rIHNvY2tldCBpbnRlcmZhY2UuDQo+ID4gMi4gVGhpcyBlbmFibGVzIHVzZXJzIHRvIHJl
dHVybiBtZWFuaW5nZnVsIGVycm9yIHN0cmluZ3MgaW4gYWRkaXRpb24gdG8gY29kZSBzbw0KPiB0
aGF0IHVzZXIgY2FuIGJlIG1vcmUgaW5mb3JtZWQuDQo+ID4gT2Z0ZW4gdGhpcyBpcyBtaXNzaW5n
IGluIGlvY3RsKCkvY29uZmlnZnMvc3lzZnMgaW50ZXJmYWNlcy4NCj4gPiAzLiBUaGlzIHRvb2wg
b3ZlciBuZXRsaW5rIGVuYWJsZXMgc3lzY2FsbGVyIHRlc3RzIHRvIGJlIG1vcmUgdXNhYmxlIGxp
a2Ugb3RoZXINCj4gc3Vic3lzdGVtcyB0byBrZWVwIGtlcm5lbCByb2J1c3QNCj4gPiA0LiBUaGlz
IHByb3ZpZGVzIHZlbmRvciBhZ25vc3RpYyB2aWV3IG9mIGFsbCB2ZHBhIGNhcGFibGUgcGFyZW50
IGFuZCB2ZHBhDQo+IGRldmljZXMuDQo+ID4NCj4gPiA1LiBFYWNoIGRyaXZlciB3aGljaCBzdXBw
b3J0cyB2ZHBhIGRldmljZSBjcmVhdGlvbiwgcmVnaXN0ZXJzIHRoZSBwYXJlbnQgZGV2aWNlDQo+
IGFsb25nIHdpdGggc3VwcG9ydGVkIGNsYXNzZXMuDQo+ID4NCj4gPiBGQVFzOg0KPiA+IC0tLS0t
LS0tDQo+ID4gMS4gV2h5IG5vdCB1c2luZyBkZXZsaW5rPw0KPiA+IEFuczogQmVjYXVzZSBhcyB2
ZHBhIGVjaG8gc3lzdGVtIGdyb3dzLCBkZXZsaW5rIHdpbGwgZmFsbCBzaG9ydCBvZiBleHRlbmRp
bmcNCj4gdmRwYSBzcGVjaWZpYyBwYXJhbXMsIGF0dHJpYnV0ZXMsIHN0YXRzLg0KPiANCj4gDQo+
IFRoaXMgc2hvdWxkIGJlIGZpbmUgYnV0IGl0J3Mgc3RpbGwgbm90IGNsZWFyIHRvIG1lIHRoZSBk
aWZmZXJlbmNlDQo+IGJldHdlZW4gYSB2ZHBhIG5ldGxpbmsgYW5kIGEgdmRwYSBvYmplY3QgaW4g
ZGV2bGluay4NCj4NClRoZSBkaWZmZXJlbmNlIGlzIGEgdmRwYSBzcGVjaWZpYyB0b29sIHdvcmsg
YXQgdGhlIHBhcmVudCBkZXZpY2UgbGV2ZWwuDQpJdCBpcyBsaWtlbHkgbW9yZSBhcHByb3ByaWF0
ZSB0byBiZWNhdXNlIGl0IGNhbiBzZWxmLWNvbnRhaW4gZXZlcnl0aGluZyBuZWVkZWQgdG8gY3Jl
YXRlL2RlbGV0ZSBkZXZpY2VzLCB2aWV3L3NldCBmZWF0dXJlcywgc3RhdHMuDQpUcnlpbmcgdG8g
cHV0IHRoYXQgaW4gZGV2bGluayB3aWxsIGZhbGwgc2hvcnQgYXMgZGV2bGluayBkb2VzbuKAmXQg
aGF2ZSB2ZHBhIGRlZmluaXRpb25zLg0KVHlwaWNhbGx5IHdoZW4gYSBjbGFzcy9kZXZpY2Ugc3Vi
c3lzdGVtIGdyb3dzLCBpdHMgb3duIHRvb2wgaXMgd2lzZXIgbGlrZSBpcHJvdXRlMi9pcCwgaXBy
b3V0ZTIvdGMsIGlwcm91dGUyL3JkbWEuDQo=
