Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2422D8F075
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbfHOQZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:25 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:53952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731440AbfHOQZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBSWIwZ8DDcCFiTcFe70gYx9ZiutSwfFcKk9jCYBT3BuRWbGlBVKoHda9kOyL18A2kbtm0vJSowmtZ2LFPJexR3cPqNkXcR0trQvD2ak3jrN5s4ie3F5xB2E4jAZ6pL7mTC5M8rRxZVkwlEI4NjIaOmWh18/oGBrOq7MCHSsfjZ5gxu9GAxo6Yt79NK/sQV1sUHv3Gh6VI/YquCpkRp05lXt17F3BbcVByxVCEXckT1unxTJt2NyEvULjBoc7AlwVk4hXkOubtMaZy0a/2P+TZsCN2qpqlEoGW08Qkcc8RU2xDP8QJJWQXbyFGnDg3xr/9NiFyLYUt8Vi6COn8fVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPRIOuQRijAorkoapBRaOiQVs1h/clKfBgwej+0bDIw=;
 b=M1a0LrFG4KI3zg6QzmTb/DGtShNTBXBwKM0zyogdPrkZnGkp19v5zvdpJPrxFdw2KYHHJKNbSPbs6jQcZCJo92p9z1XPTNtwXr/Cb37L4zUpryg7avK6KHE/27AbCKFvGEd7GoFgmZiL9NlGXNrZ95At+iFzCJazYLdcw8GtxVrnr/DFrbQSe/4gDBJFtIE1RZ7HULG3aI5cFBMwkF9AxOpslIZ82e3vomHmJLrviz/6LCxbDMfccXs0QnyM5zJE3hp3oNK3qQCYgeDrDo2k/mdv3oSLHZty1ymMel7AhZWRzUPp5rw1XlrmBtTROpN6BSTpldS7+JCPC4QdyRboTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPRIOuQRijAorkoapBRaOiQVs1h/clKfBgwej+0bDIw=;
 b=gcnJu+gk/zAn3R4Sk2iKIsKHAfVY8fVxz77tj36FTqaJzl7uAzdCzHTfEtPfk/axEIqVr16tCaJyLp7kdsLQGprGOuysFe2Sj4Q8y+zzc/7oT5cS0oESHefiZEuiAxEVmIeEfD9OjZeFlt7LpMQOSRTZwbkYj5I4JziszzXtTeQ=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:15 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:15 +0000
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
Subject: [PATCH v2 10/15] kvm: x86: hyperv: Use APICv deactivate request
 interface
Thread-Topic: [PATCH v2 10/15] kvm: x86: hyperv: Use APICv deactivate request
 interface
Thread-Index: AQHVU4YEMH5b0cYjFUWHrps9bHK0VQ==
Date:   Thu, 15 Aug 2019 16:25:15 +0000
Message-ID: <1565886293-115836-11-git-send-email-suravee.suthikulpanit@amd.com>
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
x-ms-office365-filtering-correlation-id: 439d7b8d-f80f-4118-1896-08d7219d2749
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38976D625653E4A6CB8F634CF3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(102836004)(66446008)(76176011)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(446003)(54906003)(4326008)(305945005)(86362001)(11346002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lzrDuBPTMu01x//gn9p9Lo1qrSFLo4Qn37Th1dCuobwsZUSyxMak3HnLa8O7bWGaH9h6LcLAfmUtEVRFNbW7Qf1bntuRxk5icTVuUt7Xqxv/q20k65sSsZpRIwTxK/vXk9mk5/t7qN6rqcB+YW2mCJB6VUVSB1KuGg8Isx9Rjav9fxUR1MCZtZetaEoGL77UXG9k7Nle5BHta2GByZtd846wWOcr+MQS5pUmd8oBDUSwfKS++RBInGr/hFxuIZXEvO7+6wQIioT4gdnZjUAdXXbf3roa/Yz1MwnqcSIh4yrTfB2XUHR+LQOb64ObSj93TPuZF1MSyY9wpYCzZuEerGhs3LwS4rjvQn6c2vojVoHIdhFPWUNes9FPaQZHh/j/yQ3XCCr2McJAnpc0maXRD3raQObrb/+VBG00MYAQVTU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439d7b8d-f80f-4118-1896-08d7219d2749
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:15.2286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2BChLOfDxh56wNFn9HfQxTe/aMSo9mme6xKORQ89tjsAzVQCXldHUrBTibpWc89Oe+zrsJ4cI9bSN3lsCP4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since disabling APICv has to be done for all vcpus on AMD-based system,
adopt the newly introduced kvm_make_apicv_deactivate_request() intereface.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/hyperv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a39e38f..4f71a39 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -772,9 +772,17 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool =
dont_zero_synic_pages)
=20
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so deactivate APICV
+	 * not compatible with APICV, so  request
+	 * to deactivate APICV permanently.
+	 *
+	 * Since this requires updating
+	 * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+	 * also take srcu lock.
 	 */
-	kvm_vcpu_deactivate_apicv(vcpu);
+	vcpu->srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_make_apicv_deactivate_request(vcpu, true);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+
 	synic->active =3D true;
 	synic->dont_zero_synic_pages =3D dont_zero_synic_pages;
 	return 0;
--=20
1.8.3.1

