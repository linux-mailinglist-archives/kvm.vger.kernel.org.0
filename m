Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657E737B44F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 04:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhELC4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 22:56:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59688 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhELC4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 22:56:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2Y0C4028881;
        Wed, 12 May 2021 02:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=lYaG9mCpHdaSAqGNzPGndXNZxWV9gxCPg2KmqGBrnMA=;
 b=C9DAEPgNbmHkhJ5YUPLWBygaOD1aFJ8AK+Bt2l5TcghxGFw6TfAZyrc7flY6jD8o2Vpi
 upgZ29HQjE6T8gCFmmadM7UZ0LSKsJgNnWywVk21iGSLdi9dtqpxC8HASXB3/m4+TrCV
 eF3inFmw4QDLJ+J+MIdFzH0pJx7XEYjOhe6gLsL2aMGYXHXk8WvXySnbk3vkQV3rPXjE
 3LdabTkeA5zUk3GDpfWrK+IIL1JJ0SM31GzGbXVidobbh6fiASi20XtYZD0RiTNHz0MB
 Hcrm5S8ywd6n+SVTwH+yh72tENICt0UmwXVYRLK1rZHUeJ7NEzpa1ZEKyMD13KaRGYs0 nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38dg5bgrn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2a2jr028938;
        Wed, 12 May 2021 02:37:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 38fh3xnkqu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIjo3M/hrMClrckxFFAz3SI6EFA9rUmZ4oslO7/cRh33/RPdxLsMBOMxWbjKsQkU+/sE+t5GPJYzmHZ5GGgRz0KE4mZmO4KshojoY+EzjfYxgmBSYa3RHCdXoAsGNuGYFxA1ahfJ1h1FwsLgu3yH1htosfjDY3A3loC7ERgqzKdRJPFDdxY9cM8hnkhu9cuC1M0l92zKp/qDpb2/UogmuAxI3zV79bYntnfdLr6TuuHuNyRfY8q8EQGWQMRIWjkYcAey03NUMzOUU1BjsoEdi5olJoWBxOjlaBFQ0hLnPmMdG8l0tfpeuybgDycR7Femd3/sWlOFBpH6BqYwXpJFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYaG9mCpHdaSAqGNzPGndXNZxWV9gxCPg2KmqGBrnMA=;
 b=erXF6Msq3PVpCjeUANM/RlVJYVEwW0berRoV6vpJRjXUPubBDasu0FT4fQRA9KZUkTE+4ho6ASinukyXaneq5ZJ9Fe0YjbGw3HrHoO3uHgF9PXslLXaKL4xotjEzcsiccJ+WERi44jOkUYzCpz7cR1aNkzTEADWOlSbRiC5ykNU1dkVPVDJtAB3i06giDsCKUBrOAnuJuwD+jHtwb/m8+ma3XmULd6eK2ydRAe5uOiKb2mmWxEdr30kAmJfzn234SYXF0hDW1HWnr1ERF8/ACvm68PCTTLeJFH8CdI5pZOsiMdqTZ2xqljtTW7cxC8rxmz2w7QRTIl3KA06lgRHnlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYaG9mCpHdaSAqGNzPGndXNZxWV9gxCPg2KmqGBrnMA=;
 b=MQUm5ixs7LUWdIzCth7TEN7rw0MmnAwjZ1+kQIo+FNrmZ3cWDeI6tqi0RGNnR65CUGvu1t3DXqgkdoE5pvXS21y+3N+BKAVCui8vB8wjWQOIDKK+45ei8EEVU2My04AdUlc8P/SUKD+ZNkQYvzr1+YDIowsCtdbfhUr3stmwmag=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 02:37:13 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 02:37:13 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/3] KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM
Date:   Tue, 11 May 2021 21:47:59 -0400
Message-Id: <20210512014759.55556-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 02:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd171759-a2e8-4b40-11a6-08d914eed9aa
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB44258660D6BF5720BA54165C81529@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IIFOBRoSufUZFu7sqsgXTmRUTbVPecYGkka4HOOxLONR2ttfkicWCDub+hfbg1KUxIMaEJ0d31mPFnxFMOe0+SN7Ocz9E5pY8JCsfvu8rfobRJfqG41dU/D5oEzTaGDL7+AFY0WwkfjKOHZX5PcBuSUKgXEm2u8c3Pshp0GMkQARk8ooEBN14zcJ51cSiVlN+WN5D2vDe/lCP8dgkOyU0vqQRS2utFiQLQRl9lsBZeZXs6mQ1xTmeCl1esdoxckMUfTHsAFDSwKSKgZJHB75LWEBjnCh0Fw6qCe4Z+lZdb7QmDbinvXJXsN5jhLLKvKmj1vl0ZBuoizVy+zlxP8mYnWQYJtI3u1FTC++Nw/hQOlVwzMublhPvzRtmSko0iN5f41I3tAz1izoe0M5UxOBaBjV8bDer9CpVrBdKBF3U3xuDh1d/QI9WJXVbIoMmgsmGseFWdVseiuf9rKh30YYQTQX0XScEuP8tLO9BMo2T0IPIrDOP1cRm2OdbpwdX5L/0zpBU0QHk1yyqtMbPffrYoElg4zOaQUTnm3y0tjdbfwPFVRPjeM17yjA7gM4bTfocODM3FQL5A4bdO1zI6UH6BzBkfSNKlJzBLD+cmx4moNfzXr76DF2roH37A+M/g10/PHIjsANj+9WCVZiiupNDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(66946007)(8936002)(66556008)(478600001)(6486002)(2906002)(1076003)(36756003)(5660300002)(83380400001)(186003)(16526019)(66476007)(316002)(86362001)(6666004)(52116002)(38100700002)(8676002)(26005)(4326008)(38350700002)(6916009)(2616005)(44832011)(7696005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JuiQRcgrk1r3okrDG/ORsEgsTKNl7F1PpAx9dRUrlmJxzr5ED934aLgccok5?=
 =?us-ascii?Q?xTd3yFDS5Ck/qzinKd5lvcbi8uAzTDVf1HfSRyku0w9HfQHZmWLAYRxju4mZ?=
 =?us-ascii?Q?WKF7/9AQOhVGgb/HzGiZK17AtfEs9NkdmP2D/4q7XoUfdaUmGEIg/4SakQQY?=
 =?us-ascii?Q?Re23Hk9Z2PWD70fmNVbjCjFM+/swhLF4EKS3I0V/pJYb7C9LtPGKkcL9pjGV?=
 =?us-ascii?Q?ZzQJ9ACwfNOSBFpik9/O308zLXlMwU6Q/luGIbFBghJxwaSzuhRuaKga4D7k?=
 =?us-ascii?Q?YAEydMr492aqRcheZ153tai/xQsH7H+YBjqQ4wwtXzd8smjUZEoaA+C4UAIf?=
 =?us-ascii?Q?Cr/vM27EyAJj0J56KugVYke4ZJ4PAp2tie649xcktLKp5iTl5DJM+LUuEGZf?=
 =?us-ascii?Q?iXvGdFkFx10QXlA/EQzGK+cKR2lJyij0EDeu2IcLeyXaE/ARz7lZ3Pw2R9to?=
 =?us-ascii?Q?VjDZLjsOnguczgW/iah+54J3SOkc2fMh+s/nCpRlqT7xPpXVFsOcCvBxA1+0?=
 =?us-ascii?Q?cNG//kYWXzhq2e7eEP4lzjTH0/k+s3yBt5wmk0+fcUnz5SpDf8NUxQ4rJTS5?=
 =?us-ascii?Q?9XFrbWL1LWrLRtB/YoKnIt6CE95tSHo8PuYIajizffwzygpl+6gZ+QCgESgj?=
 =?us-ascii?Q?gWgFWsYt2dwme5LsRERKnZINpm2w8YMU3YiPN1wRxsNR5zbFdr1aKsaEvOv3?=
 =?us-ascii?Q?d0fp7UMZ2QdTxpl2zMXMs623C33WIKw3mC/G6s/vwx1cNz/t1LlPQkeI5bAa?=
 =?us-ascii?Q?bBaq39cjTXcP1GkUxXiVPpeSeaDLEmYHMXnF2Q4FNQyPbOceOl1W3ofGqwBj?=
 =?us-ascii?Q?wtDtNYvN9TUE1sFWDhsf5vZiXmQw8QD0lu591VuI0EVu221Mfnw7U2mjjRO9?=
 =?us-ascii?Q?VHbwtfgjIyDFSsbECwIrcveOAtRfPh3mrcXkPRZk4Swcer+51jTvxZbCQlss?=
 =?us-ascii?Q?XfSWv2IYSLfYzcBZiIeORruTkjOCip1/NLQB0aINH/svlKfkxXcUIFwEqh+e?=
 =?us-ascii?Q?oXJaNvNyvdjf44psiQfBCtBHj05Tb7BIf1SgjghA3QHoRqpleDPr/tWtVr5m?=
 =?us-ascii?Q?DzsFIwaRQ5uBlFcleuRRFkFdnoxgrogX9lRAgPy3LjHNMkMQDkNaMBTkGTay?=
 =?us-ascii?Q?eSJYZqXZUCbwg0aDLjp44AYiVpG24MHe5CsXF6ybAQ4OptNZwZfznsKrssOc?=
 =?us-ascii?Q?9KCLokK/S3K5USRM9IwOcWU3szm4G2++sJ9vwAsvyAOEDZqYzcsre1sNMOsQ?=
 =?us-ascii?Q?Af4cSIAsga1QqtCp9A6muk5ILZANKT+MEzs+07NvPCLphd1zj10Y4o/tei5q?=
 =?us-ascii?Q?o3hjBNEvsBiwFAsmC+2pE6ba?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd171759-a2e8-4b40-11a6-08d914eed9aa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:37:13.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1MwvIfu5pLWg9No+vRdJG1PD+n5mk3vjZzBIlyYn8kiKfr92KRCRqJ2byndF3uo5gyo4kWquXO3qQwXYE8wCiyVzhl9+sHd0qXGq1HRjfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
X-Proofpoint-GUID: Z6fANM9MX-S2ULKsS3V3EoxrhxAeRmVZ
X-Proofpoint-ORIG-GUID: Z6fANM9MX-S2ULKsS3V3EoxrhxAeRmVZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm' already has a member for counting the number of VCPUs created
for a given VM. Add this as a new VM statistic to KVM debugfs.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 1 +
 virt/kvm/kvm_main.c             | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 884f6e5ba669..4a3e3c04ef38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
 	ulong lpages;
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
+	u64 created_vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01805b68dc9b..0c2a57e1e096 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("largepages", lpages, .mode = 0444),
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
+	VM_STAT("created_vcpus", created_vcpus),
 	{ NULL }
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..ac8f02d8a051 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+	kvm->stat.created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
@@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
+	kvm->stat.created_vcpus--;
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
2.27.0

