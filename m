Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF562C8E5
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 20:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiKPTXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 14:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiKPTXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 14:23:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05635F0B;
        Wed, 16 Nov 2022 11:23:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q71WwSuTEjgv9upXNXcJ6m47tjD/a6iOBhB90yNokAJDYLKbt4WTbsg8sdrD7HY/tGt/7nWl2kybiSQp/ZVefuQmJvgGTN59Z1i5mPsxkZvLhLSa1vvifFAShag1rmTdStTfg7NRDQG5pMFNoPxdlqQXfGMcLE/EQjr5eZQ84AHF2dvmVyt17zD+oBCZW0yQ7vicLZZGCZizScFzXsZCw4PPXWxkTKpb8/XlgupJUS4x2DA+N6RltGKgt5hWbTKpWBY0t/OVuBnNn/4JWnnS+Qp2ufBFGkEMqmjaFWdoGMD9E5voNPYZcYk67cRbjzLeh+Epx6spJ4WEvNytnkhuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DwRgLh0QIe+YimCwD6XlgHHT1WTGbVLveWajkaG5KNA=;
 b=GsQoDBgCOIxSla19irR+D7Rm9Cw7pXPBEFdmy+kUi4s+G6EEGQzv7UYTZreUdk5z6OrRnX6GZ0/PbKpCT8V1iTzSo6OZIrIzlyg8coMdqtDSmftFZGG5wTmp9K490ekvBjC5hLq+6B4raDeskIhjx4sZjpBKO3VcX5ekJyhEhJJn/L82opL00PuRCCnoi3TULMnRc8tUtMlmrwujLTXG45l+F/DJDMLuCTncSbuF6gQwZB1Ph/Kgx2jCq0AKB5FR4+WdA/ksDpn+FKMyYrXDp1Te9Zpb6Y2E59cPbFA9nJkzsj/aWaAQWTWpw9XF8RiX4U7s8e4vDE2BXG7/rFIrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DwRgLh0QIe+YimCwD6XlgHHT1WTGbVLveWajkaG5KNA=;
 b=jwtBvgo+RP/pK2iJOLiDrxrRTHtZt5QjYgKA4vSZGbln8FvtgyFqsoetT6f0RMUcLrHlP+wresPclqZxNQ/FCsIsY/jo2T3VEwMHwb4SSc4GXOA4GgpumbvLG0ZuY8VWj/ppl11bfxKhzsfWOFCwq/Rp9wQn9sakq+BSvItRoJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL3PR12MB6524.namprd12.prod.outlook.com (2603:10b6:208:38c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 19:23:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 19:23:29 +0000
Message-ID: <a7b3ddb5-73ff-0560-1fa5-beb05864feee@amd.com>
Date:   Wed, 16 Nov 2022 13:23:23 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
 <711e6027-1b4f-4aed-47a6-305396d05893@amd.com> <Y3Us9wSX9DrWqCyq@zn.tnic>
 <834d41e7-44f8-53f9-a1fa-0cdb5aaff30f@amd.com> <Y3U1VJdC77CfniJj@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3U1VJdC77CfniJj@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0072.namprd05.prod.outlook.com
 (2603:10b6:610:38::49) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL3PR12MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e03829a-03c4-4353-1832-08dac8080ad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSzAwKJk0jRm+idy4ex6OXJBCnwu5sPfF7wAl8HgmXNMhLKxLy/ARKiT3P0VDx0PS+oM4ySe4neBeDPLpvOSOmudpZ3EnHBCsV0nh3NlHv9NQ149GlYySil/BNCxkWb0S7AHc/kFc2NKQ9BPXo64YluTqwzb9rgpQb1FuIL5igAsYQWR7hNseVBewbrP6KY7Pqi5CODGHG0cFn/eO4nKAhREn+eL34jWRhiKmtF9IoTizf7aYDWgcTBiDrgTx/2WpSrdIIB5Cro8CfeuImRXoKsjXliZU01M7JLWmIto5qH4BdGhP4I9KPPHJnqG+DcVbyozMnVdEFIOdFzsMPj4ujoh6zEktSLzMQjpRt0ejYN0vxduxJqkQhMsra0PgZ6vaoHgrjra/WDe6zeCvZ3OkFGLCoHRMjw+uLSiZLEJuNzc3bhyFFzHdWF1jeNZkH5SdLSSnIfAaxYhvb8q805PBGdy20ImlxThvG30DoOqX68LjFQMbEPunJnoyzvuyVHkR4Hp+mo5c3KYIwAQqEGMaCMlxodiAba7byLxz+RaNecmzrJiWsNTSmtBnInfBTsx30POFBncDrVrHrPm3fJnPtkBw9Fd2QPqCiNnJ9/QCUWJ8TUBMu6uGxrqmx3pacZg2eNwp85oLq7PdPRHJyTXsktPZ/IMi+5GiQDXJySRB3+E7MTSx8tnIC/D94tgbtPoD+TyeYv7liFRhJKy8XV/Mlzga7aQ1hwf6NOMjm8xyMOqguZvF2qH/2miVjcGMHK4oaQxBT6dWa4lKqiBHFxaNhSVINOnLvLUGZ4d1D/ncEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(38100700002)(86362001)(41300700001)(6512007)(31696002)(4744005)(6486002)(478600001)(7416002)(316002)(66476007)(66946007)(4326008)(8676002)(8936002)(54906003)(6666004)(7406005)(6916009)(66556008)(186003)(53546011)(2616005)(6506007)(2906002)(5660300002)(26005)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em5qQ2gzVnMzUWJvSXBUNjRGNXdhSTEvYkJ4MVo3Q05rK2M3VC9qY2Zsb0lt?=
 =?utf-8?B?MkN1S0lsTlQ0eERzMmtRS2xydzdjN1NWOHY0YXFYb0JXdEpZVnpPREtNQUNF?=
 =?utf-8?B?MTlIbFJLZ0pTQ3lhbjV4aTlESVYrc0NQUzhmSmJ5b2I4ajJiSjkwT1dDdFND?=
 =?utf-8?B?eElVU3k0ZGdQc2dSLzJHb1JvblJNOWk5TTlGbE1saGFSYndMa2c3cGtlVDdN?=
 =?utf-8?B?R0wxZkNaKzg5YS9vMndiUS9hSCtBTUN5WEFMWFZ3aFBoaHZjMEtQUEpPRFBF?=
 =?utf-8?B?cEZ3dHRGeGkxb0NGMVZ0OFBoMUVZcWpKZzNhSEJSajY0eXBOVVBXdlNMQkYw?=
 =?utf-8?B?SXJLdm1HQUpFckp2NkdGYUpIQ1pxVHRWZmVIeDN4bTRndnhwMXNRbkxCZ2Ra?=
 =?utf-8?B?TWY3SmRiNnZCeExoN3JVUG1oMFRERExUTEhaRGxDbmxieHlHQnpGeUlPNkhD?=
 =?utf-8?B?NVRCaWJmNDRUTEcvN29uU1h4S2RPeWdnV2FOaS91SGRKTllxWEdxWTkzZk1y?=
 =?utf-8?B?aWVyVlhna2RmcGQrbmp6UzIzR3htQ1g1R05EbFBsc1BGT2grY0U0ZFhZVUxG?=
 =?utf-8?B?NERGcVVHWU83L2Qyd2YycDFHNFdoZjZpRXlpMW1FV2JFMFJkekJqeWtCZkVv?=
 =?utf-8?B?WWxLK3NpVkVXVlFPSXpoT2VtYU5mc0d0S0RLUHFGV3c4MWdDc0o0eVgwZk15?=
 =?utf-8?B?ay9xODdSaVVYNXRMM1VrV0dlaGhZQWU5QVVERkpzWldqL0dKbGdReVJJZXFG?=
 =?utf-8?B?cEIrMWhqaVZLUVp0UWdaaUlvK05aRXZBc1l6V2hVQ2NiSGxyWW9VY3Eyc05C?=
 =?utf-8?B?VnEzWE80c1ZzaFUveG5Md0doaG82OWdwaTB4YzBIeU9YMCs5TkxDVUtHMUYr?=
 =?utf-8?B?S3NyV3FGL2hBWHFHcWpwZnUydS93YlhuS3VLT2oxNVJ2S20wRE9mQlFLV250?=
 =?utf-8?B?VnVNS3dqajg4TmV6Z2t3ZFV4UUZOalI1ck1EOEN0TE5SM0NVWHRtYk1TdTM5?=
 =?utf-8?B?UG5hQlgzbGR6c2VkMFk5OGZEc2VCekxURlZiRGwyc3lvUklEaXIvb0pnRGU2?=
 =?utf-8?B?aWR1c1RiMTJxei94ZXJXM0ppdy9EZ0VzYytiazR6T0V1YzYwekRvZ1lGK3JP?=
 =?utf-8?B?UzZxSXNJaDlLMGErQnpVOTl4N2NpejRDbllDSVNrVTJBT2c5OG9GYXNGWGdo?=
 =?utf-8?B?UUE1VnJhTUxoTGxuYW5lVzFFYmdSZi9xeENDeGcwQUF3SzRyWU04RVRzQU43?=
 =?utf-8?B?ZStVNUN1UXF6NDlhYjl5QVZEdVkwZVUxT2lweDJIN0NMSWcranMzK1pDUW53?=
 =?utf-8?B?dTNsMzM1Wi9kajdMalEyeTN4OFBjalZ6WGpCUElBYXJCZ005MjZuNHNlNVhq?=
 =?utf-8?B?NFpBRTdnZkxFUHNENHFGOFhHL25mV2N4L2VRb1F0ZzVwV0NvWStKRmI0ZWpm?=
 =?utf-8?B?TklMSXlqUzFxVExteTRhc2cxeS9yNDBUMktLc0U1REk4cXBHL1cwdDBLT1BG?=
 =?utf-8?B?dkpJcXhGVElhOVRoOEFvRWZWUmUzRm9Pb05HcnZYWU1WYjREaDhmalpCYU00?=
 =?utf-8?B?VUZOWFU2UmVieUlrZm1haUhwaUZDZEM2dUVlOFdqMEtUanRrMW9TR3J4bDdD?=
 =?utf-8?B?WVJ4NXErM0l2STM3NHNlc0J2a3VhVXpwNXlTSnpqaXhsWEgxb2d0MXEvK2I5?=
 =?utf-8?B?N0t4YjExSWUvTEZ3WTFNWFBkc3FCc1JYZVFjSkNsRHQ1WlZ6L21kMUZwc1p1?=
 =?utf-8?B?YVR1MlZJbjI2SVhPcVlVSlhYN1laTDBPQTJzLytPZ1VmMkt3WUNVMXFHTi9o?=
 =?utf-8?B?YW5GWGMxeXR5UUd0NGlWSWowMjFKKzRtZlZ4cFlCR0N1SGhMdmJqU3p2VDFa?=
 =?utf-8?B?MHJNYzdkTWIvVVJvYjJXZEEyQ2JsN2Vza1lydmZPN0phQU1tSHJBcitYSi96?=
 =?utf-8?B?ZXUrSTg5akJDTzFPQ1VPVG9VUTA3M0xpYWRheU53MDM2NjZESFRDSWl4K1Zk?=
 =?utf-8?B?Q0JuS3pZdEM4czhQbXkzcURJZ1BxeEE2UXZrdFhtK2lYZ2JCWkFHMVRYT1dV?=
 =?utf-8?B?SnJsbldVT1NHS0VyNktkNldsZkNXSEpjWG1VT0xYYjc0UTgxdEpPdlRMTFRa?=
 =?utf-8?Q?RDCtLt1wQZLYYMNA5qXTrA//G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e03829a-03c4-4353-1832-08dac8080ad4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 19:23:29.5655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5zC6vTiGpS7u5pOu774azGJg/w1tNGLoEko0u7HVGpWcmqup0Xck+TutkdXs8+1MCTbrUJVeUGW9oqoNAqgbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/2022 1:09 PM, Borislav Petkov wrote:
> On Wed, Nov 16, 2022 at 12:53:36PM -0600, Kalra, Ashish wrote:
>> Actually, these host allocated pages would have already been removed from
>> the kernel direct map,
> 
> And, as I said above, it would be a lot easier to handle any potential
> faults resulting from the host touching them by having it raise a *RMP*
> fault instead of normal *PF* fault where the latter code is a crazy mess.

Just to reiterate here, we won't be getting a *RMP* fault but will 
instead get a normal (not-present) #PF fault when the host touches these 
pages.

Sorry for any confusion about the fault signaled, earlier i mentioned we 
will get a RMP violation #PF, but actually as these pages are also 
removed from the kernel direct-map, therefore, we will get the 
not-present #PF and not the RMP #PF (core will check and signal 
not-present #PF before it performs the RMP checks).

Thanks,
Ashish

