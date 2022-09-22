Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9675E6BA1
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiIVTUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiIVTUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:31 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59751AA3D0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgxOGseLCy7GU1uHah6MRXEJODOJ0mNxdtbGDntMWhoCwXSMYmaLhL5pFHmTlzUotK4e/5XtK+/JVBNfckmUaxPTNYtqKJfzrxSLQ6CO+9WXb0DiZlKi5T0UkPfD3+52DNeJRxVgyldnKlCMq8X9+h61EPQJkFZevxxijftKdzAV0m2hGm9Svn+VZhvdUkNaa+HSD7SBAR2IX1niaEip/125WlU9EwkrP45DzV7I9C8eFMf/la56OCWhWOVWrvPSAP+zZo3ijqHNdhmAWfaYAw86TmZhKkSF7W2tjAL44F9UBJ39jFE2s/zn6dIyMW/TtEfiJAmilKwrDGfKsymkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRhwNDFNXxVNw50WlXdWwzXcqRREoYBpjSZIiSEwZZY=;
 b=AO54LdzaW7nX5mfXSvpVWMyogddVOn2zQwdvsw+3tfwFK/XP9a5MrCWtgzmGnQnNNcwy7tfePjKEV65L0qljCtdwJKgbriN3bX10tT/y1A7efk5B8Ifc8t2V0xS/HKLpvSh52Zf70DIeWCLkUIaUiw1x7FeP8wVYc2U7DXBccciEAuAkKXwdfNyOZbIj1qad3OiItexSnHHxigtH4VDAlQUGigu9rHAViTPUwT9v/FT3s2tcfY2l5ErSWchtrQ+yxhvlofLiCF43shgC3pQU0UvB6TUfczl1ppLNnoY9oD6Kei7+D6O8EBHFLmAIIjX3APE49l2RLtwa6eDGz4j+Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRhwNDFNXxVNw50WlXdWwzXcqRREoYBpjSZIiSEwZZY=;
 b=tcy3aDjELUoVL5x5Kn5+F2F4932+7mJOIPoknUrs0AMpFjkfzbQ1Mjb+Jg8246OgAW2OimpNS744oS7M7u+P5FsT4vc6DuH/ClbVsgdiqw8ofUAQEvPuDkARAg1DOprS58o1tHJKp+k9/Tur+bzyV6Q6O3FtkbgE7neRbcflBhb0P2Huxhrb/k3RhGIuvvV7O24T8U0Og7pl6BRcGEQD2OSNItBGwX6vc/UP5l8XntmL0CD3quH5MFAm/88W3/5cFPgvsjGLdaUXUaYBXIsAftrUEQx8tlc7Ch6QAMZRXDoDxnBoVpziw+i+4s/bsvYxC+AYAv0KSqcmdmFcjxfLPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 0/8] vfio: Split the container code into a clean layer and dedicated file
Date:   Thu, 22 Sep 2022 16:20:18 -0300
Message-Id: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:208:32a::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 14207f34-9d15-467f-63ca-08da9ccf8156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Qymg/xAIwy9td4Ujsu45EXR/6PdnTiTux8tOZpLjxjCebyUboiAhMJUaUJRiipsPH+EJ7FOAGjNiHrDh6z848gjF3oiSG/GV4F12dXJ5BpeZ0zjITXOT9wm33F3vBIT5lCiDtOV6Ht2gLBBzjPmoNPe5EBvv48ZJWNkkLYrXzuKyP/aDKuqtVdjmGS/zusZxlt6N9D8Iw7VLbakdcoMRNzPCX26GBkipPGEaGmjfeO+2pxPpgG32hc+2ldH3Ok3DGCK0oE7PhIt0K8TTnu7JGQK7ODR4dORYpcEmWLsq0PAL0kMKQW1An5MQRIz8dDSfkpu12CR9mxONTLYZx/nkrLtTeVTghEdZNvz3KwsjdVC1bVLyEqFKzNpl3rM8UKS0rUVKJjHTuvE30aOY7IbpIXoHOm9hazXp2aIr4eVEpALEvpcd8VRqfU4/EUr5RK37Lj23IFqhalu5EfU6wrcvI706eJ1GbSR2EHyYomlDEEdkZmfk39k4N+7TCQ9JjrD2ducBloDqbhNXNTlgJcDFVmZj+ZiqVCldV1BELFantINhC0iR4eq1I0GhxitpinyYUTK5nGvNtEC/gzDH/5ayJtd30mYTUYyTkI06BXshE2u0FGfKxURp/TezguXqkZULnvZqPdRP25MxCkV11UClUlWgHFICbf/tBmR7k7lbAwNGRdqwN+67JUOoW00vOxbhR710Ly2N5iIN1eYjqMb6bpkH9uRH9uLCQiG1EKTOsbqFxBvld3OBOLFm98jL9DLGfjF9ThaPUT5a9cxbUeE3UwV6Tz55I6g8aQD1Y4xx5/HtUYvnoQOZIGdhC8aMspl1sBjl/tra6ledDQMkxorfErGUYb9V7lMbKWtzyaqYvzLsRChcOLvPmyMsjIRJBTL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(6506007)(6666004)(26005)(6512007)(86362001)(4326008)(8676002)(66476007)(66556008)(38100700002)(110136005)(66946007)(41300700001)(36756003)(83380400001)(2616005)(966005)(6486002)(478600001)(2906002)(316002)(5660300002)(186003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0HZhUCulxOjZvc958KKtngeTaKO1rpwI9tQqFvAVfVDT1f9ulKK8Pkysu2B?=
 =?us-ascii?Q?fnT0HBj4wdJG5z4y78zRIgtTxbQRgDbNda+UAylAClDvgdeXGo3xinr/+SLH?=
 =?us-ascii?Q?EnvY+vy51niOUWTyuDWrkWsoHds1EvPcExTqoTHXuLxPH7UUxK+nOoySJeyd?=
 =?us-ascii?Q?h+GUvYF6ajje3KG237e3baYWPUOZJL3fwiEKlzsx3syJPAopP7YRKpr3brJT?=
 =?us-ascii?Q?FiuhCWM0ApRNYXr4JHDCsgThtsauwqPW5gQlT85sPhGvecm4M+nwpUAX3Pdc?=
 =?us-ascii?Q?ondm/+KTWOCESzZ4XO9HyDr+cd94R/pSx7UgbIDLgIkDpTzVxW8OtrdJ7SLV?=
 =?us-ascii?Q?xpzk4pzASf1g6mxhLmPZjET4+/2LqE8DmsZxEHHYmXFMKGqj46uKKg+LkX2h?=
 =?us-ascii?Q?bunglvSEh9B8j5MRkN2gD5bVnO8wDtfsl1zgfyLDvYBLzUBkcVTAmUqfSgW/?=
 =?us-ascii?Q?7l6PjrrN2Qe+pQy3CrH1k1MHoO43g4KR6NjDoRP0i4sQvnxggs221dk2vTY1?=
 =?us-ascii?Q?4pbzBXskZxFzC6KYP61QPIisUHKQ8xHgA0o4jmhBGRbTx6mCUgS+gF8eNFj1?=
 =?us-ascii?Q?Imo++qARHiC5hc1Ipblqyf2p1qY0iKbn7FJS+0DokYv9qG9fe8IKe8tVQVgQ?=
 =?us-ascii?Q?h4mxPgDw8rF4m/H372xFTMKfVDgOCAUPU2gg41b/VD53V9tv9WwlhVS0FVr3?=
 =?us-ascii?Q?IRDbVSfER4MVDCPavWo+zKIOJ+YE9eWtdj6Rsx8TOxGszyDZUvE7XQCxmROF?=
 =?us-ascii?Q?1eZ61dxsJ3hLg0Lv7Yn8YtMYi3IvIg+MJdEAND9mGv46Oav2KnIVvzNNsLlx?=
 =?us-ascii?Q?Kllz+oVui6h8FRvJL6uVKTeinbdwqTc6LtTDzw6QMUuvBoDfQZwg1ZjvEexv?=
 =?us-ascii?Q?t63LoMbYeuHTuQRQad5vwemrhQyC0kUtFF1S0U82n/tNz0OkyHmV828hqLTk?=
 =?us-ascii?Q?9NPxjvWXFuf1KQY5G5khe93YQb89H4xCyKh5VeYaC3D2GDATq2vqJsU+QVkf?=
 =?us-ascii?Q?DWHrS28rc/gb1wZbPHNjCC2kMZsBkXdin/21uXFN4vd1L20kfCH4NEIkIMN2?=
 =?us-ascii?Q?JLUQbtzR7cbhspByChsrDdAX/NVtLqEglXyFBV2tl6+hgZC5Z5lpfTGkEDcG?=
 =?us-ascii?Q?RAGnNEXbHZdbLpDxEshMfAB0nH5Lfzl6xaT/tSnnO9NLBSYwod1q+Qgn3wlN?=
 =?us-ascii?Q?LBeKcmGXOoMBawMZVo/GPJ9mKXJ5KKec/L+vWNxRXy1BZ9buVG1Lij55vjke?=
 =?us-ascii?Q?sqKKSgIQsGVAtqY7b9FJr5EME/fIqpBY+CQ8j8RC6UMrbivyFjulPzTpwsTx?=
 =?us-ascii?Q?1ksDcQvtVmdP9ZtXlV7+m/1JZjd1T17L82UJ9QpfcOv1bhMkiFyVeV6yhK0i?=
 =?us-ascii?Q?ViGTn/5g+6LPgUVAfI79SRE7oxz0mnSmMLR8+geHd4sv5cb7ZfHbZZRsz8V3?=
 =?us-ascii?Q?FbevXaWbCE2po84luvk8kaE7hAvLnMKpNbUhNgM5zcKGGX50B4obkN3DLFve?=
 =?us-ascii?Q?xaMZWnGWCv6Jcosl8QVAtmpE3vNmYvmAIl3H+lWt48xsolbUJsBhU7/UDJAx?=
 =?us-ascii?Q?YyvKvhDiRO9zsZG29ldAO9iRO9fAp9lhOCYftv9J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14207f34-9d15-467f-63ca-08da9ccf8156
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:26.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmB+PafWmARCVtJUBX8XxP6VpC6QVJwB+0Vbuw9ouGSRw+Pe7Faeaf0LrGTTRT34
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This creates an isolated layer around the container FD code and everything
under it, including the VFIO iommu drivers. All this code is placed into
container.c, along with the "struct vfio_container" to compartmentalize
it.

Future patches will provide an iommufd based layer that gives the same API
as the container layer and choose which layer to go to based on how
userspace operates.

The patches continue to split up existing functions and finally the last
patch just moves every function that is a "container" function to the new
file and creates the global symbols to link them together.

Cross-file container functions are prefixed with vfio_container_* for
clarity.

The last patch can be defered and queued during the merge window to manage
conflicts. The earlier patches should be fine immediately conflicts wise.

This is the last big series I have to enable basic iommufd functionality.
As part of the iommufd series the entire container.c becomes conditionally
compiled:

https://github.com/jgunthorpe/linux/commits/vfio_iommufd

v3:
 - Rebase over the vfio struct device series
v2: https://lore.kernel.org/r/0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com
 - Rename s/vfio_container_detatch_group/vfio_group_detach_container/
          s/vfio_container_register_device/vfio_device_container_register/
          s/vfio_container_unregister_device/vfio_device_container_unregister/
 - Change argument order of vfio_container_attach_group()
 - Rebased onto merged patches
v1: https://lore.kernel.org/r/0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (8):
  vfio: Add header guards and includes to drivers/vfio/vfio.h
  vfio: Rename __vfio_group_unset_container()
  vfio: Split the container logic into vfio_container_attach_group()
  vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
  vfio: Split out container code from the init/cleanup functions
  vfio: Rename vfio_ioctl_check_extension()
  vfio: Split the register_device ops call into functions
  vfio: Move container code into drivers/vfio/container.c

 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  56 ++++
 drivers/vfio/vfio_main.c | 708 ++-------------------------------------
 4 files changed, 765 insertions(+), 680 deletions(-)
 create mode 100644 drivers/vfio/container.c


base-commit: 3c28a76124b25882411f005924be73795b6ef078
-- 
2.37.3

