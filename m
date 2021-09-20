Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD4412A13
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhIUAt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36922 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233841AbhIUArw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:52 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KMFWVK030152;
        Tue, 21 Sep 2021 00:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6/uezptylvJpl5SFeYemJ99x+Ta7s8GV5BmHmg9m5GY=;
 b=OlNt1Q6VKlLtwIMwkwpuaKjIORkxvFWHGeSFHgZvKo1Kl+DZSALjLCCbNEFIsVCVkEhv
 NGYEtpOBryrAu+InDb0FPsfmZY5wRgexuMMoWjmmMRMtk0sj3GQ18AvjEL/3tezII83n
 2Zr0RC+Xk8EwC1zaPHOfrae+fzldzTbTrUZzRyh6JQd7PlqKarC3tB6f4dVTwQufDyJV
 koYFdxTUawoabiQVZJNYzww3CTM4mSkogg5NBZ7/N7I5JizxMJWb0hkYFWJNdRsopw+w
 P/lO0sI3uQC58/+O15VCu5eGM4EQxZPvK1Oz/AzbpTy0K/3m3dGJBx1AyWdpqZNLm5Ir +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b6426ddwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0fVPn058024;
        Tue, 21 Sep 2021 00:45:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3030.oracle.com with ESMTP id 3b557w9vej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfinnkPJO9PX7OZj7XlaP67nVZi851Sw8/Sz/wvGjp1z/mHgGbV7bdmtufKM2NT1i2ZsRvffRD+3q3kEGIzUU2y6WL/lwS4UuqeXhQp339T1IAxYvsqN7WSqtDA/+qXnaq8tGpQLjthq9DA/rhDEGEVNQnHr9vs3qhDrSB+ZKt7IWo5f5opqc2pIRJllW04YSiTRN7J+1umIyadg6Z8i74tl7rirXT/SqRbA1oEiB5aIbqJdg35WYhJeY6jlZn1xqbhb+RegbGxCQRhMtB5KM2J66OtU+w0zvTpCFKKsNU4qIaGea+lb8VCcnBeTRAignlcU2NcoKYP4pOeYHqferw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6/uezptylvJpl5SFeYemJ99x+Ta7s8GV5BmHmg9m5GY=;
 b=RvbyxWwgceFuC0ACDIkk3skLa3s8+XIhqcUVncr/giSiQAjiKxy5MkdJQkv50YFPREssObKUJRfEXanSy/9TZ13SzOuOTuUgfYMVoagJKlHX7CSJlAQ1lyIQEFbRORNnujb94sAjHIm66tdbWjR+htNZ8pJhRKWSW6dz8bgtPZzF+yy57pFNNR3/J624pW0+C618yVTx89/Rp0MME4g5MEmEtQ1JhtuExZ83O/2KRWzG5CaOMnahWowwSBlmpwXRAPJwSpWi7vkOppp1jszOGMVCpaaqUruR2dBZp9Cx6x774jLPHiCDPDhCT+DOxU3GbaM3z8e9zL1eYI2ZRt+BXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/uezptylvJpl5SFeYemJ99x+Ta7s8GV5BmHmg9m5GY=;
 b=Afsej5dzHM8jqoHrkl4Qtw/xMeojmUnHgdpnQqRE407vNQx68FOKlWD/mJn/JOXANj60tuxCJeLH7Yvq2/5eSbQUCUVBgaLtNX4Mx+n66XohsZEW0XPTKQPIufuzWHPvp+/PxnTP8AxkpanvB/heixjO2DCTCVzTBTr4Ia+6+Rc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Tue, 21 Sep
 2021 00:45:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:45 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/5] nSVM: Check for optional commands and reserved encodings of TLB_CONTROL in nested VMCB
Date:   Mon, 20 Sep 2021 19:51:31 -0400
Message-Id: <20210920235134.101970-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4859e34d-91d2-461c-51cf-08d97c99256c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4426:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4426CFF54CFF7AEAAF12D38981A19@SA2PR10MB4426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkBy82IAM8sFWyEcKo8/TiPB9yP0Xfi18Pz7l6IoOgBAn/NocZ59Tv69gOM3peN1fTPDOWHFN94QnIoYpje3aw1WPCdFgQl3xIeeY3vOMn668Nufu5oR96aQGn6PUU4a/dpVkfMIaROQrr0BeNB8a5pIxxnrco/0u35GmB+k8nnC3RzCSem2w/FGnp2ZIMFV/h08gg0suHT8p3MzT3RUU1zzO5v0uEipD5Apw+jg1zk8ZpCrOgh/KOWVi2ewYOAXRW7nnJTKbL0JrrAsmo3TDL0nwpSE/uOz32lOEbE9+rIlHKi84DoR/PmDeFmkaIVh4ee7LP1jiilzEWdFJOCOgMpOm8ncTh3u4FB51KVtPJmtRH89gf2f5gFI+acOYU9MKwxB/AaL1P6f8w5Lot+LijqO6t1drdBBaMzDRMD2T4Qv/kresK2EE8O/oJGBTbTTVJjyCKrT8qRiF1s6cShspgCxi46con+9ZcXWOyVKwMpmKHwH/wHmjgTET4C8JbRsbsr+UMn8g1GFyzCw2MyimNOBpIdYhOOHh5RuWZ6omhZHer4i9fZRqwZDXg1CMHwT8AKBHNT0kJPuLcBXIVwkKyyHLoNtZ90ioTMsjYQreTHcUdijPkKR3EzSp4nLfDMMFT6DOPF274r54qoxos4QMX4Lq/6dGJH75ofsDi2HyGfyJw+IzpsPzNbsfZbtua0TqR4hzpvvR1yxxW7EX3Kpuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(2616005)(5660300002)(2906002)(66946007)(956004)(66476007)(66556008)(6666004)(186003)(26005)(8676002)(7696005)(52116002)(38100700002)(38350700002)(6486002)(478600001)(44832011)(6916009)(86362001)(8936002)(4326008)(316002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t8+SxjJTC+aE6jOwjYxxmdXl4j4RLjzFi7aw3A5D/NKY5LvsEixcEi9aFwl3?=
 =?us-ascii?Q?RTazBEI8dp32Vdaca3zsz6Acak+xHCOd0czSjb73wL+S8oG6VdcGpWMNlW0x?=
 =?us-ascii?Q?U/MVq/UfjGJUxFMoJjC0mjmSbvrAcEGFB+4qHDRvM00CJ4MiHbhf9YNcLpsD?=
 =?us-ascii?Q?JNia4Fhu8YeymLWJVMFUdkkiaLO0FNkSOazDNF3VuwCq/ymrO1K9kk8vwM9n?=
 =?us-ascii?Q?gfQXugAYMvr4USxhZ7tte4pVvSgejSk0n14X3tq/IfbryUORn8cz/1rUQoQU?=
 =?us-ascii?Q?HcSLWmVX+OUbpu1uOqwFsGNaRU+AcHFZmeKOZnWGWNQLeH28VA4Rvya1HOX5?=
 =?us-ascii?Q?iptP6eJbNCDLAu+l1dpOkUyyJDPmDnv0mU5L+SeY+skQ3oazKOIq+Et7x2MW?=
 =?us-ascii?Q?9KhqnaIE5WHxF+Rkask9ohMUQ4oUvKJBG31M4rk9WZmEM7d4Wd4CllxslEWt?=
 =?us-ascii?Q?+ES9zzR2x8PNudHXbFJKpAwmNBirWgDTTtfhm7Dc+IlwMrgOjl43rjFsLgTd?=
 =?us-ascii?Q?BCXMkifkoab58SoGIq1ndrXJD2Y0AGxq/4LeoC8NqJLdyYYmG8/CLQ9gvwlD?=
 =?us-ascii?Q?k8HxY4FGnxMHFTws2+Wn9Hay25m+C8MwzvavQrMZ+Tyhi6y8WZhe399MG97H?=
 =?us-ascii?Q?8iAn6MjLlWWgVYtxResFzMTRhhyUMn99JqmRDcN/S3eupVdLnxusxRaLlaMP?=
 =?us-ascii?Q?Wd0RcICeyu6CiuoFbOo3kbvEvHvtFjj8iHNwVAq/20cArJiuBV6X6Or3LRod?=
 =?us-ascii?Q?40ltafYgmocMCmQz5oc1H2tuhhTQX33rPLeBYW1N7sAeaxhxyqBgDYDlC8S2?=
 =?us-ascii?Q?w6wwgsXAbrnwS6ps5ds57U1qmbArW9tBuMD1MsnxcSqQGhV+LUsG0gy9OxZM?=
 =?us-ascii?Q?2ZTNxJksyKZXaBv0bhBwqOWtDigHv/sk4WIemKGavxK3azZf8kbsKURUcTo/?=
 =?us-ascii?Q?MX8dJvtDOAVQBGZW6AiG/OfirzUmBqT8/TQC237FocuFdrGJniFxaUHymd0u?=
 =?us-ascii?Q?wJnkis6M0VdTZ+GC2xJ3idmE6BsAqSVMzS8MVrsUK/UqHi9E0P4kNG/THvuj?=
 =?us-ascii?Q?xwYINUHRFbATC/DaFTFnsL969Gci08s7m8HoTp+IKyzdLEru12d9a3Orj5x3?=
 =?us-ascii?Q?sAdTfiLvzIwd7o9AGPJTXyKwGuPz5/JI5QduptBrStGHr7rMlDcmKdN5QFcS?=
 =?us-ascii?Q?Wyp7opR4U/9ut23PV1kad8ApHKFedxHRKjfOIrHX6A1mdBwcsU6etp/WuBO6?=
 =?us-ascii?Q?2huUlgX4B5oA8vXGKzHzM7pnszc6RBBRpaTths+qtRNlWYkiQe0D4+0WCeGZ?=
 =?us-ascii?Q?lQLcIQfYMaoEQZC10OdHrNYG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4859e34d-91d2-461c-51cf-08d97c99256c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:45.1361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8erdndjFcnxCzJTessRCSoiQUsK2G8V/FKAksPWEE0QfhHx+MKL5JHULTzeVQ0evgsOdMnPCJU7TrCVHQMv1juyM6VDnOUaAlC99lQRTSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210001
X-Proofpoint-ORIG-GUID: nYfP421YrVQWi1Eerzh95rhhzAsoecrD
X-Proofpoint-GUID: nYfP421YrVQWi1Eerzh95rhhzAsoecrD
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "TLB Flush" in APM vol 2,

    "Support for TLB_CONTROL commands other than the first two, is
     optional and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].

     All encodings of TLB_CONTROL not defined in the APM are reserved."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e13357da21e..028cc2a1f028 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -235,6 +235,22 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
+static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
+{
+	switch(tlb_ctl) {
+		case TLB_CONTROL_DO_NOTHING:
+		case TLB_CONTROL_FLUSH_ALL_ASID:
+			return true;
+		case TLB_CONTROL_FLUSH_ASID:
+		case TLB_CONTROL_FLUSH_ASID_LOCAL:
+			if (guest_cpuid_has(vcpu, X86_FEATURE_FLUSHBYASID))
+				return true;
+			fallthrough;
+		default:
+			return false;
+	}
+}
+
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 				       struct vmcb_control_area *control)
 {
@@ -254,6 +270,9 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					   IOPM_SIZE)))
 		return false;
 
+	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
+		return false;
+
 	return true;
 }
 
-- 
2.27.0

