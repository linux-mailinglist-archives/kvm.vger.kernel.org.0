Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E205ECB8A
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfKAWlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:51 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728266AbfKAWlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMlg7uokJD4neF0WL0Eoxt40hQXHFG23p++obEe4eTlaU38yKkoIUXZFBrDJPb2XWqQ+47Kql5BoDAAo7+MnMqICF4mgEzcPF7wOJVg3lb2WJZfA8GUhUdlqo1ZICOj1fl5wtCHackinCZyAEGs2f1ZVv2DsieVLeMB8GGxKbkCgAXfHYX+hds90LDOndQxUOK01dX7/CQPc0uCa8CINT0nAjpwKf9kKdXAukorPamapGT4QuCzt7Uz6w64QX20M4wYgfTVFCK30LGGKMiq0tXfF5Fh0l1JYBdzYw7F7pxYp7jcEOTP8RfhOboW8lX4M2rnmpbgLQH0ccgxcmPZLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAVHkiR8nhWMHZXu7w04MlEmDeIXqRB8jLn9H0d4PJs=;
 b=bUvft64w/HtSDrNOJPOZxrkXvWrx5TIAkNFTYVNx2hJR5N26RynvzfQ8lRUl+hI/64SCdkgnh1tgL8k2A0ua9OCHns2OfC3/EudiMtCg+jBBEcHrrps3w+p3A6GMoZByLnCPnw3F+fEFLcdxZM7Buxn7pOmfuj48/h270QE6A542qqi47cqipiyABgB57qlI1eFhg1wvQ5X/J87cFwyGszey+RFtJSCyayTgLs64Yqt9xgfk9LtRkKqD31b63y6P98UwJ6wUQtkIAqyOeTQCpoI/mu5KQp/RPBoSCAlPGHo5yO4miE8Dk+v74UyAvhS8/fWYkuxOJTqpvNwh1BLXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAVHkiR8nhWMHZXu7w04MlEmDeIXqRB8jLn9H0d4PJs=;
 b=Gh46NuHwRP/AHXxr19n3G2L7Owz3dkKKOa7Pd6RWwULfyVyba1lTxudUT/n9wXNKEmUdHMwjt8ovi5kvOdl6IYtEXaJJd7bRVG1zt0CiLMrDFK1yMbDOObpBelpUz0tGIY9zfCori7Uwzolcja7wezQuLSUmzGuyI2DrzfzWkk4=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:41 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:41 +0000
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
Subject: [PATCH v4 16/17] kvm: ioapic: Lazy update IOAPIC EOI
Thread-Topic: [PATCH v4 16/17] kvm: ioapic: Lazy update IOAPIC EOI
Thread-Index: AQHVkQWHPnnCeGX+9UOPiFdJkiKU8g==
Date:   Fri, 1 Nov 2019 22:41:41 +0000
Message-ID: <1572648072-84536-17-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 74737793-8db8-412d-8d7f-08d75f1caa17
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB324376FEE3ECC6CB4A3DF8DDF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(15650500001)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CK0+SFmTHHj5hbbt91trPiynCNrCLCK0MBHvFjTc5PwNrbimTf8FRJYTqQfdDJaB0nDKvncgvCttsFeuwg4xfwRpKeRlyEaOKAwDz2LqnRSaC/WJUGoaQzeYdlvrxtPyqZVlhWpHhUcjrUNJiTARO02QsKFSN8b1mstiOpwYZJEhY4wPktA3BW9y8aITjdhEmdUpIh+hQrGaB94f9PqrpG/9vfkpueDpiTpwZiisn4RP/TQUE8AmeBzHrE3YwiyHWOPUEBIHCKTv/UGf8GTDn0DHG09i/1USgQ7VuORJTQi8fvw4It6dG87ZhHr5P4jCi1wGi1OogaapM09Fe5FX8JRKCtZ5F2WfD4C4LDXe38nmD2ged3vzVUTHbke6H/E4o8R/rJnp+U7k2/Tzi8lC3QlzS/YIFz1xWzDUQ88XZdGfpXQpwbY53/cBtuDSuqH+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74737793-8db8-412d-8d7f-08d75f1caa17
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:41.5306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8lzDC6eUtdnZapVbrO2d18J1bKBru+u2/VuEiaMh+TOvH5DmFNTsF1jRS8clKPkB5jeb2KrPdrD3E2wAtMnY4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In-kernel IOAPIC does not receive EOI with AMD SVM AVIC
since the processor accelerate write to APIC EOI register and
does not trap if the interrupt is edge-triggered.

Workaround this by lazy check for pending APIC EOI at the time when
setting new IOPIC irq, and update IOAPIC EOI if no pending APIC EOI.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/ioapic.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index c57b7bb..6fdd88f 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -48,6 +48,11 @@
 static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
 		bool line_status);
=20
+static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
+				      struct kvm_ioapic *ioapic,
+				      int trigger_mode,
+				      int pin);
+
 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 					  unsigned long addr,
 					  unsigned long length)
@@ -174,6 +179,31 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic =
*ioapic)
 	return false;
 }
=20
+static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	union kvm_ioapic_redirect_entry *entry =3D &ioapic->redirtbl[irq];
+
+	kvm_for_each_vcpu(i, vcpu, ioapic->kvm) {
+		if (!kvm_apic_match_dest(vcpu, NULL, KVM_APIC_DEST_NOSHORT,
+					 entry->fields.dest_id,
+					 entry->fields.dest_mode) ||
+		    kvm_apic_pending_eoi(vcpu, entry->fields.vector))
+			continue;
+
+		/*
+		 * If no longer has pending EOI in LAPICs, update
+		 * EOI for this vetor.
+		 */
+		rtc_irq_eoi(ioapic, vcpu, entry->fields.vector);
+		kvm_ioapic_update_eoi_one(vcpu, ioapic,
+					  entry->fields.trig_mode,
+					  irq);
+		break;
+	}
+}
+
 static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 		int irq_level, bool line_status)
 {
@@ -192,6 +222,15 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, u=
nsigned int irq,
 	}
=20
 	/*
+	 * AMD SVM AVIC accelerate EOI write and do not trap,
+	 * in-kernel IOAPIC will not be able to receive the EOI.
+	 * In this case, we do lazy update of the pending EOI when
+	 * trying to set IOAPIC irq.
+	 */
+	if (kvm_apicv_activated(ioapic->kvm))
+		ioapic_lazy_update_eoi(ioapic, irq);
+
+	/*
 	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
 	 * this only happens if a previous edge has not been delivered due
 	 * do masking.  For level interrupts, the remote_irr field tells
--=20
1.8.3.1

