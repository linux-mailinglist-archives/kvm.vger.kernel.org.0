Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22C33E90AC
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhHKMXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 08:23:53 -0400
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:30625
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237758AbhHKMXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 08:23:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkxKv37c/VJd14ByBvKvqBYeKByfZw1RPs++qXGw20adlMgLXpqcvGrEJPg8Y713MzXRODqwFF0duIPazQ506DvhWduyHT8KEMCCacfVm5AwTfnKcLbnmVrYGUO55FLCa3gGzAllYAYwJZiD3J83lO45a3/Y9CQr42AfZ3UMFFkEvBy3Q+u6lX6PPbjydTVPnkXNCfOh6WBSgl+2cwS5yWpv/LpAbrW6lKbXBr6F7ZhdH6J5MjnhftSvqNQGByc1XxT4BYJML6DQaMPwc3mk4b9dXa1VacOpT7LOpBC2CHt9DWtEGFNJSxyTnBrhXxZzOJDzTVrFp++egzq7S+MwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEgaoy04IyQtkbwb4zsT4TMtRF8dg7AKmFSlZqt5Vo8=;
 b=HU+cRdfzk3Heql7p/VRGcuWditIPztmU2z34rXXcJvxoI67CDzlQey9wQEUJ3CKxgymYlrpNImLXfpz3quvECSaxNZQB1pZmW9ejwyqRnrfN/o0+7RHK/S2ZRVawVNuuVgSrxIqGUBK44Vxxac9s2DJnN3LejhOZWWPbbcHYsshNj9cNVTnUi56qDGvaW29eB9t14XAYD2IAWlT7bjufuVWPKu8adnSb03c1S2TyqCwX9/iyawgoc88aO9D4S2LTt+weSrSDsV0q+yjtNIgPmGv1gKyV3EEoyb/t6p9vP1DhbXThBIMKS3RxKrReNfUgDsACmZ8xw1UyzIthuO7MLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEgaoy04IyQtkbwb4zsT4TMtRF8dg7AKmFSlZqt5Vo8=;
 b=IcTQMMpTFQr5yVKuOrT+csYAa0hEsZb3tDPSKgSYrjc4vXr9edhYR7NE3CoFL3DkAMa4rLoK4fC8IY9wSHakZYpxyWxqbNKIvdASo1rM3BTXctMQ56yZPXrkeWGyc0T1F4/79XTdTuqZjX0LD6uBTZLVYqjEMGAspfwIvcIhT2BufEXZKNSHLA2O++z3E0xlipDuuEMwSfX/VWIDK/xqWBhp9DLrdYoAQod3bBgMMyPU23ByyZhEzwZ6IsQbDJOZTXmKx/MYlVWfRpCyVyv6CV8JCA61ArbODPA/Di8JpEgR444/XcP3K0SAFn8kbym8vCWhFrpCDK3I1FswO3lw/A==
Received: from DM6PR08CA0047.namprd08.prod.outlook.com (2603:10b6:5:1e0::21)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.22; Wed, 11 Aug
 2021 12:22:51 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::48) by DM6PR08CA0047.outlook.office365.com
 (2603:10b6:5:1e0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend
 Transport; Wed, 11 Aug 2021 12:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Wed, 11 Aug 2021 12:22:51 +0000
Received: from [172.27.13.120] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Aug
 2021 12:22:45 +0000
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
CC:     Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <alex.williamson@redhat.com>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210721161609.68223-10-yishaih@nvidia.com>
 <20210804203412.GA1663387@bjorn-Precision-5520>
 <20210806002357.GD1672295@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <fd9e68b3-ff4f-ce09-d041-06f620b97444@nvidia.com>
Date:   Wed, 11 Aug 2021 15:22:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806002357.GD1672295@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0eb3999-ae13-4f13-a2f3-08d95cc2bd10
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:
X-Microsoft-Antispam-PRVS: <SA0PR12MB446492F88B4275D59FB604EADEF89@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZVy9S81wMvD+M/cS4nTBKdauKoVYke1iB4epmWlEzwAjMYxMhJJh3fZ5tLJ6slYNH7AVY5mWm0cF0t+nFJHYL3ojayYy+ERgOTd6Txf8FwsZL3JnbuD3yBkwUJu+HrTOIxW3uIRhs7rqhLVctLyfmeyiRJmIS5mKwmc+sCYZLS0hpA/v4Iq2j99Yf6gz0dB/5r9IcmFh/2OKT6VS4CljrP1FoKHgiz4//nE2CLBPKIYyafk59MMb5k6S0eHvCw46rvNyC+9cZI7eh9TjFdtobpuX7KOu9G77123pcMlX3IYjBy84RSwkEZ9JVVI2NsdV8t0hw1B83Rtk/Foo1fbbqW5elZk6NBpVfrF32t8wbbjUP93XlpystTdrAlV+RNSDhikJrmHbQ4lNwdo9oqUzWEJHT7YmSjrBNafyJfdd9UgyAUGidpmPbNa8LjCRdAWfELEHzv1P2RvuMnP1sSrYDjtF2KH951N/2slczDT7vwqc9746VnTmwM/WPGO8zhIUVjAfTmRgrf85M+/ZTYsfxVhdsYXfZaxechRFpiA0w2dFIUDcIqJQ+bifygi0mCUwQRlwfRBuUK4F7wy4pTWX2MOoRt5oo2fc1fKJE8LAE/ZkiIIJHxA7HMBtE4VanV/3R0YxcJuydnN9qHwryaq9hhJr5z6ojpuh6JOa+Pnq8F4l70zkifDjkmxIf+/9W14W8Bq6tG7JYeLjgBoaNnRaE2itWjFx1lv9PmHW9l2umY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(31696002)(70206006)(70586007)(47076005)(4326008)(186003)(36860700001)(16526019)(26005)(356005)(7416002)(82310400003)(53546011)(82740400003)(2906002)(54906003)(336012)(8936002)(83380400001)(36756003)(8676002)(86362001)(478600001)(7636003)(16576012)(426003)(2616005)(107886003)(36906005)(110136005)(316002)(5660300002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 12:22:51.2172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0eb3999-ae13-4f13-a2f3-08d95cc2bd10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 8/6/2021 3:23 AM, Jason Gunthorpe wrote:
> On Wed, Aug 04, 2021 at 03:34:12PM -0500, Bjorn Helgaas wrote:
>
>>> The first use will be to define a VFIO flag that indicates the PCI driver
>>> is a VFIO driver.
>> Is there such a thing as a "VFIO driver" today?
> Yes.
>
> VFIO has long existed as a driver subsystem that binds drivers to
> devices in various bus types. In the case of PCI the admin moves a PCI
> device from normal operation to VFIO operation via something like:
>
> echo vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
>
> Other bus types (platform, acpi, etc) have a similar command to move
> them to VFIO.
>
>>> VFIO drivers have a few special properties compared to normal PCI drivers:
>>>   - They do not automatically bind. VFIO drivers are used to swap out the
>>>     normal driver for a device and convert the PCI device to the VFIO
>>>     subsystem.
>> The comment below says "... any matching PCI_ID_F_DRIVER_OVERRIDE
>> [sic] entry is returned," which sounds like the opposite of "do not
>> automatically bind."  Might be exposing my VFIO ignorance here.
> The comment is in error
>   
>>>     The admin must make this choice and following the current uAPI this is
>>>     usually done by using the driver_override sysfs.
>> I'm not sure "converting PCI device to the VFIO subsystem" is the
>> right way to phrase this, but whatever it is, make this idea specific,
>> e.g., by "echo pci-stub > /sys/.../driver_override" or whatever.
> The next version will include the sequence we worked out with Alex in
> the other branch of this thread. See below
>
>>>   - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
>>>     them with 'vfio_pci:' instead of the normal 'pci:'.
>>>
>>>     This allows the userspace machinery that switches devices to VFIO to
>>>     know what kernel drivers support what devices and allows it to trigger
>>>     the proper device_override.
>> What does "switch device to VFIO" mean?  I could be reading this too
>> literally (in my defense, I'm not a VFIO expert), but AFAICT this is
>> not something you do to the *device*.
> It means change the struct device_driver bound to the struct device -
> which is an operation that the admin does on the device object.
>
>> I guess maybe this is something like "prevent the normal driver from
>> claiming the device so we can use VFIO instead"?
> no..
>
>> Does "using VFIO" mean getting vfio-pci to claim the device?
> If by claim you mean bind a pci_driver to the pci_dev, then yes.
>
>>> As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
>>> keeps todays behavior the same. VFIO remains on the side, is never
>>> autoloaded and can only be activated by direct admin action.
>> s/todays/today's/
>>
>>> This patch is the infrastructure to provide the information in the
>>> modules.alias to userspace and enable the only PCI VFIO driver. Later
>>> series introduce additional HW specific VFIO PCI drivers.
>> s/the only/only the/ ?  (Not sure what you intend, but "the only"
>> doesn't seem right)
> "the only" is correct, at this point in the sequence there is only one
> pci_driver that uses this, vfio_pci.ko
>
>> Sorry, I know I'm totally missing the point here.
> Lets try again..
>
> PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
>
> Allow device drivers to include match entries in the modules.alias file
> produced by kbuild that are not used for normal driver autoprobing and
> module autoloading. Drivers using these match entries can be connected to
> the PCI device manually, by userspace, using the existing driver_override
> sysfs.
>
> Add the flag PCI_ID_F_VFIO_DRIVER_OVERRIDE to indicate that the match
> entry is for the VFIO subsystem. These match entries are prefixed with
> "vfio_" in the modules.alias.
>
> For example the resulting modules.alias may have:
>
>    alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>
> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
> device. The kernel will autoload and autobind to mlx5_core but the kernel
> and udev mechanisms will ignore mlx5_vfio_pci.
>
> When userspace wants to change a device to the VFIO subsystem userspace
> can implement a generic algorithm:
>
>     1) Identify the sysfs path to the device:
>      /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
>
>     2) Get the modalias string from the kernel:
>      $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
>      pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>
>     3) Prefix it with vfio_:
>      vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
>
>     4) Search modules.alias for the above string and select the entry that
>        has the fewest *'s:
>      alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>
>     5) modprobe the matched module name:
>      $ modprobe mlx5_vfio_pci
>
>     6) cat the matched module name to driver_override:
>      echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
>
> The algorithm is independent of bus type. In future the other buses's with
> VFIO device drivers, like platform and ACPI, can use this algorithm as
> well.
>
> This patch is the infrastructure to provide the information in the
> modules.alias to userspace. Convert the only VFIO pci_driver which
> results in one new line in the modules.alias:
>
>    alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
>
> Later series introduce additional HW specific VFIO PCI drivers, such as
> mlx5_vfio_pci.

are we good with this commit message ?

And with the code logic ?

We would like to send V2 with the proposed fixes and the above commit 
message and get your ack on this.

Our goal is to merge this series and the first preparation series 
"Provide core infrastructure for managing open/release" sent by Jason to 
kernel 5.15.

The first series is in the final review phase but this series is mostly 
depend on this patch. For the other patches we have some kind of agreement.

hopefully we can collect more "reviewed-by" signatures before sending V2.


>>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>>> index 7c97fa8e36bc..f53b38e8f696 100644
>>> +++ b/scripts/mod/file2alias.c
>>> @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
>>>   	return 1;
>>>   }
>>>   
>>> -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
>>> +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
>>>   static int do_pci_entry(const char *filename,
>>>   			void *symval, char *alias)
>>>   {
>>> @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
>>>   	DEF_FIELD(symval, pci_device_id, subdevice);
>>>   	DEF_FIELD(symval, pci_device_id, class);
>>>   	DEF_FIELD(symval, pci_device_id, class_mask);
>>> +	DEF_FIELD(symval, pci_device_id, flags);
>> I'm a little bit wary of adding a new field to this kernel/user
>> interface just for this single bit.  Maybe it's justified but feels
>> like it's worth being careful.
> A couple of us looked at this in one of the RFC threads..
>
> As far as we could tell this is not a kernel/user interface. It is an
> interface within kbuild between gcc and file2alias and is not used or
> really exported beyond the kernel build sequence.
>
> Debian code search didn't find anything, for instance.
>
> modules.alias, as output by file2alias during kbuild, is the canonical
> "kernel/user" interface here. Everything that needs this data should
> be using that.
>
> Thanks,
> Jason
