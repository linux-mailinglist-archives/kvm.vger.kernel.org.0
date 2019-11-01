Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4BECB96
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfKAWmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:42:40 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:60224
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728066AbfKAWlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxuKEkkIZTBIMPfi4Srtb/dewSBJsRKct2iqqWFXaSdVJ7js6F/sLtHd34eounjRh/dEYblMmaK1mB7NyZw4KCvKrY5SbPXhdS1jtq2FgmVYmNXWgSItOVnXxPdpz/R+Rs882M0N6L3DrAdlcrPOLxpU0OUPMY74wOi2A78VkOeAOyWEgQBnQe54E2m4+WWfx1YS6UUVJu5kIjpmlWFNQjy4LJCzEu34rzR7mm10b5zGYyjuOoE+umNH8Cx/kGr+msY502rLdw7rlHYj670/cmVEvWseclol95Gteun4rVVvTU5AA3eLbhFiOFxpQvKMSdHGlutlw/vEV1SNrtA7fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx443pIiyIQuSl/Tw5U3hbH0CWk0BdxUdQT0kntSF7k=;
 b=hYoL9c1fAakVJMRlfZerOxPKF0dumWkGFHEWd09LISezyKFQn8ErxK++AGnXAqaZ4g3JQwtp9BNuYSyGFKK7AzP67jl9MOpLWZEs4KzBKGu2FscvGLi7BYEcwv/wCRbs+wkcbxcW+K8OHmIMBChfVKkitkaZdnvnJS9YbXMj34MCZ+2vceBfPirwAHzBRxbJm9PlCSJx1vgixX9rFyTQ32HSkjeQTnywBFi03jGBNcdDjEpaI888uoqTZ9CGnTvI027IVLjH6FQHjm9xF76T6dqoBteIeWKfZNlR+pVWR1Ml+djV8eY8axNY7v+4mJIFMV3Fpd2RePn8KG75Qc0yrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx443pIiyIQuSl/Tw5U3hbH0CWk0BdxUdQT0kntSF7k=;
 b=FMpqgcyigGtUGgVf+0noaPNUN0Iff3ZEkiMWU+fTfGJi7JneIaIyRtfbL0ck3COJJEIGpS4KVY7Qde0BJrWGsW88Gyyo35GQ6ijM7s0iCHcKJm9ET8C81xvt6c8xe+oc6n1sQnBrCWyPnrHsuMHYVmg85e1+GrYftXL2TIpz/Q0=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:28 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:28 +0000
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
Subject: [PATCH v4 05/17] kvm: x86: Add APICv activate/deactivate request
 trace points
Thread-Topic: [PATCH v4 05/17] kvm: x86: Add APICv activate/deactivate request
 trace points
Thread-Index: AQHVkQV/Hj4BGHIomk20AZUsrh4Yrg==
Date:   Fri, 1 Nov 2019 22:41:28 +0000
Message-ID: <1572648072-84536-6-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 49396192-f2e5-4c6d-59da-08d75f1ca22e
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32433F858E2B144B811AC018F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Agc4wwmJEuKatz9wsGpSDGh6Dk+29eCEQooaYRa59SJcbQw7ghxHoypBUR/up+s0X7SEMYrO/jRhlTKKy5Y5sDX8dxTZ39Wi6Bcfh2y1NYGcGb3KfgnymbXxR49lSPEHwT/OICVzd3wpUkDQWYSbiiPeW09OmS0GmluRFjIROwLQA69NGRJZYcIThVAWbfLoeUUEo7VpZE8GM6kLpUcVQJu6LsdNv3t++tRyQVKI9ZZregcFRDIeXUynu6ZdSNirDDme5XlKpzsE9X2l+l2VxsnNx/sM0AQiLKxa0G8CkL8lLvkkfJZREsxUa71qB1EAHokymRG+IH7k1k67N5M0Qdx0kk8jP73IcsN9Q1j6Nq/t29oPashBJ1z4h803qNhCUJ29Cul1yXSf6spaXXwReMwH+ma2yPEp8iA7NrVvGyiejfZqBDJYf4D/3eYWXSla
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49396192-f2e5-4c6d-59da-08d75f1ca22e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:28.2683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RAaK1KBQKpLPZo/Gv2hUGlPyFEjnGIh8iubUdOI7ERNXxMyqTVP05NKgeZMA2tGV5s9jRY7x35ZWmlAEBV9IvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add trace points when sending request to activate/deactivate APICv.

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/trace.h | 19 +++++++++++++++++++
 arch/x86/kvm/x86.c   |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e..3bfc6b5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1297,6 +1297,25 @@
 		  __entry->vcpu_id, __entry->timer_index)
 );
=20
+TRACE_EVENT(kvm_apicv_update_request,
+	    TP_PROTO(bool activate, unsigned long bit),
+	    TP_ARGS(activate, bit),
+
+	TP_STRUCT__entry(
+		__field(bool, activate)
+		__field(unsigned long, bit)
+	),
+
+	TP_fast_assign(
+		__entry->activate =3D activate;
+		__entry->bit =3D bit;
+	),
+
+	TP_printk("%s bit=3D%lu",
+		  __entry->activate ? "activate" : "deactivate",
+		  __entry->bit)
+);
+
 /*
  * Tracepoint for AMD AVIC
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 394695a..4fab93e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7754,6 +7754,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool a=
ctivate, ulong bit)
 			return;
 	}
=20
+	trace_kvm_apicv_update_request(activate, bit);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
@@ -10145,3 +10146,4 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
--=20
1.8.3.1

