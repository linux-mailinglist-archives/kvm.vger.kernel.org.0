Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891E5ECB86
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfKAWlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:49 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728238AbfKAWlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOd/zpRtgXb4cMWTQ4ywoKW4v25UXyGpJXFlZf/9V3daE16BDdqJ4TialcWU8Zjqj0w7aKj2bAcqxwTvSskb0zDMCqQ/GmvuieVxT1DTIwuWHmYR9hHy/Y4xG5CS84yDuZRSfsQAKOnXQOG9WX9tq+uo468CW7XaC73cCmHF2rBkDAzuphmKbAw7duXYkHqRzRzgGBWQbojLWKFeqFUxhzqrRIilRupSHcpzhgrhdcGsvD3Bqxlv+iQw+Q1/obN6E7O7nh99IfQUDqxbznPrxGQBd5lS937GioEbNLt+/7HKLKIq1DVqjeWOGIzjFS9rE7bbqOMUnsPRn5HEHhE1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arfgzgyqC0J1QQ6ohwfz7F3JdvsDqPD8+8QUqeUf128=;
 b=CxT9MzZ8Br3DlKClZDKqnvBABopyLoZ+1hnw1m/sEorf0ifs2Nnm76i+EIbC/6Cs3BHIeNOybl3zJOCEZRI2iccELor4yrRyAUxWW8P+aE+B7dwkhB/ZSyjvZmnuTh8VJowm3L6FZngaPZrH3Z2iGa+pFfCGvt1fn4Ta0LwSc2bcjFOp3/4ZBUDN1zq+JClD9oatv92DmchiAC60/EmkiZLIi9WtSd4iE44W4WRh3OLI7S6uGOvGKiDUjEshGev5kqrRk1Gtgp1BFCHJEUr6kTaf680dQ3h1ewdnOLidYYYp7RWEVRBdi5O8TplaTPk2DN4FBy0eOnZdehmf6noLKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arfgzgyqC0J1QQ6ohwfz7F3JdvsDqPD8+8QUqeUf128=;
 b=VZNGMhSL+A+sjW+4ZKiKr+WrsYX4qBLCoT0E+4qkrLbPekf9S96vNY1alI7c4Ciu+J/PmIyv8YMUGY0h3S7Xlao1F+B/u2TAu/wT7TJrJSoQQjs6LMnypjWoPuFFjPr5i712bdPfYZx/tg539hQXiCD7JPsTb6AzjOxEd4xSMbk=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:40 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:40 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 15/17] kvm: ioapic: Refactor kvm_ioapic_update_eoi()
Thread-Topic: [PATCH v4 15/17] kvm: ioapic: Refactor kvm_ioapic_update_eoi()
Thread-Index: AQHVkQWGNwVFfntfBk6Z1WAg4bf9EA==
Date:   Fri, 1 Nov 2019 22:41:40 +0000
Message-ID: <1572648072-84536-16-git-send-email-suravee.suthikulpanit@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN1PR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:802:20::18) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f52c0367-f623-44a3-7cd2-08d75f1ca956
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32437C0B722D0ECCEFF3994CF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ttjjt8gHYUOBlJLsf7OqVuXaiqpbiQVvoa1tZpX8ONIg7e8cJcPa33jqwHr+Jja9zXiiD9AzwsQBcxMxDfnzYZqS5q56OguGb9VNT2UmTpZll1/+vCLV3gxKhpsEy9N76uX4NqEbdKX8WoFzbAg/oM0lm13VoYDld38XF89lfDb6wbZ6TrYQ5KLCHqBPaYZfVcvyuY3AliY6Iv7MsAUm6sJmWuxJ3mS0gZFwQK2/bFQbefNDCtWzh7vTxhyGeubHTOYst+GAP6aMTuusHcSTbIkWM0gtmQcOWkrQjYwEFLsyeYkPsWetq4BUlMbnHtJYGnSXWRCAPdDREkV8RVk0bShxKpI0r8/s+8y4ueZHMobhr6ZcAOp5nktQW45gakJiBNmXm0q45X9nOqJUbYz6aualyaD+7oPgaX7rgDqzoZueN0NmqyxEMc+r5qKY+hK+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52c0367-f623-44a3-7cd2-08d75f1ca956
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:40.2824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAyRqoZf7xjrigshhCknvkLbfw+LhDLr9Or1KPxHDvC3XT0fxhqtnBfqtc1sISylfTvEPWKfVDR2bSVJLHh1Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
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

