Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEB93A1D3B
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFIS4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:56:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34649 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhFIS4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:56:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159Iov2O057788;
        Wed, 9 Jun 2021 18:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Vjf6Kon3HdepZqNtIIO5Od1KCyPFHeiQaupkeJIzQ78=;
 b=hflk3XEMB5QoJub0Dfh6fTYe9GiVLhL0aPoaWQ/+0NkJmkUYLWxfPW0AWCU4ZAzCgkYJ
 +5LHR+3nIB9woyX+o9wW8/vYWnBb2hurYCQExx2yfbfpq5bxS+l3P0VEPDcRDl4YSyMe
 UNekZRML4+KNFxC61KWBYT91Ano+3v0Ti35m+KnnEwQ/LGE2uVdSUB/AeJLlOMRQCKsI
 SOKYaetVCmXwOnua/mGWOXoRZ30NinV6ylb1/dPLvWpMCwcl5NuMJduEBD3NUPi7smP/
 mJdhbbWv13RP6aZ9/0Sh92HS4eXBJnKiW2bWoAHrnBK+i9AtWK/clc3dTJIjJQnaW5GH FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qurga4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159Ip6AS146254;
        Wed, 9 Jun 2021 18:53:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3020.oracle.com with ESMTP id 390k1s714d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9ktenZtLSjfRjq8I4TDRYRTOuV6VP6OsIT97LAhhYeeYzs/p1ueOA9+0MLNqiHiDLAfxWpY4kKnrtvWBntLTPp8MrFVJnhfvpivAy5rQ84FEtUOpoOUV3acs70uuGGdGWBRTj2H8iWEX7uMOsgQEsAMcQCcoPG0UQhBasyAsDZMgj8zkdUu7iOv1fCe1tbKJB6Y+NQlRpABlbsruqEhETCbkV7I/d4fh83TZ9WQICzb5U7sa7X3masTlPXKQm9tlCvbwFW2V+jHETEeRuvugW4DiQPvp/pP7FlgiWmIWYFalpkIwKnMOjDCybVKghqSC5KkrugYG0ULrKsEX6nLFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vjf6Kon3HdepZqNtIIO5Od1KCyPFHeiQaupkeJIzQ78=;
 b=TZ/34/w4JCWGY94BobYVJv/zqfDWd7xdmrZ0omJMi2WwISf6PHyFZH8/+bwKlGH3OLIXMbUy3kIoGE750tuLsBm/lip59FhqOBwjtS0XXYgv5+NAef9tmv5mC3mo1KOaATsnBLPyuc+4dHtXNyE7wuK/CZxrncaagNQ4Pj97nArFTWJjcoIqhLhAIR471peFNOE+G80It/776w0gb2ATebexG6EkRyBSYn4BnLFlYZ77Bb0fSwgaigw3Em/mHoFW7DBcsCDQKFoh2ELVjtjuKhkjVOQ8o294kpPHBhAzLl1eaUYteTLZ/4PoZmkUICcwj8NGTglVOXq67/5Max5lXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vjf6Kon3HdepZqNtIIO5Od1KCyPFHeiQaupkeJIzQ78=;
 b=yDepuiZyFuyIsFUz7OHwE+iIpJ8BGt/62BSm3Flvcy3JI3Yd59S3T/G8Vquw/7sPcpAHEZMWRf01Gl8LQW0sNjDAuCa9EYaoMekPq0gEtEOtDmau0qTpgF5MqqOwQcegBjQ2uthEJaZAsyUQBVOtfBo2HpW6LWQNr9ypz1z9b9w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:53:09 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:53:09 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/3 v4] KVM: nVMX: nSVM: Add more statistics to KVM debugfs
Date:   Wed,  9 Jun 2021 14:03:37 -0400
Message-Id: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:a03:117::32) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR08CA0055.namprd08.prod.outlook.com (2603:10b6:a03:117::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 18:53:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5d81273-d5ed-4510-14c3-08d92b77d311
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2510DFEA98142BB7DE73CF2081369@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLwD1qFIgObLOFOgQ9bZxy8yqYDA5SKDqxdgsd9f4OZBfna3P+pyocD57PmOwuDERf7w++ZhTjsWfL7ZHjP79YJAf+6MRmnO/k13xzVBlN4KOXI1HW2FnQEPft3gPWXw/JIp1jhF0D0sC0spQjiB/RIcStD6clIzuYf/P4FKp768mwD/Y98F5oY6j7QSOizFvTN/CE88jfo3GJ9DzxspnPSJUPUXcYx7zs3ubKCWJXi1lo2Q4/ypWrNq363wUYTIQCfpWUpr2wGTX56tgCHYLy+WpvAdAlXEtGFG2gibUJsG3vp2u05t+8twP0YbGJ8UBIuWHMkRBeDzKbcMBXtt4up6T5ksLGwu/V2wmgW6mPzBnFs+sJbkH1qGVnyYNjw5HKAt/HUHqs00Dfv2VN7kzcE/mDKv7K1nfPRTqZmf46qO4Iepy+4y69mEeoFCuoosBSNt+S6OgE8qgreXtSL4i87LPbn12UVA89NoQgDtBNpyrnuEPx9c0DezQD+FviI49RCQ6vgM83VQiJJK+ww5Ect7jS7+gbEEw86o0B2E58lyh5/wi5xO1ePpMxIe/lulO++1SQpIF90cUXxLUoVZivrQHU+J5lDEvznONp0FAvIt5XIQuanUhjO12wmrUgi5sqs4z+whOjv8CfR5e9Qeew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(52116002)(2906002)(6486002)(8936002)(36756003)(7696005)(38100700002)(38350700002)(8676002)(4326008)(956004)(1076003)(16526019)(26005)(186003)(2616005)(478600001)(316002)(66476007)(66556008)(6666004)(86362001)(66946007)(44832011)(83380400001)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2P2owHhGTX2sYvioVo4fTCtgXhZk+z9eopJh3X9aJlVfB70KKwte6rBQeqAz?=
 =?us-ascii?Q?bMUIlOJLdEPUPgXTzMu0PVJHQ6HTmr1MTIQhUzLHoDKN8NY8EuQT1EZvfsiH?=
 =?us-ascii?Q?AueH83SsEcVFvz1zz5EC4xj2KqF71BmKGZ1kDmwImVgyeDa57JWCVCOhfaxT?=
 =?us-ascii?Q?nvP1f1kx8oC0FZ4tKuPLyy7W6RaLfY+HrGY/jh40AFYZSv3v+i0Wur5iGOqx?=
 =?us-ascii?Q?1UxVmCrsyyZ9nRvPZ4V3sVWGxDH9hwOsoNGWG/1gvyavcCLn0CMlPbtf7c2D?=
 =?us-ascii?Q?zU/cAGV7ALI6ebQntEbGx4F6Jl47/ImfGMDPfClVrXGIfqm5qAy8VvaSyKfv?=
 =?us-ascii?Q?3355FYvKn+dq6iIRCqkSYaMRC6Gl0BHBR+70Xqc+J6RdUukHYRQkgAy8AlC1?=
 =?us-ascii?Q?scnw2qjFZ+to54JWoZ3BiizaguCnINV8XClzhhKoiluwPfXhxlRKNLBRASKN?=
 =?us-ascii?Q?qn5hj1xwBlGwiUi2vyXsB4WIgPycyo7y63oVzIaRIyDKAshr7Wg7UXhS8MyY?=
 =?us-ascii?Q?HFZqePtX7yBivBHAzDbla/rkaxJN5QqFSgkYgwZoGo/aeyuSStoO+plSMdnf?=
 =?us-ascii?Q?szcu1cKETNgzJsFRj39hhxsjX8clN4u4qpJxDrfWyF7t/JkfLnjCAxEJuKue?=
 =?us-ascii?Q?EW8H15+/A7hpBZ8OM+hWsGXzBP9zMUMa8VdV48xCjjPVp9CJCsIsNGyJh2On?=
 =?us-ascii?Q?wvjldFYK72W6+OZXSX3RjGKdDGbv0EOhua2Ji7h1BnTgDpZGljdb8JIVfMPa?=
 =?us-ascii?Q?jhFOxVaZgHUMezJv9Q9kX5gzzTMPfIMkGdD8TzhIzKHJIWLwwEGcN1i0+sZL?=
 =?us-ascii?Q?YZ+5mFAVivVdzT0mVJYS+DZMUWJzkhH9cJNqAet4Uluo5F95EeT9mtSGeZW0?=
 =?us-ascii?Q?PVW1hewH35pM6Yss9EOLOUjde87Gg6ahwX7u97cY7KzkuySEf88bSRdzKBMX?=
 =?us-ascii?Q?yiBkuvUM6GginljC3NEillA7c3KZVfZe5/Bxzr1UrIt3Urt/PaForZAWLDN8?=
 =?us-ascii?Q?03RaGKs1yU2AqHuIhm3D6G9AW3DipaczUzCDL7qiIm3RIK117cxryxafkBRn?=
 =?us-ascii?Q?ZuirQAc9rf6PiSEW464HCPZQQu7vPtpeaRMWxKjv/8CYnBtHcE/kggDjY5x7?=
 =?us-ascii?Q?sias8GypRJRy9JgISNg1rc+8HWz/VI1/y3z20wCUpu9zicgu1guKxyRJB7up?=
 =?us-ascii?Q?ppUDVYqhA7XSYwn2L2tfRvW87Hi7Dgv2U8XNQW2Ut2FTKHaH/aG+U5ifWfLR?=
 =?us-ascii?Q?ZL93xESKMJAeK6JMdhUPehwW1Q5C228N9iwoWfXCO/u+OtQwViZGza8vbxpn?=
 =?us-ascii?Q?eV/2dDC1IdPsm+dA/mG4/cCf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d81273-d5ed-4510-14c3-08d92b77d311
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:53:09.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znt5R3DtbfCv28T/urdFOQTLl06UQQaxtMIH6GIgRoxmRveSklImkmc9fvcLlWvKuo7M1Tzj3hcJryPHb2uDlX15Q2EIW6tyepMi6/9fJSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=649 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
X-Proofpoint-ORIG-GUID: WZUSyHdCDZNQS7qOl1xuWWTfNbkJdcU1
X-Proofpoint-GUID: WZUSyHdCDZNQS7qOl1xuWWTfNbkJdcU1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=827 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	Made changes to patch# 3 to prevent the following compilation
	error reported by kernel test robot:

   	  arch/s390/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vm_ioctl_create_vcpu':
	  >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:3321:11: error: 'struct kvm_vm_stat' has no member named 'vcpus'
   	  3321 |  kvm->stat.vcpus++;
               |           ^
	  arch/s390/kvm/../../../virt/kvm/kvm_main.c:3398:11: error: 'struct kvm_vm_stat' has no member named 'vcpus'
	  3398 |  kvm->stat.vcpus--;
               |           ^



[PATCH 1/3 v4] KVM: nVMX: nSVM: 'nested_run' should count guest-entry
[PATCH 2/3 v4] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU
[PATCH 3/3 v4] KVM: x86: Add a new VM statistic to show number of VCPUs

 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  3 +++
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  6 ++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              |  4 +++-
 virt/kvm/kvm_main.c             |  6 ++++++
 9 files changed, 44 insertions(+), 7 deletions(-)

Krish Sadhukhan (3):
      KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
      KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
      KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM

