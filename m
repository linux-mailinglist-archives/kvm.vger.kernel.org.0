Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1271740736
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjF1AbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjF1AbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:31:20 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED852704
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:31:19 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 98B8C5C014D;
        Tue, 27 Jun 2023 20:31:16 -0400 (EDT)
Received: from imap50 ([10.202.2.100])
  by compute1.internal (MEProxy); Tue, 27 Jun 2023 20:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1687912276; x=1687998676; bh=Gd
        +embUeOu+6SuIKsLjAuiROY4aDSeIcBFv7Ckb3rMM=; b=SUs3+rVzQ9Kc44D1Ir
        EfZhhxnwMQKCJYCd6NfF4bzhjN7zGAR33fD7wWFe9QjZwcehgaDfnrwgmwDekq+L
        PXq7ZpkI/KdtTDmy4onYbuT0MCiD/7yoXlvcNm4X4FdhCQh3l4QKLRfKu8Lf0cEQ
        GCDd33n8nkYd6rYxkrb5GPsCk06xwS5/rIgmMdUaPiWoCJyW06ASDjNchnymNONe
        kqpbQtri1RcW4VfPuCIYmbhUs5EwdlWp41nEc2A64nx39gungwCki90ejJKjjDbS
        xFfRIaivq6uZNlHfQJBHdZ7dhsL9rQxE1yZThEekcYXa59wYxm8rXnd1QDEGUo0D
        Zgow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1687912276; x=1687998676; bh=Gd+embUeOu+6S
        uIKsLjAuiROY4aDSeIcBFv7Ckb3rMM=; b=klqGuJPZyF13Jx3BmwizcdEiOuxmP
        yovHnCA79KVmyf+FB3jwJYhTE7okodz+BZJFdDsIYr+0hnDHFc/T+MOp3ggsxCWu
        RxNPEOWLog7VNjDPgICgX1WMad1XWJnj4WmUhAPolXkWi3jyBmusbAi0Bw55NCmf
        ngcIMtRa1VoUgXPUKBdmPDEFDt/23HoikzKCRk8QmkTOkNXhwqEsoSoxPrAmCt7J
        pdKKh/qGqS4D6kbXcKhqMbkZun0kYwYiXGI+wIbpMj8YrJIa5zXr5BKLY/ROKvkz
        iBhNowjqGM4uVLH0/wAkLj+kYvUNFnoxz7SL1Un5zGzu0g8/rcZGSNY3Q==
X-ME-Sender: <xms:Un-bZF9Ec7t5Iqj71s-sqeB2juBUx2wTooDJRUMWE6EqU3bQshpyUA>
    <xme:Un-bZJuSCxF9zujrrY2FQulHKee-jl6xKh6PfbYrzWZYzeYuOs4NxnjMHJ07Lk3rx
    gNAq7mX9MyBUZDR_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrtddugdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfuthgv
    fhgrnhcuqfdktfgvrghrfdcuoehsohhrvggrrhesfhgrshhtmhgrihhlrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeejueehgedtueetgefhheejjeeigffhieefjeehuddvueegtdfh
    heevgfeggfektdenucffohhmrghinhepihhnfhhrrgguvggrugdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsohhrvggrrhesfhgr
    shhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:Un-bZDAG6S9spu--SH1qBeaeEW-Mk8LOGgpimxQ7czBcZGjwODPFOQ>
    <xmx:Un-bZJcu6lqmS8nlGSvTtTdDaHoOSS7IVjWjmueGVpWe_AYcUiJo5Q>
    <xmx:Un-bZKNECT2RWycM06WPjtcF6HLPeH5_1WpqqIQt7l_XupgNmNSzCA>
    <xmx:VH-bZPfjd3-WwnURFRV0_oD03Fdata9h4EY3DWWHXTsG2zzJr4JE-g>
Feedback-ID: i84414492:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9E1821700089; Tue, 27 Jun 2023 20:31:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-499-gf27bbf33e2-fm-20230619.001-gf27bbf33
Mime-Version: 1.0
Message-Id: <8af3e53a-ead7-4568-a0f1-2829f5d174e6@app.fastmail.com>
In-Reply-To: <20230605110724.21391-4-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-4-andy.chiu@sifive.com>
Date:   Tue, 27 Jun 2023 20:30:33 -0400
From:   "Stefan O'Rear" <sorear@fastmail.com>
To:     "Andy Chiu" <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org,
        "Palmer Dabbelt" <palmer@dabbelt.com>, anup@brainfault.org,
        "Atish Patra" <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, "Jonathan Corbet" <corbet@lwn.net>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>,
        "Heiko Stuebner" <heiko.stuebner@vrull.eu>,
        "Evan Green" <evan@rivosinc.com>,
        "Conor Dooley" <conor.dooley@microchip.com>,
        "Andrew Jones" <ajones@ventanamicro.com>,
        "Celeste Liu" <coelacanthus@outlook.com>,
        "Andrew Bresticker" <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v21 03/27] riscv: hwprobe: Add support for probing V in
 RISCV_HWPROBE_KEY_IMA_EXT_0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023, at 7:07 AM, Andy Chiu wrote:
> Probing kernel support for Vector extension is available now. This only
> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Evan Green <evan@rivosinc.com>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> ---
> Changelog v20:
>  - Fix a typo in document, and remove duplicated probes (Heiko)
>  - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
>    Evan)
> ---
>  Documentation/riscv/hwprobe.rst       | 3 +++
>  arch/riscv/include/uapi/asm/hwprobe.h | 1 +
>  arch/riscv/kernel/sys_riscv.c         | 4 ++++
>  3 files changed, 8 insertions(+)
>
> diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
> index 9f0dd62dcb5d..7431d9d01c73 100644
> --- a/Documentation/riscv/hwprobe.rst
> +++ b/Documentation/riscv/hwprobe.rst
> @@ -64,6 +64,9 @@ The following keys are defined:
>    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>      by version 2.2 of the RISC-V ISA manual.
> 
> +  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as defined by
> +    version 1.0 of the RISC-V Vector extension manual.
> +
>  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>    information about the selected set of processors.
> 
> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h 
> b/arch/riscv/include/uapi/asm/hwprobe.h
> index 8d745a4ad8a2..7c6fdcf7ced5 100644
> --- a/arch/riscv/include/uapi/asm/hwprobe.h
> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> @@ -25,6 +25,7 @@ struct riscv_hwprobe {
>  #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
>  #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
>  #define		RISCV_HWPROBE_IMA_C		(1 << 1)
> +#define		RISCV_HWPROBE_IMA_V		(1 << 2)
>  #define RISCV_HWPROBE_KEY_CPUPERF_0	5
>  #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
>  #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
> diff --git a/arch/riscv/kernel/sys_riscv.c 
> b/arch/riscv/kernel/sys_riscv.c
> index 5db29683ebee..88357a848797 100644
> --- a/arch/riscv/kernel/sys_riscv.c
> +++ b/arch/riscv/kernel/sys_riscv.c
> @@ -10,6 +10,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/hwprobe.h>
>  #include <asm/sbi.h>
> +#include <asm/vector.h>
>  #include <asm/switch_to.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe 
> *pair,
>  		if (riscv_isa_extension_available(NULL, c))
>  			pair->value |= RISCV_HWPROBE_IMA_C;
> 
> +		if (has_vector())
> +			pair->value |= RISCV_HWPROBE_IMA_V;
> +
>  		break;

I am concerned by the exception this is making.  I believe the intention of
riscv_hwprobe is to replace AT_HWCAP as the single point of truth for userspace
to make instruction use decisions.  Since this does not check riscv_v_vstate_ctrl_user_allowed,
application code which wants to know if V instructions are usable must use
AT_HWCAP instead, unlike all other extensions for which the relevant data is
available within the hwprobe return.

Assuming this is intentional, what is the path forward for future extensions
that cannot be used from userspace without additional conditions being met?
For instance, if we add support in the future for the Zve* extensions, the V
bit would not be set in HWCAP for them, which would require library code to
use the prctl interface unless we define the hwcap bits to imply userspace
usability.

-s

>  	case RISCV_HWPROBE_KEY_CPUPERF_0:
> -- 
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
