Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D523865B9D1
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 04:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbjACDiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 22:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbjACDhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 22:37:52 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE5E5583;
        Mon,  2 Jan 2023 19:37:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMC0QsNAH0yziw5pnOyWLry8mslquMFtnccZRECmEjGBMZ4nzx6hpRg0uitl34gvX7XM2JunEWL9LJCkRrjJduKYhQqAgNCIf7jk6v87z26VAvYfWz2fERkl1/YZqOld3CJR7WBbRKwFrtwFaZAMuVVxqV0tDhLk7vqtpx2GmJSFshA9rsaUYnD2DKViyVvE57qcRgTMR37mm3ey9oT63olL+vBex37wK99U+2W3ZpJ9NXTzg6A4SzvntgFXngcreqB/vnvBCrnuZzx9JHLutDIHk/M5OMmCXqwr0mGOHcunHgdvDZ9P64UUr36r3Q3R/QqGaoeywonabfdPfE4QhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e66salH+x+xOfK6JeIyKk8BiYcp4W/a2gLJ4uH1MMyo=;
 b=kQYj3ZC9zFGD7aBH9m6nVjYjo2SM0KNHq+2biZFgBKObt0EOuUT4DA2HvNc/xpx67obNnbwNngb9KyrMRhcxrNCythHoPFGKUHS3RzOR6gWiocWYi8UkHmwNDimnKOO+eOBAzGeDzh9bs220u7z6aYrV+dK1jRAfGKcNn+LqvGiv9ZR6CMwugzm+GjI1BJSxBO8+BjmnwNUmYMK8ejlkxZtmY5DagsnIQeWR6D2R/ZDcU1EwOXqKVZfXG3MI3jiMSYg7qNguu8Vg0yU+ehFkWvbYMKU90AfOH50LjWY6HxDhqUrzD5rWBVo3z7ZhPIkN/Y6FMDV0gO6S0QtLEErfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e66salH+x+xOfK6JeIyKk8BiYcp4W/a2gLJ4uH1MMyo=;
 b=x6EQyWLbVYE/h8mX3BDIIKbzOMy7A1hxYlWSIIlogMakvNc4ra1b1Zd6MsI2r3iR8ulYAf1ui6Bxe5mojOu1YSd1kWToUndR3ubZ7LwLiDmgR4T+iME2xDvolNxxdhwR/XEv3pGMCCt1Adq4A7FpSbNn2apFLTX7JWNXj0AUjV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 03:37:29 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%6]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 03:37:29 +0000
Message-ID: <02a2e641-6b6d-e1c5-2c43-8815306d92a0@amd.com>
Date:   Tue, 3 Jan 2023 09:07:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
 <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com> <Y7M4IzNYBtfEJe6Z@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y7M4IzNYBtfEJe6Z@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: 96e1332c-f381-49bf-30f4-08daed3bd6d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /P9z2LBvFY+E8V6VDGiAjw+DpJzY/i7wTfYKVwg+dvL6ieg8GPlb9WUMAl+sKwujHkd3wxYrUoqCEBSiHX59eCPk2UGxrXY5+2odHy6srxp2ZWChGi4Jj+1YFlVoBMuEpLBQFN3e1Acs7/vG0uxQ2DFzMDtshWToYd9XfdZm+w7ABQqGVK/8IM35+tpqkiFuwgQgLj7c5OOS3ghIGOBKidkFJq4XE+yBRnzvX9UCt2oVNtMd/Yk5pJkg6X2zLvLHfkvpUbxa5XoZ74/GcY/NkBvb02Neu9Y4XQ9jCVtYXtDbL7ZG5/5sODkIXRJRUj+ktLoy+d2DXahPpByYGX3M5rUYmUFPZkG+bqCt4cvgSDBRgf5vlJaDjA9ecl6rusiYNz2YvwaRIoA6ieqViBH62PKkmqR5VD3jFdDzNXWidGk7txlEMK3FtX41QC9dom0F7mXYuUzBARv7B1zcnXiRU/p5LD3FRNiQHC826G8KQCBtmNkMc98hacYHoOw3Ziqxb115WM0ivgWuuTEyg8IPelKJEvDBOHFlsl4l1D5vaKPVWjXRfgil4hBoFv2VA2iTfC6LmCk/ASvh02WqhDv2GragXlwH6sG4jLVo8Ifith3R9ZUwr+fjCuTCphmnK7ZVC+RkvNswUGOomg6mfSmvbkeNe8FLRJkUo5Ngu81YPvncIpZaURkWtNLAyZFsqehXYTiARm1qILpSc6yuneRi1SGADwiTIiHwI4rvRr98AkZOHlL4SgZL9npRMrqyz6HV3Umym2+PPZDjJtR37vyf3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(38100700002)(41300700001)(31696002)(8676002)(66476007)(66946007)(66556008)(4326008)(110136005)(316002)(8936002)(7416002)(2906002)(5660300002)(83380400001)(2616005)(6512007)(478600001)(6486002)(53546011)(6506007)(26005)(186003)(6666004)(31686004)(36756003)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEFkdzFFbmtTOUdXNWpLU3BoWlNRYjA4Q09uL1pxbnkrUlRnQXJKUDFtcDVC?=
 =?utf-8?B?cm4wRzBPUmFNVlo4UWtWVWRjaWw4SDlKNVkzaXp6ZnJseEpSaDVHWTJPaFNV?=
 =?utf-8?B?L1RaRlMwUEQzckczZHZKTS95OTQzVENFcFJvUSt3R0VjZTgrQkU3S1AwSERF?=
 =?utf-8?B?SVlDR1FiZkV0L1JjNW42b2ZIWEtZUDM0bk9ocUE0L0tHZk5sL05TbjUvcnp6?=
 =?utf-8?B?blJGZnBuN0JtcGpkZWhyVC9VNStiWHB2N3dod0Rqak0zV3RQTU1ITGhHQWE0?=
 =?utf-8?B?VDhXMFJCRVpkYU05SGtVZi8xdWtHSXlLU2c4L01mTTJDUzNvY2U1dlB2UC80?=
 =?utf-8?B?dWN6S0lLTUN6eUMrWnJwWnp1VExJZnF4TmJoOThnMFNBWFNQYkVhZld5eUVl?=
 =?utf-8?B?d0NDck9BMUtjeE5QbzN2OW9vT1lpR21sNDlCRjc0eXR5WTR1QzJCSUZ5L00z?=
 =?utf-8?B?Wk0reFRSTmVQeU5QUXNQaFZjWjY5bDhIaER1cjZlZmxHNFd2S0RrYjZ3ak9i?=
 =?utf-8?B?OE91Z3VwN1VJQXRKYVdDaGVseE9LT2xBbHNmdHpzVnYybUJYRnlmRG02em9r?=
 =?utf-8?B?SGgvQlZ6WldVNll4SzA3MThodGRYZ3ZaSXVxR1ZtWGZRY0xLTkVJbUZMQzhJ?=
 =?utf-8?B?M3dwa2dVQUhQTjBtY05EZ1dyaC90b0E3aEJEVXdTcE40bjR2Uk9nTFRxWU56?=
 =?utf-8?B?RFRmME41SmxYaDZXQkxYMlgvaHlCckt1d1JNa1F5VTFxR0pSK1hzZUFwUTZt?=
 =?utf-8?B?dTJZUU9lRFpIR3BPTkg1ZHp6QmF6MlV5bENzSlNNZEtvU1NKdG5VOVl4cnBP?=
 =?utf-8?B?YUFLeVR2QmdhRStxUFc4TlhGekowMWRBNnZLc0V5OFhWOUJsYnBKY0cwT01Z?=
 =?utf-8?B?dWxCZTlFNWlFbitzVGxBK2NLOFU4ci8wUHlIQUJKMFlWU2RRcjRNMWJFY2NV?=
 =?utf-8?B?ZnFNZnhvOEw3b2xvdTJ2TWhyQWJWSnlXQ1QyQmJvbWtLTURFdzlNQnFYNDRw?=
 =?utf-8?B?STlxSFpwME5GdGRQZ2RWS1M1M0MwNVdYYVBDZ2hJbUFkMVNuMFFvakhsemdx?=
 =?utf-8?B?UVQwZGd4cFZoSVNybzdKcElkR3BNc0pnVmUxNHRTaWxrL0lxUWJyZDlBYXIr?=
 =?utf-8?B?TnluTFdVUHIveTdIREVOYjNHd294c09KMW5YclRQSU9zek9CNTVnWWlGUGtH?=
 =?utf-8?B?Q1VjenVITTFIZEpJb29YYnpINWF6cUExQW4wdVRQNHFJVmtFbDU0bk40b0k1?=
 =?utf-8?B?V1paQ2FBUjVxdjhDbVRBRHB3Ri8xSnU2aDB3YkdjbFljbk5scVg3L3FjY1Fn?=
 =?utf-8?B?TDJJaG5WODI5azZFWGRvNGNQK1F4M1BReUNVZHVwM3BYVFVsNnNmYzhPenhv?=
 =?utf-8?B?bDlsYzVCN0E5d2dpQmNSQVZXUXFuWlIwSjJnZng5ZzlFcEl3aERrMThEelNj?=
 =?utf-8?B?cUE1ZThoTWR2a05xL3FVN2VFQ1NZbGQwR0RTUUFlR25jdFl1Z3NzSnhRQXZ6?=
 =?utf-8?B?SkxKUk9mK1NXak16Rmp3RVB6MlliMjdqK3U3cFNyR3Bxd3lKc2dxaXFXeDNC?=
 =?utf-8?B?U0ZucHljQ2Q2UHgwQm5meHBsT1BybVVZUWd2SG03bEdBdHlLWStQMVBKbjdm?=
 =?utf-8?B?QVR2ZVVLRUZoRGZGY1NVbFBUOXVrYjVnMjNyNDNPR3Evc3Boc3VoVnZrT0Nk?=
 =?utf-8?B?ZVNVRi9GMU9UMnpVWlJ3N2ZwL0hVM0pFWU90SUVlY1h3M0lsTFFGeVRTZ1NN?=
 =?utf-8?B?U3RnY0pNcTBlZ0pBRFY1VFY4VjVwRTQ3YlRnSm53L2tXQmhaRmE2dHVWemxX?=
 =?utf-8?B?ZDAwblk0emZQWnVBQXY5SUhwbjh1RWM4SXRES245MDBhR3c5eVlEdmhwZ2Z3?=
 =?utf-8?B?Q2ZtbThQZ3FQcXNFdG96aFhHZHQvRWJhUzcya1NGbk81bmp5akkydDFpN0M1?=
 =?utf-8?B?ZVFHTTZMNkZ3TnBRd3ZsUnczS3hXWFNDUTEwVWFUeWNCVjE4UEdZWlE2TTds?=
 =?utf-8?B?RTVYQmxmbGlXUXpGaDRFRWtzM2l2TFhSVUZxcmE0a0pZSVU1UTZPQ21RYWsz?=
 =?utf-8?B?cGVoSWhLZWlxQ1AzV21tYlpmMVhJbTBlNHF3TFpBZjVYL3IrWlVjMWxBb1Qr?=
 =?utf-8?Q?rPktZweY1cg45XV9QZCsWWbEa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e1332c-f381-49bf-30f4-08daed3bd6d2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 03:37:29.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlEWbqYB9/bV0w07zqCejrMUCeaXA4gYivkqBMRNZABnRuSzA8fXZLMpE1YBFjmwmZRyk9kNo4Rb+yej7JHGrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/01/23 01:32, Borislav Petkov wrote:
> On Mon, Jan 02, 2023 at 08:50:23PM +0530, Nikunj A. Dadhania wrote:
>>>> +		/*
>>>> +		 * Terminate the boot if hypervisor has enabled any feature
>>>> +		 * lacking guest side implementation.
>>>> +		 */
>>>> +		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)
>>>> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
>>>
>>> We can't help out by specifying which feature(s)?
>>
>> The purpose of SNP_FEATURES_PRESENT is just that, at present no features that need guest 
>> implementation is part of the kernel. For e.g. I will be posting patches with SecureTSC 
>> enabled, that will make the following change.
> 
> I think what David means is, can we have sev_es_terminate() say exactly which
> feature wasn't implemented instead of users having to dig out which one exactly
> wasn't by trying to find out what their SNP_FEATURES_IMPL_REQ and
> SNP_FEATURES_PRESENT masks are.
> 
> Looking at the GHCB protocol, where GHCB_SNP_FEAT_NOT_IMPLEMENTED reason code
> goes is GHCBData[23:16] which is not enough... And the VMSA has SEV_FEATURES but
> that's guest-only.

Currently, GHCBData[24:63] is unused. If we intend to use the bit range(40bits), GHCB spec 
will need to be updated. And probably would not be enough.
 
> I guess we need a way to communicate those masks in a more user-friendly way so
> that it is exactly clear because of which missing feature(s) has the guest
> terminated.

As the termination request is done using GHCB MSR protocol, exit codes cannot be used.

Regards,
Nikunj
