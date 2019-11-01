Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074A2ECB92
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKAWmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:42:24 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728100AbfKAWlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvB8vrgTYTa29R6pmdq9vQvxI3ElwQ14FcSc6Xt30aHEyxsDqqq5cjKzV7d8XudpesHuP+XiMgeE+LzLEa2vEgYOlu9/ZrTMYptneLuE8zTDTJMwh5oA6Gc+N1kuvdJoqZSLrNta7ocCCLWaQ/fyMba3v9krL46QfOKUaYXciy0ZwFkpHkxeFyRaxvg3CL9KICh0scla0CjU/UPzhLBY8VPU+hTx5/E7pQoOw7XHCG4MgnkpZSz/0uImNiU9rHkAMXFeV2ATjPHVv7H5vbSpdXvooruUyXYAVXwxpAxXzbUk8Hp9XAu4Jthr/tVo6MTIgveCpZbCosdpSyxdEpLzpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+vG/RAiZ/4dH4Z4X85IlEeD9hvxjxyvRq+MJcjufmQ=;
 b=e1TUFuRZk9VdRTcyn9CuLHE59YVlcZUGntYoKpGt2ob1hihwFAzSzCdrnm4BVdEDssAtbmo9ZufG7I/8aTYXfvKUKVZL0Ole8Ueycbl3+HlNNinZft7GdvloNa6XSFAVmKjAvVOs4gGNFSB6N4pMd59keuZyjXMZTMIEEDQa5+Bv1xm4FI9zKOvlgrUazp+APmrcQQikd4J2lPgnfsZo+jViHRSH+kwRyclPGYT0bIwsr58D+k+NkIlMbjOelyn7rhoHZfBYluLZzPbZzlFPf8+KHHHN9pAFnaEQ9IjM/pPVgnBZwrs/HItaR2Fi2pYVt9mT27bbnLwb4ZDxsHv+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+vG/RAiZ/4dH4Z4X85IlEeD9hvxjxyvRq+MJcjufmQ=;
 b=Mvn6U7fPH25SA5dsgy+LO6mQHCVTPR+d9PSAmxs+AZ4phqqtFQS+e288eRkOLwYiqAIwRffo0+NwbP9l6UebLCc15QEXOnNG9uLsXyQE3pSlLAPinop9Rwjf3bPw84BITcoadfCHp6xnDi8QjqxqI2F9+s0730wVlMI/pAbD560=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:31 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:31 +0000
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
Subject: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Topic: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Index: AQHVkQWB8zQYUeS//EGDH65fqyqbPw==
Date:   Fri, 1 Nov 2019 22:41:31 +0000
Message-ID: <1572648072-84536-9-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: e9448abf-f7e2-4dc2-c80c-08d75f1ca43c
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243331E6C0A22425F8EC35DF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(15650500001)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hvP/aqM7FX4P9hvgddhxnHR0M8BuKOJXUq38VtHlYu77887Ag1Gnqj3+WwWyaKv/+pqczeeNfEX5aHQZVnDMEAAa0SFxy9YH2PJgAEwyvF5ijWgcm4pmdkki6ZIPyKAsIAD6Tc9ErYfqRass6L4caKFOAjxFBF1aNatfA724g0FnSL8h0Dysl+h1NffNNnNDOh7oBrLE+n2dtVTTCEsaW6XpmI0vG7Z4I7a1k5kvNINElrIyfIwfqmJJUBUGwWHmWHbovVIHbJiPnlzz+7ajkwPw1d3NxJ+sv/1at5NHELXd++MBDr6v/nbZVpWwOBJjUUTqcd9tVKgKbYaDYOBQCr2BMKGDN1fqT5/3er/+Wbw/AG0Wo2QIv+oxrjWEL3mqnxLwPbEU5c1nFpiejvWiM0cAlLj6x/pNen5WbO8p4TniTaARXGLwXEIeUQLFEKSD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9448abf-f7e2-4dc2-c80c-08d75f1ca43c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:31.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B4SxX2CCtD/WOGKZo2QPF7dx2ul5EiA2tc44ehi2b6bl3v+LhcWq90Kn+uDqjtqKDP3NV47HDBdXzcju7ukswA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SVM AVIC needs to update APIC backing page mapping before changing
APICv mode. Introduce struct kvm_x86_ops.pre_update_apicv_exec_ctrl
function hook to be called prior KVM APICv update request to each vcpu.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/x86.c              | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 3b94f42..f93d347 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1094,6 +1094,7 @@ struct kvm_x86_ops {
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*get_enable_apicv)(struct kvm *kvm);
+	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 46842a2..21203a6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7230,6 +7230,11 @@ static bool svm_need_emulation_on_page_fault(struct =
kvm_vcpu *vcpu)
 	return false;
 }
=20
+static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
+{
+	avic_update_access_page(kvm, activate);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init =3D {
 	.cpu_has_kvm_support =3D has_svm,
 	.disabled_by_bios =3D is_disabled,
@@ -7307,6 +7312,7 @@ static bool svm_need_emulation_on_page_fault(struct k=
vm_vcpu *vcpu)
 	.set_virtual_apic_mode =3D svm_set_virtual_apic_mode,
 	.get_enable_apicv =3D svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl =3D svm_refresh_apicv_exec_ctrl,
+	.pre_update_apicv_exec_ctrl =3D svm_pre_update_apicv_exec_ctrl,
 	.load_eoi_exitmap =3D svm_load_eoi_exitmap,
 	.hwapic_irr_update =3D svm_hwapic_irr_update,
 	.hwapic_isr_update =3D svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fab93e..c09ff78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7755,6 +7755,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool a=
ctivate, ulong bit)
 	}
=20
 	trace_kvm_apicv_update_request(activate, bit);
+	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
+		kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
--=20
1.8.3.1

