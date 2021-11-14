Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7344F89D
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhKNPAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:00:34 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:17432 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhKNPAa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:00:30 -0500
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AE6XHdn023591;
        Sun, 14 Nov 2021 06:57:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=qbVFNogRcvTeDU/rSn4+BYwpmSyLe5ERxnWSTe6pVAk=;
 b=K8vrEA1ZvYe3YVwB2T4hO3XaMtTAcqeb0JlmKmK6hRmvh4BSoyFzSCfvfmBSaleaiN/s
 ZNISADFXCUQBJXaVP6/Yb4QLmIQHy6pzUo8U/sAKz+iCqJHh8hx0vgJ09cjQflbRCy3n
 GJoQgFjJNufCtXFDbrc3eFiFNslTi0FFTGVgJdVyDceWvfq8IX/l1BvJJ0OH1qdas8Ub
 S7YXKRvIrJ8LV7eqgNKKJFcUogL2i9Qo2Jyj3hcNexvcn7/Dz6g7WVkNbfeGbxrKbGKe
 H3b7O5Ig6dzQ0LTqgF42ABb3zZvcUQcfUZ1VZ7UuzVV+sQHeODtI7opLkk2WjEvCfUMl sQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cabsd9rdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:57:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3X4P3y3Y/ic9cELuxcXt0pE/kOKZZXP5oHa+gye5542iePzPYd/B8n6pBS/cLEqHXAznxhAfTc64zQcxb664k4H4KkV+yt/5ANz5Q5v6lmdeou4JS8UAgp35kyAeKkHSmFe9Pt/00kM3oRad5JlL6XftWREaGyD3jxCpsGN5gx/BstmG8oq/n9qutvCMVyuUWSvOHB+5ELrsG61NOOICjR/pJ6EwhWqH4n46QkycCW2SshPH5mrBBVo0DIHMA41cpDGDwb7xQqrTNRuPXkx5g1AR2sSA+mY/iN9+ZClA7ZOX0X3bJS/8BdxdcG1PijrMSlB/sx1jAQPIzPWaVxTSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbVFNogRcvTeDU/rSn4+BYwpmSyLe5ERxnWSTe6pVAk=;
 b=RxoAseJkSz6OcmmxVQbaLx9x8VsOdN6T2Gmb70WK4UMvYnogLHk6u1YLGT3zCYFQUJt5DDMQhjUuYqkpwOkaUb565egyqIibhUaR+jVNIhq2RFP0Pm1bf78OBUYpZRgodd/dZuw87USKJZ+/HB7YpVlc4AApCKVT8eULW4Hz0nZJ+AVhWDOUu78Sg6OnIdv0XccdJyYJNrJATOvXsJswlQhiCHjDAyDnkuTdSJn9H2UGfVuI6BxYe7oOBQCXgj40QkPj6AXdII/axd4iyyCTj/K+d+ok4xXTcfSNxjHysHvx6IqtqkULjluNc2ATd2Xpw0k7bLGgOGDQILygUo84JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO1PR02MB8618.namprd02.prod.outlook.com (2603:10b6:303:15d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Sun, 14 Nov
 2021 14:57:32 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:57:31 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH 0/6] KVM: Dirty Quota-Based VM Live Migration Auto-Converge
Date:   Sun, 14 Nov 2021 14:57:15 +0000
Message-Id: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:57:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e04eca30-6d73-4300-72a1-08d9a77f159a
X-MS-TrafficTypeDiagnostic: CO1PR02MB8618:
X-Microsoft-Antispam-PRVS: <CO1PR02MB86188A6996F8F6C95E0954DFB3979@CO1PR02MB8618.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdUHOHvKAGR5TfsZCOydN6pHtlkbqwg2LlDIFFT2A35wqXb3wt0jwYvZLuoBDM5NXp3Pk/oAtuwoGBO6PoaB9ch5VIYJ6yMP8UeE+t5vfVUx38wcl4etNDH7kbdZuoC/3MzA8IHMvysddZftcmypLOv57qv3SRzSy0LQgZGki31qn4jUiPHgWbENhbWBkua/gC6ZD4IS3epcRq/9R2QGS6p45BolH8oEbOgyYEYJ1lceueO8nbyAWcMoR5VyfT8tIvUwQc2ayIP649MY0tNp4giBHdrUebav9tQMo+yNtLQm/PqUSk7eC1T+PSeqpzQaZS+i0JUawy/vqsYSiNMJ21EkurKKOc6x+61GYUIieqTrq+8ipU1XBe9QELWrXWMQy9J9V+c5OpsGI9Gzdgp1eXwfoCAD5YtnLfMtWQ45euLmMsJrcjoK3MEZ2Z6mwF7S+xoCL1f4ygeenxk2hkoh7uemwEJ/+BBtVOO7RwdQ2tPLY1XKKLi8HhoAZ/rx3c5YYoeJoUyiXcpHumsNeK9jVpzYIpzJw+su7tB5Y5wPQxhafIlsce8OVwdOSLjI4tQn6/31CPddLWxZ49+0mVkEQjLj/CnYb7hL2J4nbxXfXx4HBze2Dnl2SVusH0YaFF8Q4SNJPAVb2gs7NKt9rqTulHvD+oJmE8oqbBaEaGaxWHlMV/qMGR2pJlvLXQwdRq1ezIKXjskUDezK9zK3ZXPLoLIY7Be4BZDA3lGgcgkRKEc9ZmgBRF93Di9mybjtSXO56l1JTkMuHDjeM95n0fGiCcJswSclQ89NSvKMhQkIPPKPRMZf0FJcqwUGHCNALk/J3qR5r9Kauqz3+GKh3UGYKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38100700002)(38350700002)(7696005)(26005)(36756003)(15650500001)(66556008)(1076003)(6486002)(52116002)(5660300002)(186003)(966005)(2616005)(6916009)(2906002)(508600001)(8936002)(86362001)(66476007)(4326008)(66946007)(316002)(83380400001)(6666004)(107886003)(956004)(590914001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1il9n8kztBn7Udk1aIfuUdRR77/qT+SW526EqbcXhJfDwi8nKaOW9rHIGNe?=
 =?us-ascii?Q?869GhUt+onV4NNL11G+9D+e5PjUp6XxrrizDNhJuR5JMkg0UKSP8sqkNrYRT?=
 =?us-ascii?Q?nrxshoVZ7BeS1VlxUezRKQTsB5p0cAL3BOBsP+n6GVjwJqq5fPb8WG0qh44P?=
 =?us-ascii?Q?N9OWKI5cxy9MrR/nYvMLMyU6d6GlxY9AfXZnVbFQQJSvITmTNcFE0+mmwtRQ?=
 =?us-ascii?Q?LjL/y2DRyMy5n4TXS/JbNHlk9htZ/S3d9vFVn+Q/G7B1AguBfnI0fpG7p+/8?=
 =?us-ascii?Q?Cw+LWqMxkgCiL3swt6Ukik1GVeO9dDrfP/EMuvyOsnrYxok/EKAo7iu9VYad?=
 =?us-ascii?Q?2CX1moD+bLfD8ZU9CWwB3KB3Bt8n2XGZJLE1l6fx5BaYfLnXg/6r3CI8p8z6?=
 =?us-ascii?Q?BgUl0IvEDPgr8hUXgLn00sgYPDhvTD6JcIOWed3LU4mY4fYqqqiDzU2lngfx?=
 =?us-ascii?Q?4+SMlL9Dm37DWEwScYJMW6uvXsxDL2+BVSmT7p/+Du1aIs2+6tVRlOk1Ch5S?=
 =?us-ascii?Q?0Fp7yPPrameqKh5YuE3qfSzsIoPwZXlpa8kCoFAibqIG85crLv2HqUbokBlu?=
 =?us-ascii?Q?1TStv+4b2uNKBzSd8m37DJR+vpsbVRIZDg24YxGUqzNRqxLKqLk6H4ianCbZ?=
 =?us-ascii?Q?kSq1ZxV/fQOtqhFJk/3wx0c5qPkd9K5zZ5HBnwp3gOv/9uqaub4jSyJ4WYIT?=
 =?us-ascii?Q?wWxr+pszPBNqZsuJawptxsmSir9xtQ5/EcP51J4amsi9WqaGssjE9GDZ+4My?=
 =?us-ascii?Q?9VcEQyaWRpIV/vlit6mGruTt+ycz8qR37Kzg/K6yjTWqkbp4Unas7XWwWpDY?=
 =?us-ascii?Q?V7tKPFv/bTxUGz5J3oVFolaOAupoQUqmDT75VgLG9iSeeNVjPrm78PQAFSkH?=
 =?us-ascii?Q?2di1nUi9Wi+yCWKhPmrn08RHlfXrFYYps2xg3LcymJzrxPkN/MhA+RiUCSsH?=
 =?us-ascii?Q?Cw7kZomxpoTQ/bbC7LynnXS6oqfPXs+XOzEKQinMxChRc6qJLMTJo1izPdNn?=
 =?us-ascii?Q?59qICX8/edjumGesEVtMufL9gQQvprGl2cgIPalJJWzuQx5aT4XSFbZvY6MQ?=
 =?us-ascii?Q?dVUuCcFd9kbN1Ks7EGJjtq1EiIZSGKlmUOrT0Pdz3k+CZolxFBIuv4sHIz8M?=
 =?us-ascii?Q?jABqYXvkuf1AYiW+CiPIiSq76YoF6cZo8sranlqTeTMlONqzFpYkdiHQfddZ?=
 =?us-ascii?Q?qq5orOYK42JVKytWRyXYoxGOhl/xo9PZyJPtCL9pBD6YOi2bXW38vXnirWlL?=
 =?us-ascii?Q?//J2PFFvYWZD4wwKToIq/MoEM3IK5tJrRzj/zVOvkEqVEFInlY25ZMKhVC9d?=
 =?us-ascii?Q?2CqNrPU629xDrisYArUPeDyt8p4Lp9eyUIt1ZqpEEVTJTtPf4l/XAoHfx47J?=
 =?us-ascii?Q?GJrNANSp5EDHwYTXKerv5w9eLkJPPgi4bYn9CCWPZGnkRIOZhvMkX6EmSCNQ?=
 =?us-ascii?Q?uZnYvQwdBhhKIRSbI8ZWLeAjbFsZJk84J3PXY4945H0Qwx9iatFO8r0c6wRh?=
 =?us-ascii?Q?SuzzRJzMwjC7fAY1PLsVt1sDwevDFtmcefHGkrxS9lNtbdgM+PyFnj4ynRwy?=
 =?us-ascii?Q?9jidRUX0kVVrZoe6koXStZ7z699OK/Tjve0rXYLPk7dM9kzuq/cHPPJqR64r?=
 =?us-ascii?Q?ckRI+pocsEV0CcR3LQohv5/HeOaIx4M24EUAx/lB38+r+4ZFjaIyBG3Fe+Od?=
 =?us-ascii?Q?FRYEXyagrKgjfN4bk9mI1hrxAbQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04eca30-6d73-4300-72a1-08d9a77f159a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:57:31.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqlOUvwtFMdq/70VHvYE7TjARoP31IGh1wV+ufZCGonsdHiQF27409vo3i5jck+KXRsd9bTVcn0EpQAYKrJeAx0BlIXZlgjk0MeYQihoNq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Proofpoint-ORIG-GUID: QOoc0UQ6G8yX-8601tiJVlbe2abzhXyz
X-Proofpoint-GUID: QOoc0UQ6G8yX-8601tiJVlbe2abzhXyz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is the KVM-side implementation of a (new) dirty "quota"
based throttling algorithm that selectively throttles vCPUs based on their
individual contribution to overall memory dirtying and also dynamically
adapts the throttle based on the available network bandwidth.

Overview
----------
----------

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
----------
----------

Initialization

vCPUDirtyQuotaContext keeps the dirty quota context for each vCPU. It keeps
the number of pages the vCPU has dirtied (dirty_counter) in the ongoing
dirty quota interval, and the maximum number of dirties allowed for the
vCPU (dirty_quota) in the ongoing dirty quota interval.

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
  Define data structures for dirty quota migration.
  Init dirty quota flag and allocate memory for vCPUdqctx.
  Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU page faults.
  Increment dirty counter for vmexit due to page write fault.
  Exit to userspace when dirty quota is full.
  Free vCPUdqctx memory on vCPU destroy.

 Documentation/virt/kvm/api.rst        | 39 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/Makefile                 |  3 +-
 arch/x86/kvm/x86.c                    |  9 +++++
 include/linux/dirty_quota_migration.h | 52 +++++++++++++++++++++++++
 include/linux/kvm_host.h              |  3 ++
 include/uapi/linux/kvm.h              | 11 ++++++
 virt/kvm/dirty_quota_migration.c      | 31 +++++++++++++++
 virt/kvm/kvm_main.c                   | 56 ++++++++++++++++++++++++++-
 9 files changed, 203 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/dirty_quota_migration.h
 create mode 100644 virt/kvm/dirty_quota_migration.c

-- 
2.22.3

