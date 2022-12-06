Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56881644252
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiLFLn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 06:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFLnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 06:43:55 -0500
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6816019C30
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 03:43:54 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.171])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 7FCA82ED3C;
        Tue,  6 Dec 2022 11:43:52 +0000 (UTC)
Received: from kaod.org (37.59.142.107) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Tue, 6 Dec
 2022 12:43:51 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-107S0019980ea4b-24ee-4c8d-b559-50a082b47399,
                    254DF8B9336E272DCABEC9A22D9B985827C16DD1) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <738728ea-818e-2f2e-40e2-d27fdee729f9@kaod.org>
Date:   Tue, 6 Dec 2022 12:43:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [kvm-unit-tests v2 PATCH] powerpc: Fix running the kvm-unit-tests
 with recent versions of QEMU
To:     Thomas Huth <thuth@redhat.com>, <kvm@vger.kernel.org>
CC:     <kvm-ppc@vger.kernel.org>, Laurent Vivier <lvivier@redhat.com>
References: <20221206110851.154297-1-thuth@redhat.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221206110851.154297-1-thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.107]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 61c61714-f846-4a2d-b30e-6b115a114df5
X-Ovh-Tracer-Id: 3096224746165930976
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigdeftdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepgedvfeelgeetgfehtdefgffggeegudfhvdevuddttdeukedvheffvdefhfdufeeunecuffhomhgrihhnpegtshhtrghrtheigedrshgsnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehthhhuthhhsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhvihhvihgvrhesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/22 12:08, Thomas Huth wrote:
> Starting with version 7.0, QEMU starts the pseries guests in 32-bit mode
> instead of 64-bit (see QEMU commit 6e3f09c28a - "spapr: Force 32bit when
> resetting a core"). This causes our test_64bit() in powerpc/emulator.c
> to fail. Let's switch to 64-bit in our startup code instead to fix the
> issue.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>   lib/powerpc/asm/ppc_asm.h | 3 +++
>   powerpc/cstart64.S        | 6 ++++++
>   2 files changed, 9 insertions(+)
> 
> diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
> index 39620a39..1b85f6bb 100644
> --- a/lib/powerpc/asm/ppc_asm.h
> +++ b/lib/powerpc/asm/ppc_asm.h
> @@ -35,4 +35,7 @@
>   
>   #endif /* __BYTE_ORDER__ */
>   
> +/* Machine State Register definitions: */
> +#define MSR_SF_BIT	63			/* 64-bit mode */
> +
>   #endif /* _ASMPOWERPC_PPC_ASM_H */
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 972851f9..34e39341 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -23,6 +23,12 @@
>   .globl start
>   start:
>   	FIXUP_ENDIAN
> +	/* Switch to 64-bit mode */
> +	mfmsr	r1
> +	li	r2,1
> +	sldi	r2,r2,MSR_SF_BIT
> +	or	r1,r1,r2
> +	mtmsrd	r1
>   	/*
>   	 * We were loaded at QEMU's kernel load address, but we're not
>   	 * allowed to link there due to how QEMU deals with linker VMAs,

