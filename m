Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39013AA777
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhFPXa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:30:56 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:16672
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234508AbhFPXaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:30:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ld6oBWRYCpWopvFb54gAr6llX/ynUlD0haVRLyBEshMuCievDLz9k3yEoh1L0Vhw9e7N7tJPJZLI+etK6FoJqqyvEtU5Dd73Lttc+NxN9RxkiyoEEAcPdaNfd1aPmGNKDSftGFub4KpP3cDhWGG2mXFvxRQPK4JRr0vF3R92+ADOhvn0aU10llUwKqqBOm3Gq9aiSvlJZ/nEdOF/GhN/gMaclYJ6qV5Cm8kcyTCPCPCJw5358DJYOydCZindplD6pVJZPthNAGo8f9+B02Wbn4ElgmQ4fXZ2BtbOkfuSNpoVXSkesUS4PjA5PdDXy19piQ1jz7QSjZLHC9bbE5+jGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6Wrl8AhJb7RxTXN085N6T9MpmQ//9k3A3EvHBbV4Y=;
 b=A6chxIwWHAoiwJuxmcig7UEpiSqsD7AcGOb66G5Jc8QAh5nXix6P/+AIZef1z2qoVy1VYC/RsMa0kEE6WBzkoJAdIHVPt/EyDVjXzTbH1nHuu9qNAvvt83CRMLjVMx7Bqnd2v8AJHCmsBhYm1jgIJYePwqv98GmA2RBzkXlnY3fIvekWeL/mjilYJ2kqxziYv3yelkvChZCiDqHaEtsyJszDwMu9OaZwUR58//kA3ceR+1s4QeikZf2ot/ktF3Z6BmsiR7NdkX4S36LYPdqCFnO2R2i6QtbEAFiwC/Rb6DMdOdD00HED8ufCOj08E/BW1BZksNh4tB/bymDaHy0EfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6Wrl8AhJb7RxTXN085N6T9MpmQ//9k3A3EvHBbV4Y=;
 b=lEgelAYU5Dn1k6r7ZlTQtKD7Ts5YuwbdhCZvkbXO4GIu6//8tWTpwU0SgMWMiH5MrzXqcqQZC0OagMWfWeV/jU9fAUAsUv+j39r19hB07duJrn3Wq3GzZ5hHiGo7FcLda6rsSx3yvu9ll1ZD09jHcnqeyOaBpS6l33ylCJZcG6gpM27/ckNyUfxMPxUbltNJQybMqEeOxmm9OnsLsO5yeaz6rVrYvv02IuYQ/WFIkIJ3697PNIaq9bPKkluD/K52hM5HCRJ/9f+WyA2HJ15bKHrCQXIMwRGCWBII/df8/JgE2QBbJvBr4bD66ykVXvFedZVothDr3l5GCkroHUsNCg==
Received: from BN6PR13CA0055.namprd13.prod.outlook.com (2603:10b6:404:11::17)
 by DM6PR12MB3609.namprd12.prod.outlook.com (2603:10b6:5:118::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 23:28:46 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::a8) by BN6PR13CA0055.outlook.office365.com
 (2603:10b6:404:11::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend
 Transport; Wed, 16 Jun 2021 23:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 23:28:46 +0000
Received: from [172.27.0.196] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 23:28:40 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <aviadye@nvidia.com>,
        <oren@nvidia.com>, <shahafs@nvidia.com>, <parav@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <cjia@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
 <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
Date:   Thu, 17 Jun 2021 02:28:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616003417.GH1002214@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4534c83-49e4-418d-61ee-08d9311e7ceb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3609:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3609D6BB90D0166E610EC3E4DE0F9@DM6PR12MB3609.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QnBxuiHc9eNgUBjzjirLTcm8pBzUbnv3SExXwH2zwlIvA6zlMIkJ66I8yIf7vPfsyL2pABXM9LYDpmOCwcet8ORZrMpQsRQC87PW0z4hw19Rmy9MOAIsdHQQEyQZAflVDUglYpGLSTOpGyJiPHfoQ7jNU6u7yAkWFVWeHe78py0XfZMvvrnDB1g0csHMSkJTxUDR4EYrigcnM6MtfWKXcPlK9kn7vS7SXPHGXBFqq+aVmRznxtyqU1fLJALAxgjFVJnZmhq5dxg23p36zwq95YEliQTESlIF49zOH9DSu9SJKv3PNYDnnx0s9T57pFcNYi5Ngkjob5+n9apNlM1vptJrtM3tIbNXoVj3kS0euIOd6z9oiP7SS/VGGu4BeYpvskc9J39a8fAaXeqVFd7RtfaLnYYDxCxqFl3609+8uLos2fo6EBKmUBgpCYkkoFx9xoNkptCkVIy4Zm34LxnLJ5ajTU0CKMB1h3NAuQHUYwrhGqge3VJsTNaS9/BnBh/HqWwkN1gfRjlIwteBz0/BFy6fM0Oi4QNdxbKT+vtWokUUpg1bP9ITijh1cRZVcMqSQGzem/KsnRazwYy3J58qdgMdwTW9+V7Q61sHRAqUDw/ZnZZ60ScA2P2mdNtmmknvCvwllHHwpzLM9SOr8IznZJQNvp59Y4AKNKbOT/x0n19KaZ/thtlC2VjuTXb7475
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(31696002)(16576012)(4326008)(426003)(110136005)(186003)(82740400003)(70586007)(16526019)(2906002)(70206006)(36860700001)(336012)(36906005)(5660300002)(26005)(36756003)(316002)(31686004)(8676002)(54906003)(2616005)(356005)(6666004)(478600001)(7636003)(53546011)(86362001)(82310400003)(8936002)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:28:46.2417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4534c83-49e4-418d-61ee-08d9311e7ceb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3609
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2021 3:34 AM, Jason Gunthorpe wrote:
> On Tue, Jun 15, 2021 at 06:22:45PM -0600, Alex Williamson wrote:
>> On Tue, 15 Jun 2021 20:32:57 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:
>>>
>>>>>> b) alone is a functional, runtime difference.
>>>>> I would state b) differently:
>>>>>
>>>>> b) Ignore the driver-override-only match entries in the ID table.
>>>> No, pci_match_device() returns NULL if a match is found that is marked
>>>> driver-override-only and a driver_override is not specified.  That's
>>>> the same as no match at all.  We don't then go on to search past that
>>>> match in the table, we fail to bind the driver.  That's effectively an
>>>> anti-match when there's no driver_override on the device.
>>> anti-match isn't the intention. The deployment will have match tables
>>> where all entires are either flags=0 or are driver-override-only.
>> I'd expect pci-pf-stub to have one of each, an any-id with
>> override-only flag and the one device ID currently in the table with
>> no flag.
> Oh Hum. Actually I think this shows the anti-match behavior is
> actually a bug.. :(
>
> For something like pci_pf_stub_whitelist, if we add a
> driver_override-only using the PCI any id then it effectively disables
> new_id completely because the match search will alway find the
> driver_override match first and stop searching. There is no chance to
> see things new_id adds.

Actually the dynamic table is the first table the driver search. So 
new_id works exactly the same AFAIU.

But you're right for static mixed table (I assumed that this will never 
happen I guess).

If we put the any_id_override id before the non_override AMAZON device 
entry in the pci-pf-stub we'll fail with the matching to the AMAZON device.

What about the bellow untested addition (also remove condition c):

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 296de7bc9dc9..2d46f6cd96f7 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -136,7 +136,7 @@ static const struct pci_device_id 
*pci_match_device(struct pci_driver *drv,
                                                     struct pci_dev *dev)
  {
         struct pci_dynid *dynid;
-       const struct pci_device_id *found_id = NULL;
+       const struct pci_device_id *found_id = NULL, *ids;

         /* When driver_override is set, only bind to the matching driver */
         if (dev->driver_override && strcmp(dev->driver_override, 
drv->name))
@@ -155,8 +155,8 @@ static const struct pci_device_id 
*pci_match_device(struct pci_driver *drv,
         if (found_id)
                 return found_id;

-       found_id = pci_match_id(drv->id_table, dev);
-       if (found_id) {
+       ids = drv->id_table;
+       while ((found_id = pci_match_id(ids, dev))) {
                 /*
                  * if we found id in the static table, we must fulfill the
                  * matching flags (i.e. if PCI_ID_F_DRIVER_OVERRIDE flag is
@@ -164,17 +164,19 @@ static const struct pci_device_id 
*pci_match_device(struct pci_driver *drv,
                  */
                 bool is_driver_override =
                         (found_id->flags & PCI_ID_F_DRIVER_OVERRIDE) != 0;
-               if ((is_driver_override && !dev->driver_override) ||
-                   (dev->driver_override && !is_driver_override))
-                       return NULL;
-       } else if (dev->driver_override) {
-               /*
-                * if we didn't find suitable id in the static table,
-                * driver_override will still , send a dummy id
-                */
-               found_id = &pci_device_id_any;
+               if (is_driver_override && !dev->driver_override)
+                       ids = found_id++; /* continue searching */
+               else
+                       break;
         }

+       /*
+        * if no static match, driver_override will always match, send a 
dummy
+        * id.
+        */
+       if (!found_id && dev->driver_override)
+               found_id = &pci_device_id_any;
+
         return found_id;
  }

diff --git a/drivers/pci/pci-pf-stub.c b/drivers/pci/pci-pf-stub.c
index 45855a5e9fca..49544ba9a7af 100644
--- a/drivers/pci/pci-pf-stub.c
+++ b/drivers/pci/pci-pf-stub.c
@@ -19,6 +19,7 @@
   */
  static const struct pci_device_id pci_pf_stub_whitelist[] = {
         { PCI_VDEVICE(AMAZON, 0x0053) },
+       { PCI_DEVICE_FLAGS(PCI_ANY_ID, PCI_ANY_ID, 
PCI_ID_F_STUB_DRIVER_OVERRIDE) }, /* match all by default (override) */
         /* required last entry */
         { 0 }
  };


>
> We have to fix this patch so flags isn't an anti-match to make it work
> without user regression.
>
> Jason
