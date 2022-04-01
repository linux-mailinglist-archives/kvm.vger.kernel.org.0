Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA54EEAE9
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 12:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344893AbiDAKE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 06:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344888AbiDAKE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 06:04:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37AC26E002;
        Fri,  1 Apr 2022 03:03:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318jOu1014843;
        Fri, 1 Apr 2022 10:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=FWDHhaLYXH3MT43MAWfs4zpVknOrIILGbOrmwZcEx6Q=;
 b=oBtFAcJF+j4SwYBN1CQU2u/yyWYUN179dnSE3MEENIWnLFHKGue+6ZPNBQSvdUTPF9gr
 7vU4nm1RyXYVwKb49ViutBXubpTaVbO31CxEjurZJGMdaFbFHk0pEucB44rMMN7GZp8+
 4rWdPpL+ehVILh5PirptiVBIAws9zBgtEO+2f3IjSc3WFkOtivL0tjZ6Xnrgdq/NUpOR
 P/t3xm0VNhrLq+pM9vnZAYlK+9Z5jI7SnhNVbpjU1wSDyL1DUemT64RdhX3VZw6aGz5C
 DX9AJ8wnnaEiX31IacJI1/bHF3kP/KvkaDAZOE++osnZqWIMPycz2UoXx8KVkQ9f8tf/ 1Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2ppsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 10:02:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2319qaO0007527;
        Fri, 1 Apr 2022 10:02:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s95nrtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 10:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSz0LqH6qynTUAIgCrUyE/cD0Lkl6vxi7c5RaeOGIMM413LRshmtUp4awQZqFJ1MeXKWZa4jQKWBlmYP7Am4maZDhzJl4hu94aQPz/6+OvaZ/YVlI4cj54fAZkKnCVW35vQkwHq07fAN+tl71Ktm0gP0HTke7CGUoRp08vY6tO16h69tM94G7UM8IYzWaU+WL/8N8DgeGOvQsilHPUGq2H+fs19GeIFr3iVIKg4YAuGdBEsaDJMug8yUk9ZC+gwSnXE9Q+3pQmW4UzzjfGH7e7qUdypV0taOXESs853u3fb5SoSAYPwWN9JbbN3XphGw4puDjyxIRu24vEFeZpFobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWDHhaLYXH3MT43MAWfs4zpVknOrIILGbOrmwZcEx6Q=;
 b=SoMe16Ai1rAhPB0UfEwGsX0dw+GESUvEPAJAizuVf9ltFIPPcCGGTgcvXyy0kF0YE6tNkkK6mCQJR6Z5eFj6bZtVqlqBdus32523WsLHQnA4uZPdhaFH/Wqt4rJ8ECpS7gLXyuAAm5G1xS1is8BnhlUYRkmeUlZwDyPcI2U8tGE4hexOY6+fjlZsO6rA6FnOFvz2mEnjcENNnAUnMsOzOF2hmYHtye5JImXk9ydHPe+/PgBCht4jO1HAhFY++wpjDT7kpiqHE09LLXnW6YiF1yytWl7evWiszxAWyTSo2OfJ2TvAktXtk/TW3QmwlMY2tXQg8h4QbWKiPNyxPjfITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWDHhaLYXH3MT43MAWfs4zpVknOrIILGbOrmwZcEx6Q=;
 b=Mfwo17WaC9QH+hDjQpjzrwsP78yI7vri5VAFyOj7O1nkNtf15uONQMHedmG1mDS4OugHfW48PVvoHG6FeYE2qWHP+s65RAW7pN8A+V4NOfGA1xYSnIwbsnGHTgd0iMBqDXGiNO8shkWWirJy20mqaM2SqzQlZYHFvias5mFBmBw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1373.namprd10.prod.outlook.com
 (2603:10b6:300:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 10:02:01 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.025; Fri, 1 Apr 2022
 10:02:01 +0000
Date:   Fri, 1 Apr 2022 13:01:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: MMU: fix an IS_ERR() vs NULL bug
Message-ID: <20220401100147.GA29786@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c048c73e-5fe6-400a-77ea-08da13c6aabe
X-MS-TrafficTypeDiagnostic: MWHPR10MB1373:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB137385D41381BB1E37A3EE468EE09@MWHPR10MB1373.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLBjcJfzvYZEpZEr+RMUiITLrm2Qjqpn1ycSt/e9BMU33Wk8OSKf4IUEh1sUZ4vB2noihUQrWWe3GcfM/dc3bnUY38cCi9u9A52tJcjwwa69AJ/5Qym7nUr8eQyx3/esCaW0FKSkKFJQzZS46EQ+ZS6xO4Vt9JyaSNnSXms/ZmL/m0TXsGimH73OLfaoVfp/uoPVVR6J1cZiQexkM0+R3q9Ks8TNw/kx59NnOLI81FSDYVbZZRPwwjqEZWorlTYS819Ky8kuZhsRlRPU6cdxQztzou1rFuHvV3H5NYJyFu4og8njEG57QZ+aIbgxb8bssBLavomO1iluVham0JtftMfZq+7rvqgsLqvhsbC82XFtQtv1pMOyW2eUCY8ITvrugsweqqtswoV14Owu+3qSSLqGTB73Jp5v31VpDgpzS9Ljo30FPjq6mT5NBmR6jpLcVCncefjY+6IVnK9Rki16EBPMTLejkq40GyTydr035dTEO5dsp9BX73+tjIDvFtZXidVfUQ1kVXKLRGXa43oytkZu/qKtJCWByoyH03ic9ABeNp9aiJ9O6AMP9332z+wXiKxBoTKpJktywkHw85VqQeHCCZQl6wpeZ2rHcmRDxwpSCHM1KAS9OEh0eNOyw4xzK4sER0lc4NWXKZOnx88dV8N7lyjZ2eEiRn0olJnK06FPYMBH91yHR7ciKiEVnKb+ulodjISQoGDAG7syFpIp9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(186003)(1076003)(26005)(54906003)(86362001)(4326008)(8676002)(66476007)(9686003)(6512007)(83380400001)(66556008)(66946007)(52116002)(2906002)(8936002)(33656002)(7416002)(33716001)(6506007)(44832011)(316002)(38100700002)(6666004)(5660300002)(6486002)(508600001)(4744005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0egOCiySy9gEaFF4GT6yRlvYXTLhfCC6Qf04H0ETPjNSS6XCmAamZU+2aA2w?=
 =?us-ascii?Q?gwHA5hrtFmceOI+F15PjaohS/ipasB8Dou3COxwiKc5rUvfkENY9UemWThA4?=
 =?us-ascii?Q?ZoYoB9Oy8lTaFJeOP6Wi7PDH17GuS9pjTdiaf7PD25Ssr31PoXfytCckW/bO?=
 =?us-ascii?Q?rvIGUmT07kofk/bAE8nHhMALW0Hdcywm97ZBlk/y+doem4jiD7NSp5EtCL7w?=
 =?us-ascii?Q?Jqzapz4wUSe/eSOap2h2LhmJQDHSr0EKUh8zeWuKuqf8YMaQ+qJVho6fKkw4?=
 =?us-ascii?Q?o4jvpR7o962q5YwqBKfF2gO2u5y2c0OLAviYp1UaroBSaO1uo3Pv+Oxl4eGH?=
 =?us-ascii?Q?OLYXUYm6b/J1eGVCW/FcSKzewr0nMgUdrOfH/N2ilX/BNIKwWFYqOHoArLh8?=
 =?us-ascii?Q?ifRIfpC3j1rO5buRVJUrakxEvssK2CCR1BovQ2OtsmHdPDm0D1XP+ckCmQ/4?=
 =?us-ascii?Q?CSvt5MJfJDF/LcN8301NKdszpsRk4XYPeHeeqon2tYEoxPthJbkfxKqXMifA?=
 =?us-ascii?Q?AniJ4loE9pXLC5b8ZPWxX9vOcwAcYl6BKR8q24HJ/YlajCXuGvRVbplzPrIJ?=
 =?us-ascii?Q?6D7cQdzXtB1H7FVXgyxbDQKOUirRpVrGmuthbg32OjU/zJzg7V0aaZqXBkj1?=
 =?us-ascii?Q?0YAb4pgakuwCnmX4nXCCUxYOBsENqjqD238c9Hx7qCwSYgnNV4HJKht4B/EB?=
 =?us-ascii?Q?3uf2AUoP61lZzmjCJ9emMEvVfLsBGvpAsq9MyHsvXH5m/ZV3HNt/MyLepLay?=
 =?us-ascii?Q?8/baWhJKALRoOsJQG1jCQWHeWcDD0tQRrVM5Y4m9LgJ8sQsZy6WyfU/TbSRL?=
 =?us-ascii?Q?VrTVLdqJkDDTIKGdc6sXTqPrhUhvD+s2Dj7Ee6e11/YPrgYVUyc7yE9QYc9n?=
 =?us-ascii?Q?vTN0NkYdkTVDHTypI+WVmyZ0sNJEaiNNthNhzPzZUE6udty+WSokZLFHdp4c?=
 =?us-ascii?Q?PQgzohcAKrS8CWb0XkACG98vWNVio7nmp7xDwy1ysItLiWFENlApibDf+oPy?=
 =?us-ascii?Q?hPpNZ/eaR2sjZozxYhKZVCkGqS3etX4U35HOMofuENECDPUgmnDgka87l4BI?=
 =?us-ascii?Q?HVRDIy8LJ3HXpJuVlofJuT/AyqNmgE8t6GDkcYB2fiDAGzzP7IF05vSt23Fd?=
 =?us-ascii?Q?Yo1SB6gSVjs2vtWIBRE+Apu22ijhqYS8x1tA+qDvkfoP7LWe/8fGD+ppk0dJ?=
 =?us-ascii?Q?tg/JtJkt/IiUGS6ip8srA8t284kYKDbYfItSvwmcgY11L761X3tr+CwEoqE/?=
 =?us-ascii?Q?RdfOmHJvta6Z5enkbeNYd8U3X/Wzb9PTUHpz0HOulmqdby+2b9LfZtAkw9fs?=
 =?us-ascii?Q?2ZBNSinaVwGmlBCHhlIeVv4LlNISRUD2k678tmgssoIIFGPVmPe3olV0XFji?=
 =?us-ascii?Q?yOEX2CW3OMaBkVtrL7YzJaBmHfW+9ywGAB2jw1XLV3bHsqXPfnab5Nq/DOXL?=
 =?us-ascii?Q?aimA9eLYKugQ/FO43AFkBYLkatNw8BzxH+yJP6PNk9EAcNGe3bygS8fxkBsR?=
 =?us-ascii?Q?zcHK6KzRRfCCpkQsUDVhmxreU9LlVC4yy00ExffAneJ3tZWxuC4Tg8r1Rc9b?=
 =?us-ascii?Q?wqnoy3+zb8Cvsj0AumegDkITUYe5jl9tEUyY4eSWA4qUTtUjWL6ss4BN+qyG?=
 =?us-ascii?Q?XQhQU5sM69wh272bv39sTgxwA5t5PKBKTxZA/kLI/Cp03iBQEv5jQIZZ4CIe?=
 =?us-ascii?Q?J0H4OlN/3OqV4QKgqGyZX21vh85plMBOGggC/KZdMaRwJuzneBjw0xdESx/y?=
 =?us-ascii?Q?rAiL53pqAkbsqNjfRNCxolYaIQwnYA8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c048c73e-5fe6-400a-77ea-08da13c6aabe
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 10:02:01.6658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azi3EiPY8SwSfNTQwSRZR2UYqfe8yBkN65K4e6CBKjRoWp76HAjcOqRMGiUljJAbUMv/QDPbHqCdmqP4oSShf1Q0m/2REMk//hpMmglZyIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1373
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-01_03:2022-03-30,2022-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010045
X-Proofpoint-ORIG-GUID: tgCcm1cRlyRw0cR7oEsiCp1g0KByCrcx
X-Proofpoint-GUID: tgCcm1cRlyRw0cR7oEsiCp1g0KByCrcx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The alloc_workqueue() function does not return error pointers, it
returns NULL on error.  Update the check accordingly.

Fixes: 1a3320dd2939 ("KVM: MMU: propagate alloc_workqueue failure")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Obviously, I noticed that the patch says "propagate alloc_workqueue
failure" so that's a puzzling thing.  Merge issue perhaps?  In
linux-next it alloc_workqueue() returns NULL.

 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2f9a34a0168..d71d177ae6b8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -22,8 +22,8 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 		return 0;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
-	if (IS_ERR(wq))
-		return PTR_ERR(wq);
+	if (!wq)
+		return -ENOMEM;
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
-- 
2.20.1

