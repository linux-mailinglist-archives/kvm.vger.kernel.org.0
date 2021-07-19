Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35093CD713
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbhGSOFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 10:05:06 -0400
Received: from mail-dm3nam07on2073.outbound.protection.outlook.com ([40.107.95.73]:30907
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241149AbhGSOFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 10:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6NA4RZpZSXxnS/HIbNVV8gSQilp9hS8sAdM64HP1M8po16XJvCUnUB24TWnNWmzan5x/Cwuf2MemfUFDq2Hep/9WP5p87CgmE1tjpfMXh7/VssCBI/+0sp2mbxEUqJnKi8ZaVPgRBLctK+1l/Bi8Ebd0sacZvogmU8l1ygJGoh2N2UywocGGzPVG59FcLkhH+0qBskcTfzHxqvgrT6V9icYCHdoFlHR5Q8XpaPyyeHqWYSHfKsYtmH4q6ZVHqYdf6Ehzq6K/kS5iV8+JN1qQpSnemXf0EpWd5jcRM3gfZslUCMiLFYfwaan86WuhrRaku6x/CvqBk0mr/PK+d3ExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYa+mb2eyAX+W+iR/Fp0Txp9Q2B3xMZp1ZbljCdpB5Y=;
 b=Tu8/JG0m4rIw9ZmRDLWPWpteJSDj1K9jCM32d6eGaA4cbApYqMjfuNK8LyioxiKlOLohqomXYCAuG6i3+OP8GUllra++PWoOEOn94ZzSphaxHsbq0Phm3R+Yy4G95xLOj8ZjBEfB4ApBlRgSr7uOgcRPbmUpFRhWOEdTL8tibYPownFhMvTEbXlw3aWWF/O63eYhGMpI7bYrgJr+c+JfkWwhL65Rq3/nfGUUb2ClT03S4OF+8+gl19SDCWfuzKjIkvThRarq72lzJnl3wAIVbAwIWoMmAGWJ45PeB5WzVflGgPbS3Lt0sKssGL3rEkIPX03FslYO2o018prA6h6dnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYa+mb2eyAX+W+iR/Fp0Txp9Q2B3xMZp1ZbljCdpB5Y=;
 b=X16Kcepo2jd3WujluOMTV18RCvi3K9DgYH3Zn0bdU0DZlFboTAcC180tUvnAtj8MxmaccqrlV3IpiF1CB/saSCYfc28wyu3ZSTsMh6iZO8pHvTv85Ub736Iyui8SZzcyCI7nj44XzO3RTGV7d1YZ374rcAogkeyvjRXXwuwA0ns=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2784.namprd12.prod.outlook.com (2603:10b6:805:68::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 14:45:43 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 14:45:43 +0000
Cc:     brijesh.singh@amd.com, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 6/6] i386/sev: populate secrets and cpuid page and
 finalize the SNP launch
To:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-7-brijesh.singh@amd.com>
 <a9ca3ae4-2460-f069-d8ad-52c063e19e97@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1379c18b-a6e6-5965-d871-278da3af513f@amd.com>
Date:   Mon, 19 Jul 2021 09:45:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <a9ca3ae4-2460-f069-d8ad-52c063e19e97@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 14:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42365eb7-5dc6-42bc-4989-08d94ac3e2e4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2784:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB278473545C9BBE3CE4FC50AAE5E19@SN6PR12MB2784.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Yt+kKscuT+kfiUvaMv6dXfLNc9/34KQfqNUptdyo2Qapwq0n28KK5YrLOYIOW1/fgd4p7PXNbWJAecKLr9fXvj8hRZxcqw90dymWUPSe3LHiMH4B22qTVIiEkKez5S1C0cnCxEqt4/Vkecrh5hJe+iVDYb4kqaWAyHyiMegQeXxfjF3g+cBHe05USQj6N+0G1pCnmPmJI1YH80WCa+x0U4z41D1VSeNkrcyG7nXmzwINF8ubH2W1BTMvrRKrvH8q0QqEjc4ZVvbQFkT2/rQCEEjA9PzFemFDm9mIo62yMNfzQ6D90Ofz6fbHncKF3NWD6v7NYjILMvuweSYF5CQT1zM0BizhIDwQhvi68Xi728/CM+zxoy2NWoZaMlFBYDqb3xOP+EV9JOVF0Q5gzJmea1P0pJYzMXrQOKOh5F6sd+Ikq6Fa1hCUxO8LXTNtfBbqLbckSbjY1LovnY3TQOAHE3vRPolRZCYphiQhUXasV8EFwM0/7V1xuVSPYqqkEVNeQCzFpF3CEfAYa0+sDWEIYq/EIk2d3gW9G05Pl1AoupJ9XYARkdDB8BU6pUbGv0D26AO/h9pPAscJKcGJM8PptbDJJRcAb9CvHV7wyQAHGjnsZW2iudxWoyrg6Ut1pgINI5a+qmfpqjOoGjfX8U7ZyUnMfxDTz1ABzLT6jIkiCZsvAwv0nAh5QRjdwz31Qqk0PelZxgIihDIQtM5xwC4nUy+bLQB7uxlHbfb0TkTnprh6KyWUsY9V9/0Q/fH5f23ljZxwp3uygyE11fKlmWtow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(52116002)(44832011)(2906002)(86362001)(956004)(8676002)(26005)(186003)(36756003)(7416002)(8936002)(5660300002)(66946007)(38100700002)(16576012)(316002)(38350700002)(2616005)(54906003)(31686004)(6486002)(66476007)(66556008)(83380400001)(4326008)(478600001)(53546011)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzlabGJlNGVESDRrZk5mTlEzWHlOUXRjNEU4V2RnT3ZrenZ2Si9oRTFxUmpx?=
 =?utf-8?B?ZFYrWFR1Nm5LWjVsTEJvYVZaaGNENVRGRCtDZUNwM3RLU25FeUNkdlRWVEc0?=
 =?utf-8?B?dzhwRDBkMG1CN3ZwdStOSU1EM0hiS2YvTEd0Qjd2R2loYjV4WXRyT05kYkpx?=
 =?utf-8?B?MThiei9kUnRHaTQ4UGhxSXhBZmtwSmFqYXpHbWR2N1VPSHlRSUlLbTBOZUpt?=
 =?utf-8?B?R2dPQU9WQVFHaW0zOVZlT1g1c05zNXl5d2Q1L2h4cnpXNFVMREJJcXFBRWVz?=
 =?utf-8?B?b2k5bDdaQTRmYU5sWDZ5YnBPVHdNdVk2dUxtSnU0Q0xFV1RIUFJaWXNMVWpw?=
 =?utf-8?B?LzdXa2F6Ym9tVlAzM1BtSHR2NVBEaGpodUpUcEpQZ0F4WVJnbE92MVBTcHBF?=
 =?utf-8?B?VHNVNkZFelFvSldreDBJMm1XVmVmaDBGbG1RN3I1NjZ1Uk1NUVZvZ0NuZDQ2?=
 =?utf-8?B?bkwvdWdOTkRxTUhzbkxVaXUyRk1IdlBKL2tMa0JBNHZmUUgvMDRtVTcvRlV3?=
 =?utf-8?B?NUFyN0JlZkpnYnVJSldKdEx1S2ZLTDI4enhKZWozb1BMVlJvZzg0YTZBbjM2?=
 =?utf-8?B?eGo5TXphWngyZU9zYUg4WjIvZlo3VEpralBFanhaSVlxYytDUGNMd1BmYzl3?=
 =?utf-8?B?QkRjNjdOMUxya2FYckV2QzVpUC9EcDE1VlJ6NFRNRnVJT282MlBPdG9jQmRU?=
 =?utf-8?B?NGo4blIvdXpTM09TNnBuSTVjNFBNakp3T1ZjVjlaTWxPWjdEOHIwM2M4bW43?=
 =?utf-8?B?c3NyTi9tU2pjNFk1ekR2OGZMNU1DNGNuS3R3Y3N0T0RyZWtUVHRpYmpVdWg5?=
 =?utf-8?B?VStkeDdhYThncE9rZlQ2NE4vRTduQXI1QXdTSzZ5ZjU4N0FJTEhPT3J0ek16?=
 =?utf-8?B?cURWRDlDMU1JWktQbkwzbys2MkUxYkw0bFRlaGVEZTRXWFhpRW52MlpRdlNa?=
 =?utf-8?B?bkFZV1hwcWdPUkh5UFdBSzNPdU9lWFdmZGNZSENtZmNzeDNrZVE1RUUyTHJq?=
 =?utf-8?B?cWZJbFRFeHhaOWRHUEVtMUhreDhINDJrbGJLM1cvZTNPWEVNMCtnTWNqNmRF?=
 =?utf-8?B?dUFZS010dVRIV0RybWFQVGdSQUs3aU1qMlFHVUxiSWhvbGZsRUFjOVpWVVJr?=
 =?utf-8?B?RTVJdG5oc1Q5bityUUJHUzJZVytuMmlVQnkzVDVRY1lGMzVaY3h5bnJTa1FO?=
 =?utf-8?B?SjlxL1AveUxKRHFobnFWM0JkaVQ3c21lOFdndllZRzdoM2xuU3RvOEI2YURE?=
 =?utf-8?B?OWM4dUU3NVNzdXh0WFRUQlpmZzhBeWNUSTZ4YjQrTExZZ2FNTmRvVFVWa2FO?=
 =?utf-8?B?RU56d2dsUC9UaVQwUTJKTFVyMmZzQlN3cDMwZWVPS2FWMFdrUjRiL3pIOVl6?=
 =?utf-8?B?SUlyT1lyb08yc0k4cDhzOHBHalJMSkdEcnJkY3RZTnVnV1pqQ3YraVgwNjdX?=
 =?utf-8?B?QXdubTJwK3NMeklDOTlWV25xL3kwSzRXMUN5TlVCSmZIOHdneFJFNkVyOTV5?=
 =?utf-8?B?aDVaZDN3NXY5TVRoVS9UUFpxOE9Rc2VhZE9RS1NJTVp3SU91NThmb0I3QWpL?=
 =?utf-8?B?L2MzRkFkTWExRUFIVzY4cnUrd1ZGaUpyN1FUbEJRODlIaUxlRXUwcnFJeEN5?=
 =?utf-8?B?YnEvTDFaU0ovUHZsa2JCM0NrT2MybXJtcktvMVpnS01NQ2lxQm1uY1grdzB5?=
 =?utf-8?B?UXpXeHZkWDBJY0ZTR3I1M2Fjek9rVEZ1NFBmM0pxUUUvMWh6TXArM0pWalFV?=
 =?utf-8?Q?dFsODP6UECpvqkBN+9CfLZv/90pRaEf3mUG80X5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42365eb7-5dc6-42bc-4989-08d94ac3e2e4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 14:45:43.7224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIPelP0UPDcW/sSQ1lNayBHWuB2NI3sEA5ufSJZ2tVHQ4dOSLK0ZwSns7S4gyZyLA2ItrnxbV57loixBJM9SXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2784
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dov,

On 7/19/21 6:24 AM, Dov Murik wrote:
> 
> s/LAUNCH_UPDATE/SNP_LAUNCH_UPDATE/
> (to show it's the same command you refer to above)
> 

Noted.

>>   
>> +static int
>> +sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)
> 
> hwaddr is a confusing name here because it is also a typedef (which is
> most likely uint64_t...).  Maybe call this argument `gpa` ?
> 

Noted, 'gpa' sounds much better.

>> +static bool
>> +detectoverlap(uint32_t start, uint32_t end,
>> +              struct snp_pre_validated_range *overlap)
> 
> naming conventions dictate: detect_overlap
>

Noted.

>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(pre_validated); i++) {
>> +        if (pre_validated[i].start < end && start < pre_validated[i].end) {
>> +            memcpy(overlap, &pre_validated[i], sizeof(*overlap));
> 
> Maybe simpler than memcpy:
> 
>      *overlap = pre_validated[i];
> 

Noted.

>> +
>> +    trace_kvm_sev_snp_launch_finish();
> 
> Maybe the trace should show some info about the snp_config.finish fields?
>

I did thought about it, but one of the field in the snp_config.finish is 
4K in size and may fill the trace buffer quickly.

>> +kvm_sev_snp_ovmf_boot_block_info(uint32_t secrets_gpa, uint32_t slen, uint32_t cpuid_gpa, uint32_t clen, uint32_t s, uint32_t e) "secrets 0x%x+0x%x cpuid 0x%x+0x%x pre-validate 0x%x+0x%x"
> 
> The last argument is an end-addr (not a length), so maybe the format
> string should end with:
> 
>     ".... pre-validate 0x%x - 0x%x"
> 
> Also I'd prefer to log the SevSnpBootInfoBlock fields in the order they
> appear in the struct.
> 
>

Noted.

thanks
