Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAA2494C0
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 07:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHSF6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 01:58:20 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4246 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgHSF6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 01:58:18 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3cbf080000>; Tue, 18 Aug 2020 22:56:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 22:58:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 22:58:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 05:58:14 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Aug 2020 05:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPbNBhTb8hgIntR1iCwROwo5IAHugrCoJA0p+wevy65A9EPmS3kA2VnMSSOkqSAiAQ935azmEmvmocDXWSq5zBxJNOQdXAZq44852GJczhk0f2Z8SjYdOmO07s1nqdWX4snnW+pySdzNATTiDUq9yUKMqkGugs+WnXMJix86VOyHJLHvL0BpdbWlRBk9xdXNDEL4LtBQM1dqf5aKAayCy00eahb74aWKtgnSbzZOv5o+XvRD+MYPsxuIubHEkXkj0XxMvhZN6T+kdTMWN2aMPMRS3HIYdw1lH8KwMR+O0qmjtskfnmGV/RlZDrS935Q8xod6OWPLl1mIXuraaOGxWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKNbvPY5UTRmNqLSg37Qx/lnP0zYIH96oV43+RyziTw=;
 b=aQyt3s2IqiQ15re63mh4ZQeCsRR4Ya3J2jrLozrj2bT3PJERRxPv/88T1nCLyXPUcAClQdVCv6okqFqiS6uG5BqrLhR+/IoD6wKpvdTggo97baTZvgbrJeWKO3Siii5vh24jLhTVZrD/WMKMdzuNew/gNozbQ8rG4r8oiIDi2H08/EoRnX/Uh3vSHKMRJo/h7T2OwiM+bgw3cOmZ1Yj9l+7lkcrfuVclLmkevxl2fsmpHUf/ybVzgLU1iCuGlS6eHsWefeKInevijGv5cAtq15UxfM4P5KZ186dIvMyV0BIp7Q+6z07cbrTSGrAkWRrJ2+Cl7rGyJGtBBY+xA4wEbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3173.namprd12.prod.outlook.com (2603:10b6:a03:13d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 19 Aug
 2020 05:58:12 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%8]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 05:58:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Thread-Index: AQHWaxahY2KLNHS+kEetIX0F/1UfDqkw/oyAgAR+pQCAAaChgIAGKisAgABceICAAAHJgIAABBYAgAAFswCAAAB4cIABK4aAgAAk5bA=
Date:   Wed, 19 Aug 2020 05:58:12 +0000
Message-ID: <BY5PR12MB43226CABD003285D0C77E2B7DC5D0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <BY5PR12MB4322C9D1A66C4657776A1383DC5C0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200819033035.GA21172@joy-OptiPlex-7040>
In-Reply-To: <20200819033035.GA21172@joy-OptiPlex-7040>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abc7b22a-c60a-4d66-5fef-08d84404db8c
x-ms-traffictypediagnostic: BYAPR12MB3173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB31735CD331FB59B7BA563B53DC5D0@BYAPR12MB3173.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ipMMGUNlRy8Gd6zlEIq4BZNYIjtrphZNk7Prs2D2VFxRMCN+XhLK5uKSL/GGxe5kG87aUj1DLp1RZyyZ2iDuyFsNUxAyPopYn+4WUat5ubUejEdqLAhflpwEItTgHA7o2zu1YiSvtzE+swDYNqyHdV/U5Dqi2jKczYKx7rilQm78M7+sz163CxBm1HhZv5mEDGsKEICWZ1jHqQdrKWoZU0yVY7gITaQUWWTnngInU47y/EWfRbfWzmOVHa/Tfzrp0Fp5oR/Paq4Jcl6a8SbJtokInDScy0CN0yiVOEDXPbCTE+d0hsIgFqNt8yN8z+kc8WFWiBs8eP1HmSGNwymWPTiWGfBLB57gNOsC+3voBGDmY/ysMafNzt4r1VFAu/fpB3LC562SM3I4xP+5vwk6hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(71200400001)(26005)(86362001)(186003)(2906002)(52536014)(5660300002)(7416002)(55016002)(83080400001)(9686003)(83380400001)(6506007)(316002)(66946007)(8936002)(66476007)(8676002)(66446008)(7696005)(4326008)(55236004)(64756008)(54906003)(76116006)(66556008)(33656002)(478600001)(45080400002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZoIwBRcwnz21vMSH/t8qrKvcSoVkA4q7GRgQ90iGG2KcMB5YqTHfBUwVPKeboc8q3MH2vXp/zDz3gRwP4HY2WOQOHh6iJK15Fm7wFkTJExv9B9lFYkset8njPfTq1ZT6cPRFQMU8P1z1d8sc06iFXkQScPH2VvJU01r5YjNQo3VRvQ7bZc+/ttC9qAkQc2+1y/CMfRRX2mfuzpq+qc/Rlgg085H/7Q4Qkb/ZAZf6/Mh7Ea8Vx+yZuZO+vvfaNseGL/PwRxGnquSzUKvk7SYIVzBHMOVIuYWQJmu3iRPxUn3sNP1qdWi/AVhRrj7lCrhdbKXGjGOO7lU26YDPvEGbvqL+69wNQCNcjDHpgW1R+Z2Xm0wFayxWlywt2u9nUUZ/JHD0BPXx0ql+aDHnVLaxOPaMt44cqlQMA2bBBW3SLqlnAPEqOXSl/UEoRYiVOwu11wf9hax/k+9imUzCx7zJuo1DE5M09MdHn0DY9fUlOwVc/bWcH3PyuSYu4RJgi61wjScj4JBsAZ0g+bWmy8BjcclzfxZPh93bd/RcGzgwyQyyUJyuvhjieEAhk2WwBny0HuKAc2L8rcMJZbm4HK9w2v1cAEWB1QVY8r9gQHAikfbUCJwMujhYGnaQy8nMWA+u7wUqhuC/cXqsl68SS1LPVQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc7b22a-c60a-4d66-5fef-08d84404db8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2020 05:58:12.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Lv1/GFll5rzY/oS4NgVX9vlKUZH+8Pv9RGXLqhyvASr5gbqpw+Mt3uy1hVs4E32FQd1qc2f7S4aSdccgu6eFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3173
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597816584; bh=RKNbvPY5UTRmNqLSg37Qx/lnP0zYIH96oV43+RyziTw=;
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
        b=ZY6QwkrsYewBR0+glqRbeXrurpOapIpn1J7OQprclBHYAVbI+nUFD8DCQg5FT/TX+
         eC11GxAjKAaaE4zymO7M9sUq3klmShXgQ7tZqMWaOZmNLhn2Hwqd/+NRgrozAT+JaQ
         dJyuHfYpiM5v6JXW5DnVdwQMTIUYby1Xjm8GNU6zuzSCdFfOfZKnnXU3pf6nbvXFZS
         DAERpHhJoHX/qoyQKzv5mqtCcOlMs6zWSqlRLTEF4JAvS70PRFKjE4UuCter2/usmz
         EldEbLOS0nny52oJUgKlCrim2PwNcycnaicF/4NpxtFXjTAgy+GBWpNh1ktA7vz+BP
         2E21jFQZrLU1w==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEF1Z3VzdCAxOSwgMjAyMCA5OjAxIEFNDQoNCj4gT24gVHVlLCBBdWcgMTgsIDIwMjAg
YXQgMDk6Mzk6MjRBTSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KDQo+ID4gUGxlYXNlIHJl
ZmVyIHRvIG15IHByZXZpb3VzIGVtYWlsIHdoaWNoIGhhcyBtb3JlIGV4YW1wbGUgYW5kIGRldGFp
bHMuDQo+IGhpIFBhcmF2LA0KPiB0aGUgZXhhbXBsZSBpcyBiYXNlZCBvbiBhIG5ldyB2ZHBhIHRv
b2wgcnVubmluZyBvdmVyIG5ldGxpbmssIG5vdCBiYXNlZCBvbg0KPiBkZXZsaW5rLCByaWdodD8N
ClJpZ2h0Lg0KDQo+IEZvciB2ZmlvIG1pZ3JhdGlvbiBjb21wYXRpYmlsaXR5LCB3ZSBoYXZlIHRv
IGRlYWwgd2l0aCBib3RoIG1kZXYgYW5kIHBoeXNpY2FsDQo+IHBjaSBkZXZpY2VzLCBJIGRvbid0
IHRoaW5rIGl0J3MgYSBnb29kIGlkZWEgdG8gd3JpdGUgYSBuZXcgdG9vbCBmb3IgaXQsIGdpdmVu
IHdlIGFyZQ0KPiBhYmxlIHRvIHJldHJpZXZlIHRoZSBzYW1lIGluZm8gZnJvbSBzeXNmcyBhbmQg
dGhlcmUncyBhbHJlYWR5IGFuIG1kZXZjdGwgZnJvbQ0KbWRldiBhdHRyaWJ1dGUgc2hvdWxkIGJl
IHZpc2libGUgaW4gdGhlIG1kZXYncyBzeXNmcyB0cmVlLg0KSSBkbyBub3QgcHJvcG9zZSB0byB3
cml0ZSBhIG5ldyBtZGV2IHRvb2wgb3ZlciBuZXRsaW5rLiBJIGFtIHNvcnJ5IGlmIEkgaW1wbGll
ZCB0aGF0IHdpdGggbXkgc3VnZ2VzdGlvbiBvZiB2ZHBhIHRvb2wuDQoNCklmIHVuZGVybHlpbmcg
ZGV2aWNlIGlzIHZkcGEsIG1kZXYgbWlnaHQgYmUgYWJsZSB0byB1bmRlcnN0YW5kIHZkcGEgZGV2
aWNlIGFuZCBxdWVyeSBmcm9tIGl0IGFuZCBwb3B1bGF0ZSBpbiBtZGV2IHN5c2ZzIHRyZWUuDQoN
ClRoZSB2ZHBhIHRvb2wgSSBwcm9wb3NlIGlzIHVzYWJsZSBldmVuIHdpdGhvdXQgbWRldnMuDQp2
ZHBhIHRvb2wncyByb2xlIGlzIHRvIGNyZWF0ZSBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZXMgYW5k
IHBsYWNlIG9uIHRoZSAidmRwYSIgYnVzIHdoaWNoIGlzIHRoZSBsb3dlc3QgbGF5ZXIgaGVyZS4N
CkFkZGl0aW9uYWxseSB0aGlzIHRvb2wgbGV0IHVzZXIgcXVlcnkgdmlydHF1ZXVlIHN0YXRzLCBk
YiBzdGF0cy4NCldoZW4gYSB1c2VyIGNyZWF0ZXMgdmRwYSBuZXQgZGV2aWNlLCB1c2VyIG1heSBu
ZWVkIHRvIGNvbmZpZ3VyZSBmZWF0dXJlcyBvZiB0aGUgdmRwYSBkZXZpY2Ugc3VjaCBhcyBWSVJU
SU9fTkVUX0ZfTUFDLCBkZWZhdWx0IFZJUlRJT19ORVRfRl9NVFUuDQpUaGVzZSBhcmUgdmRwYSBs
ZXZlbCBmZWF0dXJlcywgYXR0cmlidXRlcy4gTWRldiBpcyBsYXllciBhYm92ZSBpdC4NCg0KPiBB
bGV4DQo+IChodHRwczovL25hbTAzLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91
cmw9aHR0cHMlM0ElMkYlMkZnaXRodWIuDQo+IGNvbSUyRm1kZXZjdGwlMkZtZGV2Y3RsJmFtcDtk
YXRhPTAyJTdDMDElN0NwYXJhdiU0MG52aWRpYS5jb20lN0MNCj4gMGMyNjkxZDQzMDMwNGY1ZWEx
MTMwOGQ4NDNmMmQ4NGUlN0M0MzA4M2QxNTcyNzM0MGMxYjdkYjM5ZWZkOWNjYzE3DQo+IGElN0Mw
JTdDMCU3QzYzNzMzNDA1NzU3MTkxMTM1NyZhbXA7c2RhdGE9S3hIN1B3eG1LeXk5Sk9EdXQ4Qldy
DQo+IExReU9CeWxXMDAlMkZ5emM0ckV2alV2QSUzRCZhbXA7cmVzZXJ2ZWQ9MCkuDQo+DQpTb3Jy
eSBmb3IgYWJvdmUgbGluayBtYW5nbGluZy4gT3VyIG1haWwgc2VydmVyIGlzIHN0aWxsIHRyYW5z
aXRpb25pbmcgZHVlIHRvIGNvbXBhbnkgYWNxdWlzaXRpb24uDQoNCkkgYW0gbGVzcyBmYW1pbGlh
ciBvbiBiZWxvdyBwb2ludHMgdG8gY29tbWVudC4NCg0KPiBoaSBBbGwsDQo+IGNvdWxkIHdlIGRl
Y2lkZSB0aGF0IHN5c2ZzIGlzIHRoZSBpbnRlcmZhY2UgdGhhdCBldmVyeSBWRklPIHZlbmRvciBk
cml2ZXIgbmVlZHMNCj4gdG8gcHJvdmlkZSBpbiBvcmRlciB0byBzdXBwb3J0IHZmaW8gbGl2ZSBt
aWdyYXRpb24sIG90aGVyd2lzZSB0aGUgdXNlcnNwYWNlDQo+IG1hbmFnZW1lbnQgdG9vbCB3b3Vs
ZCBub3QgbGlzdCB0aGUgZGV2aWNlIGludG8gdGhlIGNvbXBhdGlibGUgbGlzdD8NCj4gDQo+IGlm
IHRoYXQncyB0cnVlLCBsZXQncyBtb3ZlIHRvIHRoZSBzdGFuZGFyZGl6aW5nIG9mIHRoZSBzeXNm
cyBpbnRlcmZhY2UuDQo+ICgxKSBjb250ZW50DQo+IGNvbW1vbiBwYXJ0OiAobXVzdCkNCj4gICAg
LSBzb2Z0d2FyZV92ZXJzaW9uOiAoaW4gbWFqb3IubWlub3IuYnVnZml4IHNjaGVtZSkNCj4gICAg
LSBkZXZpY2VfYXBpOiB2ZmlvLXBjaSBvciB2ZmlvLWNjdyAuLi4NCj4gICAgLSB0eXBlOiBtZGV2
IHR5cGUgZm9yIG1kZXYgZGV2aWNlIG9yDQo+ICAgICAgICAgICAgYSBzaWduYXR1cmUgZm9yIHBo
eXNpY2FsIGRldmljZSB3aGljaCBpcyBhIGNvdW50ZXJwYXJ0IGZvcg0KPiAJICAgbWRldiB0eXBl
Lg0KPiANCj4gZGV2aWNlIGFwaSBzcGVjaWZpYyBwYXJ0OiAobXVzdCkNCj4gICAtIHBjaSBpZDog
cGNpIGlkIG9mIG1kZXYgcGFyZW50IGRldmljZSBvciBwY2kgaWQgb2YgcGh5c2ljYWwgcGNpDQo+
ICAgICBkZXZpY2UgKGRldmljZV9hcGkgaXMgdmZpby1wY2kpDQo+ICAgLSBzdWJjaGFubmVsX3R5
cGUgKGRldmljZV9hcGkgaXMgdmZpby1jY3cpDQo+IA0KPiB2ZW5kb3IgZHJpdmVyIHNwZWNpZmlj
IHBhcnQ6IChvcHRpb25hbCkNCj4gICAtIGFnZ3JlZ2F0b3INCj4gICAtIGNocGlkX3R5cGUNCj4g
ICAtIHJlbW90ZV91cmwNCj4gDQo+IE5PVEU6IHZlbmRvcnMgYXJlIGZyZWUgdG8gYWRkIGF0dHJp
YnV0ZXMgaW4gdGhpcyBwYXJ0IHdpdGggYSByZXN0cmljdGlvbiB0aGF0IHRoaXMNCj4gYXR0cmli
dXRlIGlzIGFibGUgdG8gYmUgY29uZmlndXJlZCB3aXRoIHRoZSBzYW1lIG5hbWUgaW4gc3lzZnMg
dG9vLiBlLmcuDQo+IGZvciBhZ2dyZWdhdG9yLCB0aGVyZSBtdXN0IGJlIGEgc3lzZnMgYXR0cmli
dXRlIGluIGRldmljZSBub2RlDQo+IC9zeXMvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MDIu
MC84ODJjYzRkYS1kZWRlLTExZTctOTE4MC0NCj4gMDc4YTYyMDYzYWIxL2ludGVsX3ZncHUvYWdn
cmVnYXRvciwNCj4gc28gdGhhdCB0aGUgdXNlcnNwYWNlIHRvb2wgaXMgYWJsZSB0byBjb25maWd1
cmUgdGhlIHRhcmdldCBkZXZpY2UgYWNjb3JkaW5nIHRvDQo+IHNvdXJjZSBkZXZpY2UncyBhZ2dy
ZWdhdG9yIGF0dHJpYnV0ZS4NCj4gDQo+IA0KPiAoMikgd2hlcmUgYW5kIHN0cnVjdHVyZQ0KPiBw
cm9wb3NhbCAxOg0KPiB8LSBbcGF0aCB0byBkZXZpY2VdDQo+ICAgfC0tLSBtaWdyYXRpb24NCj4g
ICB8ICAgICB8LS0tIHNlbGYNCj4gICB8ICAgICB8ICAgIHwtc29mdHdhcmVfdmVyc2lvbg0KPiAg
IHwgICAgIHwgICAgfC1kZXZpY2VfYXBpDQo+ICAgfCAgICAgfCAgICB8LXR5cGUNCj4gICB8ICAg
ICB8ICAgIHwtW3BjaV9pZCBvciBzdWJjaGFubmVsX3R5cGVdDQo+ICAgfCAgICAgfCAgICB8LTxh
Z2dyZWdhdG9yIG9yIGNocGlkX3R5cGU+DQo+ICAgfCAgICAgfC0tLSBjb21wYXRpYmxlDQo+ICAg
fCAgICAgfCAgICB8LXNvZnR3YXJlX3ZlcnNpb24NCj4gICB8ICAgICB8ICAgIHwtZGV2aWNlX2Fw
aQ0KPiAgIHwgICAgIHwgICAgfC10eXBlDQo+ICAgfCAgICAgfCAgICB8LVtwY2lfaWQgb3Igc3Vi
Y2hhbm5lbF90eXBlXQ0KPiAgIHwgICAgIHwgICAgfC08YWdncmVnYXRvciBvciBjaHBpZF90eXBl
Pg0KPiBtdWx0aXBsZSBjb21wYXRpYmxlIGlzIGFsbG93ZWQuDQo+IGF0dHJpYnV0ZXMgc2hvdWxk
IGJlIEFTQ0lJIHRleHQgZmlsZXMsIHByZWZlcmFibHkgd2l0aCBvbmx5IG9uZSB2YWx1ZSBwZXIg
ZmlsZS4NCj4gDQo+IA0KPiBwcm9wb3NhbCAyOiB1c2UgYmluX2F0dHJpYnV0ZS4NCj4gfC0gW3Bh
dGggdG8gZGV2aWNlXQ0KPiAgIHwtLS0gbWlncmF0aW9uDQo+ICAgfCAgICAgfC0tLSBzZWxmDQo+
ICAgfCAgICAgfC0tLSBjb21wYXRpYmxlDQo+IA0KPiBzbyB3ZSBjYW4gY29udGludWUgdXNlIG11
bHRpbGluZSBmb3JtYXQuIGUuZy4NCj4gY2F0IGNvbXBhdGlibGUNCj4gICBzb2Z0d2FyZV92ZXJz
aW9uPTAuMS4wDQo+ICAgZGV2aWNlX2FwaT12ZmlvX3BjaQ0KPiAgIHR5cGU9aTkxNS1HVlRnX1Y1
X3t2YWwxOmludDoxLDIsNCw4fQ0KPiAgIHBjaV9pZD04MDg2NTk2Mw0KPiAgIGFnZ3JlZ2F0b3I9
e3ZhbDF9LzINCj4gDQo+IFRoYW5rcw0KPiBZYW4NCg==
