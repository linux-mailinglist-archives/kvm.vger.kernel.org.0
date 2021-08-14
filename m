Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F283EC5F8
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 01:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhHNX2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 19:28:11 -0400
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:27617
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234160AbhHNX2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Aug 2021 19:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEFQH+FfI50uKjrRecpfeNXwsxyg04oxObTpTOsBu015mgJ4jXHcEb5Rs++QaeBjOdliLat6MBY1LvKhi16jJdOFmEgRfvqGt+MMcP6bYrqEU8EPVMdb+OucxXDmy0xClKnFK5A5eVDF1HOVWuEvbjN3V5vdkveCR0FANuMoj3foIWbX0CK4xFy0WrP1RJ8HQ03EFiibTZHAWsWby4AXLcLv6Q2JU/NATKzWbOs/nsmWx9mf5HQqv9OtPsllMOONmh9xq0ZTnOJA9LSkGxWeFEZ1mEpZHjKX0sNOYLr8Z/zk9kchHJsd7eW1lYlEK77As/sscndNnAXM3OOJfGYMHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBoorolAEW5JBvLK54aD8iujCPTduM22kbVhSEM8JFU=;
 b=FwwFQGAu1QJK3JrDW0kYAI2gROx8f2QvfoGwTu5nJBiFiZLZ3vgYZyXq0xUmUJuSDHqoHUZnCNqz3KBCaW7EEaTqSXigoCyzGtcw8wGW3Nyvcs5NB/p9e4kTArJsdxMA2PI2SPhaTjfAjW3kqWZynsWlzIh4qGU3MGSnKnHuVJAjyykOv4EBciGNc+ZRE1vWSM0eeo/9jX/BQlmvX3usbgwZjMJy0iw+pzBPsEAzha+dmBm7LJqC7dp42icJp2Tv2WeS9AA/eKptBCTBbvQExyEinj9l7OtUNPcT/JZVtoIhytDkXGBILCk6XrLmHkBD+bqQXmKjZEOHtQJF8vx1EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBoorolAEW5JBvLK54aD8iujCPTduM22kbVhSEM8JFU=;
 b=SGJv7i0wIsQilbdq70yHpnlqEOuinA1uB4HgFVW7W45ed2yy5l1h1Y/YSdjMOfIgYCBsTadi5GrqvO7Z3qYqanMknlXOxGCNiztoKFmFVNa/cxcGqon46adWIi5COzgJ+IXjwGOONch0GtouHubbUOgxvXB1HEKLEDha7EvyrcKllsNWM3OuxQTDG8DB2JZPQQN4v2rXKN1PD/tMB8V6f0fScjczSnJxyImATbZJNEdgTX4XcPWKiuWb90BgciZaPdygrJM40cT4WBqayQTePHZ9fU8H5bSasFUtSKh3hyQw9YD7nnd5rX9kFL9taXoT26iOndnknRMAQwo5HoQ2IQ==
Received: from BN6PR20CA0060.namprd20.prod.outlook.com (2603:10b6:404:151::22)
 by MWHPR12MB1245.namprd12.prod.outlook.com (2603:10b6:300:13::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Sat, 14 Aug
 2021 23:27:33 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::91) by BN6PR20CA0060.outlook.office365.com
 (2603:10b6:404:151::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend
 Transport; Sat, 14 Aug 2021 23:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 23:27:32 +0000
Received: from [172.27.0.128] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Aug
 2021 23:27:27 +0000
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
References: <20210813174459.GA2594783@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <2ee30d21-5305-5e58-6fa2-da74b2c8ff5a@nvidia.com>
Date:   Sun, 15 Aug 2021 02:27:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813174459.GA2594783@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8ec640c-3734-4e43-0c80-08d95f7b1724
X-MS-TrafficTypeDiagnostic: MWHPR12MB1245:
X-Microsoft-Antispam-PRVS: <MWHPR12MB124583CFF386448A706FA59EDEFB9@MWHPR12MB1245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8xVIQaYLO6JNGmU2CGbuUybI5uPVS6FHfIJjlxlkwLRl62P98hilcF80Wvj/u+cbbMpJzxs2zJwhy5LCgbrN7Fpp3/Uoi48jIiMLlClgs1gd1KwjOoz/vNxFGvcxYbY1HOhy93zb5T5++SYLY/2eBsWiauiRNcOrtaM6BYw8ILeGtu8tfAdn9vdvuXrBMIFIy7WgKXoSxBFgBo4LItUpSp6dt/SJbpUwrXdKiIBJXewRqQsKSJCYxBt/omjffsNcyorS6dnE2wcH+3eqrm2C5iuabGu5XDpy1Kif/Qqs0rcvaGH/XMWKeSH4FJUwmjF8kRFkrwWWC7g6O/HlEDdJPWc2Hkh57SeMvswHH8hPFt8iCqFgeLoGpibjlAGsPrXHiwpJPvOh3Et5pioJV8q9QefS2G+vuKa7boI4Kp2ctqNXohE08iWHpoXb2UHOZUaK29T2GTtTmTI7TKL9aQZjCRf2EuMAVwCIsBadO/zOmm6LOkzor5nLnQmktpmTDe3JddJMLy76a6KhOgPGnRAq3iyToaMuiN6i/YO+wl3A93fXcvXfwg2wkaU0Mp5J9ZndCfsju/VqlnxN/7LUEu/PWo193NOihT2MLFYr9PXSa0pea1FwE/rALfRxZmWA7mDLDQ/g6JZO5Fd8Qb1MY5AdYzsxgR7a2pLG73tflwMR2e3bCFEypOkEMPrZhoRfbLbqXBlG/G5JXvtkcR+DIEqhEvEhH3xe993n6Q+MF6idjM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(46966006)(36840700001)(2616005)(31696002)(86362001)(186003)(16526019)(53546011)(26005)(426003)(5660300002)(7416002)(6666004)(336012)(70206006)(70586007)(31686004)(36756003)(356005)(316002)(8936002)(83380400001)(47076005)(8676002)(36860700001)(7636003)(54906003)(82310400003)(4326008)(107886003)(16576012)(82740400003)(478600001)(6916009)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 23:27:32.1831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ec640c-3734-4e43-0c80-08d95f7b1724
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1245
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/13/2021 8:44 PM, Bjorn Helgaas wrote:
> On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
>> On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
>>> On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
>>>> On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
>>>>> On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
>>>>>> On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
>>>>>>> On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
>>>>>>> Do the other bus types have a flag analogous to
>>>>>>> PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
>>>>>>> other bus types, it'd be nice if the approach were similar.
>>>>>> They could, this series doesn't attempt it. I expect the approach to
>>>>>> be similar as driver_override was copied from PCI to other
>>>>>> busses. When this is completed I hope to take a look at it.
>>>>> I think this would make more sense as two patches:
>>>>>
>>>>>     - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
>>>>>       since nothing in PCI depends on the VFIO-ness of drivers that use
>>>>>       the flag.  The only point here is that driver id_table entries
>>>>>       with this flag only match when driver_override matches the driver.
>>>> This would require using two flags, one to indicate the above to the
>>>> PCI code and another to indicate the vfio_pci string to
>>>> file2alias. This doesn't seem justified at this point, IMHO.
>>> I don't think it requires two flags.  do_pci_entry() has:
>>>
>>>     if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>>>       strcpy(alias, "vfio_pci:");
>>>
>>> I'm just proposing a rename:
>>>
>>> s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
>>>
>>>>>     - Update file2alias.c to export the flags and the "vfio_pci:" alias.
>>>>>       This seems to be the only place where VFIO comes into play, and
>>>>>       putting it in a separate patch will make it much smaller and it
>>>>>       will be clear how it could be extended for other buses.
>>>> Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
>>>> to the string "vfio_pci", that is just really confusing.
>>> Hahaha, I see, that's fair :)  It confused me for a long time why you
>>> wanted "VFIO" in the flag name because from the kernel's point of
>>> view, the flag is not related to any VFIO-ness.  It's only related to
>>> a special variety of driver_override, and VFIO happens to be one user
>>> of it.
>> In my original patch I used
>>
>> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
>>
>> and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
>>
>> So we can maybe do that and leave the option to future update of the define
>> without changing the core code.
>>
>> In the future we can have something like:
>>
>> #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
>> PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
>>
>> The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
>> flag to add "vfio_" prefix.
>>
>> Is that better ?
> I don't think it's worth having two separate #defines.  If we need
> more in the future, we can add them when we need them.

I meant 1 #define and 1 enum:

enum {
     PCI_ID_F_VFIO_DRIVER_OVERRIDE    = 1 << 0,
};

#define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE

>
> What if we renamed "flags" to be specifically for this override case,
> e.g., "override_only"?  Then the flag could be
> PCI_ID_F_VFIO_DRIVER_OVERRIDE, which would trigger a "vfio_" prefix in
> file2alias.c, but pci_match_device() could just check for it being
> non-zero, without caring whether the reason is VFIO or something else,
> e.g.,
>
>    pci_match_device(...)
>    {
>      ...
>      if (found_id->override_only) {
>        if (dev->driver_override)
>          return found_id;
>        ...

Jason suggested something like this:


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
          * The match table is split based on driver_override. Check the
          * flags as well so that any matching
          * PCI_ID_F_VFIO_DRIVER_OVERRIDE entry is returned.
          */
         if (!(found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) ||
             dev->driver_override)
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


It looks good to me as well.

I prefer the "flags" naming since its more generic and easy to extend.

can we continue with the above suggestion for V2 ?

It's really a matter of taste..

> Bjorn
