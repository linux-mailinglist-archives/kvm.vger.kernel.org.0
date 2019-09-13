Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10219B258B
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbfIMTBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:02 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388525AbfIMTBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0VbGm3ZaAGIY+0KO5xAOsiMqX/+v+sGn0WoN5JXrSTkkFjvzMqDzAbt62rUi3Aojnv41iv6YAHzGkN0L0par/XKbJZAIk8TLw/5TVY+vMhkmsz8z8dDMXUfNukawHX0RoXSs0urzDeEah8lQtMVjzeeuGs0mxmH4nF4RR8YwzNCW0q5hDmADx9zL2e3vkh2jOr/qj8CoLZwn1nzHrWY9NH4VezViriFdDafBVipXA0k+VBR6OGmem9lmhG1+XIuFy63leNTPUGFXE0mIiFfSoXuntpOP5jqVhuAptY74gMGqgUklT1Qch1N7X00TCRzFqlBNF7KqgidugNw7nEQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtDJmbTUlI7oVu3X2YLk1Ku9+rzWOUFbFJWpGYw/f6M=;
 b=fihZxi75uKCdYQAvpNzkbjEZstugWlM2pjFg2yJJF6lnD1Jua6IolcfSeqNND09ayaKBZT0IyKE5InP6fwafIQSNONnTXboUHXFZPMD6/6Ak32OObY1BYZvMC2ocWDm6FRK5dPnq3Kt7cNYik0gsfhL1AWw7BLuHraRFZU8GLXrLDmLTrTuAG7DApqBB9UoImjYNwQWhJN1s3vYOfrYUIgMqZPsyI9zURyg66lErpe73w2b9gDUakI0INwCB/5X6o50LW1OmqR775213R02uTDv1M3RZJCYv85GKk/x8+u3sNh08CksDxYDY2WnGXt1YWSvLt409y7jfUrK+WgjzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtDJmbTUlI7oVu3X2YLk1Ku9+rzWOUFbFJWpGYw/f6M=;
 b=uU1OzKySoOh1iKRRWSIZeKgT8WCxzsj2oXdH2QaAJNAiyKycih9G1zDEP+M4g31WFI60MPXzfsQ+xX1lZeZzx7UPa2hDm39slwwt5dbYlAFYTgPe3n95nANYnmX9dJBjMi+58MPpHsh6e7T4Q3bHw8+54H/UP8vgYfXZ83a6OVw=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:55 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:55 +0000
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
Subject: [PATCH v3 05/16] kvm: x86: Add APICv activate/deactivate request
 trace points
Thread-Topic: [PATCH v3 05/16] kvm: x86: Add APICv activate/deactivate request
 trace points
Thread-Index: AQHVamWRADc9HmenaE+NkczNcOboAA==
Date:   Fri, 13 Sep 2019 19:00:55 +0000
Message-ID: <1568401242-260374-6-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 3f08bc23-1fb7-4c90-ca2c-08d7387cb446
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38048E706FFB06E68FCDF229F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(99286004)(66946007)(446003)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(11346002)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(76176011)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iqscLasI2tIrXoy32HEZcpWdCbensXm3DuBcy58EZK5iedEqgwa7hcO4RjnbaF4p3M9qW/DxBe08H0lGJZEFVw7SkrqAG31TTEPbiP3juUyV5tHO+n+Ew/YtsSNVUMvCVCXz4wwCrOtkp8gJ+TX0MV3BVBrAKZshnTHOTMx/LFPeRIZKp0+3O2Qaqq+vpi1OohDTrp8TkeZMRdbLGodjRO80ACv0HzdciyHvqN9ur4rnDQj8GcQX9BHQdMwVFXBiWQm9+qfw+3FyvH/clveYnboIy6ObnELmHue2Ap3QAMn4tOY1X97XKQgycCTEiYxL1MNo3qpiXr+LLD/dp+7Zt6enT36Km0Z/Dr69sS2crI8OVTQn9gKTBYIWRoTpgmuWjsqkMCqmf6QRNI8A+mhQccbrhfFuotLTDYpYDKF058c=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f08bc23-1fb7-4c90-ca2c-08d7387cb446
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:55.0581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vO2z6SYMpYXSK9KBOQCg5TLQqupA9V9692fe+WIz6DFjQgqDaGAPvjytOZnYyD3T7pYn/rqbWsIo3rfEbSalDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add trace points when sending request to activate/deactivate APICv.

Suggested-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/trace.h | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e..e3f745a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1297,6 +1297,36 @@
 		  __entry->vcpu_id, __entry->timer_index)
 );
=20
+TRACE_EVENT(kvm_apicv_activate_request,
+	    TP_PROTO(u32 vcpu),
+	    TP_ARGS(vcpu),
+
+	TP_STRUCT__entry(__field(u32, vcpu)),
+
+	TP_fast_assign(__entry->vcpu =3D vcpu;),
+
+	TP_printk("vcpu=3D%u", __entry->vcpu)
+);
+
+TRACE_EVENT(kvm_apicv_deactivate_request,
+	    TP_PROTO(u32 vcpu, bool disable),
+	    TP_ARGS(vcpu, disable),
+
+	TP_STRUCT__entry(
+		__field(u32, vcpu)
+		__field(bool, disable)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu =3D vcpu;
+		__entry->disable =3D disable;
+	),
+
+	TP_printk("vcpu=3D%u, disable=3D%s",
+		  __entry->vcpu,
+		  __entry->disable ? "disabled" : "suspended")
+);
+
 /*
  * Tracepoint for AMD AVIC
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 446df2b..bc74876 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7756,6 +7756,8 @@ void kvm_make_apicv_activate_request(struct kvm_vcpu =
*vcpu)
 	struct kvm_vcpu *v;
 	struct kvm *kvm =3D vcpu->kvm;
=20
+	trace_kvm_apicv_activate_request(vcpu->vcpu_id);
+
 	mutex_lock(&kvm->arch.apicv_lock);
 	if (kvm->arch.apicv_state !=3D APICV_SUSPENDED) {
 		mutex_unlock(&kvm->arch.apicv_lock);
@@ -7782,6 +7784,8 @@ void kvm_make_apicv_deactivate_request(struct kvm_vcp=
u *vcpu, bool disable)
 	struct kvm_vcpu *v;
 	struct kvm *kvm =3D vcpu->kvm;
=20
+	trace_kvm_apicv_deactivate_request(vcpu->vcpu_id, disable);
+
 	mutex_lock(&kvm->arch.apicv_lock);
 	if (kvm->arch.apicv_state !=3D APICV_ACTIVATED) {
 		mutex_unlock(&kvm->arch.apicv_lock);
@@ -10194,3 +10198,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_activate_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_deactivate_request);
+
--=20
1.8.3.1

