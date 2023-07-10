Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25274DF36
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjGJU3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 16:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjGJU26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 16:28:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66C413E
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 13:28:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8959fb3c7so58682225ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 13:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689020937; x=1691612937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rF29GRgI8hOW8jLROF4KwGHDbjmxwt4c6jNir/qrBzs=;
        b=jOkorrw1678EU4ez642rTZ8VfFOAcxpduo03I2ahHvbcWtPyX1J9zaxk9/HdnXV5NF
         +8NbcVqbXxIEETOSio0rxJoqfOFcya+Q2zzEYN8/fNNNZhZr/koS7KObNfEFEr4edCYG
         g2otY5bdgkOa+0E7RELb6lFzySFZIP8voBrD4PR9VBD7ILLRAclviplJxyOQPaXuKSMn
         ANzmrhcTL3RD0Tl5DGWR/knsa+xTrfDSUDkyKz9aCBjL3LiPBp9HFz9nayULGVFla0nc
         80PIUiTW0WSKogKnyAAfCYQjdVEQaXl8YbAY/SrRBlKDsx/fX9G5/KTdHoV2xrgWvcBg
         +Pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689020937; x=1691612937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rF29GRgI8hOW8jLROF4KwGHDbjmxwt4c6jNir/qrBzs=;
        b=IPnJt6UZpTnFQMsGthehilWu5SLi46nRB+YAnIbcD0Ybq0jsC9w49FWHP8ouLTHicc
         PIdQkj8tXVOYlz5R/lbUfNiADLY0MXt6cQEghX3Upf3dYZKQiH5zQ0zX+mkerRCYJjXF
         EZurhFdmjKlL1XmHLIMWbie2v85oWx1Tp5CWQC8HyHMufPfxbOgi466VWtWwFGdAhYOn
         uI0jlNweYYujzCdePtKJQfqnzgE+JYFYerycEWgg15IpplBMJcNv4RE1kXgVxUqIZObE
         qCQywLvvM8VMU0hfQtIvDcNQ35pPHLT6wkzBQVwg+1U3XtHaupOrficrEXmhFerKmzLJ
         xh9w==
X-Gm-Message-State: ABy/qLZ117N4Q7IiamYwQl/fiMC8yJvi8WDM/AaTycwTfPIVwDu3mwuN
        rujlp+en5jVyYWKEdGf5QJMIkM4QiCc=
X-Google-Smtp-Source: APBJJlG5lGHrhxyvgWQtaCd0VQa2a0kqO4lf9RNKbEuXXJ+s8Ne6YR8onYAvNGQVdSMH3WQ+Q13aPcYpSQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c1cd:b0:1b8:8fe2:6627 with SMTP id
 c13-20020a170902c1cd00b001b88fe26627mr11923948plc.8.1689020937323; Mon, 10
 Jul 2023 13:28:57 -0700 (PDT)
Date:   Mon, 10 Jul 2023 13:28:55 -0700
In-Reply-To: <000000000000c7224e06001eb4b1@google.com>
Mime-Version: 1.0
References: <000000000000c7224e06001eb4b1@google.com>
Message-ID: <ZKxqB+eKM4bIyehI@google.com>
Subject: Re: [syzbot] Monthly kvm report (Jul 2023)
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+listf42719d660fa6d59a79a@syzkaller.appspotmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023, syzbot wrote:
> Hello kvm maintainers/developers,
> 
> This is a 31-day syzbot report for the kvm subsystem.
> All related reports/information can be found at:
> https://syzkaller.appspot.com/upstream/s/kvm
> 
> During the period, 2 new issues were detected and 0 were fixed.
> In total, 5 issues are still open and 111 have been fixed so far.
> 
> Some of the still happening issues:
> 
> Ref Crashes Repro Title
> <1> 138     Yes   WARNING in kvm_arch_vcpu_ioctl_run (5)
>                   https://syzkaller.appspot.com/bug?extid=5feef0b9ee9c8e9e5689

This will *hopefully* be resolved when the unrestricted guest patches[*] are
applied.  This WARN is a bit of a catch-all.  The upside is that it detects a lot
of bugs, the downside is completely unrelated bugs can have the same signature,
i.e. there may be more bugs lurking.

[*] https://lore.kernel.org/all/20230613203037.1968489-1-seanjc@google.com

> <2> 89      Yes   WARNING in handle_exception_nmi (2)
>                   https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1

This is likely a bug in the underlying GCE kernel, i.e. in L0.  Not sure how to
bin this one.

> <3> 58      No    WARNING in kthread_bind_mask
>                   https://syzkaller.appspot.com/bug?extid=087b7effddeec0697c66

This is more than likely a bug in either the workqueues or in sched, e.g. btrfs hit
the same WARN a while back with a similarly innocuous alloc_workqueue() call.
I'll (try to) re-label to "kernel".
