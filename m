Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D69574209E
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 08:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjF2GqP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Jun 2023 02:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjF2GpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 02:45:14 -0400
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jun 2023 23:43:49 PDT
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78D72D56
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 23:43:49 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.141])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 7734720B29;
        Thu, 29 Jun 2023 06:36:13 +0000 (UTC)
Received: from kaod.org (37.59.142.97) by DAG6EX1.mxp5.local (172.16.2.51)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 29 Jun
 2023 08:36:12 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G002bc5539fe-ec9e-4790-8209-e60a71a887e4,
                    3572DC45CCAD587926D7956B888079DA14C9F13E) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Thu, 29 Jun 2023 08:36:11 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
CC:     <qemu-devel@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        "=?UTF-8?B?Q8OpZHJpYw==?= Le Goater" <clg@kaod.org>,
        <qemu-ppc@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 4/6] target/ppc: Define TYPE_HOST_POWERPC_CPU in
 cpu-qom.h
Message-ID: <20230629083611.3ba82988@bahia>
In-Reply-To: <20230627115124.19632-5-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
        <20230627115124.19632-5-philmd@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG6EX1.mxp5.local
 (172.16.2.51)
X-Ovh-Tracer-GUID: e29b3c8e-1a4e-4c65-a97d-5e7d78dff95b
X-Ovh-Tracer-Id: 2764365747181230383
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedviedrtdefgdduuddtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkjghfofggtgfgihesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepueeuieejtdelleeutdfhteejffeiteffueevffeffeetvdeifeeujefgudegteeunecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeljedpjeekrdduleejrddvtdekrddvgeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoghhrohhugheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehphhhilhhmugeslhhinhgrrhhordhorhhgpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdgurghvihgusehgihgsshhonhdrughrohhpsggvrghrrdhiugdrrghupdgurghnihgvlhhhsgegudefsehgmhgrihhlrdgtohhmpdhqvghmuhdqphhptgesnhhonhhgnhhurdhorhhgpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhnphhighhgihhnsehgmhgrihhlrdgtohhmpdgtlh
 hgsehkrghougdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jun 2023 13:51:22 +0200
Philippe Mathieu-Daudé <philmd@linaro.org> wrote:

> TYPE_HOST_POWERPC_CPU is used in various places of cpu_init.c,
> in order to restrict "kvm_ppc.h" to sysemu, move this QOM-related
> definition to cpu-qom.h.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  target/ppc/cpu-qom.h | 2 ++
>  target/ppc/kvm_ppc.h | 2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
> index c2bff349cc..4e4061068e 100644
> --- a/target/ppc/cpu-qom.h
> +++ b/target/ppc/cpu-qom.h
> @@ -36,6 +36,8 @@ OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
>  #define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
>  #define cpu_list ppc_cpu_list
>  
> +#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
> +
>  ObjectClass *ppc_cpu_class_by_name(const char *name);
>  
>  typedef struct CPUArchState CPUPPCState;
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 49954a300b..901e188c9a 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -13,8 +13,6 @@
>  #include "exec/hwaddr.h"
>  #include "cpu.h"
>  
> -#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
> -
>  #ifdef CONFIG_KVM
>  
>  uint32_t kvmppc_get_tbfreq(void);



-- 
Greg
