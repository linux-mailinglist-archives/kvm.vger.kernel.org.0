Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB15977E9
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241861AbiHQUYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 16:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241719AbiHQUYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 16:24:45 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59F66CF4D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 13:24:43 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id f16-20020a6b6210000000b006889725d748so4391359iog.8
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 13:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=0Lb7DBMimZHfZugIsXOodK3jQi78nO6eM2SzszBZKUg=;
        b=CKoy31PNZSv+7Q2GgLdWBRIyk3A2g+HBDKumL8dWxZeXzcSkFJoTPtUqJrwtPPPKWY
         U5E6X3wmSEFtVlWjdfMa88BX7r62QWHSKcfwC8P8jbumgjYF4jPPiSLd7TloE05iI7C7
         5JJ4c0TbsLuS70uD5By28wZmbET7PdIL0nu+MiaZQhv17Mnly9WlG3M/gPXm6avVk2w+
         yLqVRCsUD6xI91K4alRarRr8OXserl+3z12qpu7elTQmSI6oRReldW9RjNdP5EbHyUCh
         mWMChGB6FZxs2GK7ywmh/H9AF+jn5JKIs5Q1jksTcE97Ri2PIT1g2g/X7tdxXHTyEBF4
         9Swg==
X-Gm-Message-State: ACgBeo0YVLgqCIpN+BRFdbyQgf6a+CnDJp6pAzOBMwbtmPBM4UAlFEjk
        gxSvAVWInUhJMQ7uoqcZZyir/Ubv7typ3lMGrboMXLFgJEyH
X-Google-Smtp-Source: AA6agR5U4fcA4nq15MO9T9Ai/5u+IfY47/Oa+2QeUn1EQvVF4BKD0hLYmrolaIdLcMpP9n5A+f1dNfWKHFhLN3pS++qo71Zfl8yi
MIME-Version: 1.0
X-Received: by 2002:a05:6638:264b:b0:343:3ad4:9d7 with SMTP id
 n11-20020a056638264b00b003433ad409d7mr12093778jat.314.1660767882759; Wed, 17
 Aug 2022 13:24:42 -0700 (PDT)
Date:   Wed, 17 Aug 2022 13:24:42 -0700
In-Reply-To: <bb50f7ae-0670-fe7d-c7d7-10036aba13f4@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4d88605e675a71c@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in kvm_dev_ioctl
From:   syzbot <syzbot+8d24abd02cd4eb911bbd@syzkaller.appspotmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 8/17/22 16:30, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10b66b6b080000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c15de4ee7650fb42
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8d24abd02cd4eb911bbd
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+8d24abd02cd4eb911bbd@syzkaller.appspotmail.com
>> 
>> ==================================================================
>> BUG: KASAN: vmalloc-out-of-bounds in __list_add_valid+0x93/0xb0 lib/list_debug.c:27
>> Read of size 8 at addr ffffc90006b7a348 by task syz-executor.4/20901
>> 
>> CPU: 1 PID: 20901 Comm: syz-executor.4 Not tainted 5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>   print_address_description mm/kasan/report.c:317 [inline]
>>   print_report.cold+0x59/0x6e9 mm/kasan/report.c:433
>>   kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
>>   __list_add_valid+0x93/0xb0 lib/list_debug.c:27
>>   __list_add include/linux/list.h:69 [inline]
>>   list_add include/linux/list.h:88 [inline]
>>   kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1219 [inline]
>>   kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4910 [inline]
>>   kvm_dev_ioctl+0xf44/0x1ce0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4957
>>   vfs_ioctl fs/ioctl.c:51 [inline]
>>   __do_sys_ioctl fs/ioctl.c:870 [inline]
>>   __se_sys_ioctl fs/ioctl.c:856 [inline]
>>   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fb1fba89279
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fb1fcc1e168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 00007fb1fbb9bf80 RCX: 00007fb1fba89279
>> RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000004
>> RBP: 00007fb1fbae3189 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007ffea48aadbf R14: 00007fb1fcc1e300 R15: 0000000000022000
>>   </TASK>
>> 
>> Memory state around the buggy address:
>>   ffffc90006b7a200: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>   ffffc90006b7a280: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>> ffffc90006b7a300: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>                                                ^
>>   ffffc90006b7a380: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>   ffffc90006b7a400: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> ==================================================================
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> 
>
> #syz dup: BUG: unable to handle kernel paging request in 

can't find the dup bug

> kvm_arch_hardware_enable
>
