Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC22517ED3
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 09:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiECH0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 03:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiECH00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 03:26:26 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1696E3A5EF
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 00:22:42 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242LDLoH017478;
        Tue, 3 May 2022 00:22:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=zAKAHVIYSUDCtPyAYCSgYeJ133VoMg4fUqRra/0q4eg=;
 b=TNvbfA39u++cebyzXmgdVeRsnDxZGRo90GnC6TcXocf8Pgtw9vBuY0xHqtMI70jwd/8n
 QXkvrp4SzzzEeApD0AcxO6RmByc5UyadpvP7cLOEVv0BqNqdnY7KSEvLgtv3PLFUK69P
 Djx1qcYAV0pxK2U2SqMrnlMct87x8NSob5ZWrWanTBTvW235TTJkUuhZ4nEIIVBA+TUs
 BnU+EBKJktk/3IJ66jAeA4hhj+pKroRvLxpvSKx9VI3Jq5Dxau7Yx92GBhFK0eIUZTMo
 23tpq92aLaPrI+9NiEeDQUgqoI6ZJUTrL3iQwMClU+D+q6Tq2IEbVU7jwdtJFfWkLZYv QQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fs2n84y7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 00:22:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8YhYIti3b8m1bVJizZDEY9b1VQtsVWc+dqtCeVUP4JIY2+nuzBwRZh2BWybwgP/44YYScaekyTZl19/uirim1tNazYf3C/2K5bIBJlCZbdYsOEXFaXQRaOZ0lynZc56a7NMOS8JSNu1eG2KxyBqItTl3gaQJb7mzkpSvQ8VKFAsks+nf9UYM/pPwRCHCFmIlS9kHsNWgG9+fUG62eCwQue4yjhIuq3TfTkYYnmrdETr8yg4v4rvwbdfKl1sTQ5kROVWFsbxjX/ytxsjegfM615AS2fiGeHUOQPfeX6fLYeTcF7gNMv1EsMLso9lGVyPwoIyD24gcCZWSo2fcKcnnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAKAHVIYSUDCtPyAYCSgYeJ133VoMg4fUqRra/0q4eg=;
 b=PYXu5Q0EUb+Ovdyb2X27JznS21BE3s1FAwZZnTYJ2EckgvMCKbasqD9piXPerrXtLAHnbSEgi+enJ87CSwWmx9f1W6M0HpZmNNoN1erIX6smOSfMNvSPDAlbsJFGT2k7FyGtm76KFyptcDfyEIOPMdxnZF1I3XHv7w52hQFleBD+G/CLCMviTvM5imvb1/nxoZ0FqzGL6J2FzXW7PYdyyREkGamn0y2iDonhOTTH0bxy6CWEI2c/m9oG8tCBgs9VOv7bjnkv/wqGJcUlTCqfaT5Zz13Csxp0HaUzJGdYOqoPf4BvYbumS2wN2fjuQVT3EFv4MIykpJVzKffo5uliiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN6PR02MB2338.namprd02.prod.outlook.com (2603:10b6:404:29::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 07:22:38 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%5]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 07:22:38 +0000
Message-ID: <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
Date:   Tue, 3 May 2022 12:52:26 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Peter Xu <peterx@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YnBXuXTcX2OC6fQU@xz-m1.local>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YnBXuXTcX2OC6fQU@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::29) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c022048-5902-4810-e888-08da2cd5b384
X-MS-TrafficTypeDiagnostic: BN6PR02MB2338:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB2338AAA1D1D0136E0FF35AE6B3C09@BN6PR02MB2338.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBdzUWNs83e2vrYb/WbOdvh6cqGgeA1KdWbG4AYMLi8m+CxU1AXSz3nBGjINb4P+mdUSjz/PHOFOaoNIfa997wSE3I+GpGfx91+3k3bQbpj+7PjVHL7rbWDiQlUt+Ckp1o9VNzRcINMb1DzpIXin+Dn5n70r4Rn7SworF18tt4Bx1/gXGZQzeTMofkmHFqkdWjXHv5YYop/gICAeGpKBo+9PVctfS8TideQVYD+lt4pw5rdqON3z14cFtBIjWUhVl9jAHJeK0HAQ7/O0hqkwk3bJ+B7lIzn4RfIw+sLWzXPUNiqJCOvMTjoXPh9pPB36rHRwGJO0IRoHFfDJAoyFL/H6cUcd6+6X3rXWiG7w2nIBURRv13McMZJGhA3KBEPEFp8Jj2mOHZuSr0dzlKxyAtdVV6JLfvMfBNFBUHRcgRUaVlpbSKV+VQBieIPp7FEV/cQt56ugh4WyreCFrXz3Bw1WhlaAXNh5ZMahoJ0qHWXmZQrDgSxp+XVcza4/mj27iLqK0sNSvvhxowvIFVnlA/QvcXGsSexmbswxswuTDWYNNhYoQG3nwrvWER3SYaRkuS8hzJCC+2MBD0A1Z+urivaALPOPNWLF/JVKudeLmyQ2CqxADajdtK7FGf4j0ys+U62Hnb8rebjWJo2t1ZDyB+geC/rvgoS4Qgc74NhUhoX+JkyDH7ZoDt9kgSy0qXfQKpVnr/MYwTBgA+pJ5nrW/M/SFK1ULCz+Z9QwFnGXKBajXe/2sAV0H+TM7QPOTH/WG4O8pQ1SSjd1Qt3/s0QmRblz0Y45zG6ptTqojj7CJ23vRwbyia8R5X9SPzmjDXAjxxNYPve4FL0ErQfttofv/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6506007)(53546011)(31696002)(6512007)(2906002)(15650500001)(8936002)(6486002)(38100700002)(508600001)(36756003)(6666004)(5660300002)(4326008)(83380400001)(107886003)(8676002)(66556008)(66476007)(66946007)(31686004)(316002)(186003)(54906003)(6916009)(2616005)(966005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1BU3FaUTh0WUZXcHVKWjZEeVE0OS83ZHhpZ2pYTncwNEMvWU9XNDRmZUt4?=
 =?utf-8?B?OURQbm5zYlJ3MDV5U2RQeVZTci9KMkRXMERrMCtwRjd0NmFNekZsRVkzckd5?=
 =?utf-8?B?RTlvVTVpRS9hay9uU0ZPWGxNbDJOTFFBUnZNN2x3eElLcWx2aklsdWxpbHow?=
 =?utf-8?B?WGRaUWw4SlRvYmYrVDd3b0dJaTF5UnMxZnlScnJFSG5STEpNWEd3WmhvRWZS?=
 =?utf-8?B?OG1vMXljTFJETERTSk0vSHZHUWQwSDNuSUNoVzYyTEpEczZxOUZoNW5jTnc1?=
 =?utf-8?B?eXZ6UFN6WlNIMWUyNmgxZnVHM0trWjA2MmFDQm1kd3FuMklzTHVUUy93cXNr?=
 =?utf-8?B?ZGJrOFc2b01uNllxOXlvVTRhYmNvYjlFR0xTeVZXOHF0TVg1Q0tZY1R6Q1BV?=
 =?utf-8?B?bkZUVkpuN25ZcmRVV0UreVd2NURTS2w4cnhQSlpLNEFLMW1ldWNNRU9oUXlX?=
 =?utf-8?B?b0FtbEcrMGZpNW9CRkZxTVhhQkdTTGZmSUJFODVyZWdYRnc3ekFRb3I2WFds?=
 =?utf-8?B?MzU0M0RnYUFOOHZ2NmM3WWJVVHZEU3VVdldrRkFHVDdEOG8vRW5XR1g0UHNW?=
 =?utf-8?B?WGM3dGlwYmMycHFYMUNpQndJc1hzRXdQdVhVVU44bDJxc0ZmTlFRRVJ0bis4?=
 =?utf-8?B?Vi9JTndBT3UrV0hjS2kwUXgzOFhvVE9YeGo1SUV6RHdqTzhDcDVkcnloMnhu?=
 =?utf-8?B?RzJweXdQcVZGdGdBYVFZdnV4a2RRemNzWEJveW9MQUozZWdtcHJYN1RKaEwy?=
 =?utf-8?B?L2dvcDJnU1NxSUNIRzhmZWMwODlab1pBOUVhTXhrZWZmWlMxaWRoRWw2Rkly?=
 =?utf-8?B?aXE0L3hpdy9uZWFIRzJRU3FlR0NONDVDZU9vMlNkOFVvMUhlZXBWUjNUcGNP?=
 =?utf-8?B?aTc5UkUrdXh1ZXEwdHNtWk9IREIwUFpBbXVnQzFIK2ZqVGh1dEVQTVo1ZmlV?=
 =?utf-8?B?c3B0azN0bFpCUmVjbndmYWM5UEdoY0xSaVhBVVlsVmZ6SjRKUmd3cCtWdHNT?=
 =?utf-8?B?YTMzYUdhMzZmMVUxbHAvdy83UnlocFFCQ0VFU245TmVBN0Z6L1pVVldncHZu?=
 =?utf-8?B?Y1lmZUFIaHA5bkllKzcxU081UDkyUjlEaERMNEcvcFRjVkFiUW1DejAwTWUw?=
 =?utf-8?B?UDg2aDI4NGV5eVZCeDJUeE1aU09NZC9MTzFwNWw4UUtPQUEzQko2M3k2bi9t?=
 =?utf-8?B?Z2VXS0dvV21SY1ZWb3FSVWxoc0hqeXR6ZEJvVmhlejd6MUZvSll5dStoR05E?=
 =?utf-8?B?czN0L054cmZob2tVbUMycWFpeUNTVFlQaVAxaWhTazBiQU52cjhIbHNXSG1x?=
 =?utf-8?B?cUlCTGtmeHBsbFUrWVFWbTJWOC9sVWFJelBSencxbm11VS8yZndMYUp1QVEr?=
 =?utf-8?B?YjJyUlBVdU9zakNUTFZHMWdCZ1BJMkIyeXZidk9wUStKR0ppRUo0ZzhJTlhR?=
 =?utf-8?B?SFFhT2g0b1ZYR0V4Z3hjbUZNUitydldLWDVrZzVpZCtRU2ovK0lwK3ZrY1lM?=
 =?utf-8?B?aW9FS3RVSmNBeWpwQWt2TXVsYmNjQUtCMzNOWlFsZXN2UGNoMlNqQ0NzdFRT?=
 =?utf-8?B?UEQ0QVpVRjBhQTZBLzBuenNnRGFvTlNIYTM4ZGRXWnh2M1gxdEE2aHRMeVNY?=
 =?utf-8?B?OUt0Q0VLbGZ1T1A4SWxEWTYrVGRZWE1ycDA1ZTZxb25RL3FUQW1Nb1dSR0Yz?=
 =?utf-8?B?QVBSSFphQi9JR0VQSm5UVVU0dlRvaVg1enlObkRhTnFsV2F1cms0akJxVnJ3?=
 =?utf-8?B?MDFmWVN3Y0JWRWg5ZkZhSmVPN2g1Q3pGbTRLSkw0SDk0cW1qT3QveW9iUTRH?=
 =?utf-8?B?VExkcXRtZk9xZFlaL0dEb2NNbXdYSjlMcUJpT3FnVWRZTm5TKzRGWWhyaVJI?=
 =?utf-8?B?TDR2M3J0OHBEMkZ1OHprMy9tYy9DMTJUd201UU5xOTRyUmUwUGVzNEpvdnZD?=
 =?utf-8?B?L2ppRHFueVBjUmRiU09MUXJEdzRRNTB6Qm9kOHJqUzlRZVhPaE1OUHF2NVZX?=
 =?utf-8?B?WkJEbHhkWThON3RrTzBRQmd3MmhOYnhyaEpCbUR5MitUQnJtbUF5c1UvbG4w?=
 =?utf-8?B?aE1PbG9lR0YxYXBTYXZReEFKMjFFcTc5OGc2WCtIbmdsUUtVenlKcmZOQTRn?=
 =?utf-8?B?aFYwaEtTYmNLQzhsSG1NQ1ZpUEZ4MEJEa3ZYbXpJNEVkWHZCSFhZYUtHc3VB?=
 =?utf-8?B?NE92RkVQdU5ZdnE4ZnhNVmxSM29HeTJocCtIeisvdlp3NWVuc3lFWFRWOVp1?=
 =?utf-8?B?YlEwN21MTVp1TUdLUFBmQ0N2Q2NiRUlqbjJ3Y3BMQnJ0dVVMbTZ5eGhxZTBL?=
 =?utf-8?B?ZnAxMThReU5JWmcvWnkyaTdpdjlGK1NVanVPVDlWUVAvTlVWektuWjdTRmtK?=
 =?utf-8?Q?VrbNP7ndtQcB8yPRExWRLOerbaIZR/a8oeQbemn1ayURx?=
X-MS-Exchange-AntiSpam-MessageData-1: HQ0SRkuGm0doufiUpIp+ZYozjcd0ApqTOhU=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c022048-5902-4810-e888-08da2cd5b384
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 07:22:37.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwZYgmpeQHR4K/fyONLk+QNz7nHMTbRC1jf2TUO1Ou0zpAH+BzvoHjPJdHc3Tvr26nCPfpSV+u0aQJqfObGhB3q5reabt1XqHSeMQ/fQ/C8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2338
X-Proofpoint-GUID: M4QGuJbGr8mTdwm8G-2ENi6YrKUiPvvd
X-Proofpoint-ORIG-GUID: M4QGuJbGr8mTdwm8G-2ENi6YrKUiPvvd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-03_02,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 03/05/22 3:44 am, Peter Xu wrote:
> Hi, Shivam,
>
> On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>> +	struct kvm_run *run = vcpu->run;
>> +
>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>> +		return 1;
>> +
>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +	run->dirty_quota_exit.count = pages_dirtied;
>> +	run->dirty_quota_exit.quota = dirty_quota;
> Pure question: why this needs to be returned to userspace?  Is this value
> set from userspace?
>
1) The quota needs to be replenished once exhasuted.
2) The vcpu should be made to sleep if it has consumed its quota pretty 
quick.

Both these actions are performed on the userspace side, where we expect 
a thread calculating the quota at very small regular intervals based on 
network bandwith information. This can enable us to micro-stun the vcpus 
(steal their runtime just the moment they were dirtying heavily).

We have implemented a "common quota" approach, i.e. transfering any 
unused quota to a common pool so that it can be consumed by any vcpu in 
the next interval on FCFS basis.

It seemed fit to implement all this logic on the userspace side and just 
keep the "dirty count" and the "logic to exit to userspace whenever the 
vcpu has consumed its quota" on the kernel side. The count is required 
on the userspace side because there are cases where a vcpu can actually 
dirty more than its quota (e.g. if PML is enabled). Hence, this 
information can be useful on the userspace side and can be used to 
re-adjust the next quotas.

Thank you for the question. Please let me know if you have further concerns.

>> +	return 0;
>> +}
> The other high level question is whether you have considered using the ring
> full event to achieve similar goal?
>
> Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
> gets full.  I think there's a problem that the ring size can not be
> randomly set but must be a power of 2.  Also, there is a maximum size of
> ring allowed at least.
>
> However since the ring size can be fairly small (e.g. 4096 entries) it can
> still achieve some kind of accuracy.  For example, the userspace can
> quickly kick the vcpu back to VM_RUN only until it sees that it reaches
> some quota (and actually that's how dirty-limit is implemented on QEMU,
> contributed by China Telecom):
>
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1646243252.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=y6cIruIsp50rH6ImgUi28etki9RTCTHLhRic4IzAtLa62j9PqDMsKGmePy8wGIy8&s=tAZZzTjg74UGxGVzhlREaLYpxBpsDaNV4X_DNdOcUJ8&e=
>
> Is there perhaps some explicit reason that dirty ring cannot be used?
>
> Thanks!
When we started this series, AFAIK it was not possible to set the dirty 
ring size once the vcpus are created. So, we couldn't dynamically set 
dirty ring size. Also, since we are going for micro-stunning and the 
allowed dirties in such small intervals can be pretty low, it can cause 
issues if we can only use a dirty quota which is a power of 2. For 
instance, if the dirty quota is to be set to 9, we can only set it to 16 
(if we round up) and if dirty quota is to be set to 15 we can only set 
it to 8 (if we round down). I hope you'd agree that this can make a huge 
difference.

Also, this approach works for both dirty bitmap and dirty ring interface 
which can help in extending this solution to other architectures.

I'm very grateful for the questions. Looking forward to more feedback. 
Thanks.
