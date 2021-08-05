Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4A3E19D1
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhHEQsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 12:48:23 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:13920
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229766AbhHEQsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 12:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEkbHfiY7ma7C4fL5xNhehj2xQKuQdNQOcP83Ktv5/cXzMjlg1imyRryLfXCgSVq1ZKcIEBlLcVNMTLCaUugQvwM467m/U7B+nCizomY2hbhXJQnMWwJx+ouMhd3788ctIlttjnp+0Ucv4kSW2HuKa/oQabgKmAo01gfbjTlF+UxV57zKoxzaaFqFCD/DUWA32Wd/EXBYzF0ZpbbxLt64i9VlnRvK3P8aaDF/axpSPOHB0YGXdqIsoohe3BHq8d5upnv4UplAcWaj1Zq4keAZF9kr7TFejFPSzgXfXrXp1hyfvjtP4Br750Q2EzIC9QU9hFc6ViWFfHeHFCCPmE0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkG9rnIL2F4YfuoaTQd/6b/5MDfQ+hgDIbkh8f//En4=;
 b=BAvRbon+qLEceIcKE7I3f+GjQmlbMza8DmRwvGT6YSte/yVZQLZzz4vu0Y/+uqYEHSz12ToLOAW7qAz8aR5GKeb0KSmAbnT5ah33L501nuX+hI6REMvQ39nLfdaZfMI520m6EaaiTX3gmJWZBmS9jqiJwxQTCkcqcHvrd2m7tkJ2RwEaYBMlTLEvfxPVyc5YnFql8jJFhYI6LoN29YdHTQaqetLErmi1wBOPqdyA3JOw7dfoCnfTFlnnrU/wdmWtT6niFFJ8P5RxkpIdUVr28WytFwWaTPpxiOmpNR3BlAomA1zZemnUxxBCyBrR4vC5zDoYhtk7iJoZoQR0HDyWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkG9rnIL2F4YfuoaTQd/6b/5MDfQ+hgDIbkh8f//En4=;
 b=tdrSIS3AcouW2udrEkOTEiXHU3oLRehT8dQ3bw0rckd4pn+TddZOwAYw75FBQn2W/zIHlLgu1CWds44pNU/AtTdiUH82PyW24GFmXz9Wpi8oeeTx25VwNRMzGHD9HJI7f7GnnluRxBqVBuxWINGE2IzvTxE1sNRcKJuDr12f+rMDBheZtnDA/PxwLFF82Qhd7i/VrXfRftwrj+VufPYRs0axikaUV4e7AT+KySOKyT9+sBi+F2ziHPRYMe2lOatXJk/+u5sKSo/HwNTjedk1SyZoFuBs5ZNykagQ7AfPr1uySLwsjtq21eXZ/eXFGy4LBoJbkOoUnHYugC9bUfW3gg==
Received: from DS7PR03CA0276.namprd03.prod.outlook.com (2603:10b6:5:3ad::11)
 by DM6PR12MB3867.namprd12.prod.outlook.com (2603:10b6:5:1cf::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 16:48:06 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::94) by DS7PR03CA0276.outlook.office365.com
 (2603:10b6:5:3ad::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Thu, 5 Aug 2021 16:48:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Thu, 5 Aug 2021 16:48:06 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Aug
 2021 09:48:05 -0700
Received: from [172.27.14.237] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Aug 2021
 16:48:00 +0000
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <jgg@nvidia.com>,
        <maorg@nvidia.com>, <leonro@nvidia.com>
References: <20210804203412.GA1663387@bjorn-Precision-5520>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <5f470f7c-8a84-bdf0-6884-c9de1dcfcd8c@nvidia.com>
Date:   Thu, 5 Aug 2021 19:47:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804203412.GA1663387@bjorn-Precision-5520>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 566e0e6d-6d47-47a5-8545-08d95830ccd0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3867:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3867C0DE8F153B5FB6E187F9DEF29@DM6PR12MB3867.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDB22VB8adj95lw6+HJFBnvjk164apKYnxEF6wH9+HJlwlCelFnI/XtN4zGQrTB8IgD+HVHKOVjxqH+kmG1hWKbF4KtNL4Y2aCMEiTjuhxVCs0PNjDAw2Ha2gZBXdnj5oGUvGdoi9vka58T5/J3yBuBf40lgWyTPJi15lFPdE0UiOeaBWUXr9BIgcCql8HHSr+rPA/nPOKPlNOGY6SifzBboVuVG1Qg9AOD2YWnwHx/LAqtFITBkqZsQIRxcTr6yaw8K8phk+PjxKSp6kBfQyushCC8fOCshT7hTMEn6C4LMI+Zr7R/VlES1LkL5cPPlyxWQoSTQAfyfK7Wwe9qaaPY0+EfYRyj17RP8C1rU21R7KpneQiCdxXJQp/Sf3aZcCkzD22+dJDCHXQd8+L/O0RxviWi034p5XHPjgxroi5ZXTfnvADDK/YgR51Z9oD100DbjqbDeAjWWbm5WVaSJvpVrvNToowEEcU+dEWey5jBHTp+SvSfZqj6NR3z/vRVgE26cJhWc2wcQxTAg4AwK7kjd0ZTzy1w62ky1QoGG0y6wiH8tXTB/Vpgm/qwoKvaFhcUqjjC1vA6ICkp2EPQpp9SrcX1CCOWusPTv8duO7Wdw2BniwszX6na1FnKSO0ySHG3TXN7sH/FnIFw1WCwNQi6pTybKT1xnR2U1ZBrW1ZG94D2fIqPHcUFS4ll8lYMYdW67iWgh8Y536UTOsnXmSktGkQjxXHiGbP0rUYAPVz4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(36840700001)(36860700001)(8936002)(7636003)(70586007)(86362001)(70206006)(107886003)(316002)(47076005)(54906003)(82740400003)(356005)(16576012)(82310400003)(83380400001)(8676002)(110136005)(426003)(36756003)(6666004)(26005)(186003)(31696002)(30864003)(2616005)(478600001)(53546011)(336012)(7416002)(6636002)(2906002)(31686004)(5660300002)(4326008)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 16:48:06.6208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566e0e6d-6d47-47a5-8545-08d95830ccd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3867
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/4/2021 11:34 PM, Bjorn Helgaas wrote:
> On Wed, Jul 21, 2021 at 07:16:06PM +0300, Yishai Hadas wrote:
>> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>
>> The new flag field is be used to allow PCI drivers to signal the core code
>> during driver matching and when generating the modules.alias information.
> This needs to read as a complete idea even without the subject line.
> The subject is the *title*; it's not the first sentence of the essay.
>
> It's OK to repeat the subject line in the commit log, but I don't
> think that would solve the problem here because "signal core code" and
> "when generating ..." doesn't get to the point of the patch.
>
> What's the objective here?

We're creating a framework for adding vendor/protocol specific vfio_pci 
drivers. Today we have vfio_pci that can match to all pci devices and 
implement generic pci functionality.

For adding features like Live migration and other goodies we'll use the 
new vendor drivers since it's not generic.

In this patch, we're providing the ability for userspace to identify 
these drivers and match to devices.

We also want to prevent auto loading via some udev facilities (by adding 
new aliases for vfio pci devices) and we don't want vfio pci vendor 
drivers to race with original pci driver (e.g mlx5_core).

Thus, we enforce that mlx5_vfio_pci will match to a device (id_table 
will be added to vendor drivers) only if some admin use driver_override.

>
>> The first use will be to define a VFIO flag that indicates the PCI driver
>> is a VFIO driver.
> Is there such a thing as a "VFIO driver" today?  Maybe this patch is
> introducing that concept?  If so, maybe lead off by motivating and
> defining what it is, then follow up with the details that go into
> implementing it.
>
>> VFIO drivers have a few special properties compared to normal PCI drivers:
>>   - They do not automatically bind. VFIO drivers are used to swap out the
>>     normal driver for a device and convert the PCI device to the VFIO
>>     subsystem.
> The comment below says "... any matching PCI_ID_F_DRIVER_OVERRIDE
> [sic] entry is returned," which sounds like the opposite of "do not
> automatically bind."  Might be exposing my VFIO ignorance here.
>
>>     The admin must make this choice and following the current uAPI this is
>>     usually done by using the driver_override sysfs.
> I'm not sure "converting PCI device to the VFIO subsystem" is the
> right way to phrase this, but whatever it is, make this idea specific,
> e.g., by "echo pci-stub > /sys/.../driver_override" or whatever.
>
>>   - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
>>     them with 'vfio_pci:' instead of the normal 'pci:'.
>>
>>     This allows the userspace machinery that switches devices to VFIO to
>>     know what kernel drivers support what devices and allows it to trigger
>>     the proper device_override.
> What does "switch device to VFIO" mean?  I could be reading this too
> literally (in my defense, I'm not a VFIO expert), but AFAICT this is
> not something you do to the *device*.  I guess maybe this is something
> like "prevent the normal driver from claiming the device so we can use
> VFIO instead"?  Does "using VFIO" mean getting vfio-pci to claim the
> device?

hope the above explanation made this more clear.

We'll have vendor_vfio_pci drivers in the next patchsets and not only 
vfio_pci.ko.

mlx5 and hns will be the first 2 drivers to implement vendor specific 
functionality in vfio/pci subsystem.

We want to use these drivers to drive our devices and not vfio_pci.ko 
that don't have the logic for migrating mlx5/hns devices.


We'll improve the commit message for the next version and add the 
algorithm Jason proposed in his previous answer.

>
>> As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
>> keeps todays behavior the same. VFIO remains on the side, is never
>> autoloaded and can only be activated by direct admin action.
> s/todays/today's/
>
>> This patch is the infrastructure to provide the information in the
>> modules.alias to userspace and enable the only PCI VFIO driver. Later
>> series introduce additional HW specific VFIO PCI drivers.
> s/the only/only the/ ?  (Not sure what you intend, but "the only"
> doesn't seem right)
>
> Sorry, I know I'm totally missing the point here.
>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   Documentation/PCI/pci.rst         |  1 +
>>   drivers/pci/pci-driver.c          | 25 +++++++++++++++++++++----
>>   drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>>   include/linux/mod_devicetable.h   |  7 +++++++
>>   include/linux/pci.h               | 27 +++++++++++++++++++++++++++
>>   scripts/mod/devicetable-offsets.c |  1 +
>>   scripts/mod/file2alias.c          |  8 ++++++--
>>   7 files changed, 71 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
>> index fa651e25d98c..24e70a386887 100644
>> --- a/Documentation/PCI/pci.rst
>> +++ b/Documentation/PCI/pci.rst
>> @@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
>>     - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
>>     - class and classmask fields default to 0
>>     - driver_data defaults to 0UL.
>> +  - flags field defaults to 0.
>>   
>>   Note that driver_data must match the value used by any of the pci_device_id
>>   entries defined in the driver. This makes the driver_data field mandatory
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 3a72352aa5cf..1ed8a4ab96f1 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -136,7 +136,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>>   						    struct pci_dev *dev)
>>   {
>>   	struct pci_dynid *dynid;
>> -	const struct pci_device_id *found_id = NULL;
>> +	const struct pci_device_id *found_id = NULL, *ids;
>>   
>>   	/* When driver_override is set, only bind to the matching driver */
>>   	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
>> @@ -152,10 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>>   	}
>>   	spin_unlock(&drv->dynids.lock);
>>   
>> -	if (!found_id)
>> -		found_id = pci_match_id(drv->id_table, dev);
>> +	if (found_id)
>> +		return found_id;
>> +
>> +	ids = drv->id_table;
>> +	while ((found_id = pci_match_id(ids, dev))) {
>> +		/*
>> +		 * The match table is split based on driver_override. Check the
>> +		 * flags as well so that any matching PCI_ID_F_DRIVER_OVERRIDE
> s/PCI_ID_F_DRIVER_OVERRIDE/PCI_ID_F_VFIO_DRIVER_OVERRIDE/ ?

sorry, leftover from last version.

>
>> +		 * entry is returned.
>> +		 */
>> +		if ((found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) &&
>> +		    !dev->driver_override)
>> +			ids = found_id + 1;
>> +		else
>> +			break;
> Isn't this break the same as "return found_id"?

the same.

Will update in next version.


>
>> +	}
>>   
>> -	/* driver_override will always match, send a dummy id */
>> +	/*
>> +	 * if no static match, driver_override will always match, send a dummy
> AFAICT this patch did not change dynamic matching, so I don't know why
> you changed this comment.  Previously driver_override matched if there
> was no dynamic or static match.  Now it's the same except that we skip
> static matches with PCI_ID_F_VFIO_DRIVER_OVERRIDE.

we'll keep the old comment.


>> +	 * id.
>> +	 */
>>   	if (!found_id && dev->driver_override)
>>   		found_id = &pci_device_id_any;
>>   
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 0272b95d9c5f..7a43edbe8618 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -181,9 +181,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>>   	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>>   }
>>   
>> +static const struct pci_device_id vfio_pci_table[] = {
>> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
>> +	{ 0, }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, vfio_pci_table);
>> +
>>   static struct pci_driver vfio_pci_driver = {
>>   	.name			= "vfio-pci",
>> -	.id_table		= NULL, /* only dynamic ids */
>> +	.id_table		= vfio_pci_table,
>>   	.probe			= vfio_pci_probe,
>>   	.remove			= vfio_pci_remove,
>>   	.sriov_configure	= vfio_pci_sriov_configure,
>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
>> index 8e291cfdaf06..cd256d9c60d2 100644
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -16,6 +16,11 @@ typedef unsigned long kernel_ulong_t;
>>   
>>   #define PCI_ANY_ID (~0)
>>   
>> +
> Spurious blank line.

good catch, thanks.


>> +enum pci_id_flags {
>> +	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
>> +};
> Why an enum?  Is the enum and the name following some similar style
> elsewhere?

We might want to add more flags in the future. I'll remove the enum name 
but let's keep the enum for future extensions.


>
>> +
>>   /**
>>    * struct pci_device_id - PCI device ID structure
>>    * @vendor:		Vendor ID to match (or PCI_ANY_ID)
>> @@ -34,12 +39,14 @@ typedef unsigned long kernel_ulong_t;
>>    *			Best practice is to use driver_data as an index
>>    *			into a static list of equivalent device types,
>>    *			instead of using it as a pointer.
>> + * @flags:		PCI flags of the driver. Bitmap of pci_id_flags enum.
>>    */
>>   struct pci_device_id {
>>   	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
>>   	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
>>   	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
>>   	kernel_ulong_t driver_data;	/* Data private to the driver */
>> +	__u32 flags;
>>   };
>>   
>>   
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 540b377ca8f6..fd84609ff06b 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -901,6 +901,33 @@ struct pci_driver {
>>   	.vendor = (vend), .device = (dev), \
>>   	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>>   
>> +/**
>> + * PCI_DEVICE_FLAGS - macro used to describe a PCI device with specific flags.
>> + * @vend: the 16 bit PCI Vendor ID
>> + * @dev: the 16 bit PCI Device ID
>> + * @fl: PCI Device flags as a bitmap of pci_id_flags enum
>> + *
>> + * This macro is used to create a struct pci_device_id that matches a
>> + * specific device. The subvendor and subdevice fields will be set to
>> + * PCI_ANY_ID.
>> + */
>> +#define PCI_DEVICE_FLAGS(vend, dev, fl) \
>> +	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
>> +	.subdevice = PCI_ANY_ID, .flags = (fl)
>> +
>> +/**
>> + * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
>> + *                                   "driver_override" PCI device.
>> + * @vend: the 16 bit PCI Vendor ID
>> + * @dev: the 16 bit PCI Device ID
>> + *
>> + * This macro is used to create a struct pci_device_id that matches a
>> + * specific device. The subvendor and subdevice fields will be set to
>> + * PCI_ANY_ID and the flags will be set to PCI_ID_F_VFIO_DRIVER_OVERRIDE.
>> + */
>> +#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
>> +	PCI_DEVICE_FLAGS(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>> +
>>   /**
>>    * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>>    * @vend: the 16 bit PCI Vendor ID
>> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
>> index 9bb6c7edccc4..b927c36b8333 100644
>> --- a/scripts/mod/devicetable-offsets.c
>> +++ b/scripts/mod/devicetable-offsets.c
>> @@ -42,6 +42,7 @@ int main(void)
>>   	DEVID_FIELD(pci_device_id, subdevice);
>>   	DEVID_FIELD(pci_device_id, class);
>>   	DEVID_FIELD(pci_device_id, class_mask);
>> +	DEVID_FIELD(pci_device_id, flags);
>>   
>>   	DEVID(ccw_device_id);
>>   	DEVID_FIELD(ccw_device_id, match_flags);
>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>> index 7c97fa8e36bc..f53b38e8f696 100644
>> --- a/scripts/mod/file2alias.c
>> +++ b/scripts/mod/file2alias.c
>> @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
>>   	return 1;
>>   }
>>   
>> -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
>> +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
>>   static int do_pci_entry(const char *filename,
>>   			void *symval, char *alias)
>>   {
>> @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
>>   	DEF_FIELD(symval, pci_device_id, subdevice);
>>   	DEF_FIELD(symval, pci_device_id, class);
>>   	DEF_FIELD(symval, pci_device_id, class_mask);
>> +	DEF_FIELD(symval, pci_device_id, flags);
> I'm a little bit wary of adding a new field to this kernel/user
> interface just for this single bit.  Maybe it's justified but feels
> like it's worth being careful.

Old applications are not aware of these flags.

what worries you ?

>
>> -	strcpy(alias, "pci:");
>> +	if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
>> +		strcpy(alias, "vfio_pci:");
>> +	else
>> +		strcpy(alias, "pci:");
>>   	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
>>   	ADD(alias, "d", device != PCI_ANY_ID, device);
>>   	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
>> -- 
>> 2.18.1
>>
