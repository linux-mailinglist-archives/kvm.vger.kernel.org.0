Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D18EB25A1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbfIMTAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:00:54 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbfIMTAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRgf+FwqXJutSahBmus5EB5PCZK/cJa0kevWUSliT9oPu1uguaLvV5FoBlW+iEN//ubescb/BDqGsRsY9tFQ1eeQ/OvgacJWmbDpVUnTom+WD8DC46gnQu5iodtHlF3V7xfqjRHB14wOpiR/HyRo8iedIDMoeiYJyfeeB36U90sghAX5G2Bb1WjCf+iNYssZw0/cuMhRA/GYWzZn0xSR1eVCC+dXOgmsPChVLrq6dXRD/jSKqKtV4uSs8qe6VJFM+gfbmp6hYuqkNqCCGjlpwYngcxb9gQUVS8KZVMGVyOwQZ/cpM6Ww6ylXLrc+RX/kxCJd5nNuU9wnwndrsf9vUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBKR6fjUDwmwqUmuqzblcx4wmgdgaNGRnVZE7ekQnMw=;
 b=gSWQRon9cIj6i0dX9JcCDp5UEWy2ONZ6ccTZVsEMDvsOfujLDcY0vsSj/fdwAGiB/egcxCUNr4q6UQQ84ZCn0xDI7cAxnlMlGh6XzZW/2qEU9CBUHaJAm2CRVSbTnReD6rpcfRfFLhZvXvJIFnnEJQWEHUiwb5JOxlLqBdyIhu/X/XpEgsywFT9joM7tQf5sMrLndcv3l5B0FD0ywF5XrRZbfgMAsXuDZTt+Pi8t8F791UTPkU3dvtf9v5mLkR/+Eov0Ghe4Gl2+u+1RWuuStD1mqmuUL7z+eGPULutKYqPWaNgRbNjEQ+dVgbbQiZUIf6Ei3RiyfZdnzV5LKFuypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBKR6fjUDwmwqUmuqzblcx4wmgdgaNGRnVZE7ekQnMw=;
 b=qI2CN9TN8n87u1BWzt9LeXbscosKQyU5rkPucFpsyjKs8EXOH3F4kDc/gS5DhapuuO3uNJhtVkxfK4RVZXDcu3n7bazERN5M/OQDnZu9N0YtZAu+0XRIfwyWK1gByroUeeaovopZWT4+n2sJDEXHQzb8LwNse8oB3N1YmrHj28U=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:50 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:49 +0000
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
Subject: [PATCH v3 01/16] kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to
 use struct kvm parameter
Thread-Topic: [PATCH v3 01/16] kvm: x86: Modify kvm_x86_ops.get_enable_apicv()
 to use struct kvm parameter
Thread-Index: AQHVamWOE6Ykw4M51kipY51rilxC+w==
Date:   Fri, 13 Sep 2019 19:00:49 +0000
Message-ID: <1568401242-260374-2-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 2e470d3f-3a5a-4311-84b4-08d7387cb117
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3804F36D7179E47C048AAA2BF3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yjdseO/Eh4VW/ZtXjgP2U5/islmU8T7BMac77Bi2rybaUNE251SSgS012JOwYWckVlx6GTEYZq+l2I7/cznIRpsXaRm2Lx/GTCbqTu+ZFgMdjU3nErnLV4K2t5BNc0nqFQU2ptLbGYzlAAgbQXw9z99Qb5DYKh3RJw2x72CMnTaRDwolTt1f6LQGuUX09QZdZ3tWw5hCzuoiltf3XS/2H54ArrQ0i4UCM1ALrygnvxERswYktPTOIlexezLJenvgDVwC0XijfYfUMAH3jeiTqRjoTZO7qojblAz8ffiTWgyd/YfsGncD1M1j1uWpzTpFgeceRFMOUijG3LKyMHXB92O9DMk16+SN/Ea41ot8hjQju7jc6DPS4PvpO4PR78xq3ag0aFgWXCVQeBmuiSrTOHDIS5wvPZlUVZADA3hlk64=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e470d3f-3a5a-4311-84b4-08d7387cb117
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:49.7091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FX6o7f4Aw4jilNaUYL3XUNqL7gIuVobNfkSWSuuT8d8pXbFuIvM4kY0aDG5A6IJ9xar5OvDGpiv+8h6PKqJfcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, APICv for all vcpus in the VM are enable/disable in the same
manner. So, get_enable_apicv() should represent APICv status of the VM
instead of each VCPU.

Modify kvm_x86_ops.get_enable_apicv() to take struct kvm as parameter
instead of struct kvm_vcpu.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 74e88e5..277f06f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1086,7 +1086,7 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*get_enable_apicv)(struct kvm_vcpu *vcpu);
+	bool (*get_enable_apicv)(struct kvm *kvm);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d685491..245bde0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5144,9 +5144,9 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu=
 *vcpu)
 	return;
 }
=20
-static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool svm_get_enable_apicv(struct kvm *kvm)
 {
-	return avic && irqchip_split(vcpu->kvm);
+	return avic && irqchip_split(kvm);
 }
=20
 static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3fa..a0702d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3644,7 +3644,7 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx=
)
 	}
 }
=20
-static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
+static bool vmx_get_enable_apicv(struct kvm *kvm)
 {
 	return enable_apicv;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd4..01f5a56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9209,7 +9209,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
=20
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu);
+		vcpu->arch.apicv_active =3D kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r =3D kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
--=20
1.8.3.1

