Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A8D52CB4E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiESEvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiESEv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:51:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9540B6006B;
        Wed, 18 May 2022 21:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjxCenHsgUIutv6rVeyxaXRvox4dmoiNU3f7NzgccsrHc2i5poUxllO/253DzTKE8xZ9wwMC3uaNZP7FN4RfiI0teqAQm9lFzkv4pEdPQcgWIzfWqrmzTBkQurpUFX9wHUf/mKgcV6XBZFeXhd5FXcStVVLcVlSGW363p7+1M5bN1nh5XhSTKdlGuUd+V4uc74/BpBq8X47lVYYwgEbrYgzj4zvxECZQmAKYli8/Q3a+LY4yrwNp8nlyZL2YxHSNDIbbZErXjbWdD9AdZG0zsGqaHmTyxD53hP9tI+b/BS23AwzKaYWBIw4eIvJRMRYMgtnLv1aAARYn7uct9j7Cgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzbdJn5EzG5ObOU3k9kLFLGfyTm2EnVBo0lWEPQMJ0Y=;
 b=B3CtvdvhrP/KRYUBZN2nBkecxwrRWH1FiBZi/udLWQrgo724r7sByCNyIL8JhBauSzkPT/kcmQKkzLHFQMfMcYxL0mEDGj6sFPYpOhhsGZ/6S7ajaNLx5jUcPGBSNwbjOTfXLbkb7sIeBf+wKpzsvbL5c+/1dFvOeTG26zgJZ3qbxn1AdjSl+Lm+D76bAt7b1HzcOKAukWZc88MdvdyX8woiBUvwkE4GiMu2+p+UNsm0FEhKMsPqbCmV8bBElsvgQ5GwlNnIKuelox0chQ5Lna9+A0ce91M4hZ2MMjJxIbAzpLQm1/QHo2SgDRTqeC5GiPE52SyTG+i3/QOUuhQNQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzbdJn5EzG5ObOU3k9kLFLGfyTm2EnVBo0lWEPQMJ0Y=;
 b=V3O1NTvXeR2U0imRzs8L7XVd9hvtM3ju4UvEWO0yhjOy4EzLz1ZtBKVgcqPNjw31U4Qo8+ULwkejIRr3hCYxO7EbMMMCcA0KzwCkSGxLq4T4GBks+uBrk9Ur4zkpYYGxJy41yevrinbaa4lLxBqEG6byKXKRb2NHyvnZ+6lOqASSxRLKGVmWPC7keq2DU+W6UScPoXjN2U7wGSKPJfu9egeMnjW69fTxpCMdpCjcSSU0vnzsFLt+imEN2Jk4KTtz7r2kFtkgGU+l9s7r+Jl6BKbh6hJ3ZU81E/ZZ5GRFdTZZM4MRRd/vhDUwX/Clamf5VySbBehZadjYNVUZaIfrmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 04:51:24 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 04:51:24 +0000
Message-ID: <55436bdc-fd09-fdb8-50b1-af088d594a72@nvidia.com>
Date:   Thu, 19 May 2022 10:21:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 0/4] vfio/pci: power management changes
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220518111612.16985-1-abhsahu@nvidia.com>
 <20220518115129.72beddcd.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220518115129.72beddcd.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::13) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fdc7170-1e25-476a-9ed7-08da3953399d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5972:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5972119D9B880237FABD93D0CCD09@BL1PR12MB5972.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLhNoSsu96PSqoFJ9+1Ol9hOOLQDye6b7VdlOFpUq5tVS5og84unIrTc3FZPIORhX7iw70mdmuvgfDauFyQw5nyYAeDQr+Z2g+ibW018Dg9RGaNZ4U9GR2pd723rYqzQsfW1Wq8oUMJmWejK5aO3ChiuFVqe9qUdCLmPh57sCvwQc75uB8Ejm9O9Z/99pjPrtkfEsmjA6ccjsiBdTAtcii5jcxbSolExfoh+J48qB9eW7Orf8tcNDus/p9aKu03YUMDzKP11RVMdngYVy+rejUSaW/z9zYFktY3wRNf/iI5WogmGtrFciPnvua1tQe24we+xOfspLnV4vmCDRtFLLq0KtnbvhHijJU9ORXMUe9A5Y48ZB9hOekDVfCSNA5m6DC0BDpbWnhdV78jO/qsZ3qQdcgbNUXJf+BGyFFms2scuL0FUeqVAkPpjtI4LMrrDBRSEKOuqNGTKDuNqyjE1FzE9VVj4f2VWhNm6/YV6XGFZfqO5I0BqbIEI457wI4TdZNOtY4Anb9TEvVUZO5oHvUIsxH97tbtcDSIhwivFaOCwFoH0OKDSa+kD0I72DzP59Ztle4QnWcegZHK97uGVQq4ahc0T62lx37DSOXR3AMnLIl4UAozYItc/DptGc+Ed1ZsC5VdghFkZ9R0Yayy61RnNQfG61TdksLXNnhftLsYY22fkM9oPDBX/skAMhBeBuD3TghRcrUvW6V+VwgM944dX4BkBPk5L1jthMp5Rqge/xqKcq723Ig+CMHfHACzdngXE2nTycUotiYQhSpRINJ/GDCxUH0guu0lp72gSBGGVqoAEUhOqM4noW3DAh0G/qvJTsauP5QuvVgMjxYm6epS9URDJE+xirrVCH02RzUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(54906003)(6486002)(6916009)(508600001)(5660300002)(7416002)(86362001)(31696002)(2906002)(38100700002)(66556008)(66946007)(66476007)(4326008)(186003)(8676002)(2616005)(83380400001)(316002)(8936002)(55236004)(53546011)(6506007)(6512007)(26005)(6666004)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnlJckVHSkFsdTZoTFBzMlJXR0tNNWlTRjNaMy9vNmQ4azFnVVRhYVFOWFcx?=
 =?utf-8?B?SFptcjNhdk5BdVlyWncyVzdHTHp0b1llbkhBejlRNXo1d3BNK3l1UDJKK1Q1?=
 =?utf-8?B?UlI4RmZBUEV1QUpZSFN3VDJLQWJBTTM5d3NxUno1NWFGOHkrQnRZWldnOWd5?=
 =?utf-8?B?T214QmRyRG9SbnJsdGh4Z041K1pWZWxyck52R1lMTnowZG0yVUI4RVN3V1Bx?=
 =?utf-8?B?YkY4NjdrQ2lUaDBTbTh1bWdQS0x2NERXZDVENW94a2tOdzFUQUZzSkNXa1Q3?=
 =?utf-8?B?b05WMmkweWZYR1JsV0JqcFV0cm91SE5INlVzSnljVzJVZjBXZU43cFJMR280?=
 =?utf-8?B?UG85WEJ1YkZNSjlUSUR1MVJrS3F1M2dNcWQ4V2l2NVhyejVNSEN5NTFwK0tj?=
 =?utf-8?B?RXZLTyt2a2lOQzdrYUVtbDdzZTdUQ2k2TndxZDRrOWJ5NEFPS3NpMy9UTVRR?=
 =?utf-8?B?R3dzNVBmdDR2SlBWUmU3S0lBNHo3NW5lVCtIazR0dTgxaXFjNFpuZ2pldUtj?=
 =?utf-8?B?YXczTk5UNXd5QStyYzFKTWZEQytlY0l1T2U0OWdHV0prY1I5eUgvUlJ0R3lC?=
 =?utf-8?B?Q0dtMHVxYkduSGhOU1kvUnNlb0JkKzFvbkVjTnYrYkh1ZVVyaTIveVdHemNz?=
 =?utf-8?B?bTZkSWRWTmFDampDRWNGeUVHMHc5Ty9HYkc5ZHdrMmVEWG9IblVVaHZHYncr?=
 =?utf-8?B?RlVqcTlXRkwzMHBYaWJLN1ZxeVQ0dTdwUTdhcTAxV1FSMS9nSFRNVVludk5y?=
 =?utf-8?B?YWZndjBqY1N2ZXJXWkgvdXQyaFY1aTFzTmVkUFZQdzJ1STZiWTJQNG5FbmVv?=
 =?utf-8?B?Ums0N1ozU1NnbS9xM3RIbzU2OTJwNCtQSHhpRUI3VFVKc2k1OTBiQ2FQUVFM?=
 =?utf-8?B?eXd3U0l0NlE2c2Vab3cxZmh2VEZoR0VCd1BpRVRtaEpNNEtIblQ1b2lnSlRN?=
 =?utf-8?B?bHlsRkVlM0FidEtwYjZodllvUEZHZnhWcDA5eGhYNHprVXJucGNEZHdmSkhN?=
 =?utf-8?B?STZUN0s3aS9VVGo3UU5YaWJqaTlJL1NzM1RZa29kV3ErLzZVWFk4WGxYWVZD?=
 =?utf-8?B?cGNrbVFvTnJQZXpDOUpiS0xDK3NTOVpsTGVjWi9MbVc2V1RrdFhVNXV0YkZY?=
 =?utf-8?B?QWRFUEVDa1dCdlN0RUF4SXphS1NBQ3JIUXRTamdjTWxhZE5maTc1NUtTT21u?=
 =?utf-8?B?bXVCancrNDBUUStrbnZ3RlVpV2YxUC9uTkd1c2RPZENWYVBGU0FFSDZXU2xt?=
 =?utf-8?B?RWtHVVN6N2ZnbWE3UGV6cG82d1JzMGl3a2VMM3hLY2FqMkVoMndKbzVsUVF6?=
 =?utf-8?B?Ti8zd2Z5VGx1YVhOSU8weFhZK3NHdUhvb2Mvek4wejdZbzFWcjJiMTkwUGhh?=
 =?utf-8?B?MnZUL0xGb003Ym0vMkg5cXIwQjdrOU5rMVVYUzZqenZOTnpqZUpwb016OHcx?=
 =?utf-8?B?VGNsQS9aSU5IVTVkRE1meXI5V0JIVGIzd05sZWN4QWNLblNPTXlVYjVQeFA2?=
 =?utf-8?B?QmM2aG03Q1V5cTlzZDBCK0Q3U2ora1dQSkZwNEl1aE5oZ3p6VjlkWks4azA2?=
 =?utf-8?B?QnlOeXhZaG9oV2k1YjRncWx0dlUreUM0RjZMWXZXRC9qT0hLNm1LK2tHZlNT?=
 =?utf-8?B?bXVpbG96allOeEYvMHNmOWZSZGQrUFdBd2xBVDZXL2ZaWmgvQzNDRCtjL2F4?=
 =?utf-8?B?blFFanNZRGxsUzRST0hkY29QaXRJNUJpc01aVFFGMHlkejVCU2FMYXZsTmRR?=
 =?utf-8?B?WllpSStCbm5rMFM2dEpLRkxHRUtZakhuLzJ6ZmF3WS8zL1kvTVFMcExWU3VO?=
 =?utf-8?B?bjU2eFhpVmkzNkJyZDBxSUR3Q1M0TW9HdmduT2EzaWtRdG5vVkl5OW1aTHBC?=
 =?utf-8?B?RkxON25HV29OT04rdVdtWWpZdXBVTWdJZmJWcWY2RjE0ZHl0clhleHNqTWh0?=
 =?utf-8?B?bWFtcHpwNDdRRlN2SVR0a2RQR0c0djQvZWl3V0ZKS0xxWElib295Z2pRMUNN?=
 =?utf-8?B?MVJQNStjeWdHVVY0MW5rYy9BR3VRTllOMjBoajZrK1lIUmlaSkwzRitlQXhU?=
 =?utf-8?B?RFZzMXhiQVBBaWROT1RMWGVqTG4wZDFML0cwVjFJL0pFSVZUYW42eHZ6T3B5?=
 =?utf-8?B?aTRoamdGVEtTQStjdkY3Y1E5eUdWNG92WDBJMnN3bG1CbzNpeE9TempxS0s4?=
 =?utf-8?B?OW4yNTB3bmJVZW9VYVlNMWV6bW1hU0ZnYWF2M3hzdzRkek8rczVwNzdLRnF2?=
 =?utf-8?B?djJ5azhubE1EZUlDbjM5enZlUFAyMGpFVHBBZFM4ZU11V3dxTVVYV2NLZDZo?=
 =?utf-8?B?ZzdBT0RkeWl5bS9FSlpNM3NkNk1PTndTVHJNMnArN082RlBFQ2dvZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fdc7170-1e25-476a-9ed7-08da3953399d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 04:51:24.1795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1OLUUKuuC0GmM6MuqHI932h7nQ+IB9xrTOnu32v9DN3eBoIW5yKgYwMItbac0AWFqP/o950QoS1zyN+qka5sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/2022 11:21 PM, Alex Williamson wrote:
> On Wed, 18 May 2022 16:46:08 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, there is very limited power management support available
>> in the upstream vfio-pci driver. If there is no user of vfio-pci device,
>> then it will be moved into D3Hot state. Similarly, if we enable the
>> runtime power management for vfio-pci device in the guest OS, then the
>> device is being runtime suspended (for linux guest OS) and the PCI
>> device will be put into D3hot state (in function
>> vfio_pm_config_write()). If the D3cold state can be used instead of
>> D3hot, then it will help in saving maximum power. The D3cold state can't
>> be possible with native PCI PM. It requires interaction with platform
>> firmware which is system-specific. To go into low power states
>> (including D3cold), the runtime PM framework can be used which
>> internally interacts with PCI and platform firmware and puts the device
>> into the lowest possible D-States.
>>
>> This patch series registers the vfio-pci driver with runtime
>> PM framework and uses the same for moving the physical PCI
>> device to go into the low power state for unused idle devices.
>> There will be separate patch series that will add the support
>> for using runtime PM framework for used idle devices.
>>
>> The current PM support was added with commit 6eb7018705de ("vfio-pci:
>> Move idle devices to D3hot power state") where the following point was
>> mentioned regarding D3cold state.
>>
>>  "It's tempting to try to use D3cold, but we have no reason to inhibit
>>   hotplug of idle devices and we might get into a loop of having the
>>   device disappear before we have a chance to try to use it."
>>
>> With the runtime PM, if the user want to prevent going into D3cold then
>> /sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
>> devices where the above functionality is required instead of
>> disallowing the D3cold state for all the cases.
>>
>> The BAR access needs to be disabled if device is in D3hot state.
>> Also, there should not be any config access if device is in D3cold
>> state. For SR-IOV, the PF power state should be higher than VF's power
>> state.
>>
>> * Changes in v5
>>
>> - Rebased over https://github.com/awilliam/linux-vfio/tree/next.
>> - Renamed vfio_pci_lock_and_set_power_state() to
>>   vfio_lock_and_set_power_state() and made it static.
>> - Inside vfio_pci_core_sriov_configure(), protected setting of
>>   power state and sriov enablement with 'memory_lock'.
>> - Removed CONFIG_PM macro use since it is not needed with current
>>   code.
> 
> Applied to vfio next branch for v5.19.  Thanks!
> 
> Alex
> 

 Thanks Alex for your thorough review and support in getting
 this series merged. I will start exploring for the second part
 and will find out a generic way to support all the use cases.

 Regards,
 Abhishek
  
>> * Changes in v4
>>   (https://lore.kernel.org/lkml/20220517100219.15146-1-abhsahu@nvidia.com)
>>
>> - Rebased over https://github.com/awilliam/linux-vfio/tree/next.
>> - Split the patch series into 2 parts. This part contains the patches
>>   for using runtime PM for unused idle device.
>> - Used the 'pdev->current_state' for checking if the device in D3 state.
>> - Adds the check in __vfio_pci_memory_enabled() function itself instead
>>   of adding power state check at each caller.
>> - Make vfio_pci_lock_and_set_power_state() global since it is needed
>>   in different files.
>> - Used vfio_pci_lock_and_set_power_state() instead of
>>   vfio_pci_set_power_state() before pci_enable_sriov().
>> - Inside vfio_pci_core_sriov_configure(), handled both the cases
>>   (the device is in low power state with and without user).
>> - Used list_for_each_entry_continue_reverse() in
>>   vfio_pci_dev_set_pm_runtime_get().
>>
>> * Changes in v3
>>   (https://lore.kernel.org/lkml/20220425092615.10133-1-abhsahu@nvidia.com)
>>
>> - Rebased patches on v5.18-rc3.
>> - Marked this series as PATCH instead of RFC.
>> - Addressed the review comments given in v2.
>> - Removed the limitation to keep device in D0 state if there is any
>>   access from host side. This is specific to NVIDIA use case and
>>   will be handled separately.
>> - Used the existing DEVICE_FEATURE IOCTL itself instead of adding new
>>   IOCTL for power management.
>> - Removed all custom code related with power management in runtime
>>   suspend/resume callbacks and IOCTL handling. Now, the callbacks
>>   contain code related with INTx handling and few other stuffs and
>>   all the PCI state and platform PM handling will be done by PCI core
>>   functions itself.
>> - Add the support of wake-up in main vfio layer itself since now we have
>>   more vfio/pci based drivers.
>> - Instead of assigning the 'struct dev_pm_ops' in individual parent
>>   driver, now the vfio_pci_core tself assigns the 'struct dev_pm_ops'. 
>> - Added handling of power management around SR-IOV handling.
>> - Moved the setting of drvdata in a separate patch.
>> - Masked INTx before during runtime suspended state.
>> - Changed the order of patches so that Fix related things are at beginning
>>   of this patch series.
>> - Removed storing the power state locally and used one new boolean to
>>   track the d3 (D3cold and D3hot) power state 
>> - Removed check for IO access in D3 power state.
>> - Used another helper function vfio_lock_and_set_power_state() instead
>>   of touching vfio_pci_set_power_state().
>> - Considered the fixes made in
>>   https://lore.kernel.org/lkml/20220217122107.22434-1-abhsahu@nvidia.com
>>   and updated the patches accordingly.
>>
>> * Changes in v2
>>   (https://lore.kernel.org/lkml/20220124181726.19174-1-abhsahu@nvidia.com)
>>
>> - Rebased patches on v5.17-rc1.
>> - Included the patch to handle BAR access in D3cold.
>> - Included the patch to fix memory leak.
>> - Made a separate IOCTL that can be used to change the power state from
>>   D3hot to D3cold and D3cold to D0.
>> - Addressed the review comments given in v1.
>>
>> * v1
>>   https://lore.kernel.org/lkml/20211115133640.2231-1-abhsahu@nvidia.com/
>>
>> Abhishek Sahu (4):
>>   vfio/pci: Invalidate mmaps and block the access in D3hot power state
>>   vfio/pci: Change the PF power state to D0 before enabling VFs
>>   vfio/pci: Virtualize PME related registers bits and initialize to zero
>>   vfio/pci: Move the unused device into low power state with runtime PM
>>
>>  drivers/vfio/pci/vfio_pci_config.c |  56 ++++++++-
>>  drivers/vfio/pci/vfio_pci_core.c   | 178 ++++++++++++++++++++---------
>>  2 files changed, 178 insertions(+), 56 deletions(-)
>>
> 

