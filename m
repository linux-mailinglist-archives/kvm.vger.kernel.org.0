Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762E23D4D28
	for <lists+kvm@lfdr.de>; Sun, 25 Jul 2021 12:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhGYKF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jul 2021 06:05:28 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:47840
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229538AbhGYKF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jul 2021 06:05:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeiRtAyEY2TQIVQ99uYhdNfOUZZgYzflf7+HsYn+xuTy6JWcXEROVCR1ycHoxJNKExTu9p6SpbmU/3+64fB6HWe61cbMPJUvWFLTFlJTJ/kaT2ZeFTl52Aqq4PTiuOF8rQ9/Jrf7X8mfz7x9xJlvHC03V8f20rFcs2Dx9GashPFAzhMAyFByDeT0FHwtqIf2P3RT7j9fxmKVhKiG/VMV+MIjEpD/pdI4T0TF5FnltKtLYskBrTOC22d4lcsW+YLaIvWjq3GxH4KPZde1cGJpeSASgKLhtLq9aEqrfAVm3LnPDPPneMX8xXPUTPOpK7VkLKEGTY/brwax6ibBINL73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AsLERQe/JD701UfybpiRhLb4QuQNdGw5Xc28t4LdMc=;
 b=LK9zX+ELZQB0X0oh393rkg788p1FkJrbVZ0r4A+BFxmMmZEqF+3HOr9eWGb6Z1+Tcy55LShuJANkNy0sJjwTnJ0wQY6BXDkHhzuQCSL0wgsd3+FOpz4oWlIWhfK16b7WKT1vJJr819NlpeSzHMTAIgTEXJK+n3CUPeL4pRMv83QKYB+DAhRNv04aGLVrFKy3ndg4XMis+OayJze+jY+25r+gXcrosAUc45G41fvlTTFYYf1JBqy0BW4nEg8SH9FGcT5xUbb3Xl4TuOx3+HBL3U16bys9Vw9QkOiMxiAAWNnOqKXihFMOqZiN7AuR1kZ87avXENSnMS6cpMuSsl1tkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AsLERQe/JD701UfybpiRhLb4QuQNdGw5Xc28t4LdMc=;
 b=Ex9rFwZ1s/YtO63p8ELQjvbcqJBwXwMDozLYOLAjQRqkSCv13f9S0NBRlXg6WhI7eE+KP5bqJIAKZNu6WoZDcqGBIcpTUTsS2GJqu2KKQBgsJ0vWDXS38adSBKLyju9tI8m3jzJ7l/JjOhETFR8VvZ/7DsIWxNHVu+CcHOjc/pKvqAU2WMhIneCGdiDpAjUfpjPmkzEz3fdtxc56G0g+yA/7ueYJdDD89W11hEx3VAHRXrZ5WrV4zEQWZLoW3NHqfQwhOJFSTWOWHFlTdLJchpkivKsAISvJkBNQbGf+kR8lza11uEXCsmXnlQ4wxyg25GE81YP2uZa6CHgMNy5FoQ==
Received: from MWHPR14CA0040.namprd14.prod.outlook.com (2603:10b6:300:12b::26)
 by BL0PR12MB2436.namprd12.prod.outlook.com (2603:10b6:207:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sun, 25 Jul
 2021 10:45:54 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::d) by MWHPR14CA0040.outlook.office365.com
 (2603:10b6:300:12b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Sun, 25 Jul 2021 10:45:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Sun, 25 Jul 2021 10:45:54 +0000
Received: from [172.27.14.121] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 25 Jul
 2021 10:45:48 +0000
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
To:     Leon Romanovsky <leon@kernel.org>
CC:     Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <alex.williamson@redhat.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <jgg@nvidia.com>, <maorg@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com> <YPhb6o06fX+/FiTY@unreal>
 <0b8db422-749d-9d93-6b3b-957259f3d0cb@nvidia.com>
 <b7c19435-5abb-c5fd-383c-d0ebad11db31@nvidia.com> <YPrOmLs9dZaEe7Th@unreal>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <2ec35d9a-3db5-5729-9805-1c04b9da6d0c@nvidia.com>
Date:   Sun, 25 Jul 2021 13:45:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPrOmLs9dZaEe7Th@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e22bcc-8695-4469-1b9b-08d94f5960cb
X-MS-TrafficTypeDiagnostic: BL0PR12MB2436:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2436D352CF7BD03138194221DEE79@BL0PR12MB2436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02kx4mZhTDLQC67/ct03WW8rAt/7OqQC1vn/5RRYKYVlts9UvKkbViq8BfQrC5siKtnpGP5aYNftCqL6AnaQIbmgpIVZVQcD+wy2gT2QcB1Wb+Os1vYYGni34Hhc2gudcxb/tnR6M8zK4sEYtUqSVab1ik1k8ObmxgNP3PjMmzkNrPuzS4FtTcvhpeIo5AiMWDLPIKWUNKcosWpClwC9Fe7iqoOYLrtHYqkzxW9WNPJDgK6V3/tE/Ndyfn5plj9hlCCaBy5v/+PXwkykH9lYwGyE+pDO2lc2kGRs72FiodZUQ0rMtpmqDH8UsH3WS0blJMvdYGbByd0zcKgmrT1m5bw0vX/FC3tq4QVSA4EIl1ZiIGpe1TyDeQhfk42Pu50T1rSENfyYyC2KnSZJCTKJfWu2cK5ArwqYLJcW+PCKcI/1EpShGQtFAXv/mFbW2GdWmvRwCwTB9sjDOVHShTmaNW0578uOQeHjGyrhlKQjaNwRhQKJe7KqiKzpt2/Jgh2fkrW5zh/50zmMASeeBIUkkQRrigt3PtaXSEWowarRsbt9//GbroXB3Jr2ldqvtO+BvmtlLut+4Bdm7c1sR3PSBPUP8m8i+d+0Tw63Ek1OJY7W4fhnH+p6fikbFEK+226XFH0DuSHE7MPQFpOPOeG1+V94kJ8SrOmu1M/PgeDMFO5SJ8ww1r/Pbs69t8Ag++3K2EKf7/ziNDWg+9wMWLVsgnFT9aR0u29NkEMy3gjjo/umLrZAeHQwm+sCUC6Q2il3MQ+3t/YVy4cVRmsJVwhCHV856I5HuuBphjIw3Bpa63h9R4Ixc7tVQpUSv7VGsS7K
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(2616005)(966005)(7416002)(26005)(53546011)(5660300002)(70206006)(70586007)(8936002)(83380400001)(2906002)(36860700001)(82310400003)(36756003)(16576012)(16526019)(186003)(426003)(316002)(54906003)(82740400003)(336012)(8676002)(6666004)(7636003)(47076005)(107886003)(356005)(86362001)(4326008)(31696002)(478600001)(36906005)(31686004)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2021 10:45:54.3083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e22bcc-8695-4469-1b9b-08d94f5960cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2436
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/23/2021 5:13 PM, Leon Romanovsky wrote:
> On Thu, Jul 22, 2021 at 12:22:05PM +0300, Max Gurtovoy wrote:
>> On 7/22/2021 12:06 PM, Yishai Hadas wrote:
>>> On 7/21/2021 8:39 PM, Leon Romanovsky wrote:
>>>> On Wed, Jul 21, 2021 at 07:16:09PM +0300, Yishai Hadas wrote:
>>>>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>
>>>>> Now that vfio_pci has been split into two source modules, one focusing
>>>>> on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
>>>>> (vfio_pci_core.c), complete the split and move them into two different
>>>>> kernel modules.
>>>>>
>>>>> As before vfio_pci.ko continues to present the same interface under
>>>>> sysfs and this change will have no functional impact.
>>>>>
>>>>> Splitting into another module and adding exports allows creating new HW
>>>>> specific VFIO PCI drivers that can implement device specific
>>>>> functionality, such as VFIO migration interfaces or specialized device
>>>>> requirements.
>>>>>
>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>> ---
>>>>>    drivers/vfio/pci/Kconfig                      | 30 ++++++++------
>>>>>    drivers/vfio/pci/Makefile                     |  8 ++--
>>>>>    drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
>>>>>    drivers/vfio/pci/vfio_pci_config.c            |  2 +-
>>>>>    drivers/vfio/pci/vfio_pci_core.c              | 41
>>>>> ++++++++++++++++---
>>>>>    drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>>>>>    drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
>>>>>    drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>>>>>    drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
>>>>>    .../pci => include/linux}/vfio_pci_core.h     |  2 -
>>>>>    10 files changed, 66 insertions(+), 39 deletions(-)
>>>>>    rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)
>>>> <...>
>>>>
>>>>> -#include "vfio_pci_core.h"
>>>>> +#include <linux/vfio_pci_core.h>
>>>>> +
>>>>> +#define DRIVER_VERSION  "0.2"
>>>> <...>
>>>>
>>>>> +MODULE_VERSION(DRIVER_VERSION);
>>>> Please don't add driver versions to the upstream kernel, they useless.
>>>>
>>>> Thanks
>>> This just preserves the code for driver/module version that was in
>>> vfio_pci.ko before the split.
>>>
>>> However,  this can be removed in V2 if we may need to have.
>> Right, we already agreed to preserve vfio_pci versioning scheme and we'll
>> not add it to new mlx5_vfio_pci or future drivers.
> There is nothing to preserve, instead of keeping this useless code, just
> delete it.

Ok I guess we can do it since the is new module vfio_pci_core.ko.

We'll remove it in V2.

>
> https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
>
> Thanks
>
>>
>>> Yishai
>>>
