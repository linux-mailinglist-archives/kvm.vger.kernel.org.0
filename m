Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3FB4CFF6E
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 14:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238572AbiCGNDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 08:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiCGNDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 08:03:33 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2041.outbound.protection.outlook.com [40.107.96.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C027CF2;
        Mon,  7 Mar 2022 05:02:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAooKV+D2wzGMRQXq2kuNwU+HmW+ZPl38dgEVMPLBmPsPcMFGZmofltNdtaQetXNP3Jh9uDZMuCJ3BTicm8nCcFTZn5oThRVZnrHYGNWTliunEEMtrHsMnpR56UyU3MGsR+yQhbfO3XjB5JycFCv2hP0Zz98glLc9BOJ+w1SiDyssk0Bnlahw4BlNJK7jlPoeEAYyjPGVIJYIZPwBuJJ04i/cFph69gRN7XgHLkCpMXoXQAILHS8IAjlSp1r2Rl0eVQgzZVeqEmX8Bdsd87pQyLTQfzWKkJWPE8Qdi15nRUfc087NOtVJM2g1y/fpjLlp5vI3rhoeY5Xd4r7KYA2Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1MTIfgqWOY2sV2RMcaPvqk32JUKm8dgrz/NNd/2+WM=;
 b=PbwqdXYv4C8N8oHUCTCOq+oSo3NUNYk818Lv09mchNSwoS2iPvToLpszpWy+iJ5/i2Cx6Wl6+y8I4KXSrJ5FjWfQT5IMxewrjDl1lV+JhtjQUpmIVac48LdrZs+RwatVCJAMBdsttCiGo3ZVde5szfvu2qK3gMVBjnxtZOjZ0e7VoLDdNSS0ogmdBNlPfHm47djc3EaZ0u+JJwMxPKv6/7ePuhkt/EFHWX4OnxbwwypHuj6fqcdi+tbkC7M0H/UF1ZWJFfxCCB4rVocXgv5J+etsFLL82jCSUcsh7TKYQVvXfHTyD379EaR3UyK8oiTAUPPocTUFZSJ9orgqRrJgBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1MTIfgqWOY2sV2RMcaPvqk32JUKm8dgrz/NNd/2+WM=;
 b=hXEqB4CoFzjoVxzLo1vOEih+/HtFrZyvMku+ns2v304+trzNuMRjct2gZd61D6FJYqYVg/fdn/3UP5msNAL0raegldDBkJy8dA+kQ2Ur0VlPV++BdfIwpGra0bP89x7mOzXTvYyfOe5+KgQ9E5LjwlEbGH+2f9x9fCCAgEoVXDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 13:02:36 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::83f:7a86:6caf:f6ab]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::83f:7a86:6caf:f6ab%4]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 13:02:35 +0000
Message-ID: <adbd9285-d6a0-3112-2ba2-cf33fdf39bae@amd.com>
Date:   Mon, 7 Mar 2022 18:32:19 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 0/6] KVM: SVM: Defer page pinning for SEV guests
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <YiUUcuEuWbQrPs2E@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YiUUcuEuWbQrPs2E@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::25) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 876812f6-eb22-4b0d-e5a2-08da003abfb9
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB432298E0B1DE634A23A31BFEE2089@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbzJmQpX0WG1HDdzfXWTFzUuo8P5sEKL+JRTFknb+tcPsY3GHXRGh5UoyuKf5AA0PhgKgz1TXHLg6x+lGMfssRYTTJfCArlnXfjEZjcmnYhwHJd+xtl479gze195au8WMn9pGV+1txQFAyAJCdYUhPnftO6js7/GrXVefokQMTQTGIuhT9kO3MWzcFlay/dnHXV54DcP8PTxCkO4yhyE7h+6kUyfaBVgd4JJcbt0grZUiQfG2j0YOniOWnPVw3aQaUDfVX5pqDJr/uT1VyfV9OPbJVVOGHz6FevPtUpTbxa+ADif6wgAeyvSwKgDK8cAQb3EXVfaPwxjV4Ktzbr0pzMb/hON6I8E5F3ZKvg+zNmAU9ZcKdyaRT7gVB94BVpVtTNLFTYXe5A0u57jTSOvqz/qQpZprrFktsFTQ6p0Au6sybHA88khlxN/ad1mEx/bu0kEC8KcsfnSlLxXs/Dy2PRq07UWqzidopa8ExxX+3wz7Pp0LCOzdDg4uBwJsJmbINdn8X2qEWZFFcr+A9uFmHkvksF+MfVZcbCPpzEJPJT2vYxhL160AbkD9ak4BXEnKY0ox6lOIWRUmghN+ElwMc+ddIml+uJyl4jnVaSgZAzDDpgGOP10Gr7jQILwxlLLjQpAqGSAy0kjX4NUcTFa1/z3eKXae/IsOo4hHJnkYjRj5zjrUbF26OL09C8J+qb1M60gdmYjJXMysuLDxBVO95Rof1QPQX5kzlvdcaOy8Nr/yBj+4+FJ0Zi9hGh6S3gTBkJ2qxAILrQRceFTmUl/YLeEJAFu3H7AMMVfWhJ2eDafJZiXV6ihzMONFtpkswtJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(2906002)(66476007)(66946007)(66556008)(8676002)(508600001)(4326008)(7416002)(36756003)(8936002)(6486002)(6512007)(966005)(38100700002)(6506007)(53546011)(26005)(31686004)(186003)(6916009)(54906003)(31696002)(83380400001)(316002)(5660300002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1RiK0NvOXdMbmp1TmwyMThQUS9KbnRuanB2V2JrN0lUa0VNMEdmSmJtdE5P?=
 =?utf-8?B?TWZDa09Za2hmQmhzU2RGcW5sVmRZMnorU0Y1SmN5enIvVkppQVR6d09qbVFk?=
 =?utf-8?B?WUVJZHhldlVIa3VndzF4SU5wdXJHZ0JpanBsREpoWVBLYTV5SGtpa282TmlH?=
 =?utf-8?B?UGRtSjZJR0JkUTV3azdyUi9OSG9BRjBlZDNNbGZpbkIyS2xhbnZlMzYveUtX?=
 =?utf-8?B?akI0c3ZGZjVOdUdvZ2o1YWxLaTJDZTBmVXBQUnZSaVczV20zUW1HdGFCekJr?=
 =?utf-8?B?enE0TC93cUVKRTlYNHlYMmZQdy83eWw1RE9tWitVMXNpWEtVWFZvc0R0TWYx?=
 =?utf-8?B?UXE1U0ttdU5JYUhtSWZyeUJDZXBiYmYrejJrUU4zVDNWcGN2WldXMHRON0FY?=
 =?utf-8?B?RXQ4bTlLMVdPRldTNER1enZnZnllbjNDU3ZOelUyZkY4WlRSaTcwOTE1c2R0?=
 =?utf-8?B?OGtoRXBlQUR6WnZYbGxydlpQVWFuYzJIeXFGMzZ5a0FxcncwOVA4N09RVDBB?=
 =?utf-8?B?eVBTNnhEMHRnYUNFR1d4cDZyTW5xTEUxalh1aERHMlZjS2lGT1VTZjhlVWF1?=
 =?utf-8?B?aXZYMVBTZ2o4aWM3TmtGQW9DeUpDcXZMVmdRd1hlcjI5MGpQTHRsWEZ4cjk0?=
 =?utf-8?B?dFI5NjRTNkFaRldNbEt3R1VBN3R6cnhwaURWdGNtSTVaOEp0K08yQVhoQUtq?=
 =?utf-8?B?L1JPSXR6R1JLd3cwTG1CdU02dVgxWllQYzRTL0F1U3BXc2hIK00wRzEyODl2?=
 =?utf-8?B?NTNhUjNNcG52MWE1SXRSVnk2TGJmOUFjU09JWnFRd2tENGxpZkVmZEpmN0p6?=
 =?utf-8?B?blNoYm9TS3hrOW5POGYwbXlIR0MzY3kyTTg2U2QrR0wwOWc3VDkvdUpYZFBT?=
 =?utf-8?B?dDJ1eDNtL0d2bytoaythQkRjcjVuT2pSY2EyV2dEMTdSSUdRbmdwN0pKUXBk?=
 =?utf-8?B?VCtKREtlbXNncG5ZR3hxYktDbzNwN00rcEFUQ09mN0E4YzU4eFBrWG8xM3pS?=
 =?utf-8?B?VlBscUw3WEpWeDY0cFZTZndzcmF3N2MvaVBpTmpOaGZqa0FoU2ltcVNOdVFK?=
 =?utf-8?B?YndwT1dUQnAzL201ZEhtZE9ENnRERDBiVE5KQ0RqOUhrc1pXTTd1cEZBS3Ax?=
 =?utf-8?B?YmRMUWJMbGJpc2R3Yy93Q2drdlhDSWFpQ0RGKy9WdUh5NHFURk0zSEpkNkN3?=
 =?utf-8?B?NDdBRTVGU0x1NStpNGdVM2crbVIzdWVVSFJlVEVHQjlzSkl0dThFVnBXNDc4?=
 =?utf-8?B?Q3Frek9sS3A1UkpYQUw3L1NmQ0l1TkUzcmlaeUJ4U3dPUkswVU5DMy9WQitl?=
 =?utf-8?B?V1RSVFpWRm9CNERRRGd0LzMwQjJQeTJYTzZMb2ExakZuVFB0cWR3THdFZVcv?=
 =?utf-8?B?cHRRWHA3NkZBN01hWU95cjAvdDVRdDUweXFzcXJkUnRSNWg3ZWRpRURiRXJG?=
 =?utf-8?B?ZTNVVUJ3d3B0MDl1ZlJxQkN4QzJoMHA1UDliS0VzdHc1MzNJc2hXOWdYMmh6?=
 =?utf-8?B?bTBCdjFBeVdtUVlWSUcvTGljSDJjQ29YQy93ckliMUpRT1FWZDN0WEdjMkFa?=
 =?utf-8?B?aDdxYUl6RXkyTnJVd0kvanZoZjFZR2NSNG8vUE1TMFVVTDF2ZWN1RmpIS0tR?=
 =?utf-8?B?TUxRSjdYVWI1NmZ2MXpXQ3M2d2o5N1BHK3VkT09jVU40aFNpTkVvU1NZNG1l?=
 =?utf-8?B?Wk11dWU4c0xnenVWREFYK1MrbCt5QlZWZmdzb2p4V2U3a2UyMk1aVnhKb2M5?=
 =?utf-8?B?VGd3eFlmbk5BeWlCNUxXTEJINjdieHpPRlJHT29HbktnZEpkNkVsVGw1dXcx?=
 =?utf-8?B?cTlSL0ZJK2xsVEU2M3liMDlXaDNJNHFXREF0NUlLWnpGNzJzd3l3S3hkN08y?=
 =?utf-8?B?TExORUhXNkRzVHoxa2gvYWY1ckpSVXJUcXhPN2tZTE9yUkRhSVNtazRjalJh?=
 =?utf-8?B?cG0zclpZTFVtby9RUk54SGdpV3BWeUl0ZUthM0duVnV5VTMwUUhSRWRSMWt0?=
 =?utf-8?B?WnhHL0RPaEhoOFpEQzVZY0JvVFgzS0tFNXE5Slo0dG1zeFAzMnU2YlduSVN3?=
 =?utf-8?B?RXVmTUg5cnA1MjIrY1oxQkYzcVFmRTIrRkNSRy8xR1ZmWDB3VDFMblpnWFBP?=
 =?utf-8?B?Rk4xbVZVcHM0WVBtNFdVdDcxbWRlanV0R2hoK2toZU9rU0htK1JKcldYa1ZG?=
 =?utf-8?Q?ui2j+VIl69e3BohwViS4tv0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 876812f6-eb22-4b0d-e5a2-08da003abfb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 13:02:35.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+TKEUxyWVaxX+lcLfrh1Wpuhg3hcIs5DVpb6PAmGfGvGfKXH7pvUTduNmFp+K2+xg1mvaz7UjGymZzjIgtP9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/2022 1:37 AM, Mingwei Zhang wrote:
> On Tue, Jan 18, 2022, Nikunj A Dadhania wrote:
>> SEV guest requires the guest's pages to be pinned in host physical
>> memory as migration of encrypted pages is not supported. The memory
>> encryption scheme uses the physical address of the memory being
>> encrypted. If guest pages are moved by the host, content decrypted in
>> the guest would be incorrect thereby corrupting guest's memory.
>>
>> For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
>> encrypted and when the guest is done using those pages. Hypervisor
>> should treat all the guest pages as encrypted until the guest is
>> destroyed.
> "Hypervisor should treat all the guest pages as encrypted until they are
> deallocated or the guest is destroyed".
> 
> Note: in general, the guest VM could ask the user-level VMM to free the
> page by either free the memslot or free the pages (munmap(2)).
> 

Sure, will update

>>
>> Actual pinning management is handled by vendor code via new
>> kvm_x86_ops hooks. MMU calls in to vendor code to pin the page on
>> demand. Metadata of the pinning is stored in architecture specific
>> memslot area. During the memslot freeing path guest pages are
>> unpinned.
> 
> "During the memslot freeing path and deallocation path"

Sure.

> 
>>
>> Initially started with [1], where the idea was to store the pinning
>> information using the software bit in the SPTE to track the pinned
>> page. That is not feasible for the following reason:
>>
>> The pinned SPTE information gets stored in the shadow pages(SP). The
>> way current MMU is designed, the full MMU context gets dropped
>> multiple number of times even when CR0.WP bit gets flipped. Due to
>> dropping of the MMU context (aka roots), there is a huge amount of SP
>> alloc/remove churn. Pinned information stored in the SP gets lost
>> during the dropping of the root and subsequent SP at the child levels.
>> Without this information making decisions about re-pinnning page or
>> unpinning during the guest shutdown will not be possible
>>
>> [1] https://patchwork.kernel.org/project/kvm/cover/20200731212323.21746-1-sean.j.christopherson@intel.com/ 
>>
> 
> A general feedback: I really like this patch set and I think doing
> memory pinning at fault path in kernel and storing the metadata in
> memslot is the right thing to do.
> 
> This basically solves all the problems triggered by the KVM based API
> that trusts the user-level VMM to do the memory pinning.
> 
Thanks for the feedback.

Regards
Nikunj
