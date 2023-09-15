Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362137A1659
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjIOGqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjIOGqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:46:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A52268F;
        Thu, 14 Sep 2023 23:46:14 -0700 (PDT)
Received: from kwepemm600005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Rn4QK1BPZzVkxw;
        Fri, 15 Sep 2023 14:43:21 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 15 Sep 2023 14:46:11 +0800
Subject: Re: [PATCH v15 0/2] add debugfs to migration driver
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>
CC:     <bcreeley@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20230901023606.47587-1-liulongfang@huawei.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <2fe9278c-2480-b718-8958-b52fa5c08eb8@huawei.com>
Date:   Fri, 15 Sep 2023 14:46:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230901023606.47587-1-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.121.110]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/1 10:36, liulongfang wrote:
> Add a debugfs function to the migration driver in VFIO to provide
> a step-by-step debugfs information for the migration driver.
> 
> Changes v14 -> v15
> 	Update the output status value of live migration.
> 
> Changes v13 -> v14
> 	Split the patchset and keep the vfio debugfs frame.
> 
> Changes v12 -> v13
> 	Solve the problem of open and close competition to debugfs.
> 
> Changes v11 -> v12
> 	Update loading conditions of vfio debugfs.
> 
> Changes v10 -> v11
> 	Delete the device restore function in debugfs.
> 
> Changes v9 -> v10
> 	Update the debugfs file of the live migration driver.
> 
> Changes v8 -> v9
> 	Update the debugfs directory structure of vfio.
> 
> Changes v7 -> v8
> 	Add support for platform devices.
> 
> Changes v6 -> v7
> 	Fix some code style issues.
> 
> Changes v5 -> v6
> 	Control the creation of debugfs through the CONFIG_DEBUG_FS.
> 
> Changes v4 -> v5
> 	Remove the newly added vfio_migration_ops and use seq_printf
> 	to optimize the implementation of debugfs.
> 
> Changes v3 -> v4
> 	Change the migration_debug_operate interface to debug_root file.
> 
> Changes v2 -> v3
> 	Extend the debugfs function from hisilicon device to vfio.
> 
> Changes v1 -> v2
> 	Change the registration method of root_debugfs to register
> 	with module initialization.
> 
> Longfang Liu (2):
>   vfio/migration: Add debugfs to live migration driver
>   Documentation: add debugfs description for vfio
> 
>  Documentation/ABI/testing/debugfs-vfio | 25 ++++++++
>  MAINTAINERS                            |  1 +
>  drivers/vfio/Makefile                  |  1 +
>  drivers/vfio/vfio.h                    | 14 +++++
>  drivers/vfio/vfio_debugfs.c            | 80 ++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c               |  5 +-
>  include/linux/vfio.h                   |  7 +++
>  7 files changed, 132 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/debugfs-vfio
>  create mode 100644 drivers/vfio/vfio_debugfs.c
> 

Hi, Alex.
Is there anything else that needs to be modified in this patchset?

Thanks,
Longfang.
