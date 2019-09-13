Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D6B2588
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbfIMTBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:00 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbfIMTA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:00:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe3rM0DmL1mix0OSq+h1Lcy5BvlpXwW8HCiqogTPOiYNNHRKnM/TvZlRERCojuERGjSkc4fxUQWM+0DI2uU673voMvxbvhDH0yjV1sfbd2N6n++9pD8WVkBX8UgTU+WGfEDHCf7klHCHCeV3S9F+uuWH9rv73ErBM8mcOM4FXTZiRy+waJycxgLUtnFZhmzbeCUpsUTzfnez02B36mq1Nr1JR2wIe+uuvAxIFh98jV7fFeD3by+RUkiQk772xhbMO09fCZNb8+7Gl1ohFOH+roA7Nr5ZeKXAjV6zOn4il/nzmQu594vW52Mzs/0RPjpAp/Xko09v9cM9y1cxMeb7vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MKzfw4mbQatxHy2uHnAQuqRUqtdXbQnMnUtgr7hKPA=;
 b=Cpe5IjB/gajiDhaSk9prO/VXJHZ2M10huejGWIRzQNbIumkKHeFgRy0z1xruDfpUrsQ9xwqATItAHRqgFcki4JgJBEzgRRz8VpEkVk/x5gAlu3ZxyakLUwjP4URfBfBcBQMtMFlM7/buQMyle4PmFeXiuOwZLFjaP5uCZbkhBsM7A8YLfj09bWcMu+gBLiV7BdraQf5VHpgdKrVBLNIl/c8iyQLXSm8z3cCZpkhyuqQExENyguxbbh1KMfd84Qa4QxuRCYxCACmSAdmtO+WCY3L87IJa4J9HhZotAkwfAo71RBwMv+UoLNbllhxYr0eT/FPpRumL4kEvjdwlDXTAwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MKzfw4mbQatxHy2uHnAQuqRUqtdXbQnMnUtgr7hKPA=;
 b=YMVxxWSq2pqzfrfrE14B30hkzyjwtvtIYDxBjbSnAjtOi//QEFjF6uAZ6RpdiehgKUj3QJy1jTKYdCODeef/y8b0ELSlKReD0rHbEiYabw9Ubkgr84kwN0fDi7kIHBykXwspISbXWGc2a1afHcnwHUct9jRbAG3vlIcX5jIeq58=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:52 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:52 +0000
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
Subject: [PATCH v3 03/16] kvm: lapic: Introduce APICv update helper function
Thread-Topic: [PATCH v3 03/16] kvm: lapic: Introduce APICv update helper
 function
Thread-Index: AQHVamWQBG4ksxOUwkiSLKWNXc7Fgg==
Date:   Fri, 13 Sep 2019 19:00:52 +0000
Message-ID: <1568401242-260374-4-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 67dc6fc6-8343-4274-f396-08d7387cb2ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804C37A249FE91918A1EE6BF3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(15650500001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pmebVoNGYiNr1Rf06z777X4FJwKJ8fTVw9KpIaxI1cl2kRthhIOEI0EkuZjQ71i9LaPUptlePIS7EY2xoSldVnEHp3DI4eKdy0naOVkOGasQl8J7HRXrYRLRkuw/6pojyR00aMgvEs52tcr2SBtJpbvkaW5BdmK8f8izyY4VOfKP9H4D4KyPXt4H0gVZNEu0LkgYZujdBRxfOV5I/POk9dW+6WFbxhR77WDPa97r+RWx4KY64mO4tHxdk2rZsJ4SIljbyS3vX9oH//anF+s6LIATIje4ipW5NPHC3yWdl8pu0gpC4S921v490A0+JDExv6ErmL+aYK/6i7OJLaFtqLAHv+hqmpWFafmGWT3mKqxIdo0PXlAZ7Yy1+sMrTEL4JI+eqBGwtuGi4PiL9WoBC+Pqn5BSsbJvI1/TRRqk7G0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dc6fc6-8343-4274-f396-08d7387cb2ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:52.4825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wAFT+gzm8f1GIKhYc7dydCaceL/omBT+GNUCf6DH537Gxd62SKzFxeN5FpKCVHY5loaV7yErOnHBnQyhFmfFbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-factor code into a helper function for setting lapic parameters when
activate/deactivate APICv, and export the function for subsequent usage.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++++-----
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 685d17c..6453273 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2147,6 +2147,21 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 v=
alue)
 		pr_warn_once("APIC base relocation is unsupported by KVM");
 }
=20
+void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic =3D vcpu->arch.apic;
+
+	if (vcpu->arch.apicv_active) {
+		/* irr_pending is always true when apicv is activated. */
+		apic->irr_pending =3D true;
+		apic->isr_count =3D 1;
+	} else {
+		apic->irr_pending =3D (apic_search_irr(apic) !=3D -1);
+		apic->isr_count =3D count_vectors(apic->regs + APIC_ISR);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic =3D vcpu->arch.apic;
@@ -2189,8 +2204,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init=
_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
-	apic->irr_pending =3D vcpu->arch.apicv_active;
-	apic->isr_count =3D vcpu->arch.apicv_active ? 1 : 0;
+	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache =3D -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
@@ -2449,9 +2463,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct =
kvm_lapic_state *s)
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
 	start_apic_timer(apic);
-	apic->irr_pending =3D true;
-	apic->isr_count =3D vcpu->arch.apicv_active ?
-				1 : count_vectors(apic->regs + APIC_ISR);
+	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache =3D -1;
 	if (vcpu->arch.apicv_active) {
 		kvm_x86_ops->apicv_post_state_restore(vcpu);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..36a5271 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -91,6 +91,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kv=
m_lapic *source,
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
+void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
=20
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
--=20
1.8.3.1

