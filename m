Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A691B58135B
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiGZMrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 08:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiGZMrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 08:47:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9848C116A;
        Tue, 26 Jul 2022 05:47:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhWTTPK6w4sijpiblltakZtaox92YQFou9MjUb3//gfTl4CTApQ4X7h8IyTyRhntN9zU/AKSFHkZeP8OfqoOhEz3R3XQIZUSYrOcbLddrUkkVda4Vqfub8V2ULVirUyHVP4RWHPmVlXp5Sfb+8aouMuQP20b2oNK2aompgUa1YGBTNWsvmDrSw2KaG6Zj1NzudH2/hsLkL8Dfn3u/37dkwuJhZP4PFw6UpKye/rfnzVTvDnE/OvHhLSHBAr3CMeP01ByWmKNwf/YSF9cuaoxFweNOnAY9JOwo7W37veRxxNmCcLjIOaR7OxdnV2z3Vv57PIf4pbDtml31B1n/5kVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcFk2QUkhi9g+Dib3d7e1laRSDMtqvybI4xE7+NmUSo=;
 b=cd5C2heLwDPHUkFlXfHSxNy5JxSqH0H31RzAMr2Pn6sMxP+oKNJVibfLxr5dImtEJu7cl8xFhTP57IhH4ltaCFzCDFOpvOM9iimJe6N8VV/d8f3z1H7snO7iOuiNKruXbKsYb7VSLtq6qNhA8xa3esOth6/TqFhp2FBXdFy3Bbm9FZOE0Pth7xN2DJiXPZ/3Y9s4I8sJgjZ1Ssz5fCCLsj7OPK2n4ytWRUrLtZ2yldLyWbXVcPNrJQIVRcccmWwmVQZw2NuHbvUn/3xkTn2Xr1TwcuZ0Fy2yb+HGP7H1gUF9zxGfYzMz0KUWaONQhfla6+6ddCC8DCv+MXAIWdMUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcFk2QUkhi9g+Dib3d7e1laRSDMtqvybI4xE7+NmUSo=;
 b=qyx1Y4Rl/CecuBgkU29e2LV1NaU+8ypKsGlfjmwE2embWgQuYKiBTeRRVhNIZwAj2JV4binFntvcd98fwaWFs5v7eOa+DMM+2M3PPgXG/H8i15JQ0g1IKPi+nul4l8qO0yb9o+ZHdiqXjBpHtwPmkZQXQdJvtKP/Cub8JEBBnIYS7eCCR0C+LTf+ZfurzgdL3LshZfJE9zCaYtRS3CsWxq0XrX3t3r8OhdvcxKz12QuFx64lJXIcx66D8XcP2nr8+lO8PWAB7MabWZVH58uEq5hbYZqwUHjqn4jqwl6MhgK14bDaSOwtl5iSsvmMrLLaA05z4vClh+YqT6OhXZFz5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BN8PR12MB3073.namprd12.prod.outlook.com (2603:10b6:408:66::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 12:47:31 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 12:47:31 +0000
Message-ID: <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
Date:   Tue, 26 Jul 2022 18:17:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
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
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220725160928.43a17560.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::17) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e9cca00-fbbf-48ed-6a48-08da6f050130
X-MS-TrafficTypeDiagnostic: BN8PR12MB3073:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: teX6hUpJclA9f1eQR6YYZ7fRqedqjFxNQX1Kaz0weOex0bI/lOwO+gy+W9N+fjBIXsiQlwA5LjTGiseGVcNmbFWdZcBjstL1sn/HcrjlgeobTdGuP7UNAVMP6y8UOpkh5SGlmhCZI7z3TKiCkZjySekZdg/4l7zhF5UwxJKq5yBT3h5xXltRa+6Oh/QHLH8v58+6rzvB4Zu4JUJJ9U5TUxMM6hXfHTdgDFWyczts7c7I/kQ/Kgw9ABodNwg2r6GG67ByIhwgkepRtMxUhldZSyKp2aQvevtWX7tXdNAKTCjq+F4M74YkVLMZZhx76Jph3V2FFZHFT0KXIIdCc1ymKvrBGE1NylxEEyNgU2eyyb4f8BMSItyvaJLaooXY/N99ZQ8yktkIyrVGVvprEclsAUwnXppfMoxULSbfOIUP5YhW2+k1g8kgmUt5zuOxVC0+fJkC5Fr43drusmZGCCaj/avm1lSAopz/v94npoOeuIugxDPSjLdkhfr6HWhKGuTfLQ1qjcI0XRXX2AMEhyV5ZdQmQyIPu3vxE6ogVjU+W9lID46120GEsIzFS9KnZSd+3wI4UPeKShccF757umn6UvNNW10zjvYGZMTUKNy9QgpuMmv+p1MyA1wR2jRaqBYx+esd+ISUnryFS5PedgcPGx7+TAt+R/lf9mkaIbY8T+LrDYxGEHESkUZkR7VLJqrE3VzIdf7eKArE/ZXjHJTnBRUPzvYzbR+aO989c/eVFp63ih5Nj6eSJgebV77RXTXK7akSyVsG2oI7hain6qKBfly3zjSN7kFQHfaUW0/5v/gOKqj5pExTXmdDaWau+VNuZpmMnUxhcyyskGpYPBFJlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(6512007)(186003)(83380400001)(316002)(26005)(4326008)(2906002)(6916009)(54906003)(8676002)(36756003)(31696002)(66946007)(6506007)(55236004)(66556008)(86362001)(66476007)(31686004)(53546011)(5660300002)(7416002)(2616005)(478600001)(30864003)(6486002)(6666004)(41300700001)(8936002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWVvZ21jbE1qWUF1amcvRm50TjJ1ZEd3eUV4MTl2VHRITUlaU1lvcUh6R3Q2?=
 =?utf-8?B?c0lZalpRaFRLSk1EbXlLMTV5dlNJOS9ZeHEzYWRvbGVjRGExbW1lWHp3Z3ZJ?=
 =?utf-8?B?KzlsYUtzekJwYWQ2V3MvclFnTUM2MTliS29ldk1ycUdGZUlWallqRHV1OE9i?=
 =?utf-8?B?REZsUE1qUkR0UXpidUtONWlOVG1ONE8yRCtGWlNGZzFtRnNWRHhFUExhVnYy?=
 =?utf-8?B?VHpFdVJMRlVraWo1SkNWbi9Hb3VtMktCLzJtZDlobTVsZHFQcU0vUTdpRnlX?=
 =?utf-8?B?MDN4dXdMVkNiMDVEa3V0ZDMzRjgySXNpQ1czTkZuelJuTWVlZTVVWktVdkd6?=
 =?utf-8?B?WklnbW9NbUs0NGlTRVFNWEROUEhuZ1lZQlJCWmxLbDgvdVd3cVljbjkvZnRY?=
 =?utf-8?B?N3lqWVBxQ0tBYkI1RlEwbVUxaUpxNllVY20wMklaLzVLQWgvR3RVMmx5SE1i?=
 =?utf-8?B?RnFsc25oQXBOMVpsNVRHT2U1Q3B1ejMrdXlnSHhtMGxoZDVCVStydVJucmFl?=
 =?utf-8?B?N3VmQWJveFU1Ni9LM1JUVStyRlhGZWlRcEZqeHZMS1dmUTQxQWk4U0Rvb1Bt?=
 =?utf-8?B?R0RJTHZxbDlsdTlGOHFucEtRZmUxR1ZpR28yM2lLMGlWc21FdU1qRXkwZGF2?=
 =?utf-8?B?eGpaR3pCTFM4ZTlFK3Zkd1lOS2tyQlBFSTFaaUZwcTVzdW82M2VPODdMY2FL?=
 =?utf-8?B?MGdMdnZ5Tjlnc0dKYzdhaEJLK0s2TkxiY3NLSm8yR0J5cGxvbTAxUzhLeVhF?=
 =?utf-8?B?R3VQeFpPUUxRc0ZUUG9Nd2dMTHRxWHJLTWNCSGROTHB1UTgvWFNXNkxFT1NX?=
 =?utf-8?B?ZW55bWZOVFppZlJMbjFrU2JUSmRQVWpiS1JwRC9GWFBiTnJDU1VRRVhHQ25o?=
 =?utf-8?B?U2ZiS0t4TUZpUDRjbnR5bm1uUWZVTzBXeUsvaU1TZ0dpaFViWEtSc3J1TkFo?=
 =?utf-8?B?TStTMnVHcnJSaEl0ODBOZ2VyeFBlbWF2aDRQSVJFR3g1a2kxME9DNlNJeUJ3?=
 =?utf-8?B?Yjh5Smd6ZFRMczE2d2Ywa2Z6Tk5TR2l2UkVZNmVvalNLMzBsS3hWQ3VIMlQv?=
 =?utf-8?B?bndxdXdmeVZtdHpzNjE2S2F2Wmp2YXNjSnF4VlRmRXdmQ3RhMEVadWZUckVR?=
 =?utf-8?B?cnhLb3pkRTRqeDlDaVBHNm5TdTlGVkMzaDZRRWcyRFh5aGw2MDZtVW4yVUds?=
 =?utf-8?B?TWFhZlI0NEVIMHJBTUJDRDBWL3ZxbkhBdGticGJtYkt1UUFXWkRHTU54YmVh?=
 =?utf-8?B?MEN5b0ZIZWRteHAra1hNYVVkcnU2WHJhQi9FazkxNmRmR0ZiMkJJQnBXK0Zs?=
 =?utf-8?B?UTZEdTgyQ3FVTy9jVEd1VkFMa2RFSGZFTVVxeUxPbzNGam0yS0RoRDd5ZzZ5?=
 =?utf-8?B?WnhDc2tyUktNejJNQkcyYkR1VUw2Z0pvbEkra2hXZ2JSaXphbGFJVzVWckxx?=
 =?utf-8?B?ZzE4S1ljMWozN0JKMGs2K3BCbVJkOW51ZnZlVVEzMU5wWmhENmZlZFcycEo0?=
 =?utf-8?B?S0pYeGx4TG5rLzdFWS9FTkRlWUJad2toeGY4Z25oN2hncTJmTWFtVGs1ckJk?=
 =?utf-8?B?Ylc2dklleGlDMXJBbkQzZ0x2MmY3QUx4SjZOTEFSbmI1cWpYR1RERXc2T0k3?=
 =?utf-8?B?T1IvUVBHazRxRDF6MzJRUFJvcGYwMVJlZ3pycnFCL1ZHS0Mwb3JGUnl0akxi?=
 =?utf-8?B?WlJqQkJTajZ2SGxLT05XeXZtdGZoeWk1NytjdkRmbHJ6bGJQSWYyY1RIcW9T?=
 =?utf-8?B?WTFjWWJuYWVndXl2bDE2K2x0R3F5VnVXY25RNVpwZGp1RnU2L3RzTTh2V3Y0?=
 =?utf-8?B?U1l1SlZRY09ubDR6ZENWK3Qwd1JIaXN6aEtTOFRqa2ZZT2o0L3M3WEV1ME5W?=
 =?utf-8?B?TzZrNVd6SUczeTRmSkNWR2xDaWVnM3NxTjZpc0hGc1JWbXNsOGNqYmdZUzFH?=
 =?utf-8?B?MEdNeEJEUld1Vk5rVllmN3hPRWVoM2M2enNmL2tPRkVtS0tMS3JWNjNsYTJI?=
 =?utf-8?B?NEZZVlM3SmNiajdRZUV1ZGpvOW5vYU5HUGc2MnVCcW80cFRVTEhIcVBZYlJG?=
 =?utf-8?B?RXBYR1RYODhndWpIcitCamU5bW1FeXhOakYvNVpmOXBDWXNybDZPcnFhVGtD?=
 =?utf-8?Q?KIHu+CWbV67l/0OxQleupN7Bv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9cca00-fbbf-48ed-6a48-08da6f050130
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 12:47:31.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TU190nyLu1D779vlqfUUUgi6bdIA6PzATAPW7h7Kno4zolJLm4AJMCQWHV5HpRAuqVKJhSmDKXgASndwK6SoFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3073
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/2022 3:39 AM, Alex Williamson wrote:
> On Mon, 25 Jul 2022 20:10:44 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 7/22/2022 4:04 AM, Alex Williamson wrote:
>>> On Tue, 19 Jul 2022 17:45:19 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> This patch adds the following new device features for the low
>>>> power entry and exit in the header file. The implementation for the
>>>> same will be added in the subsequent patches.
>>>>
>>>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>>>> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
>>>> - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
>>>>
>>>> With the standard registers, all power states cannot be achieved. The  
>>>
>>> We're talking about standard PCI PM registers here, let's make that
>>> clear since we're adding a device agnostic interface here.
>>>   
>>>> platform-based power management needs to be involved to go into the
>>>> lowest power state. For doing low power entry and exit with
>>>> platform-based power management, these device features can be used.
>>>>
>>>> The entry device feature has two variants. These two variants are mainly
>>>> to support the different behaviour for the low power entry.
>>>> If there is any access for the VFIO device on the host side, then the
>>>> device will be moved out of the low power state without the user's
>>>> guest driver involvement. Some devices (for example NVIDIA VGA or
>>>> 3D controller) require the user's guest driver involvement for
>>>> each low-power entry. In the first variant, the host can move the
>>>> device into low power without any guest driver involvement while  
>>>
>>> Perhaps, "In the first variant, the host can return the device to low
>>> power automatically.  The device will continue to attempt to reach low
>>> power until the low power exit feature is called."
>>>   
>>>> in the second variant, the host will send a notification to the user
>>>> through eventfd and then the users guest driver needs to move
>>>> the device into low power.  
>>>
>>> "In the second variant, if the device exits low power due to an access,
>>> the host kernel will signal the user via the provided eventfd and will
>>> not return the device to low power without a subsequent call to one of
>>> the low power entry features.  A call to the low power exit feature is
>>> optional if the user provided eventfd is signaled."
>>>    
>>>> These device features only support VFIO_DEVICE_FEATURE_SET operation.  
>>>
>>> And PROBE.
>>>   
>>
>>  Thanks Alex.
>>  I will make the above changes in the commit message.
>>
>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>> ---
>>>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 55 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index 733a1cddde30..08fd3482d22b 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>>>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>>>  };
>>>>  
>>>> +/*
>>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
>>>> + * with the platform-based power management.  This low power state will be  
>>>
>>> This is really "allow the device to be moved into a low power state"
>>> rather than actually "move the device into" such a state though, right?
>>>   
>>  
>>  Yes. It will just allow the device to be moved into a low power state.
>>  I have addressed all your suggestions in the uAPI description and
>>  added the updated description in the last.
>>
>>  Can you please check that once and check if it looks okay.
>>  
>>>> + * internal to the VFIO driver and the user will not come to know which power
>>>> + * state is chosen.  If any device access happens (either from the host or
>>>> + * the guest) when the device is in the low power state, then the host will
>>>> + * move the device out of the low power state first.  Once the access has been
>>>> + * finished, then the host will move the device into the low power state again.
>>>> + * If the user wants that the device should not go into the low power state
>>>> + * again in this case, then the user should use the
>>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the  
>>>
>>> This should probably just read "For single shot low power support with
>>> wake-up notification, see
>>> VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below."
>>>   
>>>> + * low power entry.  The mmap'ed region access is not allowed till the low power
>>>> + * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
>>>> + * generate the access fault.
>>>> + */
>>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3  
>>>
>>> Note that Yishai's DMA logging set is competing for the same feature
>>> entries.  We'll need to coordinate.
>>>   
>>
>>  Since this is last week of rc, so will it possible to consider the updated
>>  patches for next kernel (I can try to send them after complete testing the
>>  by the end of this week). Otherwise, I can wait for next kernel and then
>>  I can rebase my patches.
> 
> I think we're close, though I would like to solicit uAPI feedback from
> others on the list.  We can certainly sort out feature numbers
> conflicts at commit time if Yishai's series becomes ready as well.  I'm
> on PTO for the rest of the week starting tomorrow afternoon, but I'd
> suggest trying to get this re-posted before the end of the week, asking
> for more reviews for the uAPI, and we can evaluate early next week if
> this is ready.
> 

 Sure. I will re-post the updated patch series after the complete testing.
 
>>>> +
>>>> +/*
>>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
>>>> + * with the platform-based power management and provide support for the wake-up
>>>> + * notifications through eventfd.  This low power state will be internal to the
>>>> + * VFIO driver and the user will not come to know which power state is chosen.
>>>> + * If any device access happens (either from the host or the guest) when the
>>>> + * device is in the low power state, then the host will move the device out of
>>>> + * the low power state first and a notification will be sent to the guest
>>>> + * through eventfd.  Once the access is finished, the host will not move back
>>>> + * the device into the low power state.  The guest should move the device into
>>>> + * the low power state again upon receiving the wakeup notification.  The
>>>> + * notification will be generated only if the device physically went into the
>>>> + * low power state.  If the low power entry has been disabled from the host
>>>> + * side, then the device will not go into the low power state even after
>>>> + * calling this device feature and then the device access does not require
>>>> + * wake-up.  The mmap'ed region access is not allowed till the low power exit
>>>> + * happens.  The low power exit can happen either through
>>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
>>>> + * wake-up notification has been generated).  
>>>
>>> Seems this could leverage a lot more from the previous, simply stating
>>> that this has the same behavior as VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>>> with the exception that the user provides an eventfd for notification
>>> when the device resumes from low power and will not try to re-enter a
>>> low power state without a subsequent user call to one of the low power
>>> entry feature ioctls.  It might also be worth covering the fact that
>>> device accesses by the user, including region and ioctl access, will
>>> also trigger the eventfd if that access triggers a resume.
>>>
>>> As I'm thinking about this, that latter clause is somewhat subtle.
>>> AIUI a user can call the low power entry with wakeup feature and
>>> proceed to do various ioctl and region (not mmap) accesses that could
>>> perpetually keep the device awake, or there may be dependent devices
>>> such that the device may never go to low power.  It needs to be very
>>> clear that only if the wakeup eventfd has the device entered into and
>>> exited a low power state making the low power exit ioctl optional.
>>>   
>>
>>  Yes. In my updated description, I have added more details.
>>  Can you please check if that helps.
>>
>>>> + */
>>>> +struct vfio_device_low_power_entry_with_wakeup {
>>>> +	__s32 wakeup_eventfd;
>>>> +	__u32 reserved;
>>>> +};
>>>> +
>>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
>>>> +
>>>> +/*
>>>> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
>>>> + * state.  
>>>
>>> Any ioctl effectively does that, the key here is that the low power
>>> state may not be re-entered after this ioctl.
>>>   
>>>>  This device feature should be called only if the user has previously
>>>> + * put the device into the low power state either with
>>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
>>>> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the  
>>>
>>> Doesn't really seem worth mentioning, we need to protect against misuse
>>> regardless.
>>>   
>>>> + * device is not in the low power state currently, this device feature will
>>>> + * return early with the success status.  
>>>
>>> This is an implementation detail, it doesn't need to be part of the
>>> uAPI.  Thanks,
>>>
>>> Alex
>>>   
>>>> + */
>>>> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
>>>> +
>>>>  /* -------- API for Type1 VFIO IOMMU -------- */
>>>>  
>>>>  /**  
>>>   
>>
>>  /*
>>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
>>   * state with the platform-based power management.  This low power state will
>>   * be internal to the VFIO driver and the user will not come to know which
>>   * power state is chosen.  If any device access happens (either from the host
> 
> Couldn't the user look in sysfs to determine the power state?  There
> might also be external hardware monitors of the power state, so this
> statement is a bit overreaching.  Maybe something along the lines of...
> 
> "Device use of lower power states depend on factors managed by the
> runtime power management core, including system level support and
> coordinating support among dependent devices.  Enabling device low
> power entry does not guarantee lower power usage by the device, nor is
> a mechanism provided through this feature to know the current power
> state of the device."
> 
>>   * or the guest) when the device is in the low power state, then the host will
> 
> Let's not confine ourselves to a VM use case, "...from the host or
> through the vfio uAPI".
> 
>>   * move the device out of the low power state first.  Once the access has been
> 
> "move the device out of the low power state as necessary prior to the
> access."
> 
>>   * finished, then the host will move the device into the low power state
> 
> "Once the access is completed, the device may re-enter the low power
> state."
> 
>>   * again.  For single shot low power support with wake-up notification, see
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  The mmap'ed region
>>   * access is not allowed till the low power exit happens through
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will generate the access fault.
> 
> "Access to mmap'd device regions is disabled on LOW_POWER_ENTRY and
> may only be resumed after calling LOW_POWER_EXIT."
> 
>>   */
>>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
>>
>>  /*
>>   * This device feature has the same behavior as
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
>>   * provides an eventfd for wake-up notification.  When the device moves out of
>>   * the low power state for the wake-up, the host will not try to re-enter a
> 
> "...will not allow the device to re-enter a low power state..."
> 
>>   * low power state without a subsequent user call to one of the low power
>>   * entry device feature IOCTLs.  The low power exit can happen either through
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
>>   * wake-up notification has been generated).
>>   *
>>   * The notification through eventfd will be generated only if the device has
>>   * gone into the low power state after calling this device feature IOCTL.
> 
> "The notification through the provided eventfd will be generated only
> when the device has entered and is resumed from a low power state after
> calling this device feature IOCTL."
> 
> 
>>   * There are various cases where the device will not go into the low power
>>   * state after calling this device feature IOCTL (for example, the low power
>>   * entry has been disabled from the host side, the user keeps the device busy
>>   * after calling this device feature IOCTL, there are dependent devices which
>>   * block the device low power entry, etc.) and in such cases, the device access
>>   * does not require wake-up.  Also, the low power exit through
> 
> "A device that has not entered low power state, as managed through the
> runtime power management core, will not generate a notification through
> the provided eventfd on access."
> 
>>   * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT is mandatory for the cases where the
>>   * wake-up notification has not been generated.
> 
> "Calling the LOW_POWER_EXIT feature is optional in the case where
> notification has been signaled on the provided eventfd that a resume
> from low power has occurred."
> 
> We should also reiterate the statement above about mmap access because
> it would be reasonable for a user to assume that if any access wakes
> the device, that should include mmap faults and therefore a resume
> notification should occur for such an event.  We could implement that
> for the one-shot mode, but we're choosing not to.
> 
>>   */
>>  struct vfio_device_low_power_entry_with_wakeup {
>> 	 __s32 wakeup_eventfd;
>> 	 __u32 reserved;
>>  };
>>
>>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
>>
>>  /*
>>   * Upon VFIO_DEVICE_FEATURE_SET, prevent the VFIO device low power state entry
>>   * which has been previously allowed with VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
>>   * or VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
>>   */
> 
> "Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states
> as previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.  This
> device feature ioctl may itself generate a wakeup eventfd notification
> in the latter case if the device has previously entered a low power
> state."
> 
> Thanks,
> Alex
> 

 Thanks Alex for your thorough review of uAPI.
 I have incorporated all the suggestions.
 Following is the updated uAPI.
 
 /*
  * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
  * state with the platform-based power management.  Device use of lower power
  * states depends on factors managed by the runtime power management core,
  * including system level support and coordinating support among dependent
  * devices.  Enabling device low power entry does not guarantee lower power
  * usage by the device, nor is a mechanism provided through this feature to
  * know the current power state of the device.  If any device access happens
  * (either from the host or through the vfio uAPI) when the device is in the
  * low power state, then the host will move the device out of the low power
  * state as necessary prior to the access.  Once the access is completed, the
  * device may re-enter the low power state.  For single shot low power support
  * with wake-up notification, see
  * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
  * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
  * calling LOW_POWER_EXIT.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
 
 /*
  * This device feature has the same behavior as
  * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
  * provides an eventfd for wake-up notification.  When the device moves out of
  * the low power state for the wake-up, the host will not allow the device to
  * re-enter a low power state without a subsequent user call to one of the low
  * power entry device feature IOCTLs.  Access to mmap'd device regions is
  * disabled on LOW_POWER_ENTRY_WITH_WAKEUP and may only be resumed after the
  * low power exit.  The low power exit can happen either through LOW_POWER_EXIT
  * or through any other access (where the wake-up notification has been
  * generated).  The access to mmap'd device regions will not trigger low power
  * exit.
  *
  * The notification through the provided eventfd will be generated only when
  * the device has entered and is resumed from a low power state after
  * calling this device feature IOCTL.  A device that has not entered low power
  * state, as managed through the runtime power management core, will not
  * generate a notification through the provided eventfd on access.  Calling the
  * LOW_POWER_EXIT feature is optional in the case where notification has been
  * signaled on the provided eventfd that a resume from low power has occurred.
  */
 struct vfio_device_low_power_entry_with_wakeup {
 	__s32 wakeup_eventfd;
 	__u32 reserved;
 };
 
 #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
 
 /*
  * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
  * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
  * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
  * This device feature IOCTL may itself generate a wakeup eventfd notification
  * in the latter case if the device has previously entered a low power state.
  */
 #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5

 Regards,
 Abhishek
