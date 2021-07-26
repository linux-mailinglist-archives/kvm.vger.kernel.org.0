Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B66F3D66F5
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGZSMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:12:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63030 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhGZSMw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:12:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QIlWmd007786;
        Mon, 26 Jul 2021 18:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8O4HTQR9KHbz6ftONEGGGxakTpzPhLpt0TNOgUFDnxw=;
 b=UbaZckpH+fH6mjx3xFq0G+oWZD7qSpF/5fmOmYzKyzf0EIYQzYnl6ih69vPHqWT1bsSn
 BGWE7yfP213ifnK+KcIowdlcUxw86LgrlIg0mkibEpYOF/5iIy6qDyg+0x61PvPXnHGf
 L2AE5CaC6CjJ0JPFF6qYhxjZllGXhWzMbZqv7RtWCrHxDitzARlrKum/5/KmXCo55u8q
 PZsBJUHdVcyYEs9je1PJ7lariYROA96iyu59WGRCYPGiyGyvqWZIAiHx4gXFsf+rNEGD
 ij+9EytR5hObl9RQiTmNRLa7antSRz/dDUUGWRwEJMP/FgTLyAO5deWh28nmB+n3zyMH fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8O4HTQR9KHbz6ftONEGGGxakTpzPhLpt0TNOgUFDnxw=;
 b=wQcNa4+3GAT9thHuq8wFgP0e5UXQlBeVRQZh7S0SrAtRqYNhqszW6dil/Ew3Or1JPnPK
 nmnOiof83iEJz18oOvYoiO0vQPZhW84O9lCpjORpQ1yS9QAk8yGj+mRfjRtRZ+kVb4EB
 Rq2AwqHZ/wcAzS2i0WDh8xja1cebfwrDlsnKRw1QfokBR0QzdGytmYEgNCtexKtnfP8l
 GR/jejVDKAcB35O/PAnldkAoAaqejy0bBIpaj4Y7RqvUc/vSxdCp/KdptdfgQLH8W2Dv
 wcGnVM3s9b3QVtxciuvvQyOPhy3vKn1WTQkXmoiPll5omkkhwK4Jjr1Nw/A4DYpY5vAI SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a1vmc12ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QIonRr066815;
        Mon, 26 Jul 2021 18:52:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3a07yw1y6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXxbsRg3tqme7/uNgFE5agTBaiWu8hWFfK5BjJaEvpyb5krbEDXGyh1vKp9oYHStpsRQH8/f6LStRvKkyLOzb6dXn8AnuK/dbFdw3vgdRYvHxnQZutNKQ1FswnCq/2B/lPCWO6VvC25yi3tkQ4OI6QiDWBPiUvPXdoVPbGo+Qyj1OqWgLcZkiVVOvQ/uWhVlI2QX6XcEXrMLT244KXySzkZzMVVvWgsADZ7JQUxxGIyZgpGaJOFiFVYHeOhdDeYs/As4SmJb9TXZY8wjApFABviA4loUFSr+w/P65dwqHCM1YUYV7+Pq9YNCZ7Dv8N8FrdEqJFLqEbFQnBCszqoxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O4HTQR9KHbz6ftONEGGGxakTpzPhLpt0TNOgUFDnxw=;
 b=JtqGiCBCT9r2+DV2VUtVwEp15FKMbTlh7wrvcY1UKRcpjMiRNaaUHn0CeVBqTO8EgPxtvEBG3ilxZh7C/OqN8CRQuFjfOr9PVTK4cn08rz4BdTUZfsgLUGFsC3coDqx3/IFoalSAaJHs1IsxkE2Dl3xi1kTsha3KVHNtlc6dkOoFvyTI1bU4TqXiAZPEjGEfgkfYNAtm1x78s+yJ+fyv9v+27JktpstE7LmfJk04Gofho0geXh0Rt/FA/rwdCR/0GF59N8j355im877iJ6e9UHLRIc+iLVS02DWHXCZd0f/jIUfqDyfvsy+keAnsXtrJ5OFo9elR9njA3bMN0C5Atw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O4HTQR9KHbz6ftONEGGGxakTpzPhLpt0TNOgUFDnxw=;
 b=NSMPZ2zFbzzEgw43Bsk9j1XRUKuyTe5uJknV3khAleJD6YThA78Lepq01c/Q1HoCRfrKhkx/NmrrtbE49PFjOwvf3bTGd0UYDaOBA4n6wQcethkaPm9/ffHkh3/KhwW/xrwzizVSjhojIknEonteeU8O05mJnlS8Wq9Fam2sdnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2765.namprd10.prod.outlook.com (2603:10b6:805:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 18:52:44 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 18:52:44 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        thomas.lendacky@amd.com
Subject: [PATCH 0/3] Test: nSVM: Test effects of host EFLAGS.RF on VMRUN
Date:   Mon, 26 Jul 2021 14:02:23 -0400
Message-Id: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 18:52:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adc13394-748b-46f5-17de-08d950668d77
X-MS-TrafficTypeDiagnostic: SN6PR10MB2765:
X-Microsoft-Antispam-PRVS: <SN6PR10MB27654413A18B1AA01BEE9EE281E89@SN6PR10MB2765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCrjh2UGRHAIP5+P8IrhBhc05cSSw0bNFu7m1IUrKnKwvM89VseihDyB5uy09LFEcrJ3isZ2yvj+LE82wb/32xpaz6woJ33WjnwC78Neoe47pCdVZGNcaebUZ4EaO+MJ1mKjJGDdjcxqLUhy9sFneqEvWCknhjmeeBALoOc0iwdZhA8noQEEnYHEoVvQ7LfEOagMt370NTAhYMeFwaEPwxFy7FuFy0ZIIfXzkTQQbyTKa3nCKeRNjTvY2kK5H38VO3GHG2944r120rbsszcvLR6lgwu1mxJYTCEGCzMQmxoR5vXaa4VZAgORd99MoOPYq2EBPCJRdGyrw5kVBmtMLnR5RhfaTu6FATHEtlUxYaJ6WAaInvUyLqtbRHEIfxUmM/mhFXTggx1gw4gHg4E7SHcK/ZJb6ntSgPmo0mYZsJJwYhHmYH+1QWl1FF+5CFhdCBUTPppI7JMSqzQF36m1NhGS467/ojx63JfMmfafAq2yeYoTR2hI75tF395s9aekwwQIRYbe16Mbbgn/KpCLxyiG+uwQVhfopszFeGdEi8m9HoWm0fT18eLV6m9U0MzwrlfO5xqIu8jQiXkJZ9lTvgwbB7KZOMtd94auRwpzpnelQMVuQLn7AsdP8qMt2uyrbL+zq8cLojN7mQTN6xb1wW1WoIZB074/7UgBAKJVUlb8eW/4CWpbfIjafesz1La5B6rFQjnTWgP62KuCjXrXIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(8676002)(26005)(316002)(956004)(66946007)(66556008)(66476007)(2616005)(478600001)(4326008)(186003)(2906002)(83380400001)(7696005)(52116002)(36756003)(8936002)(6666004)(6916009)(44832011)(38100700002)(38350700002)(6486002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4u6L/HzXf5ZAzqdpFK+4/moYVZh8zOEGdDLTgXsxhZF4+Cl+932XdiJaRX/b?=
 =?us-ascii?Q?pwQNVDTs5HK01ruKSxLGAPAF3RcVMTvc70oQt+Uwl5sQKRpBfwNdSX2JlrYU?=
 =?us-ascii?Q?S8uwgvfHQkpLX54g6VKD3ceUSfh40GpOnJF1//LrcFGQvXxD97/+4GXArP+k?=
 =?us-ascii?Q?oiAITiu2TAop7tFABXRSM8MXYnVuiRcdavpHwa93+QosSkE9BBNYz9YTr+MT?=
 =?us-ascii?Q?HQR6PbK3cLCWK9Jr9tJKup2X6cI8Qn8NzNVnOqxSID6ICBU0rl+kiA2TV314?=
 =?us-ascii?Q?JkBJe/uZIQu4O3ij1KtNpUkg3UrCAG171VwD50RhjXCNKcrnVWpvUMMmRSCl?=
 =?us-ascii?Q?Hruo95LHa2j68U8vERSWEpC9ev5XE56kaoqZ6wlYvJADhpzmhYFnAcdfWfwB?=
 =?us-ascii?Q?3/ME9p2QZ+vGGSf7evMZjWKA+sl66CF2hakDyAxyrzK3CHCdJSfVRjxNcpQd?=
 =?us-ascii?Q?lDLXoRRkcQbDdvBJZ57P+Zh2NJqMV6pvo3vrhTRKM+GuGt/+ehkllny0KcDJ?=
 =?us-ascii?Q?bXwappet/VSIS+hht+9lVoh7fi3/tvdjCLNsxm4WfHWt1UMzXRhruFLABwSc?=
 =?us-ascii?Q?Pvw821XvqwVBHslGYf7NEvFuSKCNVHfV8mujh+8haHoIBXsutMbmyGa1sjKF?=
 =?us-ascii?Q?+3ipOW56DQ4gka8MZk0LBh18IIlvcjmbclgl2r0+8lUytmEPFfLL4EoORowa?=
 =?us-ascii?Q?8db64t1sdPjsonSgYvgzmKnidenjmtubOfZxGTW+kc3o4QQRej2/WlCUnwIm?=
 =?us-ascii?Q?osJN9Y7Yu/8sMVtw2LmvZArl2YRRrOLSMZBXCPZQ52UhS1JnZHuu5YBnsfSc?=
 =?us-ascii?Q?ysMrLzR8mI80jkr43dPHnoHFIuaz+yQp+ARBNGRUz4nnWNEb2XUBAG5xcocQ?=
 =?us-ascii?Q?5Orh8pTP1FgPtEHzxeDaWeeXBUxfmEzeGFz4O25xrn2epRmSN3mTclOiGcnW?=
 =?us-ascii?Q?nfIdgbiH1QDPnuBZjPXLC7yiiNoafZp7gaYb0T1pwwREX+4ZreAbzH9S5chS?=
 =?us-ascii?Q?ZinM+UPfPAK89jhdjn+zqGHJTMq/xoWtUOLYqWvwwRRuouPKpD1kWrC8TQA2?=
 =?us-ascii?Q?K+/tCSOv7r/8t4BPZJyzaNRjOEAXmu8IygcmS/PgauCgJ5t2nP9yWqWyMzwX?=
 =?us-ascii?Q?vZNZOAtf1d6uB7Qkv+eGO3zGsQFgrS/pVBX72sp8s+8bIN66kmPWEaJ9Q6m7?=
 =?us-ascii?Q?vGhl8+ic9F2RYC5ac4c+/J3fSLc+pQEzkcxlAGje7MJMwlQvQnnp9Tibh3rg?=
 =?us-ascii?Q?mfITYjfV/3yJSPZbdL+d7p6V/4Aoo9eGFT3Jrs2sCZSY0TeiSGOaUlLuSWfH?=
 =?us-ascii?Q?6THIrDbGLXULq7TWmAEq0CuZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc13394-748b-46f5-17de-08d950668d77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 18:52:44.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BDOs2932vSTF9tnBhb8oSuJJ5r20YN7lCr7Hd8BjlEQfRQFPWPrDCm2ER2h/h0wvDF4aQOFIsllVPXz2PTRwJy+DJafluIL/t7Nh+DBWxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2765
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260110
X-Proofpoint-GUID: AqMlIL_G3woukKsXoz_h5KhbPpzNDrN_
X-Proofpoint-ORIG-GUID: AqMlIL_G3woukKsXoz_h5KhbPpzNDrN_
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Moves the setter/getter functions for the DR registers, to the
	  common library so that other tests can re-use them.
Patch# 2: Adds the #define for the RF bit in EFLAGS register.
Patch# 3: Adds a test for the behavior of host EFLAGS.RF bit on VMRUN,
	  based on the following from section "VMRUN and TF/RF Bits in
	  EFLAGS" in APM vol 2,

	      "EFLAGS.RF suppresses any potential instruction breakpoint
	       match on the VMRUN. Completion of the VMRUN instruction
	       instruction clears the host EFLAGS.RF bit."


[PATCH 1/3] Test: x86: Move setter/getter for Debug registers to
[PATCH 2/3] Test: x86: Add a #define for the RF bit in EFLAGS
[PATCH 3/3] Test: nSVM: Test effects of host EFLAGS.RF on VMRUN

 lib/x86/processor.h | 33 ++++++++++++++++++++++
 x86/debug.c         | 79 +++++++++++++---------------------------------------
 x86/svm_tests.c     | 74 ++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 111 insertions(+), 75 deletions(-)

Krish Sadhukhan (3):
      Test: x86: Move setter/getter for Debug registers to common library
      Test: x86: Add a #define for the RF bit in EFLAGS register
      Test: nSVM: Test effects of host EFLAGS.RF on VMRUN

