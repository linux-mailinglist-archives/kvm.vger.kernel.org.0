Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD3455EA0B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiF1Qkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbiF1QgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 12:36:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC341D5;
        Tue, 28 Jun 2022 09:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aS+eoFvJi4Yo+13D9gVqWjLi/os36GYEvl0pkHja0RE9aobPrQaDm4QsUrlMv/PU25fJHmJ8a28O6G/4S2gSxyJdp8qXXin+jX9LA/7inTHHZ9kYThhCkhJOkxy1MlF3oYEV5JcSr4SbRQgOixQJ/U21CJDJdldLCMbdkqlON7VnNFM1/nhqTsVQlUkOg6zYSSpvXmIF4UE3ZMHvYWmiYmeiEoUOGxbczs8rykT44FoEtsEHfQ8XY/hAkJhQnUlYvtd3vTYySDTvoNY6XMdJ2z797UpqmRPbE+mbVe7zz+6ppAeKyvAdY9Pll2fDanwbR6/tNn1ECADxI/C4lSzHUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzEWd1jss7dxxly/+KzFB9tD7n7QnUxU4x4JHLZxwAY=;
 b=hlLR7E5xaZQC6Cej3mqvirZHunLLrGDhP8fFu19HBuHsB/RCc3P3tyv4fx2BM01xyfJI31Rpk8JB+wjLu1AGq2roCIffR839NEr01fxjDuzLKiObHRU63LO+Y6vCD7CcZxNo0QfUi0XJjP74iG+t8lqvDkaXvoWrQkNhYlrg81qllN5lL8yOXbDsVnPYOWau6VkWjsoCARpGr87RkMCeOq7XBiV3IjAX5wLhSMz70+ExXj5JJ8te0c627+VT4/65jdHj6ct0YCY9sRHBTfX49gKM3f79viLyJcJHdGkIdi8M8ekAlRQZqe/WsSPXysc1XXi/FNp6sR5UwsFkjf3g+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzEWd1jss7dxxly/+KzFB9tD7n7QnUxU4x4JHLZxwAY=;
 b=iwXWRLop4iqri8QiFfIXzibvPl6eEgWcHRvLisZHsXVyJFS4vQwWxn1mhKoG8erIcinpLBJkO8t7pmREH4Ntvdd/jPAd5tNGIOaN82RkBYRRWxTI9gXCrPwNZkEGe1Q800ouIQ9gRH7sAQf23sIsITVlmwDhE517Cl6kYuMDEp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DS7PR12MB6264.namprd12.prod.outlook.com (2603:10b6:8:94::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Tue, 28 Jun 2022 16:34:39 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594%9]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 16:34:39 +0000
Message-ID: <63f6419c-6411-af7f-1ce3-bf3cf09e99e3@amd.com>
Date:   Tue, 28 Jun 2022 23:34:30 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
 <84d30ead-7c8e-1f81-aa43-8a959e3ae7d0@amd.com>
 <a5fe4ca7a412c7e4970d7c0d48b17cefcd91833c.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <a5fe4ca7a412c7e4970d7c0d48b17cefcd91833c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0b40e29-fcb3-4a75-13b0-08da5924189d
X-MS-TrafficTypeDiagnostic: DS7PR12MB6264:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apLGIcejb2KnOnN+AEz2aeuzKVTiTSJ8Qp/eQpEHMNzMAuTpKlSFJjP4cnVmW5MdqA+DIUe65lUwPP7NJ979BjzR4rRSanxJRRddLfkDEsy7pBubeibD3GkXalF1QllK/kwQkPrUz3aRfsJdjKnDlr26pSdcS0XklVDSf7Hfld68lHzveB4B6iLgsfTApFrl3NHPi+BwZEn3ujytFIWSUmqXUxphCiJAiOKtSA/agOWYAqjFDeRV5yiRaSA4DP+l5UMAmVCeKQFJUkrOfqoKuI393hYL1YizE4LgQeS5IAECXQWcQ4bTT1CVGSx1DuncrHskd9ltfpO6biitCTVirOrLC9b0mzAE5SbACAFqZd7OS1KlRuGeTcSVpJifYktp5vskOuZZCIAXBLzstjLPmoqmWfFTAOARW71GCghOK53NFERhMbfUQ/lDcH4+Eg2QDSQ4hTSUDRKfZOy2rQU5vdk6yhTJi3vggNNLphr6d8KNQGz/HJJkQi2L+wxKbPfaIGxaK3TCmKPLnpIDQBnIFF9+5YGqmb5PKTELDk1tf32ivGRQaL6WtNOhe1VMi8BXxSh1ixQtSpPsgnn0QXwytd8uA0e8TXDtoo6v3b8mtflBuVf0AlYcM8Ov4Qs6uuVLyAoVWay49URErxj6whksiKq87WqhcCjJlxkDJ5ezfQMh5e5P9FNTQaYIOXQ7Xgjht3NdJoRJA7c7EkPhbIYlRfIGV9+IEH/V1NLGXxYhSJwPPm/5BrAuvCFB2KJZlWNpvQ1vGJhJqXt77m/uCSjhMHV+lMb5qYRtooXCATM5iZpCI77BZ+H/UCONh/MNwmSqCXfe4PoGjDBytjyc/08i+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(41300700001)(6512007)(36756003)(478600001)(6506007)(6666004)(316002)(6486002)(26005)(2906002)(53546011)(86362001)(66946007)(186003)(31686004)(66476007)(8676002)(5660300002)(83380400001)(38100700002)(66556008)(8936002)(45080400002)(31696002)(2616005)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WURTWjllUGJ6Z2xidTJlenV0N0dnOVk3S2JBT2F4YmFPeDk2SW9CVkUwVUhF?=
 =?utf-8?B?MDJLRFV6cUhJSmh4OFpVUGQ1UVNWRkRTb1paYVQ5MzJtb0M2QnZ3ZC9zRVQz?=
 =?utf-8?B?c29yd3V5WGV3Q2g5WFE4VzIvZGxuaEI3RFI0L2x4OG5qQUJYUThsWjlOemlS?=
 =?utf-8?B?eG80VDR2dTRERXRjSmR0dUtGVkgyNU55Yzh2U3RzdzFPcEk3ZGx2ZlhWK1d5?=
 =?utf-8?B?WWU2UlpDRjduYysxdWU5V2t6d1RoOGNYYkZxaU1OYjUxUjJBQUFnUVRBbVB1?=
 =?utf-8?B?N05KTmFSeUE4dWY5LzdZR3F5UHRlTTFYTHo4RjAzZVRMOW80cnBzMzdoK29j?=
 =?utf-8?B?czdpTXdHRmlDNTBvQjZYRmVGT2N1blBIeXR1RHkySVljMlFheGhURFFBU05k?=
 =?utf-8?B?WFZmRVFicHgwUFhEL0EyRTdDNUY1T1VNMHlvbkw2UkVMa0Roc2RtdTlETkZN?=
 =?utf-8?B?YTZUemIvYklSdzFkMFFrMGRtdGVwTmV6NEFUb01STFR6Q1BXT3Z5QmFTMnJz?=
 =?utf-8?B?Um84UXJkZEJ5bm42dUFDcG1pMzFaZVpqRmFBN1ZpeWwyNGo3TXVnMnpjSlE1?=
 =?utf-8?B?amlXUTZwS2pGOWU1bXpUU3ZWY25ndHBWSStLWTRQUGxFRnU4emFaaVJzZnZF?=
 =?utf-8?B?R2dMaHJqLzNmcExRRFJHYVl6b1ZqN1o4TGpwT3pHdm9mT2UwckwrV0lUSU5Y?=
 =?utf-8?B?d2FMS0RKSUR4a25KeDN6QzhiQ2piVnZrRy80NmIyakw0bVNnd3N4cERrUE9I?=
 =?utf-8?B?WkxRSDM3Y3VBZjl0elp4d25vVEhZTkhLZ1djQTNJeFVyYnErNi9sUnZMWkFo?=
 =?utf-8?B?UERIb3BzM0VJMmhoajg4d3kxOTdDcFVjSTEvZGh5YnJWVmhZMXI4eW5COFpp?=
 =?utf-8?B?YVZVVmJyZjZiSmY2SS9FZ0YrY0ZPaWtjamovMVh4SWk2MFlubHREWDlxdy83?=
 =?utf-8?B?SkVPZkEvZXJqZTZZTnN2ZC9vQjZHNkJvZ0Rnd2lRdVRIeURnUnVUVndXOHNG?=
 =?utf-8?B?anlyWGdQdVVUc1BzRkZSVlc4L25JZ1laV1AyTVBtNU9PQ1ZLNVp1WExGNkNJ?=
 =?utf-8?B?VFYzOVY4SGVvbWFpdGJ6UGpQaGtiN3ZFd0NDNmVON21KQnJiSzNHU3FkRGpV?=
 =?utf-8?B?TWdnZVQ2TUY1c2pyYjV6eGQvNlhHNS85NDdUYk1LSzl0eThTbTNMeWJqQlNl?=
 =?utf-8?B?S0c0KzNXSVZvVHVjY0tMbm1kYUhURE5rSW4vT2h3WHFraTVlam9PbFhxbk1a?=
 =?utf-8?B?MGFWRmY3Uk9xQU8vbkQxb2xGMXRpWEtNVXI0Qml0czc3V3VDWnFRSGR1NzlR?=
 =?utf-8?B?M1BUZmF2ajFQR25HR1FJQnMzT1R3SkdTMkUrbVJoQ1Fuc1JETHdqZlo2bFk5?=
 =?utf-8?B?WG5JbVlNZzFvbGdUSWoxL2tMTWZuVk5mZzlHNXlkNUc2YU9HVVR4b3lzN2Np?=
 =?utf-8?B?MFl4ZTJZYkRQWmdEQkR2eXZxOE02TTRVWlNZRERuQ2lNR3czdmpQS2p5Q0RI?=
 =?utf-8?B?V0tIMjcxT0VSaWVXaHkzWmZWMHVIM1RNMFZzbytSSnlTdkVoeTJ1eGdBWDlt?=
 =?utf-8?B?UzNTNkdPWFo0SndZUXlCaE5FT0dxYWsvZk9Mc0JEZ2Y3ZWhpS3BBWDhOb1d5?=
 =?utf-8?B?d0g2TkRZUVZSamJ1Z0Z6VVZyU2ZuYVh4UVVuZWV5ekppODZuY2V4OXVUZGpi?=
 =?utf-8?B?ekJ4Q2VXczRSS0JET0FtWHFZM0psVXlwd2hhYVBsKzRyNEZ0SDZvWWpOWXlL?=
 =?utf-8?B?T2Nza2ptdFUxUXRjak5vdkROYjJFL09Na3hsd0dRMHZOeWhwQU5KS1VzLzJ2?=
 =?utf-8?B?UGlLRlc0THZCWmZSTXRrVWtJU095dGtrWEYrakowbThjOFJJWjRUNWJPdmcx?=
 =?utf-8?B?dU9yL2hPMmV5YWZvdW96S01jdjVrTFprSHBUdTNNeUdnQWxNL08vUVFadHZG?=
 =?utf-8?B?SW0yQUovdGNFaFRGR2FabWNVZmQrTkRvMmpxc0NqOEhJbXR5bDY5Z0dBbm9p?=
 =?utf-8?B?N05jS003QUlSL1lNWnVRUHRZNmloOU00bENIWmdqNzJuNGV2MFZFOEhLVVdn?=
 =?utf-8?B?MTBRZ2RMUFUvekR2QjZ5VmgrL1RCWnJYenJDMzVqTlBBWEgxaGllZ3I3cFFQ?=
 =?utf-8?Q?3XmIrTIIbnlSSCszuOvb8Jq4v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b40e29-fcb3-4a75-13b0-08da5924189d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 16:34:39.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyalYB3jdyGOj+5Rg+LJwhU3z3X9h4QX/X3A6zzhNN6jrDwB4OY2JGO++lEKPrdgWc+BwdeZ8f2cyb01AdXvSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6264
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 6/28/2022 8:43 PM, Maxim Levitsky wrote:
>> With the commit 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base"),
>> APICV/AVIC is now inhibit when the guest kernel boots w/ option "nox2apic" or "x2apic_phys"
>> due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
>>
>> These cases used to work. In theory, we should be able to allow AVIC works in this case.
>> Is there a way to modify logic in kvm_lapic_xapic_id_updated() to allow these use cases
>> to work w/ APICv/AVIC?
>>
>> Best Regards,
>> Suravee
>>
> This seems very strange, I assume you test the kvm/queue of today,

Yes

> which contains a fix for a typo I had in the list of inhibit reasons
> (commit 5bdae49fc2f689b5f896b54bd9230425d3643dab - KVM: SEV: fix misplaced closing parenthesis)

Yes

> Could you share more details on the test? How many vCPUs in the guest, is x2apic exposed to the guest?

With the problem happens w/ 257 vCPUs or more (i.e. vcpu ID 0x100).

> Looking through the code the the __x2apic_disable, touches the MSR_IA32_APICBASE so I would expect
> the APICV_INHIBIT_REASON_APIC_BASE_MODIFIED inhibit to be triggered and not APICV_INHIBIT_REASON_APIC_ID_MODIFIED
> 
> 
> I don't see yet how the x2apic_phys can trigger these inhibits.

When I add WARN_ON_ONCE at the point when we set the APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
I get this call stack.

  11 [  105.470685] ------------[ cut here ]------------
  12 [  105.470686] WARNING: CPU: 279 PID: 11511 at arch/x86/kvm/lapic.c:2057 kvm_lapic_xapic_id_updated.cold+0x13/0x2f [kvm]
  13 [  105.470769] Modules linked in: kvm_amd kvm irqbypass nf_tables nfnetlink bridge stp llc squashfs loop vfat fat dm_multipath intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd wmi_bmof sg ipmi_ssif dm_mod acpi_ipmi ccp k10temp ipmi_si acpi_cpufreq sch_fq_codel ipmi_devintf ipmi_msghandler fuse ip_tables ext4 mbcache jbd2 btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy as    ync_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 linear ast 
i2c_algo_bit drm_vram_helper drm_ttm_helper ttm crct10dif_pclmul crc32_pclmul ses crc32c_intel drm_kms_helper enclosure ghash_clmulni_intel nvme sd_mod scsi_transport_sas syscopyarea aesni_intel sysfillrect crypto_simd nvme_core sysimgblt cryptd t10_pi fb_sys_fops tg3 uas crc64_rocksoft_generic i2c_designware_platform ptp crc64_rocksoft drm     i2c_piix4 i2c_designware_core usb_storage pps_core crc64 wmi pinctrl_amd i2c_core
  14 [  105.470851] CPU: 279 PID: 11511 Comm: qemu-system-x86 Kdump: loaded Not tainted 5.19.0-rc1-kvm-queue-x2avic+ #38
  15 [  105.470856] Hardware name: AMD Corporation QUARTZ/QUARTZ, BIOS TQZ0080D 05/11/2022
  16 [  105.470858] RIP: 0010:kvm_lapic_xapic_id_updated.cold+0x13/0x2f [kvm]
  17 [  105.470906] Code: db 8f fd ff 48 c7 c7 8d e8 ca c0 e8 43 27 88 ce 31 c0 e9 f8 90 fd ff 48 c7 c6 00 6a ca c0 48 c7 c7 e5 e8 ca c0 e8 29 27 88 ce <0f> 0b 48 8b 83 90 00 00 00 ba 01 00 00 00 be 04 00 00 00 5b 48 8b
  18 [  105.470909] RSP: 0018:ffffb13a436d7d40 EFLAGS: 00010246
  19 [  105.470913] RAX: 0000000000000030 RBX: ffff9f0372c98400 RCX: 0000000000000000
  20 [  105.470916] RDX: 0000000000000000 RSI: ffffffff8fd59e05 RDI: 00000000ffffffff
  21 [  105.470918] RBP: ffffb13a436d7e40 R08: 0000000000000030 R09: 0000000000000002
  22 [  105.470920] R10: 000000000000000f R11: ffff9f21c5c2fc80 R12: ffff9f0372c64250
  23 [  105.470921] R13: ffff9f0372c64250 R14: 00007f9ac9ffa2f0 R15: ffff9f0344da7000
  24 [  105.470930] FS:  00007f9ac9ffb640(0000) GS:ffff9f118edc0000(0000) knlGS:0000000000000000
  25 [  105.470932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  26 [  105.470934] CR2: 00007fa34c73c001 CR3: 00000001b71a2003 CR4: 0000000000770ee0
  27 [  105.470936] PKRU: 55555554
  28 [  105.470938] Call Trace:
  29 [  105.470942]  <TASK>
  30 [  105.470945]  kvm_apic_state_fixup+0x85/0xb0 [kvm]
  31 [  105.471002]  kvm_arch_vcpu_ioctl+0xa01/0x14b0 [kvm]
  32 [  105.471080]  ? __local_bh_enable_ip+0x37/0x70
  33 [  105.471088]  ? copy_fpstate_to_sigframe+0x2f6/0x360
  34 [  105.471099]  ? mod_objcg_state+0xd2/0x360
  35 [  105.471109]  ? refill_obj_stock+0xb0/0x160
  36 [  105.471116]  ? kvm_vcpu_ioctl+0x4bc/0x680 [kvm]
  37 [  105.471156]  kvm_vcpu_ioctl+0x4bc/0x680 [kvm]
  38 [  105.471197]  __x64_sys_ioctl+0x83/0xb0
  39 [  105.471206]  do_syscall_64+0x3b/0x90
  40 [  105.471218]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
  41 [  105.471228] RIP: 0033:0x7fa356d19a2b
  42 [  105.471232] Code: ff ff ff 85 c0 79 8b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 f3 0f 00 f7 d8 64 89 01 48
  43 [  105.471235] RSP: 002b:00007f9ac9ffa248 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  44 [  105.471240] RAX: ffffffffffffffda RBX: 000000008400ae8e RCX: 00007fa356d19a2b
  45 [  105.471243] RDX: 00007f9ac9ffa2f0 RSI: ffffffff8400ae8e RDI: 000000000000010c
  46 [  105.471245] RBP: 0000561ce47ee560 R08: 0000561ce2351954 R09: 0000561ce2351c5c
  47 [  105.471248] R10: 00007f9ab80037b0 R11: 0000000000000246 R12: 00007f9ac9ffa2f0
  48 [  105.471266] R13: 00007f9ab80037b0 R14: fff0000000000000 R15: 00007f9ac97fb000
  49 [  105.471270]  </TASK>
  50 [  105.471272] ---[ end trace 0000000000000000 ]---

Best Regards,
Suravee
