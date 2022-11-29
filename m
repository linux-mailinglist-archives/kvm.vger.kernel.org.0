Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCCB63C937
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiK2U34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiK2U3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:52 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A5963BAF
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVQ2vQzDkf0VzgaqU9eVFCZ+TQ/PxoSCkMxG7J9u1vqOQQb+/JjPPVPsCFNEzWWPfir3bIUJZXdM6tw2P2KvLTkwdMp+qRg4cahVlpJ/I2O0Ro+1xepE7brWwrP3/Ueqoeju8ARoVRMYVAeNQDUi1RAQgyWDL16bFGKWhOSQVd+FHutuqiU7A4My2sQRo3g1m/VxdJRlGiX/TMv6zM5F0cLs2yNsUQzIsNyodUwMeOQfC5pDEu5QZHVrjq3RejaG4srt0dccybY1zHpoozxaBzfBsNmJtI8s5bFSCzKqtKgIgjlx2yq5eCHmsdBuBx60YIqLH1qIHbLl2YiiFJenDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFG0eorqkJlJaRJ/YtcEpmpkZg5cEqgF1aVImBwNj9o=;
 b=AGILCAuAJHxm4BJgp75H79eYs5EBYcAsVPIvDVX+DTa5gu4kbki90H+VKLBVYoiCQV4V1QrWiYwyqKLNlXdgBskblHmBzK6aQcDUbmkJPdSOSsiD5Awjl+wa9ZNI9StRtT4HnDzFyfeeLj2S/0eKp7PYmgae2YDz56w0286dF+VQC3B2rJAFUsOCVaCqtVWL4QIKSlnc50ihK8SVnwRoCTndmJooXjUOJpU+5txX7E7zVUAnQAJweB/yeTz/nE8099zXNImkLNsm2w0Y0nHH5YDWHnjjwl+UZuMPUPUgxcW4iu567KQSWIwGpoTEDzXuFg5+HPZWsgqhs6v14bSCZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFG0eorqkJlJaRJ/YtcEpmpkZg5cEqgF1aVImBwNj9o=;
 b=qODObo8/RsBT87zY8rTeBPhUznBcbBoEb+PlYocz1raonOK3NJdScp72AyjNFk/eVZtbFMOoDhq/X32KJgTHYU0O3YuswvQ8RpEBI0mJ9TPV74WGOe0Md8C4l4RZFr6PpPt2gpO1NimPP/VkuBro79Cy8jHYnfGyKbO3TonLBXcFP6hYIY6EOfp1uo7WJ6GEgNosIF8eoyEStTEFl3pZKCWExgY004/SY171QsPDaLt0e9CERDCKurGqaU82dOX894SXnuabDBNOKuchT6P+bRO4SM/5J8vXDmX335fJppgU3HqW7IHJx77A2gyqFkU2xFGZP3HUsM3gvqMfFdHfig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:46 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 07/19] kernel/user: Allow user::locked_vm to be usable for iommufd
Date:   Tue, 29 Nov 2022 16:29:30 -0400
Message-Id: <7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:74::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 54763479-8e37-4b15-4f48-08dad24873ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPfxEs2U4akBZIqL5MLRIrKU6rOID9QbZZGSj0YyI6zv6cXqFuniHfpOUoAX47j5crIk8VuImqlqvcjLUal9LYVebMDLQQCHz4F0itj9NkFZQK7piGPfCRDJy5WGNc0W0IaXDra/0l8JWUP5FOd/mNDpmgPU26HspHMUPRCNxdzAZqIzmQXd6Eko85ZYQODebBrbCMQ8752OSdvfYD/rOzlRRxa8F98cGBdzvTtQE2GfLmkIgNJe5v3pVLzXC5ZwQwBf4Hknt0rpyOPJtfIFFOY9jVkfd80XU+8b8BfZ2IwGkNQxd0b/YF2DuL3PCfKM0iaHTLxn1ZKsvjDi0JEf/aCq6gLPf49ByMG/cOBOCOPcniDOhyQJVcxN7aNwRNt93spE/P9/jGdk8+GfbzjJGQTugNFMbRU5cMv4OLAUhxlEXGBSr1bPskNmi2Z3PVDWUChdchG2D2p8lWh4AyTadhj8F7xiJ0qghE0KgcMTClbRTCkIBo0r4EVockk1MU7nby3K+NxGDi5lemf5ujvk/1J/k+euYRcrCa5h0cKj5SwZ8/yJv57tTX0qzN3Xpf1rQ0el/+1zjtERBITg29xundV4EiyLqIbSsxi/SyuA4WEc/B/uZEV/CWVh0Ma/9bvqwWUBsvFv2fOmNb5XyWVfuFCt7YNVuxysmWQMdsEU8JsaJFVzkpSXMAjhDhCeM7uOlO8pBQQHLVw3PVp9ReAFfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iBaGeiSgTHExCI2QrEhwUX9XFQTWhEyCHcg3pMAWPZrWbPVYN3TBpTXb0NeI?=
 =?us-ascii?Q?xDXlJ4IBSYSr30oK41pHunJBLPTKre1A+wqiWQeuqxTr1E/yMsWMM2tHCDCq?=
 =?us-ascii?Q?VN1SO+TkkhAeu1PS5BjbQZGu8E0RUvKcieY08K2Do8KLLtUnv+3HjxdxQ1jj?=
 =?us-ascii?Q?JuAL0l92RKaqQqDFRC4E3Rv4l7LQoOAZSHdBg+6ApzI1DF2QeiehhY2MFtgY?=
 =?us-ascii?Q?LFjOv7iv+uhAshOlTKLrT8zYCz13hZtE/Q8gZGIvC84aT8Mig6OpyQAvSKD+?=
 =?us-ascii?Q?h6Eh2QjTkuK3kTuJtHPl74/RvCEqZFasQVVyxN49tQZjuSg92M+khwPAKaaL?=
 =?us-ascii?Q?MYV5oJoLqNfW93GzRVtQp+60nUr+LImwFYzU8zVsnbG6OqeuipsrbPr8BJpR?=
 =?us-ascii?Q?alByCLaKZxXBMqFrnmglVuusGTiNWabSTY9/m7/c2mWU5inz9K6HMq7RSf0p?=
 =?us-ascii?Q?mzPrOop19dSIrqQkRuwK6MllDN/ij0B8AAWhFinc98jtAoyR85gVwA+QcNtm?=
 =?us-ascii?Q?RrOlvx03HNl0kSVJZPrxB3mvbrTDJ2xTmxka0yc52ocDyJTDI30p85jlYQen?=
 =?us-ascii?Q?N+1AA49SkJxltK5jBWovhSzxrvNsSLwkj0a0ag1ajiG6wzyCSv38is58wsvq?=
 =?us-ascii?Q?a044ZSKUuOB0y8sGg8Pn2K4inhega5cL0PnWKNEhiREB04rO4kClPvxYjxX/?=
 =?us-ascii?Q?HGb0ChR7KGxeL+z4zynhFLBXrikgsYTQoyTLmHsmme1nIotK4Qt4bEN2STzZ?=
 =?us-ascii?Q?H+XTlQ1rAJlwgnRhWxSLAFtC5ax/h5NlPXGhnd+JYteHX8uSEZrRVTUhNvxX?=
 =?us-ascii?Q?JdSfSwH5YyGHsuTcG6MVfkiMxIqrEm2touGdzj2e0z/kJy1L1Pz3BAXls55A?=
 =?us-ascii?Q?e4ihtRgPb+z2FHwkc/m225DoxOT18xueI3q9W39LeMrPuiokM8dPHZyWEaP8?=
 =?us-ascii?Q?c342jw6Cl0FhD4Vb8vhGibh6YEDHD5k7/5MsBc3AwqTyC1wQqEeVjTRjzM5S?=
 =?us-ascii?Q?D8JtV8DLJfHsCZmYbHGBJQQpnKIO7bEzpbWI06U2fxThvTCjMx0Irjw9F7jX?=
 =?us-ascii?Q?Kct5XSkwtq7Kndma7ZjFk6YLjhCFzE6k3vkgjo5Glem9ZTdRCNYcrhRZW3dO?=
 =?us-ascii?Q?zpxGvVZq9M7xsG+lJZ/Z/EjjJArBMI/9CNjJKBBtVZ2kDSFfG8EWnhnGOoxF?=
 =?us-ascii?Q?TSv91qMCwtQqwaWbjBL7pxW+CNXt0O33SlOCQzMffOWLGmGvJpBvx5I16T+T?=
 =?us-ascii?Q?oJA486s1VodnBqBa+EUBz3Tl9hYKn9g9SSaw5mD/Qgwkl9JFrrezFoYpwr4u?=
 =?us-ascii?Q?IxSMJLjn65WgBvVonqUiwyPWhfp6CcpB2osx0dY2yq02Uyhf77Ntz4Hc8pah?=
 =?us-ascii?Q?VRbgquxaUCMvbtnSgaYC8NIAnWnvHjMr+y8nPiDITNhRw7k7tZ/EgvtXOJl7?=
 =?us-ascii?Q?Hfc5kj0Ukbw49utQND4Gnjd8vPTeFHJsPnUNqyh4tT2UaaovfI7JrXym/AWr?=
 =?us-ascii?Q?IDFoBGm2S9TRw0BjVoCVFrdC5AkjHoWEaQq7wlBRwe+PJJQ0FqvbY8PUs/jv?=
 =?us-ascii?Q?D1wxj0GNRqvSnWBJJq3OKkYQIhfY1k1shV5kuFhC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54763479-8e37-4b15-4f48-08dad24873ea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.2747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVbNcK5AP9HOKlKCB3Q/87JXig5Bvknm0oPolOK641CamrJ2Fde6NlaD5QVjz1ke
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the pattern of io_uring, perf, skb, and bpf, iommfd will use
user->locked_vm for accounting pinned pages. Ensure the value is included
in the struct and export free_uid() as iommufd is modular.

user->locked_vm is the good accounting to use for ulimit because it is
per-user, and the security sandboxing of locked pages is not supposed to
be per-process. Other places (vfio, vdpa and infiniband) have used
mm->pinned_vm and/or mm->locked_vm for accounting pinned pages, but this
is only per-process and inconsistent with the new FOLL_LONGTERM users in
the kernel.

Concurrent work is underway to try to put this in a cgroup, so everything
can be consistent and the kernel can provide a FOLL_LONGTERM limit that
actually provides security.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/sched/user.h | 2 +-
 kernel/user.c              | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index f054d0360a7533..4cc52698e214e2 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,7 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
 	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-	defined(CONFIG_VFIO_PCI_ZDEV_KVM)
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
diff --git a/kernel/user.c b/kernel/user.c
index e2cf8c22b539a7..d667debeafd609 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -185,6 +185,7 @@ void free_uid(struct user_struct *up)
 	if (refcount_dec_and_lock_irqsave(&up->__count, &uidhash_lock, &flags))
 		free_user(up, flags);
 }
+EXPORT_SYMBOL_GPL(free_uid);
 
 struct user_struct *alloc_uid(kuid_t uid)
 {
-- 
2.38.1

