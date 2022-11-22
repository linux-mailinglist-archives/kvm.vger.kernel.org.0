Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360A7633A3E
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 11:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiKVKhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 05:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVKgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 05:36:35 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F7510BE;
        Tue, 22 Nov 2022 02:32:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA1OcEdTimeMFM+RPAbpBITkz8Ssx8KwEl83Oqb9i8Z0BTVSAjF3OB74RIAEfBcHQb9+8S8brU791kclY23LYRaXHi4xQfHD40XD0C70v17mhzRK2+8WoDifHmKOaWkbc+cqKM/s/NwPiTS/Z4UEwaOQ7ylNc+CjhBNum0Su66a7u2wOdaFBvDPK43OcE/6fHB7VMKT7zlpSu0DOhsiabntbOLNq4tU3RCWDkYIy/60911N4mvMx28zPLSZqJiSCxVIcVsrOyJmMHYvgogJ0kX4qSOgJRcWxfZFmHPpkYxhucP4gvIqUmMvEF3RGPWdTrr7E+/jrIXOUdu1XMQw7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg9mPeOJcg7cGmxCIr5JV4h6tv6Y2NZLTzpGlig5vjM=;
 b=dIGsnQ+4RVzeBLt0GCNyGJjWLr+h61zSuPeYoUULVW9dxEnYW4tcImcc1JWpbJok2vB6dx/p43QQ7sIl9QUpQK17hvXG3GP+rMMGOSIstojcAKUSbSUO2n3tCCkbzwlCX5cTYO5qso021picEGMTKXtXaxEnjAsrIRS6X8FN8aFcXp0qfmzZi0MlvtAbzvW1dQ8xz37OV+H5RjnTxVXl98VQJ21WfGOZUbivVwTsneJEw8y11dovCRdjXsm57NUgFOWEsH7Gend+QLWd/XBODMZi9XViYxu3n/PTE3Ce90gvUSx8FLfs/bX/Thk3hhTizg8qS8O0CiNiUqwZChUEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mg9mPeOJcg7cGmxCIr5JV4h6tv6Y2NZLTzpGlig5vjM=;
 b=4YAPl4Wjp+PFGVvkdsaKThKoXjPH3ewRmw2ax69t0ESuJdsooAW12Vk7rj3CAKx21Wzfy/q2mFP1WMmXi0JAKHS6lnJbqDLxTXHfcJap6bgriKNTjUopkbadWGVO7tEXhfz865pNRUujTMVWmGwy9oB6AmHHUWCNOwbIov7wgQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:32:24 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:32:24 +0000
Message-ID: <d85bf488-9050-13d6-a23b-1440a4df4c81@amd.com>
Date:   Tue, 22 Nov 2022 04:32:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com> <Y3qdTuZQoDZxUgbw@zn.tnic>
 <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com> <Y3yhthJTIWqjjAPK@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3yhthJTIWqjjAPK@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:610:59::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS0PR12MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a9754d-ed0a-4099-68e3-08dacc74d7e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzafT4tKWzI7WTfM3ivuUGLh5utCUwpFzaYAHJ/073NPX6GTbYKqZMCaIWL/fGTEG1ludhgxLY/LhL6WXmQOYQS+WbBJrtrgmOlLJ7qCrIwFO7C2+jIp+YIgvqccYIQZjD3maoImgSY53wg01q9LnxoKUikk7kreToEvUv9g4LvNOF0JOzV18fH5CQEu1AJzTWPd/1RfS9l1OJLHIUZVwqSuZwBV0MgFEt3HS/PgEJ/uPM7vnbYm7EtfFzddBZ+TmWj40lx6gR0Ey7xYj43UQh2vl1q8IGoGow/2Ww5iSqWa9bKk75yP++xQ8TOJYU3i76/nLDVuqznNp8FPAbafwzdIja/IfC1JmIVIT9tfvFk0eZOGX0bcm/c+iTPBlTe84sF01FKCRjvsXqW0Bc4y5NdHBLWtiRnWQw/hK+D/ceVeBvGSRpRcmnawM5TbW+QI0t2jv+7E1we6ygxE4hpCnJeLNS5IQQi9hSvQeyPCaE/lvVZnQdmzuxhbSQc0VGayovRzh8vGCHY7QPLd9e6lhiD2iSmZCo3vBGL2o4Sf01+VI/2GE3jQWJ5BvuCy/GFkY6NqYg/iAUsLqOtSsT9oiV2tV1MMult0cUgb+i3DKWkYabANa4CMCBNe1fGlHUvudBu2MjSQlYAv4aFuGX6tI51TSy9v2v+L3nmDurx9trP7/wDV8YQKgBAsa6J4D86uFlbP9L84iXJvqnlWQdTWju+t3wr8F9d6exsoj5t7H+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199015)(31686004)(2906002)(7416002)(7406005)(8936002)(41300700001)(316002)(6916009)(5660300002)(6486002)(478600001)(66556008)(66946007)(66476007)(4326008)(8676002)(36756003)(31696002)(86362001)(186003)(6506007)(26005)(53546011)(6512007)(6666004)(2616005)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3d4WDlGZytIbVk0MjRnNWhweWV1OFZOUm5ic0xMakN1NXczRkJmZlRBL2h1?=
 =?utf-8?B?MW84QTZacjAyN3krc3FUMlpEa0ZVTmxzMmdtM2pSaDFkczVPVzV5aWxpRnla?=
 =?utf-8?B?NTlTWFFBOXNqZ1ducnBkSWVvSi9XRUczN0V6QWE0YlAxQ0lTekhDL1JVdENR?=
 =?utf-8?B?c25ZT2ViYTBQMzF1NEszY2h3ZElhZnlBaUVtZzU4NXI5WUZMcnpxNnZpUmFz?=
 =?utf-8?B?L01VT1pZc1RzckN5aGxBUHFPcjRVdGl1MHpMdHdCaHVJWUZsSjYwMENlTkdh?=
 =?utf-8?B?aDRsa21ZZXNtRmxqb1ZkYlViNGlSM1lsN2hBbjdwTWFaLytXL1VueW5zM0Y3?=
 =?utf-8?B?amp2Z1dVMXAyb1NnZFZnNzhvT0thdURDY0Z1K05velJCK2FiZnF3WFVLNW5T?=
 =?utf-8?B?TUZqZGlYdXFQUmxUYnhEUDhZWGUvQk9aeHJuOU5uYUpxR3p5WTJvbWNaZ1lW?=
 =?utf-8?B?bXVRbE1pQnlJUmdKRWg3anlqQXdOdFBvb3YxZTI4ejBTYm1CUHArME9NS3lJ?=
 =?utf-8?B?RHZhdHozUFBneGwrRmJ0TTA4cjBwcTgwTC83TjIvbk9Vdk8yeFZDelBwMFdx?=
 =?utf-8?B?VTNmK3k4aVN0TVN1WUNuUjdOZU5McG14eVhranVCU2FVOXFBUi9QdURoM1JR?=
 =?utf-8?B?NHFWaUxEKzYvZ3AxOUswL2lWVG94OWRVNG0rU2RtUGlpSUVTdzYxclFYVlZN?=
 =?utf-8?B?VDA3WE50U3p3U2pOeDNFa0src3hFSzFqL29VQ3psRFlLRmlHQjcvK0Nqc1Zp?=
 =?utf-8?B?Y2U3eXlHWEtMSHhnMTYzYkVudHRQNmdqT0FEbDJqaVc0ZlovQnFocElVQ1RL?=
 =?utf-8?B?Ly84TmRSN08zN0g0RzlMV0V6bVF5QXAxeUtFbjhKMmx1cWVJSGNJU2Z4aEND?=
 =?utf-8?B?UGFoL3ZENWJSMmNpU2hlQ1ZSK3ZiUjd0MnZUWm56VDJjZ2FuZnpLWVBxbnha?=
 =?utf-8?B?K1orVUNacDJwWG5XNGJIaHpZVWpCM1UxVXFtU0dHRXVwWnlDdCthanZsNHpr?=
 =?utf-8?B?amd1NE1hcW5KTW5tV0RsTm5iNW1iUVBDcUlVL2V2RzlkcWZ4TGQydWhYTURX?=
 =?utf-8?B?YWZsV1d4SW1oMlBJYTdaYytLMFZXY0ZqKzFGaEtrcEM5NEx6ZVh0UWprV1lx?=
 =?utf-8?B?K0Q3WWU0YXNxaHVIcE5jV2VhVlJZdjNxZWFrbHk4Wjk3UTROL1p6MFJVL3ht?=
 =?utf-8?B?eENsd1hSRFh4Q1R2WkplUmNsdWdERlJzb2tHVG12YzduVWVVYXFoSXk4SUVI?=
 =?utf-8?B?OU4xMVBXU0tTMGNvcWlsU2I5MXdXZ3IvdFVjeDJvQzIvN2VsaVN5cXVHWW1o?=
 =?utf-8?B?OG9YUUNEYitWM1dMT3BycDdycWJzY0t6aTJpMkd5c3BiQVpXT2FDZDdHYWdI?=
 =?utf-8?B?YXdGWjF0SWcvaCtUNGY1N3lsUzVoV3hFNHF0a29TQm10MEhtRlBsSENsZmxM?=
 =?utf-8?B?VUkzOHFna0Q0VEJsRks1U25XNnlQeGZrbnBHS0VHK2hjOCtvSEl2Y294a0VF?=
 =?utf-8?B?S2oyU3lrbnlHQXg0WjNGNWFUQ3FFblpRbzlyT0pORTVYSUcvY2VFM0dhdXdQ?=
 =?utf-8?B?eGM1RjV5YmxOdHZuY3V6NCsrcVBqeWpSVCtnSjN1SW9nV3daOHZMY2tlZmpE?=
 =?utf-8?B?S1M5d3hWQTZjYzlYZ014bUFScFRHd1JxZk0ydmFkWEw4SWQ3QStOY0xaRDJQ?=
 =?utf-8?B?VW1rWUtGc3J1bndSOXZ0SlhUWmVUQTA1MU1TNDFxNjJkRy9aQlR4T0dSVGp5?=
 =?utf-8?B?em84TGlScFRhaUtDdjdsS2N4STI0OXRsd2F0STFoMDk3Vy9ZT2Zzckd5VFdT?=
 =?utf-8?B?bDVtYTRETEJlT05EdC9LOTdiVVVQU2V2RlhjUEs2UmV1WmVIVkt3UDdIN2Er?=
 =?utf-8?B?QldOTlp4TWVVRXNKOHZEdHJSZTZBYWNoZXdwcEpLNEcyU0dKUzFJUjlHQ2RD?=
 =?utf-8?B?dUR2eGJRL3daaWFiT1J1eW5zTEw1cnUza0FJL2xmUEVrUnVteVArRXpSb0k3?=
 =?utf-8?B?bW15b1FoZ2w3VytTLzNkYkdtSzBGeUp2elo1VVBJZWNBWGpWSlozdXhiTHhr?=
 =?utf-8?B?azlPN3FWRmE0U2NtWHlnRGZVREQvMys2QTFGTUh4SThJVkt1S0VJV3ZFdWpS?=
 =?utf-8?Q?CFZDG2VQyIzmwBmC1gERFjwfA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a9754d-ed0a-4099-68e3-08dacc74d7e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:32:23.8630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6wsz+cqesjPX2+zjOogOrd728GDzpdJ5Lw00TJ7jzC0XuzyBwpoGpqOAIDiAbH1qFRjeSLOjCmreySotHtimg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6608
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 11/22/2022 4:17 AM, Borislav Petkov wrote:
> On Mon, Nov 21, 2022 at 06:37:18PM -0600, Kalra, Ashish wrote:
>> I agree, but these pages are not in the right state to be released back to
> 
> Which pages exactly?
> 
> Some pages' state has really changed underneath or you've given the
> wrong range?
> 
>> It might be a user/sev-guest error, but these pages are now unsafe to use.
>> So is a kernel panic justified here, instead of not releasing the pages back
>> to host and logging errors for the same.
> 
> Ok, there are two cases:
> 
> * kernel error: I guess a big fat warning is the least we can issue
> here. Not sure about panic considering this should almost never happen
> and a warning would allow for people to catch dumps and debug the issue.
> 
> * firmware error: I don't think you can know that that is really
> the case on a production system without additional fw debugging
> capabilities. Dumping a warning would be the least we can do here too,
> to signal that something's out of the ordinary and so people can look
> into it further.

Please note that in both cases, these non-reclaimed pages cannot be 
freed/returned back to the page allocator. Anytime the kernel accesses 
these pages it will cause a panic or host process crash.

So along with warning, the pages will be added to a leaked pages list, 
but there is no poisoning or anything, only need to ensure that these 
pages are not touched/accessed again.

Thanks,
Ashish

> 
> So yeah, a big fat warning is a good start. And then you don't need any
> memory poisoning etc gunk.
> 
