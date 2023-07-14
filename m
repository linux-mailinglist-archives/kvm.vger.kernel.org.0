Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F397536E9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 11:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbjGNJqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 05:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235774AbjGNJpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 05:45:44 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0002D51;
        Fri, 14 Jul 2023 02:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1689327935; bh=je53xgpjUO3Kn0r9UmjMsQwwLu/6ZQ6k+jN6jnhYPJg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Tjx99n6hXAabeXlajgLHSK2tIIUMoTUEgyrMKx6v/0LeQxOh2tKh2N0y/wYqBZtfd
         zSIsHQol6LHSTmLwS7Gn7A6XbJgq4S3Er4A/ngl+2PVb1mqECLsPcoyrNvoXw7Zrfr
         e3A22y4t3TigGm2+Cw5e0KF6ZNtPhn6r6jSY3G0k=
Received: from [100.100.34.13] (unknown [220.248.53.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id E085660148;
        Fri, 14 Jul 2023 17:45:34 +0800 (CST)
Message-ID: <81270b55-37c4-d566-8cd7-acc90b490c10@xen0n.name>
Date:   Fri, 14 Jul 2023 17:45:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v16 05/30] LoongArch: KVM: Add vcpu related header files
Content-Language: en-US
To:     Huacai Chen <chenhuacai@kernel.org>, bibo mao <maobibo@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, hejinyang@loongson.cn,
        Tianrui Zhao <zhaotianrui@loongson.cn>
References: <20230629075538.4063701-1-zhaotianrui@loongson.cn>
 <20230629075538.4063701-6-zhaotianrui@loongson.cn>
 <CAAhV-H7P_GSsoo+g5o0BTCzK4fxwH5d2dQOYde-VpcGvn4SXQA@mail.gmail.com>
 <152f7869-d591-0134-cf9d-b55774a135e8@loongson.cn>
 <CAAhV-H4N2wdB8n7Pindv9WdVPLPOboK0Ys75SWOkMZU+=NWEbQ@mail.gmail.com>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <CAAhV-H4N2wdB8n7Pindv9WdVPLPOboK0Ys75SWOkMZU+=NWEbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/14 17:22, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Fri, Jul 14, 2023 at 3:45 PM bibo mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> 在 2023/7/14 15:11, Huacai Chen 写道:
>>> Hi, Tianrui,
>>>
>>> On Thu, Jun 29, 2023 at 3:55 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>>>>
>>>> Add LoongArch vcpu related header files, including vcpu csr
>>>> information, irq number defines, and some vcpu interfaces.
>>>>
>>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>>>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>> ---
>>>>   arch/loongarch/include/asm/insn-def.h  |  55 ++++++
>>>>   arch/loongarch/include/asm/kvm_csr.h   | 231 +++++++++++++++++++++++++
>>>>   arch/loongarch/include/asm/kvm_vcpu.h  |  97 +++++++++++
>>>>   arch/loongarch/include/asm/loongarch.h |  20 ++-
>>>>   arch/loongarch/kvm/trace.h             | 168 ++++++++++++++++++
>>>>   5 files changed, 566 insertions(+), 5 deletions(-)
>>>>   create mode 100644 arch/loongarch/include/asm/insn-def.h
>>>>   create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>>>>   create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>>>>   create mode 100644 arch/loongarch/kvm/trace.h
>>>>
>>>> diff --git a/arch/loongarch/include/asm/insn-def.h b/arch/loongarch/include/asm/insn-def.h
>>>> new file mode 100644
>>>> index 000000000000..e285ee108fb0
>>>> --- /dev/null
>>>> +++ b/arch/loongarch/include/asm/insn-def.h
>>>> @@ -0,0 +1,55 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>> +
>>>> +#ifndef __ASM_INSN_DEF_H
>>>> +#define __ASM_INSN_DEF_H
>>>> +
>>>> +#include <linux/stringify.h>
>>>> +#include <asm/gpr-num.h>
>>>> +#include <asm/asm.h>
>>>> +
>>>> +#define INSN_STR(x)            __stringify(x)
>>>> +#define CSR_RD_SHIFT           0
>>>> +#define CSR_RJ_SHIFT           5
>>>> +#define CSR_SIMM14_SHIFT       10
>>>> +#define CSR_OPCODE_SHIFT       24
>>> As all needed instructions have already upstream in binutils now and
>>> binutils 2.41 will be released soon, I suggest again to introduce
>>> AS_HAS_LVZ_EXTENSION and make KVM depend on AS_HAS_LVZ_EXTENSION.
>> It is a good news that binutils 2.41 has supported LVZ assemble language.
>> we will add AS_HAS_LVZ_EXTENSION support, however KVM need not depend on
>> AS_HAS_LVZ_EXTENSION since bintuils 2.41 is not popularly used. yeap we
>> need write beautiful code, also we should write code with pratical usage.
> 1, For pure upstream: the CI toolchain comes from
> https://mirrors.edge.kernel.org/pub/tools/crosstool/. Since binutils
> 2.41 will be released soon, CI toolchain will also be updated soon.
> 
> 2, For community distributions, such as Fedora rawhide, Debian
> unstable and Arch: they usually choose the latest released version, so
> binutils 2.41 will be used quickly.

You seem to have missed CLFS for LoongArch [1] and Gentoo [2] ;-)

These two distros are also very punctual in adopting new toolchain 
versions: the maintainer of CLFS for LoongArch is Loongson employee 
himself (and he's the author of the Fedora LoongArch Remix too), while 
the Gentoo toolchain team usually follow the upstream release very 
quickly. (I happen to maintain the Gentoo loong port too, and also am a 
member of gentoo-toolchain team.)

[1]: https://github.com/sunhaiyong1978/CLFS-for-LoongArch
[2]: https://wiki.gentoo.org/wiki/Project:LoongArch

> 
> 3, For downstream distributions, such as UOS and Kylin: if they choose
> kernel as new as 6.6, they may probably choose binutils as new as
> 2.41; if they choose an LTS kernel (e.g., 6.1), they should backport
> KVM support to the kernel, then they don't have any reason to not
> backport LVZ instructions support to binutils.

I generally agree with Huacai here. If those distros pick bleeding-edge 
kernel releases then they have no reason to not also bump the toolchain 
baseline too; otherwise they must be backporting. In which case they either:

a) pull patches from v6.6, so they may as well integrate the binutils 
patches along the way (trivial compared to kernel backports), or
b) ask Loongson to provide the patches, in which case you may just give 
this version of code to them, which can be done (and I assume, has 
already been done) without any upstream involvement.

All in all I don't see a reason for hardcoding any opcode in this 
particular time, when everyone involved agrees on moving fast.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

