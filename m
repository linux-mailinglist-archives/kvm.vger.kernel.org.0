Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E956C2E8F12
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 01:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbhADA4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jan 2021 19:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbhADA4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jan 2021 19:56:03 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07F7C061574
        for <kvm@vger.kernel.org>; Sun,  3 Jan 2021 16:55:22 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id d203so30382526oia.0
        for <kvm@vger.kernel.org>; Sun, 03 Jan 2021 16:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Tk8aeB1lMcqEvmEiRLSZYEP/rdW9yQtGNUZwFbieVA=;
        b=sMiglgVYI4ufM+s8kU4v0P9/sZIVAhkSjgP8Olk5dNiz3iubEo9aoIhiXBrgK0hBVE
         CbjAu/q5DBsK+0FPml0ajiu0EBK7aaxDmwPN7G0yrlU1YI63gThFZOgIEXZPEeyMDXM2
         9JJRcUC+zwXemO7Phe8/8ptV/dIQOX3SAJDhgoUfXg9yic84YGqABaSXocUXMLn14bEU
         sSLSax/UlPJfSmzrV2gEIzX9pmxHhW2GYgbL1tu8nnEkLr0vRGTeVsECPP7C4jrPvyEC
         4XFa2le+BS9fnXe5iLHbNJKBQLGwoXHP3H4JtV9ba6dC7Jxjqic3tChBOJXfGmZHJYS/
         98wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Tk8aeB1lMcqEvmEiRLSZYEP/rdW9yQtGNUZwFbieVA=;
        b=h6I524zkANQNwMVKU1sI82A6FOUcabgPJVR9vd63D68F5hPQWk6HwbaMte1VHIaI8j
         ikL2SeyZeI3vVNVQDY5A/1VPYCqgrGJkyz5PqiT8rPoxvhAQQzKoiFgob+0XKtLk29wU
         k2RrUHHt1U25HCnOZh0I1MvdU1LUTJIGAYP5XO1fsgiWRwY68B0jXVMhtPCW90tTUQfh
         Xrn6rNyDJ3SfCyU+JYYWTWC+c70yEjDC7jf9lC5vi9QWR3ygA6h+P0z28DdPZDhz5pjp
         IBALCGn5lK0/nSSTUx0+U+IRYKwszW23r6Kqp0Cyj7Bkg1iLEHUtfojmw9FDrDQPQoeI
         TlkA==
X-Gm-Message-State: AOAM532CRO0Y/81GC/RnnsnN2Twr93i+tx8F+s+WT2AOaqHnHdya3NQL
        XldhfIKzCHeoyXQZpFwRmibacj2nUc0cHYYK3OI=
X-Google-Smtp-Source: ABdhPJxEA3Uh0Tn3CslwYOpdh8Z7+sidzeFScoIgaReNMBhrRVx1b1YI8CYsXHXGBhzsoEwrpkoHqvnMzeh88UcTmNc=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr16624669oig.33.1609721722186;
 Sun, 03 Jan 2021 16:55:22 -0800 (PST)
MIME-Version: 1.0
References: <CAP8WD_bZXpQnENCay5hDaoTQDHm26nRj9Lsa1PMQsd2wNHxe5A@mail.gmail.com>
In-Reply-To: <CAP8WD_bZXpQnENCay5hDaoTQDHm26nRj9Lsa1PMQsd2wNHxe5A@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 4 Jan 2021 08:55:11 +0800
Message-ID: <CANRm+CyA39vwmfLgxfCGzKszKPurUQoG4NbB4nH=7eiUJ3r_0A@mail.gmail.com>
Subject: Re: kvm_arch_para_features() call triggers invalid opcode on i486
To:     whiteheadm@acm.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Jan 2021 at 00:42, tedheadster <tedheadster@gmail.com> wrote:
>
> Paolo,
>   I am doing regression testing on a first generation i486 and came up
> with a kernel crash because it incorrectly thinks the processor
> supports KVM features. Yes, we do still support the ancient i486.
>
> This processor does NOT have the cpuid instruction, and I believe
> testing for it returns -1 (not supported) in two's-compliment form.
>
> I think the -1 is not checked for, and this is causing
> kvm_arch_para_features() to think it _does_ support
> KVM_CPUID_FEATURES, causing it to later execute an invalid opcode
> (cpuid).

Please try the latest Linus tree or kvm/queue, it will not have this
issue since commit 64b38bd1906bb ("x86/kvm: do not setup pv tlb flush
when not paravirtualized").

    Wanpeng
