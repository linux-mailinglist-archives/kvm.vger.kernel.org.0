Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1A58512D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiG2N4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbiG2N4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:56:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434D76A496;
        Fri, 29 Jul 2022 06:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD4DszVNLvHneUxxXkHMXRdmXnsQFOdGgpPf3PlXSFN3h+2/6q7lXZsjVg/USl/H3iz8VZyG+YyZOrquSJAemYzm+Cm2nvxuzL8JVJmYsvydC/y3WEDtBi2DTElZqpX67QUTVIds6Tbn4vLYV0GOJm5LANyNvgHyMCqPs+YHJWxnpW6WDt/S+2ae1V3RsaExnk5+C9MNO2ydNYaOTo8o2a+IbbfrI5IUn0afuIdAuqfHyVS4OPqiX7E2ZmFtHmiFpnZvTzKnbNa6OP5i8RXrbUhOkx33i2y2Q5/Nxq4BdS/JQXzZ/U0g6fSdHzq3SGVbVNxmMhZcQLphQ/54kk0xvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gP9k7J2/SbTO7MobSG7eVB4DB1YYXnj0e2/kYGjSSsA=;
 b=JjNujmLL5VTs3h3c3KJS9hW9/SU5Z2NvQh4ukZTIcVpFBb3FHBeGYoN6CpqAQOtLLGlE/ZwcJjjfHWAcmhQkU/giybNJk5KHD4+dyVlwJsBz1OsrWl9of/ezzFS+F3ha7fwWg4An2gZBIw+PKdYFiTvCqzITrA9CoCiThaHhr0G7wPcMCHbaZ0tM4gHx7DHyt6lqvTSgxzE03eD+XEEBJAShYg+3p7hVh5LAbnsg4ITzYUwVuT5c6/aYGbs7XmRmKBD3cZ3Ioo8rl7fiie1wEkRwhRu/uIVKklEUdAkmpJlNLyjkWeYNyCh1E99OlHsNy/SLeJ89Sr63EscgAhsvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gP9k7J2/SbTO7MobSG7eVB4DB1YYXnj0e2/kYGjSSsA=;
 b=CKAjlaloG/lEleWsJqNMl/FqOlqmTFr803iT975RCAJ0m/L02zuPqW61qpHLrvM2t+qiwuKH0bWtZPVjbOciZ8h3VPXklna3O7WtA15mHwKFURHwToFDPQvoNndn/xHJ7kVF5/i86mO059eyWbp6XZcHkiDklvBziNS30uc4K6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by PH0PR12MB5434.namprd12.prod.outlook.com (2603:10b6:510:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 13:55:57 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 13:55:57 +0000
Message-ID: <b6030283-9d43-c3c3-9d58-4972cf7efb0d@amd.com>
Date:   Fri, 29 Jul 2022 19:25:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-6-santosh.shukla@amd.com> <Yth2eik6usFvC4vW@google.com>
 <23b43ea0-0a92-e132-ada3-ebe86dbaf673@amd.com> <YuPmRbBcUp931KMP@google.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <YuPmRbBcUp931KMP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::23) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e391233-77cc-4e6b-1c36-08da716a0f93
X-MS-TrafficTypeDiagnostic: PH0PR12MB5434:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +TE1BDpEQ0Hha3NTkMOuzZK96PhW7hikwX898hVmZKwWsFFX3TgLgGGt2+cZ/V8xIU/FpWksb5qsGYpv0FUZvv1EUQpmCQCRtVELIWuLVTK65VYQ1B0F95g8lSuCKiehQLh8QPQJeMupcKf8k7zC1BSzazVJqco1S0/HzCfvnemV8uI3aGtptHIrqk2Mruv0pRELbc6clAe4gfBy4RZHawlettOQqrKAOt1qff2hYUD0nPphGddH/g4A1nyTwQ696ArKd4SDlKnRfoNLLAmWLRK5k0ArtW7GOb4nRwc2Z2z3//Yjps/u10C2jTGWvsy7MNI/CoktCHPmr7CFm6YuRYkgZo4j871jmGiSQHrEY3c2jjjC3pu7Y6/XpHoTXnbIKymF6dpVohqrkMC7FAbZHRd7oQkYaLcEmx5vHavi1csMHpdNesq7ss9le0Iu+2VSLDWcdo6ikH1FilqJDn4LcNA+5xWSbh2ZsCLaVSPvF98UI9SidwW+XlDO9L1+GVG51Dswbc+E2SdSHC9fmyaDM3jc5E3Om+RrbCPJwRNDrNgQgpAxDsb+sUOJZ3tMpu8RbD1Ewv9J3e9LOYlXI+ovv7aPGvfWawrdfO537woTaxASyhgwRPy8A2e8SegYcSMmt+W6bzLqwCrqmPN5SdSRl2b4AgvDJXgnebv32DP1KE7G6on/dvur5nWYYA+U44WdCqDcBXxynDO4iDxgPylUxJ3YO3R8zajozpPTSFT9HlH+jqjVQPvmzMOzS8g4mOuGQKEYfHGRLE1CQC2Ui4H+kvCgk36oLO0wYdRQZIxJhS1Xfcu7qAnFVZpuGU8U0yqXfoAESNq/0R+WNSoKpNcNfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(53546011)(6506007)(6666004)(55236004)(41300700001)(2906002)(26005)(6512007)(38100700002)(2616005)(186003)(54906003)(6916009)(316002)(36756003)(8936002)(31696002)(86362001)(478600001)(6486002)(4326008)(66946007)(8676002)(66476007)(66556008)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdYSjhIMjBCZ0x4c1dsTlcxUzl3MWhMdlJNNW45U3Rkdzl0bmZXR1NDK0pL?=
 =?utf-8?B?TG5nSFZ3YmRoK2U4VWovM2s3MjU5aXhhUytWcnpqUU1YZWc1bG9scDlqVDF4?=
 =?utf-8?B?UFFOQ0ZWWm92RzROMXlYbERuNW1iUkd4aXFQUW5wM1BaSHRYMFpuRElIcGVm?=
 =?utf-8?B?czVsck9EOHJkOGR5VDd6d05hYWQyK0dYVGFYTU5jcm5nSDVHS2ttVEdJSXFv?=
 =?utf-8?B?eEVrN1dIdldsRW9IZVh1NkRoSUZwL3BuZXg3VmFGNlVnNGU1WGMwdWxDQm1G?=
 =?utf-8?B?bjk3WUhub21FQ3RjZyszSk1JbkMrWlk3NGFJK3dYamRXam1KNUNJQXJnZUtK?=
 =?utf-8?B?TWhyak5RU3NseWsrVVg4REsxdjJvNnBobUMxdDZZWklOc01nUVdXVGF5UDF2?=
 =?utf-8?B?QmtaWlF2eFFrOVlRQitNNnJPWVNsSmdjQTBzcnpaZndXOUxaNTIxUjBlUGxl?=
 =?utf-8?B?RUNEdElveGhtbVBVMFRmSWIrajBlN0l5RU9MN1FVTDZYRXJxbUFJQjBNSTQ2?=
 =?utf-8?B?N2ZwRFlnNnRhMER6UjU0ZkhhWUF1ZFpIck1HUFFxcEsvQ3drREVQYnV3QlM3?=
 =?utf-8?B?WEtGclhHZDdjb2p4dSt2SjRxNDQ0UHJLNThBcVg0Q0NOeTMzblU1MnBUQm53?=
 =?utf-8?B?Tk9kalBiRXF0MHZJUXZxbHlMQ3ZBUHVkMlNSK3pST0tESVpkbnM1b0xZODYy?=
 =?utf-8?B?OVJFZ2RsZEVua25HZkRVOWJCR1NkSUlXa0pUVDdNMVVOcmx4bWFMOVE1Q3ZT?=
 =?utf-8?B?S0NOMjUrcmIyNFVGTmU3MXpDaC9heC9NcHNyZFQ4SXVpS3p1LzBiR3EzT0l6?=
 =?utf-8?B?RFFYRFU3MlUrN2JJUytCUXdSaFpTSGRzd2hqVUQ1NFY2Z0prWUVkQ0FYeFNS?=
 =?utf-8?B?YnRUWFArQUd4T1VxTHBtSVR4TnUwNEF3TVdtV2NmL21tV1pNOGJXeGptVk82?=
 =?utf-8?B?UG1JUmhKeUJXY0NCY1ZqL2xZZmNOL3FuMTN5c1NiQnFPV21kTEF3ZEVXVE9o?=
 =?utf-8?B?cE5jbU5oZE9PU1prcTBwVWoxYzV1Y2ZmdFRLTkxhUHNPQlYwenhtWG55dS9H?=
 =?utf-8?B?d1NzVk8vMWVSbElBVjZyd3NQR0I5U0orMnpvbTBmNHR4S0JvZlRBaXg5TG8z?=
 =?utf-8?B?SFJvV2VRK1RFckFVZ1ZtRTUxVDNVSjdnK3k4NVNBYWZJa01qMWRFY1o1a3F3?=
 =?utf-8?B?TnZLV2Y5NTNOcjB0bzVNRmlsM0RKYVN2WFZFdUk0SkZLdGlkR1R6bmtjZitq?=
 =?utf-8?B?OTF2Ukc2WEdJcGhYdWVHZVRBRmR3L1phNFNQOTJwSWRkU21XQVhldnFLNkdo?=
 =?utf-8?B?a1IrcTA2b1hZMGl4cTdDcjJyVjJPWC9pWk01RjVKVUg1cWVEMndsUHIxaDFF?=
 =?utf-8?B?MTdYS0IzbmovM1R4aEpHOEtJREUzRmtxcFRxRVNwcVlPRjlUb1UvVWJMMlIy?=
 =?utf-8?B?aTN1ZE5UdWVXWGM3M3JGbUI1TW9tVGd3YjRCMUZUNXdDS2hRcWJPVmhsbWwy?=
 =?utf-8?B?MDBRbWRqV0JQTkZYYitndjlLaXA3SithM3dzdWNtZ2g1WGcyT2xrOVBhNk1w?=
 =?utf-8?B?aXZ6MGdaa0g2UXJQUy95V0JlNWlIWnFmL0FJWXNHR2VHUmNhMTZIditCQ2lY?=
 =?utf-8?B?RG0xeTdmSXJQMVZvcGdNaXJUTVkwRFlXRGMrU0RyWVY3ckZrb1FoclYyUXJh?=
 =?utf-8?B?QlRMTDZnNGYzb3J4WXNTOXpTbEVGeEEwMGlKWC9scFlvaE00cnNJUlFrLzJH?=
 =?utf-8?B?OVhwRGdoVzNTTHlWdnJWa256TlhpSlJEQlhTODVub1AyYitVRzJ3Q3ZEOS8v?=
 =?utf-8?B?TVd5SXEyRG5WY3pFQzhIZ0hmZDNNWC9ndFE1R05kODFmcFFpdzdKblpEYzNG?=
 =?utf-8?B?MmhGWlZTaVJuQTlnWlNWVnlDd0tBTEFDR09MMGgyRjV3UUZYYlJOZDU2TUts?=
 =?utf-8?B?bXlDWjZQYXJTMDVIYkpJYkZiMVJlMGtBcldkVzRUUXg2Um9QL3pIY1ZiZ0Mz?=
 =?utf-8?B?THVZVG9UMHl0Q1ZoUHhvTjdTOHVlZDNHeWVvakRoeTYrcGNLSk9kUGsyR0pS?=
 =?utf-8?B?TjEwK09JdHArdUtFRHY0dnBDNmpaSXc5WUhQOWY2T21xckZUVE9zZ2xuanBw?=
 =?utf-8?Q?mq1+vUWQvF4qWulHtebtGLdAm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e391233-77cc-4e6b-1c36-08da716a0f93
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:55:57.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcrchktFYrnsxzWj1/Ww++ucocP98UDfwo6AkCHMydWZLQ1tYgD1dGtHIqnYs5BtOH39ZcAcDzxwBUdBTeLuPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5434
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/29/2022 7:23 PM, Sean Christopherson wrote:
> On Fri, Jul 29, 2022, Shukla, Santosh wrote:
>> Hi Sean,
>>
>> On 7/21/2022 3:11 AM, Sean Christopherson wrote:
>>> On Sat, Jul 09, 2022, Santosh Shukla wrote:
>>>> +	++vcpu->stat.nmi_injections;
>>>> +	if (is_vnmi_enabled(svm)) {
>>>> +		vmcb = get_vnmi_vmcb(svm);
>>>> +		WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);
>>>
>>> Haven't read the spec, but based on the changelog I assume the flag doesn't get
>>> cleared until the NMI is fully delivered.  That means this WARN will fire if a
>>> VM-Exit occurs during delivery as KVM will re-inject the event, e.g. if KVM is
>>> using shadow paging and a #PF handle by KVM occurs during delivery.
>>>
>>
>> Right,.
>>
>>
>> For the above scenario i.e.. if VMEXIT happens during delivery of virtual NMI
>> then EXITINTINFO will be set accordingly and V_NMI_MASK is saved as 0.
>> hypervisor will re-inject event in next VMRUN.
>>
>> I just wanted to track above scenario,. I will replace it with pr_debug().
> 
> No, this is normal (albeit uncommon) behavior, don't print anything.  Even if it

Ok.

Thanks,
Santosh

> weren't normal behavior, pr_debug() is usually the wrong choice in KVM.
