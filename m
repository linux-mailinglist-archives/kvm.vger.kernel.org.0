Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0B70B3DA
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 05:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjEVDnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 23:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEVDm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 23:42:58 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF62C4;
        Sun, 21 May 2023 20:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1684726974; bh=rP3A3NWlnh0twgVqFQ9Ghly+c940ixOeCKKj1+JbAPg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TgTPePy3dbHCvevaw8C53ojSoukuZsTopdglf3UgOEYx8yBZDCWUQFwhf2Eor3Ouz
         BVM/TQYAjWQ4NjeOXP5WCaWWDftJKJZ7QjKzK1hjMFcD6thpVFkwxnZC7PfCFHmyyQ
         2884cIXsSC/C2suSJzQryU3Fz+mYxbMqEcH+SFtQ=
Received: from [100.100.57.122] (unknown [58.34.185.106])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id B3558600DA;
        Mon, 22 May 2023 11:42:53 +0800 (CST)
Message-ID: <fb7f0c26-b609-c225-f8db-de32e72cd97b@xen0n.name>
Date:   Mon, 22 May 2023 11:42:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v11 31/31] LoongArch: KVM: Add maintainers for LoongArch
 KVM
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230522031217.956464-1-zhaotianrui@loongson.cn>
 <20230522031217.956464-32-zhaotianrui@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230522031217.956464-32-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/5/22 11:12, Tianrui Zhao wrote:
> Add maintainers for LoongArch KVM.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   MAINTAINERS | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 27ef11624748..0b6fe590f275 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11357,6 +11357,18 @@ F:	include/kvm/arm_*
>   F:	tools/testing/selftests/kvm/*/aarch64/
>   F:	tools/testing/selftests/kvm/aarch64/
>   
> +KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
> +M:	Tianrui Zhao <zhaotianrui@loongson.com>
> +M:	Bibo Mao <maobibo@loongson.com>

Your company email addresses end with loongson.cn, aren't they? ;-)

> +M:	Huacai Chen <chenhuacai@kernel.org>
> +L:	kvm@vger.kernel.org
> +L:	loongarch@lists.linux.dev
> +S:	Maintained
> +T:	git https://github.com/loongson/linux-loongarch-kvm
> +F:	arch/loongarch/include/asm/kvm*
> +F:	arch/loongarch/include/uapi/asm/kvm*
> +F:	arch/loongarch/kvm/
> +
>   KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>   M:	Huacai Chen <chenhuacai@kernel.org>
>   M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

