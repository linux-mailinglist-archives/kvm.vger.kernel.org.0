Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47662337C6
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 19:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgG3Rgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 13:36:46 -0400
Received: from mail-eopbgr770057.outbound.protection.outlook.com ([40.107.77.57]:62870
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727080AbgG3Rgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 13:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qk2wgpWvpHra3oSGaV3KooxDv3iPnjVYNUSp5dzxbqA4QCOtpjJo9NutUtCDbQbqQkzxytN2yoJT4V6ufMmhGcLWPQqKhDAYmAm4C+rLctJBGtCXb0cNv4/3fBNZQyMFGyazdvLJMofTEfCOQDEJIILVr5Ca5dPILdAETZ6Il0/yB96gZpBHOBgF8CAQoUPygqIBm16ikbPy1UiC6ONLr89HBL5kR3OBjSsYJy1u8JdROhcJYBqlhYLrq/uext8sJ0SDZqN6zI8YBj/Eqf0UPsn59qp8ydg/WhFXzkc5+0Q35YENfYrFDPnUvsFF6JtmwdyPyNKxDKXOX7j9hFun7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYGlhh/Lx0j2n6eR/tg/ymss0HwDw36Rc9NbO1CSWqU=;
 b=lLpIpa3h9w+NIh3yoxXKLLK4jKzMzwnSHTlCcprO/IAQHPNRrTRv21W4PBUQRMc0k7TzMW5JZAUxJwC3HyU1mDeI3m8GCAkS6wJ+6Oa5fgw+sAVjOY6sbC49WBuIsa6naI0Fus1U/Kfefcoww/nkFxHPtE71KmKq8w/8tJTV08udI3aqKrcXmybX2IpytcmZnLe28y98d5FEflviSJs0ffW4EL1so5zZq2lkcbTOAiEJlIW+EwjzV0AIc5f9nHufOeVd/F3BXt4mVFlEbA9y0cNcAiaGGBxKwMoiJNNbXAuJXJLJ3XO2nXCcZKScrYW0vDqldUACefEk7CTDf0r7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYGlhh/Lx0j2n6eR/tg/ymss0HwDw36Rc9NbO1CSWqU=;
 b=06IsDw0i9UhGz6D+oY0CNBu+jndxcD3VrlTP5ub2aKwx9npfZRnSPx1sXUqd8Y6/fGccyIuJwtN9qXTeCS12Ar6EGLf4bRVEJQVYHx+l0neQZNjIzH/omv7/D3FKhohGbSBYZIqZd8YQVqxS5P0yi8up+fZ65Dj4neQrNE6F1oE=
Received: from BL0PR05MB4772.namprd05.prod.outlook.com (2603:10b6:208:29::17)
 by BL0PR05MB4820.namprd05.prod.outlook.com (2603:10b6:208:5d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9; Thu, 30 Jul
 2020 17:36:42 +0000
Received: from BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::692d:b0ee:1561:60be]) by BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::692d:b0ee:1561:60be%3]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 17:36:42 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Andrew Jones <drjones@redhat.com>,
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
Thread-Index: AQHWZjQkZcbo6dMKYUqQXELtxmgWZakfq8cAgAAIk4CAAAEWAIAABiwAgAAEN4CAAD3qgIAAZMqAgAAAp4CAAABgAA==
Date:   Thu, 30 Jul 2020 17:36:42 +0000
Message-ID: <EA3D04A5-3144-4F0B-B7D5-A99DB0FC4818@vmware.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
 <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
 <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
 <CA3B8C12-0421-489C-A135-3D97D58D9D5F@vmware.com>
 <2b07717e-3716-cc55-8f1b-8047a318c1f2@redhat.com>
In-Reply-To: <2b07717e-3716-cc55-8f1b-8047a318c1f2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [24.4.128.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32784e24-af4e-4a83-e84b-08d834af1f6e
x-ms-traffictypediagnostic: BL0PR05MB4820:
x-microsoft-antispam-prvs: <BL0PR05MB482065DC29FD37AADA028A19D0710@BL0PR05MB4820.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SFn433ZI0Tu2HDjy6SnhVljDIxGG40GbwszLqg8yh/0oCgtslobsjliPeR2LP0Wjq/tsdtodsBdhvEV3PUukhp+lanmyNa59sd4T0rNkS/V5E37Q1QS4eupfbXCKIliGUW/VgBzoxs/lQ5UApzq+JWZOHewMaEhJJsi35TtwhLFXElxeaYYnEkOuJDCSN1U9UISRercQ9QnZTY2of4lHd53mbtlUlpVrh3BSAA1quBjTZRWLQXdpzCXCCa88uXUCU/qIVFSZLLXNYtQ236Kn8xKjTAeHAclOsnldlCsuXmfLbmTkIGUEJ5lyMnioBBsHP3vZwLzpTrWhEGbBL0WlEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB4772.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(4326008)(8676002)(8936002)(33656002)(186003)(54906003)(26005)(2616005)(6512007)(6506007)(6916009)(76116006)(2906002)(91956017)(53546011)(71200400001)(7416002)(4744005)(5660300002)(86362001)(66556008)(478600001)(36756003)(66476007)(66946007)(316002)(64756008)(66446008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8o4B3wSiyB/qQBxNfE41TISut3Fzi11/Ixj16fpfk5rDtCkXDsbCchF7Yd7VlgM5tR4VizqwRyzM/XGfF2hguOUK7qLeVqIX6QzaDPRGEMm9Ha6BvKGjjmM4pzARKjRrAbZzNOEZ4Cr3Rsdt+bnd6cC6jB1as7r99pwW9+uWAtfQqHzxWiZxsq6m9ubqw/fhcaIOqCHAUDi5fT17yYv5XBovkwKInY3zdenGzzbM2YtVQMIeXkr771zeWQKaRBfcNxTCo9anavYlskNN4EmV2a90WgqQohgcek7dz92l7BzdNHuCqtFc22DANIRtoOegTxNnFTBged42BIItna4nFjrUkE49rLA0SaVkSbzmtWfgtKSXX2g48W591DdCLoc8kNwWHPxZdBUZrWWkFaUyfZ3pBYbu9BCAcC7PH1HyNrxLep4YkLXUIWRGvNVICrK1s+IfrxzNtSCNY1+mBFN3vDmr3F0D5mI2n6galWMjAiqvEJ/Fik0kZvqTqZtCyfS/uqeDOnrOPAq9xOzOrZ+aDg+j9fMmTq4uMsyv+Y3v3CyjXJ+tyMH3X3AnezaOj3RYBnWJJ4JdSSE7kkdFosXz04idFySj8Ap1MrsMIbQgRrurolo7HEJQrHe9hV8SlIPozow+iowjvTO2i7zHOheAMA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <13EEC804BB36F049B41025B7DDA5AE02@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB4772.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32784e24-af4e-4a83-e84b-08d834af1f6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 17:36:42.2189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4lK4AnFPrXQJE0O9tWRkM912LhDeNoUUOfWB9FIRY7u88gls6aqHNKB3I9FCtwvpfi3ow9rimtqP5pWYs18wcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4820
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMzAsIDIwMjAsIGF0IDEwOjM1IEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDMwLzA3LzIwIDE5OjMyLCBOYWRhdiBBbWl0IHdy
b3RlOg0KPj4+IFdlIGNhbiB1c2UgY29tcGlsZS10aW1lIG9yIHJ1bi10aW1lIGxvZ2ljIHRoYXQg
ZGVwZW5kcyBvbiB0aGUgdGFyZ2V0IHRvDQo+Pj4gZGVjaWRlIHdoZXRoZXIgYSB0ZXN0IHNob3Vs
ZCBiZSBhIG5vcm1hbCB0ZXN0IChwYXNzL2ZhaWwpIG9yIGFuDQo+Pj4geHBhc3MveGZhaWwgdGVz
dC4NCj4+IFRoaXMgaXMgc2ltcGxlLiBXaGVuIEkgZmluZCBzb21lIHRpbWUsIEkgd2lsbCBzZW5k
IHNvbWUgcGF0Y2hlcyBmb3IgdGhhdC4NCj4gDQo+IE5vdCB0b28gcXVpY2ssIGxldCdzIGZpcnN0
IGxvb2sgYXQgYSBkZXNpZ24uDQoNCkRvbuKAmXQgd29ycnksIEkgYW0gYnVzeSA7LSkNCg0KVGhl
IHN1YnRleHQgb2YgbXkgcmVzcG9uc2Ugd2FzIHRoYXQgYSBmdWxseSBmbGVkZ2VkIGVycmF0YSBt
ZWNoYW5pc20gaXMgbW9yZQ0KY29tcGxpY2F0ZWQuDQoNCg==
