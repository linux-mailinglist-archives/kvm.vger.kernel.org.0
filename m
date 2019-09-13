Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CA6B2596
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbfIMTBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:20 -0400
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:62364
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389089AbfIMTBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgdSyabQwm2zxztn166zmarh/85Qeg4QppYSXl709y3rOhxrGX6ImVfESdYE3IQzrfY2YN/dTG2etpzP8mcf6rJhHUH+8YnOKbssSIdDP3TsKH7Ym942WUwLi+2RlYcZd+BHld/c2BpXD+a9f2lrtp1+OIdoc6CfR6iF6xB64lsy4wyK3rL9tSjUdgFpyasDmP1ybKV51tA5dS1zj/SjEWrMQ8V6XLtW6KuX7j2XolclVXuNQAg/26LPF2WaPhOUbcEUAUJg15nsTe+6bx1hC/K2mYpku2lt9/4ZiQer9XuA59PkeqbfCj/yWVAdnOZX8ADwAFWIuEvUM4zxHWnIGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuKNZbehYcgZ+2EFkEll7gSdo1jNkrY7AGWJsaJdx3I=;
 b=dVkePde4Jx8qxT0PIo4nqfG6d/+unNKpJs69fQXTXTNnPAvNTVJdWkoYZIjSfHAx6r6JrdyWvdFvurjrFdljW7rwCk5DmwgxDBrERGkCfr3dP2aVh1AFHSdOX3lGJAwa5kwaCW5goQ8FHFwrAj9sB2Q9heIY/JZepvWgfAGvKn2QUvEMBGvTMDFvFQAmThXicIyuhYKmTVlfs4u0zU/Yk3ox5wc8Rd8JKjJDwZflWemK2tHxo0x5fho9LCUQQ9JHQHI/BDdV0BfRgWZlwPRA5rboIAronzk4MlsbFIApEDn48PnXzxXARYj/ormvWfZNdDHoma1Sg7IgqHS+Lp4rgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuKNZbehYcgZ+2EFkEll7gSdo1jNkrY7AGWJsaJdx3I=;
 b=1RNQtAT7WaiKErxLPOC0siKvzTNPzHuV9hJk/h6d+gSW+IeDK+ZL7r1MTHpieJi4AtIEdHcDITbrVJZMFi4OO4KPDI87eicZWS5nETXq8OWHmeYzk1w6XlKfga18IaOCUSKoOfAZS5+j9EIBxmXEFErXaW0RdHXApV/9lli+5Cs=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:01:10 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:10 +0000
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
Subject: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Topic: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Index: AQHVamWbRD5vJtxZB0KDkUxSQlG/TA==
Date:   Fri, 13 Sep 2019 19:01:10 +0000
Message-ID: <1568401242-260374-16-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 0cc446e7-26ec-40b6-c3f9-08d7387cbd73
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35961FFB6D40C0F741655013F3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(8936002)(66476007)(15650500001)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OL7pr9t/DcR54DW9ON+V6BCHSQev6PXIKiyd/ZGyXqtAIoXhTZV3a3rdApmeAZLjrZPjJVb2cIi+VrNsp2aOELURhsltVKgzLsbJpyV1QKdfiePWJ+W9KN065k66tszdlrP6ZACS2xIHEi7xl8eqso4iGooDKhpf4jpXB0FptvW/lyzh2F4eNn17FFzMf22eB51C2CNnyQRkxiiGY7pktZUfiF0uAP7bd1EYr/Ah/B0wGyTAGkcVfs0/aO3KHoc+Hr6A4IVtoQ0DzNpcXVIfGVI3Ucowk5dnON/u8WcRZJGDQXrIAOwqtFu/516A+KUTWFEPLqeZdosahTXClYvUz7FwkXKxMEjPtVpEG7NaoemGfKPLMX65aTDPSl/2VDnVdUDsHkerG1yR8r5LFmlh0xifFRlShh2aWViAdDjrAfE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc446e7-26ec-40b6-c3f9-08d7387cbd73
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:10.4933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iwyEXL7/9J7hGhUEod08FnbEzRm9KKI5CbDKTIVm/MvcZQ9yJnGFVfibnGAnyEOiP3jSDFaSI9tdDJXmaRIVWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
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
index c57b7bb..ddb41ee 100644
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
+	 * In case APICv accelerate EOI write and do not trap,
+	 * in-kernel IOAPIC will not be able to receive the EOI.
+	 * In this case, we do lazy update of the pending EOI when
+	 * trying to set IOAPIC irq.
+	 */
+	if (kvm_apicv_eoi_accelerate(ioapic->kvm, edge))
+		ioapic_lazy_update_eoi(ioapic, irq);
+
+	/*
 	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
 	 * this only happens if a previous edge has not been delivered due
 	 * do masking.  For level interrupts, the remote_irr field tells
--=20
1.8.3.1

