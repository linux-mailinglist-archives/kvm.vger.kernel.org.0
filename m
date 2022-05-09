Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4183151FFCA
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 16:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbiEIOcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiEIObt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 10:31:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC322BB2D3;
        Mon,  9 May 2022 07:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wxrg95NzYRt35UQY0ylk0MGTV7L+HfzL1Wc6ITIH07Irzz8y5+lG85S7ZO0UNKyd9+YH/4R2KJhGpAtZj+MU/qKRWEAS3G0SbPbrUZznCzlhvFvF8+MiH3a807cXVx3dOdZP3QzJRPdKfBJkrWEDvxyaTV1scqPBUa5AIFS0QaOkY82d1BPK47gC7BjguUYAy04oofHX77F3rG1KziR8TFFuPriNsoeUMMOiG6n75xu0nm0SK4mAPdnYomqMUo0QIhzfOocozFqJ5H8K3rHfTudYHKhYL01ALMPl3ScPlE/gW3/ThzibxMnW887BZqbgadOHh68TcC3m1YzvugDMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb6tSorB2A97SHyr4TvCGp5n47wSlHX4FSicRp/WL2I=;
 b=cqHlUxZBXbt7teq6ILYiPbpdjhZi7rohtmHnHonby4U035g8B432WUDriJMur8NrtdXOfG91ClG4MsuqfJ+GXJylosznsb4rGd/xc0WfmlGb2fiSMoGmQ7fHqAFiBmoBXIM/fnaJPaArmtc88dTyhhaIXsvrKv1M6GcYH4KXvqbwi9eK9hZFVdMgnFTxalaW7h5GRzTzcVhRPEu9kRuM3v2zUCgKc/ZH+JpdHbDuEWsYR5xw3xpfQ3woREDdsG6c/TD6nEeiNxomnLM2C2qHAjxeGmInDaiyhNIg3gxWXod1zYC2OaeFkeUkO+8yBJkFXeMhtXhHv7xKNP+JdsqNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hb6tSorB2A97SHyr4TvCGp5n47wSlHX4FSicRp/WL2I=;
 b=03Gguh4tHQpap4iglP28Jg5ITyQsLp4hbzme5Sr1nhEjybJoWJFgOEx2gVCvsNe6NUMOr+8gcCix0kLKWotT0LQFPsKfSrrq1DqBQqmY6kCQeSnsfgpmE1HDAcSiAwqeJIubEXxMJ3XgwEVde4b6jwIZpigO8MLj2CdlVmpplHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 14:27:52 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad%3]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 14:27:52 +0000
Message-ID: <e02cff98-922f-7093-d674-5f81caf14a48@amd.com>
Date:   Mon, 9 May 2022 16:27:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 02/15] KVM: x86: lapic: Rename
 [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-3-suravee.suthikulpanit@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220508023930.12881-3-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::49) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c19a4c9-269b-4111-6e21-08da31c81955
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51767BE960FD35C9CCEBA6619BC69@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q46pTB9179Zahr5j2ZWRtlX6bg0magMvziVYLZgEGVWQ64a2wQhZ9gs6KogqIpJcoEKafPfMT6TMWqN0U+9R/VoVxRCwzmRJLgCzulVko4/rd1GjHQiOj7/aHGYR9NGbIKpxC8BLMJkByoPjzMKXCxXsLKQIFHw76ViEGrlYViksn6Tr3fx6ICfSFkAVccG84mtqPLWMZRAgy4O02oyqfJZVUcRP/Yr+CLwfJWu1x4wrYO6/m1eBPQySzTQHaNBiAGMCAcqDwsiVolvhbaWeCERaV94l5zwlxDKPqMpmLIvg53zZiWc7WZriRQndqCy4skS91S4KKB+ntzzkO9H2i9vkrQ0OQqY2u37sukuzHeVk5r9/vf3dPuh7O0w1ZE7GlkDM80UdS7QoY5IjhDJGPlSTMb+hYN3GWwe0Ba/jCvVMbLTiEFSm4bCFZrllN3RN4m4jvhPn/WTPLAlBZ2PmEmi6ZUdj8FXU8RxxpmWNT5NsR+3/ur6JFuXa7WdPv6ibzKWaGHUCUUxjFJl7A0cVInUyJ3qQolMEtaS3ZQ0d3B0jflT8JP2E9jxS4mUagSU3HngVtdzYCy7IzRMJruM0FojxXZ+Ukljsagm0C3CrW/bAuiT5XzCJEXoF1/LO8p5dzU8hqVlCKBsSpUBd8BDWVkFo/+9FcfYKbKPvXB94MbQEtp7Md2Q+jlHLPBULCSlQ8JvubcQGFHDY+UzNHOESVDIxkSvc+VZNk5llI9kSEGMgFA7Bh/HLoRrFhncYClXH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(66946007)(6506007)(508600001)(2616005)(31686004)(8676002)(4326008)(26005)(83380400001)(6512007)(86362001)(8936002)(5660300002)(31696002)(2906002)(6486002)(38100700002)(6666004)(316002)(186003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2JySmVLdjJad1dubXBwZVRPOXdISVcvMDVTdjY5K0d1RFRXYzN4S0hKYWd0?=
 =?utf-8?B?LytJODVsdDk3Nyt1TmZuMit6QWVDTXh4cnM4aHREY1M1MUIzRzRJNkNVUTFz?=
 =?utf-8?B?eVA3M3NCWDZFRS91bVZPNjFjKzh0cjRweGYvR2J4MkRsQUFyZkVPbDVreGZT?=
 =?utf-8?B?T0RLakZYSW5ya1lZUnREWVZwNWRqSDYrZ2U2ejM4aXRjNGplWDl2ZC91dmhw?=
 =?utf-8?B?dTIxQ0ZnNGZ5aEFZSGdWSHRJUEpQMXZjQXBHZlU3VjU1Zk1wa0ZNZzRnV1dm?=
 =?utf-8?B?cUVsazVwOElORkRJWS9PUEJpcXh6d0Y1Y2dlYlVROXJlOUNqS0dZbjNGWVhz?=
 =?utf-8?B?eHlRN3RlZmlwRTQwSlNBK01SWkk3Q242UkhFb1hpdXJEUEx0VkxtUXFaT3ZJ?=
 =?utf-8?B?UTdBUmR3QmROU1hNMy9KY01vY2NhQU5IbUpRY0lDdzhYcnUzMUdLWFcwN3c1?=
 =?utf-8?B?VDhLbHRIMUNpOFBDa3c1U0xIQzM5Tk1ocnNxbHBOODJBRGFXK1RRTk9vN3cw?=
 =?utf-8?B?UGV1RjB1WlBwd1RXdEh5UGZOZmhITDhJZ3N2KzBJTitPNFhHdFlYRjdnTXFR?=
 =?utf-8?B?L1JSdm1MV3pmelUyUGZBRlF4Zzd5a096VGFDOVVuL2R5VnBqYzlWWm0xbktO?=
 =?utf-8?B?TVg4dXpRRExZeTdTbjdqamdhaXhnZis3RnZkeWxJekJBNm9HbXlncURYTkpM?=
 =?utf-8?B?bHVtUzJNN1ZQSG5iS09wdXd4NzczcDA1RzJiM2VxdjYrODloZWpteUZubWNX?=
 =?utf-8?B?R1VDckI5WDc1VHJxbUJIUGwwQUMwbTlUMEFUK2dOMmZ2aUluMmpxSWhSM3dZ?=
 =?utf-8?B?bWtsOGJFVFZ4WmN0WUFOalllUnBPdFdaU01KZ29Rek5ka0R5TFNLeXBqTWpt?=
 =?utf-8?B?SzFpcGI5d1FNZDZOVFZsVW85OUpqbmdWTVg5Nk9rc3dqY3dFTlR5NWppUzJE?=
 =?utf-8?B?R1NCa0xUV1hJTC9HOFFKR0VnSTB1TSs5ZXYvYzZETzBQdmZnVWN4RGZxeXE1?=
 =?utf-8?B?MXE5YWFhWUg5T1BiK2c0czVXKzdVcldwYnJ0SUJoV2RPNmhiUmRmQVpnT3RT?=
 =?utf-8?B?N1lIV3k4MVhmRVVFd0JZcitoK1BIbEZJemJlcUZ1TWI0b1d4Tko4Zm1yWEJX?=
 =?utf-8?B?NGEwWlg2SHBla1BiMVZkNnBVWHV3bU1xL0ZpWWI2S1p5VjJJVVcwTzJBL2Y3?=
 =?utf-8?B?Q3lUM3hkenJyeVAyc0RpRFJkRThJZzZ6dFQ2OExEblJ6M0VLZzJMYVh5WEZl?=
 =?utf-8?B?SENPdjFGUDdQRyt2S2JSRU8xRlFwS1cyV2t1YW1PeXFJVldQak1aQUFFVjhh?=
 =?utf-8?B?YkxXY3dESWI3U3JFQXU0bWtoVXZtbVhIZXQ4N2I5cGFGeGl5WGxhK3MwN2to?=
 =?utf-8?B?bkFEQU1RdTBYbkNBMms3WEdyOUVLZGthMURSV1lEeXg3djVjWTljeGwwM2VC?=
 =?utf-8?B?cTBzN042YmU4VGJwTXpBc0xwY1lHUVovdTYrdFQ2eEpzTkk2a3g3dHNwaEtF?=
 =?utf-8?B?V0toYlZHY0dqWW5VTkFlb1hwQ2FnRHBkYTZFWDhaKzBRbXQzUFUyUmpaSjRw?=
 =?utf-8?B?WHYvaEpRVWRxZC9YcmdDbUhjeU5KODdEUzNzanB0eld1SkpFVkdMaTNqTVhK?=
 =?utf-8?B?ckN1TDFlMFZCMzlMTDQwa0lrdFRHRW5CYUhRbjVZREc3RUNGeWFBL2pwanU2?=
 =?utf-8?B?UUsyMmdYR01mME00KzhVdGwzSzNOTWxiSVVMMzhEeVIzejgzbG1pRTNZWUZ0?=
 =?utf-8?B?Ynd0TkErdFVyLzd0eEIvY0gzdUJqTnYrRWs1bnNqa3ErdWtiUGdqTE8xZDZk?=
 =?utf-8?B?K0J4QytvSjd5cEcrZWVyZFFod3hsSEg0WUFrKyt2eEdRc2U1RW1ROC9HTjFB?=
 =?utf-8?B?RE1od1hiTmprU1czV2N1d0JqSEZGZSthUEFrcXJxY3ErMC82WmtTNlZ2YzFt?=
 =?utf-8?B?eElmbXMyQkVGUjc1MFNNTm5jS3dhVWZ2Ly8yUWoxVGdRYzV3TUdxbkZtZ012?=
 =?utf-8?B?K0s3b0RDSzJ5U1pjTEwxR3BHT1NlMHhHdmpuY3U0NGJTaWRpTldFZlJ1YWxn?=
 =?utf-8?B?RlVQR0ZtMzJzMTlGNXoxVDd3czErQzRUZ1Bka1hpZUdPUFlwZStQbVY1SHky?=
 =?utf-8?B?cEhTZ002QWsxanpFMGpKNmVGMzY0RmVhV2hYOXU2UzdBMVAwZXZTQnorVGV5?=
 =?utf-8?B?dXJQVWprY0piOXFPR3ZscWg2VEFnQkUrR0t1OTh2M1U2S2I4REYyUmdTWER3?=
 =?utf-8?B?T0xQbnFjMWhWRU15dlhRZTl4RS9LajBzY0NXMTVhRHJtZ1QvZVg0M2JSdUMy?=
 =?utf-8?B?Nk1abTRIUTB1allCQ1Ryd3l0MXYwWnFSbkZUbkphUksvRWZMaHNZUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c19a4c9-269b-4111-6e21-08da31c81955
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:27:51.8970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gRfUN6NRNnOGHMqeH6X1pAZwNcdZKxcrFxnz7DAbdxTnm0QjfzP4J/qYiq8R0PoYN5jxnc0DjgEsxKAm2bigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> To signify that the macros only support 8-bit xAPIC destination ID.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/hyperv/hv_apic.c      | 2 +-
>   arch/x86/include/asm/apicdef.h | 4 ++--
>   arch/x86/kernel/apic/apic.c    | 2 +-
>   arch/x86/kernel/apic/ipi.c     | 2 +-
>   arch/x86/kvm/lapic.c           | 2 +-
>   arch/x86/kvm/svm/avic.c        | 4 ++--
>   6 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index db2d92fb44da..fb8b2c088681 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
>   {
>   	u64 reg_val;
>   
> -	reg_val = SET_APIC_DEST_FIELD(id);
> +	reg_val = SET_XAPIC_DEST_FIELD(id);
>   	reg_val = reg_val << 32;
>   	reg_val |= low;
>   
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 5716f22f81ac..863c2cad5872 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -89,8 +89,8 @@
>   #define		APIC_DM_EXTINT		0x00700
>   #define		APIC_VECTOR_MASK	0x000FF
>   #define	APIC_ICR2	0x310
> -#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> -#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
> +#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> +#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
>   #define	APIC_LVTT	0x320
>   #define	APIC_LVTTHMR	0x330
>   #define	APIC_LVTPC	0x340
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b70344bf6600..e6b754e43ed7 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
> +	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
>   	apic_write(APIC_ICR, low);
>   	local_irq_restore(flags);
>   }
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index d1fb874fbe64..2a6509e8c840 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
>   
>   static inline int __prepare_ICR2(unsigned int mask)
>   {
> -	return SET_APIC_DEST_FIELD(mask);
> +	return SET_XAPIC_DEST_FIELD(mask);
>   }
>   
>   static inline void __xapic_wait_icr_idle(void)
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 137c3a2f5180..8b8c4a905976 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1326,7 +1326,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>   	if (apic_x2apic_mode(apic))
>   		irq.dest_id = icr_high;
>   	else
> -		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
> +		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
>   
>   	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 54fe03714f8a..a8f514212b87 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -328,7 +328,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>   	if (apic_x2apic_mode(vcpu->arch.apic))
>   		dest = icrh;
>   	else
> -		dest = GET_APIC_DEST_FIELD(icrh);
> +		dest = GET_XAPIC_DEST_FIELD(icrh);
>   
>   	/*
>   	 * Try matching the destination APIC ID with the vCPU.
> @@ -364,7 +364,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>   	 */
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
>   		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					GET_APIC_DEST_FIELD(icrh),
> +					GET_XAPIC_DEST_FIELD(icrh),
>   					icrl & APIC_DEST_MASK)) {
>   			vcpu->arch.apic->irr_pending = true;
>   			svm_complete_interrupt_delivery(vcpu,

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

