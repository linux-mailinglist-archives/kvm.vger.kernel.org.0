Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD22534C61
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbiEZJQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiEZJQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:16:40 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2038FC6E4C
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:16:39 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q25P89011390;
        Thu, 26 May 2022 02:16:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=A8PAvjVN33WmjPQZ1wU+qG04waDoRQolEZF0N3wYF0Y=;
 b=fdEZkQSS6S7y2dLebMdFHGC0SVOssKtu+OfTLl5OvMV9GmL4DLCWRs6M1f1hjlQLC01j
 a3zOGG6gCz8J4y1IiOYYAedAC53Mao/vrD6UrsUX0Xf6f1aSAS7UTetROG1zSO7s1ygc
 2c1ruIp3bE47R9kZzc2k7slaTG5Yq9AysxzHls2cs64smG7c5NyDql0lg9yNTN8p9h17
 7zekExAiUWRFU6HAYimgLtCuUrj4DHuC6rn8rY2dfxP59fySjaOuhNd40jNLmLSBA/Ip
 PJWGGYWE0wPGp1fREhLaT96nNC8FQ4TJ9195+aCI/Cta/i4Zrj53b9xFn8HUFtFQI3+A XQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g9jva2f9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 02:16:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNOkLgzix6BOmz2wcDWqTYGBzt9yO7OH30VPtl/e/wgfgpZvpG+tFdTiyp7pn9i0AFwWFfEWw/l6DlxfdVeJELFxpAhJ+7WHS7hrqfSH4NW8bykfSMG25Yx+W7TKgPVL1K1Spz+EhZ5OXK49mJ6SvqzaG795NvFNlTIWLBqocSNi1LxKcPPBJV+AE7fGo0UDwJ5fS0e3qisb9Ig/9l+J9gWC19pIf03AtIF2ZejcoBlErvus/dWQQ9/4sgQ/0osfhGPDr0O0QpU1idt6xQXk4vAZKF8zGWNr/GSqfKg1fOe7YMTrq8FR8qQZi9gE6VfaTub0Pi0hJf5kxQjW9iLNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8PAvjVN33WmjPQZ1wU+qG04waDoRQolEZF0N3wYF0Y=;
 b=O8R0dlciwkNxspHiqKUcrNOAlX3trvc2gztxeq32eZgFY/Bm2msXOvzbGeVpZWsSUUYLUAEJH5MPrxhvKxpq0pOsK6klCXIYohPxQSz36rR1eo65fRa2N+YZm3v/tOa0VFUFkRt7fEpo7J3FpcklX6vXIbIeqxudlIuIEXSV9AZ/ghqytdgvxJIvPXdOzQ8fUrN1jm8sgRnHOHUE61ETq2HJV3JX4O8gXtIVZbUeXjE9qH0g4zDTEBeG3qt3oJTbr8SP4fQsrQW0PVgJ2jynj8wUo9gufLK/cufN76reK64fkeeav8D8N2SrrFUO1t3lowgfXsqEEdNvg8HNzWmsBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DS0PR02MB9022.namprd02.prod.outlook.com (2603:10b6:8:c6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.13; Thu, 26 May 2022 09:16:27 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 09:16:26 +0000
Message-ID: <c9f4b959-7282-231c-024e-810ddb8024c6@nutanix.com>
Date:   Thu, 26 May 2022 14:46:14 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v4 2/4] KVM: arm64: Dirty quota-based throttling of vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-3-shivam.kumar1@nutanix.com>
 <87fskzmmgf.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87fskzmmgf.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81d5146a-17cd-4034-d921-08da3ef8693e
X-MS-TrafficTypeDiagnostic: DS0PR02MB9022:EE_
X-Microsoft-Antispam-PRVS: <DS0PR02MB9022BD6254B3883B56AA6A7BB3D99@DS0PR02MB9022.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TINLuPZx3E+w7+FNfCasB+8rPL2XAHc7ndbQwhuhPkvRo8OQ2XBwwpT+Af6TKxqJBD6krS8ij2w4mYx5m22ZLjFIX7qIEGXCLmqOnOptSic8V0TKu92I7KPzdsbykFsAUR86OXMq9r2uItRlrrVQ0GOcYtu8fLYsWenHx3XiD37ugBBxKYLrsAEwBvuDNMJcgS/SCp4bcG7yfpSLpYfL1jrv+vkFvZPXcz6lHBL0o832TJRkBFlGQbfr67WmioXQ+CpF/vfgM7h3xj+OnSzuy4BK3NGs9+jwHzWAcRkd5TngrmDFBeg9xgoXTGFcdAViP4Jo0bUXmczxOB/8fZdoCH8F2+IOS0IkG7ooSoBUt0ioC/NUMjQaxY+8so2nItWEhr6l34WTM9hSUptUnG3XfHie5AvKmKE+jrZ7Ia3iOeJYKXY4sG8HmY9HrpqW5QP3lH0weHBR8YfxRbKgZddezSS1iI+klcNcqI/40OKRpEYlkGsgfPV1MUsIfqGVxDwnyg3vZclMErzccoKbEBcCMMSVnMrI5n94jCTnNlGFip9RhZzTvqV1fLSI6gR/ueD0tRmbfdDvhgqiZDywRhyBjYM9thM6IITOYnN70YD9pZx4wQA7Y1KGZmsLREFQH4ey7mCOGz9AeDOb7XApzHFnQgyQk5/thYEVx7wcvFh3g3Noa6MQkhbdYJHyZNzhRr/EHnVbRh7EGhzCIFZkVM+VC9A5MjGymrHnZa09shMoQlGN8U61f/6tJ8OhqEnvv+pY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(107886003)(186003)(83380400001)(8936002)(36756003)(5660300002)(15650500001)(2906002)(31686004)(54906003)(6512007)(66476007)(8676002)(4326008)(508600001)(66946007)(2616005)(66556008)(26005)(55236004)(316002)(53546011)(6666004)(6506007)(38100700002)(6486002)(86362001)(31696002)(6916009)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHFKT0ZFOEJoMDk5YXpkTmRCUmZMbGpaV2pxUENFeEMrTjZSanlpeUZaYlNI?=
 =?utf-8?B?Q2pNalVrS3luVS8rc1FtRkhvL1JxSXFyMklXVENlT0dMdUVuUUw3TTYvSnJX?=
 =?utf-8?B?MldZWlBGdmNoTlVtQnRCTW9lcHVxamJRNzFZaS9lZC9HU2FEeEtHSFNhbE1B?=
 =?utf-8?B?ZnB6Ny9UZ1AvTmpoaC9NcHNjb1RKdjdvNVl4QzlGZ21BeDZQcm9EZmtOSElN?=
 =?utf-8?B?Wm96ejY5NjZMVkNCSWV3Y0dLYitPbzdRaHUvaEZDMHNnUVlnN3RKaXZlczlq?=
 =?utf-8?B?UG1LbFVsZHRWc2hpazNUaWMvYlg0c1FZaWJoOFRmRUI4ckpFeVJQanMvNmVs?=
 =?utf-8?B?VU1IdXhVdCtjR2w3ZEdxeXBwS3ZYbDgrREFYNkIwcDRDZW1kcXYxV2J4YTAz?=
 =?utf-8?B?U3hadGNrUzh1aXlVYW9QYUg4TWtKRTR4TW1JNzVXN2NQZloxNGpnVDl4aHVv?=
 =?utf-8?B?ZUNRdXovZTNnbXh4ejNJUlJ6L01aZTMrVDhMTFRpWGc2K0pNMXJRR2VMMWVx?=
 =?utf-8?B?ZG0wQW1GVlFJZmVxMTJhdEVwNFpPY1ExUythY28ycHRZQjlXZFB4OTZORER0?=
 =?utf-8?B?UCtLMzhRTW41OGZKRlFwRWJzS0lKTkIvaUtxMFhPdzFXNnB6eXpRVlhkNjJL?=
 =?utf-8?B?c3lFYWtPc0luZlBINEoxdy81R2JabVhmQzZJMTQvRWdkcDBJVjlsQUd1bVNR?=
 =?utf-8?B?WlJHby81Q2tXK3ZFNHdKclZkSEk2RVpBd2YyZzJRZFp1aVgzbFI0MmFvSVV3?=
 =?utf-8?B?QkVZVVZPYVc4WU5Ca0JSQTVmSmozK2VJM2ROYmE3WVJKbWJvTFNmU0N3bzBt?=
 =?utf-8?B?NmlpaVNaYWZtdTRqUHNRYURUVTRKc2tTa3ZuTEdUZ3dKTm9ZY09PSkFuVUtq?=
 =?utf-8?B?NEI5N29pQ240cmhYMGdLbjNESCs4TWZQS25IcUc2UVJ1SW4wSWs3MWU4MXRM?=
 =?utf-8?B?NEh3ZEdmdUdrOFVoemdZRVY4SlJBcVdmejlUUUJ4aVhWVkxuQVZkSmFWSDZy?=
 =?utf-8?B?ZFJ5OTI0VGR4SmwyeDk1WU43cVZQanhhMHM5SWdzRFE5U0JGZ0hWaTduK3gy?=
 =?utf-8?B?WlZtRFEyZXptNjhVMmhLQjEybTduTFFtaXBZT21PU2xrd0ZDUzhSQTRtK2Qx?=
 =?utf-8?B?UUZtTGRjKzNvYk1XUXY1cE5uYlZ5Z3Y0VDVOaVpTeG56QlduSTgwMEh0ZTUv?=
 =?utf-8?B?NkljR3hVeC84N09vQ0d0R0Z5QjdFQkZHOTloU2VJdVBqMzNsYTlEM3lyUnJo?=
 =?utf-8?B?NEk3Y2dsaVFQaWxDamhIQWYwbDI1WUV4QThHME9WaG0rM1AvSGNZSTdHcS9P?=
 =?utf-8?B?cXMyQ3RKa2NJN1Axb3Z2TWlJLy9acXlZUHVpSXJ5bE1aL3pRdnBQYXpIRWV0?=
 =?utf-8?B?b3lNdm8xRUFORy9IYlJhR25wVWdFcTk1VjNmQ3hOVjhrTm9zajB4RXJ1WWg4?=
 =?utf-8?B?OXZlcDdGckFGdnJYazFUam9vdkFOOG1qclF3bVlKVVA4bTlkS2lKMjZUVGtz?=
 =?utf-8?B?VkRKd1lDbVozaUJUT1Z1aHFEM2dBTld6ZFhsL0VVazRzcUp0dW40Wm9DdEJM?=
 =?utf-8?B?eHVCVHlFMDJoaHZWTXdwNGw4ZTNGR1JGaUFLUWJjM1BqZ2d6ci9vSG9nblM5?=
 =?utf-8?B?anpyVVRRU2NNMFhDbkdBSkxaT244ZFRTUlJpWkh3QldFYmJ5SDNJTnR5YnYw?=
 =?utf-8?B?NFp3bXBvT2NJVmZReURQL1VSTk50cWw1K2tGeVZ6N0dBSkVYWWx5Y2xpSTZz?=
 =?utf-8?B?NE5ldVJHOTZqbHl2ZFNBZEo0cUJsalpxRmx0REZsNE0vR3gvUC9HSnA0YXRF?=
 =?utf-8?B?UlFZZlp5TnNRUHQ2eFg1TldmeC9kcnI4MXo5Z2MxdnlJZ2lzYWlsV0FTVWVG?=
 =?utf-8?B?NFhRa2FBYkFzZnIrVVJiTTJpNTREREpZVm96N0pZNHNKclJMU1A1UDdKbVRk?=
 =?utf-8?B?c3hRMlVlUDVzdXVveE1lTUxaY3FYSXBOdW9qZFdURVB5STMwdlJPb0VTRXZh?=
 =?utf-8?B?cHJ2am5QV0FMVlB2ZEd4dHpxUU9rQ29XdUNUTWNmMllsRzREZ2NoT3lDc2JS?=
 =?utf-8?B?YkR1QTlqQVFrMTE0NlFJVC9MalB6d001UWVoZlZZbmJyTlRybm1xeHM5bHVj?=
 =?utf-8?B?QWJ3N0lzUCsrMWhETWhUUXd1UjFGTSsvTXJ0YktnSzFwQUMyVEczdDVUWFN4?=
 =?utf-8?B?MGJIbFdNQmFvOEt5c2ZtNEF4M1JYSlpDSlRySDZIUE5HK2pyMExEalc0cmZs?=
 =?utf-8?B?MzVCdS9CTmxoSTROUzFaY0VINDNPaTJtVDFGWWRRU0lmc283YlVPWjF3NG8x?=
 =?utf-8?B?Mkphei9Ca2MxU0ZJZSsxZjN3bDJ4K0prZ0pGV3N2ZlM1T1lZdlpldkNTVHcv?=
 =?utf-8?Q?ZycFP0n8vqDVriYI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d5146a-17cd-4034-d921-08da3ef8693e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 09:16:26.9102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7Gh7hj61j011F03Bl1adSmTK1Vz47sen/UkfA92EcG5xmNGyfUzu0Y5Wa55bAhp9509dxw7ry/sm593M6NoXy4j6HXtk8/FQn5JZ1vzqps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9022
X-Proofpoint-GUID: 9ztvKuBAVco3fbf7DR3OZoTmb7FbuHwa
X-Proofpoint-ORIG-GUID: 9ztvKuBAVco3fbf7DR3OZoTmb7FbuHwa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 24/05/22 12:44 pm, Marc Zyngier wrote:
> On Sat, 21 May 2022 21:29:38 +0100,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
>> equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/arm64/kvm/arm.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index ecc5958e27fe..5b6a239b83a5 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -848,6 +848,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>   	ret = 1;
>>   	run->exit_reason = KVM_EXIT_UNKNOWN;
>>   	while (ret > 0) {
>> +		ret = kvm_vcpu_check_dirty_quota(vcpu);
>> +		if (!ret)
>> +			break;
>>   		/*
>>   		 * Check conditions before entering the guest
>>   		 */
> Why do we need yet another check on the fast path? It seems to me that
> this is what requests are for, so I'm definitely not keen on this
> approach. I certainly do not want any extra overhead for something
> that is only used on migration. If anything, it is the migration path
> that should incur the overhead.
>
> 	M.
I'll try implementing this with requests. Thanks.
