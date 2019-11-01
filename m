Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7E4ECB83
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfKAWln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:43 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728178AbfKAWlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX2TEDgtK+lvyHC9kbDu+N1tPU3vFSYObn5JM8hCKFJ3PS12EwkrS97mhQMmRYSQIwmDT7yG6Ofi+n/lROgR0xUylmxh1/xYDy8XwgKiyaXl1XAeR6mLs3yQvd386xrusM/sLxpdDv0jtUC7Taj1RB9dnengol0S2JAU0pn1I+yYBRPqlPizqQrAa8Oq6eKOacEgd+Cnc9nbPHxuwhjhVVxN2j33L+sU74gLctq7UdX71WUazj4ao419EPMK0IDf513yfAv7cuh7wopxNuMgaQKzkHDx2pxuNU3k/q3zM9DUkX5uEJkVCPtiY0XMOwMnyuS3XbBDE2eyjGlsGc+h2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Tp4WKVbXYrtXYVqN/q/J4DyH0704uY06p08APXWkI=;
 b=QtrCLEjC5zoCRTC6HePc8xwtMpzPmanqafVeHehaZRw5vDu79OarDh8fEK/2yJRJNdHvsbeU0UaBMBo1wRnHJqkk0iHetmUm3URtysnMVr4LCSJsJZyxCb2K7ljo5Qtfaq7guVeOwhHdqeq6pBFeY/X8pTQUMeFGIEyMHz/Y3K2FoRSXQ/RRSVl0Aa33q8jJpaWtefs3RVUgiJ2+Tpozz4iaihBMzpeHvOdJeJkfoiswW4/UBnbjesFw5JlOAqj1xaBEYmjTIRvHcDfBdE3LOK3wjUb/uO2xAc+K+0OnVT2bi3Wp4mTeF/AUuNH2noJm8uLvIn1+f2GuFSY1FccJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Tp4WKVbXYrtXYVqN/q/J4DyH0704uY06p08APXWkI=;
 b=EG4sMyfKTkGf5we/YiqJ1QlQwLi6AOS3uKqwRxosBG591fL6e24fRlFIn1biI2/uxP7nHN31vct9Gu1i+Hg409chihqY5U+SJnmwAguqR8U5KFQytON4HH6GGsXd6JGTZTk17blcGhkDXbDMOFXyHYbGhW4gKBLquXmlCU/nHyE=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:38 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:38 +0000
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
Subject: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using in-kernel
 PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWFwL1+c1CZPkWuTq14KdLXDQ==
Date:   Fri, 1 Nov 2019 22:41:37 +0000
Message-ID: <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: f184d363-865c-4abf-b3c7-08d75f1ca7fb
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243F475FA7D6CA1C9B518FFF3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2AbdUbA4nuUOVGK9sK6kwU7GR7u5+Apfm/+Ml7D0q3vQn9E5sqsnfN63u1sX08Rkvac8D5vpun+3g+PB9c9f3Sp1VzF4zhmb63PPKxxFWp9v1V0WL/52IWo6Fyi3hfBqxu0EhVAPybJz7hvd9JFntCvWTxgOyDpfTtITvGhhUPC6JbIi+j9ArlNdG4blcMBE5CF4NIU5W0djP3k+qTg52m4uvKVo09nN61DAKcN0kIeHIwA+gj67rEhub6lDJPGQo3ntt2PPLZLs8ezU9F3W5z7EbX8BAvv/bKQPCawX4A9o8XVe/vkVYI+2a8t4EC7MnGgNkV49PISzf+wfuIZn7qbcbbftb5kM/cQQDvQq4Fw0squMfL7a4kb/5Fd+I34HT5v0+F/OEca0Nao7f0XPU1/5fuSH1WrQngLfAdI3tbe2xXMQxmfYHXw4nGT74gl6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f184d363-865c-4abf-b3c7-08d75f1ca7fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:37.9837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VzdzFnU1KkLDCgQ4xZ/i1ptFQN52kuuwrjVMgUDyC/S599yW8/w9lTJ7tuJ6xH7w8pr9Kh22buE4Lv/N/VVMqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SVM AVIC accelerates EOI write and does not trap. This causes
in-kernel PIT re-injection mode to fail since it relies on irq-ack
notifier mechanism. So, APICv is activated only when in-kernel PIT
is in discard mode e.g. w/ qemu option:

  -global kvm-pit.lost_tick_policy=3Ddiscard

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/i8254.c            | 10 ++++++++++
 arch/x86/kvm/svm.c              |  8 +++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index fe61269..460f7a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -858,6 +858,7 @@ enum kvm_irqchip_mode {
 #define APICV_DEACT_BIT_HYPERV     1
 #define APICV_DEACT_BIT_NESTED     2
 #define APICV_DEACT_BIT_IRQWIN     3
+#define APICV_DEACT_BIT_PIT_REINJ  4
=20
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4a6dc54..3f77fda 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -295,12 +295,22 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool r=
einject)
 	if (atomic_read(&ps->reinject) =3D=3D reinject)
 		return;
=20
+	/*
+	 * AMD SVM AVIC accelerates EOI write and does not trap.
+	 * This cause in-kernel PIT re-inject mode to fail
+	 * since it checks ps->irq_ack before kvm_set_irq()
+	 * and relies on the ack notifier to timely queue
+	 * the pt->worker work iterm and reinject the missed tick.
+	 * So, deactivate APICv when PIT is in reinject mode.
+	 */
 	if (reinject) {
+		kvm_request_apicv_update(kvm, false, APICV_DEACT_BIT_PIT_REINJ);
 		/* The initial state is preserved while ps->reinject =3D=3D 0. */
 		kvm_pit_reset_reinject(pit);
 		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	} else {
+		kvm_request_apicv_update(kvm, true, APICV_DEACT_BIT_PIT_REINJ);
 		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0e7ff04..9812feb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1679,7 +1679,13 @@ static int avic_update_access_page(struct kvm *kvm, =
bool activate)
 	int ret =3D 0;
=20
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page_done =3D=3D activate)
+	/*
+	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
+	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
+	 * memory region. So, we need to ensure that kvm->mm =3D=3D current->mm.
+	 */
+	if ((kvm->arch.apic_access_page_done =3D=3D activate) ||
+	    (kvm->mm !=3D current->mm))
 		goto out;
=20
 	ret =3D __x86_set_memory_region(kvm,
--=20
1.8.3.1

