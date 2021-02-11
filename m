Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B320731904C
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 17:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBKQqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 11:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhBKQod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 11:44:33 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF01DC06178C
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 08:43:46 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id j5so4264814pgb.11
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 08:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q8cYYXpQD69b29Rz/wpLt70Z0TQIcwFQEc6shque2So=;
        b=LOxo1kM4fI9rRUnG5+ONbkAIcsGEd/Rywcs4GV9HUOeuzBibBkGOj86HekEsV0s77W
         Ahv4UuCate+g5qtkch9nKhsYPNL+uesmoJmpT2OZXdB6sE9Eh+R3Nuz+8weOHIQG5whG
         KMBoms0r5ijFuu9X7mz1g9sgJN/fdhd7Yd/MZV/oN8x/IIkdJEgbw40m2oUTgFlrHYRn
         c9/BoZ+08S8NUYfmQjrcSQYvTO8GsMxadIf1NWMmTgg1LXBOu4btY/EFOfbwG+2AWxjx
         zOnmbTf3NN5Sg38BxiUX9lAJ/ZK1SISZNfwIFg4CbmHh2P7f9IFc+Vh9kD2w7UITHRLx
         CMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q8cYYXpQD69b29Rz/wpLt70Z0TQIcwFQEc6shque2So=;
        b=oqPgyIsRqjAnEc/tDaeV/xxhmjwSDBjsIU7+VSaPJ+WdDXzIwRKoI9sO2XYxULvjHL
         muKaJVlhS0FzPs2lRfJxfk6zOwCnEwKm9smHaooorZfCeO5QYVXEYDPnV9cm5rFA+nSb
         4oqj8wMC+wbD+5sJUVojrwvqovTn2q2juBznTCItb9V4J6REnCUza5ASnUb4hsE7jExB
         MG1gwF/Mt8568qiYvaPumAg6sRtf4r+GVJRwupJQDtDXvXEBQSK18GPo16iKlMQ/0JbR
         sqN/q/8ANJSxRI63cDWhcS3v48us2+1zQUrjsvJgzkgvctShP/gnsjzljqzn5PZu6uAQ
         WdIA==
X-Gm-Message-State: AOAM533nbwvXmyJ4z/E+lret1rKgQ40S4gf52RtEQ/7/7A0FHnzqBw3c
        VW6rcJEDteIVDKkmEoSHYK1CB9uoim4KMQ==
X-Google-Smtp-Source: ABdhPJzNtYM3Yj74V3gA5Zip72qFg0TSAP3m2hD2KDTKjTuS7T+diIoWhvPLpeKZcvBiVM/p+tb7YQ==
X-Received: by 2002:aa7:9293:0:b029:1df:4e2:c981 with SMTP id j19-20020aa792930000b02901df04e2c981mr8512078pfa.41.1613061826269;
        Thu, 11 Feb 2021 08:43:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id p2sm6495119pgl.19.2021.02.11.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 08:43:45 -0800 (PST)
Date:   Thu, 11 Feb 2021 08:43:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Jonny Barker <jonny@jonnybarker.com>, KVM <kvm@vger.kernel.org>
Subject: Re: your patch "KVM: x86: Update emulator context mode if SYSENTER
 xfers to 64-bit mode"
Message-ID: <YCVeuxKYW2L6+pFs@google.com>
References: <6032a7c3-94d3-0d53-4c94-4767b5a9d6c3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6032a7c3-94d3-0d53-4c94-4767b5a9d6c3@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Jan Beulich wrote:
> I've noticed this patch while routinely screening the stable
> kernel logs for issues we may also need to fix in Xen. Isn't
> a similar change needed in SYSCALL emulation when going from
> compat to 64-bit mode?

Yep, it is.  AMD's APM explicitly states that compat always transitions to long
mode.

I believe em_sysexit() is technically buggy as well, though in the opposite way,
as it doesn't set ctxt->mode when switching from long mode to compat mode.  But,
it explicitly truncates rdx before assigning to rip so that's likely a benign
bug, at least for now.

I don't see anything in em_rsm() that will fixup ctxt->mode, so I'm guessing an
SMI with a 64-bit RIP will be fatal, too.

__emulate_int_real() can't switch mode, and INTn and company aren't emulated in
protected mode.

assign_eip_far() does update ctxt->mode, so far call/ret aren't broken.

Given the number of flows that can potentially affect mode, and the difficulty
in testing them, I feel like x86_emulate_insn() should handle refreshing the
mode, or at least do a sanity check to verify that it was already updated.

Side topic, I'm super curious why Intel lets SYSRET return to compat mode, when
SYSCALL #UDs in compat mode...
