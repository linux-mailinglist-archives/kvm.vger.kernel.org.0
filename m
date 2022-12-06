Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9147A6441B6
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiLFK75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiLFK71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:59:27 -0500
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Dec 2022 02:59:08 PST
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F323158
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:59:08 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.123])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id E2F241487AD7F;
        Tue,  6 Dec 2022 11:40:45 +0100 (CET)
Received: from kaod.org (37.59.142.104) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Tue, 6 Dec
 2022 11:40:45 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-104R0053661617a-9bb6-4b4f-ab77-e4154bb311b3,
                    254DF8B9336E272DCABEC9A22D9B985827C16DD1) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <e857891c-e41a-c953-fb21-730fa74ea7d1@kaod.org>
Date:   Tue, 6 Dec 2022 11:40:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [kvm-unit-tests PATCH] powerpc: Fix running the kvm-unit-tests
 with recent versions of QEMU
To:     Thomas Huth <thuth@redhat.com>, <kvm@vger.kernel.org>
CC:     <kvm-ppc@vger.kernel.org>, Laurent Vivier <lvivier@redhat.com>
References: <20221206101455.145258-1-thuth@redhat.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221206101455.145258-1-thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 52f73e55-9437-484e-9a25-d0e773e00513
X-Ovh-Tracer-Id: 2030279007038573536
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuefgieevhfevhfevkedufeefgedvteffhfehudetueffleektdefieffgfetgefgnecuffhomhgrihhnpegtshhtrghrtheigedrshgsnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehthhhuthhhsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhvihhvihgvrhesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/22 11:14, Thomas Huth wrote:
> Starting with version 7.0, QEMU starts the pseries guests in 32-bit mode
> instead of 64-bit (see QEMU commit 6e3f09c28a - "spapr: Force 32bit when
> resetting a core"). This causes our test_64bit() in powerpc/emulator.c
> to fail. Let's switch to 64-bit in our startup code instead to fix the
> issue.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   powerpc/cstart64.S | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 972851f9..206c518f 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -23,6 +23,12 @@
>   .globl start
>   start:
>   	FIXUP_ENDIAN
> +	/* Switch to 64-bit mode */
> +	mfmsr	r1
> +	li	r2,1
> +	sldi	r2,r2,63
> +	or	r1,r1,r2
> +	mtmsrd	r1
>   	/*
>   	 * We were loaded at QEMU's kernel load address, but we're not
>   	 * allowed to link there due to how QEMU deals with linker VMAs,

You could add this define in lib/powerpc/asm/ppc_asm.h  :

#define MSR_SF	0x8000000000000000ul

and possibly use the LOAD_REG_IMMEDIATE macro to set the MSR.

Thanks,

C.



