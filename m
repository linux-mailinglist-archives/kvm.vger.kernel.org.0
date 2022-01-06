Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84D485D95
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbiAFAuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:50:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53792 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344061AbiAFAsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:16 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N5G8P009916;
        Thu, 6 Jan 2022 00:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=UFTfPBqMhfxwUs14W4I/lXe+Vd3zvFZlPmGM7cmJszc=;
 b=ODQ9lvkmW15AEmPpWyPoAY1xB8jOxd4To3AzW2b+MRtyQSBg4lvHEXB6PifP7YIoSn4W
 1xqy6jzBUKoeTsnzFPVT4CYB6Hdd3gnFU3xHw9954htH8Y+07SH5JqFK13bjZqJluRPQ
 v53S6aUYcQWNwz7dwZ0EmsK8d3dSxVikVXvFMA9IOkdEvemthQZR/iILL28tpbxIO/9G
 7WLdhSYZYS6cIrgjxWj44Hr/Gntgg1J4DISDcz71TgaDyRIZVxZuchi4ZKtSy4ePf8A+
 l6cqGfxDZYkff540KiMpUAqOPT6HISiZxcG3YHLOymRZP80IJSH4KaE+ikFaIWj1j0+Z Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp83uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VnfM086893;
        Thu, 6 Jan 2022 00:47:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3030.oracle.com with ESMTP id 3ddmqbvtbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBZzLil5gcKiw8g87ZC9jKksJggwVPmrMRvFusFQDRb9T95neTDy9pjiFO3Q2EqBG4avIKTtBRykloUqdjvVXCyJXV7LO/YvNGA8CTPL7xnWqI7dNBKgWsvpOaQaJFppZ+1A/5viqJ+x8kxvSfkYXKvNsG/2ZrLoxPHv+VJwxuyvOnwfXY/q+GIseg1ioW+PDGHBqa5IkEFk/gYFuaSexrKF7EmLEV+ChuaRQm4IuarNcA2aKapoCdnZL6IZ9o6AFQuRuiGA++pCw4XKNi5UXEO8tdX/caHwBtvYbmLEM5HsoAP2T7NAGzntWViCdXHz7msssNUclPDDP5x46pO5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFTfPBqMhfxwUs14W4I/lXe+Vd3zvFZlPmGM7cmJszc=;
 b=DxBFyTyBb+ghE7YbHNpbMc0DnBJPFDKemM3n48As9ndZTV0a3Vtz7F3zCD7f+q23Dor88xizKkKcjlPX7M+Mqj16u+v3Oyt41MjniodZY+1N7Iy64IFgB/eB1z5NUEHIeiSh/kxf8P63jICtJtbAmsBhjd221KSfyjXKVuTzq197024rtNx6koX8rIdDjYAjDSF46vtiuAQB/eylc1WT7ni3BXMvwK+RBij+fiLdstaXmw4E9aOHcjjGuyhhSA5lBgsVx/x/by5F0nhf1gr7/rZwMUeaegDzmTNA88jSZfRW5IrJUnjz7lLPfSlFk92PbI5cVskQ86uYM1CdiuRYOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFTfPBqMhfxwUs14W4I/lXe+Vd3zvFZlPmGM7cmJszc=;
 b=HLkWB5XCrjqFEP585oKCGTsth7MLp1+q3VSZmPd5vJHNvRnnJ+hOd9g1592YBMTxmruPbB/BFtB1KPY0mvfT2BHY9nBdwifDuPoMoNkeVP13XZlYmlWoVSQjWR8SxjTdEM7uL7G4FIsxj+6YHaciqpzSA9In6cFDi9xvWa0DEJE=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:48 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:48 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 13/16] padata: Run helper threads at MAX_NICE
Date:   Wed,  5 Jan 2022 19:46:53 -0500
Message-Id: <20220106004656.126790-14-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adbda2d3-5b34-4bcb-db85-08d9d0ae2948
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB442293137DC84D7F533DCC51D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6NfPhMcNMzhsdUD4PdRCyIJ3XrFM7jnTQxK3JctqNCduenVq4Vplxa/omnBsVO3veEr3wq/vcS69v+4dLQUiro0XH/mhPnZibkaUUE0D/u28aV6pQBYSAwy7QQ65qtMagAEdEG5W6gFWOFIAu9nxlyZff8HUexsNhmjnZREb42YALkgjJLiPOldPsoJmJJWWhXy+9yFk/qFFCyKQejnpr5cUR1So/MvKL2dIXkDOY1KU9DiY6/+NBgRn8LFb0ACG9Y2onacbwsrJrQ7hahH3HnnV3rmjXdSx2Sz9nugB9HuiKCdgTCaLLQ7MyBEgR/6KMVmMOwG6oXMQdN/3AA/CjF3egfoPM+D/hMHTPueguBC84dvj5d9zt8iHyDXK5Gro57NZVlWwmFrVahFoaZMpr5ZfJMIzGsvnGuPvcQMBn9CMYCE76AAU33QiCDwwdf+1Ztu3COdLI39LQb/zoLtuOYd+0GBzvl+49K9UH1F8p8oU/4wE2Rppgf3buvwNjhn2qe1N648ZriYU/SkOIUuK9BLg+faUb2EFWerA3ZkUcQKr720bkmohMz/qHVI1+KtIoqhHmW32A+ldcoV0D4kFmdnWWewSCns+QY0X6smRKhfJWjEHNsguyEZUUQSmhXKrS3SU1q2EaYcEyXkRzD6eNtroxRlSO0Rfs4owqLu5fdW8lXXa12o7unvf+qh9zTQ7Haeb2+xUBRgwjwg87+2eVzmuTwRiNCEUZwwdYfjH7trxIfnHsyiB/NF454TAF1QbJhK7Khr/jYW90w2S2XGM+adxGvfkngJLC2zwxHv1gcYkII7QaPGMxS1V8Nqe2pJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(84970400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZL7Ot7T98pxVEcnPQOSoI90FRFbeDedeRBmKR171NpGgxPZcxzhEyT2rWKth?=
 =?us-ascii?Q?064v/Z2u52Nei1lvlIH18xIubI3U740b2PmMb12rRwvGY5Cbg+aH+moxnj+e?=
 =?us-ascii?Q?NNdIOskU9Ki12SpWXOya16fUAG/T4+oa2WxUh9I3w7qDeKCIcPmKXU9vqFIi?=
 =?us-ascii?Q?HJ+smNBklirz4+iTXByhiSkMAvt86Ak7fMhszFJvU5ra78GsCVjqYbWv2HGq?=
 =?us-ascii?Q?xYQLupNvJB+w6pWUxUYFrJ+o6KH+mjdP8vIO/TlrYj7c4WNVFlo09yEnMohe?=
 =?us-ascii?Q?i+S6Nh2NfKjK6jR6rlTOnMPSD/R8ks0GSkTWhtWZ1qbg7FOCpKkfaAtiuOtc?=
 =?us-ascii?Q?YuFMOXiCFD0pSyAzbuSHGmVLTMOIRfvpUsEIElgCVuBQLTGs4lOfmpNLZuvG?=
 =?us-ascii?Q?CwA/ApaVe9qLa6HzIc2VqdgG9T7yVA5DYrP1WHzF43VBvEacxhA7QhII5e2M?=
 =?us-ascii?Q?ZjK2zXggHIJWJz/dl6wvXUGeBaYGoj0q+XB1zMAVOGvl4vDOyIsY1lY0jhKY?=
 =?us-ascii?Q?4vK6cwTtTNTHxVc2yirYAflGkxqi8zW9kV1vu1CWe/eso9MgaBhQxS8uZAvB?=
 =?us-ascii?Q?XlYQnNbvS+GiX9eAqkFMB8ud/w3RDSywQJK7TaSof3pDeJoA/Oz/ZBQPUMJu?=
 =?us-ascii?Q?CODG39rSm6rTlWVK0OI7BW3Y+ScgV4qJpEjg95Q0ido7hqUAB6lQQYn72kWP?=
 =?us-ascii?Q?1RxaEV84KlfOYy1CL/1EGvUkbAxet5zNkmM0ZT7q2pLCwCqSnmRFtctiWnNM?=
 =?us-ascii?Q?nRZ5ZSfKlUySuHdcoEP7UJr3ghn3O2hmRvtFqPlwxIZpSWTDWujZ4xIoSa9W?=
 =?us-ascii?Q?pOyl/6CV3m0O8hoFvzy+kvxcNA85sKzWG62A7Mdp9DG9CTiLUR3NEERKmyca?=
 =?us-ascii?Q?kDAgFjX4bJ+Hr5YgrRu6voTXSXz8bDeJAchYCUfinsohIUeECaUFWtg1aNv1?=
 =?us-ascii?Q?etONN76wt0atvqEu+xgjZfezpuFmqjGKCVbrAE9dIqrp1m2SoRx8kapeVjSs?=
 =?us-ascii?Q?zKbwuL+WEcFsKA9F2X9p0U/Sj1d9d9aIh31+yNsUcx1bLNABy5NfUCVAJ4T0?=
 =?us-ascii?Q?0B/Png0u/ydLHloN9QNDpIKTX2yYeMUbpBpPxBzlWSoU5DhGBJovPDNVOsx+?=
 =?us-ascii?Q?Ts5qY9Wu+QbdxGP7EpFqGYFUkRS0UylUTYAqdhhVniROQvOvuHljc1u4qBe0?=
 =?us-ascii?Q?mFLyt13nGbREONs0iwcAo5sRDCj6UKlEhtlTEra8uoKP4boiIwIAOkJ3qxkk?=
 =?us-ascii?Q?6ema9/tpiOPhJC93KD6eHU0XUFO6pcvl9HQP5DkZy8yz/M0dfgy1AVlM1wUQ?=
 =?us-ascii?Q?xwR40lHVWScIvTQAuMsuGUsYKrXVNrmeUvVmePqfC0RXLV0b2K5Hc9tCBb4/?=
 =?us-ascii?Q?61CNyjJxDuXiNuIKzHTBWmWIuXhq5hCbmawUhLM9we7xrJMb09C3PPaSggDY?=
 =?us-ascii?Q?u5QyMsLFeDqMQ4DF470tob0Vp3yC8jUM8Smwd0jvuA14+4qUk0SSYcULDfeY?=
 =?us-ascii?Q?Phi511sn8/PXRHg0yBA2yAfBxaXLqJ2yLM4apsNxuVouBp43j3AyRsTl43/c?=
 =?us-ascii?Q?hkibgeTNRhae4WFqiPuDoqWajMGbjCKbby9n9eA54lQh3iZeOnQyyU9ZV2b/?=
 =?us-ascii?Q?pq4Km520g/DCpmAqKaHr735C8/M98GdFpfJNZvVdXXsQ/s/RgeI7j3z0fjHf?=
 =?us-ascii?Q?S14us8yaN7AfLNLXD8JTK/FkQes=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbda2d3-5b34-4bcb-db85-08d9d0ae2948
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:48.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RzNC/0AUb0MH/deITYpJ2w9eED4OndMwrWLK3WrU2oP0QC5BfEYvq21x0i2DsDE3e7UQ9yOawmZXKcf9b52Cpi+RNoVrFiNwIFyaazwvX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=823 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: QwxVU9QEH6cp4HgJQNh4EYEY9FzWI5uT
X-Proofpoint-GUID: QwxVU9QEH6cp4HgJQNh4EYEY9FzWI5uT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Optimistic parallelization can go wrong if too many helpers are started
on a busy system.  They can unfairly degrade the performance of other
tasks, so they should be sensitive to current CPU utilization[1].

Achieve this by running helpers at MAX_NICE so that their CPU time is
proportional to idle CPU time.  The main thread, however, runs at its
original priority so that it can make progress on a heavily loaded
system, as it would if padata were not in the picture.

Here are two test cases in which a padata and a non-padata workload
compete for the same CPUs to show that normal priority (i.e. nice=0)
padata helpers cause the non-padata workload to run more slowly, whereas
MAX_NICE padata helpers don't.

Notes:
  - Each case was run using 8 CPUs on a large two-socket server, with a
    cpumask allowing all test threads to run anywhere within the 8.
  - The non-padata workload used 7 threads and the padata workload used 8
    threads to evaluate how much padata helpers, rather than the main padata
    thread, disturbed the non-padata workload.
  - The non-padata workload was started after the padata workload and run
    for less time to maximize the chances that the non-padata workload would
    be disturbed.
  - Runtimes in seconds.

Case 1: Synthetic, worst-case CPU contention

    padata_test - a tight loop doing integer multiplication to max out on CPU;
                  used for testing only, does not appear in this series
    stress-ng   - cpu stressor ("-c --cpu-method ackerman --cpu-ops 1200");

                 stress-ng
                     alone  (stdev)   max_nice  (stdev)   normal_prio  (stdev)
                  ------------------------------------------------------------
    padata_test                          96.87  ( 1.09)         90.81  ( 0.29)
    stress-ng        43.04  ( 0.00)      43.58  ( 0.01)         75.86  ( 0.39)

MAX_NICE helpers make a significant difference compared to normal
priority helpers, with stress-ng taking 76% longer to finish when
competing with normal priority padata threads than when run by itself,
but only 1% longer when run with MAX_NICE helpers.  The 1% comes from
the small amount of CPU time MAX_NICE threads are given despite their
low priority.

Case 2: Real-world CPU contention

    padata_vfio - VFIO page pin a 175G kvm guest
    usemem      - faults in 25G of anonymous THP per thread, PAGE_SIZE stride;
                  used to mimic the page clearing that dominates in padata_vfio
                  so that usemem competes for the same system resources

                    usemem
                     alone  (stdev)   max_nice  (stdev)   normal_prio  (stdev)
                  ------------------------------------------------------------
    padata_vfio                          14.74  ( 0.04)          9.93  ( 0.09)
        usemem       10.45  ( 0.04)      10.75  ( 0.04)         14.14  ( 0.07)

Here the effect is similar, just not as pronounced.  The usemem threads
take 35% longer to finish with normal priority padata threads than when
run alone, but only 3% longer when MAX_NICE is used.

[1] lkml.kernel.org/r/20171206143509.GG7515@dhcp22.suse.cz

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index ef6589a6b665..83e86724b3e1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -638,7 +638,10 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 		if (IS_ERR(task)) {
 			--ps.nworks;
 		} else {
+			/* Helper threads shouldn't disturb other workloads. */
+			set_user_nice(task, MAX_NICE);
 			kthread_bind_mask(task, current->cpus_ptr);
+
 			wake_up_process(task);
 		}
 	}
-- 
2.34.1

