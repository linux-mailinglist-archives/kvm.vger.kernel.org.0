Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DC43EEEB6
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 16:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhHQOpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 10:45:43 -0400
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:28716
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237387AbhHQOpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 10:45:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyzQqstfTyR/mEp/sQpnFLoRXdcZTshB1foSJThV59F8ap6M8XsEL3dhTvj2XdcDuuiaQDmUYtnlDM817+H16YAWwixAVwAuqP/D7EIIvp8KSTV1R0ePSM/zJKswZsaclUWhflGbeI/HaREAjbTMX1hZyIA46QeTuiAGUFvkL4+NUwJNm2rBjwJ42xZ73/a/WUhGnD80UxIGWNJrDeMhQQPo+G4fqe0+GZH3iXPvZQbEfMLcv3QCzSAcdt8+3wsUnIUaQeyLFjD9lBPHx6v0EHelJhBZBVlMMkZ8sIH+/O/NAnN9mFOuay3X3boEZnriroeKXJo1vUBBELo2Taek0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HoSvT9JE58g/7mCmdaF0cUr6GFWgkqkIy2StXcG/P0=;
 b=TnppmwYP0EthrDNEtgQd9pzhCppiKcietlqtA6/qvrp9MiNlWkYnBzHXULy2QgT6ppvUiL2HNXZOyAZqHOw8LlOlSJYl4k0z8P2bCaJym5itPdKmga7KRPKp1i4mIo9cG2KvCZaU/lrLYjEhqQtjYApibbaSHW2ZwGJfljIxBwnlYx5SYmBiqNKXwe4InE+o8g9ovOkcpmW0lB3B7gJrHYbSt4RmUDOYSolGyixVFM1Bx3Um5KvCQUAdoNU+8p4yWGzyjWgeMpfuHprDiy5GZLGT+ml6+tszxupS0iWq1tgsZDTiEEV1XbX3bUPdrvmIYrTqC2paE2G28Eifl9lAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HoSvT9JE58g/7mCmdaF0cUr6GFWgkqkIy2StXcG/P0=;
 b=AIfBjlNeYV2yogF0j5rn8EOiJHyjkVjaO6kQhCboPnx0TGRmNkHoVjyldgLgUbw9MU9msU4BfXfplSomFuIguBM3mNc+r0AAOjFZQ2VLJK7YDpFV3B7zNzJ0n02H1ISJ0OlVR1zf+4spz09kxTCoV63TT5Bi7YZUr/nvK/sj7yRbcRskZNvq9wMpN46pWC5qB7jB5tV/dtBKBvsJO+rqNBH68CDCKt10h0jJ8OoHTc1uoDUH7ZW30FwTvxcqUMutZtj6a0gb1GeARzF+RPnqKFZa4SjogSbXA8Ry/MkRvI/1JIBjeq0M/wZYSFL+l0ArFapOxenbk+eaKFqyfQv17w==
Received: from DM5PR04CA0058.namprd04.prod.outlook.com (2603:10b6:3:ef::20) by
 MW3PR12MB4554.namprd12.prod.outlook.com (2603:10b6:303:55::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.16; Tue, 17 Aug 2021 14:45:07 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::fc) by DM5PR04CA0058.outlook.office365.com
 (2603:10b6:3:ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend
 Transport; Tue, 17 Aug 2021 14:45:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 14:45:06 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 14:44:20 +0000
Received: from [172.27.13.131] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 14:44:15 +0000
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <alex.williamson@redhat.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210817141342.GA3010409@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <a44f7e32-a725-be5b-4d12-6784c54b4803@nvidia.com>
Date:   Tue, 17 Aug 2021 17:44:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210817141342.GA3010409@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09b6ec6c-9833-4383-551d-08d9618d9ada
X-MS-TrafficTypeDiagnostic: MW3PR12MB4554:
X-Microsoft-Antispam-PRVS: <MW3PR12MB455475DFAE758F98EF368D88DEFE9@MW3PR12MB4554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HhVH5yPKQ9t5FeyBVaGL2mrY+MG82pRbmaFC0oka977K89oWR4r2LLiSuhhDKKTqGqY1ghwNOsWMU8Vrg3KRF7ClDuUz3ONLCBsk+H9+efRRS0ZS6+RvR8TSREpBho4nl71DM7oeLdUIB2q2q2WFi0V+LGtSdmpwleNEb+D0RMrfTNHo3p1wnYs9hYkcjYFiVTDdtXBNGadtsXEL1Jz2BYv8QIw4yG4h8BmgZb490IP1Ee9IvQSv1+rl7p6PzRviqy3PVnFDQwNMYaLbl126x4gGAU24DDP/J8Gc5z1lUhYeM+tlicAJSSRc45r+HQq9dHxXU8f5CelO3i13KwL7uU+aGQCaZepG7dSV6vM0+XGIi2gkp0gDV9HHLxzOwVKndPSlNgQMP2pmSxlIZAhO2CQbEi2aN6JMyjJ7zqshJKITr39txWMKc0yAUMPSKuT6/xSOvhIdLiJFhzy8+O5U+a59hLfQF8/gZPEu6PqQMltQiL3o66HOM4tGwzk/sI/DAasdwWyeKUvFkN4M/zChEktWoCGr1fPSlcNkROaJSY3mYGpVrAKQSUny8fVIJZiUvqx9e4PG0KNLuxZze68lObjJLNHK3LIQk2ywp1ID5G3DB9sZr5P6w/vSv9dSBm02/0fBuN6CNbfVIDkc9B99ynCzDdHnG09JsaxMjWIX3I3Y4ZYohu5fmQ48PX61U44n+QgdNrH7QhMdDp0/PoJsHN081xG8mXNTadngznLYgnGnh4lEpSW1wY21rODQ2AtPcvt1+K0PVOKd6Kir18k0x41vjE+2XRkeUcwgUcEP/Jte+ORJzXAzEOLRn/UMzNhj
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(107886003)(4326008)(6916009)(7416002)(426003)(70206006)(70586007)(356005)(8676002)(7636003)(336012)(82310400003)(8936002)(966005)(26005)(6666004)(478600001)(47076005)(16526019)(54906003)(82740400003)(186003)(5660300002)(36860700001)(2616005)(36756003)(2906002)(16576012)(316002)(31686004)(53546011)(83380400001)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 14:45:06.4859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b6ec6c-9833-4383-551d-08d9618d9ada
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/17/2021 5:13 PM, Bjorn Helgaas wrote:
> On Tue, Aug 17, 2021 at 04:01:49PM +0300, Max Gurtovoy wrote:
>> On 8/16/2021 8:21 PM, Bjorn Helgaas wrote:
>>> On Sun, Aug 15, 2021 at 02:27:13AM +0300, Max Gurtovoy wrote:
>>>> On 8/13/2021 8:44 PM, Bjorn Helgaas wrote:
>>>>> On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
>>>>>> On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
>>>>>>> On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
>>>>>>>> On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
>>>>>>>>> On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
>>>>>>>>>> On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
>>>>>>>>>>> On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
>>>>>>>>>>> Do the other bus types have a flag analogous to
>>>>>>>>>>> PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
>>>>>>>>>>> other bus types, it'd be nice if the approach were similar.
>>>>>>>>>> They could, this series doesn't attempt it. I expect the approach to
>>>>>>>>>> be similar as driver_override was copied from PCI to other
>>>>>>>>>> busses. When this is completed I hope to take a look at it.
>>>>>>>>> I think this would make more sense as two patches:
>>>>>>>>>
>>>>>>>>>       - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
>>>>>>>>>         since nothing in PCI depends on the VFIO-ness of drivers that use
>>>>>>>>>         the flag.  The only point here is that driver id_table entries
>>>>>>>>>         with this flag only match when driver_override matches the driver.
>>>>>>>> This would require using two flags, one to indicate the above to the
>>>>>>>> PCI code and another to indicate the vfio_pci string to
>>>>>>>> file2alias. This doesn't seem justified at this point, IMHO.
>>>>>>> I don't think it requires two flags.  do_pci_entry() has:
>>>>>>>
>>>>>>>       if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>>>>>>>         strcpy(alias, "vfio_pci:");
>>>>>>>
>>>>>>> I'm just proposing a rename:
>>>>>>>
>>>>>>> s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
>>>>>>>
>>>>>>>>>       - Update file2alias.c to export the flags and the "vfio_pci:" alias.
>>>>>>>>>         This seems to be the only place where VFIO comes into play, and
>>>>>>>>>         putting it in a separate patch will make it much smaller and it
>>>>>>>>>         will be clear how it could be extended for other buses.
>>>>>>>> Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
>>>>>>>> to the string "vfio_pci", that is just really confusing.
>>>>>>> Hahaha, I see, that's fair :)  It confused me for a long time why you
>>>>>>> wanted "VFIO" in the flag name because from the kernel's point of
>>>>>>> view, the flag is not related to any VFIO-ness.  It's only related to
>>>>>>> a special variety of driver_override, and VFIO happens to be one user
>>>>>>> of it.
>>>>>> In my original patch I used
>>>>>>
>>>>>> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>>>>>
>>>>>> and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
>>>>>>
>>>>>> So we can maybe do that and leave the option to future update of the define
>>>>>> without changing the core code.
>>>>>>
>>>>>> In the future we can have something like:
>>>>>>
>>>>>> #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
>>>>>> PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
>>>>>>
>>>>>> The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>>>>> flag to add "vfio_" prefix.
>>>>>>
>>>>>> Is that better ?
>>>>> I don't think it's worth having two separate #defines.  If we need
>>>>> more in the future, we can add them when we need them.
>>>> I meant 1 #define and 1 enum:
>>>>
>>>> enum {
>>>>       PCI_ID_F_VFIO_DRIVER_OVERRIDE    = 1 << 0,
>>>> };
>>>>
>>>> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>> Basically the same thing.  Doesn't seem worthwhile to me to have both.
>>> When reading the code, it's not at all obvious why you would define a
>>> new name for PCI_ID_F_VFIO_DRIVER_OVERRIDE.
>> because we need the "vfio_" prefix in the alias.
>>
>> And the match can use PCI_ID_DRIVER_OVERRIDE that in the future cab be
>> (#define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
>> PCI_ID_F_SOME_OTHER_ALIAS_DRIVER_OVERRIDE)
> Read this again:
> https://lore.kernel.org/r/20210813174459.GA2594783@bjorn-Precision-5520
>
> That gives you a "vfio_" prefix without the unnecessary VFIO
> connection in pci_match_device.

I see.

So I guess the following code should be fine:


static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
                             struct pci_dev *dev)
{
     struct pci_dynid *dynid;
     const struct pci_device_id *found_id = NULL, *ids;

     /* When driver_override is set, only bind to the matching driver */
     if (dev->driver_override && strcmp(dev->driver_override, drv->name))
         return NULL;

     /* Look at the dynamic ids first, before the static ones */
     spin_lock(&drv->dynids.lock);
     list_for_each_entry(dynid, &drv->dynids.list, node) {
         if (pci_match_one_device(&dynid->id, dev)) {
             found_id = &dynid->id;
             break;
         }
     }
     spin_unlock(&drv->dynids.lock);

     if (found_id)
         return found_id;

     for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
          ids = found_id + 1) {
         /*
          * The match table is split based on driver_override.
          */
         if (!found_id->override_only || dev->driver_override)
             return found_id;
     }

     /*
      * if no static match, driver_override will always match, send a dummy
      * id.
      */
     if (dev->driver_override)
         return &pci_device_id_any;
     return NULL;
}



