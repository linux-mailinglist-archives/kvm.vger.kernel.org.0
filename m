Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87D68F089
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfHOQ0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:26:05 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:65343
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731441AbfHOQZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVXyF8AdekZiLxmdvZxjJ5VrPdEZZO+ndvp1G40jk6guK/ZFwXKQE1b2TIkBwfgX091/q2vLYsHjk1Xxsd9TJ19MJ4dpq6XrWyOzYW2TsF/zW7royHk7f790QRtzpXm8MSAYoUb9+cQ7yoA1yjyS3yd8dBBmRODOpj06uP4DsZp9p/kQeByaeWZ50BR9MJseb0fHi/L8ker9NvSPCVf43uTmTTXn/wusJjqXbyU1ui8XN/4k2vGivl7R02ylKsDLYrtXMkDJe0QolVXBh25+umk0VN64xczjhdZj3Rz8aehoxJjy3CVgy5b3PtI2IrbqqNSzO6D/rxE9Nt6VoesnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wa2tDZSFdjlCRDUD0+24Sd9lSEd8gM0SsP2nYdE1bcs=;
 b=T44Y73TUx5dO5BAP0ISMWXK6nXDZE4mxeDDO9X/ELSLHqvWAI2Of2ey9ct/rjeXV7qRCg6PObkpcTucCfQByJYNgag/M/uqhzsSZHIBYGD18ambpJEqeioHHXjx2j/E8zwG28GrxTY6svYuaOiEjlGr0GSo8AUNPcptmyGIozGocKEvv/t5L5onVlg8tKgls1Tmf9wUW4HNNoNbQCx4M2vqHMPal7tFkhfxzB+LbUBd3Palp6K+zqbtfvus//cIZqxAL70Hg4TIoXHBhbMvzH4E8BxJij1zzwJttjhQvHzVGODAtvfvDbjuw/OfKHkxN8U2mi7yiq2tzp93zKgnDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wa2tDZSFdjlCRDUD0+24Sd9lSEd8gM0SsP2nYdE1bcs=;
 b=gLepFjJ/hOkhH2vbWYr1Y8mkGbdAKl1YUFp38TEvv5yQM9T0E2vMDXIux8VeOsyh97cAiPkrmErGgQ6DYb8BZLavBNb++Yg6sHCWEEHCVSw4Ze+g8+0BbmInvwy894GkdEN2wqpMmVWKeBeM4zi+6VuW16BzKso7R2pM/utyO0E=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2603.namprd12.prod.outlook.com (20.176.116.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Thu, 15 Aug 2019 16:25:20 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:20 +0000
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
Subject: [PATCH v2 14/15] kvm: ioapic: Delay update IOAPIC EOI for RTC
Thread-Topic: [PATCH v2 14/15] kvm: ioapic: Delay update IOAPIC EOI for RTC
Thread-Index: AQHVU4YIh6tJvHdq80Sa2/XMOGUQVA==
Date:   Thu, 15 Aug 2019 16:25:20 +0000
Message-ID: <1565886293-115836-15-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 46bbc0c6-2b82-4135-1e0d-08d7219d2a60
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2603;
x-ms-traffictypediagnostic: DM6PR12MB2603:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB2603FDFBCE1040392CB19F68F3AC0@DM6PR12MB2603.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(199004)(189003)(14454004)(256004)(6436002)(81166006)(81156014)(478600001)(4326008)(99286004)(14444005)(5660300002)(25786009)(15650500001)(50226002)(8936002)(305945005)(66066001)(476003)(26005)(6512007)(6116002)(186003)(102836004)(7736002)(446003)(71190400001)(53936002)(2501003)(11346002)(6506007)(2616005)(2906002)(6486002)(8676002)(386003)(36756003)(3846002)(110136005)(4720700003)(316002)(486006)(86362001)(66476007)(66946007)(66556008)(64756008)(76176011)(66446008)(54906003)(52116002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2603;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wreklhotwQDPhTYHBA2LxN9Zj1Q80/l/tXvoqieylXeXsX3oyFHAm3LUP/euYlcLJVIaTHGMVBpwIgIKc8GiP+AuTFpy1CYhYdiQXMBP7xQfMaLLiFdVWGCSemS+DxUtSuggiyX7y3aHaxzdZdpk2oLalrX0q0wZObdqXDFOGr9B10SZpSPCBpKsVHz70e2v4Qsjis1h4a/ay3LWIVe7XmHUiIJY1qwm/faSoGXAJU9seL75cOm2N7Q23qWJ9IF4bpRmyWPWYilNvUS4XLufmuoQpqd9dRzRHsp3ucPcV5abObqByJE0R2tTO7tyADxkpHWOHAKrCSm6HnlirxBYt0+wPYv71+mD/awe8dwDFpYjezcaw8H6ujNfasOXNDcFW41Lg+8Hv9P0CTMsdHLkvK4b3r4ydcWq/egXe+SVLuw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bbc0c6-2b82-4135-1e0d-08d7219d2a60
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:20.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbqw0aa9wUuY731KOXq/sEojXS7VTu3h+tKZJlOnotblaLaga8bTZRJ1nOq5afwq++cPdaoOBQ2XWtSaEp3Kaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In-kernel IOAPIC does not update RTC pending EOI info with AMD SVM /w AVIC
when interrupt is delivered as edge-triggered since AMD processors
cannot exit on EOI for these interrupts.

Add code to also check LAPIC pending EOI before injecting any new RTC
interrupts on AMD SVM when AVIC is activated.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 1add1bc..45e7bb0 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -39,6 +39,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
+#include <asm/virtext.h>
 #include <trace/events/kvm.h>
=20
 #include "ioapic.h"
@@ -173,6 +174,7 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *=
ioapic)
 	return false;
 }
=20
+#define APIC_DEST_NOSHORT		0x0
 static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 		int irq_level, bool line_status)
 {
@@ -201,10 +203,36 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, =
unsigned int irq,
 	 * interrupts lead to time drift in Windows guests.  So we track
 	 * EOI manually for the RTC interrupt.
 	 */
-	if (irq =3D=3D RTC_GSI && line_status &&
-		rtc_irq_check_coalesced(ioapic)) {
-		ret =3D 0;
-		goto out;
+	if (irq =3D=3D RTC_GSI && line_status) {
+		struct kvm *kvm =3D ioapic->kvm;
+		union kvm_ioapic_redirect_entry *entry =3D &ioapic->redirtbl[irq];
+
+		/*
+		 * Since, AMD SVM AVIC accelerates write access to APIC EOI
+		 * register for edge-trigger interrupts, IOAPIC will not be
+		 * able to receive the EOI. In this case, we do lazy update
+		 * of the pending EOI when trying to set IOAPIC irq for RTC.
+		 */
+		if (cpu_has_svm(NULL) &&
+		    (kvm->arch.apicv_state =3D=3D APICV_ACTIVATED) &&
+		    (entry->fields.trig_mode =3D=3D IOAPIC_EDGE_TRIG)) {
+			int i;
+			struct kvm_vcpu *vcpu;
+
+			kvm_for_each_vcpu(i, vcpu, kvm)
+				if (kvm_apic_match_dest(vcpu, NULL,
+							KVM_APIC_DEST_NOSHORT,
+							entry->fields.dest_id,
+							entry->fields.dest_mode)) {
+					__rtc_irq_eoi_tracking_restore_one(vcpu);
+					break;
+				}
+		}
+
+		if (rtc_irq_check_coalesced(ioapic)) {
+			ret =3D 0;
+			goto out;
+		}
 	}
=20
 	old_irr =3D ioapic->irr;
--=20
1.8.3.1

