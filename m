Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539575175CA
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386626AbiEBRfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbiEBRfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41C525DE
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAPOYSk+Go3BPGs5dXF+RC+3pjD6CvhMSuw9v+Sp8044EqQxnbb+2r7+j1dCbgnjp5FswSRGj2IyQrZingek/uScmoLzLt524ZZEFRBiyv2CsVjX5dSRXYnwTGB+TB7DB0WLj/d5j+eIhb3p3Rwu7Y/WeOik2weJSbz7oU09lnlJCWoxSSRvTUJKdBMCATofs+5zl0DyBuUznQsiYunWJHaEPj/CzST+XCUpRwH/f/r5C5aFIGj/mAOxbInLAjGm7JDzJ/kdgE5p736MTdFq/UKv8M6bOeG+U4uYpWfuyGACU21wWaAXHiH1u+9X8pA0YB/ZsRQb65hyGj4UZrgZUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxkw6ngOoKhBeljMSCyxFiBHUNL7LuPdLA/AyaKtltY=;
 b=QDb5wpHk0OCvGvvSXwz7zm9KBRWjzeRkRZGlJ9bFNvDjQ/sGLvea+iqhI3oWxBhowXCWOkJlltyQCrCsz36lJIEl6N8UuQNhcAQEswtewTQ8X6PodS2OhXCdQ2bl+SEe3GPZnZpzRyp+ff11KLFzqrIPCPG7QoTIJQz3aLKID3N8uLCACTdF2pA+Z8rxwI4BLj/TCqlNueKsKOaxzes/uIOYdIXNHSc4eniQ6l1O33nYOLcEwgXMwQ4jQM5ZsomdLraXdnE2Rn3aAlpIqDtHoYyYaQHzkBcXKP03LbxPAQUJdTND6kac1qCcAbxauZxDbZTNdW8zrnXPyyfJ03qO1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxkw6ngOoKhBeljMSCyxFiBHUNL7LuPdLA/AyaKtltY=;
 b=lBFKojqtqJROlaFsVq0qD0fzQBBZ2sd55Q1Of71de+LJsn7vSWcn+09riP3Sa1CUCXpJc7WZ3eHFRFlMgh7EOQcIbhEzQ8YsHxTKJccKjCj+Jsz7KNGjzVSc4OMyYcTa3DiAJFgapxgd7MwQBsFRKhes64fm6eEOL3/Svw7EL3HfB69HG21xdcOk3wNCWtIiAg5OGT1QHPOHqLYKtZv7y7PHdHQd3le7JfIhPMCjWlZPUf79oy9MyJ05TLa2ebfTgN05OT4PA3gP67HonXlOo+vMW4/0MZPYsfWnBfzo3Iac7B2Fx98hF2uKvDnmuNlG3vbqeASewPu9gkAK7ZdJmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 0/7] Make the rest of the VFIO driver interface use vfio_device
Date:   Mon,  2 May 2022 14:31:30 -0300
Message-Id: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:208:23d::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320fb102-b650-4b68-eed4-08da2c619cbb
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB54580BD6CECADAC827E66E87C2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvSVZvLqeT24a0mrru5+Db6LboD0hpUmR+fQD8mmsrNvVd6fBpa/dCioF4jxeEL9JQq0xWj3m5cyth1EXMjSEDwlrHpwpLkbC437JifbV0myYt6vYxBWDvUJNuoAcdxfyRTOnYlW8p/vOUmTEJAwWAsgPfc8EF/OnlAnuecjk5NyTavaosPWgbW13tfdFXX7iMEVWDsYsP/OcyxfbGVeW00EjQ32jhVWtTHZQZFJsWd/HqLEoYb4LdiCzWtqpzJ3AakT/IVQ98lmNG0FLOSeY2+jNJXIALJD52H7h4bLjN2PMUwBL0addmWtxv/YFa6N4Stu4DSm7rsu/n7hyQCW5+RLynVMGEjLTEOmAyMCnJaE1oYtLt+b3gfnGgr3kp4H9ud0gt+I8CShwDjjQuwX0UwiCnFCbAkbAKxcJXEwbCoe1SCEiL8wVOKFE6lMeLFX8AoNLsJkjFcP6zvW7DslbTbNeXPZ9UEsbPmsyoO/b0EborffJfCzgrXMokqj2xV8U/x495PRdkD4rc8sq3YtQ63M/i3d8s5gKOoTgDHrNE1vrxEsQYuJuXfBh5hgOSAkbUFZw7SeNpuKSGqn4KDYnnh+OEXqK1b7SDa6fy9YIHRHTEeEHh/soCCWNh23/Du+6qRa6GDlnl0RKfWZ9XgnW4RZkirPfzC4JkUMG6qRpWJbb+bTfRlM2WzkPqEhOXkSIRTSDGZw6QVAlRroX+GvJG1CXojsHOZVuJjHpvPe+3OXgRexFiFgxo2Q3F08tM3ZhJ/6Vc6+VaZ8lzOHZ5rT4uqb22kv6wrFC6tGMKW6ap4mWXaulUVl19QCbgTrFUp1CVySS+AAM7zWOEmXvwBzsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(966005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uI7WPPEpsmsEA7FTy0OOypJ9Ypf4lsoJgeSi4HiBYJvvIIVk6VtJRXFdY33V?=
 =?us-ascii?Q?19Z1RxiReji39mqAzXIZsenmKILB+IxUi5Efa8mAsJmAFzOyfJMz3HRF5dNr?=
 =?us-ascii?Q?K9s359GVsp52ozBD7tKJrzINnpiBA7IZz29FdvmWdZzLOPuDa+dM6LD7DOj4?=
 =?us-ascii?Q?cBKTMjmHrFwCFD242UVx9AeZgK9nwKGeLzfFT41c9sYsOOUvY34vwKmxgmnt?=
 =?us-ascii?Q?GrlthVeuraItc0wQpXxrG1CiKm5DZFAedEnE8rELeVTf60bK85YdWGKKa5ON?=
 =?us-ascii?Q?xKeGkDgZoTTfrVZetyl8SK/hg95VOMeV7oMTrfjYWUch0FluWpoUhYnnA1Hm?=
 =?us-ascii?Q?xtL1ARvNP72NcLwCCjVWa1nfLAvobA7nK78itke4sIGEhGxwE3JtAgzeLtfX?=
 =?us-ascii?Q?UBurRPEMfr4gIHe2c9ERanCotTQZm7+xeEFA3CGsubv6zhKuxKSZofw3il9o?=
 =?us-ascii?Q?F6MO+6tGMSGitTZ2t9PgBrr0zkFxsipGsIvHo2qzU9F8PTTSSNRm+9bSq3Jd?=
 =?us-ascii?Q?4WiKnWHC4kEEFLJZikRrfqa9RN4YQ4j2UHlpHALyB9FZfS3i/lV25Ngvv820?=
 =?us-ascii?Q?heo1qcHcal+Uc3ndovK1esLQpPpZsfCez8VdDfpVpc+QAz4KzFqEmAtn53Dw?=
 =?us-ascii?Q?Jux6EAsYohuUMXUCaoNRBsG9tFl/Ci9yVfpQpE3RHyK46fh4LdqZEqwB+zE8?=
 =?us-ascii?Q?uU6JfoO83R9GRdq6EBPuEaJGXbpOr8kiYxoln4FwC80Lgm+SsNom6LmlStEY?=
 =?us-ascii?Q?L8DLQSj3PPbIvsCSyOD9a8ZlKhYSaSxDodx0TFP3zjwI4soE2Ssd/VXidN96?=
 =?us-ascii?Q?2uexXDJ/6qwmT6/k+ZOP/QuWWVVcOEY3NZ832y5JxLG8oNJhskZg4rrN5v4F?=
 =?us-ascii?Q?0b8ee3jIO2oy/q7sr16GjJcZiGIjmcPlWlzZ8rBUMfJVGq3qQlZ07PCN2cCn?=
 =?us-ascii?Q?u8D7MIrE829pEHn4/oTllIU6onJWtbzHbZLg+wHX1yOl3JAezNyttA6IY4TA?=
 =?us-ascii?Q?MeXg83GAttWdDZOU07Blom166ax3gMZCj2E1ZvqGqTH6NWoZB4d/gz7APIoV?=
 =?us-ascii?Q?4dzkeHIW9c36EeyGlsBq/plwxqV6OGmUXyLO7wj9BMCUFO6Q87UQSabWWtlm?=
 =?us-ascii?Q?8+RauKtbbnOR9tXHN0AUfpJLa2HMKZCWUOS/1AHixbWuHE5gLWSY8XMG5/hu?=
 =?us-ascii?Q?79h18bDmLL8AbGIMEQ8rQ9YQ2xvQKwH/obIh5vbpexGpWggyHyz1AvwiOuex?=
 =?us-ascii?Q?dP5gHKj7mciJvJwZ06x/VlNVz9yiVdw/6n9+8MGs3Rqeg3Jxrs/q/iqarqO7?=
 =?us-ascii?Q?NOVwFzlXwmWf/m/js4Z9oUS3EYftiqSehuXIYGWwaqm4mZNR20VC6bqJOTrl?=
 =?us-ascii?Q?61rm1NUARhhtcPIXtOmFU7VXwq5zTZzGDdBouUKhdTIgNrdzyaET/ohvoRgn?=
 =?us-ascii?Q?5SCs1Kq0BDdljbHWrqKd89Kdzc+9MN/Dy8Vp7TkWmC/87uD8fbVO1Y3aiHXD?=
 =?us-ascii?Q?1ZVtem4JGHh4UxWP35xFxNNyLV3pwZY0ZFJO6XZhsSN9R44xRoHuCFseEMGB?=
 =?us-ascii?Q?Rhej/S2X+B85TEaoKBCA4rIvOFPZ2Q3CClirYMrDTX8VQzZ6/RxPFE6O3lHM?=
 =?us-ascii?Q?0mhrJv/2K6ohMtqQ+IMK7hOwn0PYBLGDIbdhRpiBK/MjacnV+NduH2FpzGsc?=
 =?us-ascii?Q?QJsXg9qgvJOgA9uJO0NYI9Tu0VnsT0IXKP7D0Lvm39u6ey0Ft/0aQ9bL862S?=
 =?us-ascii?Q?3YFVe3gYOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320fb102-b650-4b68-eed4-08da2c619cbb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.0608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PtM5cUrHo076T0wAV/HG8v49rz0+5HZ31NjJdM6MDNA6uIEnX2TsmA/TcYoRPeaF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior series have transformed other parts of VFIO from working on struct
device or struct vfio_group into working directly on struct
vfio_device. Based on that work we now have vfio_device's readily
available in all the drivers.

Update the rest of the driver facing API to use vfio_device as an input.

The following are switched from struct device to struct vfio_device:
  vfio_register_notifier()
  vfio_unregister_notifier()
  vfio_pin_pages()
  vfio_unpin_pages()
  vfio_dma_rw()

The following group APIs are obsoleted and removed by just using struct
vfio_device with the above:
  vfio_group_pin_pages()
  vfio_group_unpin_pages()
  vfio_group_iommu_domain()
  vfio_group_get_external_user_from_dev()

To retain the performance of the new device APIs relative to their group
versions optimize how vfio_group_add_container_user() is used to avoid
calling it when the driver must already guarantee the device is open and
the container_users incrd.

The remaining exported VFIO group interfaces are only used by kvm, and are
addressed by a parallel series.

This series is based on Christoph's gvt rework here:

 https://lore.kernel.org/all/5a8b9f48-2c32-8177-1c18-e3bd7bfde558@intel.com/

and so will need the PR merged first.

I have a followup series that needs this.

This is also part of the iommufd work - moving the driver facing interface
to vfio_device provides a much cleaner path to integrate with iommufd.

v3:
 - Based on VFIO's gvt/iommu merge
 - Remove mention of mdev_legacy_get_vfio_device() from commit message
 - Clarify commit message for vfio_dma_rw() conversion
 - Talk about the open_count change in the commit message
 - No code change
v2: https://lore.kernel.org/r/0-v2-6011bde8e0a1+5f-vfio_mdev_no_group_jgg@nvidia.com
 - Based on Christoph's series so mdev_legacy_get_vfio_device() is removed
 - Reflow indenting
 - Use vfio_assert_device_open() and WARN_ON_ONCE instead of open coding
   the assertion
v1: https://lore.kernel.org/r/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com

Jason Gunthorpe (7):
  vfio: Make vfio_(un)register_notifier accept a vfio_device
  vfio/ccw: Remove mdev from struct channel_program
  vfio/mdev: Pass in a struct vfio_device * to vfio_pin/unpin_pages()
  vfio/mdev: Pass in a struct vfio_device * to vfio_dma_rw()
  drm/i915/gvt: Change from vfio_group_(un)pin_pages to
    vfio_(un)pin_pages
  vfio: Remove dead code
  vfio: Remove calls to vfio_group_add_container_user()

 .../driver-api/vfio-mediated-device.rst       |   4 +-
 drivers/gpu/drm/i915/gvt/gvt.h                |   5 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  51 ++--
 drivers/s390/cio/vfio_ccw_cp.c                |  47 +--
 drivers/s390/cio/vfio_ccw_cp.h                |   4 +-
 drivers/s390/cio/vfio_ccw_fsm.c               |   3 +-
 drivers/s390/cio/vfio_ccw_ops.c               |   7 +-
 drivers/s390/crypto/vfio_ap_ops.c             |  23 +-
 drivers/vfio/vfio.c                           | 288 ++----------------
 include/linux/vfio.h                          |  21 +-
 10 files changed, 102 insertions(+), 351 deletions(-)


base-commit: 676d7cda1a3c19872428a9bc818577a1aafafdd5
-- 
2.36.0

