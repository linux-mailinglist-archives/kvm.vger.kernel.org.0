Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E54F6865
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 19:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiDFRzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiDFRza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 13:55:30 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489E83C8C2F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 09:20:23 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id r16-20020a056e02109000b002ca35f87493so2006545ilj.22
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 09:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LPDWwLlqsdkU08oFWKxHzU6RAOblUfdn4Uz94Jc/vec=;
        b=cJxXc0LMBGQoCZO4Nrt+tU/ckYwLq7UGCFqEn70FoDFHp4x3N5xnS28I9MZDKuS8zs
         tBn7mkLIMpHDkPzWPMviwdhWN8NVlGJDAAOkgXy1b5tPKAGHgr96TzBzFSMkieNfNQBY
         3tocnv/Gln1SFyX31JJhaAdFx5I+CrmSG/phswT95EUWSG45qp4lm/2GqBOyJQM7hvge
         BIWJTbAMn9LoO8tWGP3u1NtGyiemei+NcLy2JXKtBo7HHLiJjehOjrCRRh0BZ7wS/JZb
         /5gc/nvHOVNDRDUBdVnuArZ2ZYNe7xicX2Cm0F1hWrvH/vNKdBAWd7eTq9uuzCkJoLyS
         pdJQ==
X-Gm-Message-State: AOAM531wcEYKrL3vKiudfsV+Gft3nV0nAEogZrUk3rVDqAwm30kMe40Z
        I15Hx8eep3LqFXX8MPf38ty5rn0kgj9txrniQ8e3kKgCLwmW
X-Google-Smtp-Source: ABdhPJybY8vgvTKMRiNccae0QC/VP+OHClBhZJ4ZVV687OjbRUQ5PiLnMtqB43Gzv8vfuLCtaMYjfVILFwqwuOyL8UFqvPnXw7fa
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a84:b0:2ca:d62:ebf8 with SMTP id
 k4-20020a056e021a8400b002ca0d62ebf8mr4533187ilv.120.1649262022655; Wed, 06
 Apr 2022 09:20:22 -0700 (PDT)
Date:   Wed, 06 Apr 2022 09:20:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000008dae05dbfebd85@google.com>
Subject: [syzbot] upstream build error (17)
From:   syzbot <syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3e732ebf7316 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ca0687700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eba855fbe3373b4f
dashboard link: https://syzkaller.appspot.com/bug?extid=6b36bab98e240873fd5a
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com

arch/x86/kvm/emulate.c:3332:5: error: stack frame size (2552) exceeds limit (2048) in function 'emulator_task_switch' [-Werror,-Wframe-larger-than]
sound/usb/mixer_s1810c.c:543:5: error: stack frame size (2072) exceeds limit (2048) in function 'snd_sc1810_init_mixer' [-Werror,-Wframe-larger-than]
drivers/block/loop.c:1524:12: error: stack frame size (2648) exceeds limit (2048) in function 'lo_ioctl' [-Werror,-Wframe-larger-than]
crypto/ecc.c:1362:6: error: stack frame size (3640) exceeds limit (2048) in function 'ecc_point_mult_shamir' [-Werror,-Wframe-larger-than]
crypto/ecc.c:1280:13: error: stack frame size (3832) exceeds limit (2048) in function 'ecc_point_mult' [-Werror,-Wframe-larger-than]
fs/ocfs2/dlm/dlmdomain.c:2101:19: error: stack frame size (2104) exceeds limit (2048) in function 'dlm_register_domain' [-Werror,-Wframe-larger-than]
net/qrtr/ns.c:661:13: error: stack frame size (3096) exceeds limit (2048) in function 'qrtr_ns_worker' [-Werror,-Wframe-larger-than]

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
