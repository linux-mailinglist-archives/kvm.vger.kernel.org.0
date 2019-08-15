Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B558F08E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbfHOQZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:20 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:65343
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731382AbfHOQZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS0WTXY3tJwldAiaWMaVsNmvIpjyliDBrBURF4Zcy4fcaf3K8H/ns+KoiaUOcQ2Mb2Isy+wH73fuwpdFGyyHbHbLNXGDs1ro1XXUE8gH86kdeXQPi2DYf5DdVwoPiVSUIgSlY1lliaGPs1x6hRCngX91ZOiPTAEJetSJj8pNiGH8Z8Qj1RI3I55G180al/aTTT0hxNX2kGboOGx8gj384BmtkOyYojMeB/mj70nN5g4tJb5RtjctdTHGuEVNi2896bu2qgDDfs2P11eNkZMIcFEOmKThA7Xlb9F0vJwTeva93cFL7093TZw5QxDogXAJmTtPDl0mbwF2LY2oTNPVcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS8NcpKb9C+yiruPoRdnl55cIjRnl3m/XryAFuFXdQU=;
 b=Cj0XNJ+q4TswE2C2DaGA5wSltVE0xOqmVaxfBmZOmnDuG3zlyFu329M8wlh4qniVuMa192DFUEczZz4bJ03LtT+/Y+nFK6Wk3+AAmY1JYvqCxfoKbdt3YwdCDlSxj3e5QCcvhb8tqeI9o1Jtw5E4/EruDnYdSM/LPYxtMaN7e4TOoQ1TtBBBxL+AiHyymO8aAKag7vhr3r9indlDVbKxsFA/girYRGYPJ1Umu8bRi0zisOrfNF1VekPA2VKwtuPVlYGQzgVx/mh+Hz5PgwfMFHIyJwoPYJ8S07hqrkPWfS/eoNhnpLO9qikPhZU6s4LGPGptizrpDNOTAR3YRK62Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS8NcpKb9C+yiruPoRdnl55cIjRnl3m/XryAFuFXdQU=;
 b=uyFfZNmM/uojoBnrydLPvCyDaeNH0zqKbRIjBUA98eYMdwUiFHiQJabHGveTO8kBTzvJedv3ynidgbaQxBokb2z3NCVjNM8vv16aZsaBS0VCp9GXnKr3HBJycaq5ggCeY2yDP/E4+XjoAGjQflUwfUiH1VDQWtXtBOoaU0U76ro=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2603.namprd12.prod.outlook.com (20.176.116.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Thu, 15 Aug 2019 16:25:18 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:18 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when injecting
 irq on SVM AVIC
Thread-Topic: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
Thread-Index: AQHVU4YGnOwcrgTvnU6R6KE2IzCt1w==
Date:   Thu, 15 Aug 2019 16:25:17 +0000
Message-ID: <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:805:f2::25) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e75f4fb-4179-46a0-bb06-08d7219d28e0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2603;
x-ms-traffictypediagnostic: DM6PR12MB2603:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB26033658A49046A29E684A95F3AC0@DM6PR12MB2603.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(199004)(189003)(14454004)(256004)(6436002)(81166006)(81156014)(478600001)(4326008)(99286004)(14444005)(5660300002)(25786009)(50226002)(8936002)(305945005)(66066001)(476003)(26005)(6512007)(6116002)(186003)(102836004)(7736002)(446003)(71190400001)(53936002)(2501003)(11346002)(6506007)(2616005)(2906002)(6486002)(8676002)(386003)(36756003)(3846002)(110136005)(4720700003)(316002)(486006)(86362001)(66476007)(66946007)(66556008)(64756008)(76176011)(66446008)(54906003)(52116002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2603;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xmdg2oxpLNPC/M53vb416T/9/2H/PE8u4Wb+iE/efhg9FYx821luiycyySX8U+ThPKZSXhuWGe6QwsEnej0m/8L79IPHybd0jvtBwqPWbbuiZ6n/LWdBL7L7PkkWIX7T+pMGxi1F/MNrrb0qHDK3/0pH9IU9D47PjdfxeDGrZbA5l5I/rMMlzzUGDMEguZm+xRbg5BbKMIc2k405KmYABWJ154sUDfO5RWydDEknLaxZhZUoKC1T4KcJizmQioboCmZcU7G6C1zu6Dj3xq9kQS6zoFaTMWgZJVPiTXfObmwUImNjCcwdKAlet5mReDnH92+hHJ4JSQ1gUsbts0OEJvzUYCSh9xHsTrnBLr1rm14Ki4mIGPb4RPW6voAKHN5xlcFq7+p13edCrdR2zQ1+fsVpCQre5VIPbE7jGqi9AF4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e75f4fb-4179-46a0-bb06-08d7219d28e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:17.7092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+Rq4hqGU6h5CTg/L4gLrPZX/g7pwWzzGiZz4G9HLhhVSJpsYq5K9gZ0PSQYnxwyUjt8nJdN3HUaI1VBFfo0nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ACK notifiers don't work with AMD SVM w/ AVIC when the PIT interrupt
is delivered as edge-triggered fixed interrupt since AMD processors
cannot exit on EOI for these interrupts.

Add code to check LAPIC pending EOI before injecting any pending PIT
interrupt on AMD SVM when AVIC is activated.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/i8254.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4a6dc54..31c4a9b 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -34,10 +34,12 @@
=20
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
+#include <asm/virtext.h>
=20
 #include "ioapic.h"
 #include "irq.h"
 #include "i8254.h"
+#include "lapic.h"
 #include "x86.h"
=20
 #ifndef CONFIG_X86_64
@@ -236,6 +238,12 @@ static void destroy_pit_timer(struct kvm_pit *pit)
 	kthread_flush_work(&pit->expired);
 }
=20
+static inline void kvm_pit_reset_reinject(struct kvm_pit *pit)
+{
+	atomic_set(&pit->pit_state.pending, 0);
+	atomic_set(&pit->pit_state.irq_ack, 1);
+}
+
 static void pit_do_work(struct kthread_work *work)
 {
 	struct kvm_pit *pit =3D container_of(work, struct kvm_pit, expired);
@@ -244,6 +252,23 @@ static void pit_do_work(struct kthread_work *work)
 	int i;
 	struct kvm_kpit_state *ps =3D &pit->pit_state;
=20
+	/*
+	 * Since, AMD SVM AVIC accelerates write access to APIC EOI
+	 * register for edge-trigger interrupts. PIT will not be able
+	 * to receive the IRQ ACK notifier and will always be zero.
+	 * Therefore, we check if any LAPIC EOI pending for vector 0
+	 * and reset irq_ack if no pending.
+	 */
+	if (cpu_has_svm(NULL) && kvm->arch.apicv_state =3D=3D APICV_ACTIVATED) {
+		int eoi =3D 0;
+
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			if (kvm_apic_pending_eoi(vcpu, 0))
+				eoi++;
+		if (!eoi)
+			kvm_pit_reset_reinject(pit);
+	}
+
 	if (atomic_read(&ps->reinject) && !atomic_xchg(&ps->irq_ack, 0))
 		return;
=20
@@ -281,12 +306,6 @@ static enum hrtimer_restart pit_timer_fn(struct hrtime=
r *data)
 		return HRTIMER_NORESTART;
 }
=20
-static inline void kvm_pit_reset_reinject(struct kvm_pit *pit)
-{
-	atomic_set(&pit->pit_state.pending, 0);
-	atomic_set(&pit->pit_state.irq_ack, 1);
-}
-
 void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 {
 	struct kvm_kpit_state *ps =3D &pit->pit_state;
--=20
1.8.3.1

