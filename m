Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FAA1BB7CE
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD1HgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:36:19 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57445 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgD1HgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059387; x=1619595387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=l+7lymZr2/PbYc8GInZFUxgJZD0H1aEn6FrOAjgjXsE=;
  b=pcne0OqSEw9+hBs9e4xCxsLuOT48xBXEzrC9kBrb0jhMaEz8Lf4QLsYd
   Ap0F71C0/fToeg/UcOWwcPzL0Ji763nxmQIBFYfqwbaVq+LrfwZMzp3V2
   mbDbngmDe4mBw1BFM4ZvdrQFLuNgZ3Ux9qeMYRMALVXBIbpcFTK/0xhau
   CVLMBr02vNLYvYpx7caOt/3Br9lHma3+xmJ5a2xVITiQzC0YV21jRKsI3
   RbfCvPFKNn0EKzeUifoWsm5d1mUE6h426M3V49+05mmHHzJbGOH51L/qD
   4DK6quRCn3ZfNmV3dg2L9zojti6yzknKbmodm1i3I+Whz5VUgzUSjjKlD
   g==;
IronPort-SDR: rrx3yRjQKrn3vEgUf5i1JbVFyFjDVipK+0Ae9Ps7i6JwkAlUL1E5c2ZabnyFSc582XANNZAAoU
 teRTy+rJb+jVFh1JX3egsUJU2TUEVL4UMMgDH3pH1rXaQS4nuQ255tHAyu4gLEm+BOjvXX3mBc
 7uIE4e9W9p9lS/6nAunymV9EGbiU3jAHUvvVrJiPahGUlUGVrV2dwI4GcUuSbe4J1zmDuKI9/a
 UOM71NlUWuwLN1nEh189Jxbxm3vcGtaXshL94KeinUq65WpR1M1Pp5tOCcm8ZPb+Q0q4gNX1K6
 pu8=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865963"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:36:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp9qBG3uOjocNp7Si/+cvkxpjjGJllHN+uTJNsSbTiP5H0yDgV1yyXQYAGyvQUlOdBTyLlo1DX4u1vFe0eTKqMBvVc37HtfVDhni8Je5C5hx1rZ6g0lXrhn5JXVaD66jFo0oQ5FRzbPOz6BJuqQQ1BJwPhX7I4bnJEb90swr/3pWIU7PPBtPeIIRj4PYadO7Oc68Ss4Ny6ZUnRw1JNFca0npuOlPd6gGD0Ogm6WZVaDe4Q9iEXUd6KhtHm5xuy4nxifGxjIgJUSFWlMIh1u7wbYhO9wVREwTV7uuHYVdhfMO2EJ1zx/tWjiKDRF9OGJwF6KJgjZHK49mN8AgYW1vjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kMtbv8yUt4G6v4jrQHHQQ4khahSBTQvBJDoYl/V4NU=;
 b=AUAvfXfCRR867zXfZU3DfM3jVGPpkGw8RZFi6hAhW98pU/YcCP1pPpAryjDDpOo/JlWsoihcQWS3iPboPUiDkjwBTMDC6Q66s0myjNlhN7MbFGXiiI96juKZ9x4OEvmtwbQQhuYcIWhWrF+7yP6QprAd7yNq7jRjowV3uAhvdPrL4V3aHxKCVjDhEX52ogwmJX6FACwISKfhP27l0Y9SBnbvxwFN1EQVeYPNvsoauwvq7AE5M6RAipWcE9rAXgl5y/hyDfPZzcopTVSFN59aQ1M6RUI4AtEWTHt4sN1lxBrFCO1lOcL7xAiPbmTS2yjiGvI7SDaOZfndciJ5y6D6+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kMtbv8yUt4G6v4jrQHHQQ4khahSBTQvBJDoYl/V4NU=;
 b=DUsbisR5Ajk9Gsgd3O5aaJ7QdCYfg0A5gxJQ46bLrkDQS93pAvhMEajD0sQw1vs/zVzFe3lXPs9KWfInZtq3RpkBCgVc3kb/k7mzGTfh/P4XecMxy/fXQyBevQpsD/tdM6zigELdF4/N2Vx1mjpSFKIQ4yELYYsjDACjBhZGQpM=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:36:00 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:36:00 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v12 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Tue, 28 Apr 2020 13:03:12 +0530
Message-Id: <20200428073312.324684-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:35:53 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 697a908f-56bf-441b-de0e-08d7eb46cbc3
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5929EAAA2A91D45BE886D1C28DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQfE3qQYFNdMVR4pCA2H9pBTtujkDr4f2WhXUZhYXQ7tLSbP8ZuM5rqbx9oresXCDWKXcHloRwasOW7HtIQman6UlQs4ypVh7x2Z7nYI5cFL+vZ1VwXGVWN6oPbmT4FkNvrKGOnS4VEJdEccdK9Gk2jTu3Lg31GoB6kI8W0Ith/BjpDypqU8+te6RpN/eStugTpPrrhakOQTEbavuwSfx/Fl8q+gGW/u4Mv0zVslnixC1ZY0V8/GgTCHFeUNed6sjZrI8FRXfarZ0as4HCOn2eAP2Ah8MNkOExp2stWwmpR3JO68GNrJjHObXzNWiGUVLJD9QIr73/v8e3l+yaW+Ih8JD3uLQ80vdOS0fWpREYM5Ys/WI4wiiPaC0G1/mRSXjdw9Vcgoi7T/b8hKlMF71Rkoket9Tq9Jv5JWLdy8Vz+mG47skf5ctFXlSu6D07Lh
X-MS-Exchange-AntiSpam-MessageData: BPNy4eSdcKGFmPTjRJns0RtOx0SrsdiyF4mzxVIdxfBAOGUlSVAYtL2iF2vhyDMITEHhD8fYNl70tRMUDRrM5jWR9+8/l73cVUZmPxYLc1XZ89i9wYXb4aQIfSqvl2sihODqzuttrNZJSkqikxAViUbuziQy7erp9K+9mdgcYfcUwojjxJU3cEgT24gm9ZW0ahlP02NRIRsrBatEX9uzKwY3LTvBXfBYOP1xvpPRmRBh98i6NEnqVFD6UlNtyGGuE3ccl+4pGa07GmE2DapO/mi+mto3OttLu+D5dQEI6y1/R0luIOMYVv/3tk6ntA+0qcDAcljWhmwkW7Pm26e28cM8yh3+LimU9s9sEInXgQ1i7TndTuWoVVtovAB5ArxrS5XaJAlswwEvN9adh+e8Q7gv+K+SOQwEI+dZHIJWCZ12lTtZzXFV3pxAqrLs2Z9eLWqTIljs+TkbY9fmYXVn0qbmJkt4heyTciS38Zd1C0fx9H/oAAEb8OuA6E7V4Wb56Vr1WsCT/wTbYN9grt9XoxXYOoN5EEjIOq/TA12DkIcYwm9ZyysFcFnuskv2YVFsfq0re0BGTTs0GCIvw5XIdrcAxtnd9zAEHe7lSM6KebW229Fs/eRWBfOpmSrQRZuTHOzbWchJcVrTekMJBPyo5mFdcmbZaHim/6qeaolIFMGEjCNjMVJ91BJJzlrI6dIynCXjxHZSb+o6QUAVOMlHQ6lISiobVEoUUvUATs+MxQ5Z5LydC5RPNh+rdkbG9ZBTrXXSOSPBW3iVwet6M5UZpHufNaYkGVEIJEz5a5bjSVc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697a908f-56bf-441b-de0e-08d7eb46cbc3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:36:00.0300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0EGFCLqljrtW+0ljHk83LycyCzRshwzO0VrF5iP1hWuE9sF+HPTmbnM6VzDSd54t0hf9ZQPyeLCMdVgf+9CXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself as maintainer for KVM RISC-V and Atish as designated reviewer.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 26f281d9f32a..ad3f37a8bdb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9324,6 +9324,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
 
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+L:	kvm-riscv@lists.infradead.org
+T:	git git://github.com/kvm-riscv/linux.git
+S:	Maintained
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.25.1

