Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CCDA0806
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfH1RDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:03:01 -0400
Received: from mail-eopbgr140095.outbound.protection.outlook.com ([40.107.14.95]:48192
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbfH1RDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:03:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1SgP3pt1F+VplJBID8OtUYTL2SoJYSHOPKvGldbsiKlFAp5b9Xgkf2Mp15Un2JqDUWPBK6VTmOjkLa2Hbv6hGbxQyGfznF2vifKbMPjJRcETozGhYtYdGvvdJTm484ZXzL+3walln30+CQFxKOcmYdDmgfJMq7NScc8Jk38kQ9MYldI+FuyKEtgxSTk4mSZrXJ7ferh151nnhX0SzADcVY9tfjCLwwg+dy45m5iUoesQv20kCy+Ms3OqggeBPhDT/4JvaVdfY6togZLHuwzwtudYwjUU0bw8wkgMcql1EQouklgebf6AgAHaolKIf94e1M6b8sHE9eUuPSAE4Lnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh3jtT+lXogQSO3KQAYL4qcU6PTMONzl/DOKLnMK8IM=;
 b=eq5aUk0VZ1tHDQiwGvzfTdJPoL0lxWcuBjXIqVt+mzPikUwK40oxD4ZLqoEoH26IsIsnO9tc8wL+9Ez0l/rqS4KNVqZpXxc7RxZGoESHCK1DgehNdJApicFucREDAyw8ZjcRaWMKyjlpwX7oHI/vrqpMHOlTBsDb7b3hh4Ff9CnZ6KEY/jIixUTz3laQsJ3QlQWe/gcFgRJFdt8sbVjI3hUlPf/5cvGC3AkA5KfkNFATL4FDi1ACAOTe/PC2WkhshXkoOR6o1cr4jNHnAoQZeTT5kSsLBc+eVS/+G8B5ZW8LymqQHlbYYxYem0nlWTtFU/TQ1biI/uxAZ6jsp7kHQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh3jtT+lXogQSO3KQAYL4qcU6PTMONzl/DOKLnMK8IM=;
 b=HEJ4FiAxcObqo2cRAyi/Jkyq2+mZUWfxpHTaKpsFsmsl20oD63L/AU98ROHZ3uyIE4wCbNU3dRso6PvTuuoSn30ryZ+bp1pcIrU8Wbqx759ddpnKgxodEDXKl4QGgpukyiytvRgwkKfQpPHnh85D5OPV2mRKIazQTgaz2WFWcic=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3181.eurprd08.prod.outlook.com (52.133.15.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 17:02:55 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 17:02:55 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v2 1/3] KVM: x86: always stop emulation on page fault
Thread-Topic: [PATCH v2 1/3] KVM: x86: always stop emulation on page fault
Thread-Index: AQHVXcJv3UD3akQ2HkiJEaqhuDTLcQ==
Date:   Wed, 28 Aug 2019 17:02:55 +0000
Message-ID: <1567011759-9969-2-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:7:28::41) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b76d02b3-7759-4981-aafe-08d72bd991bd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3181;
x-ms-traffictypediagnostic: VI1PR08MB3181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3181FC1ABB7F3A3CA1650A218AA30@VI1PR08MB3181.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(39850400004)(136003)(396003)(189003)(199004)(478600001)(26005)(4326008)(8936002)(14444005)(186003)(102836004)(3846002)(256004)(476003)(44832011)(6486002)(66066001)(6512007)(305945005)(2906002)(2501003)(446003)(86362001)(6436002)(6116002)(66446008)(8676002)(66946007)(64756008)(66556008)(76176011)(66476007)(316002)(7736002)(81156014)(52116002)(25786009)(81166006)(71190400001)(71200400001)(6506007)(486006)(386003)(14454004)(53936002)(99286004)(2616005)(5660300002)(6916009)(2351001)(54906003)(5640700003)(36756003)(50226002)(11346002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3181;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0MKtYWJkeb3OZ/91KKHEedEMwjJu7z+alGdFdqTmrl/clHEYXaka8grIbTD5SsCEP+fctdOZ2NruFikW3bVCbUXqu/1oavhA9Ccqx1rRqiBQp9HoHiswG0Cu8gRE64GoUFt5Ut9r1jidcRPrc6FlEXOnTvwgytwg9IPSRDEqwna2lFl4lbDm1YhAh7u9z7Z4cj5+6N20XKtux9ob6yQNiurOHbJC896sQx/4AmaeDktsUMW2GOyNklmiSTQvJ+PhEdl6d1XOurtPNAfnabtGtjY5V2Ezp96TKZH1QKtR6Cd+Vmwt5EGGgpmmoM/J+oStyxn+Jik5mDpzNh0xtoCo16wHgrXO9/w64a9YYEWcP/FtmCXYKHM8OCEAdlr8mcJONtiYbJAHVGXGzd1dILBtSxfcYorgHWt+wkWWbcJwyHc=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76d02b3-7759-4981-aafe-08d72bd991bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 17:02:55.3276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t83KJU1zpEBoq+zSBDdFd//2pN8xrqtCY+Dziha7dgHyXOURf3f1BL9AwlJGbkPS+Rbae747Pe2wp1q0ETBoCt4HjmVhJEovtXuQCT8m+Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

inject_emulated_exception() returns true if and only if nested page
fault happens. However, page fault can come from guest page tables
walk, either nested or not nested. In both cases we should stop an
attempt to read under RIP and give guest to step over its own page
fault handler.

Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd78..903fb7c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6537,8 +6537,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
-			if (ctxt->have_exception && inject_emulated_exception(vcpu))
+			if (ctxt->have_exception) {
+				inject_emulated_exception(vcpu);
 				return EMULATE_DONE;
+			}
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
 			return handle_emulation_failure(vcpu, emulation_type);
--=20
2.1.4

