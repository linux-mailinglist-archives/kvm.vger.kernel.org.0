Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77522627700
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 09:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiKNIDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 03:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiKNIDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 03:03:15 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2074.outbound.protection.outlook.com [40.107.96.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C6017AA1;
        Mon, 14 Nov 2022 00:03:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcPkkypyXZwpzwePx3GeWMam3bpUNhne5q5jD7p1mrVoyDXuPxqsYLpiKYeMbAfW2wdYfso/L9XAE/5FAQEUheXxFWec04wnIWUIkRoKPthuHC1at4fixH72aNTyhrmZINz3RzS5UKDD/ym8LpoiwnWsJKaXBDu8PiBz7JIGIxIU0ZVZHCV4gKY5ITNV5y6xFI+qxJg4nOaaWHesxbbs6mhwOrOcOIzLj9+lnBBf4u332FhY69RuBCN7WXubk882nj7knGCSOtdL0EOn5qPd9ecqQEpuMMJ3DVJH0mUy/4eekN8NERLOYV6qq2FHLwdO9/rdZjOkAQNE6sNgDimg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3u+VacMw8qR8Ps/lq4thEXDvZ/hz53boJfA6PHL1zIY=;
 b=RBeGvCbNY+wwLwSOnKgoDqJZeUPUArBRtEqXYbdcBnUGQAPyGPS358NkzCzKzPrUcFzluktcXg9lcqbvpVKYmQFiaYhAXEMm7eMJJ7uh7az1Jc4ukdm/p3AmJC01Yq4UzqtErEPT5tHEKKKBfwxRA8UKP0W2GZihLTU+WPWbClzlTjgVjvGSQxqBTBsASvrnKuOM4aZkBciyuJX/rD8FuJo/L+tAK9j6LgG/HCyEHLZP+RNN91SLbra0P4Xgo0gxxDB1iOu0dZsUzPm9CtJq22Te51B06nUMYVYkVw0RxxlHXjydZasfZaqLx4qRgkZqM82hjW7WZEziYOfuEAXbnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3u+VacMw8qR8Ps/lq4thEXDvZ/hz53boJfA6PHL1zIY=;
 b=p8XIBNH2NCObFDmlv3veWk+s9qlGQ5vIM6Qvnv2fjZYE0+kEXwRZ76H6XO2k0IP8ccM/AS2ChOc55TnBvEqUCeiDmQf5W8rQg0nAGqJCEIVuZL5gEGJggBCijo5U49Fzx6zFuoJcfyE8KtGd1gWBRVhUx7qpAfBEvYHOU8mjEb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN0PR12MB5762.namprd12.prod.outlook.com (2603:10b6:208:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 08:03:10 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776%9]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 08:03:10 +0000
Message-ID: <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
Date:   Mon, 14 Nov 2022 13:32:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
References: <20221027083831.2985-1-santosh.shukla@amd.com>
Content-Language: en-US
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::12) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MN0PR12MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: fb69a7e6-ec3f-453e-bfe9-08dac616aaf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPq+UlNpoC6oV7BOH22192CrVdV+APyfVQ+/lHr7l7bS8R06eb56xd+/hZNsRlpYMv/xFNdUuvfMQo3Rci/dFeNJR4qH0Bi9tx286Im130IThR91wRlO7AZeiyL3BglPbiE9ELOVWSm4xghmr6I36MwhSOHhg3PqWmHSjEPIuEV2eMNxAt6QoE6njOGuxqC73bQ6vLJPFuBRoBo0eF8logyfLNpl8mxDDNdAWGkzOz0nDrDNjf6ReglN+7yg4Qy5vr75THjIGjlYjpX3tN+1kIyo/SdvSh4JWOAiwY095S4WJcA5yeZfj9eU3SKtIotpIGSCFT3V4vxvsl19j3lj9fnwSS2Oa4BmrdQomXtck7zAczbUyxYMAoDI6yCG4cyir72xlqz3WzGVYNsZ7y5lcYmR7b3zpgu0BuDSmaix7neLPFx0OyI4QJ083fptB7QuNpSZ1GbFobgI72ukjBiuzT7C7vRMPAu91jdCDfQH+BmV3DWtVGJCilvdiZAfM7pvBU1gPwuBwwwNpvnI81mwr2OUnJIZJnAbGDghZqvM1+0ftuWFkaAQWf3mIha4lROotetRq2CxOOW9z8qJkZezjGVOr1cKUFtsKQKaIOeWx2iRyxgfJfu9n1/WkSmDR9v6odA4BpK/cWDTEunupdKpgnJPJJNSlaNgGvYuIj/gZlJRpaSQRdXxNsVXM4eNS8VEwGy5bw5/Avf+7zS3csKeJlGC3WsA3+h04hDzDID8E6kj28+OVlcBJKHoGrIxUnG2qPIiT9buD6PzxdxA4YT6DaVuTOOLhD87N7nGW03BPNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199015)(38100700002)(6486002)(86362001)(478600001)(31696002)(6666004)(31686004)(558084003)(186003)(2616005)(26005)(6512007)(5660300002)(6506007)(316002)(53546011)(36756003)(8936002)(41300700001)(44832011)(8676002)(4326008)(66946007)(66476007)(66556008)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVVKcjRIQUxjeEJnS1dmRzRQNzJjSUV0dEhCd3BLT0hsNmhKRFFieTFkdTZk?=
 =?utf-8?B?S2x1ZkF2SUEwb1l2ZlVhdGpmQ3RmKzJ2Q1YvN0FlVVBZUFNtbmdhaEtSOUxX?=
 =?utf-8?B?dXl4Z0xkVnk2bnl5bS9XU3ZGYk14dng4TXAzeitVYk0rOXM0Wis1TmtaQmI5?=
 =?utf-8?B?eEFTVnN1MXJCK1EvYm1FUmY0Z0M2SHhNYytwWlFuZTlGY3JNTUJKTGxBWHZI?=
 =?utf-8?B?Zy9ETXZnempsNVNmeWlUcExJUkd2M2Q4dUEvVnBlMVB4L0pYVml0S2hYRWd2?=
 =?utf-8?B?eGwxRE9wenY1YWUvRmJ5bUhuSDdldmpGdTJQZkpMSktCSlhKZUtBOEs3cVdK?=
 =?utf-8?B?NWhheE1tYlY2MXFYOHhkVVY0R045NjFaS0VHQ0V1VEc3THpSUzhhWDA0cTBP?=
 =?utf-8?B?dTNnS0tNS2ZqZndPazBDVFpOTlpoWUdvOVF0aFlWejlkaFFlSzdPam5tWlow?=
 =?utf-8?B?eWpqeU91ODlxMHZhdlF6MnFZY29oeDRLaTA5T2lNMVBoSEEyb0JnYnZRdlFv?=
 =?utf-8?B?MVAxWXpYTVZqS1NCTHJ1VURBQ2NuTTc5MUNvMkpZL0RQZGpyVVRpRlZkejB1?=
 =?utf-8?B?ci96WHRvbW54bjEvZzBKOGhQQzdXRWEyYmhrZTRRVHdqbklGbmN6RHNHRldS?=
 =?utf-8?B?c09RT2R0Y3NpQ2JjNUVsR2sxVDNtVVFIRE9SUmQ4dW1FTWVPQ0FOWmxNUnhr?=
 =?utf-8?B?VVdxQ0NWSW1jQkhKU0Zqbm5lNkxKakdWMEhwTHBpNWlZeWl2VFF4dVl5SGZJ?=
 =?utf-8?B?aExRVEpnS3IrczhBSUFVamF0SGwvNjVTVWFJQllaMjJxbDV3MFZzWXlFSldL?=
 =?utf-8?B?UmdmZjY0Wkl3ZEg0WkdvcHZvVWx6d1VOeUFYVElINDM4cGFEam1pQ2Vpa2d5?=
 =?utf-8?B?S0gvbUtnVUpnYS9kLzRvMkZEKzJsRzIxRzNZc2d6cjllL0tBOXFJblJORUhl?=
 =?utf-8?B?UzFGeHlFZHdIV25ZR1JzVGFVNUNUak5MRGxxbUhMYWRiTjI4VHg1TGUzVllD?=
 =?utf-8?B?TFFNc3I5WVZydnFjcUJCUkRaV2huOS84Q1B0TVBmYXVQKzVpRHl6SHlWalpL?=
 =?utf-8?B?dU9VUytWVlMrZDRzNGZZbzdDU0R2VUpsMlAxSU9YMmwvbFoyVGJleVJSRTJa?=
 =?utf-8?B?UmZjSy9aSXRBbXplOW5kSyt2VDRqMnFBUW9laUR6aW5JUXUrclV6M09CVlJm?=
 =?utf-8?B?T2VnK2FLSmhEYk0zYkVYc0d1MklzckdRdGFTRjNQRm9YR3g2TWtZMExyYnN5?=
 =?utf-8?B?d2ZCREppWkdvZFNML3JWQkhjcVBCRnZhdTFLWTRheUQ5WnF2QzFlTnVRdkNs?=
 =?utf-8?B?V1dGVXJKUXBNMEpzcklvUWpia1grc1Nta3I4WDVHU3pDVjNSVEpZWnkwM0xE?=
 =?utf-8?B?aWFySjlUVDlVRlRDTVNBM2YwOUxXM0IyWkJ1V3N6cDl1eGYySWoxNzJsL0NG?=
 =?utf-8?B?MXVXWWZnWnphVnpkYUErcVRrOVJmNFZkeVJnamFYdHVjd0UvZk1mK3FKT3VO?=
 =?utf-8?B?bklVWTJjekx6MisvRVNHRHVGUHJUcmY4Q0J0Z3RRcFlGUmQ4elIvV2ZPMW9x?=
 =?utf-8?B?TitiT05ZdW5DN2NSVXZOcE5pdEZhNXFMTEw1UFpOME5PWlY5Rnd1ZFdVVHpM?=
 =?utf-8?B?Yk8yZllMbmU0WWxNSy85Wmd1QktGVE1qcm02TW45dW9nc0Q2ckNCc1pXbXo1?=
 =?utf-8?B?M2RJR2tzK2h6bkxiTlI0alZZL094ZkxtenV5ZXExMmJDaVNLMHo4TjZMOER4?=
 =?utf-8?B?UjJQZ3VLeW9JanRoQ0tuZVd3dmgxZ3hLa0dZK0lFeSs4MXR1dFZFVktSSmpV?=
 =?utf-8?B?UmJQbHhuK0NxVkg1QUdkTlQxZUVmRDAyazVRVldNTlU3MHpxSzcydzg4em1y?=
 =?utf-8?B?cEM4S2IwWjNzYnRlSWRrM0tPOXhJUUxkL1Fjc1hNNlAydlZpQmtkRlNxdER2?=
 =?utf-8?B?MUhMQjhqRjY4UWhOSFRJdnVqb2pUZExTQm85TzZkR3hCZUZhQnA0VVhKRnR1?=
 =?utf-8?B?SWo4eWZzbEY2b3Jpb1V0SGpPdytlOEpQNE45elFFMTl4QnAyblptbmxKaE5X?=
 =?utf-8?B?bGtGajF5TUM3MGlueDhqNWdVSStCVEhtM3kwRm5YRjVhQkczWm5ncWwraDUw?=
 =?utf-8?Q?5h4iWtXhbL2Kpx8zLHWdKJkzk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb69a7e6-ec3f-453e-bfe9-08dac616aaf4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 08:03:10.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evgMTUEyGXl1a9Wb5EmXoYJgd8KI0IGPQbM/ahiLP0ROVdXk2gMn5dfgW/N2r5ZPu+OhswXixRIGl66sgNEKKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5762
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/2022 2:08 PM, Santosh Shukla wrote:
> VNMI Spec is at [1].
> 
> Change History:
> 
> v5 (6.1-rc2)
> 01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)
>

Gentle reminder.

Thanks,
Santosh

