Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0D47979D
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 22:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390728AbfG2TvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 15:51:05 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9311 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390475AbfG2TvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564429864; x=1595965864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NO/0MsVKP71zr1N2x8BGfD/IHsCvghxnvN3rCJWUCV4=;
  b=rF+kku+uIsR7p4jUINCVC7nhz+q8oLp6TATcOp7NLpIs4utwijnVExVw
   00NimPqLsePo6b+fpN0+sTwz9zioek9Pjmm+92wKcXHQPLCGV4CqoIq3X
   L0FZcVm4FstL+Q5qzk8gQMc2SafQVJ6a1rc7F5JpHfQZiDSZMPN9kaUmP
   JTn4rimrvb0Uf32jsuXNHjwp92guNEMS7s4dshflJFDHcSl7WCKTTBpLP
   LYHUo/VRN93GvKV1hC/3cHJkPsTeLJ7JN7hMhn+Cgfrd02quwtSiNbDqr
   3orAXFqmePWbPn4e80JtC7to4n9f+6pIM+KoOmDpeV/IQlrxvV0jXwPkO
   A==;
IronPort-SDR: gJZs9x29wo72RQLI5rHcDPbrbC+rxWTNycBh2lgauP5bp3kZ6zV6r2d2ehN4X45ps814+UglE/
 FapRe4G+Kx97XUkWbYHrLsqlW0ATCarPQRvU+HRsN8XQFmlwgaV3z4vJG/ObDuZX6V1C2A3KWa
 YcAORgXb7hEtPcw6/C9bXEAD2XQE2OmCU0RvDzOu6+XeYPbf8OaVn2nX7Jzl7eXJfNUtIv9vWp
 9A9p2sX72ooIqynOw9da9YHeu/SFymyK+c8OF+IMHBD0U+t55fpIgODW6DZ5+FXpUljBI0sj2H
 nDA=
X-IronPort-AV: E=Sophos;i="5.64,324,1559491200"; 
   d="scan'208";a="115439495"
Received: from mail-sn1nam01lp2057.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.57])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2019 03:51:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnpB+bVzG1zFbSj/AnvYkVjUPu7zwtioqYeLvw5t4VCJZUKebAo5M9Lpu0kQvW7pmG27XdQXMYC3ArfFVszOGRTaPAbS5D/esh/G26T6Dcy+/dBgN5yRffVRG9BzJxu/UwPmfXkmSmlkxcFwYzCq99SINAW5tdoE3BDwgH5DQTf1kvAdJg5NHhTlEvTqhg/pfyLQF4gLq+Jta3AfX+0YnY4Rr4gjo66uH80NJi5rTjogNwmKp85OKDjgG+2+cC4erceB4XIVsRVKXUboXP80qdhX7k4TfU9Lmves2YFB4GQAnYrNd2Me0nLJdfGfU8bLSz4FWmgOSA0e7E5cujpF2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO/0MsVKP71zr1N2x8BGfD/IHsCvghxnvN3rCJWUCV4=;
 b=gZ1kLnDO5cdfAhPuhMCgQqyk/qpEclkHBcZ0AynVl/DXQYM9AGR6GYbxE315k/rM7niO4+FsxAGx8J/iH3o2q3ZFJN/kkN9e5oHBTA3gwzCIjfuf8HwgIV/+/I+Z9WrZdkUkEz+TSYDJcZJunVNMhdi9UlExG5AIjoUFH3WJQwYFiZLZQ7YQybHgSWNE8AqE+nCyTc9Nc6PNMA3Q+mvBRifGAtqsxbUOxDpQRc2qvHWcNghxM8/vu4bIuBry3iPg8FNMfBCC8KDEODgbHjdrrkWRmBeT1bBIk04s2eCeulzePbE6xZWdU227YyWPquX0Hv94jUnkAxf5fMXt6yxugQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO/0MsVKP71zr1N2x8BGfD/IHsCvghxnvN3rCJWUCV4=;
 b=lHaOAAdJ2eOWrESvG9cywMLVCDVHtLNk04JFk1Ln51tX1g05K1DogVIgfSV/Ub16AfG4aTu6Z+FdCnPqcii7YHAf3ouIWiuIe5xUBtbS0lreZ/gipNlAH3SNrF2RY2LLYlR9QN3tk9Q9+voK/cYMt5gu6UjwQDCE94AyNcwQuXM=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB5432.namprd04.prod.outlook.com (20.178.51.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 19:51:00 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 19:51:00 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVRgTdLbP8aD0d50+SPOvQQEaYeqbh/v2AgAAC3IA=
Date:   Mon, 29 Jul 2019 19:51:00 +0000
Message-ID: <0e19ff14a51e210af91c4b0f2e649b8f5e140ce1.camel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
         <20190729115544.17895-16-anup.patel@wdc.com>
         <b461c82f-960a-306e-b76b-f2c329cabf21@redhat.com>
In-Reply-To: <b461c82f-960a-306e-b76b-f2c329cabf21@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.45.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb898cc9-e796-4736-6019-08d7145e14e5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5432;
x-ms-traffictypediagnostic: BYAPR04MB5432:
x-microsoft-antispam-prvs: <BYAPR04MB54328E32EF693A367280E483FADD0@BYAPR04MB5432.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(189003)(199004)(476003)(446003)(11346002)(53546011)(186003)(256004)(2616005)(66066001)(26005)(66556008)(66946007)(36756003)(102836004)(486006)(6506007)(118296001)(305945005)(76116006)(64756008)(86362001)(25786009)(66446008)(76176011)(14454004)(7736002)(99286004)(71190400001)(71200400001)(66476007)(478600001)(5660300002)(4744005)(53936002)(2501003)(7416002)(68736007)(4326008)(2906002)(6116002)(2201001)(6512007)(110136005)(229853002)(6486002)(6436002)(6636002)(8936002)(8676002)(81166006)(54906003)(81156014)(6246003)(3846002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5432;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dY9cpiUkzq9jMG/mBMslqduUDYmYHXcP0wHC0LpH1v4+72janntXmVUGi0U1qMAa3o9BVTM3zsdYSRmZnv9id5n3bbJRePR2i03qsYY+20XEN8CPP4mTKjslPHdpb/ajzZFvbaC9A1rdKFpKDRxGRytGcavPowGNXNm7jimVCLRHfp9w+Z/SATz4QT59j9TIZNJQdPwlEbNAJ6ZFfoywXDlzylmr3R7TZ4AOekn+ZaB5dk18Gl6rxa1NATC1P7m1R9Inn+Y+KC2OMCrL07HMAN/hZYSKUV64nxBOFe+S3rtmCrHYf7AOjXP+Eg9hk+irfNqdzL7/YT7P1yNYKE5bN2ApYb6wFRTPlqe64lkKIK+JCHMlN7PrWwTDFGL27+2jzIVxp2hoh2F1VSUAEyKN+SbmpPMVrQDrbMKTrQeHB7Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA894D5BDDBAB64FBD4E2016B8DCCBBF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb898cc9-e796-4736-6019-08d7145e14e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 19:51:00.4733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5432
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDIxOjQwICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyOS8wNy8xOSAxMzo1NywgQW51cCBQYXRlbCB3cm90ZToNCj4gPiArCWNzcl93cml0ZShD
U1JfSFNUQVRVUywgdmNwdS0+YXJjaC5ndWVzdF9jb250ZXh0LmhzdGF0dXMgfA0KPiA+IEhTVEFU
VVNfU1BSVik7DQo+ID4gKwljc3Jfd3JpdGUoQ1NSX1NTVEFUVVMsIHZjcHUtPmFyY2guZ3Vlc3Rf
Y29udGV4dC5zc3RhdHVzKTsNCj4gPiArCXZhbCA9ICphZGRyOw0KPiANCj4gV2hhdCBoYXBwZW5z
IGlmIHRoaXMgbG9hZCBmYXVsdHM/DQo+IA0KDQpJdCBzaG91bGQgcmVkaXJlY3QgdGhlIHRyYXAg
YmFjayB0byBWUyBtb2RlLiBDdXJyZW50bHksIGl0IGlzIG5vdA0KaW1wbGVtZW50ZWQuIEl0IGlz
IG9uIHRoZSBUTy1ETyBsaXN0IGZvciBmdXR1cmUgaXRlcmF0aW9uIG9mIHRoZQ0Kc2VyaWVzLg0K
DQpSZWdhcmRzLA0KQXRpc2gNCj4gUGFvbG8NCg0K
