Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7D26464F2
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 00:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLGXUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 18:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiLGXUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 18:20:49 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C63432051
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 15:20:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5q1Qccvm7mdpr6AXO7yeAZYRkTe5K2j0ZO6IlRrmFV1x8xfvK+f29HwamsMELZK9FH6Y/bL81xFKYcjDCX6EIk0Hw0Tiejj5Dao56RU2OmgqT6pUVLTaBCFnvG2t0jcZiOX+P58Jg5BZQtN+yWRiefWh+A2gdEqnQJqDV3piSaSVcaF+NS+R3bDZ+tYJzSn+V+cA+NtEt0ce237NGO+Hu7UA6s6jb0yqqlC/QQKL4VUpY9qeSRkw7t9DwJEX0Ari2hvP0jDdGE1jA9CWF8WGKpkjHHmIuCtYk8CIQTU1ChtzFaj+5kazqnFmzQ4MbJ/NqO+l8ztGCS9uNh57VxxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kz5xrDsFHev2U5anUIR7/pNZZsIW1kWEfTWQ/PzKDAE=;
 b=KJm40roihtgxzPJ9eQ1/ZkCjYRIGzKLx75NCdoSW8N3v6W/hECrm6+9IR4c+yQ0KgnhPceBi9hHSu8Qwg8a6hv0MCx/69aKD5TF31uigQuoIezyEFBCgLLzvUh2qQp6oqc+bIXOF4YKhBmxWwx28D9mGutLqadg0h6u1bqtxArZgNmlz+JZCH7hLXIaJHBZ95TdY7BgRp41nIxX5EFwexfrKwtSmMvxft1je1SoGAVw8N6aO19IFQjB9iaT4J+XKvL291DzPjui95785NM2xY/dQPQpwvKK6AhWzecIklr4ZyycDEjdWkERix3VAY5Nj4d1YjzmE17nyRnFyX4sD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kz5xrDsFHev2U5anUIR7/pNZZsIW1kWEfTWQ/PzKDAE=;
 b=uKTlJBPACdIxnCRgQlkm7dVg17rHb+GhKSugJDp/oiIy6kaX81NyU+eyyU5msNd4WZXdyk6kU3IzdtyLlq6di3dEds1r/3ctnnXF29PXoQDz9Ruy8ITakGpGn5DREyvOPGdtVG1dj6jl1rl+hS8cePL+zpZIUsBumhFGpiHIDX1xJKR/CW+ICkw4U5px0OZ/eq2KPonmSuBuCpZuW70OhisIgrOTFHb9kRjUsGdLiOmSwgD19uTmzRqy0eFR3gZ9TlhYIqfA6/MRpuQniOQgA8jbfgaK12y2/f9VzAtBH8bjqj63WnKp5GOiytkkByuBpSQUR05qm42EyH6KNIkpoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6555.namprd12.prod.outlook.com (2603:10b6:208:3a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:20:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:20:43 +0000
Date:   Wed, 7 Dec 2022 19:20:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <Y5EfyiYZMAkwUTan@nvidia.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: BLAP220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 851d41be-e7a2-45de-e88f-08dad8a9a97c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixciWjjiGDUrysnd8N/qHXsAxQN2sOQuGVURy60UzoUFXR/AiWPvFSrHpIjhfU0wlA032SWC/UdXm85wiRiDgBJ/PIuVm6jiGJnWH10v9/QrReWHDK5LgyNQN/eVULCZx9H+XDwJFNOq5XBvljSCzStnerU+QzvjwC1JXovK9GOs5wYWmKo3cTJknxmCJ/I5YgiyGVrWxYuEhsouPEwfYJAhpGYBEMZmXyourL9a6BErcwknad/sH3xLMJdbLUcdwryipoa/VifWe2oZptrVt6gHZYV57dPAiLz3NK39UKoNNt1VQnrrJjbgMQ/9gc5G4hudtybJBMA9gBEeIMW0s3RTC+gjKPMFLo1neilXfI1bTilkmqHx131aK33pHs+yBLO7R3ZmscvIwLjUHIcSVvbBN1xjtCBmdbrRkjSnDCLreHT8nM6R3CLtahzskG/E/ebZB9hSw6FM9Z5fiFykDHOyWFlh/sjkOexFkmeQOsJUsGyHrOKWseDWAkAuWt1SAfd4ZrV7+TEg5MssRMoJ89zmPDLBOYkyBMCWXeb6TeGXK1D5PE90Nzt7y0u1qWROF7ABm0FvBpQQrELQKaCTAIIiEaU+DCCSX8oDHxf+NFJ2wWinPYRIK19T1E+6P8V4WsXOU3P4V5xb2kP/8Z4bCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(15650500001)(2906002)(8936002)(38100700002)(26005)(8676002)(66556008)(66476007)(86362001)(4326008)(36756003)(186003)(66946007)(2616005)(41300700001)(5660300002)(54906003)(316002)(6916009)(6506007)(6512007)(83380400001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yL1yckKxUF7ZrttXakgbSlDOIInie3mL+ywbRvxcL4WtlNOn08/2sY5iRqd1?=
 =?us-ascii?Q?0yqu6rwIzi9HfePFIzt59NOic5zWIiWN4J8s00ihA0w/Jgy4+Xg6cG/0mDDe?=
 =?us-ascii?Q?v6P1esu2ELOuIj3PKeoB1psBxSzjx0XlR0deEDS2yQ/ts58n7G3NoWB112sn?=
 =?us-ascii?Q?sNzVYQMxnIIRp3m75jmj0uaBYiQ64R/ALfiIRw484V468sBLRAWqzti9A4Ok?=
 =?us-ascii?Q?JonDnw5l2VjlfvWPl/n8rOxP+Am8PlFZYaK5EjlQYvlwR9wSAQhfsxmWivdV?=
 =?us-ascii?Q?PDR6bOJi2qipNwlw97Cu5UXsbVd+qm7109QFdTY+SvqAYPipAcu+nsoIX2Un?=
 =?us-ascii?Q?yL63MGqhVN3+41UHnlfA7eamumRe6UukPCnP0gwNoYx/wlSj54M3JuGLqHTd?=
 =?us-ascii?Q?rQRWi4lLvnkwHhy2jTMhVoKLzKmCtTolt0UArD2+8GlQdgVUPj83D2yT+crj?=
 =?us-ascii?Q?BCbhd7dWTuH2xXzIbKl4xQHZIsuwzDuoPVjvT5brfYbR7kw3Xp853YCVMjLM?=
 =?us-ascii?Q?vHRST7S6HoAAwFJ+RfCl5GL+cbuuprIvNktC50zCBCB4F7ETD4iloFZyRvft?=
 =?us-ascii?Q?LPqTExOXc3ypicEbyRuVjphvaG/w0OW3rqOjxLs6tMY4f+OAPauXWdVqe823?=
 =?us-ascii?Q?d9BnQ31KySHGwcW2DB7RBVOc/vhqd7rnb5lxgmj1Ro8tUF+yjLf8p+4NfBq3?=
 =?us-ascii?Q?f8VhWDzsxvzXRS3in+pM8hPm7LPVB645STiYBZ5XRUjhyWy0fJN075NDYlBI?=
 =?us-ascii?Q?Ce3jWOMGNd/8DVOFgc0fIshd734zKTa8o0d1zb0+5D3oIKQi9i+dOXCedW9x?=
 =?us-ascii?Q?sNT+9DXye0/n7spITigHascWeS3GF3JSewunbDOW3seG/Idivd/InwuXV8sr?=
 =?us-ascii?Q?mP67baFXl4caL+H4PQ8TGkXnWdxL5Sm/SqQzTDFJ2htGO1UwRBcnKOiS345m?=
 =?us-ascii?Q?pbZZSDLT+W+YUxBnj43ejnyWkhKhwSTUko6YdO0iw1bOKu7T0XZBx9Yg640u?=
 =?us-ascii?Q?I47ZI9WBGU3yV5Nal/5J8Aq15qPcQVdnAWUeep+nXgaOy1UvxScsct5dTkgy?=
 =?us-ascii?Q?3Tpe6tb+AH97Z8UNpLjMn3MgVeirH6DKCnpyO8eAigX9jmveVgyG2wuLxpv6?=
 =?us-ascii?Q?uqxOlhkMP0Dd6ox2binyCAK2lIdG9giFbnNl06rVWfY1co5dZW/zypZy5KGf?=
 =?us-ascii?Q?u9/m5hYCXTU734TjjNmgkgdGVUGsQ2l+7/eoNEl1KiW2BhsEgDIFMEtiRs6v?=
 =?us-ascii?Q?0t1jAFqGJnLxAwv0Dr6kAgex0TjjqPfNPxBjnQZ2QlNW3sxZXKdnH4rwbfnT?=
 =?us-ascii?Q?mKgXcq6wgnhub6XCpwU7cv9wIR37UM4/U6Jysfr5QV8rup0ZFMHQ/rWHtPnG?=
 =?us-ascii?Q?/y0jsy598IBm5ENXUOhb/haFWTMFWmO2CI8+VzNjKZjmkIzGjqBNFyzyKQVn?=
 =?us-ascii?Q?1ixCvimzaJqkGLD3SnL1taigz+rfqT4cVKEq6+PUpQAaWTij9D0uVMH7wl4P?=
 =?us-ascii?Q?7Zz1NV1hmJ5+2qdBNI0gQ/vPURpckKUGwXusL+zzWkzxIJiZCYYxwRtSZFQF?=
 =?us-ascii?Q?JRaBqlrGF3s0ElJUIZE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851d41be-e7a2-45de-e88f-08dad8a9a97c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:20:43.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mp2mlez4pOc7ph9ynGxNQlk9JS3X/RPe6PfTRBZZGrpLkmrPGmbbqvBSVVXN/yZ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6555
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:55:46PM -0800, Steve Sistare wrote:
> Delete the interfaces that allow an iova range to be re-mapped in a new
> address space.  They allow userland to indefinitely block vfio mediated
> device kernel threads, and do not propagate the locked_vm count to a
> new mm.
> 
>   - disable the VFIO_UPDATE_VADDR extension
>   - delete VFIO_DMA_UNMAP_FLAG_VADDR
>   - delete most of VFIO_DMA_MAP_FLAG_VADDR (but keep some for use in a
>     new implementation in a subsequent patch).
> 
> Revert most of the code of these commits:
> 
>   441e810 ("vfio: interfaces to update vaddr")
>   c3cbab2 ("vfio/type1: implement interfaces to update vaddr")
>   898b9ea ("vfio/type1: block on invalid vaddr")
> 
> Revert these commits.  They are harmless, but no longer used after the
> above are reverted, and this kind of functionality is better handled by
> adding new methods to vfio_iommu_driver_ops.
> 
>   ec5e329 ("vfio: iommu driver notify callback")
>   487ace1 ("vfio/type1: implement notify callback")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/container.c        |   5 --
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 144 ++--------------------------------------
>  include/uapi/linux/vfio.h       |  17 +----
>  4 files changed, 8 insertions(+), 165 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
