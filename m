Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0256D9F25
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbjDFRqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 13:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbjDFRqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 13:46:14 -0400
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E00E1AC
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:46:13 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.227])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 4294527142;
        Thu,  6 Apr 2023 17:46:11 +0000 (UTC)
Received: from kaod.org (37.59.142.96) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 6 Apr
 2023 19:46:10 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-96R001bbd69b5d-5ba5-40e2-98d5-61c75b75d5d4,
                    FAD431FEE685CF753936F989CEAB98D84F5F9206) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <5b90b770-b420-1dab-401e-b1ed5b5d7e94@kaod.org>
Date:   Thu, 6 Apr 2023 19:46:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 08/10] target/ppc: Restrict KVM-specific field from
 ArchCPU
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        <qemu-devel@nongnu.org>
CC:     <qemu-s390x@nongnu.org>, <qemu-riscv@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        <qemu-arm@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-ppc@nongnu.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-9-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230405160454.97436-9-philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG9EX1.mxp5.local (172.16.2.81) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 4ee85be4-94f7-4812-b6b2-e6f1dcb9ab6d
X-Ovh-Tracer-Id: 388153995401333749
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejfedgudduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeliedpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhhihhlmhgusehlihhnrghrohdrohhrghdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhrihhstghvsehnohhnghhnuhdrohhrghdprghlvgigrdgsvghnnhgvvgeslhhinhgrrhhordhorhhgpdhqvghmuhdqrghrmhesnhhonhhgnhhurdhorhhgpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhqvghmuhdqphhptgesnhhonhhgnhhurdhorhhgpd
 gurghnihgvlhhhsgegudefsehgmhgrihhlrdgtohhmpdgurghvihgusehgihgsshhonhdrughrohhpsggvrghrrdhiugdrrghupdhgrhhouhhgsehkrghougdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Philippe

On 4/5/23 18:04, Philippe Mathieu-Daudé wrote:
> The 'kvm_sw_tlb' field shouldn't be accessed when KVM is not available.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/ppc/cpu.h        | 2 ++
>   target/ppc/mmu_common.c | 4 ++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index 557d736dab..0ec3957397 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1148,7 +1148,9 @@ struct CPUArchState {
>       int tlb_type;    /* Type of TLB we're dealing with */
>       ppc_tlb_t tlb;   /* TLB is optional. Allocate them only if needed */
>       bool tlb_dirty;  /* Set to non-zero when modifying TLB */

'tlb_dirty' was part of the same commit 93dd5e852c ("kvm: ppc: booke206:
use MMU API"). So we might as well include it in the #ifdef section.

Thanks,

C.

> +#ifdef CONFIG_KVM
>       bool kvm_sw_tlb; /* non-zero if KVM SW TLB API is active */
> +#endif /* CONFIG_KVM */
>       uint32_t tlb_need_flush; /* Delayed flush needed */
>   #define TLB_NEED_LOCAL_FLUSH   0x1
>   #define TLB_NEED_GLOBAL_FLUSH  0x2
> diff --git a/target/ppc/mmu_common.c b/target/ppc/mmu_common.c
> index 7235a4befe..21843c69f6 100644
> --- a/target/ppc/mmu_common.c
> +++ b/target/ppc/mmu_common.c
> @@ -917,10 +917,12 @@ static void mmubooke_dump_mmu(CPUPPCState *env)
>       ppcemb_tlb_t *entry;
>       int i;
>   
> +#ifdef CONFIG_KVM
>       if (kvm_enabled() && !env->kvm_sw_tlb) {
>           qemu_printf("Cannot access KVM TLB\n");
>           return;
>       }
> +#endif
>   
>       qemu_printf("\nTLB:\n");
>       qemu_printf("Effective          Physical           Size PID   Prot     "
> @@ -1008,10 +1010,12 @@ static void mmubooke206_dump_mmu(CPUPPCState *env)
>       int offset = 0;
>       int i;
>   
> +#ifdef CONFIG_KVM
>       if (kvm_enabled() && !env->kvm_sw_tlb) {
>           qemu_printf("Cannot access KVM TLB\n");
>           return;
>       }
> +#endif
>   
>       for (i = 0; i < BOOKE206_MAX_TLBN; i++) {
>           int size = booke206_tlb_size(env, i);

