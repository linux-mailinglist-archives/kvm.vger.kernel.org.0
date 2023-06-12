Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0261B72D53A
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbjFLXw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 19:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjFLXw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 19:52:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E01713
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 16:52:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56cea71b98fso41136527b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 16:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686613974; x=1689205974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEFBZqLeOnIerekrccz1lLmd8Qe7x3UoGwlW9bvhl44=;
        b=74uw2p5KDfHpf77SJVASj5uH76Ilvhf8JMHoUd9hNY4bzbEdPddbUR68jtbbJnKFsM
         gDIWe5FzLrY16wmXdA2kSlMQohD4Sf/24Mm1XVRBvr3UyNkrRqEPLVyoGmDhW+Sfp8yp
         P1wiPuquT7/7+IjfiJx6Wbd0C8KQUHkSsanNbHDpnZbRVc7MDRFv+WB4agCvZ3BNE7bl
         yLvBH9ckD4qAuruf8TpfR5yFn37hspUeIEFSEB1R1CBbRS2hiwhecagfkEfo/CXv+X+Z
         vIy69c59exvRUyffGsAhO8qmPISg9DJhH4iBBDAXPvE7ymbg07gwyOIyNByaCTX3Y3Oq
         t4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686613974; x=1689205974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uEFBZqLeOnIerekrccz1lLmd8Qe7x3UoGwlW9bvhl44=;
        b=E3q1b5fmNQ+TnuYeV3npWlngXNc4h8omnVDPW37Ako2abYKDWuHtLI99DpDfIbpLML
         3ibJ0QYrKZcX5v3eQB8AaSU9ygcJc/qY1yAcbRRTdh3KVB4kkPdhhpktDr3RYrWc5IpH
         DHgKp/o+tY/fZ+VJcsj3FRp83keVm95h3IqlIEwSYkmDj940AwPOb1nlE8tYXFkfn5OR
         xLgEHunJDZepnvmoK2bkA3ICA5XztFg17ubL0TBYYiDJah8RQFN1OCktNfNleeA7TlDe
         U+rb46g+P5YvzOW/zSRndubkRaUA/6zXocV7cpklS3MyUw1ZkH2mwpgJ6Sz6WuoKfNm5
         lQzg==
X-Gm-Message-State: AC+VfDxbkQFP0+TI2Ki6XToEKqbYMPamczdKeCO2urOy4ytqkn6RXtkK
        r/lout/7kxRrIWekDXJtRCtERCyvQPI=
X-Google-Smtp-Source: ACHHUZ4jeKee0CjUjPElP1qI0aJ+KnIqVQ4G5y9q65QKkFJYHCvJMcSpmAn0PBTGxIHzEQVL0jzKUYM4abA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e30a:0:b0:56c:f693:9d04 with SMTP id
 q10-20020a81e30a000000b0056cf6939d04mr84447ywl.10.1686613974687; Mon, 12 Jun
 2023 16:52:54 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:52:52 -0700
In-Reply-To: <000000000000f316b705fdf6e2b4@google.com>
Mime-Version: 1.0
References: <000000000000f316b705fdf6e2b4@google.com>
Message-ID: <ZIev1Fj/PQV5lEwM@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_arch_vcpu_ioctl_run (5)
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    64569520920a Merge tag 'block-6.4-2023-06-09' of git://git..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12386cd9280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c980bfe8b399968
> dashboard link: https://syzkaller.appspot.com/bug?extid=5feef0b9ee9c8e9e5689
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adcb43280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13af3853280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4421ae3b4ee0/disk-64569520.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9312cbb35f54/vmlinux-64569520.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3476854febf3/bzImage-64569520.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com
> 
> kvm_intel: L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> kvm: vcpu 1: requested 128 ns lapic timer period limited to 200000 ns
> kvm: vcpu 1: requested lapic timer restore with starting count register 0x390=1812281087 (231971979136 ns) > initial count (200000 ns). Using initial count to start timer.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5004 at arch/x86/kvm/x86.c:11099 kvm_arch_vcpu_ioctl_run+0x2379/0x2820 arch/x86/kvm/x86.c:11099
> Modules linked in:
> CPU: 1 PID: 5004 Comm: syz-executor120 Not tainted 6.4.0-rc5-syzkaller-00245-g64569520920a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
> RIP: 0010:kvm_arch_vcpu_ioctl_run+0x2379/0x2820 arch/x86/kvm/x86.c:11099

KVM doesn't reject KVM_SET_SREGS with a bad CR0, which combined with an L2 that's
configured with unrestricted guest *disabled*, coerces KVM into stuffing VM86 state
to virtualize Real Mode, and eventually leads to all kinds of weirdness.  Will post
a patch "shortly" (probably tomorrow at this point).
