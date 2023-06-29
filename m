Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454DB7420C9
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjF2HMn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Jun 2023 03:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjF2HMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 03:12:39 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Jun 2023 00:12:30 PDT
Received: from 8.mo548.mail-out.ovh.net (8.mo548.mail-out.ovh.net [46.105.45.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB89294E
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 00:12:30 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.17])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id A5E232223A;
        Thu, 29 Jun 2023 06:36:41 +0000 (UTC)
Received: from kaod.org (37.59.142.101) by DAG6EX1.mxp5.local (172.16.2.51)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 29 Jun
 2023 08:36:41 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G0044fe8cc28-ee85-49e8-8059-ec83b0f83da7,
                    3572DC45CCAD587926D7956B888079DA14C9F13E) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Thu, 29 Jun 2023 08:36:33 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
CC:     <qemu-devel@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        "=?UTF-8?B?Q8OpZHJpYw==?= Le Goater" <clg@kaod.org>,
        <qemu-ppc@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 5/6] target/ppc: Restrict 'kvm_ppc.h' to sysemu in
 cpu_init.c
Message-ID: <20230629083633.7e48cedd@bahia>
In-Reply-To: <20230627115124.19632-6-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
        <20230627115124.19632-6-philmd@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG6EX1.mxp5.local
 (172.16.2.51)
X-Ovh-Tracer-GUID: a29bf055-2cb6-44d9-ae14-a11cb6e9bab9
X-Ovh-Tracer-Id: 2772247049428441391
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedviedrtdefgdduuddtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkjghfofggtgfgihesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepueeuieejtdelleeutdfhteejffeiteffueevffeffeetvdeifeeujefgudegteeunecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutddupdejkedrudeljedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehgrhhouhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhhihhlmhgusehlihhnrghrohdrohhrghdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpuggrvhhiugesghhisghsohhnrdgurhhophgsvggrrhdrihgurdgruhdpuggrnhhivghlhhgsgedufeesghhmrghilhdrtghomhdpqhgvmhhuqdhpphgtsehnohhnghhnuhdrohhrghdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpnhhpihhgghhinhesghhmrghilhdrtghomhdptg
 hlgheskhgrohgurdhorhhgpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jun 2023 13:51:23 +0200
Philippe Mathieu-Daudé <philmd@linaro.org> wrote:

> User emulation shouldn't need any of the KVM prototypes
> declared in "kvm_ppc.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  target/ppc/cpu_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
> index aeff71d063..f2afb539eb 100644
> --- a/target/ppc/cpu_init.c
> +++ b/target/ppc/cpu_init.c
> @@ -21,7 +21,6 @@
>  #include "qemu/osdep.h"
>  #include "disas/dis-asm.h"
>  #include "gdbstub/helpers.h"
> -#include "kvm_ppc.h"
>  #include "sysemu/cpus.h"
>  #include "sysemu/hw_accel.h"
>  #include "sysemu/tcg.h"
> @@ -49,6 +48,7 @@
>  #ifndef CONFIG_USER_ONLY
>  #include "hw/boards.h"
>  #include "hw/intc/intc.h"
> +#include "kvm_ppc.h"
>  #endif
>  
>  /* #define PPC_DEBUG_SPR */



-- 
Greg
