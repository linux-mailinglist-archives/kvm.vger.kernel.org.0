Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EDA623206
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiKISFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiKISEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:04:50 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8654411810
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:04:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NM+AvJ4bhhDXGlJRwChtrL6oLzdr8vJjI6P38/KXR5PJy5c+pX23PocRKS1PoOA75qH0sgtZicJy266PJIRnkpwa8/lLAsZ9wWEkwn1+ghD7GjAx+VEsdWiGTQ+vaQtnxVGTjSwV4mBomp/acZhXqMLom/rfzZciMBf/YTP/y61yRL6BBHG/tcDaD2tH/tCl6wRyLtXoFyi/HlZ+jQLAiVJ5IePxXljJRCzExS2H+R+rEmNtzfR6AhCDVzJF6dxQ6WdqWoatEK9VICAjVO+wAlxzel9lkhPmc5NlX485JAE6N0F42RxRqv/B3Mgdn6Bi1zK3tMY/SaoLBw5HeRWW8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dez0li1v+vqpDAugQ8bXfnU/nwLPjSB4afevPHgkcBk=;
 b=fN4ZlLyk2vnLPRvVYWVg8Pq+4/tMijYLf927vNCLf+S+HlJEHTxYzXkwGxLBWKdQxKsy5MNnOPvEAJatbxStwRRtQi/IqIj6eBDHAIaQKqMxE6Oqd5k6H/klP+zKGEQhYMILBl5yM2HEU4iiihRKITNf4KJckxc+ov8ouWWQ7TwEdSQxfGSvmks7+ncc6FXpMhlj/Q6JTm/xwRGLiSiO1NTemeqR0ex4Sx6r70BBomwPcQ6Dz609/PnDmrVeWK1ant+Wk365hW7GS7Aaoe8QcASUBrhrrEsv+jNr6vrHzXcGcMs0uaQZn+jUj3ZzS6dxENkR+7Hg256UrUNn7DK6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dez0li1v+vqpDAugQ8bXfnU/nwLPjSB4afevPHgkcBk=;
 b=gXXDCW4Jj1tPO3f/9O70hNs6FbeZUwwKLXjaXxG1he+wjze2yVh6fIk1BF28Ezp1YlO7KzH8Orzzk2JHKLjD0iikn+xhHyHisHp5ezpP4iOriP1zrJbktBbLHUtFvEcE/BYB5G6fgF8k3k+uUQXM1GWvg7TvzBvPzwW03GlvlLBlaD9s7cMLMlbOzx3bZ9n8qLFzYdZPgH74uduCk+nNmAnjANyLK+4E8NtxeKmZUlu+L7VKF6QzF8/i/5AZGijN3JGo3SSyDFXRA7wGu2Jo+ylBVQdAnNIlIHjNCxcMBwhMW5YJ3Lf3H4L/1YteltKMQYJD0MBTDeX0D9SO2mdsaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5942.namprd12.prod.outlook.com (2603:10b6:408:171::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 18:04:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:04:42 +0000
Date:   Wed, 9 Nov 2022 14:04:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 05/13] vfio/mlx5: Enforce a single SAVE command at a
 time
Message-ID: <Y2vrucy8NNG2856a@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-6-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-6-yishaih@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:208:32f::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: 23eb083f-00df-4a2d-8796-08dac27ce0a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIDDOkFytk89ej/+EUKhJFCVrEULZYFjmE8zHQxuenjREkO9qTpWg8eBZxsoPeu+9430hLf9R7assVe4vJICAXIsqkG57AB5Sfmrre/0JgcXGXJXW1fwsjU9v4qlOyh0m1pYm7PGx67aZ0SmsRLC7AwS55NuEcJpQH8jQw17PPy65ffPuut7VXLKk7WMtdWDKeZpUJLLgTWLndnXfFl0p8+jqv0uIHCddWfuETRIHOrpDiO/fXhiJn/qJygFNuYYjmd9Y0pnNkR/AB17X3nwGcS8AF1/iE8kHlfM6BT3J3TOTywwPGl3cLPK2uZl5l6/mRA1R7nswmOTDTmz9BzsqCT/0CUjfZOsjCp6b95I9Q4Fb5Cg//G2lN7VxasBWmLS1QXuhtQvRriXt1mdGnRYQglDSIXyZQiNI2iUnvP5KScWP2HEJmINEfhFg/3Za4gcWu1VeJ6F4KWwIhQM3RS4xaKJnDntNveBzafakdiZI2S/mjGdGr2hoR+hHdMlBrHHm+WJWd7xRKj6xLtybcl3+4yBf3xDe61LOpZqtXLUbg2pubzCvdTsJHCqx1OySCiNr+07fnNAqZu9ckRHNLFB8iKcg5AwIoFR2RNXyW2bifBC98G8LwErdKk+soX5RBbsCAH/nG4kNvkK1jCh8iNbSSGhJO2lny9GLXBffJjSiIGyLL1TmTOTx2JW710bqFp85NbeVNWmcb0Fx5A477Yxug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199015)(66556008)(66946007)(66476007)(316002)(4326008)(478600001)(8676002)(6486002)(37006003)(83380400001)(86362001)(6636002)(38100700002)(6512007)(26005)(6506007)(186003)(66899015)(5660300002)(8936002)(6862004)(41300700001)(36756003)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Co0cH+IApxE8JcOtYsdlcJjLF90cUmEdJgqghQppPV8VnozfVxbnOqHRKcbt?=
 =?us-ascii?Q?wUh4QO4bsnkL++2u9FNbJUrJef77N/UizxjsRFP4Un6EgyZCz2YDceAj33WM?=
 =?us-ascii?Q?iQaEUegeOFVQ6AOipRwcFdn4RbwSID8sv3wjzX67xfCagK0kHgb8rRMNT9cF?=
 =?us-ascii?Q?Zi8B03kSXriPy7Ss1Bpbt6LdL8X14RpZB4CZY2gOA6LTbv40fvsfzllhgaRz?=
 =?us-ascii?Q?jWJFOnIPTkhETXqL24Chp9vK27nlruHJgOPKztxgQ6iPtuqbitJ/XNmbGtx4?=
 =?us-ascii?Q?GjVkkUa4mLnKFgiPNpJs/i5y54OtchAqx82vX0fsT+dOXg6kT3yLUbCN4M3Y?=
 =?us-ascii?Q?zDiB1bnz2ut4OlhXvCOMw7cwVxSwGyBr0Q2mmfbxQfnEa0e05UVR1uPTWEm6?=
 =?us-ascii?Q?+IbzzIt2/LWQ8lhhXNo1hEC6aN5ce0B0MFqTP/NjAn7kUFCTxtM+LgDu/BEO?=
 =?us-ascii?Q?W/CGknwSMQr7dphI+M3SRXbxHKrlk1RIq+R/VobSEygyR42kVLIcycxHXC4o?=
 =?us-ascii?Q?M78z0p+FcrCRUuruFl+W5N+SsDuJ9RL+ilxMVgkDVde4/7JCfSGdWyIgKV/z?=
 =?us-ascii?Q?aiqf9ClFvG7AkQcIJ1EBFiClqYCmR7RG6pJlPGUb1XkViKZenRsjjLuNn5Yn?=
 =?us-ascii?Q?mnoJLHPQLU/XhsJkrYmBaytc1JjexghXjpKVE6n4MFeF9o87Kqg6EoU7bnqp?=
 =?us-ascii?Q?qjglAnimqRHZsSa9P+bS8R4uc1PqwETiBu1qK3YVLrt9coUBmrb2WTypoUWm?=
 =?us-ascii?Q?RU6TMm94t+0bXBTKU2ebeN5ThWE5u54kh9se8TOXTe7pWpvICir58N5Ah0c6?=
 =?us-ascii?Q?pStiF5M9a/BTGvnvK2cXbN9nEQULaTD/0JmO8Vqj56SKiI6Blyxegph5B8fc?=
 =?us-ascii?Q?NrcjFtRRoDByh63gHY/zOJJec+Gf2b5iLRUOQw/AHxJzEdZ4DdgxPhzil6px?=
 =?us-ascii?Q?9XggMe0XIIMDzdjpRqp3Vag4R08Lccs/QWGXAL4Nsk0zCxGEOS7RQXYafaI/?=
 =?us-ascii?Q?kUxVVcqkHQsLeQjv2H/fHj93CbOdQB5rWYflogEtqXOVlymWWMjveKlUujMV?=
 =?us-ascii?Q?arPhW1VK3zwen1Kx7FLzEK/WJmtp3Nu9jEHQvpip6xrl+R/mLpn6y28mb/95?=
 =?us-ascii?Q?oi34/lpP1fInw+G83XfUB81JGmwuNdMVlw5W5Qq+19C27cgKDMsD019OEO0k?=
 =?us-ascii?Q?YIqjRU5CCrGzzCDeGFFcK9IGc+hNexzPZ5BE62f7e9QA+CyWCaus9Tw5Fl/0?=
 =?us-ascii?Q?qNrilIOTx4P6kjeLrWKRInbMJnwSVTNydsys81ANa/JUte6KzE4Xlw4Za+A+?=
 =?us-ascii?Q?vo0Iad0Y/v9fwDKZvEtoXFa3cru4U65g5kWerXkrkqKWL9mnve75/ImtoNVC?=
 =?us-ascii?Q?MxesKVvhF5cBeE4Zb6B7cEOjD1mLBHUquEGdkzO3vDA0528iaatarepTopLX?=
 =?us-ascii?Q?ZGgVK4x+bumPa/laeYCffg3cQ4mb6Cur2IgSrFRHIfIsWoT0rMbx0no0kjHv?=
 =?us-ascii?Q?rOLjkGitHKI52wR6b7JIlpWUUDI3HIRniGNYTLcoWjjeZXwC1BVB/GKE/V2N?=
 =?us-ascii?Q?dU+rRr1yeVRpCBwW+7g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23eb083f-00df-4a2d-8796-08dac27ce0a1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:04:42.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7f2BO3XgygrIl9rlDM7V06hd2GS5gmJ5PIy5m9PVhgmGeezgC8M24lWhc/3XpAgS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5942
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:22PM +0200, Yishai Hadas wrote:
> Enforce a single SAVE command at a time.
> 
> As the SAVE command is an asynchronous one, we must enforce running only
> a single command at a time.
> 
> This will preserve ordering between multiple calls and protect from
> races on the migration file data structure.
> 
> This is a must for the next patches from the series where as part of
> PRE_COPY we may have multiple images to be saved and multiple SAVE
> commands may be issued from different flows.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  | 5 +++++
>  drivers/vfio/pci/mlx5/cmd.h  | 2 ++
>  drivers/vfio/pci/mlx5/main.c | 1 +
>  3 files changed, 8 insertions(+)

This should just use a 'counting completion' instead of open coding
one.


> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 0848bc905d3e..b9ed2f1c8689 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -281,6 +281,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
>  	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
>  	mlx5_core_dealloc_pd(mdev, async_data->pdn);
>  	kvfree(async_data->out);
> +	migf->save_cb_active = false;
> +	wake_up(&migf->save_wait);

complete()

>  	fput(migf->filp);
>  }
>  
> @@ -321,6 +323,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  		return -ENOTCONN;
>  
>  	mdev = mvdev->mdev;
> +	wait_event(migf->save_wait, !migf->save_cb_active);

wait_for_completion_interruptible()

>  	err = mlx5_core_alloc_pd(mdev, &pdn);
>  	if (err)
>  		return err;
> @@ -353,6 +356,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  	get_file(migf->filp);
>  	async_data->mkey = mkey;
>  	async_data->pdn = pdn;
> +	migf->save_cb_active = true;
>  	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
>  			       async_data->out,
>  			       out_size, mlx5vf_save_callback,
> @@ -371,6 +375,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
>  err_dma_map:
>  	mlx5_core_dealloc_pd(mdev, pdn);
> +	migf->save_cb_active = false;

complete()

>  	return err;
>  }
>  
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 921d5720a1e5..b1c5dd2ff144 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -26,6 +26,7 @@ struct mlx5_vf_migration_file {
>  	struct mutex lock;
>  	u8 disabled:1;
>  	u8 is_err:1;
> +	u8 save_cb_active:1;
>  
>  	struct sg_append_table table;
>  	size_t total_length;
> @@ -37,6 +38,7 @@ struct mlx5_vf_migration_file {
>  	unsigned long last_offset;
>  	struct mlx5vf_pci_core_device *mvdev;
>  	wait_queue_head_t poll_wait;
> +	wait_queue_head_t save_wait;
>  	struct mlx5_async_ctx async_ctx;
>  	struct mlx5vf_async_data async_data;
>  };
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 4c7a39ffd247..5da278f3c31c 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -245,6 +245,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
>  	stream_open(migf->filp->f_inode, migf->filp);
>  	mutex_init(&migf->lock);
>  	init_waitqueue_head(&migf->poll_wait);
> +	init_waitqueue_head(&migf->save_wait);

init_completion()
complete()

Jason
