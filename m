Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B588921B14F
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGJI2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:28:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13805 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgGJI2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369692; x=1625905692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FsmLAUNJnyElJzelbNbYBjIrZmYTW3L+bojP7QKU8CE=;
  b=rDiCHbIeDaFsBbmrk3PnOfNZVjTmN4lLwKd0MNmoKh9unb5ALRhpahxw
   Z3KF6+U1IvLrIMP4SZlDtx+4I/bNNIBMMDa9KXFZQVLmVkCLfflCrrQYU
   M8qN7Q4cLbOY4SUwxZKJ18kB0hQcI2CF4wxPmSl97xK6mjdiHo9X8fIOK
   ZPkSkgPNVD/8sp8YM/WB0vxKvixokWkSJOlVIOVgv7RAuGEEkeOsyiM2t
   pk5PfkdyMMjFNw3yLHCQ84Y5CcBHmYEXPEkC1p6RpSG8wgOJRLZb4RHY9
   LTbtAgbrpGPcX4syrAomai4f+3SXNknuwt0wKcnG6yQvJcvh/evIEY8Rc
   g==;
IronPort-SDR: zEtxTHRHamAYHIMe+JfyE3xwhjcs3BVk/wDk2alWH0JOKqd4tRxC3VYg0RbWkWObeOSdjfh5Fn
 0ZHoEPqHBOTAIAyn3MVGPHLoEW2NHpIbWT4TqVAQZnnWto9g8qwIZf9+4YQ9cAVZdkhaoIR0rz
 mXj11Zr1IRYUf/yZ9/fMEezRXY8yQvEAaaCiBYGtyVAR0k1z5+WaudWP1ACtXIZIzO3C8e1Njh
 1gYDTXiiXXhlj1ATZDvQueiOa2ihjDm8PLzlLDU9GU7YAnqLB27bZlLyS9Isea9Gf7PNf2/zfd
 d1Q=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142275750"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:28:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vjo/quYU1CNHtxhyKR8wSPFL/GOa7I1Z18p0lyfqJKyhe8qtfOtgWrE3YDNYp6vXxKRV7xbGhLJdeBIE+ST6PqO9rse1EidCE9+yBcbKa/xA6y8uZLr6wfmoUXzzm7FLN4VzVu8NgVe29aQx7cH7Ykz0SgSnjIH7hkmItIUhFar2iIso32Ws8cmvI3iGU+MnvKV+ERg5DPa5LoMSlZM14C99ZOeMrUXy5P+t9LlGbahTTBUs0MhrR2DZg/HnynkGaBFf7/hxVJXnguyba+QjNTUH9iN51hOYtv7lJXFRx93uzcqqyyHAWSLyDYempyGFD9uAXOddzMLhzHaeCwAs0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yol6RQPIRFzOTIFJgzOje+3ZjgwAoUvD850p6DKKkcQ=;
 b=UHVGozb5OIwbs166hnPRtWGduvGWqDuHNRjDnsggn1yqx93WNZacSzL6lpOGIzKQ2kKKWlUsWkIuLD6MFoBXO4uyXBwTH1ZlAhxOC5A0ynspes1noEVczh4pVKmkX3nGCBghwO1fk2WtagdbfT6PNDREVddEjTjQJ6UmHbRRTm8ct//+lc32e15X2EkOUjgcpMr4bjnrKy/fRkGWHA31S+w594rkhxni+SXr2WxC2jaQXK6O4/mwQ0GMeGa1GBV+ykTEAcugpI4MNSZm0q95sbT2A0Lq48J+jHbhbzmI2aRVBNMXDu9EaZ2H74dzbvPALQRw3b+w/6xX4MKzWJZNow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yol6RQPIRFzOTIFJgzOje+3ZjgwAoUvD850p6DKKkcQ=;
 b=SFz9HKu4JbDWOiVtGIeeIhKzmKEtiSPC0Wlh4TlRiW3FXY7dt9kK49hyqt0j/WxiDdjaJpPj7tpWOr10VjEVn1bNcwO2+c5D4MAad6ycnSPovQBbIKXBhehFH6QOqwHtuwk56Q4TGHL3I310x5J/cct0z1Fz/qmnXNjy+lFPbow=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:28:09 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:28:09 +0000
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
Subject: [PATCH v13 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Fri, 10 Jul 2020 13:55:48 +0530
Message-Id: <20200710082548.123180-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:28:03 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0568c300-6fb0-47ce-01e1-08d824ab2d02
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB04613979B543AF3D5C789AF68D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vus08HEcRS+fdNNaiSZYzSfs62tPLglanaS0Upa3KbHP1oboCnflXSdq2ouvRHce3Y0+4PBncoIkiNBTBpaPzGHYcmLzUOGP4P3O1cPkFGGX0/kF1I0HnrhJA0gPckz99kfgceAPAhHfcAwsb3EfBnnZ5yQTn/6lm1Enu5SKtJG5F+C/EhcKmT8j0I/xqoMg6hj4cCpbuYtCWDj+duzcAlO11hCVJ2ZtelvxU5ARfHIVllcN3OGxLhpA7pHYqNLcmhf3eJFMD3lvGRY1nEUq703ErGBM5PCZ4vKTuHBI0/rbadqXeVPta49lPdv96arfRMD2UJfxqc+1zA9yDa0Now==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(110136005)(54906003)(7416002)(478600001)(6666004)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uxGBJCGx1jgfvbKlcgIvyNcyTbCJEr+AStuslTIejiwH+4LpVe9Zx0jin6/wcI90ROiTJOfwtWwq+esrJ3dWraSVLKyQPKwoWvn+p2++8n1TfPZXE88qWB0FMgt/ydneB6Mx9tbSA+UZnGeraSzu9CIuFSH15IlxtZhEWy8bJAL32/FOf7uaJsZT7lEeFsLZw9lc6Sqoi41adkdEMjSNxLAaA/T1suTWLJavq1DzpSkWEy6/329//4LkdKOFOIlO0qBKV0oETluIPkEXshw+Lo110njKR86vQE8e3v36KKQ4qNvmp/POfxsawB1pjpOlASsgeIKG2qOFBwdir5R6h1DzrQwk+/eOwsdNBGe7bpZTNzyEcT02CPVcyPjUF+dgN+cjJlHwgZ96GkrIowJa1dfEETcBoAHPjEzt+VaP2P8r8K26NZXrMKMJ9f1jYKXlzbyijQ60ROQQT/8dwV5BLudSR+gxyd+U4sYy1xUgOj0=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0568c300-6fb0-47ce-01e1-08d824ab2d02
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:28:09.0755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3GQrGiOVdn1yDMeaqvr9C3gHdY8qdT0iDmck1B9MJPJ14F3/kC2HYGTEJmJRO0PIexdSqAhd+ovdGr2xSO6pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
index 1d4aa7f942de..9a3e6e688479 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9459,6 +9459,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
 
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+L:	kvm-riscv@lists.infradead.org
+S:	Maintained
+T:	git git://github.com/kvm-riscv/linux.git
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.25.1

