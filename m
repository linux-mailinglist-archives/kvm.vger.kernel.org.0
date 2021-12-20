Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEDA47A536
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 07:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbhLTG5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 01:57:44 -0500
Received: from mail-dm6nam10on2107.outbound.protection.outlook.com ([40.107.93.107]:10695
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232310AbhLTG5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 01:57:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUp32wraeotx1GJf+C0whlMO0tQbIGYW/f5Ctl5wcYSib6Gg8DBNbYTtJFrAgdygeThnSlbJcv2LHB/Z/FxgDp1RebXLRbM+Wpf+a08ZhJL5UJc9t211uPSJlWtrIjxLMnDcGREbvCiYxMkYUsFZ37k4MR2Ly2Hi87nVaT8FVvEjdpdIpdl2x1gP0H8raSKdxVmRBia8nEUYTeyi6seQb8B4VwbNUwVpdTMAwaTzKWv8W3qnmlW0C5IkM8/hmgbgS2N+eFb8RLJ5J7cROnz7jx9adrJ4Vpl6eUWh1JNZbca3R4qZCLSzeBMD2zmb3QTjTVkLOnSzaiHPeC3whLjXtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oz860joWWkPvRAFAmymB9/Lwl3KNzQzJn1mSFbx6x0=;
 b=JGJCA1rs/b5MW8DKQtWLE+bK/Z/EKQwt+nDjoBvb9tdsUQF66aHm15ZWV8HxhFw0rwaGdPjBnupqaTOoEZKhXvAeZjvtiF2ElLzZKa3JVfZQi1Gp5+x6Hy9cRi9O0/WHLercJoK7T8y8DbXoCNlO3vPoK7pQQmxU1IIxjKs3XAoawlcMFTTCIxrAO6FjJoD+xiAZNZ1wWPCXixK1tFFwkuFcNU1JaLQxOoVWKOvJZtgLptRxGQxobgu1b4/pBfoDQOFg1SX2p6vds8jka26hZ1Cj09WuKN3vJYtrVBk5Pon3de1N0tAjGeRE4pO2by6hnzUPq7auF4geE7PUUKqB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oz860joWWkPvRAFAmymB9/Lwl3KNzQzJn1mSFbx6x0=;
 b=S9TZlOtR7x5//5tFF77uUPAlLWZ0CsUlCd5ak/GGjDWaMNkM9m6BvLunX3PBl5TT43F9BUHl7tl7XzOwj5OUfI1QNFTl24XQ11/i/L4vAwP8m4Cd4wlR6e3kDmdhHZsoRB8WbYQLbnk82OF/NNzEu9tBDn6phfv/cfb9Io+R1Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM8PR01MB6888.prod.exchangelabs.com (2603:10b6:8:15::13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Mon, 20 Dec 2021 06:57:41 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 06:57:41 +0000
Message-ID: <6817416a-34b6-c987-c07e-e0d773fe1775@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:27:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 14/69] KVM: arm64: nv: Support virtual EL2 exceptions
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-15-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-15-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:610:e5::29) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb6e1199-1737-4c50-bb3f-08d9c386043c
X-MS-TrafficTypeDiagnostic: DM8PR01MB6888:EE_
X-Microsoft-Antispam-PRVS: <DM8PR01MB6888AE055C930CF9819AF9979C7B9@DM8PR01MB6888.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crfk2eSwOu4GBqT2xnWxwfkSh0YxLGMlIukMQT+Of18nv1O4hKCq3fJ/or4CsdGllJz4034kjNniStUP1JKmN0zbRFhr6uL9ck8xTe9PhoaQJWTGyPH2/kSZsZoKvQMEcA7sHsxlcYs6t0mlN7CAcBAjC7DKwS/kJZzPUq0Reb8fjAwbYjSApqD2hG2bYIQinJd561O5F0iUXrORk691Mu3HWPjre6t/ET/ibQe1/Y/Wywnne3BLViXehEduOPHEex1A2Ych5iUrBVc8vWwknGHCuEif883uuSFUkAoxQja8peMf9OhMYPJ4IX+Ph4xSuXcrKaTmBikM1oZh/n0xaTVfRZCM+OwsLfeGSam59VqWAJ4oU4mR0/ej1bMAL0J5yUHSbr3WsYzy0JkCr75oWnA5CjaXdFQ0M3uE63W8Jp3a7HKZdoLZC6sWMbm1nIMxceuLaQdwv/49v8b+h9CDYm21k9pU7GrcLnPGqkE2tuJELRCteQtTu3LPTJCeLK6GSdmlR59fKYHGbM6BIRypxr44RUESETnEXlEQ9C58mTRifpVAzfPo72vSbnSvf18Gtq7eaxhHjtAhpqfguO8o13RpLjayUGHGA1GfnbtymuRkyqgmWnMY3wgSlq7qGi7/dzNNcXTw9opdLzrCWLBPbjpI56pPfV6IFCcoijSzG0YDzMZHzGmQCdj1leEpXIGw5lDVVVd0H096JKj3BdKdVnN5BdXRs6RymJj/MOa+mcd8LLBy/mQPNByJb2USf0CciIWfnnEh1nzkArtRTaUy3cp4AZhBuet8rnxXMaDMiK24bpBWRWu1dH/XxNsB8i4vWWg1cjGi6tHEwuxFOs8OUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(31696002)(8936002)(4326008)(2906002)(6666004)(86362001)(26005)(186003)(2616005)(8676002)(52116002)(83380400001)(5660300002)(66946007)(316002)(38100700002)(38350700002)(66476007)(66556008)(30864003)(7416002)(53546011)(6506007)(508600001)(31686004)(6486002)(6512007)(2004002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0g4RmMyMkM3TWoyZU5yeXQ4WFdSd2wvTVVtRHdrN1V3VWFRbVBZcU9HcE85?=
 =?utf-8?B?RTMzVW1oWlZnY0VueHYvenhLaENSK2hQTVVHMTkyRlhCWDY4U1hrWnE5UjRG?=
 =?utf-8?B?dFhueGt1czhzR2M4Z0U2NnZrRExCREM3UnNGS3FwZ3c3cUxmd05ZVG9BRkl2?=
 =?utf-8?B?QS9VWGZpaHlTd2oycVpsU0h2MkdEanpWMlB1MUk5cGwzK0tsQ0FzUldQQk9q?=
 =?utf-8?B?RDVubldCNks3eVAybWIvRnMwVVBXREorNTBaenlIcVBmTFdCQ1FwYU1iTy9r?=
 =?utf-8?B?ZVdjeUhzeWFHRC9YL2JCUVBIdTFLTHpDcGVOODY1VGNiVU5GUHlWUUtGREE3?=
 =?utf-8?B?OUN1UWFUQW5saHRkbGQ0OXJFU0cxdlkzbU8yNGVxTUxncFZMWVVOaWpjV25s?=
 =?utf-8?B?ZmxrQ01RMC9QYWNndnhyK05BRDhyS1puKzJYOFoyczlHSG9IN3pWNXI5YmFO?=
 =?utf-8?B?S0MySkcwNUV6RHVaUVBnOEtlZ0o4cnIzUmZJaDlOUEVzYUlSTkZ4TU1aTlZS?=
 =?utf-8?B?RFBnWWdtemVTMEVKSURJMHlUWFNscDRuWVFqazMycmkvVjdlZUZjVjNNK1FQ?=
 =?utf-8?B?d0k4QlA2VXhVQW8xc3ZDOWVEMm9lbm1uWHNiTzdOY054NysxN3BabGZHcHJJ?=
 =?utf-8?B?MDRDZ3ZYODFkMGVBbG9seW42OHJ3V0RidVFHZVVuRW4zNlkwbHUvcFdWQ1Z4?=
 =?utf-8?B?WlNnaGlZMnpTRmpLT1kxUTZrRVFDSnZQN3V4cW5ZaGtOTFRtT3BCUXFtNHBL?=
 =?utf-8?B?dTM2dGhGT0lPZUdzelpHd0d1ZjkrS2UrU0xMOWx5T09kQ3VJUG5PMGVTWFVn?=
 =?utf-8?B?bVdab2IrbnNRMVU5N0Y5dm1rQTVoaTltZlJzcmdqVXVyMkJEamVWWDF6YXUz?=
 =?utf-8?B?RjRLRXpHQ1AxTWZjd3h0bjY1TVpPalNyTDBMM00xeWd0NG5HVlV4VW9IL2JC?=
 =?utf-8?B?LzRBYWozUk13VjJDblFRWXBDN0ZvRHpFVTh0VFBuNWovZmNvb0Nrc0dYYjNQ?=
 =?utf-8?B?TWp5SkRhdkdKSFhsSFZYYnpCcGFrNTlPR2dKdnJBMnJGYkd4cFV4WmNVWWVp?=
 =?utf-8?B?UjZCWVhmL3BrQ1NGL0Rsd2ZBYVFBR0xWRmVlZXBXaVhVNTZTWkQrY0l5NWFk?=
 =?utf-8?B?elVqclFQZHU5NEJVTjhhSzRic2hRUDZOZFF3YmZqQU0wNytmR3QwNUx1MVFq?=
 =?utf-8?B?cVVwYTB5UzZhU2ZWZWRsZ2R3TVZnbk1xY3VXMjFrR3VmcFBRdXdWSjNyVVRN?=
 =?utf-8?B?RTZrVi8wMVNxWU9OcG52c1NxUFJCdU02eGczVTQ4N2NUVnI4c1d6a24wOGNi?=
 =?utf-8?B?SldYcDEra2pUTXFyNHBDQmhqNmVTK20wYVpxYVI4bzd3M0tPTmpXMDVzK1pi?=
 =?utf-8?B?cmxGM0dhK1c2STdrLzFha2dDdTJFOHJ3QWg3MlJLZVB2RDkxczYyRVdFL2E0?=
 =?utf-8?B?d3JEcFNnY0F4MWd4cXlMbFRzc0VOWDg5NlB5cHdEVlF2Q1A1Y0JJcVRyRnBZ?=
 =?utf-8?B?UzJUSUdISThKWUw5K29pcGtPcCtldnNtQWZKVUsybmw3Y29IUUloWjYvVEpV?=
 =?utf-8?B?SnZyVUh6YXVENjc0YXpRZTZoUmllY1VMYkh6QUNpMnhCdmxZRU1FTEFyR0pD?=
 =?utf-8?B?WDRIOXFZMzZ1ZkFYZjFhNjVjaGYyWWhPeXBrdTJVV25OeTRLdTlkNXdyZXQy?=
 =?utf-8?B?MFVYZWFVZmJUaldvYnFNZnhZWi9uRVVML3o3ajJpTWVKZHMweDJ6bEtoZVFN?=
 =?utf-8?B?RXEydENNNkIxRTlvdXJmeVhpdVBqUHgxTGZKd1JYNklkbHU5NUI1YlorYzNT?=
 =?utf-8?B?RmdlaDFEYVF0UjRNMXBRckhTSjZYc05hdFE5b0ZIelQvcXAvcTROTDMzcUlN?=
 =?utf-8?B?bEJSRVVMUUdtYzYwcjRoY1hYZDU2UE9naWtucWQ4a0U4ZGp4NE10bS9zKzJm?=
 =?utf-8?B?cGROd3l6WnJ1TGJ3KythblAwcmRMYzAyN1N1SDBsVXBrTkNHbjRmVjl5Y2py?=
 =?utf-8?B?ZGQzMTZud04vYWxLSXVWVkJKMytudHh0WXJLdE0wU040Q01kdm1WTDRxRTlu?=
 =?utf-8?B?dnhlRThBNEc5dFB4ODdnRkJEMjZiS1pSLzg4OGRxcFBLbU1oREtwK0lNVWUw?=
 =?utf-8?B?NmVVZnNjblU4UWR1WDlDQ2lJSjJra2pLQTg2M3R0SnM4Uk9PVFBuYnpDemt5?=
 =?utf-8?B?SkQwZC9PWFR3eEdJNlE3NjYvdStkdWoyRzllK1EzUTZuSFRKa0FBT2F5c2Yw?=
 =?utf-8?B?RWNiK2k3VGxDR1hrRWtYSmRMTGFsQXFIcmNMVnZRaWZvaVFRb2RFWjErTTUy?=
 =?utf-8?B?WE9XWlFuUUlPS1FoNmNwWHJlaGkwZ0Fpb3J3UXNiQnhFU1dZaE9hZz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6e1199-1737-4c50-bb3f-08d9c386043c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 06:57:41.5008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQR14CGczsCpcm1LUmRicbV8RyCKhH29fBB6QeluAFxQNz0HkxluQ/5SnIqypdQYfhp/WvnGnjF6Dgw+W6I6CGlXV1KYwvdbiY0Fxli235RpALAMobZ4ovgVq4CV8KSM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB6888
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


On 30-11-2021 01:30 am, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: switch to common exception injection framework]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   .mailmap                             |   1 +
>   arch/arm64/include/asm/kvm_arm.h     |  17 +++
>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>   arch/arm64/include/asm/kvm_host.h    |   1 +
>   arch/arm64/kvm/Makefile              |   2 +-
>   arch/arm64/kvm/emulate-nested.c      | 176 +++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/exception.c       |  49 ++++++--
>   arch/arm64/kvm/inject_fault.c        |  68 +++++++++--
>   arch/arm64/kvm/trace_arm.h           |  59 +++++++++
>   9 files changed, 362 insertions(+), 21 deletions(-)
>   create mode 100644 arch/arm64/kvm/emulate-nested.c
> 
> diff --git a/.mailmap b/.mailmap
> index 14314e3c5d5e..491238a888cb 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -167,6 +167,7 @@ Jeff Layton <jlayton@kernel.org> <jlayton@redhat.com>
>   Jens Axboe <axboe@suse.de>
>   Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
>   Jernej Skrabec <jernej.skrabec@gmail.com> <jernej.skrabec@siol.net>
> +<jintack@cs.columbia.edu> <jintack.lim@linaro.org>
>   Jiri Slaby <jirislaby@kernel.org> <jirislaby@gmail.com>
>   Jiri Slaby <jirislaby@kernel.org> <jslaby@novell.com>
>   Jiri Slaby <jirislaby@kernel.org> <jslaby@suse.com>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index a39fcf318c77..589a6b92d741 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -359,4 +359,21 @@
>   #define CPACR_EL1_TTA		(1 << 28)
>   #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN)
>   
> +#define kvm_mode_names				\
> +	{ PSR_MODE_EL0t,	"EL0t" },	\
> +	{ PSR_MODE_EL1t,	"EL1t" },	\
> +	{ PSR_MODE_EL1h,	"EL1h" },	\
> +	{ PSR_MODE_EL2t,	"EL2t" },	\
> +	{ PSR_MODE_EL2h,	"EL2h" },	\
> +	{ PSR_MODE_EL3t,	"EL3t" },	\
> +	{ PSR_MODE_EL3h,	"EL3h" },	\
> +	{ PSR_AA32_MODE_USR,	"32-bit USR" },	\
> +	{ PSR_AA32_MODE_FIQ,	"32-bit FIQ" },	\
> +	{ PSR_AA32_MODE_IRQ,	"32-bit IRQ" },	\
> +	{ PSR_AA32_MODE_SVC,	"32-bit SVC" },	\
> +	{ PSR_AA32_MODE_ABT,	"32-bit ABT" },	\
> +	{ PSR_AA32_MODE_HYP,	"32-bit HYP" },	\
> +	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
> +	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
> +
>   #endif /* __ARM64_KVM_ARM_H__ */
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4b079945d0f..46c849ba281e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -33,6 +33,12 @@ enum exception_type {
>   	except_type_serror	= 0x180,
>   };
>   
> +#define kvm_exception_type_names		\
> +	{ except_type_sync,	"SYNC"   },	\
> +	{ except_type_irq,	"IRQ"    },	\
> +	{ except_type_fiq,	"FIQ"    },	\
> +	{ except_type_serror,	"SERROR" }
> +
>   bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
>   void kvm_skip_instr32(struct kvm_vcpu *vcpu);
>   
> @@ -41,6 +47,10 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
>   void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>   void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>   
> +void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
> +int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
> +int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
> +
>   static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>   {
>   	return !(vcpu->arch.hcr_el2 & HCR_RW);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4f642a2e9c34..7b6fe18ee450 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -477,6 +477,7 @@ struct kvm_vcpu_arch {
>   #define KVM_ARM64_EXCEPT_AA64_ELx_SERR	(3 << 9)
>   #define KVM_ARM64_EXCEPT_AA64_EL1	(0 << 11)
>   #define KVM_ARM64_EXCEPT_AA64_EL2	(1 << 11)
> +#define KVM_ARM64_EXCEPT_AA64_EL_MASK	(1 << 11)
>   
>   /*
>    * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 989bb5dad2c8..1f602526e9a2 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>   	 inject_fault.o va_layout.o handle_exit.o \
>   	 guest.o debug.o reset.o sys_regs.o \
>   	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
> -	 arch_timer.o trng.o\
> +	 arch_timer.o trng.o emulate-nested.o \
>   	 vgic/vgic.o vgic/vgic-init.o \
>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>   	 vgic/vgic-v3.o vgic/vgic-v4.o \
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> new file mode 100644
> index 000000000000..339e8272b01e
> --- /dev/null
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -0,0 +1,176 @@
> +/*
> + * Copyright (C) 2016 - Linaro and Columbia University
> + * Author: Jintack Lim <jintack.lim@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
> +
> +#include "hyp/include/hyp/adjust_pc.h"
> +
> +#include "trace.h"
> +
> +void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> +{
> +	u64 spsr, elr, mode;
> +	bool direct_eret;
> +
> +	/*
> +	 * Going through the whole put/load motions is a waste of time
> +	 * if this is a VHE guest hypervisor returning to its own
> +	 * userspace, or the hypervisor performing a local exception
> +	 * return. No need to save/restore registers, no need to
> +	 * switch S2 MMU. Just do the canonical ERET.
> +	 */
> +	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
> +	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	direct_eret  = (mode == PSR_MODE_EL0t &&
> +			vcpu_el2_e2h_is_set(vcpu) &&
> +			vcpu_el2_tge_is_set(vcpu));
> +	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
> +
> +	if (direct_eret) {
> +		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
> +		*vcpu_cpsr(vcpu) = spsr;
> +		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
> +		return;
> +	}
> +
> +	preempt_disable();
> +	kvm_arch_vcpu_put(vcpu);
> +
> +	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
> +
> +	trace_kvm_nested_eret(vcpu, elr, spsr);
> +
> +	/*
> +	 * Note that the current exception level is always the virtual EL2,
> +	 * since we set HCR_EL2.NV bit only when entering the virtual EL2.
> +	 */
> +	*vcpu_pc(vcpu) = elr;
> +	*vcpu_cpsr(vcpu) = spsr;
> +
> +	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	preempt_enable();
> +}
> +
> +static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
> +				     enum exception_type type)
> +{
> +	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
> +
> +	switch (type) {
> +	case except_type_sync:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_SYNC;
> +		break;
> +	case except_type_irq:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_IRQ;
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
> +	}
> +
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL2		|
> +			     KVM_ARM64_PENDING_EXCEPTION);
> +
> +	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
> +}
> +
> +/*
> + * Emulate taking an exception to EL2.
> + * See ARM ARM J8.1.2 AArch64.TakeException()
> + */
> +static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
> +			     enum exception_type type)
> +{
> +	u64 pstate, mode;
> +	bool direct_inject;
> +
> +	if (!nested_virt_in_use(vcpu)) {
> +		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
> +				__func__);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * As for ERET, we can avoid doing too much on the injection path by
> +	 * checking that we either took the exception from a VHE host
> +	 * userspace or from vEL2. In these cases, there is no change in
> +	 * translation regime (or anything else), so let's do as little as
> +	 * possible.
> +	 */
> +	pstate = *vcpu_cpsr(vcpu);
> +	mode = pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	direct_inject  = (mode == PSR_MODE_EL0t &&
> +			  vcpu_el2_e2h_is_set(vcpu) &&
> +			  vcpu_el2_tge_is_set(vcpu));
> +	direct_inject |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
> +
> +	if (direct_inject) {
> +		kvm_inject_el2_exception(vcpu, esr_el2, type);
> +		return 1;
> +	}
> +
> +	preempt_disable();
> +	kvm_arch_vcpu_put(vcpu);
> +
> +	kvm_inject_el2_exception(vcpu, esr_el2, type);
> +
> +	/*
> +	 * A hard requirement is that a switch between EL1 and EL2
> +	 * contexts has to happen between a put/load, so that we can
> +	 * pick the correct timer and interrupt configuration, among
> +	 * other things.
> +	 *
> +	 * Make sure the exception actually took place before we load
> +	 * the new context.
> +	 */
> +	__kvm_adjust_pc(vcpu);
> +
> +	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	preempt_enable();
> +
> +	return 1;
> +}
> +
> +int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
> +{
> +	return kvm_inject_nested(vcpu, esr_el2, except_type_sync);
> +}
> +
> +int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Do not inject an irq if the:
> +	 *  - Current exception level is EL2, and
> +	 *  - virtual HCR_EL2.TGE == 0
> +	 *  - virtual HCR_EL2.IMO == 0
> +	 *
> +	 * See Table D1-17 "Physical interrupt target and masking when EL3 is
> +	 * not implemented and EL2 is implemented" in ARM DDI 0487C.a.
> +	 */
> +
> +	if (vcpu_mode_el2(vcpu) && !vcpu_el2_tge_is_set(vcpu) &&
> +	    !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO))
> +		return 1;
> +
> +	/* esr_el2 value doesn't matter for exits due to irqs. */
> +	return kvm_inject_nested(vcpu, 0, except_type_irq);
> +}
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 0418399e0a20..4ef5e86efd8b 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -13,6 +13,7 @@
>   #include <hyp/adjust_pc.h>
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>   
>   #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
>   #error Hypervisor code only!
> @@ -22,7 +23,9 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>   {
>   	u64 val;
>   
> -	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> +	if (unlikely(nested_virt_in_use(vcpu)))
> +		return vcpu_read_sys_reg(vcpu, reg);
> +	else if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>   		return val;
>   
>   	return __vcpu_sys_reg(vcpu, reg);
> @@ -30,14 +33,24 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>   
>   static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>   {
> -	if (__vcpu_write_sys_reg_to_cpu(val, reg))
> -		return;
> -
> -	 __vcpu_sys_reg(vcpu, reg) = val;
> +	if (unlikely(nested_virt_in_use(vcpu)))
> +		vcpu_write_sys_reg(vcpu, val, reg);
> +	else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
> +		__vcpu_sys_reg(vcpu, reg) = val;
>   }
>   
> -static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
> +			      u64 val)
>   {
> +	if (unlikely(nested_virt_in_use(vcpu))) {
> +		if (target_mode == PSR_MODE_EL1h)
> +			vcpu_write_sys_reg(vcpu, val, SPSR_EL1);
> +		else
> +			vcpu_write_sys_reg(vcpu, val, SPSR_EL2);
> +
> +		return;
> +	}
> +
>   	write_sysreg_el1(val, SYS_SPSR);
>   }
>   
> @@ -97,6 +110,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>   		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>   		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
>   		break;
> +	case PSR_MODE_EL2h:
> +		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
> +		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> +		break;
>   	default:
>   		/* Don't do that */
>   		BUG();
> @@ -149,7 +167,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>   	new |= target_mode;
>   
>   	*vcpu_cpsr(vcpu) = new;
> -	__vcpu_write_spsr(vcpu, old);
> +	__vcpu_write_spsr(vcpu, target_mode, old);
>   }
>   
>   /*
> @@ -320,11 +338,22 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>   		      KVM_ARM64_EXCEPT_AA64_EL1):
>   			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
>   			break;
> +
> +		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
> +		      KVM_ARM64_EXCEPT_AA64_EL2):
> +			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
> +			break;
> +
> +		case (KVM_ARM64_EXCEPT_AA64_ELx_IRQ |
> +		      KVM_ARM64_EXCEPT_AA64_EL2):
> +			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_irq);
> +			break;
> +
>   		default:
>   			/*
> -			 * Only EL1_SYNC makes sense so far, EL2_{SYNC,IRQ}
> -			 * will be implemented at some point. Everything
> -			 * else gets silently ignored.
> +			 * Only EL1_SYNC and EL2_{SYNC,IRQ} makes
> +			 * sense so far. Everything else gets silently
> +			 * ignored.
>   			 */
>   			break;
>   		}
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index b47df73e98d7..5dcf3f8b08b8 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -12,19 +12,58 @@
>   
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>   #include <asm/esr.h>
>   
> +static void pend_sync_exception(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> +			     KVM_ARM64_PENDING_EXCEPTION);
> +
> +	/* If not nesting, EL1 is the only possible exception target */
> +	if (likely(!nested_virt_in_use(vcpu))) {
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		return;
> +	}
> +
> +	/*
> +	 * With NV, we need to pick between EL1 and EL2. Note that we
> +	 * never deal with a nesting exception here, hence never
> +	 * changing context, and the exception itself can be delayed
> +	 * until the next entry.
> +	 */
> +	switch(*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
> +		break;
> +	case PSR_MODE_EL1h:
> +	case PSR_MODE_EL1t:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		break;
> +	case PSR_MODE_EL0t:
> +		if (vcpu_el2_tge_is_set(vcpu) & HCR_TGE)

IMO, AND with HCR_TGE is not needed.
> +			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
> +		else
> +			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static bool match_target_el(struct kvm_vcpu *vcpu, unsigned long target)
> +{
> +	return (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL_MASK) == target;
> +}
> +
>   static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
>   {
>   	unsigned long cpsr = *vcpu_cpsr(vcpu);
>   	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>   	u32 esr = 0;
>   
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> -
> -	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +	pend_sync_exception(vcpu);
>   
>   	/*
>   	 * Build an {i,d}abort, depending on the level and the
> @@ -45,16 +84,22 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>   	if (!is_iabt)
>   		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>   
> -	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
> +	esr |= ESR_ELx_FSC_EXTABT;
> +
> +	if (match_target_el(vcpu, KVM_ARM64_EXCEPT_AA64_EL1)) {
> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	} else {
> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
> +	}
>   }
>   
>   static void inject_undef64(struct kvm_vcpu *vcpu)
>   {
>   	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>   
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> +	pend_sync_exception(vcpu);
>   
>   	/*
>   	 * Build an unknown exception, depending on the instruction
> @@ -63,7 +108,10 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>   	if (kvm_vcpu_trap_il_is32bit(vcpu))
>   		esr |= ESR_ELx_IL;
>   
> -	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	if (match_target_el(vcpu, KVM_ARM64_EXCEPT_AA64_EL1))
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	else
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
>   }
>   
>   #define DFSR_FSC_EXTABT_LPAE	0x10
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 33e4e7dd2719..f3e46a976125 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -2,6 +2,7 @@
>   #if !defined(_TRACE_ARM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
>   #define _TRACE_ARM_ARM64_KVM_H
>   
> +#include <asm/kvm_emulate.h>
>   #include <kvm/arm_arch_timer.h>
>   #include <linux/tracepoint.h>
>   
> @@ -301,6 +302,64 @@ TRACE_EVENT(kvm_timer_emulate,
>   		  __entry->timer_idx, __entry->should_fire)
>   );
>   
> +TRACE_EVENT(kvm_nested_eret,
> +	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long elr_el2,
> +		 unsigned long spsr_el2),
> +	TP_ARGS(vcpu, elr_el2, spsr_el2),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm_vcpu *,	vcpu)
> +		__field(unsigned long,		elr_el2)
> +		__field(unsigned long,		spsr_el2)
> +		__field(unsigned long,		target_mode)
> +		__field(unsigned long,		hcr_el2)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu = vcpu;
> +		__entry->elr_el2 = elr_el2;
> +		__entry->spsr_el2 = spsr_el2;
> +		__entry->target_mode = spsr_el2 & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +		__entry->hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +	),
> +
> +	TP_printk("elr_el2: 0x%lx spsr_el2: 0x%08lx (M: %s) hcr_el2: %lx",
> +		  __entry->elr_el2, __entry->spsr_el2,
> +		  __print_symbolic(__entry->target_mode, kvm_mode_names),
> +		  __entry->hcr_el2)
> +);
> +
> +TRACE_EVENT(kvm_inject_nested_exception,
> +	TP_PROTO(struct kvm_vcpu *vcpu, u64 esr_el2, int type),
> +	TP_ARGS(vcpu, esr_el2, type),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm_vcpu *,		vcpu)
> +		__field(unsigned long,			esr_el2)
> +		__field(int,				type)
> +		__field(unsigned long,			spsr_el2)
> +		__field(unsigned long,			pc)
> +		__field(unsigned long,			source_mode)
> +		__field(unsigned long,			hcr_el2)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu = vcpu;
> +		__entry->esr_el2 = esr_el2;
> +		__entry->type = type;
> +		__entry->spsr_el2 = *vcpu_cpsr(vcpu);
> +		__entry->pc = *vcpu_pc(vcpu);
> +		__entry->source_mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +		__entry->hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +	),
> +
> +	TP_printk("%s: esr_el2 0x%lx elr_el2: 0x%lx spsr_el2: 0x%08lx (M: %s) hcr_el2: %lx",
> +		  __print_symbolic(__entry->type, kvm_exception_type_names),
> +		  __entry->esr_el2, __entry->pc, __entry->spsr_el2,
> +		  __print_symbolic(__entry->source_mode, kvm_mode_names),
> +		  __entry->hcr_el2)
> +);
> +
>   #endif /* _TRACE_ARM_ARM64_KVM_H */
>   
>   #undef TRACE_INCLUDE_PATH

It looks good to me, please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat
