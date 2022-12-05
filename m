Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB5642BA2
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiLEP0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiLEP0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:26:03 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83391209A;
        Mon,  5 Dec 2022 07:23:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUPiCQXR7OEAbRxp1cg4Co/bGi9Qby54PRnAK+AaY52hbVmQjrw93qsDkrWsrkiIJoyWK/fmVVxjT5XOlNXnEca0ChKKvwqZOZPruSHAfaZIWIIl42DhIk+tsNst8Ta79uNmZ2nvgO5/Mwe/+Yxg/OYMX5Bov9n7jtNXN21id+l08tYcyaIOVDyYrYTlawEg/2wxsueLcYqcPEsN7HSuyHp/2q1hykLpOPgeSw4N/eQ9U9aSl4x+gJ/RyxAKZmlVwXs9Y9N6oDxa7S9v24sDFyYaEMY/CgjbiI2zZ5KZ2SO2CPAakNBmr+FQR+TRLAnSfOsL3I1PyxJZzBLDzItAXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPOS/W3JZC0L+ViDiUz/8FapJqA1vexKnuQoirUHiaI=;
 b=fhIRkBqlTMD0OCJXZ3lIqC1YLLMe9EgYn7KJPFQPv/J1HnNxTtHWlDthsxvHQAD7W9t4mZ48n7mbPd+jW8oe30z1fMNq+cYxzAnAV81DAUpMPJsV3Z8sM/0Yt1fjEiRGZTDnN17pyeze+YW1eNMAC3zGAk6JWT1+ASP4iwYN43VIZ1BLsKhl/ZmA89/I7p7NeED5FC1Z+qARTcM3VbYmFDv1YvA22c1ALT+EwdUgYQrhLcI9uXVn4ixqsXE/1E7KgaTR1yn49GO68QbSysEqmbmjj2sMKTQ9hNrCR+Y6PXFqbV7CP5xP4Wgn2l7l+Wf/1bvgL6ifesaIY0C4ecsCIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPOS/W3JZC0L+ViDiUz/8FapJqA1vexKnuQoirUHiaI=;
 b=NisiyGMlriioj2rbcSXvehJLqKuxjeLYPeMlJAwiNn0NMzRuh0VHRPFTXOhmwPgP/jWbZPLyVWl/vt446wohKPk+zRVNe2FQ3fHUGKjG2g6cUvzHXf2ndCzLqsC9168RZIOraWGc0s6BfHfUZsiYUkfdG2TDGbVXkqKoUcfktVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CO6PR12MB5492.namprd12.prod.outlook.com (2603:10b6:5:35d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 15:23:20 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 15:23:20 +0000
Message-ID: <896d1b00-1602-2a0f-b50c-0582d5219039@amd.com>
Date:   Mon, 5 Dec 2022 09:23:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Borislav Petkov <bp@alien8.de>, Nikunj A Dadhania <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        stable@kernel.org
References: <20221201100423.7117-1-nikunj@amd.com> <Y44Amf9MJIIi4Ric@zn.tnic>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Y44Amf9MJIIi4Ric@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CO6PR12MB5492:EE_
X-MS-Office365-Filtering-Correlation-Id: a67232bb-a0f6-4c8f-a967-08dad6d4a456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgH5D54BSA2AiAy6bnvK+xNIfqk+6157S/jfbdQoDkLFSMhLkHHV+QLY4VPJ34Sa9ZqaIroS0cKhygLTlE/s+mR0aukC+TkZnJugJ3hC3yXDn2hc+1Lue9BeNttV4OZCeRILJDmGlxmivgL+03Tb9F4c46x34VYK5gGxmONAvIB/8CKT9Vvs/JJ2JuAG137DHSJIeAZxUhCfXfBnWuJFMfLxOAAbYPXFHfdc97K03bAKVHHJf3yQT/E+jt54noTQkxlqye0odkHQXwISG8HNBnqihcZ1O8utrR3NtO4cuqnH5ijmgo5lDtAkm9vN5AGTb8OCl/Flx5uel2NpnheYCtNb91LPgNW6R2/qWzxSfmN5QX6wPwvOOICuHJ95F2kh++1v4P1/Q8M7YwktWz/tI44dzpuIHUej1aTh8Q3YY5gcW4XSbP1ZLE0Ks3FuhDSMbiSawDWhDMDzY/9UI+fO03986gHA7tVz3wSPkC1CbkllpcrqhPC9LT2ro5xZaP1dY/8DIH8whquC8tAMMkTJmeK1FPEH3kSCN/AmdUPnGPQUe769Dy8DANnCuH5KSwr64KtBCgISaGKwsHFAT5RYiBa/wMhzYvv8WwynzZ+Z6oGPdIGqlWz7kR8BUnjbJNPphEckpr6G5G4yopbLcH8yyAAjrVcd040FIlqvQfFsWFkymEJ0lcT1a2GAcDtg9UFFFY5XrvArILLs16hgvhO0yry5HNi8D1xaENxpqLiY/hs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(83380400001)(31686004)(2906002)(41300700001)(7416002)(186003)(5660300002)(8936002)(6666004)(478600001)(4326008)(6486002)(2616005)(66556008)(66476007)(66946007)(8676002)(38100700002)(36756003)(316002)(6512007)(6636002)(110136005)(26005)(53546011)(31696002)(86362001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXBGMlJlSUg4RzNuT2RZV1U2aGZRWGJxMDVmN1ZwTnZYOGpEMWxNcDlEclFa?=
 =?utf-8?B?d1N0dWtjUzZreEwxOTFZa09GaGVHczlESnl6MDI4Y2dRSnA5eUFYYXkzTjR3?=
 =?utf-8?B?UU9pcGNPVnkwYkpKZUREbStqb2FYbW5Lc3dTcXRRMnE5TVlHV1FDRHpGY2dT?=
 =?utf-8?B?NGNCdTJ3MzZJUE9nNXIzKzF4Yzl0cDhZSjBHb0o5TDhoNkNITVdkYk5SNEhM?=
 =?utf-8?B?RFd6MkdWTmV4ZFg5ZzJxQlRhVjZ1ZDZhMUZNTTM1enpMVWt5WDNzWmNuR09K?=
 =?utf-8?B?WmlkRm1VVUxKdUVZbkl2UHRVYWh1UzdOMVYzWVVIYUFuOUl6bnpPTWI4bi9n?=
 =?utf-8?B?RWIrdjJhTWNMWXNDdmZlYmNkTEJxbDZBTmxLNzZPbzBNR3ZSdHJJR2RhVE9m?=
 =?utf-8?B?Q0JxSTJxbWVkKzBPMTRSem91bk4zakNFNmxLdXNkb3dTL0dJVHd4Uit5aDV5?=
 =?utf-8?B?SENrNHpnM2RIbWZhTXplS3FPVkJxZS9LdFJ4WWpjTHpYcWRnL01nSlpHMDJS?=
 =?utf-8?B?WDFNM2dlM091WThjT1kzUnpwaDcyajdrNEJPbTU0UWpLUzVIK0tIOStxYk1W?=
 =?utf-8?B?d1Erd2x5S2pRNmt4ZjZTY1ZzNUpid3RlOC9OZ05oT3BRZFcxQ1ZzOUh6YWZz?=
 =?utf-8?B?SEY2cFBtRUFCL2dKSFZqcnVtbEYyM0dzTFBRdHQrUVJPeXlFL3RkTWFqeVYv?=
 =?utf-8?B?eXd3UXF4TVhVNElEQVRUWXRRUVkzYVc1S20zT2pCaENhL1BudlpML1lTb1dP?=
 =?utf-8?B?Y0UvcEI3UUlTajd3RnRLRjQ1OXZ6SmMrSlN2VVB4amVJN2t1SkI0ZE1YOUVT?=
 =?utf-8?B?TDlDNk16QmpGWDY1VlFDN09GejlJbzYrNEpaYWxLcXlsVmZuY21iV3BOWGht?=
 =?utf-8?B?dlhmWHhsMEhjd1RRbmYrRXZsWW8vazA1Z3daT21TRVAyRzl2ODdybGhkNENi?=
 =?utf-8?B?MjVvbThwT1gxZlVDMk56S2dwM1pGQlY5ODUwMktZR3o3aGtYOFVEazQ5THRV?=
 =?utf-8?B?blppOVhSZ2ZnVXFvSjVHcGprQWJkSjJEb0lEWm1Oa25oSVZ5ODBxYXlDZXpW?=
 =?utf-8?B?SzFzY2c2ZEhaemQrdklnZnpadGZIRzF5aHJGOVlNUTFzK2ZjTnl1QVRxY2xU?=
 =?utf-8?B?dU5PTG1Bd1hrVFBDNjZLM2h1bnpPd0F3TWxFYThjQXlsWEhrRU1hRVI4UTl1?=
 =?utf-8?B?dEZsaUVzbVNhMVB4RmNTbVNXYmtXTFc3bHJoaWlibXFkb1NBVlhrUXRxNXJY?=
 =?utf-8?B?ZkhvclhnSG9qbFQ4cnlLbU5tanl6TUdkRU9mV25oTEo5Y1k0VjYxNGlGNisv?=
 =?utf-8?B?b3NhdWVXWmlDOUhBSXp3eTNwTHBlbnE3VnkwMUFmMEZ3djNNSTZQR0NIL0sy?=
 =?utf-8?B?bGtmYkNJMXF2U1Y4ckpwclhZRElrVFBUcG5xZXVCY0R5WU9oRnFkYTRVN3FL?=
 =?utf-8?B?Wnp1eUl4TzZYcC80Y2dzWjVDeDJicUVKT01GRVdEOVZtS2Mzck5uR28xaWI0?=
 =?utf-8?B?cExXd1NzSTFENytxT0dPbzZTNzR4YkdrSzV6ZUZkT3RRUlR0QnpqNGpPbDZM?=
 =?utf-8?B?YUYvbzl0N0oxNGFPTUl1R2VUTEJGQUcvMVVXV3pkbmNwVkgvWnB5aWk4UzBJ?=
 =?utf-8?B?UEc1THk0MzJNbUQxT0NvVjZteEVtd0NVTVVkeDYxY2xyZ0JFMlhyYnFlMnpI?=
 =?utf-8?B?ZW1EZnF1azg2NkJ1aDJlY09aVVY5cmo0YWtvNkw1dFZHRmtJTmJoTThnOGZJ?=
 =?utf-8?B?SUIxOXpTRExUSklGWnhndzRBOC9EY1V1T2RmQVE3Tmw0SXRGTjllSnRYUHJt?=
 =?utf-8?B?WTNVbUd4NlZpUnFQY2JGdGpJS3AwYThCSDBVQ0JRdUFpWGw2UFFJbWJIRnRv?=
 =?utf-8?B?YkdzbU9VS1lVdWNNMUltbk1EcWpwcG1CTDdRZ0ZRQ0I4MXRLQjdNTFBxZUdV?=
 =?utf-8?B?NmhtVldnQk1PZVNJUFBCQVV2Tko5OCt5WjJ5RjZpRHRHWml1cFlzcDdHZjlM?=
 =?utf-8?B?aFY4VnZ4ZVljcUNaQmh1US81RDZhazVGV1RGcGZrMC9wZ1kxamhtL1cxbzAw?=
 =?utf-8?B?RG9NcUxZWGFWdm05ZmNSbXRBZFR4ekNRNy84SFZwb1B2eTBvS3cvUTNVNDRo?=
 =?utf-8?Q?M5a5uI5JUXygCNSUgwyQuEB80?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67232bb-a0f6-4c8f-a967-08dad6d4a456
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:23:20.6306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iox4ZyLH1jfqv+Yf1V2N4CeiTBxJss0QQ5OTXIyt81kz21qw8sW5QEWZ/sfqVHHAKhWWPmJDX7aDoczwY3NPwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5492
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/5/22 08:30, Borislav Petkov wrote:
> On Thu, Dec 01, 2022 at 03:34:23PM +0530, Nikunj A Dadhania wrote:
>> The hypervisor can enable various new features (SEV_FEATURES[1:63])
>> and start the SNP guest. Some of these features need guest side
>> implementation. If any of these features are enabled without guest
>> side implementation, the behavior of the SNP guest will be undefined.
>> The SNP guest boot may fail in a non-obvious way making it difficult
>> to debug.
>>
>> Instead of allowing the guest to continue and have it fail randomly
>> later, detect this early and fail gracefully.
>>
>> SEV_STATUS MSR indicates features which hypervisor has enabled. While
>> booting, SNP guests should ascertain that all the enabled features
>> have guest side implementation. In case any feature is not implemented
>> in the guest, the guest terminates booting with SNP feature
>> unsupported exit code.
>>
>> The below table lists the expected guest behavior with various
>> possible scenarios of guest/hypervisor SNP feature support.
>>
>> +---------------+---------------+---------------+---------------+
>> |Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
>> |     by HV     |implementation |implementation |   behavior    |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      No       |      No       |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      Yes      |      No       |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      Yes      |      Yes      |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      No       |      No       |   Boot with   |
>> |               |               |               |feature enabled|
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      Yes      |      No       | Graceful Boot |
>> |               |               |               |    Failure    |
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      Yes      |      Yes      |   Boot with   |
>> |               |               |               |feature enabled|
>> +---------------+---------------+---------------+---------------+
> 
> I like this table and I wouldn't want for it to go under in some commit
> message which is not that easy to retrieve so I'm thinking you should
> add it along with some blurb to
> 
>    Documentation/x86/amd-memory-encryption.rst
> 
> instead where it belongs.
> 
>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index c93930d5ccbd..571eb2576475 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -270,6 +270,50 @@ static void enforce_vmpl0(void)
>>   		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>>   }
>>   
>> +/*
>> + * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
>> + * will need guest side implementation for proper functioning of the guest.
>> + * If any of these features are enabled without guest side implementation,
> 
> "... are enabled in the hypervisor ..."
> 
>> + * the behavior of the guest will be undefined. The guest may fail in
>> + * non-obvious way making it difficult to debug.
>> + *
>> + * SNP reserved feature bits may or may not need guest side implementation.
> 
> Yah, get rid of that PPR formulation. If you see the verb "may" always
> run away. :-)
> 
>> + * As the behavior of reserved feature bits are unknown, to be on the safer
>> + * side add them to the NEED_GUEST_IMPLEMENTATION mask.
> 
> Yah, that makes sense - you want to protect those for future use. Ack.
> 
>> + */
>> +#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
> 
> SNP_FEATURES_REQUIRED

This makes it sound like these features are required to run SNP, which 
they're not. It's that we can't run SNP with these features without 
support in the guest. So while the patch name is long, it is accurate.

Maybe SNP_FEATURES_NEED_IMPLEMENTATION if you want to shorten it a little?

Thanks,
Tom

> 
> Simpler and shorter.
> 
>> +						MSR_AMD64_SNP_REFLECT_VC |		\
>> +						MSR_AMD64_SNP_RESTRICTED_INJ |		\
>> +						MSR_AMD64_SNP_ALT_INJ |			\
>> +						MSR_AMD64_SNP_DEBUG_SWAP |		\
>> +						MSR_AMD64_SNP_VMPL_SSS |		\
>> +						MSR_AMD64_SNP_SECURE_TSC |		\
>> +						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
>> +						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
>> +						MSR_AMD64_SNP_RESERVED_BIT13 |		\
>> +						MSR_AMD64_SNP_RESERVED_BIT15 |		\
>> +						MSR_AMD64_SNP_RESERVED_MASK)
>> +
>> +/*
>> + * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
>> + * implemented by the guest kernel. As and when a new feature is implemented
>> + * in the guest kernel, a corresponding bit should be added to the mask.
> 
> And there's no way we won't notice that we've forgotten to do so because
> it'll terminate with the proper error code.
> 
>> + */
>> +#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
> 
> SNP_FEATURES_PRESENT
> 
> And so I've done a couple of changes ontop, here's a diff as it explains
> a lot better what I mean.
> 
> Have a look and let me know if something's wrong.
> 
> Thx.
> 
> ---
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index 10272835dfe9..f023d37e2c41 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -271,48 +271,35 @@ static void enforce_vmpl0(void)
>   }
>   
>   /*
> - * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
> - * will need guest side implementation for proper functioning of the guest.
> - * If any of these features are enabled without guest side implementation,
> - * the behavior of the guest will be undefined. The guest may fail in
> - * non-obvious way making it difficult to debug.
> - *
> - * SNP reserved feature bits may or may not need guest side implementation.
> - * As the behavior of reserved feature bits are unknown, to be on the safer
> - * side add them to the NEED_GUEST_IMPLEMENTATION mask.
> - */
> -#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
> -						MSR_AMD64_SNP_REFLECT_VC |		\
> -						MSR_AMD64_SNP_RESTRICTED_INJ |		\
> -						MSR_AMD64_SNP_ALT_INJ |			\
> -						MSR_AMD64_SNP_DEBUG_SWAP |		\
> -						MSR_AMD64_SNP_VMPL_SSS |		\
> -						MSR_AMD64_SNP_SECURE_TSC |		\
> -						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> -						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> -						MSR_AMD64_SNP_RESERVED_BIT13 |		\
> -						MSR_AMD64_SNP_RESERVED_BIT15 |		\
> -						MSR_AMD64_SNP_RESERVED_MASK)
>   
> -/*
> - * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
> - * implemented by the guest kernel. As and when a new feature is implemented
> - * in the guest kernel, a corresponding bit should be added to the mask.
> + * SNP_FEATURES_REQUIRED is the mask of SNP features that will need
> + * guest side implementation for proper functioning of the guest. If any
> + * of these features are enabled in the hypervisor but are lacking guest
> + * side implementation, the behavior of the guest will be undefined. The
> + * guest could fail in non-obvious way making it difficult to debug.
> + *
> + * As the behavior of reserved feature bits is unknown to be on the
> + * safe side add them to the required features mask.
>    */
> -#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
> +#define SNP_FEATURES_REQUIRED		(MSR_AMD64_SNP_VTOM |			\
> +					MSR_AMD64_SNP_REFLECT_VC |		\
> +					MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +					MSR_AMD64_SNP_ALT_INJ |			\
> +					MSR_AMD64_SNP_DEBUG_SWAP |		\
> +					MSR_AMD64_SNP_VMPL_SSS |		\
> +					MSR_AMD64_SNP_SECURE_TSC |		\
> +					MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +					MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +					MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +					MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +					MSR_AMD64_SNP_RESERVED_MASK)
>   
>   /*
> - * The hypervisor can enable various features flags (in SEV_FEATURES[1:63]) and
> - * start the SNP guest. Certain SNP features need guest side implementation.
> - * Check if the SNP guest has implementation for those features.
> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
> + * by the guest kernel. As and when a new feature is implemented in the
> + * guest kernel, a corresponding bit should be added to the mask.
>    */
> -static bool snp_guest_has_features_implemented(void)
> -{
> -	u64 guest_features_not_implemented = SNP_FEATURES_NEED_GUEST_IMPLEMENTATION &
> -		~SNP_FEATURES_HAS_GUEST_IMPLEMENTATION;
> -
> -	return !(sev_status & guest_features_not_implemented);
> -}
> +#define SNP_FEATURES_PRESENT (0)
>   
>   void sev_enable(struct boot_params *bp)
>   {
> @@ -383,7 +370,7 @@ void sev_enable(struct boot_params *bp)
>   		 * Terminate the boot if hypervisor has enabled any feature
>   		 * missing guest side implementation.
>   		 */
> -		if (!snp_guest_has_features_implemented())
> +		if (sev_status & SNP_FEATURES_REQUIRED & ~SNP_FEATURES_PRESENT)
>   			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
>   
>   		enforce_vmpl0();
> 
