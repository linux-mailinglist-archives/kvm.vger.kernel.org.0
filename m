Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB0712BC41
	for <lists+kvm@lfdr.de>; Sat, 28 Dec 2019 03:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfL1CdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Dec 2019 21:33:03 -0500
Received: from mail-shaon0148.outbound.protection.partner.outlook.cn ([42.159.164.148]:25591
        "EHLO cn01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfL1CdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Dec 2019 21:33:03 -0500
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2019 21:33:02 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=panyiai.partner.onmschina.cn; s=selector1-panyiai-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oumLJjtnjOD/Aq20nX3Vf/Am+GLbvgbNlZ6awrtPjy0=;
 b=YHs/pz9WHnND3odAWyX+X9Awlwu7JHY9LAqoO0DrvQ1LQJ7BJaknIL/2ZB/yBFpYpgIuxRTG4a4UcMEAl9BvpSTc+15UAfv4bNZ/Zp5K0c1m91jE7qEyfHBbSshoTVoq5bNUhigFE5rm8Efqgw8hzE+LkeovYB62nyDzR5EYupY=
Received: from BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn (10.43.32.81) by
 BJXPR01MB0375.CHNPR01.prod.partner.outlook.cn (10.41.73.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Sat, 28 Dec 2019 01:59:44 +0000
Received: from BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn ([10.43.32.81])
 by BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn ([10.43.32.81]) with mapi id
 15.20.2581.007; Sat, 28 Dec 2019 01:59:44 +0000
From:   Renjun Wang <rwang@panyi.ai>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: VFIO PROBLEM: pci_alloc_irq_vectors function request 32 MSI
 interrupts vectors, but return 1 in KVM virtual machine.
Thread-Topic: VFIO PROBLEM: pci_alloc_irq_vectors function request 32 MSI
 interrupts vectors, but return 1 in KVM virtual machine.
Thread-Index: AdW9InlyzaDL52etQ6qMDqb0chxtmQ==
Date:   Sat, 28 Dec 2019 01:59:43 +0000
Message-ID: <BJXPR01MB0534C845ED8D3942E95E7BC7DE250@BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=rwang@panyi.ai; 
x-originating-ip: [182.150.24.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6af28c5c-d362-4291-345d-08d78b399be5
x-ms-traffictypediagnostic: BJXPR01MB0375:
x-microsoft-antispam-prvs: <BJXPR01MB03755FCFC4DBBAACB25FC497DE250@BJXPR01MB0375.CHNPR01.prod.partner.outlook.cn>
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39830400003)(396003)(376002)(189003)(199004)(328002)(329002)(53754006)(71190400001)(71200400001)(4744005)(66476007)(66556008)(76116006)(95416001)(305945005)(86362001)(5660300002)(6306002)(486006)(5640700003)(7696005)(2351001)(8676002)(64756008)(6916009)(102836004)(186003)(478600001)(966005)(26005)(3846002)(14454004)(316002)(6116002)(66066001)(81156014)(1730700003)(33656002)(2501003)(7736002)(55016002)(2906002)(63696004)(476003)(66446008)(9686003)(66946007)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BJXPR01MB0375;H:BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: panyi.ai does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yo90dVKvniT5Y4jlGSeYbeAhfFuGFQiGzDfBBffiQToHTkN54oOfw25vBWm9MDajlEPvPpfPfiu1mwwyDfqKKiUJClp0O2kvI8nnjoa0ZceQOAWyCIhjOZ5Ir3prKbQCs45+ed1r1Ky6axj/L6mLPnFHaVRKGfccG1Tmrdan9dgqLBW7VSlOMwQICtXXv9yq3Q0QH48qgG4HbNJC+9Vg8ZZiroWdgI06LctQWDq3v6XzVvCX0JU6n59apjNNDBlsKIhl7CcipPzGKV6j1nJaziFHTYC+4j+JJwKmy4mMDpnh3nvNIrMUWPH/xPoBzjMId7s25nMj8xwrPbENaoqfrCzphWn//QirFCJFhKC8QA6AiuXTdjUTp9pb8jWs9vkRBuUJNeye6xW7WYLHlQ/AqoMqFj0/FVPO2Pic5AkUzJyY9w8W88v0fvl36pv0EgIv56y7SZOdRAco1z89am7nC2Z3sfH4L0ru8lJhxrvV6Mkmr7HIM1pwK2LVCpuyi+IlLuFZISufAwXcZBfU4AvL/mnsa0itIzMoSsoCB3A5ZBA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: panyi.ai
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af28c5c-d362-4291-345d-08d78b399be5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2019 01:59:43.9941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ce39a546-bdfb-4992-b21b-9a56b068e472
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t78sezuWJrXysEjqOgA81Vi6V1vT265m1D+8DxRam3ERfk94k5KFz3oRYBAVMoww
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0375
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all:
I have a question about PCI which troubled me for a few weeks.
I have a virtual machine with ubuntu 16.4.03 on KVM platform. There is a PC=
Ie device(Xilinx PCIe IP) plugged in the host machine, and passthrough to g=
uest via VFIO feature.
On the ubuntu operation system, I am developing the pcie driver. When I use=
 pci_alloc_irq_vectors() function to allocate 32 msi vectors, but return 1.
The command=A0 `lspci -vvv` output shows=A0
MSI: Enable+ Count=3D1/32 Maskable+ 64bit+

there is a similar case https://stackoverflow.com/questions/49821599/multip=
le-msi-vectors-linux-pci-alloc-irq-vectors-return-one-while-the-devi.
But not working for KVM virtual machine.

I do not known why the function=A0 pci_alloc_irq_vectors() returns one ?


Best regards.
