Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6528F070
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbfHOQZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:12 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731184AbfHOQZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5lWzyQupvkQRz4TwgsjWF/GTANIOs/3lVVCDaTKkqErsU+O/FuldFQG9GB8PSomDHCq3pk/Zc/BpBU0Eux1MRFLwkZ9JKKowfXTNTIuR7jhq8iJIZzrFExJ+Ak4EILMghVX+KbGATQ7W03t/w9LNrQbYdp76vxEh975U8a7VJoSdy3IY7GcR8uSlpPqZ+sL+CK6HP6ZuTvkv1YESmCTS2rB2aekhFVVjZ8YI0qWp/Rurp5hsZTyz9nPnnJ7OYUDYZe8Ek6Me+WSU4FmNNJs5rfDMpB1sqt+FaoQ0RocdHv5kKGUf6Efeaf4QXyvOx4XJ9gt6oIaRVbY62fFI2dqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OwGJBVTOHUe8SFSsGHmjlLUlwnpZPP/0ooWTApuRnA=;
 b=HKMCuuTJoheJMO+NK7RLxvp+gYtcCi/LNFmOaVhJ92Kl1JhqAtlCPYhW+EsbfpL+agulohYNAmfNwk6a4HW/9vIeMmoKaFU38QmMDKqW2PCuvJjCp7OUE402bDL4dx/ha9yeIw2u9oB9wdg6KjOmKgxJJ8M680o8d6QH1GvKRECdbmXE6tbtRhO6a/gWXqpmTpYSdDNNR77l1JgNf/BBG2+q4sG5Yyw8Nr6txRbTCgugRX0hJHpyOw5PKOMEgvrOhHeUna0Mg0nj4vAP1xHjImPXKh80eVDmPi0UuSsBWElqjb5EDCpiTEyv/X/+Ea+rIipCj/ZHPNkQJ6jyVUvCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OwGJBVTOHUe8SFSsGHmjlLUlwnpZPP/0ooWTApuRnA=;
 b=hBNik1Wi25YYBUPjb982uAQMJ2qSrDGEQMm2e7Cnrc0uouipqw7i2LSmZQgb3ISU8wceFXdHZ1y8To2bmrdkKoEtTmOfTsCzYByoRblycPqhmD/UMT73keIONq+3OndwYYT1i6WcDangcIl06J79Eoc4eJr//jJwo996jGzFinE=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:09 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:09 +0000
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
Subject: [PATCH v2 05/15] kvm: lapic: Introduce APICv update helper function
Thread-Topic: [PATCH v2 05/15] kvm: lapic: Introduce APICv update helper
 function
Thread-Index: AQHVU4YBcPSQVrB880myyMRcT79ZPw==
Date:   Thu, 15 Aug 2019 16:25:08 +0000
Message-ID: <1565886293-115836-6-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 2580d735-b427-432b-f57a-08d7219d23aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB389701F7BA4A7E5B40158BB6F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(15650500001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zT3q5bfEx1c+1e8MCyW7ICoQKl+CGsOrhr0XJ7jJAd8PP5gIbwkDFGr7a/6JkgmWsYAbA3hdvFRCl6TRRqL5kSl0NkQtUipD9o/droUwMRoP2mUv7HzSL3ydElqnztJuq0kfk+dIzkzj6ExAs5CaArj6nzrn7BweppVVBvXc8vFfq7GAZxFOeq1hkVRpPv2odYuiBxeN6+dXSLkYHcA9zKokxQh5zmIlPEYcH52ATdguysqWMn2jIF+82OVxNr7ett4+XILtGZPaxRLvUFnxslBBmRRw5wXX0KwTGPkgFwd4DCfNdgOGYE2Ykv3Vfw93YDQeuf1OZYqN4hZxZ/1H0B4Mh+Nd0qg19k1DOd5WEVuFz6qSWcP2xIqUKseeKYVbXp4JLQMBGUpNMiQ9TL6974Z+HiQUQWax4B+0Hfpv9rQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2580d735-b427-432b-f57a-08d7219d23aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:08.9962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZCVQZ8Hrwq0jncR9KNulTImSl7MBViEn1hdM9NgpF/rgo/zBrVYqJd1kID3f7xbR+FEXB3zmKYVw9/7RXq0sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
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
index 4dabc31..90f79ca 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2153,6 +2153,21 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 v=
alue)
=20
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
+EXPORT_SYMBOL(kvm_apic_update_apicv);
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic =3D vcpu->arch.apic;
@@ -2197,8 +2212,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init=
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
@@ -2468,9 +2482,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct =
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
index d6d049b..3892d50 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -90,6 +90,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kv=
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

