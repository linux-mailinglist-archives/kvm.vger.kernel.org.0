Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0823A570A
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhFMIV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 04:21:59 -0400
Received: from mail-mw2nam10on2081.outbound.protection.outlook.com ([40.107.94.81]:7644
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229870AbhFMIV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 04:21:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0yPUTneFNT+Kt7qo8p+dRLGMtGI58s+Yf+gR87+h5rZIvdvfncE+cEHWFGBT1WljylEPIm1wSvfVPVRDNRt2YuhaA77KGKx0aTGCpTIRgETUiLbDNq9vflk+ui47+a5jEeM+rsiKKWOy+OdtgTjkC9SF388NpOqM0ktN5AHxXxhhr9Jhvi/K0z9aGJpvPPK469npObr9F75jeWnTLvb99kgvUHl9VJo82t4R2sYjTcXIcwdL2M3N5hYFXWh6ZJYcZ3/GAVozdLmG9JWNPvnGb5vQxMSeFDZ6oA1s7ClVc98jzYzGqyV5iaYDqtExcZsm3QTDnIgIqo1b/Z1kJlYNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cvyCwhlGDFxtNKXXaSA96jahjjRIkxi3XW42aqH2tQ=;
 b=KQI78JzJXf1CwWzHOUJayD7fmxC/7LNnKVpCzewTtk2EXLxAhli/oGzdVs4oZVw74LFRw6Y/TBtn3cuc15vS8GiYWoPxaU5e2eIGnIAgSp9Ki3SSjEY09kfkauheV71MxAdkKL8rjYTLTVbt5Tlr4czzKkZiopcJUSBr1XJFescfW/xk7LipE/8lfkswc1F5rNKPbHL/H5ueXJ7M4m9KuXTBsBif8jD5rjlSqKgSmiSlVDRRmQ2yEdfvgnAneKuH50EIPUo/jwkz8q3MBEPCmtO7DVJWTsKnmbBkmFmrlNR0F611nOQJrYeKzIivlICUE8v4kHCIAZyRMggeT1UQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cvyCwhlGDFxtNKXXaSA96jahjjRIkxi3XW42aqH2tQ=;
 b=VXQb6zc4WEsbU0mKFN7oWQlJ6c997oM4AlsuKvX4fj0yAam56Qy2nwXFsdDWFcGRua5HQ1B180y/e7Adzjgpc/rJbcnbGeXrjAnmwAoQtY4MiNb//MYdDLZr1jEEbwbBGLapleuX2GXsmN3VHxxL0vxSZszGcLxpUrCKcsPP8t+hpmtHXCq1gK9gkxV+wYTHP85SGRTljjYnJLyYbW/H+YslZug7f+CA0xvEJJ8djUlSXYQ5lAa4KIPMKRf3GXolNEqVRMi0/0ARE+vdJCJvGlmxkVdtW2+q9nNu5ET6AMkkji0gRo+4EXS3YA7BtfsTrIwxJr6jg8WzHK4WBDyueQ==
Received: from BN0PR02CA0053.namprd02.prod.outlook.com (2603:10b6:408:e5::28)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Sun, 13 Jun
 2021 08:19:56 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::8e) by BN0PR02CA0053.outlook.office365.com
 (2603:10b6:408:e5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Sun, 13 Jun 2021 08:19:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Sun, 13 Jun 2021 08:19:56 +0000
Received: from [172.27.14.244] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 13 Jun
 2021 08:19:49 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <aviadye@nvidia.com>,
        <oren@nvidia.com>, <shahafs@nvidia.com>, <parav@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <cjia@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
Date:   Sun, 13 Jun 2021 11:19:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608192711.4956cda2.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20f8297-c4c9-438e-95ce-08d92e440724
X-MS-TrafficTypeDiagnostic: PH0PR12MB5433:
X-Microsoft-Antispam-PRVS: <PH0PR12MB543391C882ADC10B81F20F04DE329@PH0PR12MB5433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nq978ruzOKbhCOot2KyDoc/7S89gpyhp7Teuptb/nVb+8jMsZHkSf2lsVapRSHrNIqVd/UGBtvISPMN9UBKLGO+3oetgKbNJLxujXmHTp4Vn1OHSR8j8v4ICgbkd54Y+25+4OEBJDdufCKppK19tYIBTRW7FXqdNixX8bhG0vGxU6wCfQPmBGTufUOqJfsutysAR8KVAW6lwz0i5lol0SLZUl/+YvHbvG8GWxxWDLdu2ivv+GY11Kz0WiRa+bJbCN5p9DdhWTTxVCOYo+zwSM8IkBWSZilwMVxxE2xsHnGZW9Sn2kmbET8WUoP22GWq3rwZhWhLUHiKpxj74peLdMfgi+atTqjnez8aoyF57RDxJ5ZeqCLQGdPkteSacg6DK0YZ8wGTpqAscDY+jIQMZ9BzOJ0uPwaG11gsVkCGHVyVyNp7BKreWsOAZ4WYY0rGNs6ASRCJTD3hxN+rrkh1ie5RhU7sRot2V5a/KqkdCoBx5rIySDJ71S0OnCroDSHXFBWVfvHtl9jYmXqEBG0e4xZiMXCU4AnQntMtkwscA2eaURcAmhDAv6kI22QdLcgNwZmanQ8RgLAw2CW85TqPEG2255ywp8Fs3OKFK+8h5Bk+7UIgrNilFYyL9trNNo5AuVh2wTl/Je4CNysJGTyujGLfYDBrnQDMlz5r1zudBuYqtvUjzNFiPkDj3tUWUUJ8O
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(70586007)(110136005)(4326008)(336012)(70206006)(31696002)(86362001)(8936002)(36906005)(54906003)(36756003)(2616005)(316002)(16576012)(6636002)(7636003)(26005)(426003)(356005)(83380400001)(36860700001)(16526019)(186003)(5660300002)(31686004)(82740400003)(47076005)(82310400003)(478600001)(6666004)(53546011)(8676002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2021 08:19:56.0338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f20f8297-c4c9-438e-95ce-08d92e440724
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/9/2021 4:27 AM, Alex Williamson wrote:
> On Tue, 8 Jun 2021 19:45:17 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote:
>>>> drivers that specifically opt into this feature and the driver now has
>>>> the opportunity to provide a proper match table that indicates what HW
>>>> it can properly support. vfio-pci continues to support everything.
>>> In doing so, this also breaks the new_id method for vfio-pci.
>> Does it? How? The driver_override flag is per match entry not for the
>> entire device so new_id added things will work the same as before as
>> their new match entry's flags will be zero.
> Hmm, that might have been a testing issue; combining driverctl with
> manual new_id testing might have left a driver_override in place.
>   
>>> Sorry, with so many userspace regressions, crippling the
>>> driver_override interface with an assumption of such a narrow focus,
>>> creating a vfio specific match flag, I don't see where this can go.
>>> Thanks,
>> On the other hand it overcomes all the objections from the last go
>> round: how userspace figures out which driver to use with
>> driver_override and integrating the universal driver into the scheme.
>>
>> pci_stub could be delt with by marking it for driver_override like
>> vfio_pci.
> By marking it a "vfio driver override"? :-\
>
>> But driverctl as a general tool working with any module is not really
>> addressable.
>>
>> Is the only issue the blocking of the arbitary binding? That is not a
>> critical peice of this, IIRC
> We can't break userspace, which means new_id and driver_override need
> to work as they do now.  There are scads of driver binding scripts in
> the wild, for vfio-pci and other drivers.  We can't assume such a
> narrow scope.  Thanks,

what about the following code ?

@@ -152,12 +152,28 @@ static const struct pci_device_id 
*pci_match_device(struct pci_driver *drv,
         }
         spin_unlock(&drv->dynids.lock);

-       if (!found_id)
-               found_id = pci_match_id(drv->id_table, dev);
+       if (found_id)
+               return found_id;

-       /* driver_override will always match, send a dummy id */
-       if (!found_id && dev->driver_override)
+       found_id = pci_match_id(drv->id_table, dev);
+       if (found_id) {
+               /*
+                * if we found id in the static table, we must fulfill the
+                * matching flags (i.e. if PCI_ID_F_DRIVER_OVERRIDE flag is
+                * set, driver_override should be provided).
+                */
+               bool is_driver_override =
+                       (found_id->flags & PCI_ID_F_DRIVER_OVERRIDE) != 0;
+               if ((is_driver_override && !dev->driver_override) ||
+                   (dev->driver_override && !is_driver_override))
+                       return NULL;
+       } else if (dev->driver_override) {
+               /*
+                * if we didn't find suitable id in the static table,
+                * driver_override will still , send a dummy id
+                */
                 found_id = &pci_device_id_any;
+       }

         return found_id;
  }


dynamic ids (new_id) works as before.

Old driver_override works as before.

For "new" driver_override we must fulfill the new rules.

>
> Alex
>
