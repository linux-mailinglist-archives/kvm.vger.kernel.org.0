Return-Path: <kvm+bounces-7260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5E083E870
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 01:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB1351F22A7C
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CD02912;
	Sat, 27 Jan 2024 00:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmVcraQl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EO2coDWp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBA417F4;
	Sat, 27 Jan 2024 00:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706315116; cv=fail; b=bPyTaKc6RY/rN6ZwLyZV3Qe71hV8jTBGNwyfVhfdEhmytw9MrSsQqXoKbuqK/Z0OnkO6RuNQu97rG0qacBffjufahG6QfMVD7a/F3LJEiH6hUqdxxyGhV3xlJL8D9nMPJl0/paR97bIv6C2MOWShfqnlNBV7aA29OlrpvvRVc4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706315116; c=relaxed/simple;
	bh=rkpw32swyaMNgzMFyOIr26/qd4MkOks47A2BtLuJR/M=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dKqnrQyhMiNtkxJ+badFej7+ymlu5B9l4AvIbhHCYo2zkqrNPcJptp9KLmkM/fXnME7SHySJx5Go/gPZLSlDvu0r24+oY/D4iDCTbfX+v5Jtr0fZ6sVrLEOLygoejO+tlMlH8lL6caCw7hjR04GOSJYUcSm64X2+NrxOvpNWNjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bmVcraQl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EO2coDWp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40QLeSNl027536;
	Sat, 27 Jan 2024 00:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=WVMdUQMtLieiPLiXnz3lkm4b9VtA9gLcmHG1OWVHN2U=;
 b=bmVcraQl6rtPbysW/9nHmK7WoTw5sab0MkLXZhWZ9D0+zX/JwJfJY2l3Iq8ZMF+nxdqn
 oAiKZX/I90HNtQxq8Mor32a9TUYLlIffiLtZ3JclNtmPB7rCa80y6gUeBMB4PF6s4QE+
 gvamJGTYmwvC4l2xWevbCJ+Ep5GXV9CrLoiKE99K+GcmiFDCmSTsH3MZU9etqQ4vuyKQ
 5M7nZZrXUDyU03dGgDMeYO9N+/Rho9DMGazzWNg06abWqf0cRVkLrd2p9mJmxiSQ/xCa
 ru9vJTx0iGCPemQmTcJlenl5fbiH9rkE/2jzXdKcqkk4XZbeyTYhCh3b4Crc2F+EYYr9 0w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cv3fdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 00:25:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40QMpsHM014360;
	Sat, 27 Jan 2024 00:25:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs376kvb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 00:25:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQukETJfEhA5e5MRtEIkCW6Wa0z8qAFAEyvlqAPDpAflb4cnbvnsnW7Kun1XoXuP/OWC727UqJKfNRxuynlCUUZOVhCZZu7uVkMCpq9BcKS3Yz8QNgefEzOqGQggpSCQ8GcW+qTTPALjdgowyckw4Dvv0dWjUsEtj7cMw5ZePxHsVg0/N9op/yMSy+M+BnArteqeqG7Kd5ApbN6um63tF0IdY0PJSWxbLO8vEBFfCpUMLPXcz2ExGM64thpkYZC6/xLGbjKy07XxGhwUp8aKf/RFcOzblBYCoTeViLnlYTyB/AdaIGZvtFw/N0RmusHfn/4TT5hOxy+x7tiQXUwjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVMdUQMtLieiPLiXnz3lkm4b9VtA9gLcmHG1OWVHN2U=;
 b=dsWofi97/kq0fkeU5bZqW+s9TOHysNX9sT0bdBPUiSKBUcbj8fSjrepfa3zDk/Q9BrH5F4FtMYHlIQutq6f2UA9fPrhxfPSmQf5dUkGJWBOOBWnOtaQptVLhXHutgiQFpxjVBS7ZqRuaIotJiA5wOrimVj8vtigMMrpvqmnAnIZxrMK2RpxG4Dylg7G8VeOfJLNuEzi2MT4zwjGGyjhXZoyVEr+YLl6K3XzfdHyHcq/VoBdqgZOx/twWDTkAcNwA9785MUa1PQapPCIv0F0mqTyvoZ15OnWomuWfikLh216420X9IZzD4W/RQkOdgnkkuZCVlJ4QbG7z4ZZy7vtC3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVMdUQMtLieiPLiXnz3lkm4b9VtA9gLcmHG1OWVHN2U=;
 b=EO2coDWpIid2filV7BmiO+50pIvEOQicrg4bAxNFetvMf9T23I3VutnI+pQHRQLBvKMEx6r+9hQJaW3TIN1Iwjw8MwaJAMG+DldZ34Zl8RSJPrFb9iweDs7nkaS/83Wk9+SpclTGhylt6qAT1mq0iMBz6fhCdi8ohcp/ScALUDg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH7PR10MB5815.namprd10.prod.outlook.com (2603:10b6:510:126::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 00:25:07 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7228.027; Sat, 27 Jan 2024
 00:25:07 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, joe.jin@oracle.com
Subject: Stable bugfix backport request of "KVM: x86: smm: preserve interrupt shadow in SMRAM"?
Date: Fri, 26 Jan 2024 16:20:16 -0800
Message-Id: <20240127002016.95369-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0298.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::33) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH7PR10MB5815:EE_
X-MS-Office365-Filtering-Correlation-Id: f19aaa52-17d1-4b14-066f-08dc1ece6a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jPEVn5yGuLFYpkLDHalOT4MS1Op4fa2X6IzHqIkVIdXNLFfB7kj7yEFNSE2kiJbV2MqF19mKaBYt1zPjMkd1L3J8UInRksRcwuVBKIfrq/4rdDG23AItdpE/ab0fSs3aFl8ePLmEgiqtlFss14j1pucrvFdAfBDevZbYBKu9xyskVxZv8KOjiv8jwy1q2CPXNd7xppMtPlhQD4y/OQxU9cCt81a3kmfutEPkJ7NgjjcbP3EdjAQ/p0oqe3QNkECLg3YJmJUg8Wk35Fq0j32b5h1Pi/V2hFC9ZV2NIetrqdMd0JA3RmKRXnMyhfoWpFDAD42ODioQmU1neqfu9NldNxcp+NwLskmNehT1dHQGVH0i9A4Lwujnk+qYZRHcwyMR7tQxRd7/uiNZnwzkP8t6DyaQJZhI6UV9T5Ka98uYBB4zdkwbuo0QBJSneyStz/kdcCq/7H43u6ukPSxsj8AkC3vA/WYDB1egvows52NFo13IIG2TYv6Maj+VRIj26I0qjwnUsS0/yKZz+B+pXsTJ0+Jf48UG/PmuP3YWPaAk27o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(366004)(346002)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(41300700001)(26005)(6666004)(2616005)(107886003)(6506007)(1076003)(53546011)(83380400001)(8936002)(4326008)(8676002)(6512007)(5660300002)(6486002)(478600001)(966005)(66476007)(316002)(66556008)(86362001)(66946007)(38100700002)(44832011)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LwgfzVbLd5rmxa1w6vg7cdDQJbiWY8CL6DSMxPtqEehRu1JEKm4P6PJz2gLP?=
 =?us-ascii?Q?xY2JxAogSFyGadL1FHgsAvmyRAm1+4bZpyfPdh+XFNwBwMC62rXfaoWbXp49?=
 =?us-ascii?Q?0qw7s4Nl/CjPNRw1aq8Xf+PxtBhpT92Tm6G9+A1V72KtVIgdyiFtOpEV1FfN?=
 =?us-ascii?Q?laYDiXfBFn+XYIKcivxJWJU4MIMPbGVMXRH0+8hyEp+zGA9sazIk/YYe7gEV?=
 =?us-ascii?Q?v7+U1xf2+uyxxNqg97oQlIjAwmiDqUZ5mLQgQ2ZCzrol/vkdI7gDOhls5O4v?=
 =?us-ascii?Q?eBpKcD7MwVsckki4ybR+rBOK2f+kajDYqXEWdo+6UcfCJ+PF+OciZsZBTLhp?=
 =?us-ascii?Q?klmk9iCMGj8vVmc9BRxxolInjaxV2hW5IirDbDrxfmeFlKr3ZPwQBVusuzZ+?=
 =?us-ascii?Q?BQjTKB82rICNNo90Pn7rmy+uFETzfcKU4uVv2/aTwj9gY90PMNQPsYooJW9S?=
 =?us-ascii?Q?8kxjO5bZ5Lcv1bu/CIKUeLe0/NCvqkXP6nPKv3fuFza7FU3wmk80qtF3/18P?=
 =?us-ascii?Q?G8CydOXAleSGzR+U7vk3nKFQjr/Z+yeg46GqaVjj6H98xQDoN4ZJ10pxwu0F?=
 =?us-ascii?Q?hwonIAo4gBLt7wjFHFJJwpO1Jvtb/YfGcIKm/rdCYtglGIPW6k84TUC22nK4?=
 =?us-ascii?Q?L12+sLF8fN+/JQsnmq5oBBFbnzMJicCRpFr67B2DGdjnXzb/8da3W8/Uu4up?=
 =?us-ascii?Q?HBbDQaIwHTgOaDvfhAragr5RCn87sUOKG2h7mlrtWOabpojQtKh6WCzfpu22?=
 =?us-ascii?Q?YZBvDdQ5CTgOZnohA1gsh9l+q/FjJXks+A9BTJO793yo5lOpHGFu61fQ0QMc?=
 =?us-ascii?Q?wxw4SjNssIvGru1tC3qrRIm60SdHFUcWvNDTfAsJCj74wAOEtx5PJnIAxfca?=
 =?us-ascii?Q?aNS6FhtGnwmM39tl2Lqi83J0KaGuLO8jXngEcd4Tt7oBCFnzDHkx8TFMNBt/?=
 =?us-ascii?Q?xxtt9RDOf6HgNc/+V6AryGChNlkxe3a6CGO7R2doaTtpwdzDapqzlCSCsQjv?=
 =?us-ascii?Q?ZNAO/GvOTzSGQ/GvojJEDsApZXZmqDK3hLM6Xtmw1Dq+zkV9Md5ELVce4m9+?=
 =?us-ascii?Q?17TznywMcA1/HxC545t+u0dzYqVosefNudjS8hOVlgFmzTrvd5b0xlJnvUCf?=
 =?us-ascii?Q?vQlrU+ycohBnaKPFk6S5nm41QzpKn30L8cnfK0QUj6nTePsAgv6+kaURwCBN?=
 =?us-ascii?Q?f4wEB7/1TiGIWFX7gQhXReYPqKWSbt9jpkamtTr3/cfxHaZnh/vohiGCc7os?=
 =?us-ascii?Q?+ad5elfkjXF1d0z6m5rTtozUdkCG7LPMr0E+0YjHZbXBVZTVgBMx46kX5Ok7?=
 =?us-ascii?Q?28a1xYR6E9DIcn1Gpjw7Mcx7s764GjYVkbC7+//tl7Y1TH2RSRD4Infkoi4H?=
 =?us-ascii?Q?QFrApWnkkUhdt+lnL4d8YSofh08P1QsfMiAQyfl01boJmR7Zh6O9KuTrAQcm?=
 =?us-ascii?Q?pIMvdg+cLSpI6q2eOSJD0KduVQ5JFq+S3tWvDHVgOx6K1WOG3WxCx3DKVViG?=
 =?us-ascii?Q?W0BBYZTa+V30Uqj090ClQaPX8+LZw/pQEOUB4l54tfwYAefKIqlt1G+OX2VW?=
 =?us-ascii?Q?Q547ivNN/laT12I8YkrYq4BdBdk4r/OfUG/t3TfDhkQEVx0Hx9kUVTbfj+zA?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6dkr7Ufn6IzuEVEIXitPEXtzolATrx+NfaKn3gsGW3uzmRDzm+RWmXT6LY1icr3Hd96vGXDLUpMK4rUUvFNDUdZa185J97V932M2Yo30m1YurzuxeTEy9YtiyVsCVgqcoYGrt5ih/rU3bluNH+A/Zi1KR9j5XB5Q6jBuCiKUc6+pFwbOLQSlmJTe2GJFU1qiGAEEFOO3AvvngqpYmt4mmoJRyUyVKXT2E65MSI2oLtXeHj+H0fBduUrwB1eDn3grz+fDpTnFfbLDehNeia0Yrmp8vTWVinHAbLHbP0kvxXJOS6ZPYxOz87oxlEDBlQIhFfQdkvsuPiYn5DUR+eFYVPkhqF4jhoZefoIgpEGuryDCwCZpJw09ZRZlF6R2+lu1+paTTbXlvfe0LfzQmboRf3+SSOXPT4PJQlRHq2HRGi4n9bZkBOHzKFdt6vPjW2qQECtJJtyFlVB19YGcYe2+xFK+MW0eSdXZyL/LkLnGdYB7nmoN9HFqPCiKqG/Fk30Bo2/ZRrsYTQHBQF6h9otBHUpJRORI3JSOetluTuSL+oPHJQ6WFrchmIUzWUx7P1UkknX4WeDxUZjG5AkT7dLi2f/627yZX1yccizXT4Udu5Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19aaa52-17d1-4b14-066f-08dc1ece6a16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 00:25:07.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOin6oxWn7hw6iJdGDN9X0+i5eqE0aRKfPOrmB7ex+4NKSQvR47608QLZEc5CfKDun/acktZbGxV66Pl9XbYjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5815
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401270001
X-Proofpoint-ORIG-GUID: BpIfWe1zQV6Wo3NE6JJy0J1LnGemKsU9
X-Proofpoint-GUID: BpIfWe1zQV6Wo3NE6JJy0J1LnGemKsU9

Hi Maxim and Paolo, 

This is the linux-stable backport request regarding the below patch.

KVM: x86: smm: preserve interrupt shadow in SMRAM
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb28875fd7da184079150295da7ee8d80a70917e

According to the below link, there may be a backport to stable kernels, while I
do not see it in the stable kernels.

https://gitlab.com/qemu-project/qemu/-/issues/1198

Would you mind sharing if there is already any existing backport, or please let
me know if I can send the backport to the linux-stable?

There are many conflicts unless we backport the entire patchset, e.g.,: I
choose 0x7f1a/0x7ecb for 32-bit/64-bit int_shadow in the smram.

--------------------------------

From 90f492c865a4b7ca6187a4fc9eebe451f3d6c17e Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Fri, 26 Jan 2024 14:03:59 -0800
Subject: [PATCH linux-5.15.y 1/1] KVM: x86: smm: preserve interrupt shadow in SMRAM

[ Upstream commit fb28875fd7da184079150295da7ee8d80a70917e ]

When #SMI is asserted, the CPU can be in interrupt shadow due to sti or
mov ss.

It is not mandatory in  Intel/AMD prm to have the #SMI blocked during the
shadow, and on top of that, since neither SVM nor VMX has true support
for SMI window, waiting for one instruction would mean single stepping
the guest.

Instead, allow #SMI in this case, but both reset the interrupt window and
stash its value in SMRAM to restore it on exit from SMM.

This fixes rare failures seen mostly on windows guests on VMX, when #SMI
falls on the sti instruction which mainfest in VM entry failure due
to EFLAGS.IF not being set, but STI interrupt window still being set
in the VMCS.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-24-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Backport fb28875fd7da184079150295da7ee8d80a70917e from a big patchset
merge:

[PATCH RESEND v4 00/23] SMM emulation and interrupt shadow fixes
https://lore.kernel.org/all/20221025124741.228045-1-mlevitsk@redhat.com/

Since only the last patch is backported, there are many conflicts.

The core idea of the patch:

- Save the interruptibility before entering SMM.
- Load the interruptibility after leaving SMM.

Although the real offsets in smram buffer are the same, the bugfix and the
UEK5 use different offsets in the function calls. Here are some examples.

32-bit:
              bugfix      UEK6
smbase     -> 0xFEF8  -> 0x7ef8
cr4        -> 0xFF14  -> 0x7f14
int_shadow -> 0xFF1A  ->  n/a
eip        -> 0xFFF0  -> 0x7ff0
cr0        -> 0xFFFC  -> 0x7ffc

64-bit:
              bugfix      UEK6
int_shadow -> 0xFECB  ->  n/a
efer       -> 0xFEd0  -> 0x7ed0
smbase     -> 0xFF00  -> 0x7f00
cr4        -> 0xFF48  -> 0x7f48
cr0        -> 0xFF58  -> 0x7f58
rip        -> 0xFF78  -> 0x7f78

Therefore, we choose the below offsets for int_shadow:

32-bit: int_shadow = 0x7f1a
64-bit: int_shadow = 0x7ecb

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/emulate.c | 15 +++++++++++++--
 arch/x86/kvm/x86.c     |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 98b25a7..00df781b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2438,7 +2438,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
 	struct desc_ptr dt;
 	u16 selector;
 	u32 val, cr0, cr3, cr4;
-	int i;
+	int i, r;

 	cr0 =                      GET_SMSTATE(u32, smstate, 0x7ffc);
 	cr3 =                      GET_SMSTATE(u32, smstate, 0x7ff8);
@@ -2488,7 +2488,15 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,

 	ctxt->ops->set_smbase(ctxt, GET_SMSTATE(u32, smstate, 0x7ef8));

-	return rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
+	r = rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
+
+	if (r != X86EMUL_CONTINUE)
+		return r;
+
+	static_call(kvm_x86_set_interrupt_shadow)(ctxt->vcpu, 0);
+	ctxt->interruptibility = GET_SMSTATE(u8, smstate, 0x7f1a);
+
+	return r;
 }

 #ifdef CONFIG_X86_64
@@ -2559,6 +2567,9 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 			return r;
 	}

+	static_call(kvm_x86_set_interrupt_shadow)(ctxt->vcpu, 0);
+	ctxt->interruptibility = GET_SMSTATE(u8, smstate, 0x7ecb);
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa6f700..6b30d40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9400,6 +9400,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
 	/* revision id */
 	put_smstate(u32, buf, 0x7efc, 0x00020000);
 	put_smstate(u32, buf, 0x7ef8, vcpu->arch.smbase);
+
+	put_smstate(u8, buf, 0x7f1a, static_call(kvm_x86_get_interrupt_shadow)(vcpu));
 }

 #ifdef CONFIG_X86_64
@@ -9454,6 +9456,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)

 	for (i = 0; i < 6; i++)
 		enter_smm_save_seg_64(vcpu, buf, i);
+
+	put_smstate(u8, buf, 0x7ecb, static_call(kvm_x86_get_interrupt_shadow)(vcpu));
 }
 #endif

@@ -9490,6 +9494,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0x8000);

+	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
+
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
--
1.8.3.1

--------------------------------

Thank you very much!

Dongli Zhang

