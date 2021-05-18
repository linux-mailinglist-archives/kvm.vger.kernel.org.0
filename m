Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC04387A41
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhERNoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:44:10 -0400
Received: from mail-dm6nam10on2051.outbound.protection.outlook.com ([40.107.93.51]:54112
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230217AbhERNoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9X45jNcvm2vU94u/c2s80K0qZrsgaI+gUW6yzrgNmmddiA5T+f6+0Ns+eaAptN/veksGl5goB2rVBXeBgrA4nG1DzT5jgVr1vxq3v8g1Rn3tSKWxJUyRq+eF2fvIoSGLE1BGofZcKYo6i5n1VbQMin0zW8YBPhDk90+M91V/c+NmZ1nNfz1+Q0SL5k/o4qXUcqsNEbEbXVrONYhXmLBDxgNohCsJ4mASW4j23ynxTmhKwj0bHWpKq74H4pQGdnHsO9QqGZ4gjb+w1sd7uaz/+M16mWfoxpnoDkKxbfmKHyZWrxw7eLc15Grwreiqe88IZAo+1pE2y852ScrFcYvqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQ8KyTMM2T/pnlshLsWB+Z8KvTef+BqfrIt8rIYqr7Y=;
 b=dTOnmet/pmQ4U8kkGs7j5LBpbpSv9NFme9SFNvE5zhltdbJP+yaPK7ifY84Ru4eX8NVa7E/mS9E6IgHzwQXTVmoWQeVsPQ12hz4bgdKgcsjW/3iKsL0kHGHX84Jt/LEUsQS8BztNdKUEXnXZS5sG49teA6TqefFTUC9BH3uw1H5MaGXRrRc7zUR2gKsqDNjzYH+2JaWqvkQV20RHlJsPc3/80/u+uvE6Gkn3AKixU61w6WRYks6dxlI7kg9q3562zsJL9ME7pWnRiFi9Vw1gsHs0uOYo3kqgoW8EyKFZH4RKYvGD6aVB86IYJQDQNdrUT/0BChlI1LlPKuu+NXguNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQ8KyTMM2T/pnlshLsWB+Z8KvTef+BqfrIt8rIYqr7Y=;
 b=zboEkcNvJ1L2RN/dAoprmAFmcAUkAjdZky3dhkAIVo2I7g1BuzMTYND+a0sus8dwxS3yu3zBJw1HcRHmC/Xu5s/DXU0kXvpbLaDCFy2goad9YrHCUSkKzI5ce5NVdIrmonb8qVrbRoYVXNnb3EVRj8ozVJKFFRX7cgRa194xFu0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Tue, 18 May
 2021 13:42:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 13:42:46 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 06/20] x86/sev: Define SNP guest request NAE
 events
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-7-brijesh.singh@amd.com> <YKOaxBBAB/BJZmbY@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d6736f33-721d-cbe5-eda2-eab7730db962@amd.com>
Date:   Tue, 18 May 2021 08:42:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKOaxBBAB/BJZmbY@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:806:126::10) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0185.namprd04.prod.outlook.com (2603:10b6:806:126::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 18 May 2021 13:42:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd4fa7d4-4119-458b-b26f-08d91a02d1f8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4512A1F885E7D1EDDFDCEE9EE52C9@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jleX84nOgr5oGznRryeRrnxuT5OH9/w7IZarnsAzY7qt3vIPWsGvcGTR6RcLg/PrNVTrPWFYIx4hScttUxf3R88sOyeh/xZfP+Xp100LSJUSJp+hkXNSQeK0jH8gGtL0nCG0rBGjIBmvNfUzYDAjAy5u/ZieNYa2iHRRcH+ohZyskZAInZRHwITYxXsWe+PEP9dJ1iih1v0o+ZtBgLImjl+t/bC69xYFvFh6T7hPP71BuhbYxsyE5BXz50SUnHYEC/O+bnkeujLsy6o45Z25pSm8n0cp9+ZpQ0BSPXXe5t0W/aly5IDu8EGYsSIQg1SF+eoVcmZvjZpw+NbaDmWlKQpZ/GBoUEIlmi3e3N1fXKpVJOAW5Xri5BN12VMfHOYCJIxa27hHrlGFxeBJhtHwzUpl+dvovzTpEclUZ1+O77/Kli7VrL3FSHKIEVxDEzredaSVbfQjSSwCtqF4HYhvI+CL0bbUArg0ixmanqmq15FqhE9Lobyq2IQlVDyyb0szeNkILDIKrPac2tFzl/XgogB+8pWKOsPdZdUw5rYM2zL5qgCEpb8ubJI6O7+A1OzAuo9SjTz0S+UCzsTXD/2FvbM0DBJQaxckGmSFUkunahABkesrPnOEWcEY7GJOXkLb9CbR/04pSyZzWMNZ5ydszA27PmH4KwkmS/KokrDQBBBZ4w8pN35HOWTV3DVKXxU3PqvrqErQS5YiLClOAPul45RXH+87EqQgsbGHdQIXCLo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(6506007)(8676002)(83380400001)(186003)(7416002)(53546011)(26005)(16526019)(6486002)(8936002)(478600001)(52116002)(31686004)(6512007)(66476007)(38350700002)(6916009)(36756003)(66556008)(86362001)(4326008)(38100700002)(31696002)(956004)(2906002)(2616005)(5660300002)(44832011)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGZkcTB5aEhFKzVBSlZlVUFsSmpMaENhaVdDSFdZdEg4TmIvK1o1aG5JUXl5?=
 =?utf-8?B?eVEvWTVOK0x1OE5BYW4va3dXYlJiL2MwdmhFWnB1cEJpVmd4amNJT1Vsd2hR?=
 =?utf-8?B?ZHhZQXlBTG1KYlFBT29oUXhObU8yZVN6ZXoxcDMreGsvQjJrYzRTYzB2cGtK?=
 =?utf-8?B?SkR2Nnd6dEE0RnNwZmNUclFEaVcxZFpKMlFodGZHcldDWU5KUUJXMnhhVzhS?=
 =?utf-8?B?VFZ6eWFiRG5XMlgwMzRQVC8ySGU2WnhMemd0clUzU1A3eHhZSFVhYVBSSy9X?=
 =?utf-8?B?OHJJQ0dKSWV6aDFUcmFVYlFWVTJWQVRhYXpDckNxWnp2NGFFZWxhT0xJcGtH?=
 =?utf-8?B?QXdaT0U3RFVOM3R6aUUwU05VRHNiSTRvNmZBd1J4YVQ4WFV2OXl5WVdtQnNB?=
 =?utf-8?B?U2ZWcXlxOEtsYityc0dWWVJuZjNCbUJic0hodE5oZFYyYVJ0b2ZJbzJDNEhI?=
 =?utf-8?B?bmtvS2pRKzkyWXBQMTdXOXZZclVrczY4c01QYlM1b0l5cWo5MmVSMlJZQS83?=
 =?utf-8?B?dnpZMTBzRTZWc3IyVm1pV2lZV0J5UW56RmZrNzR4T1cwOElOaEV3Uy9WeGtY?=
 =?utf-8?B?QldRNEVVVXNFS2o3bGhVUnE0aWU3T1hsL3Vya3drUEdiRnppRG41WE5SdHJi?=
 =?utf-8?B?YUJHQWNMVWlOVlgrS2RMdHBobEZCRTVnZ2ZqRXFFWXBmdFhUT05HYkd6c2xn?=
 =?utf-8?B?SU1NMmRONjd3VW1BQlRGdy9Yd0ZpcW5PUG15SEp3bXcrWSsvQ0RNSjBCWVpu?=
 =?utf-8?B?c1FmUVY1NUt2Ymw2WFc1WlJnZ21HNWIrdTJuNkVmbE1mY3lTSk12UVlVYXVs?=
 =?utf-8?B?K050QmEyK0ZFUG1Dd3VWRTZYdWRmcS9zZ1YxSXluNDcxdUxIS2xENXpQKytE?=
 =?utf-8?B?TzZIbnRNY3g3azRrR2hRcElzaFZMUzhMSFRPK2tzVWJack1LZXJnSmVSQzVE?=
 =?utf-8?B?N0JTR09JMWQxZjhVY0ROZ1AxYWVoaFVSWCtzME9jRU51WmNNK0FiK202eHZE?=
 =?utf-8?B?U2dIYmlRREplWEVVYnFQZmtCeGVMUmplSXFUMWFtWEFXTjZRbWNzcFZPRGhN?=
 =?utf-8?B?NTN2MnAyTUxVKzJqQlIyRFNiRzE3d2orNmRVTVNPN05rdVlLVHliWWMrb1BK?=
 =?utf-8?B?Q3B0VkVyWllLRjdmbTBOekhzamh4UXdoL2VFc2REL3lrdUZYMWZYclBCWGtM?=
 =?utf-8?B?Z0NobDY2QmNHNDNpYXVGVGhvMHhRU0tTNWkwaTUxa01Xb3IyTlRHNG1XRUJy?=
 =?utf-8?B?YXlCWjh2cVdaeE9iUHhhLzNGUGE0eWpidzlPWFppN3FMdkhScVJsYm02cUFn?=
 =?utf-8?B?eEcwRW1vWDY5YzlFYTBheHFSTHhMWWIxaG1rZDFkS2l5Rkphb3FTaUdQRzNT?=
 =?utf-8?B?eXVPL2dCOGVXaUlUbEN3RS81UmRLWEx0bVVnQ1cwNWc1aVJEWXZsWGdwY0V3?=
 =?utf-8?B?NXl6M1NUYmVRNG9kaXJTb2RXTE1Ua1dHYk9SMFpvaUVvNjFBeUt6d0dWTXds?=
 =?utf-8?B?K0E5RDUrVHN1T3FSR3BtdGZqTHNvZ1BSbGZlNXlTMmlzaStVWXNkU1VTYytu?=
 =?utf-8?B?NisxQjJoQUNlOU5hWGFvT2N2Mm40RGU2YndhK2c1eEdhekh1aUkvcURzWFF0?=
 =?utf-8?B?b1k5M1ROUGVmV0x3TFVhaTJMUUhiSGx6R2E3c2RQY0NXNVcyMEFHTGNlZEVi?=
 =?utf-8?B?MW1uamVScDcwcVp1U2EwOExLbFhsR0FOcjBncTJDdWFhTUJubWJrdEwrSWd4?=
 =?utf-8?Q?G1+4f/VGRDRYQDmvnYvSDW5olf2sZpuxopMT3Cd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4fa7d4-4119-458b-b26f-08d91a02d1f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 13:42:46.6398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/0r993yBIKH96hExcM3PQC4rY+KaOn/6R7Jr/c5IS/JTmLxWK4qu4OxFkB0cKNErWMzNGINJ4BqdzV4ue+w1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/21 5:45 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:02AM -0500, Brijesh Singh wrote:
>> Version 2 of the GHCB specification added the support for SNP guest
>> request NAE events. The SEV-SNP guests will use this event to request
>> the attestation report. See the GHCB specification for more details.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/uapi/asm/svm.h | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index f7bf12cad58c..7a45aa284530 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -109,6 +109,8 @@
>>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
>>  #define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010
>> +#define SVM_VMGEXIT_SNP_GUEST_REQUEST		0x80000011
>> +#define SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST	0x80000012
> Why does this need the "VMGEXIT" *and* "SNP" prefixes?
>
> Why not simply:
>
> SVM_VMGEXIT_GUEST_REQ
> SVM_VMGEXIT_EXT_GUEST_REQ
>
> like the rest of the VMGEXIT defines in there?

This VMGEXIT is optional and is available only when the SNP feature is
advertised through HV_FEATURE VMGEXIT. The GHCB specification spells it
with the "SNP" prefix" to distinguish it from others. The other
"VMGEXIT's" defined in this file are available for both the SNP and ES
guests, so we don't need any prefixes.


>
>>  #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
>>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>>  
>> @@ -218,6 +220,8 @@
>>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
>>  	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \
>> +	{ SVM_VMGEXIT_SNP_GUEST_REQUEST,	"vmgexit_snp_guest_request" }, \
>> +	{ SVM_VMGEXIT_SNP_EXT_GUEST_REQUEST,	"vmgexit_snp_extended_guest_request" }, \
>>  	{ SVM_VMGEXIT_HYPERVISOR_FEATURES,	"vmgexit_hypervisor_feature" }, \
>>  	{ SVM_EXIT_ERR,         "invalid_guest_state" }
> Ditto.
>
