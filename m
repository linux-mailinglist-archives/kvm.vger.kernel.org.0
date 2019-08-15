Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDD8F06C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfHOQZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:10 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731184AbfHOQZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8IzXlG+2GvOCZKTLMiYkPTgapU1/YzKLViu9azDrDjuNrz1lECz2tAxXUJtGPI5R072BWtYUR7Txt8SSzdPsxKY27FeAXzhRWZu596TXC+AeSB5JHsNhZN+VBOm4ehW1FCj75YgIUeyitGS8EfNRduF3mY1rBA+KE33fEyYBVVt8oPs2O9OJWqbUxm7qEca/JKAoR2ekHxwsQy6Esv6ZkDWcRBPdAspzq6F0Hgc+ooT78tXNiC0ZOXA1mh/Z7WP76JmuD4yFSQ19iWs6d9VMQp58BioNN1jyGhCC6qOiNTxP2h+M8McScSwlJ5UZZWHR/rc02EDBIKypvjEtSSVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OsmM6eE7A/QaSo6HyMHz+GayIhhuL7yk0tCgcavVc0=;
 b=KgD9UsxeB2T11qTmRK1epFhvgf0ZZ18CJDfY5zJSc6I1z9Wy8YcnrNCkkhB6ElqkexfSf/eT8zMiKzcEX0ea43v56zvMFlsHo7T7AU05bJ5UW6CWBU8wH4tc4wqvp9zqTxrOC9EZTx5HCZLBtdL69UWVXAmtn+JjAQXA34S2GzuolQmNP/d8lnTcBLzRJ7s6t9yvW2aG45K/9D19RpGA2cC4xP1yZTyNQOm+74fv0vsHoFdOJ7ShifTgZAo+brKdlsi6HLMdjB/1HpFn5rp1fF8F3aYRmavVDE8tMeeNfUOeifcuJQ+FjG1cWwOX8qPk3V5FC7hZQ7BdpELnhLUsKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OsmM6eE7A/QaSo6HyMHz+GayIhhuL7yk0tCgcavVc0=;
 b=U6rTCfGxnGSDrQEoCXpkJ2bb7HGLeFNrGL2+v12/8ydsJRlgJ3syfIIvnCnClLTpMqSP87bKO5We7CF0Pe/4YNGk+0xis06V2ZdKXcGdL6NVEw7VTx5+TV2Y1MpSsvb12CvhGbOyglwHz01IzupAt0CwsRlILT+Xs5H1CMGqaag=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:06 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:06 +0000
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
Subject: [PATCH v2 03/15] kvm: Add arch-specific per-VM debugfs support
Thread-Topic: [PATCH v2 03/15] kvm: Add arch-specific per-VM debugfs support
Thread-Index: AQHVU4X/dxH6W6viB0OTINL2tjPgVQ==
Date:   Thu, 15 Aug 2019 16:25:05 +0000
Message-ID: <1565886293-115836-4-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: c24e1f77-3166-47b6-cf1a-08d7219d21b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38972D358B793FE68E3FF59CF3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: owt6u3x90rPd7dUG105O5QkxBLmSw7ccDTsf2802YMoCxRJi4EwsVlcuxOr6qRX1bBDN2As+YX5onKBiGcDqEzEtloSklZP6OornwRKz8gExxk6D+v0m3W1rzvE4XxP5AeSQMCi8T3TJrp+vpmtWtYKQuxH4sIt0G7ocRbisJTNVlqkoFjmfExALFdJe6mz6JX1nn9t7niwg37y2fMyp1BdWsQ3y6U4EnswLW1FCdt7MC6Fd/VaqxQzXLuZO3lBn+hh5YFBGLAad50+QJ2rcSLgnoMaLC5n1W0HZYd5XTgw048UXKqZdeSqMD9YEcaOBxEfBRicyB7FhcJP2igyBl6VshIws33QOG4Dp8WyrSx7+2KAkUQJBA4bZxUI+vjd62S24vPGEx4B7cNkQCFiwlsoOGmUT93aPFsMfzHm5/w8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24e1f77-3166-47b6-cf1a-08d7219d21b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:05.7770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8KCHuDE0eK+rj/9bnUX9+uUq7krhzsomyqPC+cTOQOtcYzDSZK52UNhGrSd3WtD5t40geKo1ssYY7DeiXYTYdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce per-VM debugfs for providing per-VM debug information.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/mips/kvm/mips.c       | 5 +++++
 arch/powerpc/kvm/powerpc.c | 5 +++++
 arch/s390/kvm/kvm-s390.c   | 5 +++++
 arch/x86/kvm/debugfs.c     | 5 +++++
 include/linux/kvm_host.h   | 1 +
 virt/kvm/arm/arm.c         | 5 +++++
 virt/kvm/kvm_main.c        | 2 +-
 7 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 0369f26..d8325b7 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -160,6 +160,11 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu=
)
 	return 0;
 }
=20
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 void kvm_mips_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 6d704ad..44766af 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -462,6 +462,11 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu=
)
 	return 0;
 }
=20
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	unsigned int i;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 28ebd64..243b5c4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2518,6 +2518,11 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vc=
pu)
 	return 0;
 }
=20
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 329361b..d62852c 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -48,6 +48,11 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u6=
4 *val)
=20
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_f=
rac_bits, NULL, "%llu\n");
=20
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	struct dentry *ret;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d1ad38a..ef9f176 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -862,6 +862,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu=
 *vcpu,
=20
 bool kvm_arch_has_vcpu_debugfs(void);
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
+int kvm_arch_create_vm_debugfs(struct kvm *kvm);
=20
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bd5c559..8812c55 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -154,6 +154,11 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu=
)
 	return 0;
 }
=20
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	return 0;
+}
+
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf=
)
 {
 	return VM_FAULT_SIGBUS;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2f2d24a..e39db0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -620,7 +620,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int f=
d)
 		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
 				    stat_data, stat_fops_per_vm[p->kind]);
 	}
-	return 0;
+	return kvm_arch_create_vm_debugfs(kvm);
 }
=20
 static struct kvm *kvm_create_vm(unsigned long type)
--=20
1.8.3.1

