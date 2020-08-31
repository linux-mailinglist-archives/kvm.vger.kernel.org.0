Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D22257963
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHaMfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:35:45 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45698 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgHaMeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877264; x=1630413264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=S4y4Vm8tut2wgHeLX6jE0JoYIjXp12q/wp9enCPTsY4=;
  b=gCW8xyN3wdaapYoOwA3j4PkNsYlhnNIfrzpwpIVd1xR79GkIn3tJsStZ
   VT60kedYxsx4f8ESk1oddsaLahHTvGrNbDwDou9ZE+w639reP9uoRIpyB
   k1MM1+G0Jtf8P/rEcfSXF47ta+t5DdlcLT3dIdBstorQBG645raWugsXi
   kJG3hJXcdKAV7flOT8BdKX0M1dzmkF4GvhYbWBF/inm5TZoVmt6UODRHr
   HhyvDD4D/piz84T1Yf97HCEAXJAmFsEUcSzY/0zR/P+etgWbWhEkGn26J
   uRwRKuLV53HIzx+9xyEyNakSRqBxZePBLIznT0mBbiqWUKqeFEdkzq8ni
   Q==;
IronPort-SDR: 3fvFAwSdJy18nOw4K5WyS8+shxvcRqcN60c0lKGXI0NIAeqXPbTz3663LYWbvX0wm3htMhhC0U
 jan9WmA+WnHgVl5G8HscCp+BkxmephQey3CUaJqGPGUr1tqtwGN0T/Hkx+okdYBYAQjsenguoY
 KMDMnL+O6tPYuSuvJEN9pKnJ1Dan99rfrccZY9EyWb+pzAZ4J0sTEo2XDbL2xNtP5YwWUGN17r
 JBLDh1inTuqdSMHa/e5XwPTK2qDB8ilK6bYf6jgg/8Klo8LtqVK6EuTQvSmbbw0NlPDEPzMl2J
 7V0=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="255743429"
Received: from mail-sn1nam02lp2055.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.55])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:32:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDhxE/a+wo3OySTib9Yh91MGwwlpv58xKimFhDgAIKtoMyCgrV4TxdL+c6F7VnsrlnExRSgM1XHIgxIstztg4m/23GgUI8Ivck6SFBnI67l8+uhKwDEIC/q+lfNtrEXemdRwAInB3rIRQk29GG3eyoSTsFdGx9yVLZodCYo6vaY+Cjedbs3WkjjUEpRKHGl4j7hbU/6/giM2CyjxVSXMdET26lMPp0T+dE//Z8KvSnqKZBiXTIKYw2ViWEt19bDrdfdKd3xjjPTgvv6BWMneUOH0cOYjlcrIFY1OWojPHEYM4Wh8eh9H4YkhWvuQ7EAJcSdKiogl7Ui1QQbfsG+xdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTtYrBZP4gzZbQ1QIWCsEiIDvdU9FjH5vKDKdqsXGVk=;
 b=Ad/8wOvjUB12bRQ7lBfVoC1NVxBwt1/vhKxKVPIn0EJdN/6exIRrhqzmQfBxeKR9F/T2UY/0ZcttyBH8LN1gpOVxNG5XMqTYt6VZSNRF3HYXDBCgb6yeZ9DbuJOKbLZo7MczlEQxOBHdZjT4YmWAErXfRikLjAj5wTyJx7ILNpP1wsXQqt9xNbcubMm7ZajQcFkFOWls6VdyUUNrQpZ9+yLByJY1jPa1cCveLK7ll+bQHQ7sYVDCQw4N59ZMNRK6V2torrT9CGDc4ikS8OcxpEmyP2goqoSXH/D09BK6NMd4z889xHPkSrA/apSOolUUwzGX+T3NO/+Jh/mNN2pIhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTtYrBZP4gzZbQ1QIWCsEiIDvdU9FjH5vKDKdqsXGVk=;
 b=nSZ9X+9R3BM06DgAiBB/TdPTMqN15pWZZdKM5MBD2YwlwVzM/orkEBN7H8mZzrqVCVyNmu5gDwqQh2WP5e/r1y3xpqkGG+YXPQlAp6zeIhTChlvPh/6qfxzbKb2ukPwIUMQGC3y7gMWrfrW2A+qNKBO740AsGJpSU+WXaVByb1w=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:32:05 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:32:05 +0000
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
Subject: [PATCH v14 17/17] RISC-V: KVM: Add MAINTAINERS entry
Date:   Mon, 31 Aug 2020 18:00:15 +0530
Message-Id: <20200831123015.336047-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:32:00 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 63f2b7f9-f63d-4072-c9d2-08d84da9de1b
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB60923A765DCDAC4DD643EA008D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uF0dvvn57m69yLMB5wgxvLLL6oCcCgjU2iLnvTcoKMQQa/uxN2BX0RpgUZL/ONZah2JzaVV1rtdGb+dUFtTLi7d/4KZKHAVuSy3mhmwijRz8N4E81wyCGzr5gsg53sl22TGTZi428fIpMvkIXGSwbKBdfdEcAURFT35+B814NDCgY/VMa1yU5P1GC7hdgmrhauvfX6q5TCcTf/qTbMHy+DbHt5Ly9zm9lANN/FnMxJ9G8gDkyBJHBj0dQTjOiHGmy1awQrOs6HMDYGakBKp+ah9EB4l+kI/DC2uQA1l2KFmhA6/XwmFnQL6TFmLYdrjleowc/FA4f91S/rHKQZbDSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(110136005)(8936002)(54906003)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3CdA+Vwe4hnIMtwnCQHT/DIsebF9NPU9QtzCc1L4kPfIBGy5v0lay1A2KU5kjvFaf70SsI7zVRVSdv2rkofwAr3fH3chb+Sd4f5tkpCAIV+2+ZjavjlFaapL5eVpfG2G71E+IrnhEjWnBIavOGoowZFxj8MPAQAsqhOGAkJhLRsvddGJT695hS30u2V3Aca3M0IPV3JyRjsifFFKjs3cEubvY6uTaE+yORWeuv9Ldi1jpjiqVVj5Qyk5AxFwoLX/LazjvEIaEZiy7PQVFjyV82KT3jZhakORZI0xY10QnqddV3GPunGs0VfVq1qqlN2M2RLZxNdyfbKuOJBGYak99zNCGhxvXiwgyc9Cttw9OC1AVi5djX4auqp2vEIdO8URsO2NuY5suCJ+hE9L/pn3YWVa5G14Sv1SqZcx49jc9J7RbmR5jO6wVD1MQPWH7sQl+B1z64FqZS3zalrZm6OhuxFFZC8ugqnHguTL7mQjTA338CwEyGbDTrjVv9Y3BFVqe2IOdOrR4K1tRmbikAqQXBqLE8XN+wZJ4P45KjOcTcVLnzoc4B97gkWCr9Vbpvg17KtFDp7xAY2psjLqakS1JkRbAh9agA9wXcSKM0FGDlsvLCKUD4WHnw1StR6J+z17gYaArlRc46LdDYZpAtxEGw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f2b7f9-f63d-4072-c9d2-08d84da9de1b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:32:04.9426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiRno5ICaalwDzpVodDZxIU0Ms/Fd9cndjLxJQQUUVBzsWM/Dl7Q60FCMQfaZeUVbrlL+rLw2ecIHroFJH769w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
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
index e4647c84c987..abecd5bf990e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9564,6 +9564,17 @@ F:	arch/powerpc/include/uapi/asm/kvm*
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

