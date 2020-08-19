Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6D249A17
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 12:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgHSKSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 06:18:39 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:20097
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgHSKSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 06:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=M9rnylawN8c3PtSgn6fCs4xu/S6cOIoszPyVEKyJJleyC7Or/9vbq4tjULaT8Z6sgT3kR124LWIlxzpsKFA++XNZ02qZxtgXX6hCOYVygcOjVWEfInLrHvIJd+Nb41d/7/E/LPpDQBbMk6innNOrEUjfUIYt903PUB9uS+LdxX4=
Received: from AM5PR0202CA0004.eurprd02.prod.outlook.com
 (2603:10a6:203:69::14) by AM5PR0801MB2116.eurprd08.prod.outlook.com
 (2603:10a6:203:31::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 10:18:33 +0000
Received: from VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:69:cafe::dd) by AM5PR0202CA0004.outlook.office365.com
 (2603:10a6:203:69::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Wed, 19 Aug 2020 10:18:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT044.mail.protection.outlook.com (10.152.19.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 10:18:33 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64"); Wed, 19 Aug 2020 10:18:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8042e54646a5.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id FF78DDFD-C69A-4EB8-B2B4-1CAD106CCE10.1;
        Wed, 19 Aug 2020 10:18:28 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8042e54646a5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 19 Aug 2020 10:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QidqKe8DGygR4ITrZjs+G1xzyvrOvLOF8p3bE1NqbFDgFLqw4+atAddzVVhtEqcrw0++NZe5OLH4gfNnFxzNGA9KwhpkMwwLp2tKFB2LaZEWcwvwFdTM2qB01ZOWgVX48fEdicp738GhonYQuIMYmCMWMY42ZbHfwS5f9kS+ndnc7AUiukSEbwiSSscNVmraMx0SQ6CvlE1jz7n87g4LsjwnNLjhH+452BOpwYE+9r6jaRIgdlMM7FQhUy9F2C48nBqtnV082Rk+/RvvdGdKU/CYGUCc0kIiH4F6dn5EBUZSBprHtXySgRaIhZ6d60XR5pRstvBTeYTiwRJdgsvrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=cydiBBe69ruksHYs04AYtllDgi69XtHQafaDPMrSpGRCvzk6pzCniqM5cq2Z1rVN+7X+h7gDNg6jnMoMUN47sCZnCxnKCPVNlfSbn/tUIvx9ooRjwx2G4+90/7AuPZSL2ac0Y909t0+3VOq0YM6Z3S7ARHYgodQWAVvHC2L1M9oiOsfoRdyV/UGOnKGB4HnushwQV9F3CvOYBlgpi3LumXlJDH3YiAUzTwDDehLx6+Xj4kberFqBw2j0v5oEaEYO3qkuAU7Yo9frGrTl05PWoU4F8TR+64+C5Ny26UC8x/4Cqvu6mLZddxcasmat4xI/4yr0bF5sqCQP7It97wGT0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=M9rnylawN8c3PtSgn6fCs4xu/S6cOIoszPyVEKyJJleyC7Or/9vbq4tjULaT8Z6sgT3kR124LWIlxzpsKFA++XNZ02qZxtgXX6hCOYVygcOjVWEfInLrHvIJd+Nb41d/7/E/LPpDQBbMk6innNOrEUjfUIYt903PUB9uS+LdxX4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1977.eurprd08.prod.outlook.com (2603:10a6:3:4d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 10:18:18 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0%5]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 10:18:18 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Peng Hao <richard.peng@oppo.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alexander Graf <graf@amazon.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Topic: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Index: AQHWa1Xu75d1j9xetEK2hY75HyglSak/PN3ggAALmACAAAFIoA==
Date:   Wed, 19 Aug 2020 10:18:18 +0000
Message-ID: <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
 <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
In-Reply-To: <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: F86E3AC848FF8E419C992080C2A9B61C.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3bca3da4-1c26-4354-8caa-08d844293a68
x-ms-traffictypediagnostic: HE1PR0801MB1977:|AM5PR0801MB2116:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0801MB21166252260634BDBA6FD429F45D0@AM5PR0801MB2116.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:489;OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 8bXqE66Sg706QvPREXnCtdkMSQUwyH/ET+CorMfSeudvTaeKiT+4XHWzj8TKq+D+7eNjlFj2n6UKUcJENscAhRMCflvqmJJU3Oh2jnZNBnmCk/wZf7sl5g+g+/IZX9/HNz8HfT0SZ6awyfX3VRXyndDkQcSrX9nVOT9TwEDiXX9lqArtfj1xXbip0xBlrl+oPsQYdH1KjmYKNMyXRmEJDQZITZ9Q0MrpZmYxmPDGd6kr/yMiRzuq6Nmm5DoZoXICHckTLKKr5cOnLltD1Vg+Zu3V/SjBBWMyWmmqU4ejjOBfw83Xy2Bxsg+ve7LVfzpJ2FIfAV3cRFNsXPOVsjq/tXdXTo4AS4eT6DxSK6TRvuS2GvfJNbU+92lFE6XtcIDCnZU76Q73x7BPPNbxqMcwiQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(4326008)(86362001)(478600001)(71200400001)(5660300002)(966005)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(52536014)(316002)(26005)(8676002)(2906002)(186003)(6916009)(33656002)(9686003)(54906003)(55016002)(7696005)(8936002)(6506007)(53546011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bhwT1X+O/D7o3QnkYMYWDCanVzkIixxQWHT7ULaxey1H/4sd1PY0kVcceGsFIZMyg0c+G+hnvluXW96X1FiWHenWSNDd3o0CrWmgZWon7i4YdCAK1++g0oogRtozZnyWfq4IZsAAU5n1/Y7O5fcJ6f+/3dePTl58bvvCjsJfiUHlCYrvl+TyyAWRZu0rCD3g7jSHhKF2Fxzv1/7qhG91wu73t+JDxypXc/vuh5ExmY7llbEym/pjZIpMq6Hl0UFUOkpjXPoaLg/Qefuvmo2+r/hQvW4DzzFVC0C0feXllfrNM2ZG4MVlguEnm1iEML/ZoS3cIar4EDMQQZigMBjOICNexY2PGS4yaqfNT7oYO601n1xiZyqZjp8oUNUQHWltQspTJovg8NaOoWRNbPPNbqcMyy9cjkWi7KKuXCC4i5cQcsXkfOudiKKnWw8dvKvWj5CKzziixF5aTwU8JO09lyT8rBuAAm0HsU1SMP0p1EswhVVymzb1EBCB0+cHHT14inUfxsfqthpgFz/23jg0h9mh0KA8sKPTiLUX/ui5dCBoetNK/n2GxnrWQtlprJ8FhkY+pis4/pUHoeBTyFda8j0pjarrLylgXEZU91A4KSKXWVkHThTMUE/hMfCL/KWV15HXt5yfqOPpbkItkRq4Iw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1977
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: daf8c6cb-1902-4f2a-f075-08d84429317f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZvb2+GFWMIdJ8Og5xncxLJk4G+FNuTSfeHC3qUwk56AJcLzZPRctEVYe/1pN3UDgWVBVKFyEvjOn80tY3jY4NpVF0u0lTDPUKVGFYcGEjemVYmkhdJj7U8ZqybVjpEtOXZmZAmEvnsiNpA9CvVHshT9fht+fv4K4It2fBzabhc4BcSJ+bKWLrGKFYlmT9UjxZbHw6JQnNqANhvqiAYVBr0fvbZUe+IMBtaszVFUsNUxFDbw3zr/QzrCwYt58mi+G8h0BLbYTPYwLD7FeQunOciuAN4kFjqW9MGlQdbtx87UnoDxVmCb5gcxrYEcYLxu09AKs+zNDClZMKah/gM0Wbm/+nhz4hH7ZeT8PclYDQ8do6FOW3WqRBzV8rfocM4r3MTPqWzlJPf+LQf7mJ1aml9X2zdC6LAEbicOyV/miI7QvFUbMR+S+Lq43yDCBvBgRHGqdnHCNzGFiD1UxyKG0wxg4A3MIzuEsj4mb2dFoeo=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966005)(478600001)(2906002)(107886003)(7696005)(4326008)(70586007)(9686003)(83380400001)(8676002)(186003)(55016002)(33656002)(70206006)(54906003)(82740400003)(316002)(86362001)(36906005)(6862004)(82310400002)(52536014)(356005)(5660300002)(6506007)(336012)(26005)(966005)(8936002)(53546011)(47076004)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 10:18:33.6080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bca3da4-1c26-4354-8caa-08d844293a68
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB2116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Wednesday, August 19, 2020 6:00 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
> <richard.peng@oppo.com>; kernel-team@android.com;
> kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to th=
e
> sys_regs file
>=20
> On 2020-08-19 10:24, Jianyong Wu wrote:
> > Hi Marc,
> >
> > -----Original Message-----
> > From: kvmarm-bounces@lists.cs.columbia.edu
> > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
> > Sent: Thursday, August 6, 2020 1:57 AM
> > To: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com;
> > kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> > <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> > kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> > Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
> > sys_regs file
> >
> > Move the timer gsisters to the sysreg file. This will further help
> > when they are directly changed by a nesting hypervisor in the VNCR
> > page.
> >
> > This requires moving the initialisation of the timer struct so that
> > some of the helpers (such as arch_timer_ctx_index) can work correctly
> > at an early stage.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   6 ++
> >  arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
> >  arch/arm64/kvm/trace_arm.h        |   8 +-
> >  include/kvm/arm_arch_timer.h      |  11 +--
> >  4 files changed, 136 insertions(+), 44 deletions(-)
> >
> > +static u64 timer_get_offset(struct arch_timer_context *ctxt) {
> > +	struct kvm_vcpu *vcpu =3D ctxt->vcpu;
> > +
> > +	switch(arch_timer_ctx_index(ctxt)) {
> > +	case TIMER_VTIMER:
> > +		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> > Can I export this helper? As in my ptp_kvm implementation I need get
> > VCNT offset value separately not just give me a result of VCNT.
>=20
> Sorry, you need to give me a bit more context. What do you need the offse=
t
> for exactly?

Yeah,
In my ptp_kvm implementation, I need acquire wall time and counter cycle in=
 the same time in host. After get host counter cycle, I need subtract it by=
 VCNT offset to obtain VCNT. See https://lkml.org/lkml/2020/6/19/441 https:=
//lkml.org/lkml/2020/6/19/441
But now I can't get the VCNT offset easily like before using " vcpu_vtimer(=
vcpu)->cntvoff" and I can't use the helper like "kvm_arm_timer_read" as I n=
eed acquire the counter cycle in the same time with the host wall time.

Thanks
Jianyong

>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
