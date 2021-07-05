Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5F3BBD82
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 15:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhGENd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 09:33:58 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF7FC061574;
        Mon,  5 Jul 2021 06:31:21 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id f13so5743975lfh.6;
        Mon, 05 Jul 2021 06:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqJSKXEq1qvxzt4fRoDnpx/9Q8+N8oW72HArhulx5c4=;
        b=S5tyMH6tdDy8zu6XhKnUxvI8WfUNknC0197JRod1YHnrJ8jMpMeuShvMurJcL/XN61
         PDaQQysmSZMu6p5Nyq+REnvvk+4w5EKJvCsGqhzt0N/KmSd205Vn3YI5lqBibyoMCN24
         pLLaeuMtw8ipDdi7YiljZQg9WUchUHZWmUSGaYzedNYq/w2aLLE9n5K0I4YFRpw2eoc5
         nlbPHLyXwo5YyivgVBjkqu+hvUk4WNcHlHhMoxg0BE7AzYlTqx26jXaQbVmzC9qpDiPz
         OD+Be5fu6NJXk6/RDeeTHRLb2IaN6C0ktskTTMLMN84z3X8IZHe5xl68Rw9KeOwfoJbC
         HAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqJSKXEq1qvxzt4fRoDnpx/9Q8+N8oW72HArhulx5c4=;
        b=PIOxuuxWr16TVlARz4BcO6dI1xTN5SKjNT5LXS/4+5hC9+pAbGY1Y7s9pLJPlBtzwI
         GaB7a5W+Bffy5oHQx2PN3BQElViYDUMwYVMlzKFchk7aIm9z+LLiQZX9ISj6nif9TEZ+
         eile3hpH+guTkAEieDBtJBjfcbAXJWRkg6bwo0gyLphsRZjgoBGqb2ReRJiCMFRL2kzQ
         KYtlWl8v3pO8BFRItzrOxnXMm1qbZW5bJLsY3JS4P6hDSU4Oygoss02/bPLUTDDYpojT
         QX7q5EQHE35xSFQJleoXL49CUQNf05VVXUSaQUddNctl0Plr9ygspjt+gMGsfoNNgT1b
         Gqjw==
X-Gm-Message-State: AOAM5336hXtjzkcPUdRwWgA8mzkoGQhnuHq4/pHm2YYY2gL7aO3jSG8s
        dnQnu+uoe+3mJ1+sq5tTDbE=
X-Google-Smtp-Source: ABdhPJw+GZgQ+lQ0lANw8cUSXymS8JLjFao55geIUHEN5JpD1+kXXSNMY6a7Ute3/ROcp/zTpckg0Q==
X-Received: by 2002:a05:6512:3b8c:: with SMTP id g12mr10741709lfv.551.1625491879881;
        Mon, 05 Jul 2021 06:31:19 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id q21sm1090364lfp.233.2021.07.05.06.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:31:19 -0700 (PDT)
Date:   Mon, 5 Jul 2021 16:31:13 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in kvm_dev_ioctl
Message-ID: <20210705163113.367df3f1@gmail.com>
In-Reply-To: <CACT4Y+aeiQ9=p6esuAseErekJnLzxFL1eG7qpWehZHUfb8UoNw@mail.gmail.com>
References: <000000000000bfb6cf05c631db0b@google.com>
        <20210703101243.45cbf143@gmail.com>
        <CACT4Y+Yk5v3=2V_t77RSqACNYQb6PmDM0Mst6N1QEgz9CdYrqw@mail.gmail.com>
        <20210705143652.56b3d68b@gmail.com>
        <CACT4Y+aeiQ9=p6esuAseErekJnLzxFL1eG7qpWehZHUfb8UoNw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jul 2021 13:47:30 +0200
Dmitry Vyukov <dvyukov@google.com> wrote:

> On Mon, Jul 5, 2021 at 1:36 PM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > On Mon, 5 Jul 2021 07:54:59 +0200
> > Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > > On Sat, Jul 3, 2021 at 9:12 AM Pavel Skripkin
> > > <paskripkin@gmail.com> wrote:
> > > >
> > > > On Fri, 02 Jul 2021 23:05:26 -0700
> > > > syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>
> > > > wrote:
> > > >
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of
> > > > > git://anongit... git tree:       upstream
> > > > > console output:
> > > > > https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000
> > > > > kernel config:
> > > > > https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
> > > > > dashboard link:
> > > > > https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7
> > > > > syz repro:
> > > > > https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000 C
> > > > > reproducer:
> > > > > https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag
> > > > > to the commit: Reported-by:
> > > > > syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com
> > > > >
> > > >
> > > > Corresponding fix was sent about 2 days ago
> > > > https://patchwork.kernel.org/project/kvm/patch/20210701195500.27097-1-paskripkin@gmail.com/
> > >
> > > Hi Pavel,
> > >
> > > Thanks for checking. Let's tell syzbot about the fix:
> > >
> > > #syz fix: kvm: debugfs: fix memory leak in kvm_create_vm_debugfs
> >
> >
> > Hi, Dmitry!
> >
> > Sorry for stupid question :)
> >
> > I don't see, that my patch was applied, so syzbot will save the
> > patch name and will test it after it will be applied? I thought
> > about sending `syz fix` command, but I was sure that syzbot takes
> > only accepted patches.
> 
> Hi Pavel,
> 
> Please see if http://bit.do/syzbot#communication-with-syzbot answers
> your questions.


Yes, it does. Thank you! 


With regards,
Pavel Skripkin
