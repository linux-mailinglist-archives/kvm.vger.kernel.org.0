Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221FE2481F3
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHRJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:33:04 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17211 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgHRJdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 05:33:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ba0130000>; Tue, 18 Aug 2020 02:32:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 02:33:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 02:33:01 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 09:32:57 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 09:32:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDQmAtmb6l4QM+yqfDuCkIMR6TthSkqoP1zMQr2eRJONW0X6ly+2ZzN25Bn3aUktgl9CskkXQWRUzu9o0jLJhZOlGFlOFvXnP8/6UWq3Lx8WzS8kovywb3a/I0MnP+S17VGaa+xafr7FkfhYcOkT5ZgBW6n9Sd0hZvWXVuIjT9Xd0y3aLjqhLRZtfebJSIInzsI3mfqEpjYz7qSNilwHiocu+cRqtqbgZM3UFt6XuVAMkCEHmWqNBv7Pfczb2DUqKtQt1TaEG7UC9/2h8uLdLoqrtQZLtOjaFgGLAfgisNTtk2mS2u+SBfIsanQ50qgFLKYeuf+E5rs1AN/3Wo+Q+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCwN+MP5vwTY0MX1XataMpmjF4QWCoBUKEQ7o+E7qSo=;
 b=BOHX2X2TCg6aADnr5YWIUfKciRyd0pFjJHZXgR13yuowkpSEQ+0pbjs6xZFSBYJn0mNjLYchzP7H2j6lxQNg2vuu9TeLKU6uvBRxJy9R6gvAMuX/qrplBqqJCDWdaSjGnWeE46jsDIY6JHnc1qrDrVpYJvGDWkxOiC2jHYh0PCkpxb/HyqJAEIMIzQakpCNLixIkVDVv3E/pl6HZiobAhF5txVu7EUZzBcsn4OenOB81THSOJR9OkHbnLkAgsLNm7+4g6a2PmcFNR0MRgDdnxyC2nNOHoQSc6L4vyIWbl3fN8CuBUc7wqmTh2PBgvdjwTpOokMwGSYcsDnSdu7cWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Tue, 18 Aug
 2020 09:32:56 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%8]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 09:32:55 +0000
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
        Cornelia Huck <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: RE: device compatibility interface for live migration with assigned
 devices
Thread-Topic: device compatibility interface for live migration with assigned
 devices
Thread-Index: AQHWaxahY2KLNHS+kEetIX0F/1UfDqkw/oyAgAR+pQCAAaChgIAGKisAgABceICAAAHJgIAAAlhQ
Date:   Tue, 18 Aug 2020 09:32:55 +0000
Message-ID: <BY5PR12MB43222059335C96F7B050CFDCDC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
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
In-Reply-To: <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69929b2d-a67e-4d92-23cb-08d84359b01d
x-ms-traffictypediagnostic: BY5PR12MB4084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40840A10D6787B3BEBEBE574DC5C0@BY5PR12MB4084.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: djg17ZqqtvjmJQWQeOU2ak+n9sn5l5NIsQIHF+O0qtCgDgfwtkfi6GO1UTSzsaX2VvWyTjMpmYlucTbWq+sRfPDIYy2E41nEJODPN8FXCkc/tJtNMQyfeob+ad3CYKFD9Bm7zJTUlBY25tDIOYhN5Nku3W+mFgCfarX0jGvOi9lgkJ8G2v3YFlVaPzajGHObAoXwLqUHtDxz+UV0oQXwGadIPytZHf8G6HisVzgZGCb0oxuXrPLTTNoXuA4XbprqWzcciobd6Uxqpb9Xl8v9cvfIS8NBJWDLKSnkzjo28i0hfpNMAP48PxPMm4zhUGcBy24mbSF2eqTxLKSHIscFsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(64756008)(66446008)(66556008)(7416002)(26005)(66476007)(8676002)(9686003)(66946007)(55016002)(2906002)(186003)(76116006)(5660300002)(316002)(55236004)(86362001)(8936002)(478600001)(6506007)(52536014)(71200400001)(83380400001)(110136005)(4326008)(54906003)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rgN5a2hev42CJBdjiY+3IirIdvirkSuGsTJROzEFyI4r30YPUyhKMzBIIIiSO35x5zQwxVSIoURvAouSJerIkqloF/KCrf3E8+/aUxNiVPGmEAh8enE0ZtKt2mkLgbz8w1+xa4er1qLLZDdWKih5GY/AgJr2NR+/42u4WzUfh3B9kg8coadaxjNSR+5DtD16KOEO1Ou3/KHaaQ3p0WgU6dtSxw3uw4IJ/6rn6PdSrnb6+1cABGO62QtdWGhFsr9XdqdnGCT6MHZeyE76i+EG1+3Anx1jn6i11Xdgiyno6C+/tecaAC8U0L+j812gTicrDbGPFT4uJdZOkhyRAc+Q4jIiTw8p5Yt76ak4jPguhkxTX8w/3mHdzs92JObx0Hv7xdOpJo0Y6yG4pObOHgSP7A/lVxNHYtnLP881tEeYEhW4mCP+IaxqponMJIOUrpJwDgDTztatCAcK9qQWXqZs9sf8MOhU6tqv92bBB0955R4T42xsUpiNwVsMoCdK4Raa/ROmESK943Z8VNkJs2e9GnzuV6h3dg2FrWUcjInj65KoO8PBhobNbMj4Fv/1ql1FzM9LGp+TchX1YavbKznL2HFL82Rl5F9VFUtJTt9bVLfVgtOhASZ/QLI5Oo+o0lgTZ6RlIubCWZ7qW07Vmf3ZoQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69929b2d-a67e-4d92-23cb-08d84359b01d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2020 09:32:55.6455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k1t5x/fAcSVdWegJDNAn5D2o9oRAihlJqE42/dbeWDv3X6W3HiKDrK6wV/SiSLR8Peb1F9JaZYhiqOfkSfj+8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597743123; bh=nCwN+MP5vwTY0MX1XataMpmjF4QWCoBUKEQ7o+E7qSo=;
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
        b=BF3HCKKxowZEap8LTaUXcK5qf1YFEonxkR3RsBjk0mzdO3s2kYg3kVOpITzR+4oRL
         +HlIRy0Mex4+6OMGBAipvjf1GaICCWPLCA3iHN2FqkuQQGug+V2ac14jqSapgIJ3Wh
         4bR+gHtBnnRBkA8gJapI1WqaOcAK/PmYWEsT/EPDg4Qnn6JlJPkdJY1dvIiR1bzOP7
         1sNNiHH3J24q70/broFtAy/n2qSIYgvRsikgf/9tJwzVvYdDjwfO2rHc1xYIkSLnRR
         M6A1S9VWHrVn5royN4sLPuEOBiT1AKdYKaaevQ8A7E7oQvM4hbO4fLXWt9Yhk354aB
         FC17ROcDrALaw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSmFzb24sDQoNCkZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IA0KU2Vu
dDogVHVlc2RheSwgQXVndXN0IDE4LCAyMDIwIDI6MzIgUE0NCg0KDQpPbiAyMDIwLzgvMTgg5LiL
5Y2INDo1NSwgRGFuaWVsIFAuIEJlcnJhbmfDqSB3cm90ZToNCk9uIFR1ZSwgQXVnIDE4LCAyMDIw
IGF0IDExOjI0OjMwQU0gKzA4MDAsIEphc29uIFdhbmcgd3JvdGU6DQpPbiAyMDIwLzgvMTQg5LiL
5Y2IMToxNiwgWWFuIFpoYW8gd3JvdGU6DQpPbiBUaHUsIEF1ZyAxMywgMjAyMCBhdCAxMjoyNDo1
MFBNICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KT24gMjAyMC84LzEwIOS4i+WNiDM6NDYsIFlh
biBaaGFvIHdyb3RlOg0KZHJpdmVyIGlzIGl0IGhhbmRsZWQgYnk/DQpJdCBsb29rcyB0aGF0IHRo
ZSBkZXZsaW5rIGlzIGZvciBuZXR3b3JrIGRldmljZSBzcGVjaWZpYywgYW5kIGluDQpkZXZsaW5r
LmgsIGl0IHNheXMNCmluY2x1ZGUvdWFwaS9saW51eC9kZXZsaW5rLmggLSBOZXR3b3JrIHBoeXNp
Y2FsIGRldmljZSBOZXRsaW5rDQppbnRlcmZhY2UsDQpBY3R1YWxseSBub3QsIEkgdGhpbmsgdGhl
cmUgdXNlZCB0byBoYXZlIHNvbWUgZGlzY3Vzc2lvbiBsYXN0IHllYXIgYW5kIHRoZQ0KY29uY2x1
c2lvbiBpcyB0byByZW1vdmUgdGhpcyBjb21tZW50Lg0KDQpbLi4uXQ0KDQo+IFllcywgYnV0IGl0
IGNvdWxkIGJlIGhhcmQuIEUuZyB2RFBBIHdpbGwgY2hvc2UgdG8gdXNlIGRldmxpbmsgKHRoZXJl
J3MgYSBsb25nIGRlYmF0ZSBvbiBzeXNmcyB2cyBkZXZsaW5rKS4gU28gaWYgd2UgZ28gd2l0aCBz
eXNmcywgYXQgbGVhc3QgdHdvIEFQSXMgbmVlZHMgdG8gYmUgc3VwcG9ydGVkIC4uLg0KDQpXZSBo
YWQgaW50ZXJuYWwgZGlzY3Vzc2lvbiBhbmQgcHJvcG9zYWwgb24gdGhpcyB0b3BpYy4NCkkgd2Fu
dGVkIEVsaSBDb2hlbiB0byBiZSBiYWNrIGZyb20gdmFjYXRpb24gb24gV2VkIDgvMTksIGJ1dCBz
aW5jZSB0aGlzIGlzIGFjdGl2ZSBkaXNjdXNzaW9uIHJpZ2h0IG5vdywgSSB3aWxsIHNoYXJlIHRo
ZSB0aG91Z2h0cyBhbnl3YXkuDQoNCkhlcmUgYXJlIHRoZSBpbml0aWFsIHJvdW5kIG9mIHRob3Vn
aHRzIGFuZCBwcm9wb3NhbC4NCg0KVXNlciByZXF1aXJlbWVudHM6DQotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCjEuIFVzZXIgbWlnaHQgd2FudCB0byBjcmVhdGUgb25lIG9yIG1vcmUgdmRw
YSBkZXZpY2VzIHBlciBQQ0kgUEYvVkYvU0YuDQoyLiBVc2VyIG1pZ2h0IHdhbnQgdG8gY3JlYXRl
IG9uZSBvciBtb3JlIHZkcGEgZGV2aWNlcyBvZiB0eXBlIG5ldC9ibGsgb3Igb3RoZXIgdHlwZS4N
CjMuIFVzZXIgbmVlZHMgdG8gbG9vayBhbmQgZHVtcCBhdCB0aGUgaGVhbHRoIG9mIHRoZSBxdWV1
ZXMgZm9yIGRlYnVnIHB1cnBvc2UuDQo0LiBEdXJpbmcgdmRwYSBuZXQgZGV2aWNlIGNyZWF0aW9u
IHRpbWUsIHVzZXIgbWF5IGhhdmUgdG8gcHJvdmlkZSBhIE1BQyBhZGRyZXNzIGFuZC9vciBWTEFO
Lg0KNS4gVXNlciBzaG91bGQgYmUgYWJsZSB0byBzZXQvcXVlcnkgc29tZSBvZiB0aGUgYXR0cmli
dXRlcyBmb3IgZGVidWcvY29tcGF0aWJpbGl0eSBjaGVjaw0KNi4gV2hlbiB1c2VyIHdhbnRzIHRv
IGNyZWF0ZSB2ZHBhIGRldmljZSwgaXQgbmVlZHMgdG8ga25vdyB3aGljaCBkZXZpY2Ugc3VwcG9y
dHMgY3JlYXRpb24uDQo3LiBVc2VyIHNob3VsZCBiZSBhYmxlIHRvIHNlZSB0aGUgcXVldWUgc3Rh
dGlzdGljcyBvZiBkb29yYmVsbHMsIHdxZXMgZXRjIHJlZ2FyZGxlc3Mgb2YgY2xhc3MgdHlwZQ0K
DQpUbyBhZGRyZXNzIGFib3ZlIHJlcXVpcmVtZW50cywgdGhlcmUgaXMgYSBuZWVkIG9mIHZlbmRv
ciBhZ25vc3RpYyB0b29sLCBzbyB0aGF0IHVzZXIgY2FuIGNyZWF0ZS9jb25maWcvZGVsZXRlIHZk
cGEgZGV2aWNlKHMpIHJlZ2FyZGxlc3Mgb2YgdGhlIHZlbmRvci4NCg0KSGVuY2UsDQpXZSBzaG91
bGQgaGF2ZSBhIHRvb2wgdGhhdCBsZXRzIHVzZXIgZG8gaXQuDQoNCkV4YW1wbGVzOg0KLS0tLS0t
LS0tLS0tLQ0KKGEpIExpc3QgcGFyZW50IGRldmljZXMgd2hpY2ggc3VwcG9ydHMgY3JlYXRpbmcg
dmRwYSBkZXZpY2VzLg0KSXQgYWxzbyBzaG93cyB3aGljaCBjbGFzcyB0eXBlcyBzdXBwb3J0ZWQg
YnkgdGhpcyBwYXJlbnQgZGV2aWNlLg0KSW4gYmVsb3cgY29tbWFuZCB0d28gcGFyZW50IGRldmlj
ZXMgc3VwcG9ydCB2ZHBhIGRldmljZSBjcmVhdGlvbi4NCkZpcnN0IGlzIFBDSSBWRiB3aG9zZSBi
ZGYgaXMgMDMuMDA6NS4NClNlY29uZCBpcyBQQ0kgU0Ygd2hvc2UgbmFtZSBpcyBtbHg1X3NmLjEN
Cg0KJCB2ZHBhIGxpc3QgcGQNCnBjaS8wMDAwOjAzLjAwOjUNCiAgY2xhc3Nfc3VwcG9ydHMNCiAg
ICBuZXQgdmRwYQ0KdmlydGJ1cy9tbHg1X3NmLjENCiAgY2xhc3Nfc3VwcG9ydHMNCiAgICBuZXQN
Cg0KKGIpIE5vdyBhZGQgYSB2ZHBhIGRldmljZSBhbmQgc2hvdyB0aGUgZGV2aWNlLg0KJCB2ZHBh
IGRldiBhZGQgcGNpLzAwMDA6MDMuMDA6NSB0eXBlIG5ldA0KJCB2ZHBhIGRldiBzaG93DQp2ZHBh
MEBwY2kvMDAwMDowMy4wMDo1IHR5cGUgbmV0IHN0YXRlIGluYWN0aXZlIG1heHF1ZXVlcyA4IGN1
cnF1ZXVlcyA0DQoNCihjKSB2ZHBhIGRldiBzaG93IGZlYXR1cmVzIHZkcGEwDQppb21tdSBwbGF0
Zm9ybQ0KdmVyc2lvbiAxDQoNCihkKSBkdW1wIHZkcGEgc3RhdGlzdGljcw0KJCB2ZHBhIGRldiBz
dGF0cyBzaG93IHZkcGEwDQpraWNrZG9vcmJlbGxzIDEwDQp3cWVzIDEwMA0KDQooZSkgTm93IGRl
bGV0ZSBhIHZkcGEgZGV2aWNlIHByZXZpb3VzbHkgY3JlYXRlZC4NCiQgdmRwYSBkZXYgZGVsIHZk
cGEwDQoNCkRlc2lnbiBvdmVydmlldzoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoxLiBBYm92
ZSBleGFtcGxlIHRvb2wgcnVucyBvdmVyIG5ldGxpbmsgc29ja2V0IGludGVyZmFjZS4NCjIuIFRo
aXMgZW5hYmxlcyB1c2VycyB0byByZXR1cm4gbWVhbmluZ2Z1bCBlcnJvciBzdHJpbmdzIGluIGFk
ZGl0aW9uIHRvIGNvZGUgc28gdGhhdCB1c2VyIGNhbiBiZSBtb3JlIGluZm9ybWVkLg0KT2Z0ZW4g
dGhpcyBpcyBtaXNzaW5nIGluIGlvY3RsKCkvY29uZmlnZnMvc3lzZnMgaW50ZXJmYWNlcy4NCjMu
IFRoaXMgdG9vbCBvdmVyIG5ldGxpbmsgZW5hYmxlcyBzeXNjYWxsZXIgdGVzdHMgdG8gYmUgbW9y
ZSB1c2FibGUgbGlrZSBvdGhlciBzdWJzeXN0ZW1zIHRvIGtlZXAga2VybmVsIHJvYnVzdA0KNC4g
VGhpcyBwcm92aWRlcyB2ZW5kb3IgYWdub3N0aWMgdmlldyBvZiBhbGwgdmRwYSBjYXBhYmxlIHBh
cmVudCBhbmQgdmRwYSBkZXZpY2VzLg0KDQo1LiBFYWNoIGRyaXZlciB3aGljaCBzdXBwb3J0cyB2
ZHBhIGRldmljZSBjcmVhdGlvbiwgcmVnaXN0ZXJzIHRoZSBwYXJlbnQgZGV2aWNlIGFsb25nIHdp
dGggc3VwcG9ydGVkIGNsYXNzZXMuDQoNCkZBUXM6DQotLS0tLS0tLQ0KMS4gV2h5IG5vdCB1c2lu
ZyBkZXZsaW5rPw0KQW5zOiBCZWNhdXNlIGFzIHZkcGEgZWNobyBzeXN0ZW0gZ3Jvd3MsIGRldmxp
bmsgd2lsbCBmYWxsIHNob3J0IG9mIGV4dGVuZGluZyB2ZHBhIHNwZWNpZmljIHBhcmFtcywgYXR0
cmlidXRlcywgc3RhdHMuDQoNCjIuIFdoeSBub3QgdXNlIHN5c2ZzPw0KQW5zOiANCihhKSBCZWNh
dXNlIHJ1bm5pbmcgc3lzY2FsbGVyIGluZnJhc3RydWN0dXJlIGNhbiBydW4gd2VsbCBvdmVyIG5l
dGxpbmsgc29ja2V0cyBsaWtlIGl0IHJ1bnMgZm9yIHNldmVyYWwgc3Vic3lzdGVtLg0KKGIpIGl0
IGxhY2tzIHRoZSBhYmlsaXR5IHRvIHJldHVybiBlcnJvciBtZXNzYWdlcy4gRG9pbmcgdmlhIGtl
cm5lbCBsb2cgaXMganVzdCBkb2Vzbid0IHdvcmsuDQooYykgV2h5IG5vdCB1c2luZyBzb21lIGlv
Y3RsKCk/IEl0IHdpbGwgcmVpbnZlbnQgdGhlIHdoZWVsIG9mIG5ldGxpbmsgdGhhdCBoYXMgVExW
IGZvcm1hdHMgZm9yIHNldmVyYWwgYXR0cmlidXRlcy4NCg0KMy4gV2h5IG5vdCBjb25maWdzPw0K
SXQgZm9sbG93cyBzYW1lIGxpbWl0YXRpb24gYXMgdGhhdCBvZiBzeXNmcy4NCg0KTG93IGxldmVs
IGRlc2lnbiBhbmQgZHJpdmVyIEFQSVM6DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KV2lsbCBwb3N0IG9uY2Ugd2UgZGlzY3VzcyB0aGlzIGZ1cnRoZXIuDQo=
