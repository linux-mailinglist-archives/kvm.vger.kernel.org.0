Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10F15AE0C0
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiIFHQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiIFHQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:16:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ADE40E28
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 00:16:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftoGxTMmWUJOSi+1jsjtm2SnVPUIj6ef3sN6rlts9XefbARWzM55WsSYRpXuYf4zbCwomQr8zPaOB3dylAWeuxH+iWe5eXD7aeqQvVr7bRWpLPMgduUZ1SXzR2mLFuWBdegZaMexlWuLn1o1ecnjFYMfZqSvXyg91BomzlwfDo2FR7QgTOAXIw1qBEYxCubGG+30ijTT8r80JwF9h/D7fFN2hRnUMlDW7NvF1D1XNNVjZffMEkuP0Epo2vuAUr5p5yImlWMI4wFPZekZ/TR5uOmd6txVOL8hFWe1o7/CStjkphsX5K8FBJEAjx7JYNs7bN+fgoru03bb4JV6Gl9aJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtI/mY/f/zLUUQVKiog2XPoQ34l+MYROawZU4dZJO1o=;
 b=L4N/1cKxDoD5HPft5x6TyEB433zPracPR1YCZ7st3YNdIz1sWFw+qcriAdXrClr+WM2vCjH/WtBiQbF9NWAygah1fm5XIDLFYSj/1bpAVZS2W5Cb99zSKb+GXNqSrw2qk4ebB6L3w49TsEtpgFGkvP+nnpQV+dBvsj6z3XpPmMKHJt3I9JZjR+B7sa+t16eXRBpd40MO5hlKO/wMJz3rtUa8Bimyj30DpTJYxx79KmaS9+zA/U++YzJN9gKFHfKflmo87oMWHNXqDCsrS56qfjJuTVLhbvSAMhzw5X+eP/pWYUjHzb7P2dY4nCUWSZBZIxAVJ8SzaIiL9LrB12aOsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtI/mY/f/zLUUQVKiog2XPoQ34l+MYROawZU4dZJO1o=;
 b=OZQfWip1cBf2ygGYsCl/ePcnz1ax1aRUZLZZFiZY7S8vIBt1zhF5lzaXXOwj876C1N+dmugrN/OIhXg8B/r4k7ddHL7H7/6OI6Wn7y7kJ7EbgayX0mvtt1N300XdH0awNKfkFNksXl7FqsqyYJlvF0wSeHRmtXcm/GkXlK4P3pI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 07:16:11 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 07:16:11 +0000
Message-ID: <895a4eab-5c1c-add1-35b7-8178b927fefd@amd.com>
Date:   Tue, 6 Sep 2022 12:45:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20220819110939.78013-11-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0108.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::23) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0fcba72-5237-4e78-01df-08da8fd7acea
X-MS-TrafficTypeDiagnostic: SA1PR12MB7343:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DU4+IH878InvHeMRqrImf0vWXMLO6vpHulLyJVoFZkv1GaXKhyt1b07wmSTA1Sdo17dpWz7Dhp7hYnGeOHxHPj9gavGG5GzCTpFTCMgyL2aXwWkwNBmxZv46LHBHExnjjPa7AFl6bIsxyb56bVFj/Zz0yHXuwDrdgVeB8xHECysacSvQDSx3kUld02/ct+8aGn9KTdW5iSU5g1uW5GxBkNOAiivTjrEwv0MVoLBj5AXI440pSXk8VB2JwDvUaQa2ZhQjx51qldrr5j98dObMbQSCH2YLndtIME4YZJJ3PT6t+PeoaMRUr1UBX55DUHc3R49fQyRrOYKXiS6SGDXbSsnbC7j2j0ePvHwZ9Xxzh+mtu2i1R79YQd3PazUQeY7mah8UTIOp4BVbIqV8yW4pJjQ7+2o6ZZUnyJawyv6TkP1B94pMn9nh8NnZGpeyOEiYPMoVKO6iEik3GifFvjkAjhqivWOhEgnJ57dt79eCuRsLxIDVnGKGZTQwR9i7vxfVN2NCINWB1eLpfzI2qcJg42ufBMCEeGdm61JklrwWQda/qKi/0sIz2Q81ZB25cUTKJttQCZ6MnLPFo2nn4LUpcxT3CHaQo8zHhEhie/SI4P3RN35THLpiyWk3yds5BwJgob0dro9SLTshJbPY8O5HCzaEazzLZwvBP2gulExrH9rdVhBVT+sckjfts/irYRERaH8beA+iqVDMGfqS4FQSVDNHd49osD+oudvsE6iokQbDksmaQN0fPi+lL/cOJyFhkYX2uyG5XPMtA50gKZw9PRsTLBXnIIHmPxyrpqib+4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(26005)(86362001)(2906002)(6512007)(6506007)(53546011)(83380400001)(31696002)(66476007)(66556008)(66946007)(31686004)(316002)(5660300002)(8936002)(8676002)(4326008)(6916009)(54906003)(6486002)(36756003)(41300700001)(478600001)(44832011)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmpKeHFKUXcwQ2diNmZtVFpEQnpIaGtSendHd1ZGSktnNFUyOXNBWUMweUIz?=
 =?utf-8?B?VTZvcW0yQXY1TU9iSTVKRGJ2QkNoVmVXMEMxRGg0NDMyalVTUG5XMGdoczhk?=
 =?utf-8?B?N09teTdoWEt6QkZvMFJlejI4N2xYNDVxS05Ecmk2aURzd1hSZG8zYmlCZUhr?=
 =?utf-8?B?VFBqVThTbXpSOHVzblB3ZGNTWXRJeGhrckl3dmhjRFZ2dUNxWUZBVHVmYys5?=
 =?utf-8?B?Smk3OXV5THF4V2JSN3pHT0J6R2xuanErbEkzK09UbXBiOWRZQjBoVlRRQyt4?=
 =?utf-8?B?eSsxZWlMWWdiNDZoQkZ4eWdXM0RiMkU3bkJaVzhxYTU1eG0weSsvcGR5UTNG?=
 =?utf-8?B?OXR6b0FBWnlIOWxPdUFSbmZUYnRzdUZqMTFyaEJIbXZxVmJxNTRzakVOQU9s?=
 =?utf-8?B?OFNjQ01Eb3JKOFlKaUlPS0c4NHV3eDkyekYrYmkzeFFTS2hLTVNBcEhQZ0xh?=
 =?utf-8?B?WEhFOFkxSzNiRmh1VVYyTGo3cE05V0ppc2dYRW5ac1ljYWV2SUNoajM4dURV?=
 =?utf-8?B?dlphRWl3NXZEYWVPMEFTUXFWZHFZbzBFdDlCem12SmtINkttcGxld3dFR0lr?=
 =?utf-8?B?bExTTnA3RUdCaUlVaFpjTU9TelZKc1lUTDVja0drMHNKZmJrdlRuTmVNYi84?=
 =?utf-8?B?RUs0L2RheHcyRUtNaG5VNnFtZkVoaDlXaTh5K2FnRlhJNXpoUkg4ZFZhM2pp?=
 =?utf-8?B?c0JoUSt5VEk5NlFuUzRYaVZCRmFDRXpnang1TDQyTDlJaEFHMFhvdTViWUw2?=
 =?utf-8?B?TnordkdKandhdG9yb010ZE5CZm9FWWVtbU5ocFpxbXV4YzZmTDRvQ0RsVU9U?=
 =?utf-8?B?NkJ0OWN3RkZ1VXh0eDlBQlQveFFwL2R0S2Joa1E2NHFudzJ2dzJ2Rk1LYXB1?=
 =?utf-8?B?Q1VWVWg3QTRjSUNwcEhvbkRnSEhCS2JoaFEyREhMVHRSbVdvaWE4S1o0b1Rt?=
 =?utf-8?B?YU1BTSs3VTEvVno3RTZ4bDlFK0c1alNBUWFNT1V3RTlQUFhRZjE3S3Uwc2g0?=
 =?utf-8?B?VWgvbHY3RHdFM3p5Mjc0TmloQ1kwYy83VHdmeXNqajA3TXlwOXpHVlY5MlE1?=
 =?utf-8?B?UFBjcGRQR3Mrakl4T1NndS96Mjd5dFB3RTU5aVNUckxaamxjN2NhUVhIaEh6?=
 =?utf-8?B?N3YyVkEvMml1NE5ub2JzczRFaVVsbnMxcWxRczdKSFl1bXR3Z2pueXZvMWZy?=
 =?utf-8?B?T1draVU3WC9zU0F0L2R5QkNaUjhhcXlTcC9xUDd2RnI5SEltMjhlQW1HblZk?=
 =?utf-8?B?K3p6UzlnQVZhakhyaENyVFdwdFlVSDBHWFUzcEFmUGNDMkw1ZlQ4WXRpdVRB?=
 =?utf-8?B?bVA2Y0FCL1NOSXlSOUFWcWlMSm1OblNEUU5GYnppYXl0M3hPVlZReHI1QVV1?=
 =?utf-8?B?NFJKVzRhY2ZNaGdlaGdSQndqVTVPYXlNa0JRVEM4UHh6a002VngwZEh6bU5M?=
 =?utf-8?B?MEVvRHFNOEc2ZXdDTzIxdkVvZ1JMUGlnTktxNDB3Qmxjb0xScENxSDdGaUNz?=
 =?utf-8?B?U1ZpR3BQUUNZSTNNSmRqSFptRUpOOWI0ZTVXSTJKZVpzVjhNdXQ0WFlvTElU?=
 =?utf-8?B?VlRGYzQ5TXZxd2FJMk9hUm9Va3BCakdUUGxuV3JKMGZXSzlQeTVHUlIrbmZ0?=
 =?utf-8?B?WCtjQnBXTmNBYzd5ZXAvSlZMd2tNdnJkRmlkdDY0c1ZCbDJTZkJaRG5nZC9y?=
 =?utf-8?B?S1RZQWJaUERLUWdvWUVVaW9XSVptZ2d3MWoyWTJUeFRpdkt5QkM0Qjk0SWtD?=
 =?utf-8?B?VXdtdTFhdkpTcmFVWFdncFRXYUM4N1FtQzZWRVZpVVptT2ZvR2hjcmVHc1hG?=
 =?utf-8?B?WTUreWRPSFpIcEM4aDRXK2N5VUpHZE5DbVgxQXhBZ0dkYXcvZnA4UE5jdFBo?=
 =?utf-8?B?L1VwUDVQWDFFK1MzTlF1YUl2VWVjZFNub1RUWkVuVmd1V215R1Y3YWhUZkxD?=
 =?utf-8?B?Y00zN1laRldTUlNNV29kSWIvUEhsZGVNNlVhUjMvUC9zUFhsQ1hDdk1xekFk?=
 =?utf-8?B?VjBHbjZRL0NCZ1F5RmNBL21OOXFwZlZ6VndHUjJabTlJTTZFRmJ3ZEhqT2JQ?=
 =?utf-8?B?UkZzZ3FGUElTcm1ZM0NEZ1VSZjE1WEtmWi80MG54SjRRajRBcGREdEFyTFd4?=
 =?utf-8?Q?BXjxjWe4Fi8f29MYGXciU7UY/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fcba72-5237-4e78-01df-08da8fd7acea
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 07:16:11.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xA3ZwfsSMgix0p/8J7b56aZMghg+LgN3G7VXKwvoFJVTj/PxWq27nVzFrVIgQ0y+wXpUozNYve06LQR5pFWprw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

On 8/19/2022 4:39 PM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> For most unit tests, the basic framework and use cases which test
> any PMU counter do not require any changes, except for two things:
> 
> - No access to registers introduced only in PMU version 2 and above;
> - Expanded tolerance for testing counter overflows
>   due to the loss of uniform control of the gloabl_ctrl register
> 
> Adding some pmu_version() return value checks can seamlessly support
> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 43 insertions(+), 21 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 25fafbe..826472c 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> [...]
> @@ -520,10 +544,13 @@ static void check_emulated_instr(void)
>  	       "instruction count");
>  	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
>  	       "branch count");
> -	// Additionally check that those counters overflowed properly.
> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> -	report(status & 1, "instruction counter overflow");
> -	report(status & 2, "branch counter overflow");
> +
> +	if (pmu_version() > 1) {
> +		// Additionally check that those counters overflowed properly.
> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> +		report(status & 1, "instruction counter overflow");
> +		report(status & 2, "branch counter overflow");
> +	}
>  

This should use status bit 1 for instructions and bit 0 for branches.

>  	report_prefix_pop();
>  }
> [...]  

- Sandipan
