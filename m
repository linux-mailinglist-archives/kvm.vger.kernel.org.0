Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81E05304FA
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 19:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349871AbiEVRjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 13:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiEVRjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 13:39:23 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB10186C0;
        Sun, 22 May 2022 10:39:22 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i68so10182122qke.11;
        Sun, 22 May 2022 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkCujTokcqPtWiwpiGRk5TtIbZPWLmLWKiJpPt/OGWo=;
        b=ZItGJ02c4c8FBNvKfrvVRaMVpja1L3Tmz8glCrjwgC0rSrah9foKJrdU0Tr9NhfMLi
         sDgQPqgUU/yA2kK4MP44nJSubsFxdeCwx58ISc4L4wbA8tGdUmgbZqHfu8OjXcuaezeS
         3yR61TbCcYS0ugkO0Mqj3tPxUcR55UQ2Oi6FlDTKkAeW4W7Tzrfe4rjVmB9gpGfKo+J9
         xDXmHPuy9wD37TRxdKm9qecP4CdqrmyoOzXXfwBVLCXfeu3872/BqZZRSWNNvQ1xJdbL
         Iewvssuu0kfzz2fi7BzWE0CI3OOzRUJ2eyWyDpXbtQufRixNtdnW87DMcLUFmwNVdQv+
         afoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkCujTokcqPtWiwpiGRk5TtIbZPWLmLWKiJpPt/OGWo=;
        b=Ro0vMim7NWqB/JR38phM8T3DlVb0kEOsHqz+QJvYjQ3xfDhQERcMt4GIytBdDKcvRh
         lQQ1qajF02/NeNlxdAkMr+AMp826fD6Ghj3CIuUDKEC9uJPy0nyFSCruCzk6dTrnS/Ww
         nxLPePQ925rj0/Raf9zDXwtOOaMajHkYk46SxfaWlTt9uqRn9EqkVrZRf+uXcst3uEsJ
         tztKjGEsNnZH0B/wu8E/KyOHW4bQRslslQDUg2hVXkesfWao5FH7UmWlj+j+ZveA/p03
         bK64SZBQwkpwcAe191oF+vPxGb370MNb2Uvw40OJQwRCRN8/rQkFjjE1oS1iljXRwP1s
         Ttlw==
X-Gm-Message-State: AOAM533/ba9FLtk6bQaTXFKNSrK2k1rCBv+FHO+rNgi59gp0Y6sjmr2d
        k0aGaoTI7NM6u2GwvIcQY1I=
X-Google-Smtp-Source: ABdhPJxZLxs0+TkUltsfJwRF5N/FN9ogf4uiCB2TmPZQWm1f9m2I7PENOE+YgL9VRGB4i56uZKRmTw==
X-Received: by 2002:a37:6685:0:b0:6a3:686f:699a with SMTP id a127-20020a376685000000b006a3686f699amr4169112qkc.390.1653241161897;
        Sun, 22 May 2022 10:39:21 -0700 (PDT)
Received: from localhost (c-69-254-185-160.hsd1.fl.comcast.net. [69.254.185.160])
        by smtp.gmail.com with ESMTPSA id h11-20020a05620a21cb00b006a36b7e55b3sm2642393qka.4.2022.05.22.10.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 10:39:21 -0700 (PDT)
Date:   Sun, 22 May 2022 10:39:19 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@aculab.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 11/22] KVM: x86: hyper-v: replace bitmap_weight() with
 hweight64()
Message-ID: <Yop1R+Z7OtIcfrvA@yury-laptop>
References: <20220510154750.212913-1-yury.norov@gmail.com>
 <20220510154750.212913-12-yury.norov@gmail.com>
 <20220522145357.GA244394@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522145357.GA244394@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 22, 2022 at 07:53:57AM -0700, Guenter Roeck wrote:
> On Tue, May 10, 2022 at 08:47:39AM -0700, Yury Norov wrote:
> > kvm_hv_flush_tlb() applies bitmap API to a u64 variable valid_bank_mask.
> > Since valid_bank_mask has a fixed size, we can use hweight64() and avoid
> > excessive bloating.
> 
> In kvm_hv_send_ipi(), valid_bank_mask is unsigned long, not u64.
> 
> This results in:
> 
> arch/x86/kvm/hyperv.c: In function 'kvm_hv_send_ipi':
> include/asm-generic/bitops/const_hweight.h:21:76: error: right shift count >= width of type
> 
> on all 32-bit builds.
> 
> Guenter

Hi Guenter,

The fix is in Paolo's tree:
https://lore.kernel.org/lkml/20220519171504.1238724-1-yury.norov@gmail.com/T/

Thanks,
Yury
