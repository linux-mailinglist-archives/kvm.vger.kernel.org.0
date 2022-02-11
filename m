Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA124B1A23
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 01:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbiBKAKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 19:10:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiBKAKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 19:10:44 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E6E58;
        Thu, 10 Feb 2022 16:10:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daPU15teeBB88yXTFEkH82bGrCdQWYre2EBbocX89NwUeQguMwlWKRn4vNvo6/eetvAj1p6epzV+aNgQmVNkajiGywxcZ4vIy/4yI+MtOUefyFHUSD+1HDn5df4MJCqdLh+JmxtMZmGtzr+BrY0TKjRJ+YOo5DIF0/ZDdeJx/UOUjloOGwOk6+C5TUT7e6hEy99bM9MKp2hyM38DBbSs+c5tA/vVVX6Q1gwHvsOt79A5r4Uh4+fprrWby/yBkgrDcpvZYRo7oeP40HRrG9AkY7ks32RJSi4vqO727nNwnUSIYpIjsxk4Qjhd43mIGnX78/8UdEfvquqFU1hMdPIlOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9/R9VuUQkX2MytiYJmFuWWuY6N9mM1PeIAifIYfBIk=;
 b=R8K6l0DN6rRXI10MTRZYhKtLfJs4kOnrz3aTPNm5rvkR6+AtS7yLs0iq7TOtDvBOTIvLUxIWiPduV7Yr92SBT5IKK0Gp/7ehGn2TviLSabcnw5o1+dXRTD7Ew5vJQNVcw5Vdp0pJt6rAQeDgSPgV5ABIwBcmf/awqSwFTL8YFZNZ4Hb47oZQRY1Mkt4AQSJ/XWyzv1PaoD0CjZpkiWMRdbsWAp9mhBx7+pVc1IgckkLKop+IcqqYYP/XOSdQLCrH0FN16TN9kjYwhK8CKgvj3Y/KE61E4i/p/+RxtXQ9OOfZXvaEMq/D+MasjEWfiX5ma7gA43f2eJ/b7k/spq7vLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9/R9VuUQkX2MytiYJmFuWWuY6N9mM1PeIAifIYfBIk=;
 b=d2lLWGCY0rtQ+82wXx4Zj83/MT1e9pVVo30ctnZKCRCssLhCWa+jsvwn/com30YVfjEvD6b2dHeO4jnPZYNMtdM86tF++N+iR5s/uw+9kcRJ3VBfxanWur/X7EzXoSROz2B/f+q0Q+ocNKCTizw0P9KNVNkyI1u2TdSeXicUHDY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB2970.namprd12.prod.outlook.com (2603:10b6:5:3b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Fri, 11 Feb 2022 00:10:42 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::74f0:93a2:5654:588c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::74f0:93a2:5654:588c%5]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 00:10:42 +0000
Message-ID: <d30fef36-a1bd-af87-4ad6-9781ed62a407@amd.com>
Date:   Fri, 11 Feb 2022 07:10:30 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5] KVM: SVM: Allow AVIC support on system w/ physical
 APIC ID > 255
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        mlevitsk@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
References: <20220209152038.12303-1-suravee.suthikulpanit@amd.com>
 <YgP/3u2UjqzG4C/M@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YgP/3u2UjqzG4C/M@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0140.apcprd06.prod.outlook.com
 (2603:1096:1:1f::18) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b003f924-6448-4f66-ebd6-08d9ecf2f0db
X-MS-TrafficTypeDiagnostic: DM6PR12MB2970:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2970D8732E2B200F8BE92954F3309@DM6PR12MB2970.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IW8XA+CCyCGrFxbO+jNWMtfZbtiJNnfVNUi60jVEXCybD+fl56RzYF+4UjK4V6Afdcb8fXSfv1mCIskW1nQuyxNJu+X3LKgtro/VPXp+VfTwL0PCv3VwFwSCZEGCcpdXgBR04iGDxTPkWSbfwEE1gKx1uBzrf1KPcZlGgA+bz7p4catkQNIKdDI3DG/+XxX58THMpjnqDKH/H8IdXx0d7vU8wuUl3cXh9LeE3/EMgnagAGuFWKR30XhBKiXJTHJLUVDLE0WAQlXqg6ybhh3S5GfAPJWPBxQMTntzC0gLnK1BcS0vDHY0UVzTI+UDsIGel4Ei0mARE/GIg4+9ye42zm9wF1190X4Nl3/HrNhguKF62fIj5UdyNthNpYliFftoF8NRezEZjveJgv9cICEhFvQN3V3rQ7CaD1mPhR4UD5Pbi1jwFpODtWdApStEm6v/PJuB1+TF6aumBbJdO8vlfyj71Io0qIXdWbnBe/fiV2TngKhazF5RaVhvWo95TgylA36LU7+7RBCykaAdSOgCMKYaSP8hjACxgyDo5Cmd5wVdr0o5JdW5xCKUHv9brdMf0ruuj01lCeo40xX/UsDkB/V/kSXyovS1I6xqqeUm6NH8TI5DHcoOP2yiq+DUxYlJFSbF/YUZRuC8hpUFY1p+gM5wVY6sAYxLMishgpqWz3OY4Cq+1/VtDzlveL1/K1VKNZAPiPHXt+wEgGBarNB77j5DezivQmqfzfbxGa3I08I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(186003)(2616005)(26005)(36756003)(6506007)(83380400001)(38100700002)(6916009)(53546011)(6512007)(5660300002)(6666004)(6486002)(508600001)(4326008)(66476007)(8676002)(8936002)(66556008)(66946007)(86362001)(316002)(31686004)(7416002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXlFRzZia0F3TWh4Q3MyMmtPQzcwb0h0R0p2YW1CTjRxcVVwWUFGdDZsSDBM?=
 =?utf-8?B?Y2tpeDQ2S1dKMFRqOVk2ZXNDa3krOUNDZjEwWHJQYjg0UytDMG4xeTlGOVJ0?=
 =?utf-8?B?UFpWOGpWd2FKeTkxTXFRWG9OU1dXZWljeUJyaFJ3TTFibjZmb0tNL1dTZ1FQ?=
 =?utf-8?B?VWFjVnVVU1ljYkVmVGxLWVNXbzUzMEJmYzdXT3RIaGQvRTEzdFdQNVFPMDdT?=
 =?utf-8?B?VXBER285Y2hRLzlHNXVmZ0FXbGdOKzk5UmZPbnJHZnNoa0FFZDNRdEJuSHJM?=
 =?utf-8?B?eVBudW5wTjcvVG5SS3RBdkVGZlpETW4rQ3JOYXRWU2hac0ROL2dQU3o5ZG5z?=
 =?utf-8?B?aEpnaXRuYXl3QkxuOWMvNzB0blpiQWJjRXYxWW85YnAzelJhN3FacDRWdUM3?=
 =?utf-8?B?U3dQaDB3RTQvZFV4bWJudk5LRkJXZ0RGSm5qYTVXdDRqd0svOWcxMkFTZnhi?=
 =?utf-8?B?dktkbkZIVHpIVUtrK2g2Q1NuWFo4VmY4UjVWbUFhUCtsZXE3NUVrZ0pMVWZV?=
 =?utf-8?B?UVE0WjdFbDd1b2RZdFA3bi9Ya2RScnRKT0NIaU85UHNDd1h2QjZhaGFCVTJi?=
 =?utf-8?B?T3BkOFhmaE9QRC9WVTRsYzVMeGR4VTRhaEJTL3pvZGpvaHhMMjFjZ21Dbk1p?=
 =?utf-8?B?dTJQMDUwcTVtcVlCaTAraFp0R2VENnNnSVFnUktSOGZGTFIwOFQ2aW9EVGZO?=
 =?utf-8?B?MERYczM1VDBVaTQrUWxNOTZxamhaU1J6SnlPL3VOTG1VWSs3K3VOOHNmOFJX?=
 =?utf-8?B?c2JkajY5MnhGdHBkQmlXV1pFdXA3dGpscG9PMHB1OENOeDJjaXlleGVNMTBn?=
 =?utf-8?B?aUlnc2Y2WTAycFBaOVA1cjF6RHdTaForV2dXSEYzTWFMMWx5bmlSMjl0Tmsw?=
 =?utf-8?B?K3VEbnF4QlMwYnMrMGNjWU40VldqNmZCS3JEVmFvQkVlS2pjdHB6ZDAvcHow?=
 =?utf-8?B?eU5USGVBSWFjZ2JPZFBjSm9NYVdGVU12KzhWQmloUk1CVUpVSmlvbCt5T2hp?=
 =?utf-8?B?THM1TGRyeldDeHhaZDI4RXIxNFRCb0VRV2lzQk0zUmdkcmF0OCs0c2lJL2pP?=
 =?utf-8?B?Qis4QVZZbDEzc1pjb0EraS81KzcyUzkwNXhZVVdkMU5YMWZFQXpvVWk0c0x5?=
 =?utf-8?B?aDZxZ05xU1I4U2ZmZk50ZFJjYzMwZGl1U24yeTJQQmpDdDUxMzh0cW5odGZL?=
 =?utf-8?B?akdYWjFyVkxLdS81R2FkU0VKRlMrTTAxOXJ3Nzc5TDYrMHBLRDA3bmZhcXpy?=
 =?utf-8?B?SWgraDVSSzUvZ1d2MmxHV001M3NEeVUrNlp2dlZxTENQUkNXS0FqMjRIdmtD?=
 =?utf-8?B?b0x0Z2QvYzAxeHluS25jdFV4VDA2bVVSbjJWMzg3YnpaMEljR1JUbTVKbkR1?=
 =?utf-8?B?cFhNSkZ0d09mUkgzMVB0NkhQU01UaHhtTkx3ZlFDUUNiUmorWE1mZDNLQkhF?=
 =?utf-8?B?OEpVcU90SEYwenFEZXRRTXhzVTNzRS9JbnhabmkyNFAvWFVla2YxM0hhWE9o?=
 =?utf-8?B?dVluN0hLR1RlQTFTSHVWQUYrSElUMkpoYk5KNWdZTjZTMWc5K2VnV2U2MkJQ?=
 =?utf-8?B?MzFvc3pLWHRjODU5ejNGTXFUNjRhRkptSXhZNFhOOUVTN2t4UzJWTFdQcjZt?=
 =?utf-8?B?dW4xWlBGZVd6YUdSTjBuLzZPejAzQjk5U090ZWREVkI0ejNRWE5UdU1oZll4?=
 =?utf-8?B?ak9oQ1IzYjlJZGlGSmxHU0Y2NkFFSGxMeitHRm1kdGJXNlh1aTBZZDlyYUJn?=
 =?utf-8?B?ZHI1RnFkSmpNeU5XZDFTbEM1VXpxcEZHZHdyY091ZTVQUERLN0F0Z05rRXg2?=
 =?utf-8?B?RGhMNWV4SVJWRVgrellXMXhBTHJvd053eW9WdVlTTW9xdzN6SENxNHlIVzhi?=
 =?utf-8?B?RmcxODJlY0h6UWVoNmR1a005dDdTVWtZWkRHc0VwcHlZQ2JJd1QwVWRSNkNM?=
 =?utf-8?B?aEt2U3U0SUdJTnFFdmNhQnVZRi83RWxlNEZXS1hicHJJMG9sKzUyNGRJOWVZ?=
 =?utf-8?B?N1JSYjloSlczcFBtRng1S0twdjlHVVJobldYVGMxUXRDdGptSDVtcEh1TmNH?=
 =?utf-8?B?TkppcVFITTRueFR6Q2Y0clRMUHJjZW5zMnhBd3V0T05pdEhOSi8vL0Eyc3E0?=
 =?utf-8?B?alJET1M1dVh5NzhnZHAvR0JwVGNxMVZHZ0dOdjVqWkU4dXN2TmovQjJWNC9o?=
 =?utf-8?Q?CE77U4E8gC8KYm4XN2t21BE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b003f924-6448-4f66-ebd6-08d9ecf2f0db
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 00:10:42.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+0STNSSgHZHrFH6VWKpccdXvSuEIgrNexNqXfd7rCxmFywhS7vnIjkp8lg+7rS28ETSAZa9121dEltPCEQodA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2970
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/10/2022 12:54 AM, Sean Christopherson wrote:
> E.g.
> 
>    Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
>    by the architecture.  The number of bits consumed by hardware is model
>    specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
>    to enumerate the "true" size.  So, KVM must allow using all bits, else it
>    risks rejecting completely legal x2APIC IDs on newer CPUs.
>   
>    This means KVM relies on hardware to not assign x2APIC IDs that exceed the
>    "true" width of the field, but presmuably hardware is smart enough to tie
>    the width to the max x2APIC ID.  KVM also relies on hardware to support at
>    least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
>    assumptions are unavoidable due to the lack of any way to enumerate the
>    "true" width.
> 
>    Note, older versions of the APM state that bits 11:8 are reserved for
>    legacy xAPIC, but consumed for x2APIC.  Revision 3.38 corrected this to
>    state that bits 11:8 are "should be zero" on older hardware.

This last paragraph is incorrect. The APM revision 3.38 and prior states

Reserved/SBZ for legacy APIC; extension of Host Physical APIC ID when
x2APIC is enabled.

Here, "SBZ" means Should Be Zero.

Therefore, I will remove the last paragraph in V6.

Suravee
