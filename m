Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8D24954B
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHSGxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:53:12 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18812 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHSGxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:53:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ccc1b0000>; Tue, 18 Aug 2020 23:52:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 23:53:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 23:53:09 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 06:53:05 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Aug 2020 06:53:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGaj4L9GuyCXLHaRof1MN069b6e5mIHYBVoYyu8EolZsLfU6SwIuaJRIIZykw4pmCy1n2bMC/LgTALCBh5NtPHcm02sVnAbM83/6o27QRhVG+Vm9Cy9UGa2rftd9NATvnt5jPxbCV9e31xwUaUAwek1b0M7OKPcR6/wRThaJY+aRAtAzcKoIhyJeO3SgFYe9VNRcgGwpJpnadCblB0Tw5QK5Gak8WYZvgHhIimdl+Est+UHVofSUaaod1OFrc6n27ALE2xOVA0ASVbiD2nr06ZAW3dLGGjVd2OEfz+Bak7kn1Qs6ajts1KHB0Cy8PItOj+BnB/wySJXkUXI1sL7X8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMohnxEM62oIPs8rwxKuNqrHuM1aQmK0lQ+l++TMBAk=;
 b=ht/bjsgXgrPiLN08LsuGZJRhSSQ1UVVad1bhBwaFDAZ3ueTwRiBRJdlG4kq7ibphgU4HgIp079TLKf+GTF2iIUkDl7qz9aWBo4E79z3jRCNAAenvt+PU1Qw3LnnKyrq98KTJBAQQBOp9OXOraqHN/lMK9A35YSwrZgZY6w5qLCHEGH+1HLe6GL8PqTOAR5HIV3z0K0Nxd4hxtZ0jpY8mNxo1nIL61cAmJJJEf/AD6sJJNBPTn0CaO9GQBplG+gNfO8it0xar6lVQu/Ympr5m2XIl1Uli9/Wy/wTKk++tkiXEPQMEYCwt81xzmPvtfNcl9uqFZlOGmpxjft+5nUQCRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3841.namprd12.prod.outlook.com (2603:10b6:a03:194::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 06:53:04 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%8]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 06:53:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "Yan Zhao" <yan.y.zhao@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "jian-feng.ding@intel.com" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "hejie.xu@intel.com" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Thread-Index: AQHWaxahY2KLNHS+kEetIX0F/1UfDqkw/oyAgAR+pQCAAaChgIAGKisAgABceICAAAHJgIAAAlhQgAEm94CAAChrMIAAG14AgAAAbQA=
Date:   Wed, 19 Aug 2020 06:53:03 +0000
Message-ID: <BY5PR12MB43225D59AFF0D54AC2F9D3C1DC5D0@BY5PR12MB4322.namprd12.prod.outlook.com>
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
 <BY5PR12MB4322CD6B3C697B6F1807ECBFDC5D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <115147a9-3d8c-aa95-c43d-251a321ac152@redhat.com>
In-Reply-To: <115147a9-3d8c-aa95-c43d-251a321ac152@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b6b6d7a-4c6c-4841-bec2-08d8440c856f
x-ms-traffictypediagnostic: BY5PR12MB3841:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3841F3571B97E26ED4ECA5D7DC5D0@BY5PR12MB3841.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11uSy4aKxqgELzKC3N6JSzuz6+dddI0kdyLNOrhF48doBAmV/6bnr2a58zZvOBZ8O1ZFp19MqdwdbkwHvPvOkyX8FLZbWyyrg1L/FbdTIDhTW6a9HyWgMIEIfuqEgVjlbqk5B+gD26imTzFNzQc0N6ykSKTcODQPSUfsOlzkJKZ1d620V+nIlQZzYRJoIrx7Iek6q2KyQE2svXkfckgJFV333IN8Y1tQEaujgN1jkmCWTkValthNF800WVro8Fpz65H04d7yXJO762RjlCcWP+lGEXPMFXYyRj2fKnb1wDQcVd1img7/5hccExzyUNWWSlfiJlgkAaYfyi5sTJQb5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(86362001)(478600001)(55016002)(9686003)(6506007)(110136005)(54906003)(26005)(7416002)(55236004)(186003)(316002)(7696005)(64756008)(66946007)(66476007)(66556008)(76116006)(8676002)(71200400001)(8936002)(5660300002)(52536014)(66446008)(83380400001)(4326008)(2906002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wfLbT2J2GLdz2VM1whjJZFTjN+hpdgFXyitzhl7xutUm1RYaNZnN7XU/xzwFgyPx762xyrvLRuTsh9Y2zwIQ8yJTB8x8+asYlTYHLjytcwE3z4uL2avEX3R8So53+yKjS3VdmZMB+Qg7o/PnHZMaB25BJ45+aQN4mMsTMLWOT0MbIcb5Hxg2q7vjKamMzAUB6yG9IC1rlqeurYQ6lWM5fXLo+V7gWJp4CB2kh0pAvPUtE6zVcWA7WgIOPKIKcNSjGiLAzKm0daVGzKL3pthrLbbwW99BuEAf3a0lf9RlNw18zm3IRYTD7t+s36K8aghIc5+LGVDOPn81q+pn7Gs8ioBHA8TqS050pYDB/lCF64mz+nO6pzEKDwKeZZGFBDTUZhRAey/badN5E8rg1691qM/q+vYtJkkpwkNKWW1R1bxIHiHzfJSTcw2kxx2m15SNzDPjhfowLAf/yIlfReLDPQNywFhJonNgGWlxlhWDnEnN/TmgC5gARZoIqObR/H0mkDBFjbYJPKgSyXAvRwiVGiRsrJe/YWJMT/zWJjXZDDkA8L5khws+EvJ1fiLjcMmqO1AKCtINxENz0RjKfEYHm7/8ex3kkXB4/7gukEJHvf7ZvBkA8VbgEnt44LiYm7pPQHlQB4dazo5HcpGxbHn42Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6b6d7a-4c6c-4841-bec2-08d8440c856f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 06:53:03.6040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uu7DagQx6ucB8DNIJA3lMkKQdgVq0xzkRInMJnB3XjlWpFDQE33kr3LOOf5N8+ctcMyOT6VbryerFohTO+QSDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3841
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597819931; bh=aMohnxEM62oIPs8rwxKuNqrHuM1aQmK0lQ+l++TMBAk=;
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
        b=qM3DyZp0EXZGnzbi0NyjIUfPMgYxh8aoY2sxYeZ3idUYac4K7iieydbKH3RGuYzyX
         9ydt0NvCl9slY4kXadZ3Ppo6qQ1H+oawZOo4eS3aff4HfNE9FsqV6+1CDAC8KXbu6t
         cBwLdBrhUj+VFcH+NQ+gDT9x7jEAvNsWCE1edzsFtsG/5N9kOg06aIv2LogoJl3udA
         p0O64v4nb0yVWgCrLcVM580KgHEgPGbZw3rBcXJOtnaS3Cj8G0rbMiHfSRY0Qt3Qne
         19Ze+loPFfmgh3eKnFaxfW+MwLFwo35PYGA5eLv6j9lffX9iB62uhGEw43ErxFLFcy
         EVTR9n+3JfX7g==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBBdWd1c3QgMTksIDIwMjAgMTI6MTkgUE0NCj4gDQo+IA0KPiBPbiAyMDIwLzgvMTkg
5LiL5Y2IMToyNiwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4+IEZyb206IEphc29uIFdh
bmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+ID4+IFNlbnQ6IFdlZG5lc2RheSwgQXVndXN0IDE5
LCAyMDIwIDg6MTYgQU0NCj4gPg0KPiA+PiBPbiAyMDIwLzgvMTgg5LiL5Y2INTozMiwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+Pj4gSGkgSmFzb24sDQo+ID4+Pg0KPiA+Pj4gRnJvbTogSmFzb24g
V2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPj4+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAx
OCwgMjAyMCAyOjMyIFBNDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+IE9uIDIwMjAvOC8xOCDkuIvljYg0
OjU1LCBEYW5pZWwgUC4gQmVycmFuZ8OpIHdyb3RlOg0KPiA+Pj4gT24gVHVlLCBBdWcgMTgsIDIw
MjAgYXQgMTE6MjQ6MzBBTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPj4+IE9uIDIwMjAv
OC8xNCDkuIvljYgxOjE2LCBZYW4gWmhhbyB3cm90ZToNCj4gPj4+IE9uIFRodSwgQXVnIDEzLCAy
MDIwIGF0IDEyOjI0OjUwUE0gKzA4MDAsIEphc29uIFdhbmcgd3JvdGU6DQo+ID4+PiBPbiAyMDIw
LzgvMTAg5LiL5Y2IMzo0NiwgWWFuIFpoYW8gd3JvdGU6DQo+ID4+PiBkcml2ZXIgaXMgaXQgaGFu
ZGxlZCBieT8NCj4gPj4+IEl0IGxvb2tzIHRoYXQgdGhlIGRldmxpbmsgaXMgZm9yIG5ldHdvcmsg
ZGV2aWNlIHNwZWNpZmljLCBhbmQgaW4NCj4gPj4+IGRldmxpbmsuaCwgaXQgc2F5cyBpbmNsdWRl
L3VhcGkvbGludXgvZGV2bGluay5oIC0gTmV0d29yayBwaHlzaWNhbA0KPiA+Pj4gZGV2aWNlIE5l
dGxpbmsgaW50ZXJmYWNlLCBBY3R1YWxseSBub3QsIEkgdGhpbmsgdGhlcmUgdXNlZCB0byBoYXZl
DQo+ID4+PiBzb21lIGRpc2N1c3Npb24gbGFzdCB5ZWFyIGFuZCB0aGUgY29uY2x1c2lvbiBpcyB0
byByZW1vdmUgdGhpcw0KPiA+Pj4gY29tbWVudC4NCj4gPj4+DQo+ID4+PiBbLi4uXQ0KPiA+Pj4N
Cj4gPj4+PiBZZXMsIGJ1dCBpdCBjb3VsZCBiZSBoYXJkLiBFLmcgdkRQQSB3aWxsIGNob3NlIHRv
IHVzZSBkZXZsaW5rDQo+ID4+Pj4gKHRoZXJlJ3MgYSBsb25nDQo+ID4+IGRlYmF0ZSBvbiBzeXNm
cyB2cyBkZXZsaW5rKS4gU28gaWYgd2UgZ28gd2l0aCBzeXNmcywgYXQgbGVhc3QgdHdvDQo+ID4+
IEFQSXMgbmVlZHMgdG8gYmUgc3VwcG9ydGVkIC4uLg0KPiA+Pj4gV2UgaGFkIGludGVybmFsIGRp
c2N1c3Npb24gYW5kIHByb3Bvc2FsIG9uIHRoaXMgdG9waWMuDQo+ID4+PiBJIHdhbnRlZCBFbGkg
Q29oZW4gdG8gYmUgYmFjayBmcm9tIHZhY2F0aW9uIG9uIFdlZCA4LzE5LCBidXQgc2luY2UNCj4g
Pj4+IHRoaXMgaXMNCj4gPj4gYWN0aXZlIGRpc2N1c3Npb24gcmlnaHQgbm93LCBJIHdpbGwgc2hh
cmUgdGhlIHRob3VnaHRzIGFueXdheS4NCj4gPj4+IEhlcmUgYXJlIHRoZSBpbml0aWFsIHJvdW5k
IG9mIHRob3VnaHRzIGFuZCBwcm9wb3NhbC4NCj4gPj4+DQo+ID4+PiBVc2VyIHJlcXVpcmVtZW50
czoNCj4gPj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+Pj4gMS4gVXNlciBtaWdo
dCB3YW50IHRvIGNyZWF0ZSBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZXMgcGVyIFBDSSBQRi9WRi9T
Ri4NCj4gPj4+IDIuIFVzZXIgbWlnaHQgd2FudCB0byBjcmVhdGUgb25lIG9yIG1vcmUgdmRwYSBk
ZXZpY2VzIG9mIHR5cGUNCj4gPj4+IG5ldC9ibGsgb3INCj4gPj4gb3RoZXIgdHlwZS4NCj4gPj4+
IDMuIFVzZXIgbmVlZHMgdG8gbG9vayBhbmQgZHVtcCBhdCB0aGUgaGVhbHRoIG9mIHRoZSBxdWV1
ZXMgZm9yIGRlYnVnDQo+IHB1cnBvc2UuDQo+ID4+PiA0LiBEdXJpbmcgdmRwYSBuZXQgZGV2aWNl
IGNyZWF0aW9uIHRpbWUsIHVzZXIgbWF5IGhhdmUgdG8gcHJvdmlkZSBhDQo+ID4+PiBNQUMNCj4g
Pj4gYWRkcmVzcyBhbmQvb3IgVkxBTi4NCj4gPj4+IDUuIFVzZXIgc2hvdWxkIGJlIGFibGUgdG8g
c2V0L3F1ZXJ5IHNvbWUgb2YgdGhlIGF0dHJpYnV0ZXMgZm9yDQo+ID4+PiBkZWJ1Zy9jb21wYXRp
YmlsaXR5IGNoZWNrIDYuIFdoZW4gdXNlciB3YW50cyB0byBjcmVhdGUgdmRwYSBkZXZpY2UsDQo+
ID4+PiBpdCBuZWVkcw0KPiA+PiB0byBrbm93IHdoaWNoIGRldmljZSBzdXBwb3J0cyBjcmVhdGlv
bi4NCj4gPj4+IDcuIFVzZXIgc2hvdWxkIGJlIGFibGUgdG8gc2VlIHRoZSBxdWV1ZSBzdGF0aXN0
aWNzIG9mIGRvb3JiZWxscywNCj4gPj4+IHdxZXMgZXRjIHJlZ2FyZGxlc3Mgb2YgY2xhc3MgdHlw
ZQ0KPiA+Pg0KPiA+PiBOb3RlIHRoYXQgd3FlcyBpcyBwcm9iYWJseSBub3Qgc29tZXRoaW5nIGNv
bW1vbiBpbiBhbGwgb2YgdGhlIHZlbmRvcnMuDQo+ID4gWWVzLiBJIHZpcnRxIGRlc2NyaXB0b3Jz
IHN0YXRzIGlzIGJldHRlciB0byBtb25pdG9yIHRoZSB2aXJ0cXVldWVzLg0KPiA+DQo+ID4+DQo+
ID4+PiBUbyBhZGRyZXNzIGFib3ZlIHJlcXVpcmVtZW50cywgdGhlcmUgaXMgYSBuZWVkIG9mIHZl
bmRvciBhZ25vc3RpYw0KPiA+Pj4gdG9vbCwgc28NCj4gPj4gdGhhdCB1c2VyIGNhbiBjcmVhdGUv
Y29uZmlnL2RlbGV0ZSB2ZHBhIGRldmljZShzKSByZWdhcmRsZXNzIG9mIHRoZSB2ZW5kb3IuDQo+
ID4+PiBIZW5jZSwNCj4gPj4+IFdlIHNob3VsZCBoYXZlIGEgdG9vbCB0aGF0IGxldHMgdXNlciBk
byBpdC4NCj4gPj4+DQo+ID4+PiBFeGFtcGxlczoNCj4gPj4+IC0tLS0tLS0tLS0tLS0NCj4gPj4+
IChhKSBMaXN0IHBhcmVudCBkZXZpY2VzIHdoaWNoIHN1cHBvcnRzIGNyZWF0aW5nIHZkcGEgZGV2
aWNlcy4NCj4gPj4+IEl0IGFsc28gc2hvd3Mgd2hpY2ggY2xhc3MgdHlwZXMgc3VwcG9ydGVkIGJ5
IHRoaXMgcGFyZW50IGRldmljZS4NCj4gPj4+IEluIGJlbG93IGNvbW1hbmQgdHdvIHBhcmVudCBk
ZXZpY2VzIHN1cHBvcnQgdmRwYSBkZXZpY2UgY3JlYXRpb24uDQo+ID4+PiBGaXJzdCBpcyBQQ0kg
VkYgd2hvc2UgYmRmIGlzIDAzLjAwOjUuDQo+ID4+PiBTZWNvbmQgaXMgUENJIFNGIHdob3NlIG5h
bWUgaXMgbWx4NV9zZi4xDQo+ID4+Pg0KPiA+Pj4gJCB2ZHBhIGxpc3QgcGQNCj4gPj4NCj4gPj4g
V2hhdCBkaWQgInBkIiBtZWFuPw0KPiA+Pg0KPiA+IFBhcmVudCBkZXZpY2Ugd2hpY2ggc3VwcG9y
dCBjcmVhdGlvbiBvZiBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZXMuDQo+ID4gSW4gYSBzeXN0ZW0g
dGhlcmUgY2FuIGJlIG11bHRpcGxlIHBhcmVudCBkZXZpY2VzIHdoaWNoIG1heSBiZSBzdXBwb3J0
IHZkcGENCj4gY3JlYXRpb24uDQo+ID4gVXNlciBzaG91bGQgYmUgYWJsZSB0byBrbm93IHdoaWNo
IGRldmljZXMgc3VwcG9ydCBpdCwgYW5kIHdoZW4gdXNlciBjcmVhdGVzIGENCj4gdmRwYSBkZXZp
Y2UsIGl0IHRlbGxzIHdoaWNoIHBhcmVudCBkZXZpY2UgdG8gdXNlIGZvciBjcmVhdGlvbiBhcyBk
b25lIGluIGJlbG93DQo+IHZkcGEgZGV2IGFkZCBleGFtcGxlLg0KPiA+Pj4gcGNpLzAwMDA6MDMu
MDA6NQ0KPiA+Pj4gICAgIGNsYXNzX3N1cHBvcnRzDQo+ID4+PiAgICAgICBuZXQgdmRwYQ0KPiA+
Pj4gdmlydGJ1cy9tbHg1X3NmLjENCj4gPj4NCj4gPj4gU28gY3JlYXRpbmcgbWx4NV9zZi4xIGlz
IHRoZSBjaGFyZ2Ugb2YgZGV2bGluaz8NCj4gPj4NCj4gPiBZZXMuDQo+ID4gQnV0IGhlcmUgdmRw
YSB0b29sIGlzIHdvcmtpbmcgYXQgdGhlIHBhcmVudCBkZXZpY2UgaWRlbnRpZmllciB7YnVzK25h
bWV9DQo+IGluc3RlYWQgb2YgZGV2bGluayBpZGVudGlmaWVyLg0KPiA+DQo+ID4NCj4gPj4+ICAg
ICBjbGFzc19zdXBwb3J0cw0KPiA+Pj4gICAgICAgbmV0DQo+ID4+Pg0KPiA+Pj4gKGIpIE5vdyBh
ZGQgYSB2ZHBhIGRldmljZSBhbmQgc2hvdyB0aGUgZGV2aWNlLg0KPiA+Pj4gJCB2ZHBhIGRldiBh
ZGQgcGNpLzAwMDA6MDMuMDA6NSB0eXBlIG5ldA0KPiA+Pg0KPiA+PiBTbyBpZiB5b3Ugd2FudCB0
byBjcmVhdGUgZGV2aWNlcyB0eXBlcyBvdGhlciB0aGFuIHZkcGEgb24NCj4gPj4gcGNpLzAwMDA6
MDMuMDA6NSBpdCBuZWVkcyBzb21lIHN5bmNocm9uaXphdGlvbiB3aXRoIGRldmxpbms/DQo+ID4g
UGxlYXNlIHJlZmVyIHRvIEZBUS0xLCAgYSBuZXcgdG9vbCBpcyBub3QgbGlua2VkIHRvIGRldmxp
bmsgYmVjYXVzZSB2ZHBhIHdpbGwNCj4gZXZvbHZlIHdpdGggdGltZSBhbmQgZGV2bGluayB3aWxs
IGZhbGwgc2hvcnQuDQo+ID4gU28gbm8sIGl0IGRvZXNuJ3QgbmVlZCBhbnkgc3luY2hyb25pemF0
aW9uIHdpdGggZGV2bGluay4NCj4gPiBBcyBsb25nIGFzIHBhcmVudCBkZXZpY2UgZXhpc3QsIHVz
ZXIgY2FuIGNyZWF0ZSBpdC4NCj4gPiBBbGwgc3luY2hyb25pemF0aW9uIHdpbGwgYmUgd2l0aGlu
IGRyaXZlcnMvdmRwYS92ZHBhLmMgVGhpcyB1c2VyDQo+ID4gaW50ZXJmYWNlIGlzIGV4cG9zZWQg
dmlhIG5ldyBuZXRsaW5rIGZhbWlseSBieSBkb2luZyBnZW5sX3JlZ2lzdGVyX2ZhbWlseSgpIHdp
dGgNCj4gbmV3IG5hbWUgInZkcGEiIGluIGRyaXZlcnMvdmRwYS92ZHBhLmMuDQo+IA0KPiANCj4g
SnVzdCB0byBtYWtlIHN1cmUgSSB1bmRlcnN0YW5kIGhlcmUuDQo+IA0KPiBDb25zaWRlciB3ZSBo
YWQgdmlydGJ1cy9tbHg1X3NmLjEuIFByb2Nlc3MgQSB3YW50IHRvIGNyZWF0ZSBhIHZEUEEgaW5z
dGFuY2Ugb24NCj4gdG9wIG9mIGl0IGJ1dCBQcm9jZXNzIEIgd2FudCB0byBjcmVhdGUgYSBJQiBp
bnN0YW5jZS4gVGhlbiBJIHRoaW5rIHNvbWUNCj4gc3luY2hyb25pemF0aW9uIGlzIG5lZWRlZCBh
dCBhdCBsZWFzdCBwYXJlbnQgZGV2aWNlIGxldmVsPw0KDQpMaWtlbHkgYnV0IHJkbWEgZGV2aWNl
IHdpbGwgYmUgY3JlYXRlZCBlaXRoZXIgdGhyb3VnaCANCiQgcmRtYSBsaW5rIGFkZCBjb21tYW5k
Lg0KT3IgYXV0byBjcmVhdGVkIGJ5IGRyaXZlciBiZWNhdXNlIHRoZXJlIGlzIG9ubHkgb25lIHdp
dGhvdXQgbXVjaCBjb25maWd1cmF0aW9uLg0KDQpXaGlsZSB2ZHBhIGRldmljZShzKSBmb3Igdmly
dGJ1cy9tbHg1X3NmLjEgd2lsbCBiZSBjcmVhdGVkIHRocm91Z2ggdmRwYSBzdWJzeXN0ZW0uDQpB
bmQgdmRwYSdzIHN5bmNocm9uaXphdGlvbiB3aWxsIGJlIGNvbnRhaW5lZCB3aXRoaW4gZHJpdmVy
cy92ZHBhL3ZkcGEuYw0KDQo+IA0KPiANCj4gPg0KPiA+Pg0KPiA+Pj4gJCB2ZHBhIGRldiBzaG93
DQo+ID4+PiB2ZHBhMEBwY2kvMDAwMDowMy4wMDo1IHR5cGUgbmV0IHN0YXRlIGluYWN0aXZlIG1h
eHF1ZXVlcyA4IGN1cnF1ZXVlcw0KPiA+Pj4gNA0KPiA+Pj4NCj4gPj4+IChjKSB2ZHBhIGRldiBz
aG93IGZlYXR1cmVzIHZkcGEwDQo+ID4+PiBpb21tdSBwbGF0Zm9ybQ0KPiA+Pj4gdmVyc2lvbiAx
DQo+ID4+Pg0KPiA+Pj4gKGQpIGR1bXAgdmRwYSBzdGF0aXN0aWNzDQo+ID4+PiAkIHZkcGEgZGV2
IHN0YXRzIHNob3cgdmRwYTANCj4gPj4+IGtpY2tkb29yYmVsbHMgMTANCj4gPj4+IHdxZXMgMTAw
DQo+ID4+Pg0KPiA+Pj4gKGUpIE5vdyBkZWxldGUgYSB2ZHBhIGRldmljZSBwcmV2aW91c2x5IGNy
ZWF0ZWQuDQo+ID4+PiAkIHZkcGEgZGV2IGRlbCB2ZHBhMA0KPiA+Pj4NCj4gPj4+IERlc2lnbiBv
dmVydmlldzoNCj4gPj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+PiAxLiBBYm92ZSBl
eGFtcGxlIHRvb2wgcnVucyBvdmVyIG5ldGxpbmsgc29ja2V0IGludGVyZmFjZS4NCj4gPj4+IDIu
IFRoaXMgZW5hYmxlcyB1c2VycyB0byByZXR1cm4gbWVhbmluZ2Z1bCBlcnJvciBzdHJpbmdzIGlu
IGFkZGl0aW9uDQo+ID4+PiB0byBjb2RlIHNvDQo+ID4+IHRoYXQgdXNlciBjYW4gYmUgbW9yZSBp
bmZvcm1lZC4NCj4gPj4+IE9mdGVuIHRoaXMgaXMgbWlzc2luZyBpbiBpb2N0bCgpL2NvbmZpZ2Zz
L3N5c2ZzIGludGVyZmFjZXMuDQo+ID4+PiAzLiBUaGlzIHRvb2wgb3ZlciBuZXRsaW5rIGVuYWJs
ZXMgc3lzY2FsbGVyIHRlc3RzIHRvIGJlIG1vcmUgdXNhYmxlDQo+ID4+PiBsaWtlIG90aGVyDQo+
ID4+IHN1YnN5c3RlbXMgdG8ga2VlcCBrZXJuZWwgcm9idXN0DQo+ID4+PiA0LiBUaGlzIHByb3Zp
ZGVzIHZlbmRvciBhZ25vc3RpYyB2aWV3IG9mIGFsbCB2ZHBhIGNhcGFibGUgcGFyZW50IGFuZA0K
PiA+Pj4gdmRwYQ0KPiA+PiBkZXZpY2VzLg0KPiA+Pj4gNS4gRWFjaCBkcml2ZXIgd2hpY2ggc3Vw
cG9ydHMgdmRwYSBkZXZpY2UgY3JlYXRpb24sIHJlZ2lzdGVycyB0aGUNCj4gPj4+IHBhcmVudCBk
ZXZpY2UNCj4gPj4gYWxvbmcgd2l0aCBzdXBwb3J0ZWQgY2xhc3Nlcy4NCj4gPj4+IEZBUXM6DQo+
ID4+PiAtLS0tLS0tLQ0KPiA+Pj4gMS4gV2h5IG5vdCB1c2luZyBkZXZsaW5rPw0KPiA+Pj4gQW5z
OiBCZWNhdXNlIGFzIHZkcGEgZWNobyBzeXN0ZW0gZ3Jvd3MsIGRldmxpbmsgd2lsbCBmYWxsIHNo
b3J0IG9mDQo+ID4+PiBleHRlbmRpbmcNCj4gPj4gdmRwYSBzcGVjaWZpYyBwYXJhbXMsIGF0dHJp
YnV0ZXMsIHN0YXRzLg0KPiA+Pg0KPiA+Pg0KPiA+PiBUaGlzIHNob3VsZCBiZSBmaW5lIGJ1dCBp
dCdzIHN0aWxsIG5vdCBjbGVhciB0byBtZSB0aGUgZGlmZmVyZW5jZQ0KPiA+PiBiZXR3ZWVuIGEg
dmRwYSBuZXRsaW5rIGFuZCBhIHZkcGEgb2JqZWN0IGluIGRldmxpbmsuDQo+ID4+DQo+ID4gVGhl
IGRpZmZlcmVuY2UgaXMgYSB2ZHBhIHNwZWNpZmljIHRvb2wgd29yayBhdCB0aGUgcGFyZW50IGRl
dmljZSBsZXZlbC4NCj4gPiBJdCBpcyBsaWtlbHkgbW9yZSBhcHByb3ByaWF0ZSB0byBiZWNhdXNl
IGl0IGNhbiBzZWxmLWNvbnRhaW4gZXZlcnl0aGluZyBuZWVkZWQNCj4gdG8gY3JlYXRlL2RlbGV0
ZSBkZXZpY2VzLCB2aWV3L3NldCBmZWF0dXJlcywgc3RhdHMuDQo+ID4gVHJ5aW5nIHRvIHB1dCB0
aGF0IGluIGRldmxpbmsgd2lsbCBmYWxsIHNob3J0IGFzIGRldmxpbmsgZG9lc27igJl0IGhhdmUg
dmRwYQ0KPiBkZWZpbml0aW9ucy4NCj4gPiBUeXBpY2FsbHkgd2hlbiBhIGNsYXNzL2RldmljZSBz
dWJzeXN0ZW0gZ3Jvd3MsIGl0cyBvd24gdG9vbCBpcyB3aXNlciBsaWtlDQo+IGlwcm91dGUyL2lw
LCBpcHJvdXRlMi90YywgaXByb3V0ZTIvcmRtYS4NCj4gDQo+IA0KPiBPaywgSSBzZWUuDQo+IA0K
PiBUaGFua3MNCj4gDQoNCg==
