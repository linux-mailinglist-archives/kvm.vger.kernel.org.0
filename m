Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC93E32D5BA
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 15:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhCDO54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 09:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhCDO5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 09:57:34 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E6FC061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 06:56:54 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d9so27450840ote.12
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 06:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metztli-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=Egt7O0hrtmxmw6ied+hJV1grz0SHUeSD2SQDlj862Pk=;
        b=fUI/6ZYJMWbUFwjm8jmBfNsfDL4299KeFqYaRVzK5VlqyLXiWQm4/KkiD9Z+Aus4TL
         0SoZiCvH/Ri7z14bYhnrrgIMuW7Ur1qGeL1MTIBofB8C5SS4PqqPd6vZs8GPNvyI803Y
         SAsc1nOg4EcGqdnjZ1mWcKrYWvjWjbz0MNuH0rsY3jkH2jQ32elwCupKgkiSKjTnnHuY
         lCAgnBTLoG/7A07pGFEopN8Bi0hlk1RAyf+7e5rEVh5MwhVNLGs9TfBcGw4fsDuM5LeD
         o9nCfgnaqlrIy2K/AT2ZicNDCCSh4YB7NRYScdEvRVop5ht+cTAOkkk9Fp87MJI2kvf5
         BwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=Egt7O0hrtmxmw6ied+hJV1grz0SHUeSD2SQDlj862Pk=;
        b=QG7qBzPEMz7LpTgli+1a3p10R5LykM+om1pEoY4GRPhlQkHoMNCLETFMLqNy/V7/m4
         7uEyRzex2NW3yXKRIVSJyJgQkOGdb+UCEJNOJSkzvNwXfXFynPx82Y2dSpzKREEQEiVq
         7x9+sWkChRJY9ZwWT0Such52xDhSLsixoZI4b4zguehPEFQkW4UgRvTj4Zvi7OJHKaDZ
         2Jav188w2jeoWHdfciKxHOiUk8/EfgKKXsDiQaaXecHkEAv+UOGb9lIVCZXLGZj9eRse
         fmfIwp5lfPouJNVb2RLTyCZG5J24lMvwu4/jJxb9fbv+TmI5500wBvlgt6QZpoTyskml
         Kb3A==
X-Gm-Message-State: AOAM530vPEnXXmLl879pxisVjrjwOEz4Ow9ilyecMiq5x+Hla+3YKpO9
        hKKVuaGaxDnf0WYeNs0NhmV7pQ==
X-Google-Smtp-Source: ABdhPJxkNQEB58oZZK3MLqb8eVT35aclKdHIFuP+UL5QdOgSBqHXSzTlszl4v2CAnz/kmCtQxy/h8g==
X-Received: by 2002:a05:6830:1afc:: with SMTP id c28mr3734282otd.99.1614869813366;
        Thu, 04 Mar 2021 06:56:53 -0800 (PST)
Received: from ?IPv6:2600:1700:6470:27a0:682c:9aef:c4a9:8393? ([2600:1700:6470:27a0:682c:9aef:c4a9:8393])
        by smtp.gmail.com with ESMTPSA id i3sm5834233otk.56.2021.03.04.06.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:56:52 -0800 (PST)
Message-ID: <f709dc80a94fa6ee0f34dc785e7f30ba58850122.camel@metztli.com>
Subject: Re: unexpected kernel reboot (3)
From:   Jose R Rodriguez <jose.r.r@metztli.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     syzbot <syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Gargi Sharma <gs051095@gmail.com>, jhugo@codeaurora.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>, linux@dominikbrodowski.net,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Edward Shishkin <edward.shishkin@gmail.com>
Date:   Thu, 04 Mar 2021 06:56:50 -0800
In-Reply-To: <CACT4Y+b1HC5CtFSQJEDBJrP8u1brKxXaFcYKE=g+h3aOW6K3Kg@mail.gmail.com>
References: <000000000000eb546f0570e84e90@google.com>
         <20180713145811.683ffd0043cac26a5a5af725@linux-foundation.org>
         <CACT4Y+b1HC5CtFSQJEDBJrP8u1brKxXaFcYKE=g+h3aOW6K3Kg@mail.gmail.com>
Organization: Metztli Information Technology
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2018-07-16 at 12:09 +0200, Dmitry Vyukov wrote:
> On Fri, Jul 13, 2018 at 11:58 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 13 Jul 2018 14:39:02 -0700 syzbot <
> > syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com> wrote:
> > 
> > > Hello,
> > > 
> > > syzbot found the following crash on:
> > 
> > hm, I don't think I've seen an "unexpected reboot" report before.
> > 
> > Can you expand on specifically what happened here?  Did the machine
> > simply magically reboot itself?  Or did an external monitor whack it,
> > or...
> 
> We put some user-space workload (not involving reboot syscall), and
> the machine suddenly rebooted. We don't know what triggered the
> reboot, we only see the consequences. We've seen few such bugs before,
> e.g.:
> https://syzkaller.appspot.com/bug?id=4f1db8b5e7dfcca55e20931aec0ee707c5cafc99
> Usually it involves KVM. Potentially it's a bug in the outer
> kernel/VMM, it may or may not be present in tip kernel.

I have been using GCE with my custom VirtualBox -created reiser4 root fs VMs
since at least 2018, long term mainly as web servers with LAMP / LEMP --
including some Ruby apps with Postgresql -- and short term to build our Debian
Linux kernels. I have not experienced 'suddenly rebooted' scenarios.

Note that I have been usin Intel CPUs at the Los Angeles zone us-west2-a, as
well as us-east1-b zone, and AMD Epyc CPUs at us-central1-a zone, without
abnormalities (other than it's becoming more expensive ;-)

As a matter of fact, I am currently testing a Debian'ized reiser4 (AMD Epyc -
flavored reizer4 label) -enabled Linux kernel 5.10.15-2 which has logged 17 days
+hours already and sustaining most of the apps already mentioned.
< https://metztli.it/buster/r4-5.10.15-gce.png >

> 
> 
> > Does this test distinguish from a kernel which simply locks up?
> 
> Yes. If you look at the log:
> 
> https://syzkaller.appspot.com/x/log.txt?x=17c6a6d0400000
> 
> We've booted the machine, started running a program, and them boom! it
> reboots without any other diagnostics. It's not a hang.
> 
> 
> 
> > > HEAD commit:    1e4b044d2251 Linux 4.18-rc4
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=17c6a6d0400000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
> > > dashboard link: 
> > > https://syzkaller.appspot.com/bug?extid=cce9ef2dd25246f815ee
> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=165012c2400000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1571462c400000
> > 
> > I assume the "C reproducer" is irrelevant here.
> > 
> > Is it reproducible?
> 
> Yes, it is reproducible and the C reproducer is relevant.
> If syzbot provides a reproducer, it means that it booted a clean
> machine, run the provided program (nothing else besides typical init
> code and ssh/scp invocation) and that's the kernel output it observed
> running this exact program.
> However in this case, the exact setup can be relevant. syzbot uses GCE
> VMs, it may or may not reproduce with other VMMs/physical hardware,
> sometimes such bugs depend on exact CPU type.
> 
> 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
> > > 
> > > output_len: 0x00000000092459b0
> > > kernel_total_size: 0x000000000a505000
> > > trampoline_32bit: 0x000000000009d000
> > > 
> > > Decompressing Linux... Parsing ELF... done.
> > > Booting the kernel.
> > > [    0.000000] Linux version 4.18.0-rc4+ (syzkaller@ci) (gcc version 8.0.1
> > > 20180413 (experimental) (GCC)) #138 SMP Mon Jul 9 10:45:11 UTC 2018
> > > [    0.000000] Command line: BOOT_IMAGE=/vmlinuz root=/dev/sda1
> > > console=ttyS0 earlyprintk=serial vsyscall=native rodata=n
> > > ftrace_dump_on_oops=orig_cpu oops=panic panic_on_warn=1 nmi_watchdog=panic
> > > panic=86400 workqueue.watchdog_thresh=140 kvm-intel.nested=1
> > > 
> > > ...
> > > 
> > > regulatory database
> > > [    4.519364] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> > > [    4.520839] platform regulatory.0: Direct firmware load for
> > > regulatory.db failed with error -2
> > > [    4.522155] cfg80211: failed to load regulatory.db
> > > [    4.522185] ALSA device list:
> > > [    4.523499]   #0: Dummy 1
> > > [    4.523951]   #1: Loopback 1
> > > [    4.524389]   #2: Virtual MIDI Card 1
> > > [    4.825991] input: ImExPS/2 Generic Explorer Mouse as
> > > /devices/platform/i8042/serio1/input/input4
> > > [    4.829533] md: Waiting for all devices to be available before
> > > autodetect
> > > [    4.830562] md: If you don't use raid, use raid=noautodetect
> > > [    4.835237] md: Autodetecting RAID arrays.
> > > [    4.835882] md: autorun ...
> > > [    4.836364] md: ... autorun DONE.
> > 
> > Can we assume that the failure occurred in or immediately after the MD code,
> > or might some output have been truncated?
> > 
> > It would be useful to know what the kernel was initializing immediately
> > after MD.  Do you have a kernel log for the same config when the kerenl
> > didn't fail?  Or maybe enable initcall_debug?
> > 
> > --
> > You received this message because you are subscribed to the Google Groups
> > "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an
> > email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit 
> > https://groups.google.com/d/msgid/syzkaller-bugs/20180713145811.683ffd0043cac26a5a5af725%40linux-foundation.org
> > .
> > For more options, visit https://groups.google.com/d/optout.

(saw your last message of just a couple of hours and...)

Hope provided info helps.

Best Professional Regards.

-- 
-- 
Jose R R
http://metztli.it
-----------------------------------------------------------------------
Download Metztli Reiser4: Debian Buster w/ Linux 5.9.16 AMD64
-----------------------------------------------------------------------
feats ZSTD compression https://sf.net/projects/metztli-reiser4/
-----------------------------------------------------------------------
or SFRN 5.1.3, Metztli Reiser5 https://sf.net/projects/debian-reiser4/
-----------------------------------------------------------------------
Official current Reiser4 resources: https://reiser4.wiki.kernel.org/

