Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12B4232CB3
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 09:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgG3Hur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 03:50:47 -0400
Received: from mail-eopbgr750043.outbound.protection.outlook.com ([40.107.75.43]:64389
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3Huq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 03:50:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwRVybgmMRbxtgoiRYRHDAdEb8/zeCYs9bM8lsR5YOt3g6c0YnhegoXfOPoeS3CkcQHaYsAMazcYA1SpKmcVTiRcheARnzhkMPNPR0RrM25JQMJWIP2EsvFdFYa6YxkbvaE4Y2hivSjF/7fXP1blOiKFFIT6+dhS+bRYCPb5El9oTbV78KZ1ewa76v7EdZkUIfZ8ype4vD9HDUrkdcWpeDIjXdxV9OSng9x0m3uOef3Whky1iY+fVrU+oISTwjbNWynlDFaQj77K9Dsokzxr7B3TwxcdwAg47sdzRCmJuYKNWjAgoouOU/1LXKSRY1pW3Du+HMp8rLn1Y8aUrFs97w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NE9JMA6uOU4HDgAa3UZ9CE6RQWwxbf0D1LS06/Gw4gE=;
 b=Yrz6khMs8jBFw4dQHhJFgv8F50YHJrYfUfqtl5npRAfmSTMgsjWPfeKQIHt2vNesl451mjdUnZF8d9aZV1zxoPcMOWxVPgTqDrAKZODiRtWnxHMFwcRiErfWrVqqztaMM1wIDe6QqWHzEN6A1DuKCLtnYWpHlRfXJaK3P12XDVmKUJregiePk+djYh3oK0b9NlXvnYhc96ZzFlEB1pHYABgZUpiO3g7iRjB4SmaXQghFI51yyIsZqEV2KLINfSGzmYsPhwhdFoHqdWxunRwsVILR2N5pkpfT6m6Z7P2gaT1xUrqXEJlgq/h8pEavftYNs2fq/oBU/HDI7Q06M4l9fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NE9JMA6uOU4HDgAa3UZ9CE6RQWwxbf0D1LS06/Gw4gE=;
 b=dTBvcwJXQthF3+UlE6yoUHMahjz2Cl00PxmPEMCGerpJEHZeA5ihQzR9KuI9PsYdPeMWhUnpS5C+NzHRR4E2iW20PZ/FdKJnmxvxmiznI2Uuhq37KqXcdfBX4sRUoB6A8pM4dVj0TnEIKaS3VqmsyZCiU1Olrna6lfOHyBB1s0s=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB4709.namprd05.prod.outlook.com (2603:10b6:a03:4d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9; Thu, 30 Jul
 2020 07:50:40 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3239.016; Thu, 30 Jul 2020
 07:50:40 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: A new name for kvm-unit-tests ?
Thread-Topic: A new name for kvm-unit-tests ?
Thread-Index: AQHWZjQkZcbo6dMKYUqQXELtxmgWZakfq8cAgAAIk4CAAAEWAIAABiwAgAAEN4A=
Date:   Thu, 30 Jul 2020 07:50:39 +0000
Message-ID: <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
In-Reply-To: <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:2449:b801:cf45:be14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c325b860-ce6e-4b6b-d98b-08d8345d4113
x-ms-traffictypediagnostic: BYAPR05MB4709:
x-microsoft-antispam-prvs: <BYAPR05MB47096BD7CBD32C5CEFD22858D0710@BYAPR05MB4709.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQLlWbudPgisxnPts5zb/ksH8prpmnmphcj+g2+zp1pfTcWumfGClwKCLQX6yiqqk2eaKL159ChOAeUsHugZEmtoV44yuLP2UTK7ppGeQSp6ut49heutTQ/Mp2nHYb9d0uNY9h6W7H6gJyhO8NcSnRhNT6MhnTJcS+Rdvt0NMugow3YoMt+0GKgKdPkZvmT0VQV0l5RGGj48e9XHBLAWqepdkavCR4y30IpQCTp2J0FnJaHwvprNivsXwgmrE8J4AljnDVshRWtvsY/9KCE54oXoaGdp5QbA3D9LA6jgLynEykWhQQe4IfVX+yJuNpsdbsrJNVlNily3XaebGduHi14KEe9uHlJZ4apYBA2lPLruSjWsUG0HLZS17usooLZ3j5IIoUqurz3Ot0vEpy/OCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(7416002)(54906003)(6506007)(53546011)(316002)(6486002)(186003)(6512007)(2616005)(36756003)(8936002)(2906002)(4326008)(8676002)(66476007)(478600001)(76116006)(66556008)(66946007)(64756008)(66446008)(5660300002)(66574015)(83380400001)(966005)(71200400001)(33656002)(6916009)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: O6Oz2dVSkDMwHN7vRnfM3qaNTEoASPL3h9rjJsxKPnM85mlGNjytToLpBa9tOOQWf/wOaRqvf8V1BExQG1ODF+mxyxBkNCrZRFSo2X+JFB7TAbf+yxQGbS7aSLYiw9jYlgroLS8QTca70xC7/jeSFA653bnnqpmT3B15DjAiygSstGJjqZsceR5yiRbGf+3mG3cLulJQNOgxbLU728RKItNCjWjeJfPmEJdAK5PndhK0f+YdnlKnO2A8Qj3mECAoCgoOOMS+KZpZIlWqAJQ7Z5nBl1trrNlu8AC5TyboTkwZHAJswfQ7QVjuyHVLmQm5as7uEVQ0lPdonqtaxt7lZlQHhePMXJQm2H3rI4afUmSfupYHoquzd2lNtsXD3OgNzGuu+sVYF1qzrLhn8Z3oGCqiAocBZvTmy7fFc5A880T6jRxLOBQxaV831J+0RVplw2wywQr/ldcZEfUjtZ90JVdA6sT5/eAt/AM5JDWbDNMcK4AgSSm1UJdOVxaCbDwbrmh5xeVEbmB6okPMKNDRWiEGI7Ug6krk/5MmsAtnarRItWfoiiNQWUkcGvYCD+0SdEH7IEeBLCjEsTASFexOrYNCO+AhbsQbKk3XPVyCJEQLI7byGmTxh9AX+xylhggqUAyvoZoY27dgiNQs7hU5gh+0nAa9qsNQWCvkwbi53Tf0/agXA8hGvyXS1CiXbxjzmo278kWDaf7MPz6ORbVrbw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E21D088C34C4649B51AF1B989BB8CD5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c325b860-ce6e-4b6b-d98b-08d8345d4113
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 07:50:39.9439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9qHG6KXrzvraZzB5jEhIX6eCbeTClNbb9YFOrMnnAXmj/LKWDOorrE7jiXbL9MPKYqu6g/3wZWeU2T+ZaESVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4709
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMzAsIDIwMjAsIGF0IDEyOjM1IEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDMwLzA3LzIwIDA5OjEzLCBXYW5wZW5nIExpIHdy
b3RlOg0KPj4+PiBJIHBlcnNvbmFsbHkgZGlzbGlrZSByZW5hbWVzIGFzIHlvdSB3aWxsIGhhdmUg
b2xkIHJlZmVyZW5jZXMgbHVya2luZyBpbg0KPj4+PiB0aGUgaW50ZXJuZXQgZm9yIGRlY2FkZXMu
IEEgcmVuYW1lIHdpbGwgcmVzdWx0IGluIHBlb3BsZSBjb250aW51ZSB0byB1c2luZw0KPj4+PiB0
aGUgb2xkIGNvZGUgYmVjYXVzZSB0aGUgb2xkIG5hbWUgaXMgdGhlIG9ubHkgdGhpbmcgdGhhdCB0
aGV5IGtub3cuDQo+Pj4gDQo+Pj4gKzEgZm9yIGtlZXBpbmcgdGhlIG9sZCBuYW1lLg0KPj4+IA0K
Pj4+IGNwdS11bml0LXRlc3RzIG1pZ2h0IGFsc28gbm90IGJlIGNvbXBsZXRlbHkgZml0dGluZyAo
SSByZW1lbWJlciB3ZQ0KPj4+IGFscmVhZHkgZG8gdGVzdCwgb3Igd2lsbCB0ZXN0IGluIHRoZSBm
dXR1cmUgSS9PIHN0dWZmIGxpa2UgUENJLCBDQ1csIC4uLikuDQo+Pj4gDQo+Pj4gSU1ITywgSXQn
cyBtdWNoIG1vcmUgYSBjb2xsZWN0aW9uIG9mIHRlc3RzIHRvIHZlcmlmeQ0KPj4+IGFyY2hpdGVj
dHVyZS9zdGFuZGFyZC93aGF0ZXZlciBjb21wbGlhbmNlIChpbmNsdWRpbmcgcGFyYXZpcnR1YWxp
emVkDQo+Pj4gaW50ZXJmYWNlcyBpZiBhdmFpbGFibGUpLg0KPiANCj4gR29vZCBwb2ludC4NCj4g
DQo+PiBWb3RlIGZvciBrZWVwaW5nIHRoZSBvbGQgbmFtZS4NCj4gDQo+IE9rLCBzbyBlaXRoZXIg
b2xkIG5hbWUgb3IgYWx0ZXJuYXRpdmVseSBhcmNoLXVuaXQtdGVzdHM/ICBCdXQgdGhlDQo+IG1h
am9yaXR5IHNlZW1zIHRvIGJlIGZvciBrdm0tdW5pdC10ZXN0cywgYW5kIGlmIE5hZGF2IGhhcyBu
byB0cm91YmxlDQo+IGNvbnRyaWJ1dGluZyB0byB0aGVtIEkgc3VwcG9zZSBldmVyeW9uZSBlbHNl
IGNhbiB0b28uDQoNCkluZGVlZC4gTXkgZW1wbG95ZXIgKFZNd2FyZSkgZGlkIG5vdCBnaXZlIG1l
IGhhcmQgdGltZSAoc28gZmFyKSBpbg0KY29udHJpYnV0aW5nIHRvIHRoZSBwcm9qZWN0IGp1c3Qg
YmVjYXVzZSBpdCBoYXMgS1ZNIGluIGl0cyBuYW1lLiBXZSAoVk13YXJlKQ0KYWxzbyBiZW5lZml0
IGZyb20ga3ZtLXVuaXQtdGVzdHMsIGFuZCBQYW9sbyBhbmQgb3RoZXJzIHdlcmUgcmVjZXB0aXZl
IHRvDQpjaGFuZ2VzIHRoYXQgSSBtYWRlIHRvIG1ha2UgaXQgbW9yZSBrdm0vcWVtdSAtaW5kZXBl
bmRlbnQuIFRoaXMgaXMgd2hhdA0KbWF0dGVycy4NCg0KU28gSSBhbSBvayB3aXRoIHRoZSBuYW1l
IGJlaW5nIGt2bS11bml0LXRlc3RzLiBCdXQgSSB3b3VsZCBhc2svcmVjb21tZW5kDQp0aGF0IHRo
ZSBwcm9qZWN0IGRlc2NyaXB0aW9uIFsxXSBiZSB1cGRhdGVkIHRvIHJlZmxlY3QgdGhlIGZhY3Qg
dGhhdCB0aGUNCnByb2plY3QgaXMgaHlwZXJ2aXNvci1hZ25vc3RpYy4NCg0KVGhpcyBzaG91bGQg
aGF2ZSBwcmFjdGljYWwgaW1wbGljYXRpb25zLiBJIHJlbWVtYmVyLCBmb3IgZXhhbXBsZSwgdGhh
dCBJIGhhZA0KYSBkaXNjdXNzaW9uIHdpdGggUGFvbG8gaW4gdGhlIHBhc3QgcmVnYXJkaW5nIOKA
nHhwYXNz4oCdIGJlaW5nIHJlcG9ydGVkIGFzIGENCmZhaWx1cmUuIFRoZSByYXRpb25hbGUgd2Fz
IHRoYXQgaWYgYSB0ZXN0IHRoYXQgaXMgZXhwZWN0ZWQgdG8gZmFpbCBvbiBLVk0NCihzaW5jZSBL
Vk0gaXMga25vd24gdG8gYmUgYnJva2VuKSBzdXJwcmlzaW5nbHkgcGFzc2VzLCB0aGVyZSBpcyBz
b21lIHByb2JsZW0NCnRoYXQgc2hvdWxkIGJlIHJlcG9ydGVkIGFzIGEgZmFpbHVyZS4gSSB3b3Vs
ZCBhcmd1ZSB0aGF0IGlmIHRoZSBwcm9qZWN0IGlzDQpoeXBlcnZpc29yLWFnbm9zdGljLCDigJx4
cGFzc+KAnSBpcyBub3QgYSBmYWlsdXJlLg0KDQpTbyBpdCBpcyBtdWNoIG1vcmUgaW1wb3J0YW50
IGhvdyB0aGUgcHJvamVjdCBpcyBkZWZpbmVkIHRoYW4gaG93IGl0IGlzDQpuYW1lZC4NCg0KWzFd
IGh0dHA6Ly93d3cubGludXgta3ZtLm9yZy9wYWdlL0tWTS11bml0LXRlc3Rz
