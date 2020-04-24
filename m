Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB60E1B6CFB
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDXFAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:00:34 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17084 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgDXFAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587704434; x=1619240434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cXI5XArBC2z8g33BwE0i/uv/zplGk8cfHyIJaSUoTcQ=;
  b=JCw8cmB/htHkStfjnrcHgFbfRGwCy7MvkLiBdYffSW9PD5EykdtemkR+
   LrqrU8XUDuDQi0mABfrpTW5lGRmFCJG3/yVQpAezlra7iKsfB3VHUZ3qg
   7nJ/wA53EWykiFksqzBaJVbEpO/6I1NGcHE0yr6fmWBncw5Fenozgz6qR
   Ph3fnop+AthnBla652n4KD4dWnzTQOEU4GPbQRvGowj0d6TC5L5pd0ejo
   Tahfj+4vfM6O79VMr29eEz+9DM+LVzyJEthzdOHtW5CxMKcedPB0Kjh1R
   3393FwDmsrwkP2CSmjxrpwzfJaiDXNSBSL5Ydq441qvbZb7MQUqIxpmQp
   Q==;
IronPort-SDR: H69R1u6/XTLAtEsdGgj7AnvGFEtirXuuYOd91zGxEpj56tf5nkVT2761XYJsMgbexVRQfsxFc7
 Qzqi9HufxDBhzjK2HkMrSjlexQ1PPouRjT6Fa0trLbfMOAwblL0/WgnUZU9xvEI3HKy+X9b5+d
 PbdhG0bE95MlM5HV5mBSRGgxTxn38r34g0fUDFec1FAvm7V7nLUNZV44wAHhbLKnJt7r3dQS+d
 Hzo6/oh56qsDpEhQSJPrFtsXOBy9yFtZr8BXc0bSoyC5G7EDFeUpaQJy8Bxo6uNlL8lzE6Gk9s
 2Ls=
X-IronPort-AV: E=Sophos;i="5.73,310,1583164800"; 
   d="scan'208";a="136354236"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2020 13:00:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd8FP3qKZS5jm/3d9te7QqkvSGmNEQgPFuQxUSIKcpX8K9NvIhOjnIOkxGAa5Pkh9I9094wnuDCqhRbm8Vq67WvuTQ4Pkc+GnnkDZRCMWCiViQ0MDWPnz7XxnAe7ndptX5uGpVoCbRy/5yjvNmVhj1HAP2PgwPU6hntMjq5eBq92fAS/GkEEC7d+leVufRmhPZZddTOs6y14H8Fv8HILCVMDO3jdwyCQX1CoVZhPHHH8VrJ6DUOmHnRq0re8r691evOuN+jR0aQfJUNL4axiQKIfpLwocLSZgQMnhKaoAm4IHHUd5E14vi7TGBXfBhZEpxJlPojBeNtjEFC/e56RlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k65QgFyR9lve0l0tTNCfsaZWQHbNvhiIVb5NMlpDydw=;
 b=Y/anzw0PTJryq5kpXKtZjLnE2CA3s5ETTeUlE86vBOpV0I0+JeqdqR21Ysk4SPb8B4+s6ZD1yi1ceMvXGaYrsXHsJq1Ri+tnQlPUPxX4RuVWWbkLAA58cIM0i904f/0W1dWJCW5wkiJz1WUinqLLCFYUjkm85I97p6BLPmDTyY731qT2SuqxbO2kvAtKgKdNmSuiKw9zcFtP4LtjPjn3sI2vGNIbTeXYzKKz5WTIbJRe0RHbmKIRVpuh/vUZkd+1f9WZvNTYkFAAEAaK8mMX8f8jCA7OCOb6j3hVFBPSbItEWRd/A15edTq86Pxj8YPYH1SVQGppE8TCTNPYRGUJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k65QgFyR9lve0l0tTNCfsaZWQHbNvhiIVb5NMlpDydw=;
 b=FiWnzdpRdbUS6g/vSbeIX0thHrVpdjOrpCc1A0O+3rg3JQUiUZwHaJGayczpFYY2lY138sUBKUxCAWFKxTV61tQJFmGFMnXrwjCM9J7O4OWd6fzUUtsL2t/o3RMXJ1idnNovNhuPzChC8JX8i5slV2bt3mAx7t1pAKXuuk+eGoU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (20.178.225.224) by
 DM6PR04MB5467.namprd04.prod.outlook.com (20.178.25.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Fri, 24 Apr 2020 05:00:32 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 05:00:32 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH 3/3] RISC-V: Remove N-extension related defines
Date:   Fri, 24 Apr 2020 10:29:28 +0530
Message-Id: <20200424045928.79324-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424045928.79324-1-anup.patel@wdc.com>
References: <20200424045928.79324-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::24) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.136) by MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 05:00:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [49.207.59.136]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 008c275f-dacb-4c20-cf04-08d7e80c6a54
X-MS-TrafficTypeDiagnostic: DM6PR04MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5467F8155B0EB1AB7CFFFC7D8DD00@DM6PR04MB5467.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(54906003)(110136005)(55016002)(52116002)(7696005)(16526019)(8936002)(5660300002)(7416002)(4326008)(2906002)(8886007)(81156014)(478600001)(1006002)(186003)(316002)(1076003)(55236004)(36756003)(4744005)(44832011)(8676002)(2616005)(26005)(956004)(66556008)(66476007)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81FlpW/i4S41bF88AKOnMDz20+lJ5qedTOzch+gdXVUjbvx5gOIQlbo2OQONza+iaOY1G8heByCF8K0eIz+6q3OJdW69tlT/SVub8J6wi6LoC1IxTz4w2FxEXVT32XG5zqihaDzT/RGHT1xmAnyARkj3qTM8m5SI3rgD7qNGxK1XAiaBvXQ//4dLGRkzOuIV/Bz3Vnk+HbIyp4/sdtTyMVJjH1x2SegAqvOJwKtd+Nq1bNpFz95TfRTEEW2BBjJLABK+1d4pICP7q+rA96r3m/dhFJAq/ffqlf2wS7NxcK64sn8e6k/0619gkzfR7pBFB70mjetZA5K+jZqBJgnV9tGIts/p7z9/QQy1AmLUM+GAJOh2KYb0gOrFIlqi9qOAvFKop90ML14Oqo1i+ZArKaezGbU29fAxHwjalyGa+Dl6lLkFtbWHiWejdQQ65/0k
X-MS-Exchange-AntiSpam-MessageData: 7YeIaXOtczUR0IjhZDC+2cb1bGYfLyvSQH9kyFyLukSlO86gubQHATpECFkwu+esT2AQ+urQcqg744wZIFkI0OBCcseOkCxccUwIhNdMjdhmPNXL9JmjWwkYnqJDfNS3kbWw1KliYMKAMxz+HVTXiA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008c275f-dacb-4c20-cf04-08d7e80c6a54
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 05:00:32.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJAr1YSRdbteEdf8KRtFM0jxrgAoHZ5FUNdS/dJNUZ7unOaPnoUimCqIVuqEFtaOJ+Vk7nCrwaxVhe+yZpVHOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5467
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RISC-V N-extension is still in draft state hence remove
N-extension related defines from asm/csr.h.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/csr.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 8e18d2c64399..cec462e198ce 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -51,13 +51,10 @@
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
 /* Interrupt causes (minus the high bit) */
-#define IRQ_U_SOFT		0
 #define IRQ_S_SOFT		1
 #define IRQ_M_SOFT		3
-#define IRQ_U_TIMER		4
 #define IRQ_S_TIMER		5
 #define IRQ_M_TIMER		7
-#define IRQ_U_EXT		8
 #define IRQ_S_EXT		9
 #define IRQ_M_EXT		11
 
-- 
2.25.1

