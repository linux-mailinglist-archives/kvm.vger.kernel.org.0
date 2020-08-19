Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35A249942
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHSJY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 05:24:57 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:21134
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726863AbgHSJYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 05:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=+RIJDjmlKfAX09SvJgT1gQq787T+HmKMMl2z7Mim8uL19xXpEw2GVeA+2HVvk9RMlTbiuj48fkKKZQBnfpsDNtBYO/angvG5xAQFuvn0p5L0fUpRLvnoU8Rf21Pz4fFgvqqT10YrCrUbf3RYkgPloavFlF5YVWEcDpVvvWRBDN4=
Received: from DB8PR03CA0001.eurprd03.prod.outlook.com (2603:10a6:10:be::14)
 by AM0PR08MB5138.eurprd08.prod.outlook.com (2603:10a6:208:15a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 09:24:48 +0000
Received: from DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:be:cafe::7) by DB8PR03CA0001.outlook.office365.com
 (2603:10a6:10:be::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Wed, 19 Aug 2020 09:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT063.mail.protection.outlook.com (10.152.20.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 09:24:48 +0000
Received: ("Tessian outbound 7a6fb63c1e64:v64"); Wed, 19 Aug 2020 09:24:48 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0a134c5af661.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id DC653A3F-3496-4083-986B-DAE4821657C0.1;
        Wed, 19 Aug 2020 09:24:43 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0a134c5af661.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 19 Aug 2020 09:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0DCRWq/UNL/wIABNnI8Sow3AIHPDvdyi6GOXgUEDV92H2eYGDHuj8FQdkIdRuIteZFRNiakOtjQQ6jLWbF00+Nz1c3LRYOQQpisC14iohv87aN3pP7KDx1/Wqe6GCH45osffozFkMUpvNwrT3J3dghpcTb7LTWgW/TnCr+QD1aRBmJFSrNG/BVYszmX4PDbFBKUAUReHBRPfsDOOt0PNeqNJHtCE2V5jl4vhrko1URkandvg76BYtT6B0RsDlNpuzdaiP2rKq7C8qMJN+uEPrGJJADsEXDPT1xMmBThHTmr4I+BUJVnGC2Q1sqckcOBFDV4d9MNC7meEZdh0n1eag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=GC2WzO/n5a4J552AS9JUBDF8esGxw3JFHdIV2xfTcQ4jPWg2C6s5pOvGT45PpKYWj18ysz5prfFGs9pUoXO9nP+B0Kcz3NDsEFeQRdFQ89kBR2peVcV5B2dMjInOwBHIScrz0uo3gEpEtC2TECzV5S2/As+jA/jOPu61Zrc43gl53K3v+KOoh6p+pyxfxRn16Y2jvreHqQqqH9XFaIQHrTxT3pMyMKsEzuUZ9nQuNQML78PBT+OrnOL+YskNS2pPtx0nHdY19fDZcQqJnc3Iq3eUVrvOI4PRfmK8GuGKMuBPEPMGHXZMiqS9mQHwpA0A7nF8eDNGkw9v/qrbKrUivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=+RIJDjmlKfAX09SvJgT1gQq787T+HmKMMl2z7Mim8uL19xXpEw2GVeA+2HVvk9RMlTbiuj48fkKKZQBnfpsDNtBYO/angvG5xAQFuvn0p5L0fUpRLvnoU8Rf21Pz4fFgvqqT10YrCrUbf3RYkgPloavFlF5YVWEcDpVvvWRBDN4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB2108.eurprd08.prod.outlook.com (2603:10a6:3:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 09:24:40 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0%5]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 09:24:40 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     Peng Hao <richard.peng@oppo.com>,
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
Thread-Index: AQHWa1Xu75d1j9xetEK2hY75HyglSak/PN3g
Date:   Wed, 19 Aug 2020 09:24:40 +0000
Message-ID: <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
In-Reply-To: <20200805175700.62775-48-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 174DC4FF4714444F8D113E09FD85505A.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5bdc8bbb-88f1-4f3d-3112-08d84421b7eb
x-ms-traffictypediagnostic: HE1PR0801MB2108:|AM0PR08MB5138:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB5138448AD9A57E8B9CA3C346F45D0@AM0PR08MB5138.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: J9pWIrWyTZC5H7woAIreXTaNg8mDcZdRaesu7t4hSL9B3n0sFGEENN6TJt2+HXnev4Dp0I4H0B3JiCowkgBbdN99dsdFRctaZ37YD4nDcZD+niu0pn2jUETSerDjga4apKQghlSRke3yxzd7PgCNHIVCttxvzAHRjQdF7ZCFXS84Xyf9XRF5xMixknLWHP6M6JHXccGNwiHnDbj/U4uEGliSqe3WYey2b4+SYKE4r8sjt+pdGvrtMHUDz+N55y/UHeKDkPV9utgI/MItuTUGHGIVaTbRy+hJZztB/idLkSDflMRD7pejOVhrC7UXnDxCACXyeNKrkZ2+ALTHoBLevUoLo6kOYSwWrFZ51SSNNye7V682nLJmRLbthGMdTk4f9W1MQV1hocLHOTvyPNgXUw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(33656002)(66946007)(76116006)(2906002)(478600001)(83380400001)(966005)(71200400001)(64756008)(55016002)(8676002)(316002)(4326008)(66476007)(54906003)(26005)(110136005)(53546011)(7696005)(66446008)(86362001)(6506007)(5660300002)(186003)(9686003)(8936002)(66556008)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VsY8w211r3WIisHP/miFPjaRs4SdXz/DGe89jj88AxtB9k2K9XSNVUbk9aOHTo8/Exo5S3TPHs/sfwoYK5kD0ZSNlXRkX9neZcgftbW1S5y5pLIFdJTVL5UN02JeT6EJmuwduJSI+/eoT6ActbdmHnAvODpNzFCOXtq5PcX4TRI3w7LdlRbxQloNGa7T3fqqde4wi20S/dJQoi2ros4L+7mmDYX+28PG8HdLO8TflCucsCfwje7g1ze5sqiPEUNsl3Weit8IeH1yO9p6+be6TggtEh53DMqYWXxfKX7/ajlM2YchLq3oZHISHxIbwSTRWeact0bvN86rsI8VvGmY1+kaSmhmAwRLgTkqy9nqbsHgOgEZ3IZWxhmUAKnj+68fRfch1s8phLwACVg3X4cN5DdSuiwnMrWKekEejVizqhPEOqRoxZ4cLN2Vtoyz63n5mKmujVHKpv0XUvgpArug+XiQp52isXiGcBKzBHkxl8nh8vzM+seC5KAXmFHIM9lNRg2VDR1QCt0p+W0wouPh93645usIcqeIKN1VrAPxiGi2KSiKW09u6HGW5aN+XTt025sI5FKOShzfc/Vx4lJ4qjTJISmWRkuUtUibRUCkAKrLYZiAuLpItIb06KJw+g4WCVDWMIFQTCAWmgQHd+4taw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2108
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 28bc0b19-aba9-4daa-3746-08d84421b33e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8FGph7GmmEc3dTtvbs4EqARJH3v6XNkuRteEnJiwgXMzSbvyglZb5Sp97bZoI5wjxV8blzU++xhBi7jT08RNCAyFk0IWRoT4WKOgrnRo4PEsBTWE6KJC9Se1ZaVbF4wr1T/IEqoWzf7hJKGNxi6V6Yo4n/0ie99yRZ4GmR8NyfvxwO4s+cmO4HsRiGe0GfDvXH2alAeGhIUCw8anGJ5NW36HC5FIF9V4VkYV/ItIt30GqDWtKiJq7B7GdA15yjwu/86foQk3mJyKp/EJG6QeswPSKU2t6iyJwSLWsf2Rh/QmjJ5ynZ4241W1qgwnUPFCDcZETfl5mEcv1rCFfzw4aTzRC1oMS2knFthDM/N8Mp9JQY4IMt5ugzfGXJoi/DUWKB0CFEiMyxN4rrJOXKgPSXiORxdS/vQ+U+YGlt3K0BvXs+fmSB/plf/D7AmIJN36Dj8QFD97wiui7xhaOhFHA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(46966005)(2906002)(53546011)(186003)(6506007)(8676002)(966005)(54906003)(4326008)(8936002)(110136005)(26005)(5660300002)(33656002)(83380400001)(9686003)(82310400002)(7696005)(82740400003)(55016002)(107886003)(52536014)(478600001)(81166007)(70586007)(70206006)(316002)(86362001)(47076004)(356005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 09:24:48.3108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdc8bbb-88f1-4f3d-3112-08d84421b7eb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

-----Original Message-----
From: kvmarm-bounces@lists.cs.columbia.edu <kvmarm-bounces@lists.cs.columbi=
a.edu> On Behalf Of Marc Zyngier
Sent: Thursday, August 6, 2020 1:57 AM
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com; kvm@vger.ker=
nel.org; Will Deacon <will@kernel.org>; Catalin Marinas <Catalin.Marinas@ar=
m.com>; Alexander Graf <graf@amazon.com>; kvmarm@lists.cs.columbia.edu; lin=
ux-arm-kernel@lists.infradead.org
Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the sys_=
regs file

Move the timer gsisters to the sysreg file. This will further help when the=
y are directly changed by a nesting hypervisor in the VNCR page.

This requires moving the initialisation of the timer struct so that some of=
 the helpers (such as arch_timer_ctx_index) can work correctly at an early =
stage.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
 arch/arm64/kvm/trace_arm.h        |   8 +-
 include/kvm/arm_arch_timer.h      |  11 +--
 4 files changed, 136 insertions(+), 44 deletions(-)

+static u64 timer_get_offset(struct arch_timer_context *ctxt) {
+	struct kvm_vcpu *vcpu =3D ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+	default:
+		return 0;
+	}
+}
+
Can I export this helper? As in my ptp_kvm implementation I need get VCNT o=
ffset value separately not just give me a result of VCNT.

Thanks
Jianyong=20


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
