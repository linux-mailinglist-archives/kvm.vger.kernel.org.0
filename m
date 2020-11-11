Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1472AEF3B
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgKKLLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 06:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgKKLK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 06:10:57 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970B4C0613D4
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 03:10:57 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 199so1223109qkg.9
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 03:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xL5Q18luW55DFgY5qIJpBb4hGKIq5/0exgv15jkw5PA=;
        b=KA206W0OsGAcMx0RC2zgZz6H0z3KWiwKwk5hW9qsc5ejhI4ujHFBRpGUmWE84MPVwj
         Hp4wNN2jTiU8sZUR3K1rYzDZnW8Hg/SMc/iEvl7mKHSucyrSxC8ouXKISfrS5JaUgRXC
         IaiaeXoLiLV2CNawA9a4lWOj/DdsnlxZ7L81N1TcedJxdJdKm48JBFqfmT54B6UIYLM+
         vEOoPKHKUqFjudiiC+M2hAIEFdfxs+smeYtVgHXr3O5ybg2PJW/huWFU6G5uqvr6SePf
         T2nw6evuhWsm0wjFbYg/G3V5PfsTA98ro/MawyezibNqs+mwjBQipRZthECgYerzJ6jA
         D2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xL5Q18luW55DFgY5qIJpBb4hGKIq5/0exgv15jkw5PA=;
        b=SLBHiJRu+FWu5yJLbAU1sstwPcUouI6DZD1Ltv2Tfwn0dVI6i66Vh6eE7B3zAlyjtZ
         JqBJF/f+uMpwKizi/aFe4oDBAnYdcNfQ5Zo/cpx40lRmv9ix7pcaisNBL5moONhVyfgN
         jsrE+1ASA+cTxJakFkDXJd+0AxS+PxDltVODUQFycp0OQ2V23WVog7T5yp2lyWkYRFgt
         hcMNX7rQjpyKb4dhuwP6MIOyXuHZwbYKTiefRdCPMoNFMRtf18v0MkitPYNHD0dZZHlF
         ftA6iGCn7Bg46cph1LtwAVlGKSFy5WWwHEHbYYsylEYO4ZlnYbEQ4tPnLTRxQzAJw6/e
         g6qw==
X-Gm-Message-State: AOAM530GL+1a/kw46sWht0Jt6pAtAYbZy+LyxhjpIntlOHv1AzL9Fwef
        s49PbgMU1vjAshfvOetO7W5vdf88ChpeHRuTwhGKFr6aQzIO1A==
X-Google-Smtp-Source: ABdhPJyI3UheLHmkme855QFP63dcp2usOsIKZoDZJYqmGB0JLR180nPSoPT9jx4uaQlQsjoTK1lhdwC44y5nGfoAnt0=
X-Received: by 2002:a05:620a:15ce:: with SMTP id o14mr25220689qkm.231.1605093056602;
 Wed, 11 Nov 2020 03:10:56 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd392b05b0a1b7ac@google.com> <00000000000014484705b35f4414@google.com>
In-Reply-To: <00000000000014484705b35f4414@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 12:10:45 +0100
Message-ID: <CACT4Y+ZUwvPxWHM=Vt1g1S+ZxhJktGbM-QmG7K_dXV4UijHRSQ@mail.gmail.com>
Subject: Re: WARNING in handle_exception_nmi
To:     syzbot <syzbot+4e78ae6b12b00b9d1042@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        Will Deacon <will@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 5, 2020 at 6:17 PM syzbot
<syzbot+4e78ae6b12b00b9d1042@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit f8e48a3dca060e80f672d398d181db1298fbc86c
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Oct 22 10:23:02 2020 +0000
>
>     lockdep: Fix preemption WARN for spurious IRQ-enable
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17bbfa8a500000
> start commit:   d3d45f82 Merge tag 'pinctrl-v5.9-2' of git://git.kernel.or..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
> dashboard link: https://syzkaller.appspot.com/bug?extid=4e78ae6b12b00b9d1042
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f24a0b900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167b838f900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: lockdep: Fix preemption WARN for spurious IRQ-enable
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: lockdep: Fix preemption WARN for spurious IRQ-enable
