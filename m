Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C85CB739
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbfJDJTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 05:19:13 -0400
Received: from mail-ve1eur04hn2011.outbound.protection.outlook.com ([52.101.139.11]:51331
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729379AbfJDJTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 05:19:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cC4ADhqv4YY4M+HxtEtgtlhdOm93u+hPWHhXBDlq6JVoWNIgOG21BmQmz9xL0FQE/qUdOZRGcKz5LzdZ2AdsVXSPvMyVwekr6L6ebQjDimq33sF8YIhnaREAGFn5W9ORusunp4uuRhl2PMcfezPvaJSgYOGiIjfw300iMl27wctB4C8WMDCEH34ePTYSHRHuNrx4DxCrT8Wjtfocf1gmhAU9NtNfzgNjjAWj50qhjG6J3t27SO3V4fEmeLMK+A3yHWEgDOl8n0ew3B63FCylYTpOZOkC/yhSjB7hNsYs+gE5c47i8ee3XXjCcVrW22YS6boi4o2+rVCob0nAX4AOBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDVoLiCPfoZdyHyFGUK7dKnLd6IKBVuymCTzwUQ6f6Q=;
 b=lkm0bAg964ObmliwKZeOzR/bxTpOxgxP4ex1lej8cpsHGztHLFMdKfT1zRj28Agd3bEbJaD1Gxq1RfWPAPsSmPcE3LCN0X+0HMsZX1PYiuUjhi5jN9W7Z9SV6iinK7kPW17755uUbDK4Gqu000COWxhvcVY92IZnFDJF6EcbbXVfwF0QgVToCUseyxR38G3z+674FHVPv0aMoAex93g7FtckKbePTypKaOVnyTRmZFa5sbimVmrY2N8Sk0MEkM5HROZxvTChA9c+FdxlMetSCGeH6l1g0gaCbdI2nEbWgTmHhDKsXZgo0SA7NagQ+yC+UFplBL0y/VT+opLqQTphvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDVoLiCPfoZdyHyFGUK7dKnLd6IKBVuymCTzwUQ6f6Q=;
 b=brNY1Lf2HzE7GcVBUhCgkfHO40Y73xNPEYyD6sEW7ZtynJ2vWHu1EVQn+hQclPfqtBV70Z8s+QYrxEtAp0eeHox08/4MysKasIg+YHBvUJXkKe+HHLoWvAVzRmp6i6XND4AmL9jgqOWu7/DE46DxYIrxumt2V+OZ3AB4ZmOopgw=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB3778.eurprd08.prod.outlook.com (20.178.23.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 4 Oct 2019 09:18:59 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 09:18:59 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Michael Kelley <mikelley@microsoft.com>
CC:     vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVeQrgrl6z6kaUqkyr6D3zFBAn2KdIv6eAgAAhHwCAAOlpQIAAbTiA
Date:   Fri, 4 Oct 2019 09:18:58 +0000
Message-ID: <20191004091855.GA26970@rkaganb.sw.ru>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
 <87muei14ms.fsf@vitty.brq.redhat.com> <20191003125236.GA2424@rkaganb.sw.ru>
 <CY4PR21MB0136269170E69EA8F02A89E9D79E0@CY4PR21MB0136.namprd21.prod.outlook.com>
In-Reply-To: <CY4PR21MB0136269170E69EA8F02A89E9D79E0@CY4PR21MB0136.namprd21.prod.outlook.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Michael Kelley
 <mikelley@microsoft.com>,      vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,    Tianyu Lan
 <Tianyu.Lan@microsoft.com>,    Joerg Roedel <jroedel@suse.de>, KY Srinivasan
 <kys@microsoft.com>,   Haiyang Zhang <haiyangz@microsoft.com>, Stephen
 Hemminger <sthemmin@microsoft.com>,    Sasha Levin <sashal@kernel.org>,        Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org"
 <x86@kernel.org>,      "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>,        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR0901CA0066.eurprd09.prod.outlook.com
 (2603:10a6:3:45::34) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57f1af69-c4d3-46af-9141-08d748abe360
x-ms-traffictypediagnostic: AM0PR08MB3778:|AM0PR08MB3778:|AM0PR08MB3778:
x-microsoft-antispam-prvs: <AM0PR08MB37783F504D3E4026714B5B9AC99E0@AM0PR08MB3778.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(39850400004)(136003)(366004)(376002)(346002)(189003)(199004)(4326008)(2906002)(33656002)(36756003)(1511001)(66946007)(478600001)(14444005)(25786009)(486006)(256004)(7416002)(64756008)(76176011)(99286004)(66556008)(66446008)(305945005)(6916009)(7736002)(66476007)(66066001)(52116002)(476003)(58126008)(316002)(186003)(54906003)(8676002)(81166006)(81156014)(11346002)(102836004)(86362001)(5660300002)(26005)(386003)(6506007)(6486002)(9686003)(6512007)(3846002)(6116002)(8936002)(6246003)(1076003)(229853002)(71200400001)(71190400001)(14454004)(6436002)(446003)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:AM0PR08MB3778;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: joUvr2lZQ85TV9zR1QCe+tHGCou2Oct1sHCSlJ2epH9G1tGahqP4POTqaWVS2N2elWrE+IFXqPwg7DmsxGMcFsiKPiPLkHDv7BIfuDYwhmzivVyu8HCWuAYEATkjKQws3Ax8x6ptiNuKFgJis77PEUUSRqJ85PlHWCP8FoysOuTR0zWoXI9EVdgYBksZ+qBbEwmIgwfSvVLIgiHOmEm4dTa1oevGo6sF32x4LIfrdVan8046aGKk3poFGApz/Q7DDGtfQABSClDxNp6lvYTaQ0ttyCA0rAP6UH0NzxlKwqZD89TsTOcEwrS2WPDBd5Xg4uYjh+4Q9W9cZBxQUpRoCJR/DR4G84x9r1gQoh04ZCSKWMOjPL5cWOck3w1cHD5P4LqitIjZZDJPgEfmwIxR7HaYuvICkOcG0U8g7JnJ7bUAJ/BSJ894hWmAWcUOph20g9Nob4dCmKn84mDHpUK0MgGOj0smTNnlErqc+EYjR/glLETPuRrnHL+FG9enFvms
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D98FC6662D0AD24BBE03A53140FCAC08@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f1af69-c4d3-46af-9141-08d748abe360
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 09:18:59.0596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQYYIq54ZBSFvdBqQWwRJx5RhDRftfJKVLm0l+oV65UrCoNB52LyiyfYoC+JZ0zz5X8Y6jNMYiA9Dqr2TTtobA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3778
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 03:01:51AM +0000, Michael Kelley wrote:
> From: Roman Kagan <rkagan@virtuozzo.com> Sent: Thursday, October 3, 2019 5:53 AM
> > >
> > > AFAIU you're trying to mirror native_x2apic_icr_write() here but this is
> > > different from what hv_apic_icr_write() does
> > > (SET_APIC_DEST_FIELD(id)).
> > 
> > Right.  In xapic mode the ICR2 aka the high 4 bytes of ICR is programmed
> > with the destination id in the highest byte; in x2apic mode the whole
> > ICR2 is set to the 32bit destination id.
> > 
> > > Is it actually correct? (I think you've tested this and it is but)
> > 
> > As I wrote in the commit log, I haven't tested it in the sense that I
> > ran a Linux guest in a Hyper-V VM exposing x2apic to the guest, because
> > I didn't manage to configure it to do so.  OTOH I did run a Windows
> > guest in QEMU/KVM with hv_apic and x2apic enabled and saw it write
> > destination ids unshifted to the ICR2 part of ICR, so I assume it's
> > correct.
> > 
> > > Michael, could you please shed some light here?
> > 
> > Would be appreciated, indeed.
> > 
> 
> The newest version of Hyper-V provides an x2apic in a guest VM when the
> number of vCPUs in the VM is > 240.  This version of Hyper-V is beginning
> to be deployed in Azure to enable the M416v2 VM size, but the functionality
> is not yet available for the on-premises version of Hyper-V.  However, I can
> test this configuration internally with the above patch -- give me a few days.
> 
> An additional complication is that when running on Intel processors that offer
> vAPIC functionality, the Hyper-V "hints" value does *not* recommend using the
> MSR-based APIC accesses.  In this case, memory-mapped access to the x2apic
> registers is faster than the synthetic MSRs.

I guess you mean "using regular x2apic MSRs compared to the synthetic
MSRs".  Indeed they do essentially the same thing, and there's no reason
for one set of MSRs to be significantly faster than the other.  However,
hv_apic_eoi_write makes use of "apic assists" aka lazy EOI which is
certainly a win, and I'm not sure if it works without hv_apic.

> I've already looked at a VM that has
> the x2apic, and indeed that is the case, so the above code wouldn't run
> anyway.  But I can temporarily code around that for testing purposes and see
> if everything works.

Thanks!
Roman.
