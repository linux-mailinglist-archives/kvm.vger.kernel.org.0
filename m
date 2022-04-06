Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CC54F6AA4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiDFT6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiDFT6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:58:22 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A25E26E020
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 11:26:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d5so5541090lfj.9
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 11:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9MSEQiGX4w+Gj5Hnf9X/GdnyPnaA8vq0dsZaIRkOhs=;
        b=UQCbCU83Jyh/KNEJVyGoQ+9c4hJBtLu8phhkHqJDRycLQLAI2EyeA25FYBmbQRHO2Y
         Z0ZxINFDbMU88OM8HgA68CT46ralIOVViXkjujP7Gon1Vr0UQ4MZeRbxAMxMy3aKjVU9
         f/c0n7+QwKFXLQMBCLViGPD7mwTswWu90kSvz4Kr6DLBKJpW5bPBizRw3t9WGeS29uq5
         2h7JAYAF/e9RewvUQbkKLZQIdeJ9vatIp7QgY1474dQwPlMqP/ixDG7FiOR93P5bWcxJ
         wM2ESOMcH+4h0rVav4WDSWTk6h+P287KoTQJlOe1fOR2nIyPPZYtdw2kMtE6DZN+kC2X
         uL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9MSEQiGX4w+Gj5Hnf9X/GdnyPnaA8vq0dsZaIRkOhs=;
        b=LU4m5ZSR2A1fyyqv2XvX6qKLnmCUyQDd6XAH8mJgbiqJBbiwDBz2N4/cSDsbMEYVCe
         IWP834izCQCmPqeIgtt2K0HA5r8kUgLmMvt5TDvsZFOtW+JQeoYKnsw6YGmvVEq1Ebrk
         wM0ejQadhb4wQFTqokwL5bia4fiJxUzJkTeemAOKEuSMWIN66BoFmBH/l+2Sxkt8Su3R
         2rTGSTtKFX3jNz5Dibs74nzT8PG9QHJhweFi+sysQ93y7d30J4F3hTiRjFZdpWukUuAC
         jhEkmtpHQjwsbiiiVkKw9qa6fcET+ThAOvOBhVRJR8v5b3hl5szb+DAyzK56ZaDiH85s
         voow==
X-Gm-Message-State: AOAM5303rR6sKvZh926PXnUIsbAI7hsM87OhrmMiTbVqRtjHB1amsqeB
        kI3woE9DNSYD0uhzmuU3Ulv3as98e4YSlXkv3BLQEaO07TuXqQ==
X-Google-Smtp-Source: ABdhPJyaBCLeg4EwMtCtiJce4VSVnmDIgx5OuJNHxvpobGEbby9DmFxO6zVAqFq14QJEfG8XCrb7qg3gzewMjUTWhyQ=
X-Received: by 2002:ac2:5dee:0:b0:464:f074:ba73 with SMTP id
 z14-20020ac25dee000000b00464f074ba73mr129429lfq.392.1649269617073; Wed, 06
 Apr 2022 11:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000008dae05dbfebd85@google.com> <7108f263-5cda-d91d-792b-d3f18b63c6d7@redhat.com>
In-Reply-To: <7108f263-5cda-d91d-792b-d3f18b63c6d7@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 6 Apr 2022 11:26:45 -0700
Message-ID: <CAKwvOd=-4S1nV=qa3CGNPTAMOv9fGYZsh8hQPXDH1MpowYDX=w@mail.gmail.com>
Subject: Re: [syzbot] upstream build error (17)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Cc:     syzbot <syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        mingo@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 6, 2022 at 10:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/6/22 18:20, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    3e732ebf7316 Merge tag 'for_linus' of git://git.kernel.org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10ca0687700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=eba855fbe3373b4f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6b36bab98e240873fd5a
> > compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com
> >
> > arch/x86/kvm/emulate.c:3332:5: error: stack frame size (2552) exceeds limit (2048) in function 'emulator_task_switch' [-Werror,-Wframe-larger-than]
> > drivers/block/loop.c:1524:12: error: stack frame size (2648) exceeds limit (2048) in function 'lo_ioctl' [-Werror,-Wframe-larger-than]
>
> I spot-checked these two and the stack frame is just 144 and 320 bytes
> respectively on a normal compile.  This is probably just the effect of
> some of the sanitizer options.

Yep.
$ wget -q https://syzkaller.appspot.com/x/.config\?x\=eba855fbe3373b4f
-O - | grep CONFIG_KASAN=y
CONFIG_KASAN=y
https://github.com/ClangBuiltLinux/linux/issues/39 (our oldest still-open issue)
-- 
Thanks,
~Nick Desaulniers
