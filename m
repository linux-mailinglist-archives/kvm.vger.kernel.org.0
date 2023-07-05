Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5669774820D
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjGEKYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjGEKYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:24:36 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A410C3
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1688552672;
        bh=bxv5RlBw6jHHPJ7/NqKkDq8EbXeFR8b7l8+ro4TxGJQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UdIY8cZIOeoWNhvIOKtCcw77iFwNU4tPzQm83Pj5w4fs9L2qztMlbZeaC0W3xH9z2
         aYvCBKhg6yATq0oziwTavYJvkzA3ZdxGIeTsaTxDFEosRq4Huh2m263mzx0RAquRbD
         J6JevD0fqKmonOyUG8fI02vHJ4frfviAEdJNMWvVdw45rtbN0sSJsvG6ZkAtSAMC0l
         CH2XBTFFVeYYkisWMAxt5VBLZBPRzfZ/7TZDknwnr206ujdM7bXG14tvLdTwSAaumH
         JdoU+yHcFc0KkAlNf3nxK7ZyWW9kEzCqcC38SiQ06udfFY/IZm23i8+PdkxuEj55yv
         Ya23lfLb6/yhw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qwwkm0Cgmz4wqX;
        Wed,  5 Jul 2023 20:24:32 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sean Christopherson <seanjc@google.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Update MAINTAINERS
In-Reply-To: <ZJx0OVEphb/OqQ+t@google.com>
References: <20230608024504.58189-1-npiggin@gmail.com>
 <ZJx0OVEphb/OqQ+t@google.com>
Date:   Wed, 05 Jul 2023 20:24:31 +1000
Message-ID: <87zg4aveow.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:
> On Thu, Jun 08, 2023, Nicholas Piggin wrote:
>> Michael is merging KVM PPC patches via the powerpc tree and KVM topic
>> branches. He doesn't necessarily have time to be across all of KVM so
>> is reluctant to call himself maintainer, but for the mechanics of how
>> patches flow upstream, it is maintained and does make sense to have
>> some contact people in MAINTAINERS.
>> 
>> So add Michael Ellerman as KVM PPC maintainer and myself as reviewer.
>> Split out the subarchs that don't get so much attention.
>> 
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>
> Thanks for documenting the reality of things, much appreciated!
>
> Acked-by: Sean Christopherson <seanjc@google.com>
>
>>  MAINTAINERS | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0dab9737ec16..44417acd2936 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -11379,7 +11379,13 @@ F:	arch/mips/include/uapi/asm/kvm*
>>  F:	arch/mips/kvm/
>>  
>>  KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
>> +M:	Michael Ellerman <mpe@ellerman.id.au>
>> +R:	Nicholas Piggin <npiggin@gmail.com>
>>  L:	linuxppc-dev@lists.ozlabs.org
>> +L:	kvm@vger.kernel.org
>> +S:	Maintained (Book3S 64-bit HV)
>> +S:	Odd fixes (Book3S 64-bit PR)
>> +S:	Orphan (Book3E and 32-bit)
>
> Do you think there's any chance of dropping support for everything except Book3S
> 64-bit HV at some point soonish?

Nick proposed disabling BookE KVM, which prompted some users to report
they are still actively using it:

  https://lore.kernel.org/all/20221128043623.1745708-1-npiggin@gmail.com/

There are also still some KVM PR users.

In total I'd guess it's only some small 100s of users, but we don't
really know.

> There haven't been many generic KVM changes that touch PPC, but in my
> experience when such series do come along, the many flavors and layers
> of PPC incur quite a bit of development and testing cost, and have a
> high chance of being broken compared to other architectures.

Ack.

cheers
