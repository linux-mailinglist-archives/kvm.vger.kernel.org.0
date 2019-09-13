Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE80B25A3
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbfIMTCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:02:54 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388708AbfIMTCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:02:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJpZBtb5PPfNM5VxHroP5HinsLsvqzlQRnbOXqYs7mvd1l++CdlZoimaMogCyj5o68BJQNcKTzNvIHvRRFbMeWjPilTCVB29W58S6rjWnUvNYgaM0MeQseEDgQn8CXbEjmp5XbyQIu36asItFGIM8iQOOOKQ+WA8ygCu5Acy1F8e0yvmRkeu6xymldb0MDeTCYzm8aNPQ6F/SIFPz/jbR6tMx4IfbCQL66IIH1omTfyKUV6FAzzLfo4LLDZ6GdWrgQimgL5xY8WRsJCZrb4q/p4Djcwa0LXNZsCsUjibdFzu/rTYZBKU8GRUBaq92YHQVKdwskPf5Lrf0k+aKVLCbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HosefMQyYoGJi+WqpDVBLlIApQ/5zryyf31rOTp7TvY=;
 b=Ikbhjt4g6o5+zkNF+jPTW8Mdj5k7WDtSiqPJcT86ujzQ8p2M5LFMNMsm2/tb9obJbsoMaJUg7ZsYhlnQ3lcj4gRYNjEZV+uV7Cqbq4XYF/QWB8DZ13gkAGEmtPgPZj17hJx60aiXlzlxgMI8FzLhDvu4IoczB51Z0/gsYiz3DN9SHPu5vLdx9e6vOPH8T3SEta7csVgN/Ho9IeztpeYUZKeXbSWAadvsi6QJ+jo8DJ+CGQYoqiXBLlwYUWqbz1AXQRr/JACihj0d+J8DTMa+Mmxebxw7vEA3ik2oQV4HfejvHuN9G5oZGRaT46WI6wiYlnOsLwLo4CJLaObRBDju7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HosefMQyYoGJi+WqpDVBLlIApQ/5zryyf31rOTp7TvY=;
 b=u7Ba4grh5NyD3BYe/ghqB1nN8kAgixIGnYg62CvpUoS6k5q2dl16mpzl7+s/UQZtdGLPVYzAxDzKACYEA27NS9Fkh25tsvxOqxOHqZYCi9XYE0ozbMMBWNM6kI9+0Rk8W+2h/e7vnMqAipPKPBqeomqqYnjTJY8+cRaAkE+yH6o=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:56 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:56 +0000
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
Subject: [PATCH v3 06/16] kvm: x86: svm: Add support to activate/deactivate
 posted interrupts
Thread-Topic: [PATCH v3 06/16] kvm: x86: svm: Add support to
 activate/deactivate posted interrupts
Thread-Index: AQHVamWS7aEJ/uHZSEquRMsBUfXUeg==
Date:   Fri, 13 Sep 2019 19:00:56 +0000
Message-ID: <1568401242-260374-7-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 9883ea0b-6bf4-47a8-56c5-08d7387cb528
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804735466C2105282C4D8B0F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Je/+73RHpfNQnSQiFsviJkLpsEkNFx9dwFBiufkDBA7HOy3bGMfWbQXjbwouHlzI813LlFMIm1GZjKbviRg4LpqaeAQtlc+YnueIZa6/pPcAuDfxphBnTshhgYqeTFUXUtrijUupVDNLzJPiMQOpPUl2SysyiruXrM54yNs0JzT6ddQU2FavI7ZrK7OwWAKSxJ+DoGfI1ioBESUmqjLsZk2HeFCtWFoQOGZqDNYTlXc7qGj86xg9HJmXsyyEDWB9UmK4vVoFfzeiv/0RMvRs3/+2TunlE0LmROOGWIdEKVrqca0waubhForSpbraop+AKc9I7ZUEaowPiurZclUAKf1NajqyHxqHvVSykISsECibLeePXAqKr/WkadBotR63ECXfFais52cxkecnvOyiMhqbUtPPTTEKP7ncaLwrenE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9883ea0b-6bf4-47a8-56c5-08d7387cb528
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:56.6402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Gg5O7rkNMKkOexJZoqKBhZyOjQLRqZFU7rBPcC1b00O59fIOUWh7CcZFcuhpIHZ0l+57nEQTgzh5FkuoBD/CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce interface for activate/deactivate posted interrupts, and
implement SVM hooks to toggle AMD IOMMU guest virtual APIC mode.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/svm.c              | 44 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kvm/x86.c              |  5 +++++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index a50fca1b..624e883 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1193,6 +1193,10 @@ struct kvm_x86_ops {
=20
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
+
+	int (*activate_pi_irte)(struct kvm_vcpu *vcpu);
+	int (*deactivate_pi_irte)(struct kvm_vcpu *vcpu);
+
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 245bde0..8673617 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5398,6 +5398,48 @@ static int svm_update_pi_irte(struct kvm *kvm, unsig=
ned int host_irq,
 	return ret;
 }
=20
+static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+{
+	int ret =3D 0;
+	unsigned long flags;
+	struct amd_svm_iommu_ir *ir;
+	struct vcpu_svm *svm =3D to_svm(vcpu);
+
+	if (!kvm_arch_has_assigned_device(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (activate)
+			ret =3D amd_iommu_activate_guest_mode(ir->data);
+		else
+			ret =3D amd_iommu_deactivate_guest_mode(ir->data);
+		if (ret)
+			break;
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+	return ret;
+}
+
+static int svm_activate_pi_irte(struct kvm_vcpu *vcpu)
+{
+	return svm_set_pi_irte_mode(vcpu, true);
+}
+
+static int svm_deactivate_pi_irte(struct kvm_vcpu *vcpu)
+{
+	return svm_set_pi_irte_mode(vcpu, false);
+}
+
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -7321,6 +7363,8 @@ static bool svm_need_emulation_on_page_fault(struct k=
vm_vcpu *vcpu)
 	.deliver_posted_interrupt =3D svm_deliver_avic_intr,
 	.dy_apicv_has_pending_interrupt =3D svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte =3D svm_update_pi_irte,
+	.activate_pi_irte =3D svm_activate_pi_irte,
+	.deactivate_pi_irte =3D svm_deactivate_pi_irte,
 	.setup_mce =3D svm_setup_mce,
=20
 	.smi_allowed =3D svm_smi_allowed,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc74876..1540629 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7198,6 +7198,9 @@ void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu)
 	kvm_apic_update_apicv(vcpu);
=20
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+
+	if (kvm_x86_ops->activate_pi_irte)
+		kvm_x86_ops->activate_pi_irte(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_activate_apicv);
=20
@@ -7212,6 +7215,8 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
=20
 	vcpu->arch.apicv_active =3D false;
 	kvm_apic_update_apicv(vcpu);
+	if (kvm_x86_ops->deactivate_pi_irte)
+		kvm_x86_ops->deactivate_pi_irte(vcpu);
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);
--=20
1.8.3.1

