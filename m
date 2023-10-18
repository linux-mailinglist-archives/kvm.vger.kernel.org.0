Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8437CD79C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 11:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjJRJO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 05:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjJRJOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 05:14:55 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3304EF9;
        Wed, 18 Oct 2023 02:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lG5XwWiBEc0xl3x1G6ZF4lnW6axuxFcEMIlds8kJXWmxQOIlfgsBSR6H7YcjhsV3TpxKh6kq8q77kVfZ8x9RW/cNNig23/ehTaRSF8tj6wx2IJAGCLWn2WWhxV+MjuznHERrXdzpdcZuXXNRZLe5Hm/hakZKI70kTY2t81+U1LAAjaV9CCaIVjgNtJWKSe0Kupq2pTx4cUr1mQpReGUxk5KGJfze8KlvQYbEQYs4nqGKFEQs2E/u6nI+9NUT8AcXWJGbgQn4qjZrEruUIwp3yYLPeed3Y1VFq7TZHUU5q1FWqwpi/VhQGIGqsTDZcpsPg3BLCb87pM4jW3NCdEl4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFUF8IS0A92Pfl4U59nln7Atqo3oTBrxvTsHb8gTobM=;
 b=VD6RJWqPlXFzbs9DGznRUtImm+SzlOglFCrEm6+BKpDlLWH/1wsFcwX0pgTYKP1dYCdtTifhzc4hdeAFq0Tdo2zCfHZn8F+Ke74OUv6eUFq088LBJdZqQWggEoaZZWnZ7OnBACpFR3m6ZOjPK8a+N81EKtYJEwQY+XIL3uatlhWBD4QUo2KrqwCbrUhuJSwAu3TmS9ogtjiAc6IhlA5s6K8cSKkI0QjgQuGgpDNGnqwG0/YvGAlfZFiWidzYvnaETNhJWplPzDbeVyyKDUOZU+vzXkaHoAn1+Sr6o2+VLXNCHgt2CItdTxhM40vLX4rqSK5VR2FhbluK8fjINyASIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFUF8IS0A92Pfl4U59nln7Atqo3oTBrxvTsHb8gTobM=;
 b=o+1Nb/Skp0x3rTojW8HlbqtjBiO5QkUBZUTsHJtSqj0MAevLSj1lkVDP/+ua/iFZPiB3GFJ4So8jV3KfeNfDW+VugsB0u0PsLTjBG7mGP0nBxGLovypcwVi13ZVzt/jXfWz26YyL+XIzM8qEPSBM1TjMe0LX41N/zJzh+XJGj++15oHzne3t2+AG6pX0H24hP5PczmeaT5E6BVixqbbdoZePPWlcSWkXLJyyh5Z1MgAc76MW8/Qv+lzX+rdmarW2ohlKueRBPOAlrhqLi9RcVpUI9QCA2Z0X5D4QPVfOYnUQnnrqQNJ8H4GUY+zge7gDyW88yfFmZbF0C1330A3kyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM0PR04MB6945.eurprd04.prod.outlook.com (2603:10a6:208:17f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 09:14:50 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 09:14:49 +0000
Message-ID: <4a8b6084-bd4b-46cf-b0b1-396684e7a7b3@suse.com>
Date:   Wed, 18 Oct 2023 12:14:44 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0062.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::39) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM0PR04MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: 303afe10-3e37-43ca-697d-08dbcfbaadf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DreYfaa9fj5cIwmXUCQriuvEODlXSlDXHAd2kGxRaTwzVD8Y86waAPgPjrxtgLdE2kQ6VXeBhP2Tpm6LFGxExkQsRfVtyeXbw4K9tnOlRO/LCpmPiFi1JdZbnXeYENHla7LqfRAL3Ml7MF3Zns3PZuvfcpQxzwOHwpSu/ru1CSSjH0mJZxbouHiQK3iIyEugOnAgiJEG9C6vQ+hIwaKDcXQjwWNgbEUDnyQu+QstGeGFegntX0bFTho4UjzvUzK3YakTDcRtgdoObLG71xxKHEooRXPLj1YJwxyznakC9F1ZpeJpMeLwetFkSQF1bjmldmF/dkYyDFn03IO+LlP4/iVuWPjf73GfKcEmHjXAxf+J71b7bzEn9y6HGVsGFPUqNkJC+PV025tRqKHtwIwp+dnRQb5yci7b+dN9tqPlMTABEAr+YWqGL7VdnSQdtmKjxn3yYQQTO56XOYelDQECHOm/cpHmc8ezBwOqPRq8Jwn2UyNmatv/vce9kpUkMtCTXupA4cY1/LSx47sAsm36M0Ti91YJefbR4elpp6O85Y9zrrg5Fy3/BjPBciO0If833NWcsacGirT7GUhb+ICRVIB0OSeK6ARSxsXBUQ8g1/F5g2uvOct/Mx/Dd9kd1GO23QO79Hb78kWzmRcljo1YHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(6666004)(6506007)(6486002)(478600001)(6512007)(316002)(66476007)(31686004)(36756003)(83380400001)(2616005)(66946007)(66556008)(41300700001)(38100700002)(5660300002)(7416002)(4326008)(8676002)(8936002)(2906002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3FIQTFLelZKanBKZWEwOGhEMFVoMVdKcVBHZ1RiR0RYWGpLYmlvZVgzQ05W?=
 =?utf-8?B?RWY2S3hrTTFwZ2FsemZJVjhrRlVoOEJoYXkxeElHN2hxaFhzWjZ5OTlLdnA3?=
 =?utf-8?B?cXJLNDVZLzZqdjE1QXZ1bkQ4L1pLaiswekJGZEs3K1ZNcjlsaU5LWVBwYnFJ?=
 =?utf-8?B?MDZYdTkvZk5aNlFMMWsrTGlwR3pyVFJlVHhFc3Q4Tm1LcVBvSVRYeEgvemxn?=
 =?utf-8?B?NEtyd2FLR1RGa2JnK0Vxa0RCRlgvMlRMKzBDWEpDMFB4QVZzS0syWTNDa1hP?=
 =?utf-8?B?RTVQcUUxRXJNTktlTVNKcmtpZWhGZ3FSbGxDMjhVSkU0SEtXOUx6dXAxSTM0?=
 =?utf-8?B?cjh4UTVheFRORzlRUEJFV2VPby8xSk5LZ0M5dzU3SFpXVFU1cGZvTzJoSzZl?=
 =?utf-8?B?MW5iaWFyVHJ5dXFnZ2JxOVZaQXBLZk9kbmZnQytGMFI2QkFHVHZpYlhZUlU0?=
 =?utf-8?B?RUI1Uk8wc25vZ0R1bExaRlJVdEhKOGNxVEpmeUQ3ejJqYlFvektTZ2NBWjZD?=
 =?utf-8?B?cFAxRGtuSlFzYjRsWkEvYnI4ODVkU1pTL01zaEgzKzIzRm5maklDT3dnT3ZP?=
 =?utf-8?B?ZDhaT0hmRUZhVWhkY1hDRFAyQ1FYd041Rm1oZG9PMVluR2hNOS9TZUgyR0Ro?=
 =?utf-8?B?cnZMZDlkWUgrRVRUUGFpdFNGT3o3YTdVYk5aYkJTZy9MSWVaQzJTTmdJMlVM?=
 =?utf-8?B?bHBaQ0o2d1pkVzEvTlBYZ2E4a01qOGh0QnBZQktYZlhiTDJKbVVpMGRmRWlq?=
 =?utf-8?B?SWttLzVKVjlVcnZWZVBrTktvOFBqL0xMQ0JBNXZBalhwU1J3UWZad1dHWmhP?=
 =?utf-8?B?WTBleStjYnZJckhVMVRxQUxCTXZGTVpwUHFoQ2tET0VHcHVJL0IzYmROWEEz?=
 =?utf-8?B?b0c1UUdaNkpuMzZjWVc2SENYM0ZWWHgyaEE0UWVlYkx6cXBBYlZ1YWpjOHpI?=
 =?utf-8?B?RXozaFpnOFhEbkhkb28rdG5ieEtLNTFyWkxSTjJuQ0ZzUmlxZ0FXUllUUUVa?=
 =?utf-8?B?RFJ6UHZZN0RWWWE3QXBXVzlrYm1OUjZMTTF4eGhtZ3M3dWVNMEx5NG03T1oy?=
 =?utf-8?B?dkcyTHMzVFBxS1VlUGE1SytKU3hHcFhLUzdBMEJxU2NnVlFZdjdMK0VqTE9L?=
 =?utf-8?B?YlNSUnFTVEtmd2U4d0xJTVhrcjNwRkZ3SHZ5Vm84UlJKS2x2Vm5lR2x6c0li?=
 =?utf-8?B?OUZrSlNUdHVRYkNsUVhUT0pIUkJrWmNubjUzNDNsK0kzVUVieElQU3g4Q3pD?=
 =?utf-8?B?WWphZ2tCUW1rSkNaTE5HUkp2c1o3Zm5CR1hUa1piU3JtWkNIdTYxM0JkcFV3?=
 =?utf-8?B?bDk0MTFoNU1UM2UvSU40VGRsRVZqOXJncS8vR1RBdENaR2VPMHFjZDB4Z1Bk?=
 =?utf-8?B?REFOeEtxTDRuUEpkbGtPSUU5MEMyN0cxSVBXWEtlbXZvWm9LVDFWSytla053?=
 =?utf-8?B?SDMvK0tTbHJWVzlhM0FWaHJFQ3Q4dm81TXM4OHdwaHFNeVhySlV5WktuVTMx?=
 =?utf-8?B?WkRyV2tTQ1lZeEowRXBJQWt1Z25UQndmLzU4NWFOMk5OTGJYT2xjcWFRZ3dj?=
 =?utf-8?B?SWp5S1VPSytCaU1qcVVGRzNJVW8wd0RVRkQ0SVA4bzQreE8wdDQvSGxQNVFv?=
 =?utf-8?B?a3NNcUQwQWV0R3BHbnFKS3BZUTdlV3lpZ0JIdlpYQ0JYZGJySmVJWDVTM1U5?=
 =?utf-8?B?cm8zWDlhYlYxYjlVOGM4WDJCbnJINkhtRXcvSGE1RXlrQTRxdlJDQmtYdC9W?=
 =?utf-8?B?QzllU3RuNTJZMlpLNGZDcDA4bzJsMlFxMTFNbmJMcUpDZDlQRjlkWW1vV2JX?=
 =?utf-8?B?RzVQVWdIRmIyald5aXJMRTdoT0xOeXIyMjhCeXJhekx4cTVNSmJKcVNRYVVw?=
 =?utf-8?B?N0JSVllUM0xFVVBYT3hCSEVPcjN6ajVtWTlWMGF1ZVk3dHhqNUkvUGM3aDJW?=
 =?utf-8?B?b0l3ZnhEc3ZDUVQ1Ni9Wc2l4V0RyMlRVeUxMZktHZWlkZkV4aGV0WW5MYmw1?=
 =?utf-8?B?eTNWQXJzTmg2VWg0Y1pPejhFaTJsRnkvQ2dKQ0NPeFp0SE40bjR5UTVNekxk?=
 =?utf-8?B?ZUZyZFpjSktPaGZrYzZIVkVSSk9rMWhDU2Y2TEwwZmFuSDRKY3JpQjAyTkJW?=
 =?utf-8?B?RytnbjJLS21IanM0K2J5Qm9Xa096QjZmeUFvSlI1dUk3N1piZkJ1NGpiYURR?=
 =?utf-8?Q?bw4IhLBLta0ViBcN8RRewlPPG74J2PfTI+bu9RAyvZXa?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 303afe10-3e37-43ca-697d-08dbcfbaadf6
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 09:14:49.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzPDzA/zrDAkIByah87alSE3xe70r4RX31wlp1pY6ObaE1M3LRCBXWwXHTKjruGHKR7lPjIrJ5/cbNrTs1FXMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6945
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.10.23 г. 13:14 ч., Kai Huang wrote:
> To enable TDX the kernel needs to initialize TDX from two perspectives:
> 1) Do a set of SEAMCALLs to initialize the TDX module to make it ready
> to create and run TDX guests; 2) Do the per-cpu initialization SEAMCALL
> on one logical cpu before the kernel wants to make any other SEAMCALLs
> on that cpu (including those involved during module initialization and
> running TDX guests).
> 
> The TDX module can be initialized only once in its lifetime.  Instead
> of always initializing it at boot time, this implementation chooses an
> "on demand" approach to initialize TDX until there is a real need (e.g
> when requested by KVM).  This approach has below pros:
> 
> 1) It avoids consuming the memory that must be allocated by kernel and
> given to the TDX module as metadata (~1/256th of the TDX-usable memory),
> and also saves the CPU cycles of initializing the TDX module (and the
> metadata) when TDX is not used at all.
> 
> 2) The TDX module design allows it to be updated while the system is
> running.  The update procedure shares quite a few steps with this "on
> demand" initialization mechanism.  The hope is that much of "on demand"
> mechanism can be shared with a future "update" mechanism.  A boot-time
> TDX module implementation would not be able to share much code with the
> update mechanism.
> 
> 3) Making SEAMCALL requires VMX to be enabled.  Currently, only the KVM
> code mucks with VMX enabling.  If the TDX module were to be initialized
> separately from KVM (like at boot), the boot code would need to be
> taught how to muck with VMX enabling and KVM would need to be taught how
> to cope with that.  Making KVM itself responsible for TDX initialization
> lets the rest of the kernel stay blissfully unaware of VMX.
> 
> Similar to module initialization, also make the per-cpu initialization
> "on demand" as it also depends on VMX being enabled.
> 
> Add two functions, tdx_enable() and tdx_cpu_enable(), to enable the TDX
> module and enable TDX on local cpu respectively.  For now tdx_enable()
> is a placeholder.  The TODO list will be pared down as functionality is
> added.
> 
> Export both tdx_cpu_enable() and tdx_enable() for KVM use.
> 
> In tdx_enable() use a state machine protected by mutex to make sure the
> initialization will only be done once, as tdx_enable() can be called
> multiple times (i.e. KVM module can be reloaded) and may be called
> concurrently by other kernel components in the future.
> 
> The per-cpu initialization on each cpu can only be done once during the
> module's life time.  Use a per-cpu variable to track its status to make
> sure it is only done once in tdx_cpu_enable().
> 
> Also, a SEAMCALL to do TDX module global initialization must be done
> once on any logical cpu before any per-cpu initialization SEAMCALL.  Do
> it inside tdx_cpu_enable() too (if hasn't been done).
> 
> tdx_enable() can potentially invoke SEAMCALLs on any online cpus.  The
> per-cpu initialization must be done before those SEAMCALLs are invoked
> on some cpu.  To keep things simple, in tdx_cpu_enable(), always do the
> per-cpu initialization regardless of whether the TDX module has been
> initialized or not.  And in tdx_enable(), don't call tdx_cpu_enable()
> but assume the caller has disabled CPU hotplug, done VMXON and
> tdx_cpu_enable() on all online cpus before calling tdx_enable().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


With the latest explanation from Kai :

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
