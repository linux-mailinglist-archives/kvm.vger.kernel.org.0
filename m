Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200EF76B35A
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjHALfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjHALfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:35:30 -0400
Received: from mgamail.intel.com (unknown [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39A1BB;
        Tue,  1 Aug 2023 04:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889729; x=1722425729;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mAEb7v40sN9BHuizCIm2U9IwRPCYJlWRI+juBIX4wyo=;
  b=QaSTqcKOl+kTk7qCNh1vUzcldov87xHVQFNS/yo9BjwKV2CrAIveyahB
   FnIW1Qj/aPjNJglRP9BFFryHvQqmX+rHm+KxINsnyaCXLOYvf1wZXN6KR
   2jQlAZ4y6hbX8Vpocj09fhEIpZ84lZmwTgmazoryM3RmU+0wWGqbtLQpp
   0G8OuoXowdAGEmXN8dbVQF8O2WbiLAu3Qdnp/t+98+b/ZBO4oIq5siRrk
   r/7eWBQkHSdnlGvwg/Kz5SdTXjVocnEGVcZde32dBjf1xU69GNVw/5VPF
   mQ/Ek6+eCUX8fKRBKzuwf6TxHIo0gw9pHTKo0l7o/1rNZzMvwEBDURACU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="368170645"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="368170645"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:35:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="818768315"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="818768315"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Aug 2023 04:35:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:35:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:35:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afYRwBOfvCT1Xf7Ci5h/7B2/+heVw6oQ4kRPNHT5ewZaw+PBSEsPvqh5XG6+Bz2rarxgVFx742t/ELu7I0WzlsFpWttfrF1SgBB5/n+zfRCRb/Gh3vZ9LqrDKRWBCa1JQYSt8MtfBmO/TFNn4A5iW7ZbVsTFv1fok5oRsgEN7aE5sh4yHwS3KdC2nJS2k0q/PD/mySijYIH65ojDJohQVlMjrfmI04TbJJvYvZ6O/NeqIBr0o4lfiS9F8VarPbVphd3F0aJuP9NQSRI50OM4KrwXZMYefwOIVI+zB70iq7y+S3JDdWMXb4RjMS7UjU7est+IDdcYw2V0ph7bDUODXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyX5QUaMmcc79GefGmN9oHSCok87kdvlpz6j9+iOljc=;
 b=m7ORWC1fcZrbUP3+HEA81hkncMuHW9mZ+69QyVe0YPRBFarFRx23bYnzghJ6qQvjvp9tGc1Ewu70Kf/5H2m6EsSxHMGCY5f7hbPt8Z+FdG7cxqKvWz3RPMdO5C4FhNRac8ZqVlCY3YJ9KaL6doaBiIumbw49MFVgige75xIHWBW3Mzou9wOiqc2/I0cgL9lW+Ci8YQblZq2wH9xpKWsII+/uCAzqq/UBe6i7RR7r8uHzzfYNy2P29dl5VJ6gjHZPPTzK7bKiSagtFwjjoINT8YySwlmbOOkXypUVqzVFjpjc79x7df0cTFPHuO2Om21Cs3oamhXBuTdfYfw4Hz9oTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Tue, 1 Aug 2023 11:35:25 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:35:25 +0000
Message-ID: <06334808-be59-4949-fac5-022988639adf@intel.com>
Date:   Tue, 1 Aug 2023 14:35:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 15/29] KVM: drm/i915/gvt: Drop @vcpu from KVM's
 ->track_write() hook
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>,
        <intel-gvt-dev@lists.freedesktop.org>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-16-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-16-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::7) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e169212-dfd2-4b80-853c-08db928365d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6/HJ54lWjw6Dpd1rJlMx4Ml4k2ZHqIfb0+zSlA4jrmA/G7cqS5GScGtfrZYkARFZdpMLNVh2kX8+3WHTOQ7m4XMbal2JrN0I8wOBhrvYmRqgtjMnHj43lHO3JNXCA//tV29tlfCkfxr83g68gjBt5pFmJ3MmeKtcH1m21CaZeCY0IP1kBefDLSldHeV5s810UMooF4Nu9inbFLKSBD78L2bQt9K4iyu1BLCm9b7uwYTXdMlW2PHvwDir2X3M+B2icWFjBzJ0I7NSIG1ZNMCw5MGh2St9+v3eTjvqDh4XDlvy0mbl70yGOH2KEay5o0Q4sZ4L8KL6WPbFC+TDlgdwGoR0gDCYiHqL6LrDvIk+ankCIMB7zXai/G3bpsy17Wcl7eFKVdZQp/+9Mc69VNfUfixYKvhgz46qQjxHlUgnSNDtnIGnMHu0A3q8dGS3kJT63tzzC6fu3B2S66+lmSJs4Z9ZKpe+d05rU/sA+E2ieB493AKzivv7U8YiDqS++xdCpd8bDyH1JVErUo6ORcY5XVearGHDLcMrC1iiU/aWYR8JLYOUsAplb2APzI/bpYOZ87C7jTVYiUgXw+0klIM/5bdrSd1amSRwd1rH1sYnamLaDY9zTNajJxazYiOI/FcDxa1BbzqpoO6qlQwbOK1Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(38100700002)(82960400001)(31696002)(86362001)(36756003)(6512007)(478600001)(6666004)(6486002)(2616005)(186003)(26005)(53546011)(8676002)(8936002)(6506007)(5660300002)(66946007)(66556008)(66476007)(110136005)(31686004)(54906003)(4326008)(316002)(41300700001)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHJpOE56Q0dITWpsWitUZnZ1R2dHMjRqWFhkU3JjUFgzQUJ5VkdiTXZUZlVa?=
 =?utf-8?B?bFpicHl6TGRrSUdaZkZIZFJXWHQyOFRYMFhRQkZEckdHOXFZdkpFWGtpdTVO?=
 =?utf-8?B?UUxCSW5qVTY3b1pWMEV1Sjd3UDBBaFErVEIzWkhHTnhxS1RHdWk2K2pkWGU1?=
 =?utf-8?B?a2c5NFBRVG1IdmdtUHJ3Wk1BYjJRNnEwV2hCOHhoVi9rZWMzQlBQd0F5MWlM?=
 =?utf-8?B?cWY2ZXVGYUVkVURZQkRhRWpUczBVTWtDeXZJVGlOeHJIUWhOWXNUbTMyN2RT?=
 =?utf-8?B?MVhlVkYzdUVuWEsrd2VwR2pXRUFLTWlJTU9pOXdMK3llQUZ5QXptak1sQTF4?=
 =?utf-8?B?emI5ZE5Pb2FVa3NHV0s1a0NzdHYzaVd5TXkzSUs3c2U2K2FaejExRDVUQVlW?=
 =?utf-8?B?aXZrbXA4cjBkcFBzUlhBcDQyTUlXYjYyOEE3VENsNXZ4TXYxMHZsLzA1VkZO?=
 =?utf-8?B?VlJKZTh1cEtjdkozOWVnNVEzOTNPaGVxL0VQdUhDZStTVGUwNE1memw3N1Aw?=
 =?utf-8?B?UTR4cW1meExZeVg0UEVSMmJMMHkrTEhwNzhleG1jZWp0OVBjUG14MS9wKzNI?=
 =?utf-8?B?eHFWTDdXVGdnTWgwaWZyUU5HckdadzlWaHc5TXRQbkdTT1V3SGZURFRJVy8w?=
 =?utf-8?B?MVpsYkxlak5NRGY4aHQrdmZxTldQRzlIR3QvbnU5eForYXJmeVJTVGZka2pw?=
 =?utf-8?B?VERkeFk5RDgvV2RyUkR2d2l0QXVxNERnL0tuK2t4a1JYV2VQQ3VJY3Ftc2l4?=
 =?utf-8?B?WjRaNDZIS0pqaWVwMDBNeXduUVhMMjBsbFJCMGdyK1M0emFFNC9hOGlSRGlp?=
 =?utf-8?B?Sy9SVzVnSFNmd1VlaGZBTVhKdTlibXhKVVFxNmF0SE5TQUliRVdQVDdjaDd4?=
 =?utf-8?B?NzR4Uzk5YS9vdklVdzNYcXhzTUxCTXkzMnRrRmhSV2w0TXpQTmRPelZPMzFC?=
 =?utf-8?B?UWVOZTh5amhKQTdEVDhQcFpIUmRPMGEzU1lIZjZzYXF2dkNMdWxGRzhsaVB1?=
 =?utf-8?B?ZlY3OFlTZWRCbEVFZEczL2NlT2JnMXo3NnVRRUN0bDZyRGZvRDNXQVhwQXY1?=
 =?utf-8?B?RjVSQWxZZ3hNZkVFUE0xN3l0ZVpMN0U3VzNSdFdyekRiT3dNVEJTTWxxZW5p?=
 =?utf-8?B?M3l5RGdRV3FvOWZsSVEwVHhvUFNhMHFLdnlZWW5SN3RieE5ONG45UldMZW9N?=
 =?utf-8?B?UnNkbXlGODg4L1pLczgrTmc0VTVaL1l2NU5FTjdCS0gzdDlOcUV6QzJnNGZX?=
 =?utf-8?B?d0lON2VEMDZWUU1xZGpzS0tyeHdoWGltb2F3ckk2NElldGpIRUgzUUZLKzJn?=
 =?utf-8?B?SG5aVHZ0MEEzd0xaRytUamF0MDYyV05hL2Voc1A2SW0waHA0TEx2ZCtzYWFZ?=
 =?utf-8?B?dHY1eWN6UWREQU5scnZPakhxRjNvVDdlMVlCUmRWc3Y1TE14d2c4cUZKUVdV?=
 =?utf-8?B?S1FvQ2F0ZzNQQzdhWUl6cUozYWIzeThDUjgvZDRnM1dlM3BRUmRHTTRqd0Rw?=
 =?utf-8?B?RzRXVFRZdllCVEVYajZraEFpa2NCc3dBVWllV25QbHM2ZGV2VlR2MHlaeGk4?=
 =?utf-8?B?WjJXWC9iYUNSTGtBZU9RZWdlR0RnNm8rNWpzVm16QWQ5cUttVHNjNDRtSkRO?=
 =?utf-8?B?V2VLT1VHOUdSR1pMUFVGZzMwZGoxZHlHYzU5T2hNUGR0RVlzVDJ3aUxwbTJm?=
 =?utf-8?B?QlI3K0xnWFlXVUdrdUZXT1kvQUFCMnFPTU9ueTREMFhPSTcrV0NNck1qL3V3?=
 =?utf-8?B?aHgyc1hUc2JNaHFzSU02ZjhiR1hmWUtSU3BVM3V2STZ4R0pXV2w1RWxsZVlm?=
 =?utf-8?B?TXd3MzkvR0lzUjRuUzZock5XbEQ3TFdhNVFVcDE3NlFhcVlMbkJIQjNJZ0tn?=
 =?utf-8?B?RWE5WTVRV2V0dTFuaFhpcC9VNlpuQnhKOXJHMEIxWlpMUUVyS2ZhbTIzRnBk?=
 =?utf-8?B?Vnc0STJQUXp2Y3lSTDFjUkZKV0J2cGliUDFKL3VjSDVYYjV6dFdhU0h1ajhV?=
 =?utf-8?B?UWI2aTVIMkwycDA4SjRCK3g1bmxRbzN2QW5LVTZPRlVFRjhGZVIveFgyb2Vn?=
 =?utf-8?B?WUxlVmlwd09FRHRtTU8rQStkL09uUTJ5UytkaEVwQ1djK1BkaEp4RFBlQzN2?=
 =?utf-8?Q?hBuRjvePd7b37Hd9jVCjBZqsX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e169212-dfd2-4b80-853c-08db928365d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:35:25.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4fQ6/5KH6yeIoqF/fLyOZjlV85g08UGXYqpjUqLjaro64Zb0/Xeje0SiFqXE9NRElCkczKcbBI7ldJfKf126g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Drop @vcpu from KVM's ->track_write() hook provided for external users of
> the page-track APIs now that KVM itself doesn't use the page-track
> mechanism.
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_page_track.h |  5 ++---
>   arch/x86/kvm/mmu/page_track.c         |  2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c      | 10 ++++------
>   3 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index eb186bc57f6a..8c4d216e3b2b 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -26,14 +26,13 @@ struct kvm_page_track_notifier_node {
>   	 * It is called when guest is writing the write-tracked page
>   	 * and write emulation is finished at that time.
>   	 *
> -	 * @vcpu: the vcpu where the write access happened.
>   	 * @gpa: the physical address written by guest.
>   	 * @new: the data was written to the address.
>   	 * @bytes: the written length.
>   	 * @node: this node
>   	 */
> -	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			    int bytes, struct kvm_page_track_notifier_node *node);
> +	void (*track_write)(gpa_t gpa, const u8 *new, int bytes,
> +			    struct kvm_page_track_notifier_node *node);
>   	/*
>   	 * It is called when memory slot is being moved or removed
>   	 * users can drop write-protection for the pages in that memory slot
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 23088c90d2fd..891e5cc52b45 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -272,7 +272,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>   	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>   				srcu_read_lock_held(&head->track_srcu))
>   		if (n->track_write)
> -			n->track_write(vcpu, gpa, new, bytes, n);
> +			n->track_write(gpa, new, bytes, n);
>   	srcu_read_unlock(&head->track_srcu, idx);
>   
>   	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 034be0655daa..e9276500435d 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -106,9 +106,8 @@ struct gvt_dma {
>   #define vfio_dev_to_vgpu(vfio_dev) \
>   	container_of((vfio_dev), struct intel_vgpu, vfio_device)
>   
> -static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> -		const u8 *val, int len,
> -		struct kvm_page_track_notifier_node *node);
> +static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
> +				   struct kvm_page_track_notifier_node *node);
>   static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
>   		struct kvm_page_track_notifier_node *node);
> @@ -1603,9 +1602,8 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>   	return 0;
>   }
>   
> -static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> -		const u8 *val, int len,
> -		struct kvm_page_track_notifier_node *node)
> +static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
> +				   struct kvm_page_track_notifier_node *node)
>   {
>   	struct intel_vgpu *info =
>   		container_of(node, struct intel_vgpu, track_node);
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
