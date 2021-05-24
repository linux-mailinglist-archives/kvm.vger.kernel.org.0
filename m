Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF5038F68A
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhEXX4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXX4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:56:45 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D446C061574;
        Mon, 24 May 2021 16:55:15 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id v13-20020a4ac00d0000b029020b43b918eeso6751745oop.9;
        Mon, 24 May 2021 16:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRnXCD+92FNz7EDcLk9ph/Nc8eMDGwxajC0s/Qy/6Wo=;
        b=leZimnSf/OOoTBvgyCGyeSDpGQp6rEt9Rkz5dbOG7WixjZpf2hxOwkzJ1jqk+mHx3Z
         xLgz8HQ9C6YZ6j+ISKKyqrpkWrDY1LihASZ+XYbV+gePRIhddSKpVwBum+lYuMEJ+4R0
         1cpO/9ZW7zjc53d3yH7RY5AxeL0W8vTxvhJaKBYoYWjGQyZyyXmsNsi7nUgkmbN0FicR
         zskl1xhZjFz7ayqVW+zmQhz6yxdR7dz3Y6ZSjDMv2bDwjZtuwXrCOeGJhzkxlrRCU69C
         K/mbmrQdplYpyc2BifhWLIfQD/gHTznO8oWfa3lLanmoyfgV3Lr79c8QYLhuFppIPgRV
         u2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRnXCD+92FNz7EDcLk9ph/Nc8eMDGwxajC0s/Qy/6Wo=;
        b=DI7ZOaJWtS4uS9pJfibE+R8lK9JvoyGUq0Rchrmb6RlB3AIqAKX8bsXWCRd7fSNWm7
         bXa9mKP6R2DLHkFPsZxyYvRreoJkYP7rgHvRloPHOa/aid5o9lodVgU6/iKBwjwHauc1
         o8VYsgAhPi7S6IQF9983vjLbPfbcqffUdRdjRnedUSmdsVJ/oXrua6ATiLs+xrEqOYJY
         63hPRo1IJOD1ig8oysKozHsOvc/F1KuWsDaOYLcspz/KGtGuLf9hepdeKRdchSOE6oq6
         qpSYjwJgYnlZn+fijuKQyEXOgUFrGxVDUJJ9Dg7Nu69kuu9neD4XWdZ0LfhNCqkjY4Lu
         e6bg==
X-Gm-Message-State: AOAM532WoEvAGOoBnYPCvD9RwzbWvUgdzqUdENzJfRXCA7viI7NLpD71
        hhzyEJGfof3u16L3zFFthrQecNIiegE4Ij2QV7E=
X-Google-Smtp-Source: ABdhPJwzG4XtZSuaatRoAIedCLWwMklX/5iEANj/5kMsuk42vdeuM007l0yGTVz4ydVLT5dN9eeR/LyQfLAWDX+UeaU=
X-Received: by 2002:a4a:8706:: with SMTP id z6mr20307749ooh.41.1621900514993;
 Mon, 24 May 2021 16:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210525093221.1b62a5f4@canb.auug.org.au>
In-Reply-To: <20210525093221.1b62a5f4@canb.auug.org.au>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 May 2021 07:55:03 +0800
Message-ID: <CANRm+CyrwrC8ccgJo0ymQ1m9KF7XeYCwsLQewt_4w7DYZgm7nw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the kvm-fixes tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 May 2021 at 07:33, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the kvm-fixes tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> ERROR: modpost: ".kvm_vcpu_can_poll" [arch/powerpc/kvm/kvm-hv.ko] undefined!
>
> Caused by commit
>
>   0fee89fbc44b ("KVM: PPC: exit halt polling on need_resched()")

This is my fault.

From b2a6d98b48fc6b22a0b47f57a98dc3203c678195 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Tue, 25 May 2021 07:50:08 +0800
Subject: [PATCH] KVM: Fix ERROR: modpost: .kvm_vcpu_can_poll undefined!

From: Wanpeng Li <wanpengli@tencent.com>

Export kvm_vcpu_can_poll to fix ERROR: modpost: .kvm_vcpu_can_poll undefined!

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 62522c1..8eaec42 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2949,6 +2949,7 @@ bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 {
     return single_task_running() && !need_resched() && ktime_before(cur, stop);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_can_poll);

 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
--
2.7.4
