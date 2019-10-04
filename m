Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4ACB36A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 05:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbfJDDB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 23:01:56 -0400
Received: from mail-eopbgr730129.outbound.protection.outlook.com ([40.107.73.129]:10015
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731648AbfJDDB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 23:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtIbbD9aMHiieYGkx/QfZxCDi7/dsFT+KfBcKhBi4BPMHC/+hpDIuWo775UJDK/6Rijcr402HvzLibvmdmHZRp4jHD5BRwcpyWxIxIzxDNuThpUMZz2TDI+hWTRksUummG8x4IyE+sus2i2clNvxw1I3OxNQ9HdS5Le/Z0amrtoi/ZwaVlyGiFR1xdyc2pzlt0QpB1BHrzg6toDyt0Wbh6tYUolDSByBkrehwtAdMytlxN1crGu2Lwz06ncnUC+lvEgdETiNR2Jqa4DWNWY5BKqVKcz6utRgSDtNhbVLfJQqzYmr+FpDbe0RASS/HuW/Lh/V+nW9Xz5QplV64WhmoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEEKoRHdFuhEMJGb/9H5pJYEJzF9NuDgCp1bKNvBYjY=;
 b=IhC1eyCtbsUQoba7TiOnhLWhJldatRsPLQ0YgqoDGlsiEHVfYfmW78DRHmNYJH8d3BZXyTj/1X/Gyht084VpYiSqL+0YwJdVGkWSwLl9eb9m4yY2PLf7rLOHhmLsT4XRJ3usHh6JUysjOpFCtuB1aAcA59IqKs2RfDz/Q38IZPkOoareEWT6pWqbe9W5/LBonwACCcOkasVXlaYpaM3GzyoxhEszt6FI7NEYoptjPCH6uZ2tVT/zTVx+1tFlDMTFKTGa4v97HUVE6WC5QGm0IKDYMji9lpn2VP1/FudYCQD1UYsxZRzo0BoEzAP3bev/XohnJZXmCToeBonUDwlC7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEEKoRHdFuhEMJGb/9H5pJYEJzF9NuDgCp1bKNvBYjY=;
 b=JMSHE0y8ttab04mC2qx725UnGkTXeSffw6KR3JBZSEeV3Ij1lTRVPluUsrmNHJ6RSDnQSloyzMQApdXd7hP4ATHqdIeFXYgT2qBxck6V8y+x0rVHYnRL0PzOIX59eFY/9zn5NKTxU6FQ9GIm7094xTSRtXRoGmnjxSqNiu+gpAU=
Received: from CY4PR21MB0136.namprd21.prod.outlook.com (10.173.189.18) by
 CY4PR21MB0503.namprd21.prod.outlook.com (10.172.122.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Fri, 4 Oct 2019 03:01:51 +0000
Received: from CY4PR21MB0136.namprd21.prod.outlook.com
 ([fe80::a849:fd6f:615d:64e9]) by CY4PR21MB0136.namprd21.prod.outlook.com
 ([fe80::a849:fd6f:615d:64e9%10]) with mapi id 15.20.2327.009; Fri, 4 Oct 2019
 03:01:51 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Roman Kagan <rkagan@virtuozzo.com>, vkuznets <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: RE: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v2] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVeQrgrl6z6kaUqkyr6D3zFBAn2KdIv6eAgAAhHwCAAOlpQA==
Date:   Fri, 4 Oct 2019 03:01:51 +0000
Message-ID: <CY4PR21MB0136269170E69EA8F02A89E9D79E0@CY4PR21MB0136.namprd21.prod.outlook.com>
References: <20191002101923.4981-1-rkagan@virtuozzo.com>
 <87muei14ms.fsf@vitty.brq.redhat.com> <20191003125236.GA2424@rkaganb.sw.ru>
In-Reply-To: <20191003125236.GA2424@rkaganb.sw.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-04T03:01:48.8514527Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2c86c3d7-269b-4811-836d-90d0280a7900;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b079f66f-93d7-4f18-b40d-08d748773460
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: CY4PR21MB0503:|CY4PR21MB0503:|CY4PR21MB0503:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB0503F2EEE9B996FAEE2FD680D79E0@CY4PR21MB0503.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(189003)(486006)(476003)(11346002)(256004)(10090500001)(71200400001)(26005)(55016002)(71190400001)(229853002)(102836004)(9686003)(66476007)(66946007)(66556008)(81156014)(81166006)(446003)(2906002)(33656002)(6116002)(7416002)(76116006)(64756008)(66446008)(66066001)(14444005)(8676002)(8936002)(3846002)(86362001)(99286004)(305945005)(4326008)(7736002)(5660300002)(7696005)(6506007)(8990500004)(74316002)(6246003)(478600001)(10290500003)(110136005)(25786009)(22452003)(6436002)(54906003)(14454004)(52536014)(316002)(186003)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0503;H:CY4PR21MB0136.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MvXEm+gaQ9YnGGKfXLN+VOdowGneiRNR+QBa0dvkwkwNT6Xyn6+prBJx39631Lo51/WQku2fqL9TszpbrGouDfSO6ENk70Ww1i0SVi/s+iWh1Z6sr9XO0YMAS7DLPC+Gee0R52BvG7OV6BgzdOE+Ug6IoC1XZZASmqqI9OcSB+YlURnn2K31kF/9n1fhHqTvhbwL77fS6UQzVL5Hr47fH5sCNWeAzEJg+5TjnB3IvrgFsuyj2fbYKfxQOWZzJkae3tdG6MYszaaoAcbMeSD5MRFu2cg/Sk7S6IH06KxgOvbBM6W2mGNy/rrYGngWXSndXjbav1saHcJPEWO+CtSzGn/DEBOMFvHYsUeGjMz0BTkJPKjxOfJz/YNFReBXyaXoxZ1iB8Yzbg3fgSCffzOAxdV2zZSUk3BGmKaYtVjbaww=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b079f66f-93d7-4f18-b40d-08d748773460
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 03:01:51.2005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gFGbmjC3MyH2kC5A4RE+XP+1Xj8RvQ7nYeCeOvXYJ242G/bAQvfo3vk8shVF1OoHE0a9UixBJLGKT7QNH21NS5WUEv9u4aFbPVU+AKWfOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0503
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Roman Kagan <rkagan@virtuozzo.com> Sent: Thursday, October 3, 2019 5:=
53 AM
> >
> > AFAIU you're trying to mirror native_x2apic_icr_write() here but this i=
s
> > different from what hv_apic_icr_write() does
> > (SET_APIC_DEST_FIELD(id)).
>=20
> Right.  In xapic mode the ICR2 aka the high 4 bytes of ICR is programmed
> with the destination id in the highest byte; in x2apic mode the whole
> ICR2 is set to the 32bit destination id.
>=20
> > Is it actually correct? (I think you've tested this and it is but)
>=20
> As I wrote in the commit log, I haven't tested it in the sense that I
> ran a Linux guest in a Hyper-V VM exposing x2apic to the guest, because
> I didn't manage to configure it to do so.  OTOH I did run a Windows
> guest in QEMU/KVM with hv_apic and x2apic enabled and saw it write
> destination ids unshifted to the ICR2 part of ICR, so I assume it's
> correct.
>=20
> > Michael, could you please shed some light here?
>=20
> Would be appreciated, indeed.
>=20

The newest version of Hyper-V provides an x2apic in a guest VM when the
number of vCPUs in the VM is > 240.  This version of Hyper-V is beginning
to be deployed in Azure to enable the M416v2 VM size, but the functionality
is not yet available for the on-premises version of Hyper-V.  However, I ca=
n
test this configuration internally with the above patch -- give me a few da=
ys.

An additional complication is that when running on Intel processors that of=
fer
vAPIC functionality, the Hyper-V "hints" value does *not* recommend using t=
he
MSR-based APIC accesses.  In this case, memory-mapped access to the x2apic
registers is faster than the synthetic MSRs.  I've already looked at a VM t=
hat has
the x2apic, and indeed that is the case, so the above code wouldn't run
anyway.  But I can temporarily code around that for testing purposes and se=
e
if everything works.

Michael
