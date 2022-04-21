Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A91450A35E
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388329AbiDUOyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384005AbiDUOyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:54:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0F61C123
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHVkTjm+XleAXb58FD30B2WSHNpaqxvunJHkp11bxfFLBsr1ihNB9cY4PyyfAP+xyczmyrKt1ZXBmuJHoquzH9Z8EjHo4Bxlug8PJVsqCF6lKgshplBbeFWttI6/A9s3bC+HABjdTb+aLqW27fQO5Z3XSfDpOp295wjiDA0UU3wy1mVdGolOHdYkXTTd5rHhjTsBoMQdRDvv8xnpu65WlOoBX/QcUcSsThwWMZmlfdZrZ11G0Zb0Ud/fGnl4DcRAELqq4XgTdBSNUHvit/IAxQALtDh9ChduZGoXvNL1tySNFq2JqRx19G//O/90QcpvbWuccHB9oIp2tRXMtkuXtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJs8qJJOYnW+AXUA2siDyZ4KvfzOCl3WMpkwlFoBNs4=;
 b=bDL2qbs+gn0QR/LJBUo/p9h2RsjAzdATb6Iqq7m3Tsey25hWtaaCHHiVm9O11+U14n7IoACDXQlzoMAHh02bpcsduy2BJ9k2qcZP3JkEN/h6leuNRu0q1NdQN1ZUBz/EL2KLB03s+Pdx+WIXRBNwXQiqYTeOUBuNwAthnOyjgL9OoqEaKgzpqD0SBKs53vWFFlFqd0BtcRJ/rZF1s7Ke/dd/g9A0YSY/YJHM0jTXwTHuooOPrmjpGXynyUUt09rifUA9KxQGWTqQQ7PKA25z0LAzB8eO4ub67s3ThZaHmoyNz5UajTLqz8gTo7bzhk6fDzJQt6H9cECbjsr0r+O7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJs8qJJOYnW+AXUA2siDyZ4KvfzOCl3WMpkwlFoBNs4=;
 b=dIBCswYvTHp8bj3ttQJsdV3oBJ8cxvnNAujC5zHEiSsZKFsnRtvhsiL55FLjQH/75HxfgICgSxK4qpWMFuc0mMCCc4CxmgmlKgjlj1e6rDbcfRten1VOe7LT51wfs8pXWru4IdIiCBKNhLbn/NLIvITM0HB8QezKC1TK12GhkIV7Sc6O3fIa66SDlbqeBOVgNw+bWjcrfyYEJa0YO7IL7Jbq7VL5k8AybQFqJJh/ZJsaoL8UDeKWbQ1HFvHJw1tQlyFKaSvOEkyFbANd7p8rZaSkHH5JRmqp8EyyXBSR7WDtvzTSL7j6lWID0hJMsEh8WIxSXakU4rcgaGdtb7SDtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4562.namprd12.prod.outlook.com (2603:10b6:5:2aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 14:51:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:51:49 +0000
Date:   Thu, 21 Apr 2022 11:51:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 1/8] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
Message-ID: <20220421145148.GA1710803@nvidia.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0305.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fffa80bf-b8b2-4c8c-35d5-08da23a67734
X-MS-TrafficTypeDiagnostic: DM6PR12MB4562:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4562670673F2C683892D24D7C2F49@DM6PR12MB4562.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwcMPEeY7c8PHTtB/VhJao4rRG9Kn3I8Q2LatG+ogxKl3otmg+rgAaZ2SRCJCEipKasVC9NteC1znmWgCcXQ2dl3uyZzuQ7MW0o/yg+RdNLJHmqK9sdPqYJuHEvKynMS+OcgfffibYoZ9pjBpz3T983ajAtL4cVsPoy5sXfXK/JkOzHCrlyRWVEzWVCT9hAwcmL7qD/omv06iB3TocrFXkCyLv7RN5NHYY5Wv7hMjjeba6AEyc4cmFxoHzfEXm5DxH/B1bNQ60g1gLLa7wbluu1INYyiTJVg2pEOj2YZoLYzIHYLldUdv4xqrHj+cOYddvbV/W3rvLi2B/bk0dC8A4RmNLGhJ58JnSV1lqXiA4LcmHNdj3LD+HZxmEE8apCse/RInNeHbJHBjqnIPqQi4csZ7lNk+t1+R37iJf2Ehg1iduCKR/kyKwiGHMtPCpxxd67iY0VByOj7SUG4bb6DwyAGpPjckjpUVigi7x/omndVE4WObpZh9J2wjnrTlIrCyvTLt+vxol4smM0OloEs406SrEzyd4hbkHR2uKogfmnGWvtcOrON56HcQEtHwB7FkELa3jjlf0BBPs4Ucgw+0m0UAawujcNVdkUzUvDLN9b2nuVwhLXUb+kCmqNr/tpuXWsfZvGZgmMR/0Qe+6JjWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(110136005)(54906003)(38100700002)(66556008)(4326008)(8936002)(316002)(66476007)(36756003)(2906002)(5660300002)(6486002)(8676002)(508600001)(86362001)(2616005)(26005)(6506007)(6512007)(186003)(1076003)(33656002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEZolgjXBAIrvnN4CmKMuERHKMhxDF6VEJsHCi4xX8xjz4Q5vpA/7iHj3Iqb?=
 =?us-ascii?Q?oQM6JYxkfxsLaFei1+lo03KCJtal76CWIYYvpUOjoFq8v+HXjUpYvOhXwkXg?=
 =?us-ascii?Q?GAEAouGyH9Qfn8dxflLS3oeCW+74nJInCwwk9S++lKRg0pOMUAqL0nhKgSWC?=
 =?us-ascii?Q?ohGnqCXIMIhMoKaMqtBqC6Vd9IV2p51rsp7WH80tguh6skJzoB2cm8kErQ9y?=
 =?us-ascii?Q?4kEUjNImbqk9lkT5AFlzvhMz6iLFdNXMrxwpZvELseJ+JfQC/0dfbvXkGaBP?=
 =?us-ascii?Q?8go5LD2Cs4kmVD+RnPQIzKMDnx3wGsPtAqyXDmEr3TavAeeqCNkeMzQLgYkM?=
 =?us-ascii?Q?VQtVjc8QGaCF2mveUhBT3T7J9vPhPVLWYDKFvoLv9uchA/rt9QSYiiZCsXVy?=
 =?us-ascii?Q?MSwTFIFyjlv96RkMAU83Eo0AuRDQWXhMe71lYC2icaBF8gKigexJljtcPvpu?=
 =?us-ascii?Q?btRsspvMunFwfE6SPvdderYtUkmG9NJQByeN/ULnjBL/fsv7xMuN5CZGo4Wb?=
 =?us-ascii?Q?hBHQ4KT2DtAPqJQgNIdZxGQI/FAs4sNKfYKmRraEzxnP7rXWMEX5cVasK3rl?=
 =?us-ascii?Q?2hydLvxRIHaN7E7GR6bxFNmy8c16CL/vmf1sq/JkSOLxAq9R/MYCRRYq5RyQ?=
 =?us-ascii?Q?/3w5EqrRkQM0BGqaAnjdjiH0pkJM4KwSbtoupWkCYL8CHWR8sx6IvjBKEjfC?=
 =?us-ascii?Q?c5KYs6rUzSbMPcljLTrwK1w2gfro9RPKaDuiH+71TEfyjzTINYYGadA22Cv4?=
 =?us-ascii?Q?DJ0WaWAkdGurzo2URZGqX6oCwzJfzWB+qybRoeOpsB9hUv7Cg5bTaa6A3LrJ?=
 =?us-ascii?Q?5VkUdL+lq/IAhprgWIFpdWMALEPu3EQyH2iMaENK150OX5TMD9JSI7pKtnc6?=
 =?us-ascii?Q?I8O7GquW5cyuDS6p2b8Q6US72qk10inyvMzXx7zyW5QCOViNBrJlQoZaxi5X?=
 =?us-ascii?Q?5QK01uUlbDfvzUyt2FVA78pbmJZ6ZV9ezsh8CAxnG1dWkyLdJUlUjA6XrGNy?=
 =?us-ascii?Q?3p39AG6vXLK0DyZGYBBrwnTnX9nDQwFM0UKRT0JzzjCfHKwlMfiPe5URugON?=
 =?us-ascii?Q?UVhgByqmmhy3aByyMQvrBpNipKY4O/WLsBE/Qc82SD+kPZRUpLmmT+4sc5Eh?=
 =?us-ascii?Q?2rIOtVobl0ylBu5/lsL2GVEjqQ3akKhhQ4VbMGPgxK37qOThVCMTtUfRvzlm?=
 =?us-ascii?Q?Lt32Ox+jEv24u+dFSoOCoTVs9HPs+frFWTOmfSgQpDvLMl6JB64vx8ldwzN1?=
 =?us-ascii?Q?hI2ZP7r+ctZ0KPA6/aK2MpUdGmXMQJyHpHYh3Y2oFbSgVAyIgcXI/B9cN/Cb?=
 =?us-ascii?Q?P+ZmIvBSahzHqbeRKGU+RVNxQRsC6dJFMpOgE8xX1iQjfRcX2XpiwAbw7RId?=
 =?us-ascii?Q?T8eh8+e94YtUNWfijNK5Ij/obpXgY1r4mblgxSIuRavvXlh5BxmtKEmukeXX?=
 =?us-ascii?Q?U4K0bjZQt3YB6CMLNAto8wy5ZVML/uZJ4cpHuLos+oALfo3N8ox3Fhyl4LRx?=
 =?us-ascii?Q?nOqMF7zN0whVSre7qnIGtxhHM98si4Q48o9f6olkshZ6Bb3WUc4fVkTSXBax?=
 =?us-ascii?Q?DfE9xEMfl3H1dEvvTmQ0aQ8XGNJh3REraFKA3rGHLh51Zoc5VH5EcbCaZcWy?=
 =?us-ascii?Q?yv1gSnLB8xAwmcAs0ETHvw2d0x9HMOtwG4jtzJb3+PUKCXUPiKj5IsD4/evy?=
 =?us-ascii?Q?kI/77o+m6+QyOMXtJiCUOpIsUZnatGG9nb6plfrS2VJL8FUkrvlRIXZqiD1M?=
 =?us-ascii?Q?xaC3D5fn4w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fffa80bf-b8b2-4c8c-35d5-08da23a67734
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:51:49.8737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vr+2Yg1V+RuRyGnZhevw6i1VLEBPW5MIvmvuXlayLrd8uxWpz0TpPfzr7LLBgRcf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4562
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 04:23:10PM -0300, Jason Gunthorpe wrote:
> To make it easier to read and change in following patches.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
>  1 file changed, 146 insertions(+), 125 deletions(-)
> 
> This is best viewed with 'git show -b'

Zero day hit a warning on 32bit, I'll fold this into v3:

--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -259,9 +259,10 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 }
 #endif
 
-static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
+			      void __user *arg)
 {
-	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
+	int32_t __user *argp = arg;
 	int32_t fd;
 
 	switch (attr) {
@@ -277,7 +278,7 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
-		return kvm_vfio_group_set_spapr_tce(dev, (void __user *)arg);
+		return kvm_vfio_group_set_spapr_tce(dev, arg);
 #endif
 	}
 
@@ -289,7 +290,8 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_VFIO_GROUP:
-		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
+		return kvm_vfio_set_group(dev, attr->attr,
+					  u64_to_user_ptr(attr->addr));
 	}
 
 	return -ENXIO;
