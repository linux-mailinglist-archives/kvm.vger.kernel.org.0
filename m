Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0AEB2594
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389124AbfIMTBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:17 -0400
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:62364
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388220AbfIMTBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3JHlKiCDIbOSb/EwuY4+LjbN5NIMDs+PU5NsOH8XkIv5MWfW4c7rvKP4j0eB094+XETUh3o2bUpRTQg6PgwNYK7ENW722hS88Rf1/Y382Ro/fk+IYhvzMy3kgClUfUH7b18Rh+0HazovMx2fFqzJqDo8fiEwB3MR3ymO2ZAYRNX1eYA+Np3Wvzh9hxv5VDRZ7ujSZuI4KvnCsHbSqfaNNE3vVV7xs5RrE3LkUmm1tXac2JeD2U8WlhtsCmE/88lAi/9Uqtt9JJm19HSjPRYG7Ho0tba9R61pkd5kJZmco/F+FoR7X4Hn5I3TW7FQYOB+2Zdyy1SGe7abwQTZfstLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arfgzgyqC0J1QQ6ohwfz7F3JdvsDqPD8+8QUqeUf128=;
 b=WrJYGR7EGODtb7DfafF6cr9r9oPI6fD7J9S2+2j7wvWanx2aFAhmJCVjEUwxlYLbxBqoZbdnNdP2YocZsqBDJpJCHiQnat0m9OBwnQGudh/LEMlu9vGhHDLMuaJ4SrqSYp8ZIekSNzvOBS+5L4w5CKEQgTGp03PyRLBpy6mcwJsIS/WpCE8jh0A5GbXzeXvghUQmID2MUpHv1mAR7s2hkR4sSlmdlLOyR0e5FZumzJhbYgNWvW42xzWP5V144mRbFtjzCZZLHsLxsEo6Obtw8kPDiUEa0uL6yZvLhMWXJV6VV61WRHqwBkEhwjBLiTggxmcrRo1UaAH/NrSP/VV49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arfgzgyqC0J1QQ6ohwfz7F3JdvsDqPD8+8QUqeUf128=;
 b=E8dAmhiTB3/CW+hyh5XzEAWrdFGR4q+L4LdVRKWLeTZ0pD/C+84ju6jAeA/EojNnIzOuiIeKifUKOiM1eGf0GNxadPAy147P/AOqsKNMMg+SF2RHwWTTqpk0q0HMfz03KCyL2Fmw0kdGt9/3svqqw6dr57jAK3rmOOdS7sB7/mA=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:01:09 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:09 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v3 14/16] kvm: ioapic: Refactor kvm_ioapic_update_eoi()
Thread-Topic: [PATCH v3 14/16] kvm: ioapic: Refactor kvm_ioapic_update_eoi()
Thread-Index: AQHVamWa/amPLZfiXUew6Og+woQR3A==
Date:   Fri, 13 Sep 2019 19:01:09 +0000
Message-ID: <1568401242-260374-15-git-send-email-suravee.suthikulpanit@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8226993-3505-480a-b9e9-08d7387cbc8c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB359634DC12538B3E15AE9F5BF3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(8936002)(66476007)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SNcfRJ8bjbMasTHcY67CdU1ZIEMIqHC5e5cDLJ8EYHNKGYC1WPMQeD5gg2+C+fEtqOiBfjOMlZNef8+57KemMFoWoGWzsVt2uAzDitZG9gMODkIuU/5mnJfqv1P8ZEaDv7ItNIlphQkK2bz/mSz0/3qx1vCFBFB++nncWyUpTMuMFLkonl837ZKU8sokihcdSgcE46Bc9Av94tWx2islX0b5izh4hEv8DYMLqym/iYeoimge9J7vCPiCGfG0vvblJ9iyejSVgAjTme5Odo6LsTnmNNlxIA1dWluZZmjlAylmrIsOL7cDFHTUWglchR+80iRfAPjhEuPl3P+w/aCzxxPzTKoFJ9OJbvA/O5eHBoPQlrNlvzqSg2wZ+BTQyfKqUMiTa/wI6JMDl26fAgshbJNlLu2tVgEwo9sq0KI85kM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8226993-3505-480a-b9e9-08d7387cbc8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:09.0701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y2FTtIzVCr64gSKpMXVddSxIToF7t2PIVh1FyhdgtqEGNHm3PFCWrTA3pDUgfdqL0ljlMr/MwgS28V1+11lwOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor code for handling IOAPIC EOI for subsequent patch.
There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 110 +++++++++++++++++++++++++---------------------=
----
 1 file changed, 56 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d859ae8..c57b7bb 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -151,10 +151,16 @@ static void kvm_rtc_eoi_tracking_restore_all(struct k=
vm_ioapic *ioapic)
 	    __rtc_irq_eoi_tracking_restore_one(vcpu);
 }
=20
-static void rtc_irq_eoi(struct kvm_ioapic *ioapic, struct kvm_vcpu *vcpu)
+static void rtc_irq_eoi(struct kvm_ioapic *ioapic, struct kvm_vcpu *vcpu,
+			int vector)
 {
-	if (test_and_clear_bit(vcpu->vcpu_id,
-			       ioapic->rtc_status.dest_map.map)) {
+	struct dest_map *dest_map =3D &ioapic->rtc_status.dest_map;
+
+	/* RTC special handling */
+	if (test_bit(vcpu->vcpu_id, dest_map->map) &&
+	    (vector =3D=3D dest_map->vectors[vcpu->vcpu_id]) &&
+	    (test_and_clear_bit(vcpu->vcpu_id,
+				ioapic->rtc_status.dest_map.map))) {
 		--ioapic->rtc_status.pending_eoi;
 		rtc_status_pending_eoi_check_valid(ioapic);
 	}
@@ -415,72 +421,68 @@ static void kvm_ioapic_eoi_inject_work(struct work_st=
ruct *work)
 }
=20
 #define IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT 10000
-
-static void __kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu,
-			struct kvm_ioapic *ioapic, int vector, int trigger_mode)
+static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
+				      struct kvm_ioapic *ioapic,
+				      int trigger_mode,
+				      int pin)
 {
-	struct dest_map *dest_map =3D &ioapic->rtc_status.dest_map;
 	struct kvm_lapic *apic =3D vcpu->arch.apic;
-	int i;
-
-	/* RTC special handling */
-	if (test_bit(vcpu->vcpu_id, dest_map->map) &&
-	    vector =3D=3D dest_map->vectors[vcpu->vcpu_id])
-		rtc_irq_eoi(ioapic, vcpu);
-
-	for (i =3D 0; i < IOAPIC_NUM_PINS; i++) {
-		union kvm_ioapic_redirect_entry *ent =3D &ioapic->redirtbl[i];
-
-		if (ent->fields.vector !=3D vector)
-			continue;
+	union kvm_ioapic_redirect_entry *ent =3D &ioapic->redirtbl[pin];
=20
-		/*
-		 * We are dropping lock while calling ack notifiers because ack
-		 * notifier callbacks for assigned devices call into IOAPIC
-		 * recursively. Since remote_irr is cleared only after call
-		 * to notifiers if the same vector will be delivered while lock
-		 * is dropped it will be put into irr and will be delivered
-		 * after ack notifier returns.
-		 */
-		spin_unlock(&ioapic->lock);
-		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, i);
-		spin_lock(&ioapic->lock);
+	/*
+	 * We are dropping lock while calling ack notifiers because ack
+	 * notifier callbacks for assigned devices call into IOAPIC
+	 * recursively. Since remote_irr is cleared only after call
+	 * to notifiers if the same vector will be delivered while lock
+	 * is dropped it will be put into irr and will be delivered
+	 * after ack notifier returns.
+	 */
+	spin_unlock(&ioapic->lock);
+	kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
+	spin_lock(&ioapic->lock);
=20
-		if (trigger_mode !=3D IOAPIC_LEVEL_TRIG ||
-		    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
-			continue;
+	if (trigger_mode !=3D IOAPIC_LEVEL_TRIG ||
+	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+		return;
=20
-		ASSERT(ent->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG);
-		ent->fields.remote_irr =3D 0;
-		if (!ent->fields.mask && (ioapic->irr & (1 << i))) {
-			++ioapic->irq_eoi[i];
-			if (ioapic->irq_eoi[i] =3D=3D IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT) {
-				/*
-				 * Real hardware does not deliver the interrupt
-				 * immediately during eoi broadcast, and this
-				 * lets a buggy guest make slow progress
-				 * even if it does not correctly handle a
-				 * level-triggered interrupt.  Emulate this
-				 * behavior if we detect an interrupt storm.
-				 */
-				schedule_delayed_work(&ioapic->eoi_inject, HZ / 100);
-				ioapic->irq_eoi[i] =3D 0;
-				trace_kvm_ioapic_delayed_eoi_inj(ent->bits);
-			} else {
-				ioapic_service(ioapic, i, false);
-			}
+	ASSERT(ent->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG);
+	ent->fields.remote_irr =3D 0;
+	if (!ent->fields.mask && (ioapic->irr & (1 << pin))) {
+		++ioapic->irq_eoi[pin];
+		if (ioapic->irq_eoi[pin] =3D=3D IOAPIC_SUCCESSIVE_IRQ_MAX_COUNT) {
+			/*
+			 * Real hardware does not deliver the interrupt
+			 * immediately during eoi broadcast, and this
+			 * lets a buggy guest make slow progress
+			 * even if it does not correctly handle a
+			 * level-triggered interrupt.  Emulate this
+			 * behavior if we detect an interrupt storm.
+			 */
+			schedule_delayed_work(&ioapic->eoi_inject, HZ / 100);
+			ioapic->irq_eoi[pin] =3D 0;
+			trace_kvm_ioapic_delayed_eoi_inj(ent->bits);
 		} else {
-			ioapic->irq_eoi[i] =3D 0;
+			ioapic_service(ioapic, pin, false);
 		}
+	} else {
+		ioapic->irq_eoi[pin] =3D 0;
 	}
 }
=20
 void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector, int trigger_=
mode)
 {
+	int i;
 	struct kvm_ioapic *ioapic =3D vcpu->kvm->arch.vioapic;
=20
 	spin_lock(&ioapic->lock);
-	__kvm_ioapic_update_eoi(vcpu, ioapic, vector, trigger_mode);
+	rtc_irq_eoi(ioapic, vcpu, vector);
+	for (i =3D 0; i < IOAPIC_NUM_PINS; i++) {
+		union kvm_ioapic_redirect_entry *ent =3D &ioapic->redirtbl[i];
+
+		if (ent->fields.vector !=3D vector)
+			continue;
+		kvm_ioapic_update_eoi_one(vcpu, ioapic, trigger_mode, i);
+	}
 	spin_unlock(&ioapic->lock);
 }
=20
--=20
1.8.3.1

