Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC587B8120
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 15:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjJDNi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 09:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbjJDNi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 09:38:57 -0400
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2070.outbound.protection.outlook.com [40.107.135.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F73EAD;
        Wed,  4 Oct 2023 06:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr+2hbrG/wQ25XfuFCZp7Q9BxtePmzStRfoQF4e9poMYb8YFTYyFMiwE606HAlqBSR3zhQHRkgTbjIrAMmhrUvzpsfdsF/ci3i3f5L2pRq2w6XDnP9asaIKzhzV/CMWxUfVCZEz+mnx7sMYq9m0Mnmw3EbWNMMNbXX/1C7Yrr3emBDgAUjAtZ/AhN/r7YldCVvqAfSQPM837h3dOwES+EIwvyS6o+5sZtaT9p7PPzaKcsKI6nWNK0YZ3YJqwL7lTLTLSvpaHcNurQ4PHEXZypmsBR/cHESfA+O+/J2cbvORRHR1xSMtGozEpXpmusjDPa0KMfBYwiiScU2E+auLIuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qS1P8Hb9UPTQZIs6emg8iHXIoAdavfzkR11cTzH1qqM=;
 b=MObMIgEQN5ZMAyx4mWNWwFplVEHask1dKx9FEKcbLniVkvjVgDHZcZD6QujWpLj5pfihM8NuXk3/Gt0vGuYIKpr4XK8qt3DUtTV3sKVmjlkpeArolFjijXlYLgea0AqeyIbLaI2t5kZkL80Dc+h5sm1jrnDR3I5btMEh1IbbMThOLVEMQiBRInrZoX3UTWT7Lir36qsnAef6oH6Ij+XYWNcVEPFlhFDSOEVHmuNl55bPFUOZ/9CMNNuI2rkNnH61AbggsQuXHNO4mcpzJDV60ghrjpoR4hrPDlzw7nP9zqTiq5YBs3htM3RE3SODv3Sx8dIfKGMvNWCh2dJdsTkTsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qS1P8Hb9UPTQZIs6emg8iHXIoAdavfzkR11cTzH1qqM=;
 b=JsQ3jW8RoE2G0tdmTnvM2FJh1NnNQ2c8SaxibktfJKJ4T/XhYOiOiffIft+PATkQAsdacGvcqMt0JQEOE3yTFKL5/K3VvPjd+o4cjBjEa7JglknQ0NldaM1lBZ8xRFzgBvls39QzBx6Til2/z3P53yQLLDNUHBQ+Vwqer2+ZZG/0btWzKef3g2NHgZvHW+THXb/CmWEpxKkUn7uNG/3aw+aj1xZyxHfp7nmYAyGWMNrSnz53Wwwlxd7I29kRf3/Da77FhdlpGqt0JNfvqaW77ZyfI46aVYREcbkWt3DAld966l9Xq0hJysHXuLqONZFEremTfKpciLV27FNn9XVjuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by BE1P281MB1473.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Wed, 4 Oct
 2023 13:38:50 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6838.033; Wed, 4 Oct 2023
 13:38:49 +0000
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Julian Stecklina <julian.stecklina@cyberus-technology.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: rename push to emulate_push for consistency
Date:   Wed,  4 Oct 2023 15:38:27 +0200
Message-Id: <20231004133827.107-2-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0132.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::7) To FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:7a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB1567:EE_|BE1P281MB1473:EE_
X-MS-Office365-Filtering-Correlation-Id: eda76357-74e7-4314-c354-08dbc4df3de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chOYHpA8aOhkQn5zL5hv5W9+uUrYEnQkmq1EDFrFtM22oS0053qLPtEUwsn/A+v1gdzafwR0RAwVE++y6XBgkEz0jE2NPubi/c5sLnArFF2q3OPlC50vlquLwB4IQ14Eahhr+1kIfRV/BmyIPGQ83agRgTuYKyY6kYLjlXQgfqkdaUa9y42EG+nkvfLDkfxqKcE3p1PXI/IMJhjeNs3htugD+l14iMHQprjiByvUnWZ4p082moMJ5IwhftfelFJNreN1nD8IIv+dZZxdcgbjWZzyWF2p0as3e4kw+fo3GTxGfmqFLQSnCtFG80/kECfgkoUOWKWLOUtmjou+rBrdKi79s3iBz80dKBL/ZHGjF1q4OUmimx02WIrmI5+Bl3toZYUf/msYDjq3wXUjMTAsXntCMRArifJr//GBwxLT87gfK1DLm9fIt3KTEklQn+UhAssgwMRJRRomVKb6zlxBLCz8ccwY4GJzG0Af6eLpv6glf1P+HcLKFTQpNR5oU5yTqYYRYweAH5g62vUDZMrZGiyYclc/QLgYuiu8XQuH+CEf4uV0819Gk0PG6txRidBCiwH1jXRn7K7E6kUaLTu7/PfTFpE7NFW6yqt67xgIwGv2ULP6KrKs+sX11Bss7MtraIdG3yWoc+pVSMDXHDDevFWFRx/NOrgQdkqXM3Z2Fko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(366004)(136003)(376002)(346002)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(4326008)(7416002)(44832011)(8936002)(8676002)(5660300002)(2906002)(41300700001)(66946007)(66556008)(66476007)(2616005)(316002)(110136005)(26005)(6666004)(36756003)(6506007)(1076003)(52116002)(6512007)(83380400001)(86362001)(38100700002)(478600001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OUiB2rgZCIWE1hTDTB6PKAxAJ5AHOxmrI7WPvjuufamXt8McX4jhpT9czAEi?=
 =?us-ascii?Q?otdpXm/77zl+X8dMBl+6VpZFtyfyrFCiIRS2y9LEY4aL3UpugVRHXP2qSkSr?=
 =?us-ascii?Q?MQEXzFkiyipRtQxQpTaAzVUpK9DDLwwu/uvhwYovQb+QwUNF7bjiomTp0RrU?=
 =?us-ascii?Q?XcAWKSQSRTSLYe4+1eBlRIriVC0RLi/wJERAQKuJVv6WYyxPOdmbpqsX6rC4?=
 =?us-ascii?Q?bYgu7edK4rWIwRRzFVi0Xemeu5I9AsKNjycN8K6kPlnNxQVKIdDy7QIGx9nb?=
 =?us-ascii?Q?VjPcRViUBMEo/qT0M6tyFv4uthq8wR9ji0uPmO49fPQfIsGhN7mpR45KA1JV?=
 =?us-ascii?Q?YrsSwsRzbNACrXPrPBOUZrmB6Ew94lF3hTlKIzF2JvATbpMt5EHm+edkuooh?=
 =?us-ascii?Q?pLsaTw0y5RPZQ9wprNSuwCmUqbjfFs+p3LVWmbN4yxqd/SEzCjh1MAlbg9Np?=
 =?us-ascii?Q?mlxgMuXmbvPXplzS/ErV2vdQyCin8DLUwLn78FfV+KSgI2y6qWdSqlWfZJuD?=
 =?us-ascii?Q?L1RoZEmoxKrO0oElEH2SJ2jBX1Klw7RrvE7MPrOGMvUjVqrBe+YEQSVFYrAq?=
 =?us-ascii?Q?l0x7kRd7A4+XSQg3PBc2OkUnGcXvk19ijUVaxTZubrdLMFMciAEUFdtj2sZO?=
 =?us-ascii?Q?L04jxjsVscu+ydf+asV9s5kY2SGRDup4XyioI1aVUOoEhFa3FcSIOG3Q724C?=
 =?us-ascii?Q?P5Rr9oDVIYrPFdH8NCOCow5WtMbJfqmV6uQ4qf5kMTMkQ2NjP1ra01OElPEs?=
 =?us-ascii?Q?TOfki2f5RPysYNNe9WeTVnS+PEgrzIrVhEnjdilIE8dlRygjC66sWdTafClA?=
 =?us-ascii?Q?e7U+oU6F8wMhHqOgXYrE2V/AZSovOXTLwEVqM7AgB2rtawIEqHLsipdx56kh?=
 =?us-ascii?Q?2jLCmS7VXshK1dr5C3FFo4UEaxAiInES+zez8c/BDqJF1+CoaZMMUAhnVf2X?=
 =?us-ascii?Q?wKM3VS6t1TnpX13bkS2JdXeHo1aDDwYFgC53cevRASNfBAjNtooAj0qD6tBU?=
 =?us-ascii?Q?N/a5sKktWJKkogHyzkYIZSmMOFmjLih0CcISi26CXqvqDf2dkzAiNKUV+XlT?=
 =?us-ascii?Q?BZ+bbvPrTrXa+msu9vzMYTZ+tZIUc6rZwm6zC83eoTD3d+f79VNQDacJhBPz?=
 =?us-ascii?Q?D1dH6X8waCvjT31KKt6NYOx/GvKM4PAwKK18uJ3OK/nGIGtxhff+WdTlJFSz?=
 =?us-ascii?Q?i8be9vtgnTXQpCSzW+VN0bq6X5j9+A7kfL88erEdL7bP5zsfWIt2+ePuTS3j?=
 =?us-ascii?Q?cVVtlDVPrZO0WsdVGOhWnGFRDjcE82ks/ujciwdp8tAtzhxVajkuYziUF1Io?=
 =?us-ascii?Q?Hh3E8w9M2YbNgZQvRsIDr1crxS1Fk1AYaEUVX65qIJoindsaIZh+WrpNRouA?=
 =?us-ascii?Q?Ydy5MSco20K1vP0emweVazVohwGECENB3GrG4Qe9g1XRwlXcMf+QYBnORdva?=
 =?us-ascii?Q?Mb8P4mQ17OAoUSTUXHZ9XEIisN9QlRjNWXR3f0QF32fDFHnZctzQI8ujODEJ?=
 =?us-ascii?Q?2mf7BaHS7FCnAKWa+ZZbWrBdv2y/UYfH3eFkiyDLAx8ZyvPF9FEjtsbB0m1A?=
 =?us-ascii?Q?kKDhwX1GOdouzh6z/KtQ0mJN+wT96Ma3PODASiLbNn7H4Cahbn4SgPT27t3C?=
 =?us-ascii?Q?9kjFqb9Ie5hUX5BYBwVdxlA=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: eda76357-74e7-4314-c354-08dbc4df3de4
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 13:38:49.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LmoMwbJTrTKQrROAB969GWXj/Dll7quQWhUI6YjZj29XKEgsl+5AIBtARd+pVrfYcG/3sLbFCMibfosdaopIj23QR9dm+mi6RVNCgRyT2mZKprfrJmgsAvus56HV3ww
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB1473
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

push and emulate_pop are counterparts. Rename push to emulate_push and
harmonize its function signature with emulate_pop. This should remove
a bit of cognitive load when reading this code.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 arch/x86/kvm/emulate.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index fc4a365a309f..33f3327ddfa7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1819,22 +1819,23 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 	return X86EMUL_CONTINUE;
 }
 
-static int push(struct x86_emulate_ctxt *ctxt, void *data, int bytes)
+static int emulate_push(struct x86_emulate_ctxt *ctxt, const unsigned long *data,
+			u8 op_bytes)
 {
 	struct segmented_address addr;
 
-	rsp_increment(ctxt, -bytes);
+	rsp_increment(ctxt, -(int)op_bytes);
 	addr.ea = reg_read(ctxt, VCPU_REGS_RSP) & stack_mask(ctxt);
 	addr.seg = VCPU_SREG_SS;
 
-	return segmented_write(ctxt, addr, data, bytes);
+	return segmented_write(ctxt, addr, data, op_bytes);
 }
 
 static int em_push(struct x86_emulate_ctxt *ctxt)
 {
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
-	return push(ctxt, &ctxt->src.val, ctxt->op_bytes);
+	return emulate_push(ctxt, &ctxt->src.val, ctxt->op_bytes);
 }
 
 static int emulate_pop(struct x86_emulate_ctxt *ctxt,
@@ -1925,7 +1926,7 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
 		return X86EMUL_UNHANDLEABLE;
 
 	rbp = reg_read(ctxt, VCPU_REGS_RBP);
-	rc = push(ctxt, &rbp, stack_size(ctxt));
+	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),
-- 
2.40.1

