Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC56A52D080
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiESK16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbiESK1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA45EA7E16;
        Thu, 19 May 2022 03:27:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQf1EnjSOe8JPmcOzUDUvBmY24+rXtgBPfH+RD8Oi51vwUIKmLVi9J1HFTI9tMyK0eeFJNqEQP6yqqp4+OStza6Vjk6sy0uD7OQvQ0i+uEeviLQlodqfwenGR+h1wBDqGkEwSe2cDIoOY1aCZG2dS4WEd8EkLJ1fDKanZ2/VzKAywH4zD0OlKZse2j8h0VX1/4w0vFrV/JaHLnyWmhMu/ox0q0XAXnUGTs+BjVeqk2ceOLibvMAd4IhuWNpivaUhNNEY9JD+Yl8sRKWY+zqg1ORzrp0siSX9xZ4YN9Uayi+WdSkAu2ahLn0PF3kAB0rdeO1rf4SfUGI7qslELMxYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/Bie8oDP8RAYNrsWPeGRtId0tjZaZQocZJiTWghtFg=;
 b=C6bzk+IX2RCF83fmHPEAy3T5Pgp13j4QzOBgHkjmXkCRgC7qeBG3ZiPbM606eqvUw37a+177lapekjvUW5dlNPAiO/wmB9rIop1CIRzQOmVXHuXVzHdAxZNtmc1Wkj3MERMa5p0F8lljIeCgEZ1ZbBD+HZWEERnQD46NQMrjUbwbvABIF8bT82ofXEFeZf9cTwNvxSKquXTHLJPqf4SQnjZbDbtmWtH5yURW23+aovX1omm2/+J7d0CclWwvp8FCQCAn0saSyDByaAC+Rh3EyLuyd0VIdHFxyZRo8xiyHxXd6EOPWNXX9L4iOZ+tBvYP9DOLvH4RVWTrPxOk2BZfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/Bie8oDP8RAYNrsWPeGRtId0tjZaZQocZJiTWghtFg=;
 b=qzf+NJj3/HJM4kJt6pwVbd90v+LW7Va/rq6MvgrLa5G99C6xA8zbgTBPlbk55cHYuB5poNtReJ1TQzv7iOTPGMXK6v5LCwbPqLbkcxo1H95vbzxbftYcrG+vjCuq8/SJ4Bh3YU0uU+7K4wgUmSQM0/9+cjl6fDBHwbKKX4OWgfo=
Received: from DM5PR12CA0056.namprd12.prod.outlook.com (2603:10b6:3:103::18)
 by IA1PR12MB6281.namprd12.prod.outlook.com (2603:10b6:208:3e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 10:27:36 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::57) by DM5PR12CA0056.outlook.office365.com
 (2603:10b6:3:103::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 19 May 2022 10:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:35 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:34 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 12/17] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Thu, 19 May 2022 05:27:04 -0500
Message-ID: <20220519102709.24125-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4bb421-1ad0-4b3e-55c1-08da3982312f
X-MS-TrafficTypeDiagnostic: IA1PR12MB6281:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB62819E10A3C9BCEE471C1C74F3D09@IA1PR12MB6281.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cyw1D/5nNgff8mDye5mcu7Gs07nihjNF4/C/Ij7Wn2zVgA/1o3Y3/oq4dgTOY0gw7W0hqZZGKg87hTLNOMZBWxT6taFjc+CdInuGcSCEK8gJd3qVsq7vPKhNJKg6dQTBlGf4vIYe5qmoa37Oh+DJYsmKhbdqnEeD/PP6TOSlirXiX1P+wsSx9vxkP2qXzv+EP7+Gf/1Trt980rqK1HVL+c57mrM0CbGCejz8Z9RSRoh35lR0l+gvZNuq9J/XYIUDggLZs+HhnRWtM5Nh8gZaTfkZCaEyRAIclabaOUsNQY17z3qohsMNmD21hzx6iVelkmrf+vThKJA6sxC0sb3F+KOI8mFr1ntGbpQfm0nFipBdY3vzpbgdoK5BD9Za7IrP0zSxRAiu93y9VjVEtWVZocUhQEhmVc+SOkSJ93EnVX+GEgiIBbaziVZQlSr9NtUX/6Xau2TXl6tZIkm+/JyESevNcQF/UkH+UXqDf1u5yUBybcwLdTy4lUVX/IKFX067YOVYZsLVKUvsGGH2tNScOFXX2of22z4xURzjEnFuI/YVUHGWic/iuLN5tXGKT3Gpvgri65AsdohmhzwJwhZqvoO3eXymvQXE+ZSFHTYUxwzUrhfjPyS2pke3GsK81TOgYQK/Ld4DR+pXOnAzcLPoA+wJAf8zttVauUkIsE+gFGMPVjVxGP7AFaUjILtdxP63vCQwAhi6xySU8zkklW8AAA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(83380400001)(2616005)(26005)(70206006)(8676002)(82310400005)(6666004)(70586007)(4326008)(36860700001)(1076003)(40460700003)(47076005)(426003)(7696005)(16526019)(336012)(186003)(508600001)(86362001)(2906002)(8936002)(5660300002)(356005)(81166007)(44832011)(316002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:35.8970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4bb421-1ad0-4b3e-55c1-08da3982312f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originalliy, this WARN_ON is designed to detect when calling
avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
is_running bit is set).

However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
running state, in which the avic_vcpu_load() will be called from
svm_refresh_apicv_exec_ctrl().

Therefore, remove this warning since it is no longer appropriate.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d40170082716..2d9455338b1f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1038,7 +1038,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

