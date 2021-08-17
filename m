Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26B43EECF5
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbhHQNCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 09:02:34 -0400
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:62945
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229721AbhHQNCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 09:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmZZHwlsmuhYCFe4rdCmiD3x4ajRDYSjaSby/qJhVx0EIkLca64LYOvpwFlH2TWO/mTJDfJG1uyWJ2dVPMt4h7unnhmDR28EJ7caIxFMRCILVksyUU2rdDBESbFSXrQy8w4wHO37Ew/s3uy1O2pGYwlxYlCkNJRkQPjMiXNvEx+ErHSfe+ESEZAgZhe/1Wmp8TXB99aI4tStgYmXdTDTZi6zWyVvaS79sKrdcO/ysipdvU66R4udb0cDSZrOFM01iSXCg5nzuGdWMUl88Ho3FCYpBTBzLbvzId13hrq9SLKytXiNzeNhG2fK+ZRLyYq+Ls1QT0KWx+7dHlmZ+cAqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRCKPu/omrtlE8wVPLNZD462lb/kdJIWyl01eFNTG4Q=;
 b=GPSCtbFT0KHsXhAXX0MupgwSBLjuMVVfBM6+zrkK3xu/DCxkSKxvMQ1NtoLmi3VEjYabUQA3afPlcqmKLKRu0UpLircjyPc1PsWebcrGt4sL2/G99mrPZixxW4kKO2cpSRTqQMznKrIG7SjLPdFjZ7ASriVwdUvjwFq1zQ5/UDZ7Jv3tLjEIzSAJL8YFaGy6xN7KpvW2mRrb7gRqJxVSG9jsAs7hWahcdOC96U3gcj+6qYHY1SXEeINWncu0wy7/MFeidiEk0jext5P1XEfmzF75qgjAY/Y3NOH3Ci358qXL+zXc64XBpY7WTaIhKLKB38Q85ng5LU/P9Aan/9ozqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=markovi.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRCKPu/omrtlE8wVPLNZD462lb/kdJIWyl01eFNTG4Q=;
 b=ZpS6Mxx3tHP+QlbSO3iK2LMKsQoH9A1QLB7iWDzhcB78rTGoXnTEBGYN64zNSJLE3GxcTBfDjhtRzM8u7Skz1vXTLS3sargs7x9NPBj7gliWR/YWBtsr7Ah6X2u8w4GgXsOFwr9tnl0NvJtzkFSAwhHBeVAXGTy3rdDzDE5OqxOG5sAfLwxf0wN5KSEI9RWC8E8nZ7bannj/KuTxQLQj3QpnwsyQVIA5T6ueakg9sOPjzO83m8KKEDjE9wkD9wUbUJjhMc7Uywq4bw6G3tkUz0RYKlc+00FBaV7nfsmTIgOYV1sZrxEhnp1YDlA7VJnUK+UkKkScGhit6DI7/WMwUg==
Received: from DM5PR21CA0045.namprd21.prod.outlook.com (2603:10b6:3:ed::31) by
 DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.17; Tue, 17 Aug 2021 13:01:58 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::8c) by DM5PR21CA0045.outlook.office365.com
 (2603:10b6:3:ed::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1 via Frontend
 Transport; Tue, 17 Aug 2021 13:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; markovi.net; dkim=none (message not signed)
 header.d=none;markovi.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 13:01:57 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 13:01:57 +0000
Received: from [172.27.13.131] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 13:01:52 +0000
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
References: <20210816172156.GA2928236@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <872e77ee-5f6d-af10-805d-4954484e5399@nvidia.com>
Date:   Tue, 17 Aug 2021 16:01:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210816172156.GA2928236@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b4b220a-0f7c-4291-e50e-08d9617f31f7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4043:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40439E772CF33DD53C8F3FC7DEFE9@DM6PR12MB4043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bpfvs2fPi4Ov+k+mYeluG5KqgP1c9032wyXFYeXo8oVstTAbed4C5Hj30mGBn0yYY50aAFzcbkcv8Wmz3400cw+Ru9IIvQLYlMJ36/dRLM+aD0EX7keN5X0wyxysh+raYRjBo8FPrTdkQMjU4YVDvrSPGFJxuh2GiY9f4H+Xwd++7ldx7tCfBtnqJDkFpYUNH+NwTLG1NmVjcU6t7HvrienbQ6iQTR0sWSGnUTGuGHPtsvNIrwjXSb/R+QJ8vcSHGpw4X1k1x2PewVGQIcAhIe5awH6WAzugaBOyCPTboAemF2xLK1M/uTRlV2ou66OazDemR+iMaF4oIMf0d2CqCejfQ6Xj6n8mfhU6+SGGP9Vg/alLaIknX1tBsRoDRzoDTtTcnVkAOXH5otinGESAltePwMlVHltnMcj5QcrQkeG+gADNUlFJt8tFhUhjapHQw4Y2cOTNjyoN11ETkzofdQJElvtCh6OY9cNuhPTtYDgIr7av5tendWj+BEkX1ZGeEpgge3Frhox4ahOhNlTV4LAp8sa3xNpiHO22bB4gV4/tNvUHYR6ARLXLC3KfEJOL5FNc1+3Vfd/WK2j0rjfEFz89YVMn+IfRHDx8EhqxtEAopaPdrT95e6+JVa90VJ0hQxdXch+MU/OnbthPI7mBpPzzGZTd1Np8zQnWSVRNT87/2ui6QVC8dLxOnwENirvny5FLYp8LUsReE1wQld+0RHS2dAGN5ZTv2hQM25jnHGAZZI2HsPFYpGyX/vV98DXJPJBHqZBL+Ed5mT7sSbxXoWas560u0P6H75L52ssdqny+hfSxPldKYl0t+J8G4NzU
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(54906003)(5660300002)(426003)(336012)(36756003)(2616005)(478600001)(4326008)(16576012)(31686004)(316002)(6666004)(83380400001)(82740400003)(7416002)(107886003)(966005)(70206006)(7636003)(70586007)(86362001)(356005)(47076005)(36860700001)(8936002)(26005)(6916009)(31696002)(2906002)(82310400003)(186003)(53546011)(16526019)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 13:01:57.5726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4b220a-0f7c-4291-e50e-08d9617f31f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/16/2021 8:21 PM, Bjorn Helgaas wrote:
> On Sun, Aug 15, 2021 at 02:27:13AM +0300, Max Gurtovoy wrote:
>> On 8/13/2021 8:44 PM, Bjorn Helgaas wrote:
>>> On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
>>>> On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
>>>>> On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
>>>>>> On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
>>>>>>> On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
>>>>>>>> On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
>>>>>>>>> On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
>>>>>>>>> Do the other bus types have a flag analogous to
>>>>>>>>> PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
>>>>>>>>> other bus types, it'd be nice if the approach were similar.
>>>>>>>> They could, this series doesn't attempt it. I expect the approach to
>>>>>>>> be similar as driver_override was copied from PCI to other
>>>>>>>> busses. When this is completed I hope to take a look at it.
>>>>>>> I think this would make more sense as two patches:
>>>>>>>
>>>>>>>      - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
>>>>>>>        since nothing in PCI depends on the VFIO-ness of drivers that use
>>>>>>>        the flag.  The only point here is that driver id_table entries
>>>>>>>        with this flag only match when driver_override matches the driver.
>>>>>> This would require using two flags, one to indicate the above to the
>>>>>> PCI code and another to indicate the vfio_pci string to
>>>>>> file2alias. This doesn't seem justified at this point, IMHO.
>>>>> I don't think it requires two flags.  do_pci_entry() has:
>>>>>
>>>>>      if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>>>>>        strcpy(alias, "vfio_pci:");
>>>>>
>>>>> I'm just proposing a rename:
>>>>>
>>>>> s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
>>>>>
>>>>>>>      - Update file2alias.c to export the flags and the "vfio_pci:" alias.
>>>>>>>        This seems to be the only place where VFIO comes into play, and
>>>>>>>        putting it in a separate patch will make it much smaller and it
>>>>>>>        will be clear how it could be extended for other buses.
>>>>>> Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
>>>>>> to the string "vfio_pci", that is just really confusing.
>>>>> Hahaha, I see, that's fair :)  It confused me for a long time why you
>>>>> wanted "VFIO" in the flag name because from the kernel's point of
>>>>> view, the flag is not related to any VFIO-ness.  It's only related to
>>>>> a special variety of driver_override, and VFIO happens to be one user
>>>>> of it.
>>>> In my original patch I used
>>>>
>>>> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>>>
>>>> and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
>>>>
>>>> So we can maybe do that and leave the option to future update of the define
>>>> without changing the core code.
>>>>
>>>> In the future we can have something like:
>>>>
>>>> #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
>>>> PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
>>>>
>>>> The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>>> flag to add "vfio_" prefix.
>>>>
>>>> Is that better ?
>>> I don't think it's worth having two separate #defines.  If we need
>>> more in the future, we can add them when we need them.
>> I meant 1 #define and 1 enum:
>>
>> enum {
>>      PCI_ID_F_VFIO_DRIVER_OVERRIDE    = 1 << 0,
>> };
>>
>> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
> Basically the same thing.  Doesn't seem worthwhile to me to have both.
> When reading the code, it's not at all obvious why you would define a
> new name for PCI_ID_F_VFIO_DRIVER_OVERRIDE.

because we need the "vfio_" prefix in the alias.

And the match can use PCI_ID_DRIVER_OVERRIDE that in the future cab be 
(#define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE | 
PCI_ID_F_SOME_OTHER_ALIAS_DRIVER_OVERRIDE)

>>> What if we renamed "flags" to be specifically for this override case,
>>> e.g., "override_only"?  Then the flag could be
>>> PCI_ID_F_VFIO_DRIVER_OVERRIDE, which would trigger a "vfio_" prefix in
>>> file2alias.c, but pci_match_device() could just check for it being
>>> non-zero, without caring whether the reason is VFIO or something else,
>>> e.g.,
>>>
>>>     pci_match_device(...)
>>>     {
>>>       ...
>>>       if (found_id->override_only) {
>>>         if (dev->driver_override)
>>>           return found_id;
>>>         ...
>> Jason suggested something like this:
>>
>> static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>>                              struct pci_dev *dev)
>> {
>>      struct pci_dynid *dynid;
>>      const struct pci_device_id *found_id = NULL, *ids;
>>
>>      /* When driver_override is set, only bind to the matching driver */
>>      if (dev->driver_override && strcmp(dev->driver_override, drv->name))
>>          return NULL;
>>
>>      /* Look at the dynamic ids first, before the static ones */
>>      spin_lock(&drv->dynids.lock);
>>      list_for_each_entry(dynid, &drv->dynids.list, node) {
>>          if (pci_match_one_device(&dynid->id, dev)) {
>>              found_id = &dynid->id;
>>              break;
>>          }
>>      }
>>      spin_unlock(&drv->dynids.lock);
>>
>>      if (found_id)
>>          return found_id;
>>
>>      for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
>>           ids = found_id + 1) {
>>          /*
>>           * The match table is split based on driver_override. Check the
>>           * flags as well so that any matching
>>           * PCI_ID_F_VFIO_DRIVER_OVERRIDE entry is returned.
>>           */
>>          if (!(found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) ||
>>              dev->driver_override)
>>              return found_id;
>>      }
>>
>>      /*
>>       * if no static match, driver_override will always match, send a dummy
>>       * id.
>>       */
>>      if (dev->driver_override)
>>          return &pci_device_id_any;
>>      return NULL;
>> }
>>
>>
>> It looks good to me as well.
> I missed your point.  Isn't the above basically the 09/12 patch [1] we're
> talking about?
>
> Yes, I see the code structure is slightly different, but the question
> we're talking about here is the name of the "flags" field and the enum
> or #define for the VFIO bit.

I guess the renaming of "__u32 flags" to "__u32 driver_override" is ok 
from my perspective.

The enum for vfio should stay.

The prefix we want in the alias is "vfio_" and not "driver_override_".

This will allow a clean uAPI. "driver_override_" prefix will be too 
generic for userspace tools like libvirt that would like to find a 
*VFIO* driver not something else.

Thus we need alias to be "vfio_".

In the future if some other driver will use this flag, it will create an 
alias also. In your suggestion, the alias will be the same and the 
userspace tool won't be able to distinguish between the two.

But in the original solution, for non vfio driver override drivers, one 
can use new enum PCI_ID_F_SOME_OTHER_ALIAS_DRIVER_OVERRIDE and add its 
own alias prefix for recognition "my_prefix_".

>
>> I prefer the "flags" naming since its more generic and easy to extend.
> We don't need to worry about "flags" being generic or extensible until
> we need to extend it.  It's easy to fiddle with it at that point.
>
>> can we continue with the above suggestion for V2 ?
> I don't see what really changed with the above suggestion.
>
> The point I'm trying to make is that using PCI_ID_F_VFIO_DRIVER_OVERRIDE
> in pci_match_device() suggests that the code there has some connection
> or dependency on VFIO, but it does not.

This is why I suggested a "#define PCI_ID_DRIVER_OVERRIDE 
PCI_ID_F_VFIO_DRIVER_OVERRIDE"


>
> [1] https://lore.kernel.org/r/20210721161609.68223-10-yishaih@nvidia.com
