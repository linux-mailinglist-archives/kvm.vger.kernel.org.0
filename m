Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C366ABAB
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 14:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjANNkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 08:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjANNkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 08:40:39 -0500
X-Greylist: delayed 1932 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Jan 2023 05:40:36 PST
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA04524F
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 05:40:36 -0800 (PST)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E9G6Es028531;
        Sat, 14 Jan 2023 05:08:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=kCK36TN3uqaVyDoCbGYFNofykTnFmKYaLfQxEmpUlvA=;
 b=bCcWBJuXvakWKiJ3QjRi8ZG/nWf/796F4PYs/ztd457A9QbwgFIqhsxzFYsa0vr6qeDY
 BPijEf11byuDV3kr24rwL1fEsr1oVhJ8qe1m42iPbndpRAq9iJIh1BMxqyhOUGdJSUVV
 4MQr1TdEsSnmmX8eV4bhQ0neIqA7lq9sobuPn+YDorzH6c93QBlaBLqi6crW5ZkMi9Zv
 inmu5P6N/sLhjCoSZStMvnksXcAa1rpf5o6bKd+B0iXLXSMk65H3ZMAX/ZSgtkIt1vE2
 kaO/AV4WfbUnzsFHihgytFPmScmIX3wPw3L9uB2flpl9vebGgmh0Swx4Ow5ZRnvJLTYl Vg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3n3sm00bd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Jan 2023 05:08:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wyg3y1Rni8StcS8lHhkROegcVubQNs6aovP6tAcBVUce1NsnyL8SjjfDTuK+zNPNc5fQ7QzBGMbqLDmQ3BhekH7xjJBJFC+WKNtaS35IWRuOCO0V1sT2U87xsqZhDyhKVJ1J5CfzNAQ7PWAr09BgEEtBKaCtl4p895pyuLLL6VitOyqATrPqMecrH5jSYJsF0Ylsf2Mn4X5j+Yk0ZUbHrWR74pW9QmFy7IhaXXJQgkMLO45lbHCjrUZiD+Yxq+VclTQHOc9haY728CFg/RXFb5lYqRMDLs8qGKGPgTdX+zGGhqrpnBEAbfJiH8TTed+kYXMIF/qS8k4X5e0LpfT36Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCK36TN3uqaVyDoCbGYFNofykTnFmKYaLfQxEmpUlvA=;
 b=dGcw5to2WWr15nIRpZUSumLZzLCMlCCH++YIvTBg8uecGZU000smDLcDbCsJRYB38ZGu9Hv1dXVQoY4/vK+3yEyzo1jGJQdGD/rpsXfoaHXZExWGG5cXrZQVa7MzHocIG1aaH/ZmRot3tlbZQ5fsGjp6fTmOIsbNbYZkNXGRZsi8mdgtEL4LEydSazfSpOqG++6ubORZGH9NyQaKuhIWa1I/hIS50dIK4WeA82IAxVUYj9GqhkHhgrUuqh9c2bnvdohvrjU98FRdSM/7424yXlIIbEtLWz9BqtYJnQWZlXznfqc4f0A/qVsFZrebTNfmY0Z0B6/dp+K3kyHIHcZq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCK36TN3uqaVyDoCbGYFNofykTnFmKYaLfQxEmpUlvA=;
 b=tPYESu3mKwHIlmhEKjhzMo4TdmTHtNcAJyhausyT2Pad3isFccF7q/nwjT/9fm5RqUkFYeq0D7Wh1hFma8iaIbQZP/nouqdyOTwHB2lM2a0H5Rt4nh/VEQCsts1p5JBEH//0EBqoaYuneqRlRAKTaunK+Hzz4o1CDxd8DbzaqSXPckpmwXUjNUJxs6vpgBOVFZUkwVaMTOvfuof2w9Q7MZtYe9UaWFKkzD0s208YyoUFSLKN0v+U93nyErIKtUri0ucZ7goigRqYz7Yr8+ZExhbHEPF9pK198OJYeRjo4mc0w3/wAbbWTz8eh2VdxANS5Nv79vd7WpOKyCWhbvLmvA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DS0PR02MB9369.namprd02.prod.outlook.com (2603:10b6:8:14b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sat, 14 Jan
 2023 13:08:03 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a%9]) with mapi id 15.20.6002.013; Sat, 14 Jan 2023
 13:08:02 +0000
Message-ID: <4df8b276-595f-1ad7-4ce5-62435ea93032@nutanix.com>
Date:   Sat, 14 Jan 2023 18:37:44 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
 <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
 <87r0w6dnor.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87r0w6dnor.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0121.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::11) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DS0PR02MB9369:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f4ac2b4-51b1-488e-3c21-08daf6305e08
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vx5ByLNCW9bQ5ePB0I54uAlI531w+d0Sgc8vBqyIRymMRyp1bSiRB797WlQOrJ0VJbI4fttfN1bgq2xsNOmKLfJHfyVDNDlkIW3p94BNGz2HX6TBWOJj+ChmK6P4XayKLyrHEl4bI9meQlk5dZf64GDjsspZz1yHa2mFcT62fmVONg+TRX6qZUe2Ddp6I2Vu/SSKLICi7hGnpjlIp0h5wwaFaRHbJFIyeWcMdeYVJxI73zh9E7BbX0OctRZWttoUNrxTfNvykgwWg0x2Qy9JzbrshpVG1tC9q7WYLNtes2fZoZeQOSSyAH8usJuaTLckjeMl33jbSs4hmWFLjil/tp8vJJND43SNRMgRfq5+XWEbtRdRhTcmsqLPkSqA6Vkg+M0O47R2m2FaL7IL989EOBBCnGXUCTEo/M0JtKfTQcw3diiVz+DQmuwcsiheWHdMhOEz4JY/ttoiuwR10/OObFcm5ubDBDVFHdmAlc+m52H1NjceQ6fernz/qPOFz7Q6ehHdiTWx8z3io66qvd3M9et30dtCKaq1xMrQfA62fGHbu7HVQ+nDsh6mNNy0RRx6Q2WEpoDFCbwRbdFYwKm2ouPY5rLahiiFfuGV5rbtiXftQjA+dG8Ao6IoeqF5s7Jq5cIvwH1BBjVUiCo67h8kuIygNJ8zrbM27GjJl4Gl0V8mxJO+BjOuwXOQjTT7wYY74BFPpCZrTl0gjEN7gZbjN9fpq9vjVcQZTUCRnKkQw1UgNOz0/9WescYKz/AsxaDDXHtfzggq1Z9YfCdnIRU7E38K0DnaAgrV9lVuXuaCFwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(6512007)(26005)(186003)(66556008)(8676002)(6916009)(4326008)(66476007)(66946007)(316002)(53546011)(86362001)(5660300002)(2906002)(41300700001)(15650500001)(31696002)(8936002)(36756003)(2616005)(83380400001)(6486002)(478600001)(6666004)(38100700002)(107886003)(31686004)(54906003)(6506007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWRWeCs2NWgzRG5BTlU1bTJxS0Zlc1crdnRsQUxCNTh0S1Y5dzlQcEdYV3ov?=
 =?utf-8?B?NW96c3laYUpvN1diRElSaVQ0RStjc2VYR1RZaHhtMFVmU0NqNzE2K0RRTUZZ?=
 =?utf-8?B?WVNZMERKZ2JZYU0vcnQ3elNmTWUwZUgyZmkyZHFkTmlWSTlzbzZnUEZ6T0pS?=
 =?utf-8?B?c0h4V0VmcDV6M2xoblY1Q2pZU1ROaU1taW1RQzVUYVFUaGVDMjhhQ2dEcFRQ?=
 =?utf-8?B?MzlQeVl3M0VsOHB0Z2tIb0lWV1NmeUJKVVVaa1VlYnV5V3BKakZ0N0NaVEVU?=
 =?utf-8?B?TFR5NTYvUU1OcUI5aEdGSmxmVDdGd09yMm5qdWNnaDhVc29FVU5DTHJqbUYr?=
 =?utf-8?B?SVpMSndXd2ZZaGg1UEVZSmEzMjhWWnE3Q2RYc0JqMldVZVBqRGZ0UjRhZzNF?=
 =?utf-8?B?blIzaHp1am9WeDB2SEo4VGhQNVZhQmNSU2MvMy9jdHMrUnAwS2NLemk4cTV2?=
 =?utf-8?B?c2wrc2ZyL0VYZXBaLzd2dTArMHRJSzFxcTk5eXJRV056dHlISEp4UDdSZEJw?=
 =?utf-8?B?S2RMNDZlckJFS1cySEl3bzUzRkh4YVpsSEl3OVUwU29nem5oVkJLcXlYcS9p?=
 =?utf-8?B?OU5SaWNWcUFjcFcxczF6S3g4bE14N2RFYmpzc1BMRFNqRlFDeFo2T0FtWjEw?=
 =?utf-8?B?MHdUaklXRi9pODNBVDJielRZeDg1eTFWazBIOFJ4bXNmZkcwdXAwcFl4TmI2?=
 =?utf-8?B?TUdTUGZBM1R0dCs1MVB3bklsQXVkYytoSzZIMnQvT2tIRDRncjltYW5TYUo0?=
 =?utf-8?B?UlpVc2JhbEVCVkN0MXBRcEN2azJSbUYrbWk1ZnB3WC9IajRZckpsN0h5elBP?=
 =?utf-8?B?ZFFWREh2MzhIZXF0dWNXcHo5ZXptTFZjWGYrVkdMWUVITExha1gwc2JqQjd4?=
 =?utf-8?B?eksyZTl2S1VGMWhXbkNnZDE1TEtqK2wzTWxHeFR5YjN3QnNzZ0F6b3pUNDY1?=
 =?utf-8?B?a244TzR6bGs1cU16UTJndXRBWk5SWklrOWFFRUdSaExKNmF3OUJ5bGJ1bnk1?=
 =?utf-8?B?a3ZheTRUaVdPZEZnTmc3a2NnZHZZUEJyUHpFcWMvMnNUemU0cmdVUzNNVlNJ?=
 =?utf-8?B?dnJKbTUybDFYamUrVkEwUGIvNzI2V1JJMkxvTkNuekJYeTR3a3RsdnM5b2hH?=
 =?utf-8?B?b0pJMU1GWEZDNElqeFI2eTZPcTMySExwd1FDeHpsRHNybi9PbkRSaHVaQlN2?=
 =?utf-8?B?ejBIUmtEUkhYYWRlTzlWbmxBblpsZ0ZYNEs1a01iRmlRNkIyQ1BMUUFTSUxM?=
 =?utf-8?B?aXdVdHlsL2RyRG14ZGQ2QlBzcUFCYUVjdlEvMEtkYlV6Qi9HUEREeFF1cVlT?=
 =?utf-8?B?cVpPQ2ZVeVM0OFJiVUpLTUFvVk9tOUxoR0hSc2VNa2tYWXlZejN5bmVOSjA0?=
 =?utf-8?B?ZXl2R0ZjdzVjQXBHNWlEYVEyMTIxOUJMaTFRSks2VnlWVlJDeWxUWWxhdkJ2?=
 =?utf-8?B?Vmh3aWdTT1RhZFNxakw3VWtGOWlnZFJGbk02a1drZEpLRnJqRkY5NVZNdzV6?=
 =?utf-8?B?V1laT2NBV1hjb0c3OHRHT08zbXRmRjZ6MHg3NWNrL2NuVjcvbWwxay81S29Y?=
 =?utf-8?B?blNQZXhaVmR3OWpydXR4cVhCZ0FhNHpwQWhVNmgwV2dXbUNpa05SemJhNW9R?=
 =?utf-8?B?UTVtWkdJMno0ZHdmc2tXUk12bUE3VStRV29vazZQc3BhRUhmdmlabEw0Zmpm?=
 =?utf-8?B?VkZldDE1M3NvemRDT25qWm1rUGo5RFB2Z1FjekNvLzNTbGxzbW5TbDNoOWpK?=
 =?utf-8?B?cVZuVU1OVnl5NDhyY1dlbjNoOFQ4eDBUc0pTOWJ3V0JadGhBM2ZZQi9tOXhX?=
 =?utf-8?B?NjIxVjJRQWVIWU1jZzhQSEFQMmVic1dkd1BFSG53SzN0Nm5RZnRsUzNRVHkv?=
 =?utf-8?B?b3NxNXhvZmt3clFNaVFHVnpzNG1keGE2UkdnNXoyU2lKOUg1K0cyQmRSNmRl?=
 =?utf-8?B?cjZ4aU96Y0R0cGpEdSs5NWFiRlp3TkhxbkpGeC9KVzRjMkQ1cXlBMitXbjE0?=
 =?utf-8?B?RTErWmhPZTV0S0R0MFN1MmJvUW5Bam01L1M2cFl4SS8zSzd4ci9mSUdJb2lV?=
 =?utf-8?B?UldveVR6ZXM2U3R4ZXBQTy9hY0x6M2w0TGZQTXltL3F6d1Q4RnRReDRISzVk?=
 =?utf-8?B?Wkl2VWpYZVdQVVJLdU4zcjNtcVF6M2R6UHMvbWlZL1NwWGNmQXlIZ1ZaMktM?=
 =?utf-8?B?eUE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4ac2b4-51b1-488e-3c21-08daf6305e08
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 13:08:02.6556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfMimzN/w0HnQ3CWfZcT9cP3uj32qJ5YB5M5d8Ufs5kp57TownUcCl7jCNhgnUmTl8X1wTvU2fgQ82Jc+YIeatcf61yK8XBAqH4wBbT8zV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9369
X-Proofpoint-GUID: XNyQHEn2fglvliWummkeYODy-4nKc_hf
X-Proofpoint-ORIG-GUID: XNyQHEn2fglvliWummkeYODy-4nKc_hf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-14_05,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/01/23 3:14 am, Marc Zyngier wrote:
> On Sat, 07 Jan 2023 17:24:24 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>> On 26/12/22 3:37 pm, Marc Zyngier wrote:
>>> On Sun, 25 Dec 2022 16:50:04 +0000,
>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>
>>>> Hi Marc,
>>>> Hi Sean,
>>>>
>>>> Please let me know if there's any further question or feedback.
>>>
>>> My earlier comments still stand: the proposed API is not usable as a
>>> general purpose memory-tracking API because it counts faults instead
>>> of memory, making it inadequate except for the most trivial cases.
>>> And I cannot believe you were serious when you mentioned that you were
>>> happy to make that the API.
>>>
>>> This requires some serious work, and this series is not yet near a
>>> state where it could be merged.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
>> Hi Marc,
>>
>> IIUC, in the dirty ring interface too, the dirty_index variable is
>> incremented in the mark_page_dirty_in_slot function and it is also
>> count-based. At least on x86, I am aware that for dirty tracking we
>> have uniform granularity as huge pages (2MB pages) too are broken into
>> 4K pages and bitmap is at 4K-granularity. Please let me know if it is
>> possible to have multiple page sizes even during dirty logging on
>> ARM. And if that is the case, I am wondering how we handle the bitmap
>> with different page sizes on ARM.
> 
> Easy. It *is* page-size, by the very definition of the API which
> explicitly says that a single bit represent one basic page. If you
> were to only break 1GB mappings into 2MB blocks, you'd have to mask
> 512 pages dirty at once, no question asked.
> 
> Your API is different because at no point it implies any relationship
> with any page size. As it stands, it is a useless API. I understand
> that you are only concerned with your particular use case, but that's
> nowhere good enough. And it has nothing to do with ARM. This is
> equally broken on *any* architecture.
> 
>> I agree that the notion of pages dirtied according to our
>> pages_dirtied variable depends on how we are handling the bitmap but
>> we expect the userspace to use the same granularity at which the dirty
>> bitmap is handled. I can capture this in documentation
> 
> But what does the bitmap have to do with any of this? This is not what
> your API is about. You are supposed to count dirtied memory, and you
> are counting page faults instead. No sane userspace can make any sense
> of that. You keep coupling the two, but that's wrong. This thing has
> to be useful on its own, not just for your particular, super narrow
> use case. And that's a shame because the general idea of a dirty quota
> is an interesting one.
> 
> If your sole intention is to capture in the documentation that the API
> is broken, then all I can do is to NAK the whole thing. Until you turn
> this page-fault quota into the dirty memory quota that you advertise,
> I'll continue to say no to it.
> 
> Thanks,
> 
> 	M.
> 

Thank you Marc for the suggestion. We can make dirty quota count dirtied 
memory rather than faults.

run->dirty_quota -= page_size;

We can raise a kvm request for exiting to userspace as soon as the dirty 
quota of the vcpu becomes zero or negative. Please let me know if this 
looks good to you.

Thanks,
Shivam
