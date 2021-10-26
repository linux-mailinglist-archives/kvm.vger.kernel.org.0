Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA8043B74B
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhJZQib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:31 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:3467 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234592AbhJZQia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:30 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFdZXT007385;
        Tue, 26 Oct 2021 09:36:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=a02LuyZCww6Sfj5369UUExoreHw6oOjvJNjfTPS8D4o=;
 b=muyu1vNvznT0zZiC/aIzZwvzbsbthRDUarapykKR87pHpZqdj7KgoIScITPHiil16jYz
 XBvpfi29g0XxQQHEkR0OVe2YP9iYHGMeTM+LhfEKP0T+RADe76NU3LaHpEaKGEePLLX7
 8XUaZIXQuwqGTQADwZR1zsfzN4Ya8IbvFr6XnmdGgGFVfE/tsdJQVr8IGF7l2H2NdMUT
 QTspBYOQoaJxaseTSqnXSgmfN6fGdQgUhXkfRQCGAhy8Kk0l5w31+5hBrktsTbElnayT
 iTCP6LkpB+tEBzm8oIysI8h+zf+IssBUDAk+wPs5zEuB1/2vv1wpv9Sv7chSexn9gm/M 1w== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4dwhvbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n82KxiKZKCzk3w7aikeI+TfJR6NRX+giyS/10RHevzXnjWdTCmKz06KlQFg2TyVoSeWOfmvvRHcgO7dWk578OZec+vHtY3v8GO1BHJn/pEXwxWQjdJXJ038W+4SgR9dDM9bnxqrPAkHZdPpgBfw7jkeeAkQA+wF3VnD5FzaLggujM5UirKtj0tORffkHkIMqqaH05xaA2c51wtG53lYNx+6sBIGDMn9cStxrcOym5QsncRNPfgtVt0F02utJhw+cd/dl9umyMfTXl4gNMEngLlm7QYmbo3ebW/AYMFY+n6nrEYZzRNvEQBKENZMtM99YnLVqub7J4YizbdmFJrJxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a02LuyZCww6Sfj5369UUExoreHw6oOjvJNjfTPS8D4o=;
 b=dqgHYJN4ZVLtE3xkoTnZGBLU5XVY3arI0EcojOyPf4UKrl5RR6YzjnQbDSpKcd7xh/fTw/R4ePYzdLx8qosPlDD+fi0WS8i+BWOtoWj2OVM7w3iuhK4LL8PvTWGXbn6GeamH6paCdyB/7UOobKP/QYW7VVgyKhG1R+ri/Ct6yS6MznkcZT/HMeDprafs+zHWspybXeQc2um9haBL0VC8Caa8dRdZt63jkrnUO9Em/Xbxjfqv96Fks7dqWtAUyux24n4gO6AhKOAc7Ois/lHa6ywP46gMRaWu3ijIzltBV+wdhkoMEj8qV/aVomnjlVN6qzRMqodjU5F8/NBkDbkudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:35:54 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:35:53 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH 0/6] KVM: Dirty Quota-Based VM Live Migration Auto-Converge
Date:   Tue, 26 Oct 2021 16:35:05 +0000
Message-Id: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:35:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27519525-7175-488e-b896-08d9989eadaa
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772823B75889F87A5653C14B3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jML5ap5hn2kbgBr/v23raU4aPMfJEw8c1eDMm7sWvbeQFOFo+K7XAMKnNSIst/pJlRhmwcIZq80DlrV6v3AUJWkh9E1movUV1wM3zjDDLvH0OZfj4h+1OoLkAcOA5uo+W+6jgrzUTleFnUVf49SRM6wjGohUUUg8LH1exE/MoEgkAfsX3c5Xg9vNPowgGVBmo+5xwS3VfdyfkETZDxwXfZftvC87AlOaPWpmlcM9f0TtIa4kHW3FG8GXUh4meu4v8549EYcRPIKOxwRTHy2c/OrWYbXQm42dYafKIM2bYLHIT8yjU9c12zlcVVEeH/6dfsnUPvgRDrXB/Ygrmqdo7U6G48Lg8buU0QnANA1Fa3mz28MiHTfXSQeZECFy9Q3ipk0qZZRxCs37kzaiBt23BROZxepCifottYZnk68SNxzTitZdi06YhBYOLkKjCNrwZKZ9A9PAkRDb5wWbJJ3IAm6t+gQ4w4gBNtPpFSmrH7dfOnpWeWar0YrAfuhqaqvd5aEdimsdGuV3AtCUwEZ7XQvL+Ef6zQ+zCW7FzhjUig1xh0EUrhVXdghYt0Tex9vOSaN+AFnTEop938U8dnD1MKtZ6c8icu9VvbacHJow8BBOwMtxvCTw0NPSS4mZlabayDUIwYfJuzRyK+cjaYN8+F7Q1UzL8iVFrRdbi+zbJmNeVcXmVK/VCjpGiqIRuKnKyT/In+iLDiZxLbG+3ECxmztAKEydTJUtEqyYmlnY/ysr0kjjlHoREI+3nyaVFescX293pVWggDpXGZs2A8r9GjtiJav79DlYg2xtw/BzgWvlcwlEVMFnilrM10Yx87SVRRx9pjz1IIAwoMKMDK3RlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(966005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(6666004)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(590914001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?170GSggo1Wze/NAQLqfEEsuVLeBMNr3EDs07nCFoCVJdYhTVNfAIskP6FgMi?=
 =?us-ascii?Q?HGwocpTk8h+zvkWgS0VagVa+B+dKy/yQ9w5nfoA+ZPYGf0DTnTkusgopNPjF?=
 =?us-ascii?Q?dxbZOKiNNtPj/7g2HqEEYy1NiOhi8ubcM1zEtppOA9r14DRPMxYhT9a+y97n?=
 =?us-ascii?Q?qmm6nyTBFheFey/OdwH1ixSH7QhULefL39WULqncXZM7Wbq8/R2tVuBmV2I7?=
 =?us-ascii?Q?DkgiBic+uUhxNRgk5QjMHXdPapfyK4XPzqQ0UL+c0F+5Vrj9HBWThUHa9Cib?=
 =?us-ascii?Q?SP1ejq7eXAKb/dVZemXaz5C9+3IS8Sr+sO5QsNAt5ixm0Vx+/YIi0xWvrm5y?=
 =?us-ascii?Q?xzpqgnxj15sHlHPvMY9WmrCI3/cwSj7LcCVorcI0OM9ml0Xmvjjc6mU7272q?=
 =?us-ascii?Q?tsAoGI/689daHE5QSuVagGb8iP+z4pYniUBK3P6mnjyeOsWCcmeNct2Bminc?=
 =?us-ascii?Q?sVkHnnm6OTqxKYLHZYOkn9vFstl6WUkhXs3JhZCpl2/WZ6hJD0wgiaMBFzkn?=
 =?us-ascii?Q?cnxv/kpxuVtzbRTy9iDqwWHjrfLKLq4RQ0F4FDdRF1BKzCL6cR8XIxuV9FJJ?=
 =?us-ascii?Q?iYZboJyNvcGlAhiZvKVtuFZzKJs56EuPAmy+8YkIjzV+nkAGRmqDu4GRKob6?=
 =?us-ascii?Q?K/Tr5Uj/6FpMTjkzBlqG0c5bd3AoiYFh5yG64yLfth2KFDtmeyV1f2ieHIUU?=
 =?us-ascii?Q?LrWRq035AYIAyIupLDMaPGxKWLr/felVRVo+cYvspkht+NKpxorDRu9xtxAd?=
 =?us-ascii?Q?/3jhWvv387mZibIrOiZBqK3QYsVcbHh8X8qTk/Re1N7OEupSrz+pxTtU0/5z?=
 =?us-ascii?Q?vJmG7wd+JqCU709mJ2GVCNwXq1LVWDz3BK6Fb2MJePzuCsVOl2SxlryvsSsH?=
 =?us-ascii?Q?X8f4qyGBRr94AJYLBVt8k9jpP4xIV1xciN4sLWUt4v/cQsELS97avilp2lSM?=
 =?us-ascii?Q?U4WivNiHMPSpnMCvY6T6Nzmy36XtljhSbK8w6yNtRuNK6xvdFcijxnslzn04?=
 =?us-ascii?Q?Z/+QECeFwTCX7HqhM0HscHB8WZyN5y9tXNTWJSQMm8JB3mUEcS6dXLbLPUzB?=
 =?us-ascii?Q?8KyywU3iaW0Y9b24IA/Nx+JJpJy4Q6ZTgXGUzw1Wcd4ImMVt8tMnyXfVLUoK?=
 =?us-ascii?Q?+AfNB4Pgt1p0O1kaUtQmkpaPePzZLIWtgJUGljGpahp18gti3kemOdP0oJe6?=
 =?us-ascii?Q?s4FMemPPJsxGMkjRTu+n5nm+cso0LjwXRA1UG1MyXufIyNkq1gfGrGKI2boB?=
 =?us-ascii?Q?nrlLlrn9LyqZ0URRqow1yxPbWjnwApsavr3g1zPysGja0VIaOxuIi1z1r7gW?=
 =?us-ascii?Q?F9/uihnGHK2DHk0h1PT0IrK1TiwsKIx+mFec0oUjEfivNmlK+eqkWSEC/BM3?=
 =?us-ascii?Q?75y2TV3F5siMHGdfHUma2bzZ7mudhPl7SwRuFEoI9efQ2RZaxezqEMrkL/ww?=
 =?us-ascii?Q?eue5qRrSByoLwqjiTGTkfXRtLRLGRkLfYjgSERH1eEub2oe8LvLqIi6+Y6zx?=
 =?us-ascii?Q?HeSVZEF7NVL8ThiOCZKvDFy6RF3wJ97UGfaxlPB5CMkgCohBzh9wZK7KbFXn?=
 =?us-ascii?Q?Ujxj91pRPXn5I478xdx9GOlUY3+/be6Di1wOQLFuUlfYpxy84G64JkF0UWKG?=
 =?us-ascii?Q?BQdY2DOrRQe2yEyYzLP1GVjivVPIt3+BNM4MqSfhh9wVXTBanai6EOe9MMtp?=
 =?us-ascii?Q?X81rS/wfmZeTyg8NZ2DsYB0UfSU=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27519525-7175-488e-b896-08d9989eadaa
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:35:53.6961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCCmLUZqJ8spik2mTLyzNpgTjZqg2sm50yeUQW0FGC49tRtT7vvAwr7zipTPbp9RS+XyLRtLpf86TKmf6XDgpNI1JQxSZmffc8p5wfs62x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-GUID: JzAg8LiRcglcj354uhHjaUiK2eOJim2e
X-Proofpoint-ORIG-GUID: JzAg8LiRcglcj354uhHjaUiK2eOJim2e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is the KVM-side implementation of a (new) dirty
"quota" based throttling algorithm that selectively throttles vCPUs
based on their individual contribution to overall memory dirtying and also
dynamically adapts the throttle based on the available network bandwidth.

Overview
--------
--------

To throttle memory dirtying, we propose to set a limit on the number of
pages a vCPU can dirty in given fixed microscopic size time intervals. This
limit depends on the network throughput calculated over the last few
intervals so as to throttle the vCPUs based on available network bandwidth.
We are referring to this limit as the "dirty quota" of a vCPU and
the fixed size intervals as the "dirty quota intervals". 

One possible approach to distributing the overall scope of dirtying for a
dirty quota interval is to equally distribute it among all the vCPUs. This
approach to the distribution doesn't make sense if the distribution of
workloads among vCPUs is skewed. So, to counter such skewed cases, we
propose that if any vCPU doesn't need its quota for any given dirty
quota interval, we add this quota to a common pool. This common pool (or
"common quota") can be consumed on a first come first serve basis
by all vCPUs in the upcoming dirty quota intervals.


Design
------
------

Initialization

vCPUDirtyQuotaContext keeps the dirty quota context for each vCPU. It keeps
the number of pages the vCPU has dirtied (dirty_counter) in the ongoing
dirty quota interval and the maximum number of dirties allowed for the vCPU
(dirty_quota) in the ongoing dirty quota interval.

struct vCPUDirtyQuotaContext {
	u64 dirty_counter;
	u64 dirty_quota;
};

The flag dirty_quota_migration_enabled determines whether dirty quota-based
throttling is enabled for an ongoing migration or not.


Handling page dirtying

When the guest tries to dirty a page, it leads to a vmexit as each page is
write-protected. In the vmexit path, we increment the dirty_counter for the
corresponding vCPU. Then, we check if the vCPU has exceeded its quota. If
yes, we exit to userspace with a new exit reason KVM_EXIT_DIRTY_QUOTA_FULL.
This "quota full" event is further handled on the userspace side. 


Please find the KVM Forum presentation on dirty quota-based throttling
here: https://www.youtube.com/watch?v=ZBkkJf78zFA

Shivam Kumar (6):
  Define data structures needed for dirty quota migration.
  Allocate memory for dirty quota context and initialize dirty quota
    migration flag.
  Add dirty quota migration capability and handle vCPU page fault for
    dirty quota context.
  Increment dirty counter for vmexit due to page write fault.
  Exit to userspace when dirty quota is full.
  Free space allocated for the vCPU's dirty quota context upon destroy.

 arch/x86/kvm/Makefile                 |  3 ++-
 arch/x86/kvm/x86.c                    |  9 ++++++++
 include/linux/dirty_quota_migration.h | 21 ++++++++++++++++++
 include/linux/kvm_host.h              |  3 +++
 include/uapi/linux/kvm.h              |  2 ++
 virt/kvm/dirty_quota_migration.c      | 31 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                   | 32 ++++++++++++++++++++++++++-
 7 files changed, 99 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/dirty_quota_migration.h
 create mode 100644 virt/kvm/dirty_quota_migration.c

-- 
2.22.3

