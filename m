Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2C53799D
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiE3LQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiE3LQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:16:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687BF79816;
        Mon, 30 May 2022 04:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC5uGF4OrcJ32yumbjU73EO1Mqv01A2bdT3oZkItLjY/Sj6H0bnE55/XHTjYTZJ9/1IbeIAbmFxTtB0ydxgvTFoIUm3xtFuU8Kb96lioPt4gF4mDe6z4jdky2m9ULpak99YhAtYGNpTDpwrp0dR9tE98W1l/aYsMbblU6V4PfGuIlCw5OZj2GjvPz1+dmkUOpV17d4swltOjTNX24AarMjrVye0JX6ocBjY1nS2XZWTPKmUHV7XMQ/tYMy4bsbfMR8hKqyzxp6H/iwmXKYZtHmooT3bnfbAhcWZ2MIL7XUotgazIW1BIP79RpdRKqtozjNJnU/BAL0JKEuN5RT39Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naulN5dkwCZ1apl2sGo4J037c65lIyBiKWZmCCOzD2M=;
 b=GtnenudmpFHZEHgN2d7eYW05xYmLtsvMBxfX1/vGVu6jHGSPJxF9KtnryCIzon/JhrWuXCy6lZDcLslLEtIQ2w2fe4HaHsJajiasHYdK3wjbAhtDOcHSDP1IdP7XwdXoDsbvfxTNUtNXokoU4gRROeQIFej7yOlUfqeI60TfUT2GGRta5ANqwScv7HihtebzN/0xguouJC6FxKJ+hhRhZVjXCt85BbfFTqAPgfTyzsOqGH8TnvQVh8aG6nUSfaabyuZifeQw1aS4hx8dK6bLnq0KsqUihpVM5drJcHVT89Rsjjs9hZs2JTVBI8pRHsEiptCOb8fIsGCD9f7uObAbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naulN5dkwCZ1apl2sGo4J037c65lIyBiKWZmCCOzD2M=;
 b=DnXhAS8CEPrTwrP9n9Hs23ixUMNr46uBcv/zdwQfzQ0AjXPxmnBubvSk9SV7WECNBVQqlzDYw5YmyP7su3504i1KXK1+4KXsOSZfaMgFlGv8BA7rXPvEowGdRgsFjfuXXEsiAdYx2P7PVMUlQ9acvjHgbGHOwWct6MXxYRWUROB+Af8Mjq/7lRxVLm2Hva0+1SAA2aRkKdi5kRaukMNh6znLQDpsk7MjY9wuU4qCdtQqrfMdjf3PM3xlsvgd2pl+NeRbMEFi74AeSxiQ7Wm0aFK5f/R6q9JUnMSLk14W3Ph03P7e/Yp71pIug3H2zyZidRJ3voNVomnIJJHyibYBsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (13.101.96.13) by
 DM6PR12MB2779.namprd12.prod.outlook.com (20.176.114.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.17; Mon, 30 May 2022 11:16:12 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::b844:73a2:d4b8:c057%6]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 11:16:12 +0000
Message-ID: <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
Date:   Mon, 30 May 2022 16:45:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
From:   Abhishek Sahu <abhsahu@nvidia.com>
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
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0106.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::16) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 556850db-001a-4700-6f69-08da422dce02
X-MS-TrafficTypeDiagnostic: DM6PR12MB2779:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB27792B1BCD2F03E8AA869E8ECCDD9@DM6PR12MB2779.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXopM+7te/efh+G0oOB7oItImQ51SPQod5iTwpsvSJlGFiSylZppLmmEMBCs5qDGlitbJVulK1t9Emvy4WaBTi4p8NlCjuFrHOSiETZ3KS3chraQm73ecdLi65QAkchbupMjXVx35JFbewDmK4Pe/FOHDl17D0NeQu4+mTOR4SwpDw/yZ5lKNheav7uJJE/7/4phMSNELiACN7d94RLPCgwf88sYeboQ33euU7I/B6DGlzzIfOb2wsnm/en8BBP+jNQNutRU/VzUVOGPZL6hNBHyYHjdGzJZG1KX0hPfILdnNbFDtm1QiBpxNzSQtdJXhEU+dZo0FnTvC4Da0FhRYdQRy3BFjKcuMDvRiAvm1IfcbZgfaT/Qvep9sG8P2rn2W2YTiEWEr6YZh3ilNrTm46ZM+jaJmEEHP8MCELfD4dqqxKT6SiexD/YScOlrK215EiuFq2nxNtLZxV+Qe+WCNagM2gwoM6qsYiGYBwxiXJwk+pIsd/YV8DGjgoBZuGpGIR38fA5EMAzwdZpnjIXy9BKMkLUVUlHDBlxUdwA4Krx/5D/5ifii+MH1ijoqrjN82E1m7YROUhCXAJn7ghwdsIBH1jcfoFvKQVb19FwJCqnZI9TuIkNJGJjnwPW9t7LtGHPWG9yAYf5KJ3axVxIcY9NQMuktQ6Al1yyrKPNVVk2vYPhP+XIeEtoLnU44QhozyjfuD6NgVtV6hW3TZ7XCeo97luHOFNfkiW6JLFfntFocM35gZQYkmowKoKC3UNh5MndBGlHXRzxeGOxgQfeBnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(54906003)(38100700002)(31686004)(2616005)(2906002)(6916009)(316002)(26005)(6512007)(53546011)(6506007)(86362001)(55236004)(5660300002)(31696002)(186003)(66946007)(4326008)(66556008)(66476007)(8676002)(83380400001)(6666004)(8936002)(7416002)(508600001)(6486002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3E0ZGR4YnBWNFQvYXBzUWhLeVB6NlN3aDBiem44SFhETWIyRUhHRkkyNHZC?=
 =?utf-8?B?MWJ6RVVodTE4NXg3SFBLeVhQd01IclQ4VkxYd2ozSzIyMXE1WHl1THhvSjB3?=
 =?utf-8?B?aEhjV2VXT2t1QlI0U1BTdlB3Q21lSkVTVVY0MDNmUXByRmxFVEFnYUpWc25S?=
 =?utf-8?B?blphNk5lbjVZSGhTQjByRVloaXlMcjRoMzRYQUxPWXcySDdTVloxUlF4R2tC?=
 =?utf-8?B?VUhWS0ZHcGg5Qnl2NUpoK0JEallmOWo4SG9wVmNLanowdEJocTNIbzNRSlh3?=
 =?utf-8?B?enFCMUxlaDJXRmJCRUFBcWx3SVQ1NVE4WHhaWk9SYWViTmpaVms4OGd2Sk03?=
 =?utf-8?B?bkFIMTVWUWhXVTlOd1Q3UnJZWWFDbm44b3FPRHRuTTIrMTZFMWJJaWp2UEI3?=
 =?utf-8?B?RVhKODhKaVpGeFpySG1lb1JmNVVyNHBmR0xhWmtzSGRUYndiMHRTQ0t2bVR2?=
 =?utf-8?B?SndiRjlsZ3BsZDk0d09xSFB5ZWQ2Z1U4WG1XZHJ6dis2anh5QWkvMnFwYXlZ?=
 =?utf-8?B?eHJxWlpFT1Q5QmxFZlh4STlVaStyUUNXS1lRdGNrVDVpQzNhN2ZvWnROOUNI?=
 =?utf-8?B?c3R0WUlCMzY0WlJMQzVrQ1NVNjZaTVZVeVNSckxtRER1SkxKVmFCKzhDN2s0?=
 =?utf-8?B?UlJVNEZTZ3h3ZXFUaWdrZDNtMjFnaTRRNmRXVVJENWFxT2VEeTUrOEMzeHkx?=
 =?utf-8?B?MWtUeGVTdkorQW1qNzRESGxwUUVPQlJ6dDNmWGFYUFZoNjhXUUtzOTE4R2tK?=
 =?utf-8?B?VEUyM0wwOWdUNFo3bUZoZG5MRzVUcm9zcVdSamc3Y3lWR1ZaWHFUY0pPNWha?=
 =?utf-8?B?aWZpVGJPYmp4N0xnSWp6RXduYlRwNUloM3BDbDA2bHBzbjZIS2VNSTE2U0Zw?=
 =?utf-8?B?V0R2b0VFWEQrWVFpcU8xN1ZlOFVZRUNEKzh5MmFaTWFVdm94Snp2VjVRM3A3?=
 =?utf-8?B?MXkyZWxKQlFwN3A5ZEZBYVBYR2J0V0ZNOWM4VGhCUEYvcER4elNBbmo2R0N4?=
 =?utf-8?B?UTZRbXRmREVNU0pJODdMdk94OG9nMnZ6Vm9ob0hpNVBxOEY4WWY0eDJtOXI4?=
 =?utf-8?B?d2NuR2J6dDRtSWZ0WUtLdVZzMzNjcmRGZjRuWkZWdzFCQmhNSDJDNSt6ZFVs?=
 =?utf-8?B?NEFpcEhKRDBnWEdHZjFsejNxN3M4VDBzY2ZKTE1hMGY4RjlzenJBMVVqdXVp?=
 =?utf-8?B?elFYSzZQaHRZeDl4QmJFb1dJdTFxbi9udGxOczJuTTNhTmZGSE9UUWM5VEp0?=
 =?utf-8?B?TWROdjlLMlZIeHVUdjE4eHVDNTFPK2lTVDlUZUdMeVp1Q2g5dmZPSEJVdFN2?=
 =?utf-8?B?SzVsZXhycEVVUktrWStmMUh6RnNuZnN4OFkyUXdTRnBoTnd2WDVYWmtRV2ZO?=
 =?utf-8?B?U3l6VXBJKzhBMTBXY0toRGpUZERSUjk1TTNtQ0NVM0FPaWlVTXg3TWE5Y2t4?=
 =?utf-8?B?R3o5anBOcTRkeVZsc3JNaURPTlZoT1VidklDRnQ0RjMwZGdueWJpbkduRVZy?=
 =?utf-8?B?MnJlODRCUjRtS3FYK1FHOHRKOUpmNmpkTm1ITm83Z1MvMnZVMkdvS3UyRzVL?=
 =?utf-8?B?b1hYMFIrZkxNSzAySjRVMWJic1QyV0dKdWtFNDNQVTdFUkZJWmFoREtmeHpP?=
 =?utf-8?B?RE0xTFUydTloZ2lDZW8yMTNlWG50Q2tvb3ZSV3BJSTN3d3c5Y0NlTklyY1Z3?=
 =?utf-8?B?QXIxZmRaVlRQTFJmaEJwbE9WVlhRdk1uMFl0eEFON1h1b3BRNnVmTTU0SEpq?=
 =?utf-8?B?N3dzRFRTaGxXVHFLczEycHhEa2d4cHRKQ2FsV2tia3Q5ck1Oa3BXSWVyYmN0?=
 =?utf-8?B?aDJlWGxUWjlDN3VvOUZaVHZQSVk1YW1BS25XRmNGSkMwREFaN2owcHhId2RF?=
 =?utf-8?B?N0NDbExmSlZhTjBiSUNOYWg2SllWME9pSzRoQ2M0c3ZjVUx4MDJTcVl2Q2FC?=
 =?utf-8?B?TE9WT2trTERxWjVhUUI2QVBmaVpGaGhVNkFBeTZqRUpVNU1oWHZmbTkwemNz?=
 =?utf-8?B?bWoxYlFzTTQ4aDB3WHBQYnptdXVnSHRQQ2VEcGRzUGpSRlRDK1k1R09tN3p3?=
 =?utf-8?B?aVlJMU5Hb21pM1VlejJrNjZGOXpyWkVoRHhTMFhxa2tmOVZRTyt6OHlUR1cr?=
 =?utf-8?B?Q1pSQitoWTVreXhESHJrY0U0NzVSWUJJMUs5YjNlcFkxdXRuUG1raDM2a3Zz?=
 =?utf-8?B?ZldYR3VueU5CM1AxU3M3Tkl0SjdxSy9OSlNoWWY2ZlF2aHZxbXY4b1QwcFJv?=
 =?utf-8?B?TkFtcFgrMmI2c3k3OWdEWlRmb3JwMU16Uyt6bXFVZ3V3aGhWb2lIUVVQQ2Zn?=
 =?utf-8?B?YmFZVkFlWU50RDlNcktQRlROc0p3MUlxUDh4M3Z4Y1E3UmF0Ulpzdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 556850db-001a-4700-6f69-08da422dce02
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 11:16:12.7178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7umKUNmSmpAR8L3NxL+/JDB5iCGaiISiia0Ufku5lsITo5O99leq4MDmONxM6eW9J0+byq81JljiqIX+OzkoFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2779
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/2022 6:56 PM, Abhishek Sahu wrote:
> On 5/10/2022 3:18 AM, Alex Williamson wrote:
>> On Thu, 5 May 2022 17:46:20 +0530
>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>
>>> On 5/5/2022 1:15 AM, Alex Williamson wrote:
>>>> On Mon, 25 Apr 2022 14:56:15 +0530
>>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>>

<snip>

>>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>>>> index af0ae80ef324..65b1bc9586ab 100644
>>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>>> @@ -25,6 +25,7 @@
>>>>>  #include <linux/uaccess.h>
>>>>>  #include <linux/vfio.h>
>>>>>  #include <linux/slab.h>
>>>>> +#include <linux/pm_runtime.h>
>>>>>  
>>>>>  #include <linux/vfio_pci_core.h>
>>>>>  
>>>>> @@ -1936,16 +1937,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>>>>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>>>>  			   size_t count, loff_t *ppos, bool iswrite)
>>>>>  {
>>>>> +	struct device *dev = &vdev->pdev->dev;
>>>>>  	size_t done = 0;
>>>>>  	int ret = 0;
>>>>>  	loff_t pos = *ppos;
>>>>>  
>>>>>  	pos &= VFIO_PCI_OFFSET_MASK;
>>>>>  
>>>>> +	ret = pm_runtime_resume_and_get(dev);
>>>>> +	if (ret < 0)
>>>>> +		return ret;  
>>>>
>>>> Alternatively we could just check platform_pm_engaged here and return
>>>> -EINVAL, right?  Why is waking the device the better option?
>>>>   
>>>
>>>  This is mainly to prevent race condition where config space access
>>>  happens parallelly with IOCTL access. So, lets consider the following case.
>>>
>>>  1. Config space access happens and vfio_pci_config_rw() will be called.
>>>  2. The IOCTL to move into low power state is called.
>>>  3. The IOCTL will move the device into d3cold.
>>>  4. Exit from vfio_pci_config_rw() happened.
>>>
>>>  Now, if we just check platform_pm_engaged, then in the above
>>>  sequence it won’t work. I checked this parallel access by writing
>>>  a small program where I opened the 2 instances and then
>>>  created 2 threads for config space and IOCTL.
>>>  In my case, I got the above sequence.
>>>
>>>  The pm_runtime_resume_and_get() will make sure that device
>>>  usage count keep incremented throughout the config space
>>>  access (or IOCTL access in the previous patch) and the
>>>  runtime PM framework will not move the device into suspended
>>>  state.
>>
>> I think we're inventing problems here.  If we define that config space
>> is not accessible while the device is in low power and the only way to
>> get the device out of low power is via ioctl, then we should be denying
>> access to the device while in low power.  If the user races exiting the
>> device from low power and a config space access, that's their problem.
>>
> 
>  But what about malicious user who intentionally tries to create
>  this sequence. If the platform_pm_engaged check passed and
>  then user put the device into low power state. In that case,
>  there may be chances where config read happens while the device
>  is in low power state.
> 

 Hi Alex,

 I need help in concluding below part to proceed further on my
 implementation.
 
>  Can we prevent this concurrent access somehow or make sure
>  that nothing else is running when the low power ioctl runs?
> 

 If I add the 'platform_pm_engaged' alone and return early. 
 
 vfio_pci_config_rw()
 {
 ...
     down_read(&vdev->memory_lock);
     if (vdev->platform_pm_engaged) {
         up_read(&vdev->memory_lock);
         return -EIO;
     }
 ...
 }
 
 Then from user side, if two threads are running then there are chances
 that 'platform_pm_engaged' is false while we do check but it gets true
 before returning from this function. If runtime PM framework puts the
 device into D3cold state, then there are chances that config
 read/write happens with D3cold internally. I have added prints in this
 function locally at entry and exit. In entry, the 'platform_pm_engaged'
 is coming false while in exit it is coming as true, if I create 2
 threads from user space. It will be similar to memory access issue
 on disabled memory.
 
 So, we need to make sure that the VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
 ioctl request should be exclusive and no other config or ioctl
 request should be running in parallel.
 
 Could you or someone else please suggest a way to handle this case.
 
 From my side, I have following solution to handle this but not sure if
 this will be acceptable and work for all the cases.
 
 1. In real use case, config or any other ioctl should not come along
    with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
 
 2. Maintain some 'access_count' which will be incremented when we
    do any config space access or ioctl.
 
 3. At the beginning of config space access or ioctl, we can do
    something like this

         down_read(&vdev->memory_lock);
         atomic_inc(&vdev->access_count);
         if (vdev->platform_pm_engaged) {
                 atomic_dec(&vdev->access_count);
                 up_read(&vdev->memory_lock);
                 return -EIO;
         }
         up_read(&vdev->memory_lock);
 
     And before returning, we can decrement the 'access_count'.
 
         down_read(&vdev->memory_lock);
         atomic_dec(&vdev->access_count);
         up_read(&vdev->memory_lock);

     The atmoic_dec() is put under 'memory_lock' to maintain
     lock ordering rules for the arch where atomic_t is internally
     implemented using locks.
 
 4. Inside vfio_pci_core_feature_pm(), we can do something like this
         down_write(&vdev->memory_lock);
         if (atomic_read(&vdev->access_count) != 1) {
                 up_write(&vdev->memory_lock);
                 return -EBUSY;
         }
         vdev->platform_pm_engaged = true;
         up_write(&vdev->memory_lock);
 
 
 5. The idea here is to check the 'access_count' in
    vfio_pci_core_feature_pm(). If 'access_count' is greater than 1,
    that means some other ioctl or config space is happening,
    and we return early. Otherwise, we can set 'platform_pm_engaged' and
    release the lock.
 
 6. In case of race condition, if vfio_pci_core_feature_pm() gets
    lock and found 'access_count' 1, then its sets 'platform_pm_engaged'.
    Now at the config space access or ioctl, the 'platform_pm_engaged'
    will get as true and it will return early.
 
    If config space access or ioctl happens first, then
    'platform_pm_engaged' will be false and the request will be
    successful. But the 'access_count' will be kept incremented till
    the last. Now, in vfio_pci_core_feature_pm(), it will get
    refcount as 2 and will return -EBUSY.
 
 7. For ioctl access, I need to add two callbacks functions (one
    for start and one for end) in the struct vfio_device_ops and call
    the same at start and end of ioctl from vfio_device_fops_unl_ioctl().
 
 Another option was to add one more lock like 'memory_lock' and maintain
 it throughout the config and ioctl access but maintaining
 two locks won't be easy since memory lock is already being
 used inside inside config and ioctl. 

 Thanks,
 Abhishek
