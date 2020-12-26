Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772922E2DF5
	for <lists+kvm@lfdr.de>; Sat, 26 Dec 2020 11:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgLZK1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Dec 2020 05:27:31 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56350 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgLZK1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Dec 2020 05:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608978449; x=1640514449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2uBhCT1dLuMUMZSXHVdB92wrCkF2a7YKar4EdtUVD7E=;
  b=ZLO5qjeI8JC1/3aETfqWwZ+W8XwOv48EWJxH+vk+ZHEJ+rnMeKG6J4dN
   KyfEX0z38RfjYnGBzT459Mu1VoKK+7V3gJ5D8nFMxjy+CjkaFyJoWH5/P
   6ieI2f4z36CYEc65nw0TluKLuENjbZ9hukE81xiCWxvFtCLWG0EeVcqGs
   7eEM2wbDgItNitZYbALEWRuuuK0K5DKHtSP7oQlnOTDZ7iZ1QofOD76bw
   n0F50hTz9IVqGybE4AsYjQpMHp7ZOPPbjVVtTiqMGyepBhztjOM4jEgE9
   5+9JSjJNdxIfacG2phEpa6iq2x+FN/fBs5BNmAzFz7UlYlBlPMF5nG3zx
   A==;
IronPort-SDR: rGao0ILNdToQ9XZY6I55dPpAlOekbPmL0+j+JyeWVrmespeot+SNWm2x+QcktXIKHErlmUMJV/
 4FWS/Ycu8ulUDxreaZ+64ODWBet5PngRR1VxuRyThmRDiOMnpRHROEcl6XBHGeaFDIDqRJv+1R
 ET1P2RilVACCbsZ0eUhShndtgWn2OYE09Izh/8xofUSxeyAdYmmQUsissFW4j0Dx9JTVjpYisI
 BRERwbEB5oKTy8WrvgqMeNuyUWUxMkmo798L5cZ19qK9KXPg1D/Yn+h1nhka3GNMz2lcE2Nex1
 DkM=
X-IronPort-AV: E=Sophos;i="5.78,450,1599494400"; 
   d="scan'208";a="157253460"
Received: from mail-sn1nam02lp2054.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.54])
  by ob1.hgst.iphmx.com with ESMTP; 26 Dec 2020 18:26:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gANkQbR7Q9ACl2zdAJpnNPY4ltAr2nCdx84AFNivxwrPlLmKwNqhVAgOYSHs570PrXdATw1knhGi+bcq0a4OSsn7UNn6JsbqsBiZhMX3M9bxGHKShH0BhdplGa7TylnGrNXnVJkgWFfZAqHxGZSmwUKfWDxjmyL9AMbo1vTVfldDkOpTHKy+3Sg1jAZIXihtPdLQAvGhsHa+ntb6tI0N3zTIXxhOls2LndQitS+w5hJFUc/smDQpH7G/k+rSw12cu10km7O6aH7Z8M6VvhJqBeVpRdKW/UeBUg6QvtdPMH/LrJ49MBxcnz7od1I69PAgb0saLXro//QtLrbrrvRmsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOpoDi2R0vT3HR1HDRH8grPMEQj1pW5bW2VR7lSmuGI=;
 b=YOvl6ME9N4jKUo5eSYQ4BRGb3tdkW/uVOlUN/dppiWC7yIcpBUkmuXm7D16O3PRqtBRe6IHzF53oD3zQuseromX6VymQfz/PTjimv7zA6u1QQVT0iVUP4HjN3Y0fg3m6yncx9Ua126+ef0k6oIiLLx5laH3EVC0E0nS5eoh6knVXg/1N/PB++vFoTvrOzNc00RDJG9DX/MWucruEt4xXir8CrlRnKkIMI8GrAUF72SJ/mjjbBFMDtBxPgzlW5yVZay/G6HjNXT+XJgyp25HdEAnzHML2FEVm6zA76Qu9TinLkHw2GykduBl2jvkDHaZsbv1IvxiciseYOkiGO3P9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOpoDi2R0vT3HR1HDRH8grPMEQj1pW5bW2VR7lSmuGI=;
 b=M4YEW3qq0wXhOm9u1tyNuystxaiRk6X37ehE+rzMIJ3KYYfZcc6c532UsyjwjPOVjMK+xbMJUAt8jpO/rRP9QVQ3TnTvKaTNJ+Y2t5R/dfuAji5ai8ffGopMzAWfkXiF0blTIG/boFW2nbT275w7EojBOt1Tpzif+zcfN5NE5xw=
Received: from MN2PR04MB6207.namprd04.prod.outlook.com (2603:10b6:208:de::32)
 by MN2PR04MB6095.namprd04.prod.outlook.com (2603:10b6:208:d7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Sat, 26 Dec
 2020 10:26:20 +0000
Received: from MN2PR04MB6207.namprd04.prod.outlook.com
 ([fe80::3c5e:9a36:34e0:9d67]) by MN2PR04MB6207.namprd04.prod.outlook.com
 ([fe80::3c5e:9a36:34e0:9d67%7]) with mapi id 15.20.3700.030; Sat, 26 Dec 2020
 10:26:19 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Jiangyifei <jiangyifei@huawei.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: RE: [PATCH v15 12/17] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v15 12/17] RISC-V: KVM: Add timer functionality
Thread-Index: AQHWtoxLCxd6PUsl+UOoYMG9P79uk6oESuSAgAUq9xA=
Date:   Sat, 26 Dec 2020 10:26:19 +0000
Message-ID: <MN2PR04MB6207BDD8992D24AB94466C1E8DDB0@MN2PR04MB6207.namprd04.prod.outlook.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
 <20201109113240.3733496-13-anup.patel@wdc.com>
 <d3f3a7aea01c49afb9cadccd47498854@huawei.com>
In-Reply-To: <d3f3a7aea01c49afb9cadccd47498854@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [103.15.57.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 565df3db-e5f0-4274-7e85-08d8a988af9d
x-ms-traffictypediagnostic: MN2PR04MB6095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6095D7450282AB659905FB618DDB0@MN2PR04MB6095.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZTnz+v0VatQBEdV5cYvbQXb8VF5hA6mPXuz1siwnJ4L0jbA5NUMPIrowC12UQxquZz6g0+tOk3kjFYGhdZ+LyvQtS3DfrmvIs372mTWDRn0tDpKXOWKXuPtbKGYZ10kpuLRq5PVaatKslj1IMrIVi6GdNzP1JKbEG0C58hwgqVAcKZMZ5QoXK9GHnIHe9KPXOpIY0eZenBwK333qRsXgkhxvihXjjL6Dzy+cIjmdlyf9d9g5PD6M962dXOmZGk1QwYzFt1GmpfDXdD479H3h+m34JRYkHo/IJpUUBy28jaSv3cgbVQkefmZFcsNbribiho3zWOUTqN+a/h5/O28xVzHa+eeS9+Ve1FswUsFmwh02jYeAr3SBtGya4HNiIjRSWm1Uj5eFJL2b3q2GAz+5mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6207.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(376002)(136003)(366004)(316002)(64756008)(86362001)(66556008)(110136005)(2906002)(8676002)(66446008)(7696005)(9686003)(7416002)(33656002)(6506007)(186003)(52536014)(53546011)(55016002)(66476007)(76116006)(4326008)(478600001)(26005)(83380400001)(5660300002)(8936002)(66946007)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Tbqa9bDfo3Vk/jKE9JeSmIB8SOXq0GrRwbvV9U+yNFCl6Dzrqne88qVK6bBx?=
 =?us-ascii?Q?bs4v5/CvjDYklpcRMKIHxai4KGXc6r+F9WRjCj2hqItikMniT5/zV33N+CSC?=
 =?us-ascii?Q?Kk06PU+PkltER4RIf1hAI7/XwJHXYB4vJls59X9f+E7KmBPKvOlC/AI+yrgF?=
 =?us-ascii?Q?pNwG5U72CJMSVndEwrTbadJCgCrOT5Hxp4cHQeyW28/z6vdh2MIBvir6WioX?=
 =?us-ascii?Q?XpP00mS5PiBQO8Ft+0/DGbsVUTkX4BWQYCfCxY2CFZs43xmyd2gWddcdARd5?=
 =?us-ascii?Q?yg1tRu+HJoVF4lDE53mEnZAqURye3Yz2QSQqUOfKNtjV/PbkQrDGkoxGpOmE?=
 =?us-ascii?Q?HbvvnqoSjPsGCY8V++ZmwnV9oeuB9754VOs9eE2YKsBYikkJP3Zd7ge4TobO?=
 =?us-ascii?Q?evp8T4Y34LzeoUqNeGUWAEoCxqPxuQNwVks63tpd91sV9bhLmiMBdpuoaBc+?=
 =?us-ascii?Q?KU2raBGKgwyedlkq0bAU4Qlv/f86GmHjWrzXQbrcCB01+I1Fkxi27s0dzMul?=
 =?us-ascii?Q?NurYcIY/fruOp0CrhDEy30rANYnvDvCI87deFmjO0nmECY6DolZUB9mURfbk?=
 =?us-ascii?Q?Dwm/5iyQbVA+Gq04H29ZyVSVMGUFE25rP/xjl9cO2FvbdFLuTNvz8tKpIobt?=
 =?us-ascii?Q?ipPmeOhJFnatD7hcUYuaaDbU8dZ+SzeJuIAaPAnb6NeEH+LQAEWTmHmNtrT2?=
 =?us-ascii?Q?OilVhve8c1cu3/kXGVj6jnJ7FBAqazhiyTfHMjrfO0oxiXi00HOT++J+EH9D?=
 =?us-ascii?Q?bUULIQ8+XMm6E/QWF0CuPdqsnh/ueEIQLZq55F9qv1EjXmLr8vdf8XC2r3+V?=
 =?us-ascii?Q?AIZo8hik6SabTC8iJcJByIEaGVy4dvfGXTC/DVjoOIqvxv12PRGV7DFheXT0?=
 =?us-ascii?Q?WTNiJIo3Uj2sNYegxJBVC+DFFuN6bVUJlmtf/SVEHAkuBEVqtUcQQb4lV5m2?=
 =?us-ascii?Q?OV+YXuO8KtdxwRoHVGXVDStbDXG7TY+txU8CIRVqz1c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6207.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565df3db-e5f0-4274-7e85-08d8a988af9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2020 10:26:19.9266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQOCPFfcmtRry1YM/M/vjf4jJivIR2BVNAPGzQj91RaYgJR5AVP8t2DyzZCCy9I3xzrvCXwvhND+SLl1DGP/IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jiangyifei <jiangyifei@huawei.com>
> Sent: 23 December 2020 09:01
> To: Anup Patel <Anup.Patel@wdc.com>; Palmer Dabbelt
> <palmer@dabbelt.com>; Palmer Dabbelt <palmerdabbelt@google.com>;
> Paul Walmsley <paul.walmsley@sifive.com>; Albert Ou
> <aou@eecs.berkeley.edu>; Paolo Bonzini <pbonzini@redhat.com>
> Cc: Alexander Graf <graf@amazon.com>; Atish Patra
> <Atish.Patra@wdc.com>; Alistair Francis <Alistair.Francis@wdc.com>;
> Damien Le Moal <Damien.LeMoal@wdc.com>; Anup Patel
> <anup@brainfault.org>; kvm@vger.kernel.org; kvm-
> riscv@lists.infradead.org; linux-riscv@lists.infradead.org; linux-
> kernel@vger.kernel.org; Daniel Lezcano <daniel.lezcano@linaro.org>
> Subject: RE: [PATCH v15 12/17] RISC-V: KVM: Add timer functionality
>=20
>=20
> > -----Original Message-----
> > From: Anup Patel [mailto:anup.patel@wdc.com]
> > Sent: Monday, November 9, 2020 7:33 PM
> > To: Palmer Dabbelt <palmer@dabbelt.com>; Palmer Dabbelt
> > <palmerdabbelt@google.com>; Paul Walmsley
> <paul.walmsley@sifive.com>;
> > Albert Ou <aou@eecs.berkeley.edu>; Paolo Bonzini
> <pbonzini@redhat.com>
> > Cc: Alexander Graf <graf@amazon.com>; Atish Patra
> > <atish.patra@wdc.com>; Alistair Francis <Alistair.Francis@wdc.com>;
> > Damien Le Moal <damien.lemoal@wdc.com>; Anup Patel
> > <anup@brainfault.org>; kvm@vger.kernel.org;
> > kvm-riscv@lists.infradead.org; linux-riscv@lists.infradead.org;
> > linux-kernel@vger.kernel.org; Anup Patel <anup.patel@wdc.com>; Daniel
> > Lezcano <daniel.lezcano@linaro.org>
> > Subject: [PATCH v15 12/17] RISC-V: KVM: Add timer functionality
> >
> > From: Atish Patra <atish.patra@wdc.com>
> >
> > The RISC-V hypervisor specification doesn't have any virtual timer feat=
ure.
> >
> > Due to this, the guest VCPU timer will be programmed via SBI calls.
> > The host will use a separate hrtimer event for each guest VCPU to
> > provide timer functionality. We inject a virtual timer interrupt to
> > the guest VCPU whenever the guest VCPU hrtimer event expires.
> >
> > This patch adds guest VCPU timer implementation along with ONE_REG
> > interface to access VCPU timer state from user space.
> >
> > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > ---
> >  arch/riscv/include/asm/kvm_host.h       |   7 +
> >  arch/riscv/include/asm/kvm_vcpu_timer.h |  44 +++++
> >  arch/riscv/include/uapi/asm/kvm.h       |  17 ++
> >  arch/riscv/kvm/Makefile                 |   2 +-
> >  arch/riscv/kvm/vcpu.c                   |  14 ++
> >  arch/riscv/kvm/vcpu_timer.c             | 225
> > ++++++++++++++++++++++++
> >  arch/riscv/kvm/vm.c                     |   2 +-
> >  drivers/clocksource/timer-riscv.c       |   8 +
> >  include/clocksource/timer-riscv.h       |  16 ++
> >  9 files changed, 333 insertions(+), 2 deletions(-)  create mode
> > 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
> >  create mode 100644 arch/riscv/kvm/vcpu_timer.c  create mode 100644
> > include/clocksource/timer-riscv.h
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h
> > b/arch/riscv/include/asm/kvm_host.h
> > index 64311b262ee1..4daffc93f36a 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/types.h>
> >  #include <linux/kvm.h>
> >  #include <linux/kvm_types.h>
> > +#include <asm/kvm_vcpu_timer.h>
> >
> >  #ifdef CONFIG_64BIT
> >  #define KVM_MAX_VCPUS			(1U << 16)
> > @@ -66,6 +67,9 @@ struct kvm_arch {
> >  	/* stage2 page table */
> >  	pgd_t *pgd;
> >  	phys_addr_t pgd_phys;
> > +
> > +	/* Guest Timer */
> > +	struct kvm_guest_timer timer;
> >  };
> >
>=20
> ...
>=20
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h
> > b/arch/riscv/include/uapi/asm/kvm.h
> > index f7e9dc388d54..00196a13d743 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -74,6 +74,18 @@ struct kvm_riscv_csr {
> >  	unsigned long scounteren;
> >  };
> >
> > +/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > struct
> > +kvm_riscv_timer {
> > +	u64 frequency;
> > +	u64 time;
> > +	u64 compare;
> > +	u64 state;
> > +};
> > +
>=20
> Hi,
>=20
> There are some building errors when we build kernel by using allmodconfig=
.
> The commands are as follow:
> $ make allmodconfig ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gnu- $ mak=
e
> -j64 ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gnu-
>=20
> The following error occurs:
> [stdout] usr/include/Makefile:108: recipe for target
> 'usr/include/asm/kvm.hdrtest' failed [stderr] ./usr/include/asm/kvm.h:79:=
2:
> error: unknown type name 'u64'
> [stderr]   u64 frequency;
> [stderr]   ^~~
> [stderr] ./usr/include/asm/kvm.h:80:2: error: unknown type name 'u64'
> [stderr]   u64 time;
> [stderr]   ^~~
> [stderr] ./usr/include/asm/kvm.h:81:2: error: unknown type name 'u64'
> [stderr]   u64 compare;
> [stderr]   ^~~
> [stderr] ./usr/include/asm/kvm.h:82:2: error: unknown type name 'u64'
> [stderr]   u64 state;
> [stderr]   ^~~
> [stderr] make[2]: *** [usr/include/asm/kvm.hdrtest] Error 1
>=20
> Is it better to change u64 to __u64?

Okay, I will investigate and replace it.

Regards,
Anup

