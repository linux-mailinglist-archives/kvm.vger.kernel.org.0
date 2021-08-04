Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0463E022A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 15:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhHDNl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 09:41:59 -0400
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:1443
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238320AbhHDNl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 09:41:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmbuIlJGGeH7kNLwxADoeZA8yEAS2nECZGwf6xuEUniMnxwbKhKJ248NR5k5LACMs4hlZjHFrUis4l3+RmjBWmZjGjp3T6Q9Q1FPCuADutviy/WmFrJgdOhj2vJIBt5d+BIlsMrwBaGfYOJdTcA1c+pAMdoygN3iLHJh6ekt4o2XIoD+vBuR1Ie/6yQhO25OUn8DoeLWGCSBnd5KG11LfXnIjQel/ZD7OeZbhflhpTcWk4zNbV1I938StP2RQr4520APp1AnokSR/cLf+FER/pSIlooPZC1FvTcIVzse8oJ4rEMlTkz2qPIEmZg3jpRk4l+sLN/L1ubLKjrM/PSrcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02aHGe/Hoba+YKLFvbKD/Rfi1XlJTqEwvoVu9INZAnk=;
 b=FDohVX/Ry+8V7wK+ceTFoNFt+j4rubl2BcnyK9zdfNvssgVTGouZbpfnR+hLW413yVJ6kHKMDpy6DLhJOk2SunAoc5JcTHhLWb9hNhTlZb+qLAHg64afZ2VT9ygVrst+6EiB7tqRxsntZg+faj3Pu9pU1PR2xok6zU4zrpK4SC83IGiv2Ed+PCeN/3qDcQAhLF2UhThFHk9BAPDOSPDmFoPuz8u9YzCy0ewjHW6Iv2Ywp/VO9nTiJre1KBUeRJddMVSXNycMjkrQfEeNUEl2oJc4wOQ0ZzoWn1PfUe1HVtPNm9MKJ7a2059+2juqNAY3kNutRt9vWgIxICqmKRQ7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02aHGe/Hoba+YKLFvbKD/Rfi1XlJTqEwvoVu9INZAnk=;
 b=g6OT0hqJdU3pGT7qhzvg6C/f4d6vKzDUPfG0e2luReDU1RNU5aOZ6nxuiHrzuEY/Mp/MwsVZiy0Tb612aZ2j1xckK0O5I36AcXYMjmi8Iwj84k7T4CT27vOIfxSehS1VxXP3eg3gsydH0s1HWOQo+rRzo2hyBIYJLiwsGdHBJMBJ60NJdHzr8thiCnt62lnmQnLBqdZ1tfbiyOHNXJwGrjQ2OXlQL97S5Xy/q2yruPuGaqdULWr8n4kOQ6Mwr5sDUcHVMwEdAAkJLCi/tjAKq3SSiKtJHsRfEhcIdypA5f5wOATFBXAoEPfM2EXSGMfeUhnugyUw/f/aF64x7vXZKg==
Received: from BN1PR14CA0026.namprd14.prod.outlook.com (2603:10b6:408:e3::31)
 by CH2PR12MB4875.namprd12.prod.outlook.com (2603:10b6:610:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 4 Aug
 2021 13:41:44 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::46) by BN1PR14CA0026.outlook.office365.com
 (2603:10b6:408:e3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Wed, 4 Aug 2021 13:41:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:41:43 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug
 2021 06:41:42 -0700
Received: from [172.27.14.8] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug 2021
 13:41:37 +0000
Subject: Re: [PATCH 00/12] Introduce vfio_pci_core subsystem
To:     <alex.williamson@redhat.com>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <maorg@nvidia.com>, <corbet@lwn.net>,
        <michal.lkml@markovi.net>, <bhelgaas@google.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
References: <20210721161609.68223-1-yishaih@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <4580c83e-f3b1-0f93-d3ea-dc9cbdf6178d@nvidia.com>
Date:   Wed, 4 Aug 2021 16:41:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a40c87a-f29a-44c2-23d5-08d9574d98c7
X-MS-TrafficTypeDiagnostic: CH2PR12MB4875:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4875A2FDE883DB0419B50ECBC3F19@CH2PR12MB4875.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hlswK8OcZzZM/QLl8GcZP/1X8f76LQqa6A988WrQI6Fcro2yid/r+K35ID6doFpu3wJU2cEMqTw0aDFOgFzxW4fKV7KU1mlsg7kPaMntKMlcTKztmXrOXZK58cJmVQ9hs4GkVhc+pbP+v03YdxYT/fnK+i2AQBRLgrMivNaflBn00Pt/AP3Mfk2W4anpsxH5BAqdOLWiaoUx4JT93Fwsu5JeNSi1KlkWGb2uicsGL7scKabY4NB3kumNZYcGvco42LGouFt3aBgvhIP1wKgRwNv6za1KGtq40rZ4iohXcRi1imH6PbOZXnN4icZS9cdU0Td6QZP3XYg75jaArj4Ir5YR+K7qckgt8ONbk6uRvnaX/wpHTbabRcZAm9Ufgvw+Yrq+BuQD7Uit4gMiAvfQAjxo5jD2ZyrK7HbGmeDOj5f9gn8qQcwE+pouuhP+Gj5fi89g37zS32/bHnC6bU3wGxAF/19iW1z/QAXfHvLu+tR6fz9BjEo/hSIc8Syv+mceUqUqcjud/Dx1iF/O1ZHX9/lfvCaxQG8BxgBst4aeLyUjJORG6SIfuEujCSSkbsGfGaiUdu1a34xk91z1Loi66A2oe2NCPzmP+wzh9zSK64r9IATwjt9XGsVnpTUDu/sOgRrVfmhDaL8RT2HWJlZIjPolr7Olr09dPMUrujCEhzSOsAID9yQqTKis607aHjw0cNWsNpPKnhBkOZ0Q4YHI++gNGlDykz0zjYsdXm+iZK9ZrVrwqCwurS+XsQ6R3UhM9prwVVXeNhpt8K5pG98HAv7Jxpj0zOSaWaPrEEm9eYK8GnaFGlZAOJEo+nvCFW6PEMM3v7Wqx8SD8uk55ito9UvfSX+8mMHFmJgm3ufD/A=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(82740400003)(86362001)(54906003)(356005)(31686004)(336012)(83380400001)(2616005)(7636003)(36860700001)(16576012)(4326008)(2906002)(966005)(70206006)(478600001)(70586007)(36756003)(6666004)(5660300002)(316002)(31696002)(426003)(53546011)(8936002)(186003)(8676002)(6916009)(47076005)(26005)(7416002)(16526019)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:41:43.5252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a40c87a-f29a-44c2-23d5-08d9574d98c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4875
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2021 7:15 PM, Yishai Hadas wrote:
> Prologue:
>
> This is the second series of three to send the "mlx5_vfio_pci" driver
> that has been discussed on the list for a while now. It comes on top of
> the first series (i.e. Reorganize reflck to support splitting vfio_pci)
> that was sent already and pending merge [1].
>
>   - Split vfio_pci into vfio_pci/vfio_pci_core and provide infrastructure
>     for non-generic VFIO PCI drivers.
>   - The new driver mlx5_vfio_pci that is a full implementation of
>     suspend/resume functionality for mlx5 devices.
>
> A preview of all the patches can be seen here:
> https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
>
> [1] https://lore.kernel.org/dri-devel/0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com/T/#t
> =====================
>
>  From Max Gurtovoy:
> ====================
> This series splits the vfio_pci driver into two parts, a PCI driver and
> a subsystem driver that will also be library of code. The main PCI
> driver, vfio_pci.ko, will remain as before and it will use the library
> module vfio_pci_core.ko to help create the vfio_device.
>
> This series is intended to solve the issues that were raised in the
> previous attempts for extending vfio-pci for device specific
> functionality:
>
> 1. https://lore.kernel.org/kvm/20200518024202.13996-1-yan.y.zhao@intel.com
>     by Yan Zhao
> 2. https://lore.kernel.org/kvm/20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com
>     by Longfang Liu
>
> Also to support proposed future changes to virtio and other common
> protocols to support migration:
>
> https://lists.oasis-open.org/archives/virtio-comment/202106/msg00044.html
>
> This subsystem framework will also ease adding new device specific
> functionality to VFIO devices in the future by allowing another module
> to provide the pci_driver that can setup a number of details before
> registering to the VFIO subsystem, such as injecting its own operations.
>
> This series also extends the "driver_override" mechanism. A flag is
> added for PCI drivers that will declare themselves as "driver_override"
> capable which sends their match table to the modules.alias file but
> otherwise leaves them outside of the normal driver core auto-binding
> world, like vfio_pci.
>
> In order to get the best match for "driver_override" drivers, one can
> create a userspace program to inspect the modules.alias, an example can
> be found at:
>
> https://github.com/maxgurtovoy/linux_tools/blob/main/vfio/bind_vfio_pci_driver.py
>
> Which finds the 'best match' according to a simple algorithm: "the
> driver with the fewest '*' matches wins."
>
> For example, the vfio-pci driver will match to any pci device. So it
> will have the maximal '*' matches.
>
> In case we are looking for a match to a mlx5 based device, we'll have a
> match to vfio-pci.ko and mlx5-vfio-pci.ko. We'll prefer mlx5-vfio-pci.ko
> since it will have less '*' matches (probably vendor and device IDs will
> match). This will work in the future for NVMe/Virtio devices that can
> match according to a class code or other criteria.
>
> Yishai
>
>
> Jason Gunthorpe (2):
>    vfio: Use select for eventfd
>    vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on'
>
> Max Gurtovoy (9):
>    vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
>    vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
>    vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
>    vfio/pci: Rename ops functions to fit core namings
>    vfio/pci: Include vfio header in vfio_pci_core.h
>    vfio/pci: Split the pci_driver code out of vfio_pci_core.c
>    vfio/pci: Move igd initialization to vfio_pci.c
>    PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
>    vfio/pci: Introduce vfio_pci_core.ko
>
> Yishai Hadas (1):
>    vfio/pci: Move module parameters to vfio_pci.c
>
>   Documentation/PCI/pci.rst                     |    1 +
>   drivers/pci/pci-driver.c                      |   25 +-
>   drivers/vfio/Kconfig                          |   29 +-
>   drivers/vfio/fsl-mc/Kconfig                   |    3 +-
>   drivers/vfio/mdev/Kconfig                     |    1 -
>   drivers/vfio/pci/Kconfig                      |   39 +-
>   drivers/vfio/pci/Makefile                     |    8 +-
>   drivers/vfio/pci/vfio_pci.c                   | 2238 +----------------
>   drivers/vfio/pci/vfio_pci_config.c            |   70 +-
>   drivers/vfio/pci/vfio_pci_core.c              | 2138 ++++++++++++++++
>   drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
>   drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
>   drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
>   drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
>   drivers/vfio/platform/Kconfig                 |    6 +-
>   drivers/vfio/platform/reset/Kconfig           |    4 +-
>   include/linux/mod_devicetable.h               |    7 +
>   include/linux/pci.h                           |   27 +
>   .../linux/vfio_pci_core.h                     |   89 +-
>   scripts/mod/devicetable-offsets.c             |    1 +
>   scripts/mod/file2alias.c                      |    8 +-
>   21 files changed, 2496 insertions(+), 2281 deletions(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_core.c
>   rename drivers/vfio/pci/vfio_pci_private.h => include/linux/vfio_pci_core.h (56%)
>
Hi Alex,

Based on the feedback that we got so far on this series, no functional 
changes are expected in V2.

It may include the below minor changes:

- Drop DRIVER_VERSION as it's useless and not required any more. 
(Patches #6, #12).

- Add the sequence of commands/algorithm that is required by userspace 
to discover the matching driver to the commit message of patch #9.

Do we need to wait for more feedback or that we are fine to send V2 ?

Yishai

