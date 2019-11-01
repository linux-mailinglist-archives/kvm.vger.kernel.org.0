Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B31ECB98
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfKAWlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:31 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727880AbfKAWlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3DuYB+a7TzXU0JpHmcDHqM6x+PKsgKEjgLULDwpgfscCBfarq6ASh4/H7M+brBuiWLOyye71H+YDSttDW2GFikRfnrLSuOHbrASadnLjqiT8fAiBUPGoxQ6gWTD11sMJ47D7VuukGsDhGpcCCLeNOZ+oop9Ys6IvXib3LSVsQBYk9cdUhrKuixfyhM9XjMO82coDiR2ztxkH2stT030B4aMUDrg8td27PSYblzw5JxILnT5SY+vUTo+bCktRgirl8eRhMDwQWimRo/HKjvPEHUKt5ayoqxUouiC+KxflcHWkWLmBkkBD0/TfnWa8g5l8bGwpmLd7wvcFfwg70V9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaotGr/Gt9M6gz9hLrxFQV06cpBPN0IPCvF4Pqz/uvc=;
 b=F24uJaR5nJg8csWNppRJn9Ws9Gp8BTS02GVh2xqSrSiYtmr89VyZpjpMlsJvFJlb+Q38cYwRsXgtXimnKfU2tbNN7rxi08F+1CZUGBX7PTYoQpgADQ9lXHuBZcoLE56JleuNJ60o40XqZ+RkEGsOa+gOJLToBhnH5YHmfQudFyGFvNJh7X4/lJi/ojFpfLFwh0atNPANb42EC+0kqJAsTVr98cr8wSj/XQiPy5EErQ4XOvNjFoyjaCYyEZXOmc4fUCc6LLD/e6kQ14StvoRjhsUdIka4dcaT5a6pfO9Id+Nwh1o01FYBZeg6NZEj5vpwBBHBMhd5YO1McxSkcXtajA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaotGr/Gt9M6gz9hLrxFQV06cpBPN0IPCvF4Pqz/uvc=;
 b=OVhxX7YhJyYZ5WAOlvVzIznovq/bKm+wNj+VvOwBPawGC+IAkmIS/zWB2c4JatEG4dFCKJTxAoFZzvMbn/P85sZSdo5UQYE7UISpD0QbPBqDaWSMqaIfrv3W2kUaCe49jmMcl96O/DOUU+R4v4EZJ5wGdDBljlrZGhfL9ucCbvA=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:24 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:24 +0000
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
Subject: [PATCH v4 02/17] kvm: lapic: Introduce APICv update helper function
Thread-Topic: [PATCH v4 02/17] kvm: lapic: Introduce APICv update helper
 function
Thread-Index: AQHVkQV9eHmWnMeDW0y4oRmhZ8rGng==
Date:   Fri, 1 Nov 2019 22:41:24 +0000
Message-ID: <1572648072-84536-3-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: c771339f-8362-41e4-0c4b-08d75f1ca000
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243D27EDC614B3F024F5506F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(15650500001)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pCpj74CuzBuURmpneCMK9c0fU9Oz/3E/zpZZAPj/Eqksi/CLbIhj3ZKnJbaBd+ZWps2uUQtvXX+6+azAr+lcdeY5n/lVRj13YC8cR4WCZPZEDfz7eGgQsmbryYiHGyoi+GsMwA331P7AxQyZas++aurnHjC/SUv0HGMxxwIL2tmox8j1m73R7WCKrfvXdaF7fUEf6GmtCGwG2/dK9/Eb+319e7aY8ggwGlLreRlfwORcubX6Xe1xKydb3yCtL0UPYh4gTIxk90Wq9+BwOPbk37o2Mdv943x3CxzJ6V7FImWs8x0mjfiWxvwQq0v9jrFyC9TJNR7GqsQj7JpsjoN39/VSamLOh8PHYs2M6TcKfRjOWWAtPiMOxG5fsBXPYW02mTcmJpPi2YnSnZSh3z84GStGCXW/1kCHFMPlTUIFo2ccSgww6k7CuZactxwz+kGj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c771339f-8362-41e4-0c4b-08d75f1ca000
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:24.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X6aLVYKFUcjLbgJtSRkw30MPD1FNgG+gTJCChDLiqCqXy9M0vmKTWHt8DP5HeMp65Fl72KTxmsP0kOCwwF1NZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
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
index e904ff0..4654230 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2152,6 +2152,21 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 v=
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
@@ -2194,8 +2209,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init=
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
@@ -2454,9 +2468,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct =
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

