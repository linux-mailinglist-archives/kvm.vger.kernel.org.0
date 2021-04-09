Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0B635A66E
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 20:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhDIS6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbhDIS6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 14:58:33 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB95AC061762
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 11:58:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g35so4598056pgg.9
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 11:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=qzPGYRIIgbwAx3GIWXZYzwGgFSrgnjtXWJk804zYlrk=;
        b=R2zitmc2UyEV/XFPNt4ZmSNyBT88XlV5CyfSwFCKbaDvAMOKHhQmYhcmW8lpJ3DVT3
         O3xwUFblk6wGJdP9AvbLAreJHXUBPiiKV+GpPPrDC6J5pe4D6+0XFpUbR9FRuvbpeoVf
         d31nPgAzjXydWPbI/6YEgHQM9JSocQV3RK90CXUdO7ypRQeaboZBYagiFSBo+EYusG3N
         0d82tK0bvRp31CvuDfLoVqCnkBvB9RlogDGlgnKphfFkXREFMGqR5bWYQs3ysQywimdD
         yEVesZi3bfW44keuWvg4KLYJMfp2mEXxmGRAPK23mlTtNVbLKe/VjJpIQbFGD20E9McU
         ezlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=qzPGYRIIgbwAx3GIWXZYzwGgFSrgnjtXWJk804zYlrk=;
        b=N23Gm4anR3kWETNTrQd50XmrBnuZcH1IicaOpZzTX591dzgCSkvlk/mhvXAhIKMepG
         7k3xeeD5seKMkGNfnf1jkgb1zcd0wI1G3ecISPTKE4NO9wMhQ+svZgfupxidjUJ7wK5g
         ZTyzqpUE9UykYH/MjeMLl5744mVczhb1/ZQpCDSx8pY1PzP0vAyh127az2jPsbVx+PSs
         zg76L62r306VlXbOnQS7eeeXRCjM/HEeiVEOH5pKiO/qiXVfY00KOCejahX87OeckFHu
         5l8vZbAUAFpVE5A9w2H+X0Vna3myrmJz18IZdZm4IEw0qiIk9932HM0mKHDL2zcCWx0g
         2wkA==
X-Gm-Message-State: AOAM530SnYH9HSCrIhwmeh1qDrVDp1qXNUuvr1PWVbWtjsIozujbWSaY
        Zd9Ge1qL4qHDMu127vOAEmS8KA==
X-Google-Smtp-Source: ABdhPJwKIOtldl7rBGs1NBZjyVCx0kPKACsREmjytSOckbEVS1OO/AnMx6b5G8xwh41jOKZDd2aUbA==
X-Received: by 2002:a63:6744:: with SMTP id b65mr14411777pgc.314.1617994700058;
        Fri, 09 Apr 2021 11:58:20 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id l18sm3602095pgh.70.2021.04.09.11.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:58:19 -0700 (PDT)
Date:   Fri, 09 Apr 2021 11:58:19 -0700 (PDT)
X-Google-Original-Date: Fri, 09 Apr 2021 11:58:17 PDT (-0700)
Subject:     Re: [PATCH v16 00/17] KVM RISC-V Support
In-Reply-To: <a49a7142-104e-fdaa-4a6a-619505695229@redhat.com>
CC:     anup@brainfault.org, Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-d64da1be-bacd-4885-aaf2-fea3c763418c@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 02:21:58 PDT (-0700), pbonzini@redhat.com wrote:
> On 30/03/21 07:48, Anup Patel wrote:
>>
>> It seems Andrew does not want to freeze H-extension until we have virtualization
>> aware interrupt controller (such as RISC-V AIA specification) and IOMMU. Lot
>> of us feel that these things can be done independently because RISC-V
>> H-extension already has provisions for external interrupt controller with
>> virtualization support.

Sorry to hear that.  It's really gotten to a point where I'm just 
embarrassed with how the RISC-V foundation is being run -- not sure if 
these other ones bled into Linux land, but this is the third ISA 
extension that's blown up over the last few weeks.  We had a lot of 
discussion about this on the binutils/GCC side of things and I've 
managed to convince myself that coupling the software stack to the 
specification process isn't viable -- we made that decision under the 
assumption that specifications would actually progress through the 
process, but in practice that's just not happening.

My goal with the RISC-V stuff has always been getting us to a place 
where we have real shipping products running a software stack that is as 
close as possible to the upstream codebases.  I see that as the only way 
to get the software stack to a point where it can be sustainably 
maintained.  The "only frozen extensions" policy was meant to help this 
by steering vendors towards a common base we could support, but in 
practice it's just not working out.  The specification process is just 
so unreliable that in practice everything that gets built ends up 
relying on some non-standard behavior: whether it's a draft extension, 
some vendor-specific extension, or just some implementation quirks.  
There's always going to be some degree of that going on, but over the 
last year or so we've just stopped progressing.

My worry with accepting the draft extensions is that we have no 
guarantee of compatibility between various drafts, which makes 
supporting multiple versions much more difficult.  I've always really 
only been worried about supporting what gets implemented in a chip I can 
actually run code on, as I can at least guarantee that doesn't change.  
In practice that really has nothing to do with the specification freeze: 
even ratified specifications change in ways that break compatibility so 
we need to support multiple versions anyway.  That's why we've got 
things like the K210 support (which doesn't quite follow the ratified 
specs) and are going to take the errata stuff.  I hadn't been all that 
worried about the H support because there was a plan to get is to 
hardware, but with the change I'm not really sure how that's going to 
happen.

> Yes, frankly that's pretty ridiculous as it's perfectly possible to
> emulate the interrupt controller in software (and an IOMMU is not needed
> at all if you are okay with emulated or paravirtualized devices---which
> is almost always the case except for partitioning hypervisors).

There's certainly some risk to freezing the H extension before we have 
all flavors of systems up and running.  I spent a lot of time arguing 
that case years ago before we started telling people that the H 
extension just needed implementation, but that's not the decision we 
made.  I don't really do RISC-V foundation stuff any more so I don't 
know why this changed, but it's just too late.  It would be wonderful to 
have an implementation of everything we need to build out one of these 
complex systems, but I just just don't see how the current plan gets 
there: that's a huge amount of work and I don't see why anyone would 
commit to that when they can't count on it being supported when it's 
released.

There are clearly some systems that can be built with this as it stands.  
They're not going to satisfy every use case, but at least we'll get 
people to start seriously using the spec.  That's the only way I can see 
to move forward with this.  It's pretty clear that sitting around and 
waiting doesn't work, we've tried that.

> Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
> drivers/staging/riscv/kvm?

I'm certainly ready to drop my objections to merging the code based on 
it targeting a draft extension, but at a bare minimum I want to get a 
new policy in place that everyone can agree to for merging code.  I've 
tried to draft up a new policy a handful of times this week, but I'm not 
really quite sure how to go about this: ultimately trying to build 
stable interfaces around an unstable ISA is just a losing battle.  I've 
got a bunch of stuff going on right now, but I'll try to find some time 
to actually sit down and finish one.

I know it might seem odd to complain about how slowly things are going 
and then throw up another roadblock, but I really do think this is a 
very important thing to get right.  I'm just not sure how we're going to 
get anywhere with RISC-V without someone providing stability, so I want 
to make sure that whatever we do here can be done reliably.  If we don't 
I'm worried the vendors are just going to go off and do their own 
software stacks, which will make getting everyone back on the same page 
very difficult.

> Either way, the best way to do it would be like this:
>
> 1) you apply patch 1 in a topic branch
>
> 2) you merge the topic branch in the risc-v tree
>
> 3) Anup merges the topic branch too and sends me a pull request.
>
> Paolo
