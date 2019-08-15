Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6F8F06F
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfHOQZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:11 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730957AbfHOQZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsDhtDxn3HlnCxDKTJ5YcSS0aBdGByYlCXElBUa2OC8t9DxYYaqal41WXd0N24FO6hXMRzKgK1fImcrbnBNG7xL0fHBNbPuIk/TvhHUBpKNXFgTbrD9YyICfiqQ/83pvUDz0vvbIgHrCPrO+ZpvQx7TPuTb9stGCAc5mCqtGerF3ZXc80Rd9ipht1W8LY44R1/d6IDkt+atvN4H2/dCT7yQojkCaFbrRARtEp9obMaRXAmnGmbAeQUNZnKaXHhJg9gjfBi++14jruDd/TmjaO2LSnAlbgh3vrvn3J+45b6l0ORLURoIh7+oDaWwDBVIUywQ/2pfCVV5BBkClhxNUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLJ6d9S9A2tu/oSSiPqsqAXE+E4UNDTegCt1VK22Opw=;
 b=NSsSSsl/CFTw3G03BAZhtg1evYijNJfC71gc3nFCZwdI/DVkOZfRdp+hvO6Qr5i6UwJTJlImZBsHj98lc/vXzaFZc4o/V5FWsPSXgxXbrf1dzDCaQDW0Gj5OKwiY92YQMNFmVoQF2fxzKwd/3jJgs9OW8kGWimkIbjdXePp19g4fyqimWE2uFFcR0O5Zj8oLE8LQ24yxRHPEaEf466Tw9bMKGNurLvB4BdzAvUxfX8BQ+usmUotft8Kr/JaN0MM8370V7fbB40ytUUnbAS0dDDwOgYCbwHSqk4X6x4IA+hSIw/iGCZ+yq7OH9D/mU11S6QBDZGpAUIJcTNHQilmtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLJ6d9S9A2tu/oSSiPqsqAXE+E4UNDTegCt1VK22Opw=;
 b=Kg0IAMwq94rjrhVxVk0mnTtB9rQGETwyTLNmPgcWH9ht6URn5y0T347F1HtJUpGvV428iy9Mh4R6dZitcYP25igGNSjUD1NgzC3cPwfFmM//55z9Qb6tBbTK9UAn8av7CsprHDUbD+Q8Mt66LF9gCH4VFeqoo2T5UOdtsg8ahLU=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:08 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:07 +0000
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
Subject: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Topic: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Index: AQHVU4YAxicok8C98kOOsiSZW3JVFQ==
Date:   Thu, 15 Aug 2019 16:25:07 +0000
Message-ID: <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 1875c1d5-78df-4ada-6141-08d7219d227e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897F377C48B5B3B47C50371F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S1Dx35ion5Lf6nrMqz/FYzZ+n/16lsbpMvEjN2w5k/SVxONBbCvYfOvtXlsmHWc7ZXDowH3LVpFaGUMVH5IYTf1ndqeCGhT+M/AALOEdpH6tvM7eKgcddsc82IZZDT6PsMESOJ0S6UlV/BSlqT6xdjsPxkte8u+0nSt0gda5nGX55ZATYt7jNsIJxwuqWQ5PROP0CUFlOPkSzqkwMI24XDwelKQolQ085VqCHYFfju3QGRjYZmp+pCpREWcyLh588/aE151WM1TPKiYi45lngAf9EJKCslQAFOmBwEWu+dGfj5Y+6A2P7PEBswsGFRwO0hUCrVX2J0zPlW/1rppiqos0xb7Ye65SOWGtAM+WEZo3ecIKrduTfvuDQETEbvr/lOd5P+n2MXTkfTIpDTi/wdQ4TNDCSiz1Lgl7kh1z4O8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1875c1d5-78df-4ada-6141-08d7219d227e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:07.1792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8upNslNbzqyLedx05BSP/Gdh9o8U9OTSPM5po3nakSIaEKylJ3sAyIk4fFzXQNGJKEwVBDCbeLXjM5itB4QiEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is no way to tell whether APICv is active
on a particular VM. This often cause confusion since APICv
can be deactivated at runtime.

Introduce a debugfs entry to report APICv state of a VM.
This creates a read-only file:

   /sys/kernel/debug/kvm/70860-14/apicv-state

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/debugfs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index d62852c..bd9fd25 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -48,8 +48,30 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u6=
4 *val)
=20
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_f=
rac_bits, NULL, "%llu\n");
=20
+static int kvm_get_apicv_state(void *data, u64 *val)
+{
+	struct kvm *kvm =3D (struct kvm *)data;
+
+	mutex_lock(&kvm->arch.apicv_lock);
+	*val =3D kvm->arch.apicv_state;
+	mutex_unlock(&kvm->arch.apicv_lock);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(apicv_state_fops, kvm_get_apicv_state, NULL, "%llu=
\n");
+
 int kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
+	struct dentry *ret;
+
+	if (kvm_x86_ops->get_enable_apicv(kvm)) {
+		ret =3D debugfs_create_file("apicv-state", 0444,
+					  kvm->debugfs_dentry,
+					  kvm, &apicv_state_fops);
+		if (!ret)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
=20
--=20
1.8.3.1

