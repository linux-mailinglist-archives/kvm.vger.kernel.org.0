Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88D33FB94
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 00:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCQXAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 19:00:15 -0400
Received: from mail-mw2nam08on2057.outbound.protection.outlook.com ([40.107.101.57]:48545
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229769AbhCQW7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 18:59:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zsy6qdF6qGCz1lzWh4t+XcT4e5uVCrYsIz486lUv6JmdPli615vEaEpvIsFwGQucNE4Ns8ZbRn1SreZCt+z/9SfbcNJ5XGXWuybjSUheAU8UVGXzpw59Z7Me9/Nc2QnLkJUj/Zr55daTsafgOGMYFCEpAFGZ2ikYmRtdZsZSQkUfWTLJ0Gx6qz+D5LYUVaR/QnwTLgwMtKJ044cfsDphwvBsmwLQxzZ+SgSFYIvsGc5KraL7+KQCMMyEY5UztPNMr/NUPvrSvEHpICH3VJv1gKbBhczKTtkk4of5GT5r6LvzkLz88oLGuogetIH0OjR/Y3xOwMGvlqOlfdkv1q4pjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8BDBICZv4tCy4+axtGxOV6J4quLPOQXMhTENleFHIQ=;
 b=IFugYWYAEgViK1wE2C9hSFw5ozWIGTeVNZ6JgemhJVQtbhA5j1zO+ZvUGfVYA053ZyHpjaM5ZQ6GAeeVDqdNAEmmTDoWQ0/TtcNbApWeJC2u6ixpkmTLpAYHmAmyvZCye3iseSWPy8qOq/qErO4VfPlLKI9v57zJUb4HtYfJziF5wwUf06lxYCnym/qk85oRZ0GM12HfoHsYNHHnauW9QmiaBWj46Aan3CrraDA2Wo2+FUDv3MJ1JDBmRnmNmj8fP+1OWXjYEe94NfZPstSxvOSFuMLkAMldTM2cqLrx+7RByWyyQIw0H74e5Y00NlbpyXHHQXYNBJw+xNsM6LIVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8BDBICZv4tCy4+axtGxOV6J4quLPOQXMhTENleFHIQ=;
 b=XLIYoqdLD/YbJ8NM4RdUPmCbVlKBMBOs9Qfs3gisMwkSwHDdeee3KCRwyGEenQw6MroYuQS7++YCxXLNgeOFGa4M0Rg4GuYoMlY66EnZb5ptNApSbG+cIrDVKls1V9q7wO3NnhB0Y3YMI856yYZhqxfyepwzJ1if67wr9ryvRJgtVzr7xdxU5m4+jovs7lG/nTa276Wf0Bse6GC1jFY7K+z78N5gr3v9oWpcnOU3p+9oLnM/Iq/HKS1bfoSsa7BVZqG8ubF1UJT4hBMq4jclh4jLkq3o/e8UiJkzirtEBz5gvh3mzZATNfEltOje++n/lu9iOKARFTuA3A8r8FWJXQ==
Authentication-Results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1146.namprd12.prod.outlook.com (2603:10b6:3:73::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 22:59:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 22:59:50 +0000
Date:   Wed, 17 Mar 2021 19:59:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Diana Craciun OSS <diana.craciun@oss.nxp.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH v2 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Message-ID: <20210317225948.GO2356281@nvidia.com>
References: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <ddaf1e9a-5f8a-e28d-9f19-928ccf9a15b5@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddaf1e9a-5f8a-e28d-9f19-928ccf9a15b5@oss.nxp.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:208:239::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR08CA0003.namprd08.prod.outlook.com (2603:10b6:208:239::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 22:59:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMf8m-00GVHq-9l; Wed, 17 Mar 2021 19:59:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ebd646-8b7f-4700-549a-08d8e9985e1a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1146:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11465B9546F47018EFD2ACF7C26A9@DM5PR12MB1146.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8xdLhwe4o1auqF3FGLZzK9B6lgBlNKbnUpGRe1GT2zu67ni4jNSSgyUcmftU182fNhbKYBOilLf7M0y6SYV5q6kU4IblsHqTlq93PnXzVDwxj2u+ZiiKyFir5wBpywQNCFtqAyXTNYjNFA6Sc0wykVhhamRTb58n/UoBW80pfqd6U7wUWpOKwI8d7JB0h9ff7cIGniN7wLurZO1y6MT275ZTfzWjn8E2hxe06+IBu/MOyvZOusLRs2JoGjHa1PqMzJP2yGWP0I88wiLcKAAtgMn71rC2/RjZXKIvO8AwUuYg7e9bOrysbA38epVLqTbv5BGfPMDJ1DvSxW7BBQe0RyCEApFW6t9Tlf+n6/bGBeTf0MrMZSFs47fN3THZLS41o90DQUDsauHrwAZU1MiKAkTbtlCp2ZLK6LCLf8FiQNrzEA6GqTjKNWH6vbBWs5QL0SJ2ezFfZqWwHPTe7kO1TmzWyCj11gCPyYUCETAK1yszaFWvI11AAF2ZTolCP/qqC/yD3qbtJxVFEz1DlPBcBZ0noeaF5SdEzSi3lrw9byX2Fxdxhw8Oj3/mVg8mbST5/qvYso2p+3AoBGaNmYK8rfh2zIo4ju+3SYBLj+xsu7BnprhVMT1jBrMnkwD/j0yGu0Oqq2acLckzE2cxvGgxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(66946007)(54906003)(83380400001)(86362001)(478600001)(6916009)(66476007)(38100700001)(8676002)(8936002)(33656002)(26005)(66556008)(316002)(2906002)(9746002)(7416002)(9786002)(186003)(5660300002)(36756003)(426003)(4326008)(2616005)(1076003)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9rOwq+QqWoBid23X/Ehn9MznRy/Kn9cbpHsn7PX+DP1d8TcNfMx2g7F2FFzw?=
 =?us-ascii?Q?4iXDeNb03pji+yRmgxCUMILHQzGjVCshKPolBsdYR9dEncLyVwGwNjvO5QpH?=
 =?us-ascii?Q?e+kxGNNOz4l/yjMslTnOZnzYRIRxY7xF8iXjwYlG4AVy42VmlT3eZ7e6AqVJ?=
 =?us-ascii?Q?+Daha0xLp8HEPJAZ+QXgeS9CpmbvMlWmJ+1vHmPeCEYRXLvywn0J7psLlVvW?=
 =?us-ascii?Q?IOR5sjXvxciTc16uXdMoJbbtxUYjJVbKSudyaNh790RfPAjoORGLUVH3klWJ?=
 =?us-ascii?Q?TD1Qp3aDfp/o3F2i9FL4cVcKGdQei5n3T1WqTahYp/ecH5ODtr3JjA2+54kn?=
 =?us-ascii?Q?azXXsEL55SZRzw6pXa0U1wEdAL/WquQncgmzbZfSLMwvirdL2yevu5ZiTqBL?=
 =?us-ascii?Q?eAlbL+XMOcGmAZ4zQpV/pHVpMRML0M2Js81tnzLlFhEYlvhepRbwWx2hYsOP?=
 =?us-ascii?Q?EjXlfHRHwrJ5UCOt9iubkXu00uXeueLY7ojV8FB6TIVQel9dUliDZ6+argAI?=
 =?us-ascii?Q?Cwl11OD7KxpGRRWOTTDr3iUtL6e319lQk5NfLySVjXlJaXoVc2dZq+B4TESP?=
 =?us-ascii?Q?CaFctbKFrpRWvac/RVrERauFxBZpNMcBufktTYEznNixtdRsLGoxWu1bP7IW?=
 =?us-ascii?Q?qLeumhvSmixK6hmlCoDDJVibgnTjWiZ+8utTm33NzbIUDl4k92J6U079w+sx?=
 =?us-ascii?Q?jTPOf//VbYuAN+p9XGhqOCxAi7Xb6t1Ejbei1PMffYv0C8s7MdEajlp4+SAx?=
 =?us-ascii?Q?EmiMz9WvoL0ORQ8+yPCd1DMlKuKDq14aQlCnk06kDa+/hID+yNbw2scqLCic?=
 =?us-ascii?Q?4CWsoDcDa4IFRXTL+ueZmYl4tJlTG1aI/S4XQGJJKCDfY6KyfUYD3Jwna3fK?=
 =?us-ascii?Q?HtnnbHqvfvQ9ViO0adQhHWO9Nj/zCkEaztmrwKYBLWm8Cwk6l63TbazIbFK9?=
 =?us-ascii?Q?+36SEqAg3IkVz8P+uog+swZU1DBWhv8EwiCerl3ZPUdasG0YIQUOz9yJifq9?=
 =?us-ascii?Q?keKvk6AueL1Kn3WMR/gEji6RR/uT2UrwsrwkKk8Prety6lqO+uQbvGV2PenB?=
 =?us-ascii?Q?IUT+fbDZBqOIfWo/sPwF8vp4jSzhYJS1nu5GtupDu2UIlV0nWoNoOUzcx4ih?=
 =?us-ascii?Q?W3bZtwoEXbJy9ubtfoZltNUD9yd/1/TmZt27+2lv8TZq6h8YFGObslsIekBJ?=
 =?us-ascii?Q?epNKE1xN0g0DqTKgpD2iStSdo0Za6wxn9D47v9xaREUHaSfyVloTZGv/H89Y?=
 =?us-ascii?Q?eY8sPiwF2rnG/T48iLX6VpxUtvkKftcTlKHWjnT6iLYUkB+WS+mTSIG3QiSM?=
 =?us-ascii?Q?D5GXA6MKw0//n8D77OnfY6/5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ebd646-8b7f-4700-549a-08d8e9985e1a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 22:59:50.4575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAMgMXIPgvUUdxF46duHCrUvLrAfd7j3yiWn5IMenQ5t5/ke/R2IjoN4O4lGrI/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021 at 06:36:09PM +0200, Diana Craciun OSS wrote:
> Hi,
> 
> Thanks for finding this!
> 
> I tested the series and currently the binding to vfio fails. The reason is
> that it is assumed that the objects scan is done after vfio_add_group_dev.
> But at this point the vdev structure is completly initialized.
>
> I'll add some more context.
> 
> There are two types of FSL MC devices:
> - a DPRC device
> - regular devices
> 
> A DPRC is some kind of container of the other devices. The DPRC VFIO device
> is scanning for all the existing devices in the container and triggers the
> probe function for those devices.

Oh. It ends up recursively calling probe() under the same stack frame?
I don't feel good about that

> However, there are some pieces of code
> that needs to be protected by a lock, lock that is created by
> vfio_fsl_mc_reflck_attach() function. This function is searching for the
> DPRC vdev (having the physical device) in the vfio group, so the "parent"
> device should have been added in the group before the child devices are
> probed.

Yes, I understood this part, but I didn't think it could be invoked
recursively from vfio_fsl_mc_init_device() :(

> I did some changes on top of these series and this is how they look like. I
> hope that I do not do something that violates the way the VFIO is designed.

Well, it is "ok" in that this is only about the reflck so it doesn't
appear to break the core's assumptions, but I don't like it at all.

I also have a later patch that revises the reflck search I now see I
will have to throw out.

I think it would be better to find the reflck entirely internally to
the driver than involving both the vfio and driver core in the
search. I will try to write that later

For now, this solution seems OK, I will fold it in, thanks

Jason
