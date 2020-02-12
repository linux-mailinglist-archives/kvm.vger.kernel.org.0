Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5968215ABA8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 16:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgBLPDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 10:03:39 -0500
Received: from mail-eopbgr1310089.outbound.protection.outlook.com ([40.107.131.89]:48790
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728094AbgBLPDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 10:03:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpzoS1/Fxv75NmnNqxKxTFNvBX6Gj2Lx1Ep0EdZOLix6Pfkv/gYALzkYXqiX/xOn6Sf2B32luP4yP7gzQNpmpg+Lvyh4dFrgZQnPpQODomncuxEgZWec0DNwOODNEoExTQMVtCPTraK/Gz2qpQ8TyE7E6qfBx6VitYMizpOPAZflx77hBgVXYdMVSAht9sGkb2cKIYorswtr9xdx6mLYTfH5bRTxm2RxE9Rm8DnwMdFJ4q53f+lFzvX5nJszuUDs1DfGxMbA2Ng5EqJ/OVY+aZdgTo1+pKUz8akYTvVxI+VtFhcdRGam1WNQGV4z0m+8FIBLPg6Ip3rbyDTTHgacVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRMS0ONHyAiGdarIvOeiuCKPl9USBNQPXj6DjQ3hgpI=;
 b=ZRGwrvyJ+KuRGvnWQl5ucSLCgTSMn5bXXqDZiE0HON5A6ecMEl40UjpJnxxH7jAa0YYV6QsyzNbU3uLhrLKGJD22Qrjs6bj+6GVZ5aCj1vfz93s1sRdXbass0VdiXVVXTuux2xXaGohwSYkEk/cYosRHIpeHRriBstVBDWvWU7JXWKti0zeHuFZSZmst6KFgzQM3Zhoe8MGDTwS8AssseVm0CGUKWlfxjr55+7G8pflAWtZuaeCLmYqGWVb17HIaWZx94yO2ogETxO7w2yqtPSai1qGiUlgB3tMV4Z5zlQANkb9PapaiYiTckND0ZcEl9VpL2RgsAsiARGJns+/wBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRMS0ONHyAiGdarIvOeiuCKPl9USBNQPXj6DjQ3hgpI=;
 b=emVu0plCHIIzQ4J4iE+jnbbCzBNdMZUMnWJK5KdCbiVym4zoJX5aeYRQrm5nOXx8AmuZ7XfZolk4Yh2fLTIGpq8zPWYnYgX0p8Gy1C5N74mj8PZAA3OrSyWylqzmdKc0fiTpvVVYWM+dKbyQ4U83B37eI0ZBrtMCqD8REjmPvkg=
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) by
 SG2PR01MB2062.apcprd01.prod.exchangelabs.com (52.133.137.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 15:03:34 +0000
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd]) by SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd%4]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 15:03:34 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: 4K video rendering speed in Windows 10 virtual machine with GPU
 passthrough (QEMU/KVM)
Thread-Topic: 4K video rendering speed in Windows 10 virtual machine with GPU
 passthrough (QEMU/KVM)
Thread-Index: AQHV4bV8N1WeKnYf20yR97AHSJr8Nw==
Date:   Wed, 12 Feb 2020 15:03:33 +0000
Message-ID: <SG2PR01MB2141C4BA837F05E4B601796B871B0@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ceo@teo-en-ming-corp.com; 
x-originating-ip: [2401:7400:c802:de67:ec11:5df0:48d0:242d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2121b8c4-4caa-4583-4f9f-08d7afccbaf5
x-ms-traffictypediagnostic: SG2PR01MB2062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SG2PR01MB2062AE4601A1432FA719ADD0871B0@SG2PR01MB2062.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39830400003)(376002)(396003)(366004)(199004)(189003)(2906002)(8936002)(186003)(81156014)(81166006)(71200400001)(8676002)(508600001)(86362001)(6506007)(33656002)(6916009)(7696005)(9686003)(107886003)(76116006)(55016002)(66556008)(66476007)(64756008)(66446008)(5660300002)(52536014)(966005)(66946007)(4326008)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:SG2PR01MB2062;H:SG2PR01MB2141.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: teo-en-ming-corp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+MlLlaax847Ej+GVyPXUbPP7VU9VwRSWjVjSo/I3dewTO6cxW2q/Ghvh0l5o/2IR6FGgFOLG9U+igJir4/NsHhMqJB0ma4GjATJHnZA8mtDv5bWXqcV/VWwVKFLsGw0LsV95HchHNZvMe6XSItKe5OVUl3Wmk9u8rX9eb+00+jk7JkX/xvNVp/hq9mMd/9xVtEwhtCltVGUO3Adhn8KP24B7GLvtdc0N7vnYvtKfmiUGbQUXcq90/EgpvTBgLe3o9HI/pbf4V8MeJUVpJvVeda7RNDBEZ/izXUD0tBSeON+58oN8S1POKp/K/Q3Hwbjiw9SlYB4EikJlqRFsfRD3LYpKtRXiui0ae4/eylj4BgdLtp8luRNsuH4mXgRYEP05B4QJWM9dhFR3qJ91Pwl52DYvCaB8CDerEowvP+TNQIWIQRa9/HCg1z9hFOFXF3rzllyPKK4zqCxIoSOusooD3Fk8pqAq+ZVCUb8YwYylnAgRPqPC4PALMd9/X4TPsfHYEVYA62uW80u1SHis27+bw==
x-ms-exchange-antispam-messagedata: zJVWcyJWYWSo54ynCf5PrrEiT0KcD50Y1FXGlcwPEsw4VRD+4ffMUqHT8bgKYZ8MV5MPpvUO/zc4lGf8xsCU5l6+HBcuZ9gtQG5Kgf9EOXKZcNUEd9df1Knm2ilhhbcQJuOQqK5JsTutb6Ri6Fmp8X8whREplCG+WkTPG+Ur8M7R/Mz7OiQCXRsY6nS+vEITvxIxBHAl5b32byHh3+nL9w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2121b8c4-4caa-4583-4f9f-08d7afccbaf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 15:03:33.9083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TgV0qkdJz+oA20acyrGoXRkFWZEjYGx1FC7RuCIofk0SE5ZXKIegEMDO04JYWOBgNqNM0bN/MRe1ms3SdzFazWrU6re/AZXL0vd1rkCDszQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB2062
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

4K video rendering speed in Windows 10 virtual machine with GPU passthrough=
 (QEMU/KVM)=0A=
=0A=
Processor: AMD Ryzen 3 3200G with Radeon Vega Graphics=0A=
=0A=
Virtual CPUs: 3=0A=
=0A=
Motherboard: Gigabyte B450M DS3H BIOS version F41=0A=
=0A=
RAM: 16 GB=0A=
=0A=
GPU Passthrough: MSI GeForce GTX1650 4 GB GDDR5=0A=
=0A=
Results:=0A=
=0A=
The time taken to render a 2 hr 33 min 4K video is 4 hr 50 min (4K video re=
ndering speed).=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
-----BEGIN EMAIL SIGNATURE-----=0A=
=0A=
The Gospel for all Targeted Individuals (TIs):=0A=
=0A=
[The New York Times] Microwave Weapons Are Prime Suspect in Ills of=0A=
U.S. Embassy Workers=0A=
=0A=
Link: https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwav=
e.html=0A=
=0A=
***************************************************************************=
*****************=0A=
=0A=
=0A=
=0A=
Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic=0A=
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the United=
 Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan (5 Aug 2019) and A=
ustralia (25 Dec 2019 to 9 Jan 2020):=0A=
=0A=
=0A=
[1] https://tdtemcerts.wordpress.com/=0A=
=0A=
[2] https://tdtemcerts.blogspot.sg/=0A=
=0A=
[3] https://www.scribd.com/user/270125049/Teo-En-Ming=0A=
=0A=
-----END EMAIL SIGNATURE-----=0A=
=0A=
=0A=
=0A=
