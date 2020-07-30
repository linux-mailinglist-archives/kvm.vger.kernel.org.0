Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D808A2337B8
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgG3RdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 13:33:04 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:46816
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730199AbgG3RdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 13:33:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggSk7qtiwri68cY0osmzKVIZj2TgN2zvU4/KX5N+aBE3dt27zJci2pcFphWmpcX/2tHDzD94bRDMCn6Md8P/JcHLLn70VxSz6oiC9M0TKmm+rOxkNpydUMVt2bFXYTFb5dUdpBflvodGprr1ptCpO7qo7utTX+v0cMBMUFazI1mVxYCFiE+Sr3klL+Ej8AWXagxDv+mwpwHvwCiyTCmQsdlcfSlmqqprND7dkeNkZiqLRWfMivkKI9lTS7vRM273SkQkXn0yvqCRmaTDqLLwjYkycz+f+wl1K7n40a19pQ5IMkrYtZXh4H5hJbg3hdKLhXUPKOrNUDLeLc21P8thPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmOI57bPXAL4Rnmu5p1y9nN5SLFnlVHgi98ffMGjcLo=;
 b=cZp3hlRElc8BAPE/EDs3/7LiSvK0XEcJpjyie0Bl1j+aX/dOJeu5V+2l02cDGhTfPj38PJuyWHdWNA53J3z9NZZsQZcUI4Gv7r4Ed9WCu9rlltvwe8hAJKHgW7XUvqBt6BR3PvMt6CJDp5+8pQ7uS6rIwQZVtwkZ5V5fPu3Fn96OhBNEIEokEEOlkdCMi1Bkc8l1S5Wuh1VgFRwbNDvuWxVc7/GdOVaS9EGXti6V3dbGxQeowj0Svwn8a7lRSNSSYGwjXwLTYK3PgLNgVZDhS7Lsde8zjjQcaPM5USav6firwXwi5572EtR+zgzU5KrbQGZ4NjhuFym28XQ3krFU5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmOI57bPXAL4Rnmu5p1y9nN5SLFnlVHgi98ffMGjcLo=;
 b=AEQJM4hMh/r45ltqRtSzKGbxLvLuHFoZVm7xpoKVZf/V6LmdHMIXBCFkUxIqLzidPNnn0dQmqxgrsG8j38SW2ZU3ExVidReUpjV/F3k2VQAJ0b9tukYQqYQE4ctqve4lVk5Muh2vc84V3t7ls0dydmpm/e62QKgSIw2uLlPe0xY=
Received: from BL0PR05MB4772.namprd05.prod.outlook.com (2603:10b6:208:29::17)
 by BL0PR05MB6737.namprd05.prod.outlook.com (2603:10b6:208:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9; Thu, 30 Jul
 2020 17:33:00 +0000
Received: from BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::692d:b0ee:1561:60be]) by BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::692d:b0ee:1561:60be%3]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 17:33:00 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <drjones@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: A new name for kvm-unit-tests ?
Thread-Topic: A new name for kvm-unit-tests ?
Thread-Index: AQHWZjQkZcbo6dMKYUqQXELtxmgWZakfq8cAgAAIk4CAAAEWAIAABiwAgAAEN4CAAD3qgIAAZMqA
Date:   Thu, 30 Jul 2020 17:32:59 +0000
Message-ID: <CA3B8C12-0421-489C-A135-3D97D58D9D5F@vmware.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
 <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
 <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
In-Reply-To: <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:2449:b801:cf45:be14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af93a637-faca-4abf-f8f2-08d834ae9af4
x-ms-traffictypediagnostic: BL0PR05MB6737:
x-microsoft-antispam-prvs: <BL0PR05MB673790B749F1A3A9F3FAE7C1D0710@BL0PR05MB6737.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xeV44PonmKXw5aCQ8vP+86UEIlboUqSgndiyMl1JfDwSZWXuE2MrPpE0LyzpVKOvhxb0E7T5MfLb3D5alKU5ft+jehW0C7+esuGNlUYXeHx70YtwSRJ/RAU4Pm9ohUcwkg5L64rxec6+WR13I0JVssdtj/KF/U/WJJO9rlbuS5b84LUXU62u7T3wSsqYNaoRjRuQbcaH/AYV0Z86Egi4/G5RdxEspF3eGMND1Y8scNU4zdi1/8BkAkHEfYgS9KS3iAKvopCpRCV3ENH7mWjBngSe068w3upprtjod0t3BXHprDo6or00sLKHnro/kxjzpOp6TCoqkgYV6LkF5vBLRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB4772.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(66476007)(66556008)(91956017)(66446008)(76116006)(66946007)(54906003)(8676002)(7416002)(64756008)(36756003)(316002)(6512007)(2906002)(71200400001)(33656002)(2616005)(6916009)(6506007)(66574015)(86362001)(6486002)(5660300002)(186003)(478600001)(83380400001)(53546011)(4326008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XFbauPhwz+qdNhhs7CF/0SCvXpPIJwEURbBmrSpc7jddT1Vn5YHjLUl+wtJOeHHV5vBx9yo8u66HQysKBtGb6QzfEqIGQLB1N4jwd4WJ2k6Zgc57YySh0m6mzxY2klqpm/FMWqWooTs/L/tEdL8gUI3YkwwrMSgq6CRt6bdyQfc+5nSu1oyae6znR/H1V6nLw6UVgT/dLncGM+0ALqIJSC5E17p+81F6FnO2II3TGHXr+z3Ateg5OcKTzQ43gU4SZvEsWmfRZXjApchUFRrBFSl8oLSw/GpUriSb5+zF1NRcfftdLnQ6w0b5O+kDqOZH8e8KdQHAk4jNRCInsc5JNGVJ9RBjzVjyHVxDXAN2V3y5yydgc/f7KkKh4ATg2nuL7PN6ptf1As5aSbfyWeNYR7swgbC75qhyGmLcnf+0RQMY0ygMFpfpFXP+MGEP7PaQlJ01iwVkW5cqONw659umm04Pzl0QdaAV/M2v2RRp92eLVDcGGsY+ruQ3DacKIW2Vi59qMEyjSRVik2gC0DrG+szynOPfuJ4pu38gko1DrPjLbOUmfFIVHx9VZVm/qLajbY1sednePeWe0lTFUDAJPEgim5HasqIt/b09T2k6uGqGJWs24XWc4ykZJytZKfqqlAXvR2tt8WcWEk1lYPlefw/0wIW2rRXfbTy/KOo7KO9Rh45b61qA/LCcID70I8e4DzM93wWr/jvyc617oEt3NQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF8EB61A9CADBE4696E8C109EF029AD7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB4772.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af93a637-faca-4abf-f8f2-08d834ae9af4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 17:32:59.9556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nH3KekhD9uWvHXG25Oqm9TElrGhn041fK/xAstHYabh9/iIdvJM1Gz7DsKH+r8AMyP6I77gmcJ1uOcoYO/fueg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB6737
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMzAsIDIwMjAsIGF0IDQ6MzIgQU0sIEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRo
YXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgSnVsIDMwLCAyMDIwIGF0IDA3OjUwOjM5QU0g
KzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+Pj4gT24gSnVsIDMwLCAyMDIwLCBhdCAxMjozNSBB
TSwgUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4g
T24gMzAvMDcvMjAgMDk6MTMsIFdhbnBlbmcgTGkgd3JvdGU6DQo+Pj4+Pj4gSSBwZXJzb25hbGx5
IGRpc2xpa2UgcmVuYW1lcyBhcyB5b3Ugd2lsbCBoYXZlIG9sZCByZWZlcmVuY2VzIGx1cmtpbmcg
aW4NCj4+Pj4+PiB0aGUgaW50ZXJuZXQgZm9yIGRlY2FkZXMuIEEgcmVuYW1lIHdpbGwgcmVzdWx0
IGluIHBlb3BsZSBjb250aW51ZSB0byB1c2luZw0KPj4+Pj4+IHRoZSBvbGQgY29kZSBiZWNhdXNl
IHRoZSBvbGQgbmFtZSBpcyB0aGUgb25seSB0aGluZyB0aGF0IHRoZXkga25vdy4NCj4+Pj4+IA0K
Pj4+Pj4gKzEgZm9yIGtlZXBpbmcgdGhlIG9sZCBuYW1lLg0KPj4+Pj4gDQo+Pj4+PiBjcHUtdW5p
dC10ZXN0cyBtaWdodCBhbHNvIG5vdCBiZSBjb21wbGV0ZWx5IGZpdHRpbmcgKEkgcmVtZW1iZXIg
d2UNCj4+Pj4+IGFscmVhZHkgZG8gdGVzdCwgb3Igd2lsbCB0ZXN0IGluIHRoZSBmdXR1cmUgSS9P
IHN0dWZmIGxpa2UgUENJLCBDQ1csIC4uLikuDQo+Pj4+PiANCj4+Pj4+IElNSE8sIEl0J3MgbXVj
aCBtb3JlIGEgY29sbGVjdGlvbiBvZiB0ZXN0cyB0byB2ZXJpZnkNCj4+Pj4+IGFyY2hpdGVjdHVy
ZS9zdGFuZGFyZC93aGF0ZXZlciBjb21wbGlhbmNlIChpbmNsdWRpbmcgcGFyYXZpcnR1YWxpemVk
DQo+Pj4+PiBpbnRlcmZhY2VzIGlmIGF2YWlsYWJsZSkuDQo+Pj4gDQo+Pj4gR29vZCBwb2ludC4N
Cj4+PiANCj4+Pj4gVm90ZSBmb3Iga2VlcGluZyB0aGUgb2xkIG5hbWUuDQo+Pj4gDQo+Pj4gT2ss
IHNvIGVpdGhlciBvbGQgbmFtZSBvciBhbHRlcm5hdGl2ZWx5IGFyY2gtdW5pdC10ZXN0cz8gIEJ1
dCB0aGUNCj4+PiBtYWpvcml0eSBzZWVtcyB0byBiZSBmb3Iga3ZtLXVuaXQtdGVzdHMsIGFuZCBp
ZiBOYWRhdiBoYXMgbm8gdHJvdWJsZQ0KPj4+IGNvbnRyaWJ1dGluZyB0byB0aGVtIEkgc3VwcG9z
ZSBldmVyeW9uZSBlbHNlIGNhbiB0b28uDQo+PiANCj4+IEluZGVlZC4gTXkgZW1wbG95ZXIgKFZN
d2FyZSkgZGlkIG5vdCBnaXZlIG1lIGhhcmQgdGltZSAoc28gZmFyKSBpbg0KPj4gY29udHJpYnV0
aW5nIHRvIHRoZSBwcm9qZWN0IGp1c3QgYmVjYXVzZSBpdCBoYXMgS1ZNIGluIGl0cyBuYW1lLiBX
ZSAoVk13YXJlKQ0KPj4gYWxzbyBiZW5lZml0IGZyb20ga3ZtLXVuaXQtdGVzdHMsIGFuZCBQYW9s
byBhbmQgb3RoZXJzIHdlcmUgcmVjZXB0aXZlIHRvDQo+PiBjaGFuZ2VzIHRoYXQgSSBtYWRlIHRv
IG1ha2UgaXQgbW9yZSBrdm0vcWVtdSAtaW5kZXBlbmRlbnQuIFRoaXMgaXMgd2hhdA0KPj4gbWF0
dGVycy4NCj4+IA0KPj4gU28gSSBhbSBvayB3aXRoIHRoZSBuYW1lIGJlaW5nIGt2bS11bml0LXRl
c3RzLiBCdXQgSSB3b3VsZCBhc2svcmVjb21tZW5kDQo+PiB0aGF0IHRoZSBwcm9qZWN0IGRlc2Ny
aXB0aW9uIFsxXSBiZSB1cGRhdGVkIHRvIHJlZmxlY3QgdGhlIGZhY3QgdGhhdCB0aGUNCj4+IHBy
b2plY3QgaXMgaHlwZXJ2aXNvci1hZ25vc3RpYy4NCj4gDQo+IEdvb2QgaWRlYS4gQWx0aG91Z2gg
d2hpbGUgSSBhdXRob3JlZCB3aGF0IHlvdSBzZWUgdGhlcmUsIEkgZG9uJ3QgcmVhbGx5DQo+IHdh
bnQgdG8gc2lnbiB1cCB0byBkbyBhbGwgdGhlIHdyaXRpbmcuIEhvdyBhYm91dCB3aGVuIHdlIGNy
ZWF0ZSB0aGUgZ2l0bGFiDQo+IHByb2plY3Qgd2UgYWxzbyBjcmVhdGUgYSAubWQgZmlsZSB0aGF0
IHdlIHJlZGlyZWN0IFsxXSB0bz8gVGhlbiBhbnlib2R5DQo+IGNhbiBzdWJtaXQgcGF0Y2hlcyBm
b3IgaXQgZ29pbmcgZm9yd2FyZC4NCg0KRmluZSB3aXRoIG1lLiBSaWdodCBub3cgdGhlIFJFQURN
RS5tZCBwcmV0dHkgbXVjaCByZWRpcmVjdHMgdG8gWzFdIGluIHJlZ2FyZA0KdG8gdGhlIHByb2pl
Y3QgZGVmaW5pdGlvbi4NCg0KPj4gVGhpcyBzaG91bGQgaGF2ZSBwcmFjdGljYWwgaW1wbGljYXRp
b25zLiBJIHJlbWVtYmVyLCBmb3IgZXhhbXBsZSwgdGhhdCBJIGhhZA0KPj4gYSBkaXNjdXNzaW9u
IHdpdGggUGFvbG8gaW4gdGhlIHBhc3QgcmVnYXJkaW5nIOKAnHhwYXNz4oCdIGJlaW5nIHJlcG9y
dGVkIGFzIGENCj4+IGZhaWx1cmUuIFRoZSByYXRpb25hbGUgd2FzIHRoYXQgaWYgYSB0ZXN0IHRo
YXQgaXMgZXhwZWN0ZWQgdG8gZmFpbCBvbiBLVk0NCj4+IChzaW5jZSBLVk0gaXMga25vd24gdG8g
YmUgYnJva2VuKSBzdXJwcmlzaW5nbHkgcGFzc2VzLCB0aGVyZSBpcyBzb21lIHByb2JsZW0NCj4+
IHRoYXQgc2hvdWxkIGJlIHJlcG9ydGVkIGFzIGEgZmFpbHVyZS4gSSB3b3VsZCBhcmd1ZSB0aGF0
IGlmIHRoZSBwcm9qZWN0IGlzDQo+PiBoeXBlcnZpc29yLWFnbm9zdGljLCDigJx4cGFzc+KAnSBp
cyBub3QgYSBmYWlsdXJlLg0KPiANCj4gV2UgY2FuIHVzZSBjb21waWxlLXRpbWUgb3IgcnVuLXRp
bWUgbG9naWMgdGhhdCBkZXBlbmRzIG9uIHRoZSB0YXJnZXQgdG8NCj4gZGVjaWRlIHdoZXRoZXIg
YSB0ZXN0IHNob3VsZCBiZSBhIG5vcm1hbCB0ZXN0IChwYXNzL2ZhaWwpIG9yIGFuDQo+IHhwYXNz
L3hmYWlsIHRlc3QuDQoNClRoaXMgaXMgc2ltcGxlLiBXaGVuIEkgZmluZCBzb21lIHRpbWUsIEkg
d2lsbCBzZW5kIHNvbWUgcGF0Y2hlcyBmb3IgdGhhdC4NCg0KUmVnYXJkcywNCk5hZGF2DQoNCg==
