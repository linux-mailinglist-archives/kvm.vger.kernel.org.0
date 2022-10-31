Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3149613EB5
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 21:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJaUKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 16:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaUKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 16:10:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2074.outbound.protection.outlook.com [40.107.96.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2692D6272;
        Mon, 31 Oct 2022 13:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6fNw0WIS5xXQdH8f0T24vieB1zk6iX7BCoTKRK5DkHrybFy5tiP+mHVVixdn7/kkzaBzbfvzvnWwzcEWdDtyj1LFyZFarN5iJVUB7Gq0SNuE0bxqcH3g7rfQ5EP5nNZ9KAMImWQzYLjzFrvwhUZ1QMFZbULhDntvHJI9DTZpsi5F3+axtS6veoc+jrMiiItOkaeMbShJ2Nu8DqDd0SyI8QlWSvFRfpv29txYxtxehRr2hmnM+cD5nOgG4D4kIS0pkB57O7b0KZJvid8HEBn1I4aK0iL+zM33yG+VTAVyrLNUQaQRbuadEeL9JNgo15+qXOu6HRFDqo84Km0mRdiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8/lwmquVovZ2zKEPSvIdRn6vlYsvddE5dQKhbBjpow=;
 b=FWmBNdtw0Av5zE4olXQipXizVVOJ7C0+/rTY2VKjqFFz4E7MXaZjMnV+PtKJLLQSwIjGMK45NnPqkRo2unh64sWQb2Q5geyk8uM8ZpF2puhULp7bERsaxixam1fDrE4c5UZTQPh9cqObzm5ONotlNA6btV85LAB6zpXFtSIGAxpXS4nS5/C7tS6WfY70uWSSFn4uBE3cfiLlg4wMUvr1Csm+2L4aZn9WMYFQQJyuQGJYpZfiIWTxfX3QhR1ySFy46PXeC2yue5mRniKw82BfjFD9qWsOmwnVym1ExO9fpQkMxuyJPTrIAK+jJqZFMpw0ywFDD+xgYhiWtu6W3UToXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8/lwmquVovZ2zKEPSvIdRn6vlYsvddE5dQKhbBjpow=;
 b=iVMJVIsirdr3S51AdQ8lmXwPGZTPA/g2hCQWeEqQeJSpTOxbF8f/wRvsl7kXvmYwawxgO7o4FApbqdfL2GwWd9X3nDM1cpCasK1rKnD9Z6d37MzLUnd+6jWK+6fdkrfl9QMWLNbCX5qwZy4Ta/E4rX06/DhWYFMqdwhRyVOadSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6301.namprd12.prod.outlook.com (2603:10b6:8:a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 20:10:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 20:10:21 +0000
Message-ID: <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
Date:   Mon, 31 Oct 2022 15:10:16 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, vbabka@suse.cz
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y1e5oC9QyDlKpxZ9@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: 54b57cca-570b-4fb9-c7c2-08dabb7bf002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKOxVL86KG+94u1SP5LwGFlQmi8jHTUBqucArwt0Ub9EFBwBDGb3b3nO1JgQiuY4u7qS/VbGdtzsCrLE8whWO0Dne+UVSDiX1SNEEecYXowWuwSdEtvbc/5MyYojZjvGTM0OaDT53lnpwaZn35L11tvWxuL5LRRr5U6IQchCwDlrJcV3mlY5iQ0IGME4fybn+S9v6/wOeT1idv5pMAH8Ymrog7p86D83gFeubudHvttjEphQLPXaAwEAoKWDnnIm9beqBuNNrR9VN93BYseIn+l+ZVJVsU+FqKnADbvmtq0txv1JQMFR88RWdY1HNgBdPs/w67aVlIw5dutq+BND+grbv2xT2AFrJScN1meAe2uwSvhSTi0gnKvlxfAPkYpJSn5XIkMbp5CuCoEeqfoncT/XtIiFBCe2+XItNa0a+I8F2mgeC2U+xtloFA7WLONezBprERP4QQgHheae/Eypfn+SPrECB32HEKcLzTc5GpnWiCGRVdcUes0onGrB+o2GdgB5/m8fMjnUkBfO8IpeFODwXNqK1SZnenp/uVQ3sk6fg5Dq9YsYbU30p30VLLbTH9RpNVNDwtWDvcdWVbiHV1Qn4ZRq3nrcyP4AbGEgNqf1KNVRRkvZUB8/++gKGMwq8YR2Feexg9yDsrBEKCo2uItfFnQIjiARfM+ASZ9fqe97inLfFmM5TZt/Yg0DpthmpispUy8DRATKQh3rZkvsCqUWfKr5tHNnVTzIsowx6ZbN8WJxSNVE+TGu69aQ+mpOyaAghSdt1KK0err9q4lGMNy8tEW6vJDMGp3DjlBdA5I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(31696002)(36756003)(86362001)(31686004)(38100700002)(2906002)(83380400001)(6512007)(6666004)(26005)(2616005)(6506007)(478600001)(53546011)(186003)(66556008)(316002)(7416002)(6486002)(66946007)(4326008)(66476007)(8936002)(41300700001)(5660300002)(8676002)(7406005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFU2c1pLZFFaQkZ0VzRNU2RJd1phYVFWSlJDaVhHa0REOFdBWVdJME5wbWdQ?=
 =?utf-8?B?c1ZGcVZkeG54bDJEQVBod1d2R2V2VjFYQjRnZ2NWK0g3Rk9BYTRMMXR3UlVy?=
 =?utf-8?B?VkpnU3BQcDk4S2N5L01MNGhGSzVxQnI3Zk11VGxMYVJwbWZTMEpIMjFGMk5s?=
 =?utf-8?B?Ni95Rk5ocTFqc0ZxeFlwVG9VcFRkUVg0RFA2OHJtSHRnNFF2cVZRSjV4dUV1?=
 =?utf-8?B?cGJKN1ltUWlqZUpidmZUc2pONXYyMnNFUVJJamFsVmNRbldhTWVWUk5pblda?=
 =?utf-8?B?NFBJclltbHRuMnFTTkdTYXlUNTBZUDBobjVmYy9QUjc3UWpYUFpxck5UMmtL?=
 =?utf-8?B?T1pjU0YzdjQ5TjhPdGVWMlRSM1VjMUlrd0lDZ1VRUUhCRXJWK0RzaUp6bWI0?=
 =?utf-8?B?RUI2NDV4bXVKZXdvVnFJQ0s4dm9DZzFNUkxLYXgrcG03T3NUZ3JFNGtIbkNu?=
 =?utf-8?B?S1RvQkJmdzRQQmxPaFMxUTgyR29TbklManRLVzB4V0R2OHNCdkFvd2dkeEN1?=
 =?utf-8?B?QmZ3UTJxY0svemkxS2IzMFVtOVhIbVZiaGlGRlBSVFdYeVJKZjhDTDQ4WGRE?=
 =?utf-8?B?ZG00eHNSb1ZXS3RVRXNQeEJCMFpqSW9pYnB1aHkwN1hPZWVVY2FXZkUvVWg5?=
 =?utf-8?B?MjhoQWE2ZFhqRnlsbGg0OURORHZuTk5OTzN2dE1MNkxLWW8wYm5ZN1MxRWdo?=
 =?utf-8?B?UVFLdEdHTTNQNm1lbWk5QzJjUmF6ejFndHJNMWxsM25OVTcwTWZ6c3pib2la?=
 =?utf-8?B?THJmb3oxd1ZsSWlWRjluVmJVRVAxUGtudDVzcGxjeHVRMTMrTG55TVltaW4w?=
 =?utf-8?B?dVBLdnlaTjdpeWdtWXpPRTZpV1VYb2NNeG1rUzR2SVR0Q0Q5VUJqaWhKeFE4?=
 =?utf-8?B?QUQvVUM4TXAyajhRR005R3R2MTAwdkdDTzgvcjBRbkZTTkh6T0tyVnNMeWpH?=
 =?utf-8?B?bHcrOG1ZTTBFVUh6S1NvajRiVUUzVWFPNGNqL1NveU0zOXBKZHZtRlM5bSs3?=
 =?utf-8?B?dGdRaFVFK2s2WTk2RUlLUWM4QXFIVGs4cklkMGpEUVY1RkFMaVpqeHRPRDRT?=
 =?utf-8?B?OTBWNjZuWis0Q0hWSmtHNWhoT01PMG1MaUl2UFpYczY1WmQxQWdoQkZOMDR4?=
 =?utf-8?B?T3M0TFZKdVd1dUE5NDVXbWpjeHErL0hrTFdKakE1N1BaQnRyeGk3c3djWS9H?=
 =?utf-8?B?QjJQOWF4WHlKaUJIaDZRUU1QOGdROTc4cFdRN2VrMU95NWRDZDBtbng2YUM5?=
 =?utf-8?B?OVJ6VldsRE0xMk5zTXBENTNVNlR5Q0UxTDEvcURkeWN5REc5NVJzakIwMm9w?=
 =?utf-8?B?VVpMUm1aVmJqNnVMLzNzK0RUczhUamdDTkEwZTZXMFlTQzNpTDNna0JaZXU2?=
 =?utf-8?B?WmVVYXhaRDJuQjRzYU9vTnZOaWo1ajBZK1hqZ21JL2pJc1FOaDZKTzBTaUth?=
 =?utf-8?B?RzFFVm1va3pxMC9CM1RMNVl2eG1ENU9wem5DZWZZcnBCSVNEMkxjTXVmZXZ0?=
 =?utf-8?B?akJVS3NrdDZBZUhSbHlobUxTbXJjOXErc2ZHcUlTdXdvcXUxM3BkSWk1cVNX?=
 =?utf-8?B?eG4zQWdSRzlRSllMRTByT1Y1VGJadHRpSnY5eGdkTlh6L2laUUZweEFGdzd3?=
 =?utf-8?B?NU5pSGF5dFlVYVdnWk55eE9ETXZrQ3gzVDFtd2RoWWR0Mkl1SkxYUHQzd0pR?=
 =?utf-8?B?QjI0a3Rpc1l4T0pST215Z1dGaGowdDBmQmVuYkhzTmhWc2ppYUVBdzF3K08x?=
 =?utf-8?B?RmFrdE9Oam0rUjVJUDJzaDF1REVxUFNnekZZNGl4bUNBaEMwT04zWEtxU0h1?=
 =?utf-8?B?VVZ0NUc3MHAvOTZUaVhiVEYrVVR0RFI0Nm84T2pjUncyVGhDSm1aSW9xdGFN?=
 =?utf-8?B?QW5tRWJjalFvWEFlYjgvOWV6aGVPYzBZd1lZOEhhUUEzbVFzZUpqcmFlY2s4?=
 =?utf-8?B?WGNXR1E4NGw2NmNKUVhCeE1Za28zRHIrTzgzdGZGa1pjK0NRL3F1bHkxZmZG?=
 =?utf-8?B?eGhRVFR6RTBBK3NjSS9iK3g0bXlGZkZob2o1cXVTNllFdXl0am82azVPYkxj?=
 =?utf-8?B?dVFaL3ZsTVpGNTZDR1gvSWxOczBLZ0tmV0p5RldRS3FqSG00WS9IQVV1eUdG?=
 =?utf-8?Q?Apo1mYZLj8qdpLnCN/Nh8xRIc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b57cca-570b-4fb9-c7c2-08dabb7bf002
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 20:10:21.0619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HoJ8kzZ9mOgCNffMbHBAuqMIBSf4etq77JE2kDafKguARGaj2IOgzUystMVhJ0GqkbfkIo21bTzsU/qbL3eFqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6301
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just to add here, writing to any of these pages from the Host
will trigger a RMP #PF which will cause the RMP page fault handler
to send a SIGBUS to the current process, as this page is not owned
by Host.

So calling memory_failure() is proactively doing the same,
marking the page as poisoned and probably also killing the
current process.

Thanks,
Ashish

On 10/25/2022 5:25 AM, Borislav Petkov wrote:
> On Fri, Oct 14, 2022 at 03:00:09PM -0500, Kalra, Ashish wrote:
>> If it is "still" accessed/touched then it can cause RMP #PF.
>> On the other hand,
>>
>>   * PG_hwpoison... Accessing is
>>   * not safe since it may cause another machine check. Don't touch!
>>
>> That sounds exactly the state we want these page(s) to be in ?
>>
>> Another possibility is PG_error.
> 
> Something like this:
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index e66f7aa3191d..baffa9c0dc30 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -186,6 +186,7 @@ enum pageflags {
>   	 * THP.
>   	 */
>   	PG_has_hwpoisoned = PG_error,
> +	PG_offlimits = PG_hwpoison,
>   #endif
>   
>   	/* non-lru isolated movable page */
> 
> and SNP will have to depend on CONFIG_MEMORY_FAILURE.
> 
> But I'd let mm folks correct me here on the details.
> 
