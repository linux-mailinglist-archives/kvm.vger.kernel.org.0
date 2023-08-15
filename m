Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AAD77CBF0
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 13:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbjHOLpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 07:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbjHOLpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 07:45:35 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF3510F2;
        Tue, 15 Aug 2023 04:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692099933;
        bh=B7H1wPFCpZ/hwcxJ8xFa02xLG2LsuWtZGZq9nBFeRnc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LUPBAVlSpuRgIRR98QO4bxof9MsLaohXOUN9wiGby8bl8wipoJbYkvf1YY2cn89Gv
         t45/vrPScckhf5z+hnEE/5ZU5T5Jb4YvvKRHOrgDgyj+RdqTnXbHt2XPfb+G60EKCy
         k/l8A9wXO5UlsY2/Rb2nb3tShkZyeYnddkCZ7v1l8rg8iCvPwTSIa1uCbU956KtWoH
         +rtEvUs4pTxUM/6h51Azav1JywoSc5ncSo9Qf+tq/0Wl1woiTqTuEfQcsp4sDATmo/
         OWA4st3T3eJe60cxapz/6wpFSdJMlMofxxrBGHPXbsf1JduhLa/Oj8pbQjkd5PJJEV
         2b9U2x+yNCfWg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RQ8bK0G9fz4wZs;
        Tue, 15 Aug 2023 21:45:33 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
In-Reply-To: <CACRpkdZuLeMKg1vG9+8tcUtWUNN-EowhpPmt6VnGuS+f9ok81g@mail.gmail.com>
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
 <87y1icdaoq.fsf@mail.lhotse>
 <CACRpkdZuLeMKg1vG9+8tcUtWUNN-EowhpPmt6VnGuS+f9ok81g@mail.gmail.com>
Date:   Tue, 15 Aug 2023 21:45:30 +1000
Message-ID: <87il9gcyw5.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:
> On Tue, Aug 15, 2023 at 9:30=E2=80=AFAM Michael Ellerman <mpe@ellerman.id=
.au> wrote:
>> Linus Walleij <linus.walleij@linaro.org> writes:
>
>> > -     return ((unsigned long)__va(pmd_val(pmd) & ~PMD_MASKED_BITS));
>> > +     return (const void *)((unsigned long)__va(pmd_val(pmd) & ~PMD_MA=
SKED_BITS));
>>
>> This can also just be:
>>
>>         return __va(pmd_val(pmd) & ~PMD_MASKED_BITS);
>>
>> I've squashed that in.
>
> Oh you applied it, then I don't need to send revised versions, thanks Mic=
hael!

Yeah, it's in my next-test, so I can still change it if needed for a day
or two. But if you're happy with me squashing those changes in then
that's easy, no need to send a v2.

cheers
