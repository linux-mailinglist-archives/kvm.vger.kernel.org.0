Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B86EBDA70
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfIYJEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:04:55 -0400
Received: from mail-eopbgr1300107.outbound.protection.outlook.com ([40.107.130.107]:51226
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728213AbfIYJEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:04:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKAq+8KXV6EH9eyu6+Nbt9ne3FrY3BvgiQEacl6HJ3Pnt5X4ASw71sBQRSYtkalHEIVc30AOl5DK5XgmKQBdIv/9qa/Yj1T0plFvX78b+niVeIx46TFo3WYalDg+NlQ5GLu1bJpvIiIyc09cxSkdCJsBfm5sbGyKKXr/Yw9BpDtw6ivR+ldI++ydoHB3Gv4iSzaaUh59t+xLS3Nt5eoQjEmhmy5o2SBKE1qKsYz0EhN4zUXuMZghOc3McnE7zPkal95c5g93/guarGl+mGWSakhgetmAVLWm0XhUSkDyQIxdGL3oWP/m2WLuhQM11mqIJQLPv+gRcS7Yu7BVW9iqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEUIs17qan8uJ+h+w2Ocr7JjLaHx/tcfjHIYRqzhESE=;
 b=JEZybzGPyp4ybZ/C2p6fg2rsuLCEuVSdKgxUnqT3kxhhglNu9CiyTKDm1uRV8YFD+Zyw/i2FUiZeuOfQsWsdhtp/QWDrzw4P4lELG7Gpev3/2uJEW8Rjw83RlMJ1Mg7nIet9CPhvDwZ0wuu0fhEjdmc4pYAtCKa/p69pLIso/Shmfzzw+HYb28GVH+SUcxMvphqMogk+3eU7VXV2SSwd+TrA5f99huJnMc0ZrRR/2Hjin8GGLIkWKhuU8tAlgo0tLi5jGQCTthpm8n+cXRbAKiQUepLM1tJuuSK11zqoHitk/++yjrZlxyNLiIf3KuKmeCbDzuDUWsZbENRs82BoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEUIs17qan8uJ+h+w2Ocr7JjLaHx/tcfjHIYRqzhESE=;
 b=BQ+IY1beLVDJI6DcDQME5xttXYZQC8hCH9lawwgPq/Nq2hSx5t1FBABEowyWfyDfxfgXNvGduGSplyM5j0Idf0wIAJ4OebVUjR1ZOZw/PaJPVBA7Ahv+6zla4TnTByasCvrgyhjujMomOkak8Apr1uorLx+qsHkBcpEfyPbDiXw=
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM (52.132.240.14) by
 KL1P15301MB0023.APCP153.PROD.OUTLOOK.COM (10.170.167.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.10; Wed, 25 Sep 2019 09:03:44 +0000
Received: from KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318]) by KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM
 ([fe80::d4ef:dc1e:e10:7318%6]) with mapi id 15.20.2327.004; Wed, 25 Sep 2019
 09:03:44 +0000
From:   Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: RE: [PATCH] KVM: vmx: fix a build warning in
 hv_enable_direct_tlbflush() on i386
Thread-Topic: [PATCH] KVM: vmx: fix a build warning in
 hv_enable_direct_tlbflush() on i386
Thread-Index: AQHVc36qkKKFgQ9iEUSGwUPOJOh2r6c8F8+A
Date:   Wed, 25 Sep 2019 09:03:43 +0000
Message-ID: <KL1P15301MB0261653DB1FE73A1EB885E2D92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <20190925085304.24104-1-vkuznets@redhat.com>
In-Reply-To: <20190925085304.24104-1-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=tiala@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-25T09:03:41.3889275Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e364f2d0-37b1-4156-8f8f-6dc661448a72;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tianyu.Lan@microsoft.com; 
x-originating-ip: [167.220.255.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c07c1af7-71ba-4fa7-8f12-08d741974492
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:KL1P15301MB0023;
x-ms-traffictypediagnostic: KL1P15301MB0023:|KL1P15301MB0023:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <KL1P15301MB00235B44249417720DA05A0492870@KL1P15301MB0023.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(189003)(199004)(13464003)(6116002)(476003)(478600001)(86362001)(6506007)(54906003)(316002)(64756008)(71200400001)(5660300002)(14454004)(76116006)(66476007)(66946007)(66556008)(8676002)(66574012)(81166006)(186003)(10090500001)(110136005)(66446008)(81156014)(52536014)(71190400001)(256004)(102836004)(9686003)(76176011)(26005)(33656002)(14444005)(8990500004)(2906002)(25786009)(6436002)(55016002)(446003)(7696005)(4326008)(74316002)(66066001)(8936002)(486006)(6246003)(10290500003)(2501003)(3846002)(7736002)(11346002)(53546011)(229853002)(22452003)(99286004)(305945005)(334744003);DIR:OUT;SFP:1102;SCL:1;SRVR:KL1P15301MB0023;H:KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H5yBJ05rUffBK4nHsWYWcYx1NC7Xw4/a07Q0/Vx5Fjgh+pE8gD+Ez7pqZoiQCKsdwTJ9JPvbGKCNSpnzYIMDZuvlZT9cV3yBHsaOb1fM0nPFNo8ae8qDQowlDrTUmhsBOICJfsHOI5CPegs2yxm0qpW0JCcBdk5Y3RSI9Ya7pPX/FFkrCrHntW9swTt4yGxaVQZs2PS7gYH1VgqePxya3+Wtd5O4qN/zi5El9ThBH4sp1UoRwYasGIC+7RBjPlq6TsSr+rzClhnnlfva/6e3pgEo04Dmf3WiYZQO+VMpy2YjA/WZIR4ci1sCkpTTTj7fu24uFF0xLrkqsDnv1jEHMYty1sV+SaqN60WUnenah+t7huQYCv6JllcOF7QYbfRCeNgHuFeUYyffsj0AY19pw5I1L4/LWIUe0AjvxNlbWJU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07c1af7-71ba-4fa7-8f12-08d741974492
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 09:03:43.8389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MptGJarMfagF3gz3YYUSkbs6U4WXDu6fmbOFUqoAzYtZaUMQ3XHi+BNohlae234qiElgWLJc2BF3nZKylkxTtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0023
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is another warning in the report.

arch/x86/kvm/vmx/vmx.c: In function 'hv_enable_direct_tlbflush':
arch/x86/kvm/vmx/vmx.c:507:20: warning: cast from pointer to integer of dif=
ferent size [-Wpointer-to-int-cast]
  evmcs->hv_vm_id =3D (u64)vcpu->kvm;
                    ^
The following change can fix it.
-       evmcs->hv_vm_id =3D (u64)vcpu->kvm;
+       evmcs->hv_vm_id =3D (unsigned long)vcpu->kvm;
        evmcs->hv_enlightenments_control.nested_flush_hypercall =3D 1;

-----Original Message-----
From: Vitaly Kuznetsov <vkuznets@redhat.com>=20
Sent: Wednesday, September 25, 2019 4:53 PM
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; Paolo Bonzini <pbonzini@redhat.com>; Radi=
m Kr=E8m=E1=F8 <rkrcmar@redhat.com>; Sean Christopherson <sean.j.christophe=
rson@intel.com>; Jim Mattson <jmattson@google.com>; Tianyu Lan <Tianyu.Lan@=
microsoft.com>
Subject: [PATCH] KVM: vmx: fix a build warning in hv_enable_direct_tlbflush=
() on i386

The following was reported on i386:

  arch/x86/kvm/vmx/vmx.c: In function 'hv_enable_direct_tlbflush':
  arch/x86/kvm/vmx/vmx.c:503:10: warning: cast from pointer to integer of d=
ifferent size [-Wpointer-to-int-cast]

The particular pr_debug() causing it is more or less useless, let's just re=
move it. Also, simplify the condition a little bit.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index a7c9922e=
3905..812553b7270f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -495,13 +495,11 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu =
*vcpu)
 	 * Synthetic VM-Exit is not enabled in current code and so All
 	 * evmcs in singe VM shares same assist page.
 	 */
-	if (!*p_hv_pa_pg) {
+	if (!*p_hv_pa_pg)
 		*p_hv_pa_pg =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!*p_hv_pa_pg)
-			return -ENOMEM;
-		pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
-		       (u64)&vcpu->kvm);
-	}
+
+	if (!*p_hv_pa_pg)
+		return -ENOMEM;
=20
 	evmcs =3D (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
=20
--
2.20.1

