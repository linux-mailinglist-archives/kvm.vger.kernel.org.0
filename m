Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87B61E4FF
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiKFRrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiKFRrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:11 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56336643F
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl5042wuIVd+w+vUWNkY6xEaT/G1Psj7qyrOgi+epdWQKvTF/Y2ONBo6Knv2TIm0SBoxTo3t7Ng6ePUwzAKXvY/VxEF8mAudGouKwEVm8OY70s0tff5Df6SCuOO+eZwkr9MHB0ctrYKScq5TU87vp19J6WkNFZCJAP1Nu62RtAHdAMziWUD99/76IJlD9ed63YHiPuIp/GB2jHOA0S6QbVCy2rK47Rz2nViBFIDjb25dBsixlyuZg1eCr+JfCAObOV/hQEvwVzAQKEdaI6caGFQ8aB/Rg0gCCYHMffTp5tDWAkbUUSKNCGwqzctpnYfm3FanSYtcyZ7ff8uu3lzFLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEdCClvjWFiCg+M59HL2sxHqWbCXw4oehGrsXnuK04w=;
 b=O4RSHbpxVe8FfQy+GymIsqkoYAV/usRhklLfHc8mp9ZjTK6lqwZpKy6lN/2bT4zxLZBHrBS2TJkgYDrxW+8MuvpZFpsQZUBmWvz4LOBc5TcuB5wv4hBrSEV7yhJgzrTs4pj34nW0lrWgnVSwVMTp8G6YtosMGsNrTnK8E4xKD+CFROQKfH5yNq3YFy6i/mkeDbEa/RXnEm5Q0P9mOL13kuAbi4JUXp8XK2mdcjqAjdCRycg/DI9+SFPDPYkeJomyHBPw1RE0pppfFln4Mo/cevMua6I4skziZIcQmJtTX0MWAvr8D/eR7kFMfcVWrNSDtVormEMWE+h5zgmgL+a2Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEdCClvjWFiCg+M59HL2sxHqWbCXw4oehGrsXnuK04w=;
 b=nqCodBR7MwZEDjH3UwAniViliwDRoTYbtihw5bDY6s2qSiDfXWx54CDVzjdtBgVCmfRw8X+P8/X/LwSgv0YX5euh9VzQKabjYOHypLsRs6R6ihDN3D7s0TqQyG/aQR9fkfWHnTODusTKJpKaPG03MSWFDUqPkIQaj1eHs4PHBATSGBUJ683QQZlaU687wTCn2tY72r0m4oXPquRJJRpSPJFPSSMzzOs4Af6VBxcbZk/HamY/jDWaR2/kQi80QToFGNXw4gRcd3CU6apTXjq0JiCrbKTNpsvrHjOUsg/2IZaPq9UXeLi4GEm0JFLAEQIRntqM+dr3f9bldvqLz4rfwg==
Received: from BN7PR02CA0017.namprd02.prod.outlook.com (2603:10b6:408:20::30)
 by DM4PR12MB5771.namprd12.prod.outlook.com (2603:10b6:8:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:07 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::89) by BN7PR02CA0017.outlook.office365.com
 (2603:10b6:408:20::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:06 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:03 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 00/13] Add migration PRE_COPY support for mlx5 driver
Date:   Sun, 6 Nov 2022 19:46:17 +0200
Message-ID: <20221106174630.25909-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT037:EE_|DM4PR12MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f90f7c-7592-4cb2-ef52-08dac01eec82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3XnYroYBf17Nu1Do/zwD/L8xy6oOtD5/R93qEG+Q72OYB82aXXr0xLHeVMXr0KRdtClHpsMTmQPl/eLG58yz4x+cDATqcRJ68tK0abXRgU8pKmL5UVDosUg4EmeJrpf7HEl2l/aA3JGp0QpJATuD+315PSUErAuuOFWVi67CBN9O+DR7dWTE4FRF2PwPhBD/guDIkhJlV/5ZwtLE9dDuqsXo9WRR+wlrOeWxMjd6Om5Pf3JwfsPnF5Ngzz+e9fRikuu4R2egPQDUx9S/mHn117wlb7S+cl91ZPOabDTiHC/ZMWTL0WU9mRzz+7eS+SaLPe58MizvDaTtc2PSGvh83zOzZppKoGwMbBQCGUVZyhBhSkJ9ZRBmLsdZyjsDCC6wWwhr76GwJVvWA74WwFlGY/UizxcpKRGuKiGhoYir239SErKuVNRa5ctBayGxFjFord2fCKqTs80BZ2yo/3wFKZnmKPSyE4spmJw8h9GHW0m+KPdO3Edq3trwkou3uKL/KV8ob52KNINF2vsby7wupSops1aNFdNRDhBTvLhtIdloF6559/Fym4Xfg2xRzvAnba+6Z1B5eUSM2ZNT7WER0U/rhXnghmVBT4KYEd5/dcxgivxSKeq/aDnUuC6reAYNR5y7c27s2yVMk6y3cqUXWxoRHHuILWOECqbom86Zea0L/jZ8msisNiYNBAz5QMl+1rxr3cgRRf3UThsTBkDJn6m18W8/b1rOvn/L/oYpjbBBtZsFaX44mC0LZ7U7lnDhl1hnRo1GBhnBUbAre9OswTR5UnWkC85JCjPOcEDUMZdj3RW5cRoEYMxFypiwvOyM10u0xB1LTBH2LnX6abNJoqaUZbwDcDfJw6/2mbydUAdXMCDXEW8cqBoruAsMGUMEmoyhQsI8uK4T2pqzZWcjg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(7636003)(26005)(6666004)(7696005)(356005)(86362001)(110136005)(54906003)(2906002)(6636002)(316002)(40480700001)(36756003)(966005)(478600001)(36860700001)(82310400005)(47076005)(2616005)(426003)(336012)(1076003)(186003)(40460700003)(83380400001)(82740400003)(8936002)(5660300002)(8676002)(4326008)(70586007)(70206006)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:07.4027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f90f7c-7592-4cb2-ef52-08dac01eec82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5771
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds migration PRE_COPY uAPIs and their implementation as
part of mlx5 driver.

The uAPIs follow some discussion that was done in the mailing list [1]
in this area.

By the time the patches were sent, there was no driver implementation
for the uAPIs, now we have it for mlx5 driver.

The optional PRE_COPY state opens the saving data transfer FD before
reaching STOP_COPY and allows the device to dirty track the internal
state changes with the general idea to reduce the volume of data
transferred in the STOP_COPY stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

A new ioctl VFIO_MIG_GET_PRECOPY_INFO is provided to allow userspace to
query the progress of the precopy operation in the driver with the idea
it will judge to move to STOP_COPY at least once the initial data set is
transferred, and possibly after the dirty size has shrunk appropriately.

User space can detect whether PRE_COPY is supported for a given device
by checking the VFIO_MIGRATION_PRE_COPY flag once using the
VFIO_DEVICE_FEATURE_MIGRATION ioctl.

Extra details exist as part of the specific uAPI patch from the series.

Finally, we come with mlx5 implementation based on its device
specification for PRE_COPY.

To support PRE_COPY, mlx5 driver is transferring multiple states
(images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

The device is saving three kinds of states:
1) Initial state - when the device moves to PRE_COPY state.
2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO,
                  can be multiple such states.
3) Final state - when the device moves to STOP_COPY state.

After moving to PRE_COPY state, the user is holding the saving FD and
should use it for transferring the data from the source to the target
while the VM is still running. From user point of view, it's a stream of
data, however, from mlx5 driver point of view it includes multiple
images/states. For that, it sets some headers with metadata on the
source to be parsed on the target.

At some point, user may switch the device state from PRE_COPY to
STOP_COPY, this will invoke saving of the final state.

As discussed earlier in the mailing list, the data that is returned as
part of PRE_COPY is not required to have any bearing relative to the
data size available during the STOP_COPY phase.

For this, we have the VFIO_DEVICE_FEATURE_MIG_DATA_SIZE option [2], it
was sent also as part of this series as its initial patch.

In mlx5 driver we could gain with this series about 20-30 percent
improvement in the downtime compared to the previous code when PRE_COPY
wasn't supported.

The series includes some pre-patches to be ready for managing multiple
images then it comes with the PRE_COPY implementation itself.

The matching qemu changes can be previewed here [3].
They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Note:
As this series includes a net/mlx5 patch, we may need to send it as a
pull request format to VFIO to avoid conflicts before acceptance.

[1] https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/
[2] https://patchwork.kernel.org/project/kvm/patch/20221026072438.166707-1-yishaih@nvidia.com/
[3] https://github.com/avihai1122/qemu/commits/mig_v2_precopy

Yishai

Jason Gunthorpe (1):
  vfio: Extend the device migration protocol with PRE_COPY

Shay Drory (9):
  net/mlx5: Introduce ifc bits for pre_copy
  vfio/mlx5: Refactor total_length name and usage
  vfio/mlx5: Introduce device transitions of PRE_COPY
  vfio/mlx5: Introduce vfio precopy ioctl implementation
  vfio/mlx5: Manage read() of multiple state saves
  vfio/mlx5: Introduce SW headers for migration states
  vfio/mlx5: Introduce multiple loads
  vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
  vfio/mlx5: Enable MIGRATION_PRE_COPY flag

Yishai Hadas (3):
  vfio: Add an option to get migration data size
  vfio/mlx5: Fix a typo in mlx5vf_cmd_load_vhca_state()
  vfio/mlx5: Enforce a single SAVE command at a time

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   9 +
 drivers/vfio/pci/mlx5/cmd.c                   | 131 +++--
 drivers/vfio/pci/mlx5/cmd.h                   |  32 +-
 drivers/vfio/pci/mlx5/main.c                  | 495 ++++++++++++++++--
 drivers/vfio/pci/vfio_pci_core.c              |   3 +-
 drivers/vfio/vfio_main.c                      | 106 +++-
 include/linux/mlx5/mlx5_ifc.h                 |  14 +-
 include/linux/vfio.h                          |   5 +
 include/uapi/linux/vfio.h                     | 135 ++++-
 9 files changed, 843 insertions(+), 87 deletions(-)

-- 
2.18.1

