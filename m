Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968C64D4D1
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLOAxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiLOAxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:53:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBC631372
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:53:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so1081519pjr.3
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eg2uix4z/WEf9zETr7MjYcro2yv1FRTpbDhT4aQx4YM=;
        b=gNbVgqTq9vJL+z/6drn6m9iK5xkj1erfyh9l/baTlm7K8AmEhd9gSVIJjy66lRDkmV
         7gWZ4y9rrbhwtjqWdy6nY+fvCNXE5K1C8hhahgZNxw2EgX9I9lHaqLdWmqBsSaWpE9bv
         v1ABUHvi1i5Xy0XXpwz30Vy6hjkVIrBbQames5yqpskgn0qVnuxscnrxEsOEQPfuS751
         SvZKWdDnhjI95V6GMyNcvlkeTnksbdU5UlLpyZ7JhhqYvjzyJhhb0ERYOAqR9l/hHyPA
         PMvUL5H4nNtCeZQm4IOo6fBzLDFv/Y+0Pke+Au+LM1tqPP3P/vyE+gzoWLlA/kbot460
         EEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eg2uix4z/WEf9zETr7MjYcro2yv1FRTpbDhT4aQx4YM=;
        b=1plEmHiKjI0Evmi5jxcNCgjBZ+SO+DjheIkCnwGu6c8jAH5c/vj3z/MCnrKVSBT/8C
         9CiDRan0/yaPQIk5EFV7EGBMbX5uBc5MqozBVuwFQO8uxcPoysN1MJ8gAMd8Mnox4Wvv
         uRsxV0p08flH5Yc43MoSH0ce6W0t9aVPQ0kf3yoGdyh5WNJwwhyuGl6OTYuPdphKX7H2
         hX65fGG7XDXWVg2KKE80WyCgvA7Y1t5zIHpH/S+HJ8ZYBL08kaLpuvvjvoU2ciHKaljz
         xFqPqWP7kTcPoFLf8+VVJdy3woRpEz//UT8cSTuKpTAWBMI26ypcmUgYjEoy7EdVIkFg
         nhRQ==
X-Gm-Message-State: ANoB5pnSK6YhqTIlew4Vv5wZ98Q9MIpoLBU8ZfZZHE3rOdNrGm3HTP7H
        OkUhA3UYwM0DMcH4L1NOX4cHJ2jdKovObj4+
X-Google-Smtp-Source: AA0mqf589/p7WADF/kJSfbiMjxsUEvvKI+MuHNeDGLUQLo4JXDs2FM8Dm2QXtVaQMo+C2pmuRWDLKw==
X-Received: by 2002:a17:902:7b96:b0:189:858f:b5c0 with SMTP id w22-20020a1709027b9600b00189858fb5c0mr963628pll.0.1671065599626;
        Wed, 14 Dec 2022 16:53:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902779000b001783f964fe3sm2451597pll.113.2022.12.14.16.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:53:18 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:53:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: RFC: few questions about hypercall patching in KVM
Message-ID: <Y5pv+/58UBDAfP19@google.com>
References: <9c7d86d5fd56aa0e35a9a1533a23c90853382227.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c7d86d5fd56aa0e35a9a1533a23c90853382227.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022, Maxim Levitsky wrote:
> Hi!
> 
> 
> Recently I had to debug a case of KVM's hypercall patching failing in a
> special case of running qemu under valgrind.
>  
> In nutshell what is happening is that qemu uses 'cpuid' instruction to gather
> some info about the host and some of it is passed to the guest cpuid, and
> that includes the vendor string.
>  
> Under valgrind it emulates the CPU (aka TCG), so qemu sees virtual cpu, with
> virtual cpuid which has hardcoded vendor string the 'GenuineIntel', so when
> your run qemu with KVM on AMD host, the guest will see Intel's vendor string
> regardless of other '-cpu' settings (even -cpu host)
>  
> This ensures that the guest uses the wrong hypercall instruction (vmcall
> instead of vmmcall), and sometimes it will use it after the guest kernel
> write protects its memory.  This will lead to a failure of the hypercall
> patching as the kvm writes to the guest memory as if the instruction wrote to
> it, and this checks the permissions in the guest paging.
> 
> So the VMCALL instruction gets totally unexpected #PF.

Yep, been there, done that :-)

> 1. Now I suggest that when hypercall patching fails, can we do
> kvm_vm_bugged() instead of forwarding the hypercall?  I know that vmmcall can
> be executed from ring 3 as well, so I can limit this to hypercall patching
> that happens when guest ring is 0.

And L1.  But why?  It's not a KVM bug per se, it's a known deficiency in KVM's
emulator.  What to do in response to the failure should be up to userspace.  The
real "fix" is to disable the quirk in QEMU.

> 2. Why can't we just emulate the VMCALL/VMMCALL instruction in this case
> instead of patching? Any technical reasons for not doing this?  Few guests
> use it so the perf impact should be very small.

Nested is basically impossible to get right[1][2].  IIRC, calling into
kvm_emulate_hypercall() from the emulator also gets messy (I think I tried doing
exactly this at some point).

[1] https://lore.kernel.org/all/Yjyt7tKSDhW66fnR@google.com 
[2] https://lore.kernel.org/all/YEZUhbBtNjWh0Zka@google.com
