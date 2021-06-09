Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41C53A09CD
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhFICMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:12:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhFICMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:12:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1591mVho166471;
        Wed, 9 Jun 2021 02:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=S5olhzKmMotylBipaseeLMQqmsffbGp1YEJKKuaJR98=;
 b=uFyEMUAxowym0sLu45jnulULxpRemq+eyLTz2jppL9oOwPZQGmLmA7Zq02uhMHwHoTUl
 a768O8BLUG3Bjatdg3YXjECMu3bgIMujsQFhOZ5xb3KnEs0i2PilLzEx52T6RBH5pIou
 WGX2N7s8WNq/Jh2VNR25dNpp+vFSGfE7KiloUjB0KvzHQ2a7p5rCPAGCUQy/Lxsb8uEo
 0AcnUzD0sWFttBVFZ79yXiboy4XoshyVY0lAgGrCrdHr/nwE3TLNS9LMQ0cyrId0iwZb
 jSw8viGCBNZqEKsS4avFcEOA6TSJ7hDM1+yBe5Ls2Q/W3W5k1GF6IhujbvLtoN+zR3at dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017nfn2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590aNee129748;
        Wed, 9 Jun 2021 02:09:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3030.oracle.com with ESMTP id 38yxcv89ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bh2nSfJs+gu1hAsBQXdpw1VqN+HBl7ENMXTXKvO0xPGE+n4yws5WhQP6kh5bPXsLk2zYwdWUqK10N5+tCBE3gDk7ziKKy13WPCizPUQtYxtMEhjPoDZPcUnBMpxb2Wr/X17iIE3eYnFyoCLJagLWtUhG7dtVpVzmycgWxh5epsSAxNs1arkxPVKIUPwUnUz3GmoV2ElIYYP50ydyQhInGTDtHAnhb4jHUqlSWzIF0SYQIIVuyVhcwVsRzUD4zf41XvyjDhN5CxExCH6tgG7usxfKLYo/x23gk9yapyKF4FNV8L0W153p87yEtPp8YXuW9NS3QBK11tvrcZ692ldbcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5olhzKmMotylBipaseeLMQqmsffbGp1YEJKKuaJR98=;
 b=DKVF7buYI/oRXNU5Xpkiv9yi9TT9SQDFHV1AcNonacChugybN4Va2NC8Thx537REHIh0g9m0ubrpQ6Lr7sn/IS4vQbx+VSGpe+BuKI4wh64svaTi4AlPbO4klDrb4xa0YoE8PKx6NcwKDym8qeHWCiDLf/dENKqvfGG/FGjsKJoxuTdbC3/7PJPWHfvrIiVJ3yr27XH/JpXfJrhY5AH8ojWLENWiBRs83IFAO8quQPwvBZWfiLM55HgZhxFKx7LyBnPn3MOQPcTlQmQ464d/qRgijRH3zmNa+3A+ROFqxwAc25ZwdxCUfAP31VGxKJBLxc9ha7R7r4ZBxEFeKprV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5olhzKmMotylBipaseeLMQqmsffbGp1YEJKKuaJR98=;
 b=M6pP4bmdiZWtHyrGNpVO+GI2kPizPHCYE3K0Dl/WGQRnjDumCQj8ytzGx20YCG9/sguo9lynEN6oYYSi53HO9MVFanjMoDHHa2Vhcn6plTBV5mnWxPlMhcopYiHkUAF3Gh8O7L1rDyoMCi+YvGv7hay/3zmz2a0OxZp1YL1oeAA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 02:09:08 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 02:09:08 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 3/3 v3] KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM
Date:   Tue,  8 Jun 2021 21:19:35 -0400
Message-Id: <20210609011935.103017-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
References: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 02:09:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2be4e77-08ce-40f9-cff9-08d92aeb9092
X-MS-TrafficTypeDiagnostic: SA2PR10MB4524:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4524D47784CE3B1FDE9AE3F181369@SA2PR10MB4524.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KkNQbMhwuuHje57jhDeyhB15ILOAVAOOR82CS1efpJdx7hSAnx/WlPSWgvkZpCz89TzszQf1JVmEUYzEdZLQOh/4DfYDrzWVo2rAGUt9VE86vpwqKfTM4HukUWteR38fn9nN9QIoBQTN63wD+mZhymQ9SZnzmZiPJogVV+ORImxVj6To4UWNhq97SQgnie1pSjXOHtK0CRqHAr4S4EbnjQ62VhTJv1HYwFJcdTnIXUgGHP0PV72vYYAtJsrMYv7v1cB5O10a/oDIQXbYE3yqRaYXFrh1mQ+EdZTwrRaTwRx39zgTYlE38rLklBRAd4egM9aU1NxG0VCzY+IYuDwlD1yEWkaOT2SWTVHslmbg800sOlbQUUHfcE2XlOD9sZsC5yoQxEXJq7IejVJlBcFD2RdV36x3KLj6pULENTigPmNbawjw6h9P5SGwpAag21lR4PwToFsOJBgSmELmQd0UgaWBfxXYSOJkA3gGRf1gVerPysY87yxowJOBJ1st0cogLe+dgn4rV3dTVJVqMuUOHv4Lm2Mc7U8haHQ52skT48BqA3gSRvUpNdyS8wJS2zw2Nkk98x3d+7Gu0f5x3uq//VzCIAi/OkBBi+BbjqmNSR6i/GEO8QalnkpYOPvYBTz4qBTDKMoSmKPyMJ9S/oKlvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(52116002)(38350700002)(16526019)(186003)(83380400001)(38100700002)(7696005)(478600001)(44832011)(1076003)(5660300002)(86362001)(66946007)(4326008)(36756003)(26005)(2616005)(66476007)(956004)(66556008)(8936002)(2906002)(6916009)(316002)(8676002)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHihGHT/gD/3SnRzUQqroh3yAsvoqY1IYqRwfRzxMxSj5WuEi1afzfbUiNoz?=
 =?us-ascii?Q?+3ErdjbYwpjqRaGNQLVgDU7ac0um/5LcMuuf+kgdjx6qMAXwQj4sP+PLd6hr?=
 =?us-ascii?Q?zcewCIPnPBmPIe4m3CCXaLmpVtzQde10BmLcYWNscNHNQR0EKEer6qX9LAUQ?=
 =?us-ascii?Q?sCShU33jnW3PMGLKb8QJ009EwlhmDQQYGQpxPNJbqTxqVCXNsfBi2DiI9dDU?=
 =?us-ascii?Q?HOV3ks6ROdcnlluW+9soDaD7fPC/wklaRahQ3v/f8nbSdhySHWAkKzjox2e7?=
 =?us-ascii?Q?INMCAHGJBiIj+XRdPyGGovqt+1MNx5ckY/SFk+ulFiyzLcXBkH0CZ0C26kjf?=
 =?us-ascii?Q?PpecpVt271Idp/9iqa6F8sy7JOqsKEYv0oerefQ2CZImcWL6qRXx2ZR6hjFW?=
 =?us-ascii?Q?qzdJ8ORlmgLq5nrBQNYMnVfQPk5MAmoOijE/9ObicHGj3qED3GGxiN9IQ0g6?=
 =?us-ascii?Q?0qJQCY0acs8BwUlbOlzMYYGoZ4m5UBkxnj+XyeG283QV2hLaQ0K1nUmPr14x?=
 =?us-ascii?Q?Nr+WqipHLWQjYAq0U1jHZYhOadMVrvSwbbEgNcigM8XzXkxZqbwfeVlwMvnv?=
 =?us-ascii?Q?mffu7Jshiubq3bbUr2LVoaATskGgyyTrKWdAjOVtTuA2mtV81dmu9givrgNf?=
 =?us-ascii?Q?M7m40KB9x/wffDNt9Mhm9xSxVokkRfeYKSWtRLSVtzb3ziocjytXoOToJ/R5?=
 =?us-ascii?Q?cJFxtDQ4ZwRXZVL1LnOu2a5yRFL9KJdD4husQy++tpR1Tysg+MCPAy2KUPz1?=
 =?us-ascii?Q?JD8WYq1NPqb2ENIQobG7zUoS+Ba9WP7oVi9OZmVbhSCj9NWsLNcxpVqjXoN6?=
 =?us-ascii?Q?6xsKzwHscPR7PheApzUUEo/1JtcpyGjCkBa2wonkXTPKUr1XNZ3bf+5MqyLX?=
 =?us-ascii?Q?3Y32hxw4sJRX1jA+98UsG1UfOdJUreOFIYAG81x5fe+/eDPwBvJqV2UVblHU?=
 =?us-ascii?Q?l19k5k/LcmUXNr9v/WYmIwX1O+4ZZCpVQ9InKXZXf0gi6AgFn7+mWwtR5mVp?=
 =?us-ascii?Q?yPO+jMQAQBgifCZlyhPxNDs6FP0y74iKbgRNf6YL8or0RxW1TLH9m2yCQ7Ey?=
 =?us-ascii?Q?HDey/ezPmYzyHVqe0ZCREz2RRYTTUb+lrWNhORVA5M5L58naJaYP2o1YVPkn?=
 =?us-ascii?Q?f8mduQyb0U9MeKF230G29ZSjFraQ36HmleNmwFz3Ax5xdSOjr5Di0JzJ8AOq?=
 =?us-ascii?Q?PjPV1U1noRiyleioYNAPatlXHfQyOmL4nYSIpbgQkVAxh2ZXnZNAqo3F+aDc?=
 =?us-ascii?Q?/xU3CCJgyRyEMARWIwPSJSstUou+PBN7m6PyuK2DBtCFxZ2tqxpkhhCIQjTt?=
 =?us-ascii?Q?i+gh5yQcSTpSeBQgFtztWXtR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2be4e77-08ce-40f9-cff9-08d92aeb9092
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 02:09:08.2616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KE4ihuHEXX5PNIV4unPLJW2Uscis2a+nJBHuy79csHzao45L/rpUBulZY/AfLu0NUI6xcGsxjXD/1aVtSl+HxuB0PV4Bb2FF4Hfrjx4kDP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: isuF9flwOVHE7691mOpgUTquXwj5xtT3
X-Proofpoint-ORIG-GUID: isuF9flwOVHE7691mOpgUTquXwj5xtT3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm' already has a member for tracking the number of VCPUs created
in a given VM. Add this as a new VM statistic to KVM debugfs. This statistic
can be a useful metric to track the usage of VCPUs on a host running
customer VMs.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 1 +
 virt/kvm/kvm_main.c             | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f6d5387bb88f..8f61a3fc3d39 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
 	ulong lpages;
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
+	ulong vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index baa953757911..7a1ff3052488 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("largepages", lpages, .mode = 0444),
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
+	VM_STAT("vcpus", vcpus),
 	{ NULL }
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..d910e4020a43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+	kvm->stat.vcpus++;
 	mutex_unlock(&kvm->lock);
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
@@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
+	kvm->stat.vcpus--;
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
2.27.0

