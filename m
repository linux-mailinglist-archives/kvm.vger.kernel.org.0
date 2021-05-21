Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7FE38CCF1
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 20:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEUSJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 14:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhEUSJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 14:09:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E6AC0613ED
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 11:08:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso5991961pjb.0
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 11:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=5U6SWI6tKwJQxiyyyLqjT1i8tYx3isO7hjR5W5+1Jeo=;
        b=vtTnyRah2kvhTAvKkgyp5rIri/BGQNchS7lXj3oCYhV5McFBbxGTr4EjYc6mvyOinn
         3AfMgA6VhS3u8947Z/3CuaEcMpm7wash5s4UhzpQ/gq2UOH/pXd1P8HP6LXs2AX2ghZ7
         WTvvt1/yfLL8GYTjA6616yKQHybiIg2wPemKZer7/tMyrMrTs7n6j06sv5XO10p5HCbh
         yLcC8WefzjiIY7amtnohfd+oXEAboa4fIZAxuILISPaizFwPRbUSghFsEjTIIQvrWCKL
         mLont745Oggstxjw6092u9UjqC0L3W/ZSGD2MiRRew69QhYXK6txzd/ZBpU4jI6Eu+y6
         cfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=5U6SWI6tKwJQxiyyyLqjT1i8tYx3isO7hjR5W5+1Jeo=;
        b=qg8cBQ2+k55JCUWN4KwkixXNOOskYV29uL6BQjXO+zpOQQ4l/K8iqBvS1GDqWneTKd
         dSnieMEn+mxuOl1LQbysVIaHVBSJrvHrv4GJE1PaCfrjnr3Ak4XFhXYBNsj319EQqxxg
         CA2fCUupwScsWoGxfpjme+kVI6VIUJZ8dbcGJjpaayfgQy+xHFA4lueGv51GafCuU8kG
         GkxTqj0J5s+wjXYBvLB5HONNQNRUhTT5l+axS67yxkh9ElJ1AlVogt6YQH9q4K5HgVct
         GJvzytuKYZlgKdlL+HKWudb2oB84wwxE+hRvQE2t5OQXpGk4CQ9qPQGTZH7xkAUhDa6k
         PBpA==
X-Gm-Message-State: AOAM533yYp887J0qCDxjSBcJ7PdUilBcfh6bpaRb8EWTboGGNHrPJG+I
        f+cAxXpKwcz+AOX1ON0d0TyyoQ==
X-Google-Smtp-Source: ABdhPJwLEJQWqh67UT0dt8OTf7ZYOzZievMqQ6z7E3S6USV227nLPVyaUv+fvSjbWzdxhAnKUIgAHA==
X-Received: by 2002:a17:902:f543:b029:f3:bfca:21b4 with SMTP id h3-20020a170902f543b02900f3bfca21b4mr13333335plf.6.1621620495939;
        Fri, 21 May 2021 11:08:15 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id r11sm4812600pgl.34.2021.05.21.11.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 11:08:15 -0700 (PDT)
Date:   Fri, 21 May 2021 11:08:15 -0700 (PDT)
X-Google-Original-Date: Fri, 21 May 2021 11:08:12 PDT (-0700)
Subject:     Re: [PATCH v18 00/18] KVM RISC-V Support
In-Reply-To: <YKfyR5jUu3HMvYg5@kroah.com>
CC:     pbonzini@redhat.com, anup@brainfault.org,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, corbet@lwn.net, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Message-ID: <mhng-122345f7-47d9-4509-8ae6-ce1da912fc00@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 May 2021 10:47:51 PDT (-0700), Greg KH wrote:
> On Fri, May 21, 2021 at 07:21:12PM +0200, Paolo Bonzini wrote:
>> On 21/05/21 19:13, Palmer Dabbelt wrote:
>> > >
>> >
>> > I don't view this code as being in a state where it can be
>> > maintained, at least to the standards we generally set within the
>> > kernel.  The ISA extension in question is still subject to change, it
>> > says so right at the top of the H extension <https://github.com/riscv/riscv-isa-manual/blob/master/src/hypervisor.tex#L4>
>> >
>> >   {\bf Warning! This draft specification may change before being
>> > accepted as standard by the RISC-V Foundation.}
>>
>> To give a complete picture, the last three relevant changes have been in
>> August 2019, November 2019 and May 2020.  It seems pretty frozen to me.
>>
>> In any case, I think it's clear from the experience with Android that
>> the acceptance policy cannot succeed.  The only thing that such a policy
>> guarantees, is that vendors will use more out-of-tree code.  Keeping a
>> fully-developed feature out-of-tree for years is not how Linux is run.
>>
>> > I'm not sure where exactly the line for real hardware is, but for
>> > something like this it would at least involve some chip that is
>> > widely availiable and needs the H extension to be useful
>>
>> Anup said that "quite a few people have already implemented RISC-V
>> H-extension in hardware as well and KVM RISC-V works on real HW as well".
>> Those people would benefit from having KVM in the Linus tree.
>
> Great, but is this really true?  If so, what hardware has this?  I have
> a new RISC-V device right here next to me, what would I need to do to
> see if this is supported in it or not?

You can probe the misa register, it should have the H bit set if it 
supports the H extension.

> If this isn't in any hardware that anyone outside of
> internal-to-company-prototypes, then let's wait until it really is in a
> device that people can test this code on.
>
> What's the rush to get this merged now if no one can use it?
>
> thanks,
>
> greg k-h
