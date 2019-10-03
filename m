Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAEFCB0ED
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbfJCVRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:17:52 -0400
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:24420
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727789AbfJCVRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxnTAgqjJH1rFZIKXvfofsVf22I8x7oZGkq4nS9aFLg/114deYTITvt9pmZxoFk+vkTUIsFQzHbeEusRjge1jh1q2W1x7j9rk26HZjDHq6vpaiEqbAtAAwdRKDH4tB5mBUaTfIJrimfUbWTdiE0P2Fr8C+k2oW3cAPs09Fep6VHxp+kBfAT+AXJW6rn5yLhm5IDCR9JbDIDOut4ZySbBUDGnylsDX+A2OPuJwLTxXnFyGKXDcr7VhSJ757jU2NRDIWT+Z77BbaDuNqTEXkXeG4DoBoeyPNwLyhxf+ryBQZyvjGk7MEqvwhcfyR3WOTGRMqza4ia32VVd1AJJpKPBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoYRBQMeBEHJDTnWwTOUSycyUnWgZtbxHmmIcw5yJGg=;
 b=aZagZNc6t0SfVRzU5iZer9Xiu9n88KKi/CF9F5Phy641qQftI3rvIz5bnySKXiYFIYx6dUJDkKQ3SjH2SdYaURxi58RzB66R8TLdkxd8ELJPeffg5kn6pHF3wVyagGVm3HL14WYdQIYXp/+mJp8yStmLcQdjZm67KTSo/suG7uAvyRXotStLL4+AEEn8XRYbk5nhr0UaXkxDL+o9n7jYRev24u3LYGF96tyop2K110F/Nd10+URCEHgmeoV4x876MgUxebFwxNSJcXJIaYIaX5BlRwMzvW7MWEd8EMwpgBe2PTVK732Uqy2o5GlRw/kXVAhPmr1AChm/eCsW8tJdtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoYRBQMeBEHJDTnWwTOUSycyUnWgZtbxHmmIcw5yJGg=;
 b=ayoIq2+X4/k2rL+MqMpX+4wD2yfa6jytPIQXnK7BIDVnHStVcM2X++UyQh2akHTPQoDGKd54P9NthoqfKO8Bf0PZG2mRZ/InM9gSLuT8k/wNzowOZ5YVTPcwlQUqxEl48993tY1DUhNronjpIJglsJ4sCdYq7JdnLi5s3jezDSc=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3115.namprd12.prod.outlook.com (20.178.31.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:45 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:45 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 2/5] KVM: SVM: Guard against DEACTIVATE when performing
 WBINVD/DF_FLUSH
Thread-Topic: [PATCH 2/5] KVM: SVM: Guard against DEACTIVATE when performing
 WBINVD/DF_FLUSH
Thread-Index: AQHVei//OJ5soDoicEy9Nk9q9dGiXA==
Date:   Thu, 3 Oct 2019 21:17:45 +0000
Message-ID: <a45e629505eeb15a96ede97c9c6484bd62195228.1570137447.git.thomas.lendacky@amd.com>
References: <cover.1570137447.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1570137447.git.thomas.lendacky@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da15442f-1b95-4608-f1d3-08d74847221e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3115C1844D1F5BB319EF0017EC9F0@DM6PR12MB3115.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(26005)(256004)(14444005)(186003)(2906002)(102836004)(6512007)(99286004)(66946007)(476003)(14454004)(6436002)(446003)(8676002)(81166006)(8936002)(81156014)(478600001)(2501003)(11346002)(50226002)(71190400001)(71200400001)(36756003)(6116002)(76176011)(52116002)(86362001)(3846002)(486006)(386003)(6506007)(7736002)(316002)(25786009)(305945005)(5660300002)(7416002)(118296001)(66556008)(66446008)(64756008)(66476007)(4326008)(54906003)(110136005)(6486002)(66066001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3115;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wnUbR1jM6ZqfEBsTN0cCaRrXw6g/PdsOQAaufJpb2vFE/9cTjuZLewzB26qG+6wFrrQPeZecouLBxuYdjqIa+Xz/pfu0ow6ayUckwOB10NEnBF7TU2sS1PrXnbQ/g+9UGi1/v/eBc4SiOKrJebHGjGv18cpjzRKvuHvHdDb/w4l4Y3qmwY2sIIRuuZlirmuYxmUS+AMGorUIV56ugIkUpoGpL3l6EkKWUoFBTDa1VkOBxcwJLqX+TyAj1xw2EgeL211PXq2Lreqw+lj3z91t0yUssLOIhPd0EXOPbYoCEITcvTN4cesAViFJcQjAXI9Hxdv75HY68HlyPI8Yy1kmSLuYIYdp5tGTZJisnSCuwsosImA7V1/iHMuHeOlXIenId28m6JgFAwG/Hr8jwJMwrcqYgV/2K4uJO2yNlO4yObc=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <C217C1BED4958F4193ED098731B47047@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da15442f-1b95-4608-f1d3-08d74847221e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:45.0374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KoH3tTGJttBdPtKiYn23q5Cj1DP0HD63cc0Iu4iYneQKD6X1whH/H8In6iW8jXrz0Dxlp+vYRTXaBxlicmNJjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The SEV firmware DEACTIVATE command disassociates an SEV guest from an
ASID, clears the WBINVD indicator on all threads and indicates that the
SEV firmware DF_FLUSH command must be issued before the ASID can be
re-used. The SEV firmware DF_FLUSH command will return an error if a
WBINVD has not been performed on every thread before it has been invoked.
A window exists between the WBINVD and the invocation of the DF_FLUSH
command where an SEV firmware DEACTIVATE command could be invoked on
another thread, clearing the WBINVD indicator. This will cause the
subsequent SEV firmware DF_FLUSH command to fail which, in turn, results
in the SEV firmware ACTIVATE command failing for the reclaimed ASID.
This results in the SEV guest failing to start.

Use a mutex to close the WBINVD/DF_FLUSH window by obtaining the mutex
before the DEACTIVATE and releasing it after the DF_FLUSH. This ensures
that any DEACTIVATE cannot run before a DF_FLUSH has completed.

Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START comman=
d")
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d371007ab109..1d217680cf83 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -418,6 +418,7 @@ enum {
=20
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
=20
+static DEFINE_MUTEX(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 static unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
@@ -1756,10 +1757,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsign=
ed int handle)
=20
 	/* deactivate handle */
 	data->handle =3D handle;
+
+	/*
+	 * Guard against a parallel DEACTIVATE command before the DF_FLUSH
+	 * command has completed.
+	 */
+	mutex_lock(&sev_deactivate_lock);
+
 	sev_guest_deactivate(data, NULL);
=20
 	wbinvd_on_all_cpus();
 	sev_guest_df_flush(NULL);
+
+	mutex_unlock(&sev_deactivate_lock);
+
 	kfree(data);
=20
 	decommission =3D kzalloc(sizeof(*decommission), GFP_KERNEL);
@@ -6318,9 +6329,18 @@ static int sev_bind_asid(struct kvm *kvm, unsigned i=
nt handle, int *error)
 	int asid =3D sev_get_asid(kvm);
 	int ret;
=20
+	/*
+	 * Guard against a DEACTIVATE command before the DF_FLUSH command
+	 * has completed.
+	 */
+	mutex_lock(&sev_deactivate_lock);
+
 	wbinvd_on_all_cpus();
=20
 	ret =3D sev_guest_df_flush(error);
+
+	mutex_unlock(&sev_deactivate_lock);
+
 	if (ret)
 		return ret;
=20
--=20
2.17.1

