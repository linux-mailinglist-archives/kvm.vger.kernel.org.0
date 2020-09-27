Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CAD27A1E5
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI0QsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Sep 2020 12:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgI0QsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Sep 2020 12:48:04 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31E6C0613CE
        for <kvm@vger.kernel.org>; Sun, 27 Sep 2020 09:48:03 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z17so8312022lfi.12
        for <kvm@vger.kernel.org>; Sun, 27 Sep 2020 09:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPWRJ85k7l/wJVQxIpMossJZ33aC3AtFlfGZLXsSkjw=;
        b=a8Cx8FbzPfSC4099D0f3KTk55ldlJAZY9L1KYpQ5t55sbPyiehirLZBsJ9AlDTxF0n
         3ocvbhCQD3qTk3v6Db6EwodquKJM/Zo+7wzEJOiVJbAWpkJ6YyWYrpeXHR6ccRDXbyre
         5b/yDcEA5uUjGnsD/rvFmRx3xKcGq681TllK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPWRJ85k7l/wJVQxIpMossJZ33aC3AtFlfGZLXsSkjw=;
        b=FS2mk+rD6lX1g2DgDm48B36PxSlzTRo+l8NSX4hUon9+tLaloZpZaw7zKXXdf05dni
         pX6ahibzp4EiWYOPHPvTMa7KTUjAiEHbPjQwCOeqhCfG2MJ/5+MmyVIlGL8DXvXIZIGh
         ucj3JX6st5Er2IC+nB8rxzuz+Cvc4ejho4XJbLieuUU45lAT3X16HnsQbhQZWnNzZFAs
         mBXW51IdxXYhwTNcK/cslz/vjIXipsb5wGIyVOOj5WokWOvh4JdHDm7eU3bZuIAOaBtK
         NcQwJ5H0/hI0Y2SXxRsU2dPAnxpg+onUjCz2T7N/DRC0GUgn5EUUFriLlJW+09SH4QPY
         v0dQ==
X-Gm-Message-State: AOAM533U15b3fcjBtNwOWQv0R/lK8Brrdr6/GZiO8nZpcFZ69FdhJu1a
        Ku/YPoaVfFK+9kL6utFXc1xvBVCBpVyYRSgFPpUM2IYjK2E=
X-Google-Smtp-Source: ABdhPJzVmwpX2xSJnkuSMBBsogmbYqUBogVkK860My+7dWUOCOmmSVFd4hMBcSK20WcmiIYJud7fUx3USdI1zPXXX3s=
X-Received: by 2002:a19:674f:: with SMTP id e15mr2421194lfj.50.1601225280963;
 Sun, 27 Sep 2020 09:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
 <20200925202401.GG31528@linux.intel.com>
In-Reply-To: <20200925202401.GG31528@linux.intel.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sun, 27 Sep 2020 22:17:49 +0530
Message-ID: <CAJGDS+E58QVYmPMsv64ECYtTX2uor2Vs=Bt1qD5cs9dtX00PKg@mail.gmail.com>
Subject: Re: Which clocksource does KVM use?
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you Sean for the detailed information!

On Sat, Sep 26, 2020 at 1:54 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 08:06:44AM +0530, Arnabjyoti Kalita wrote:
> > I am running QEMU with KVM using the below command line -
> >
> > sudo ./qemu-system-x86_64 -m 1024 -machine pc-i440fx-3.0
> > -cpu qemu64,-kvmclock -accel kvm -netdev
> > tap,id=tap1,ifname=tap0,script=no,downscript=no
> > -device virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00
> > -drive file=ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
> > -device virtio-blk-pci,drive=img-direct
> >
> >
> > I can see that the current_clocksource used by the VM that is spawned
> > is reported as "tsc".
> >
> > /sys/devices/system/clocksource/clocksource0$ cat current_clocksource
> > tsc
> >
> > I collect a trace of the guest execution using IntelPT after running
> > the below command -
> >
> > sudo ./perf kvm --guest --guestkallsyms=guest-kallsyms
> > --guestmodules=guest-modules
> > record -e intel_pt// -m ,65536
> >
> > The IntelPT trace reveals that the function "read_hpet" gets called continuously
> > while I expected the function "read_tsc" to be called.
> >
> > Does KVM change the clocksource in any way?
>
> KVM's paravirt clock affects the clocksource, but that's disable in via
> "-kvmclock" in your command line.
>
> > I expect the clocksource to be set at boot time, how and why did the
> > clocksource change later? Does KVM not support the tsc clocksource ?
>
> QEMU/KVM exposes TSC to the guest, but the Linux kernel's decision on whether
> or not to use the TSC as its clocksource isn't exactly straightforward.
>
> At a minimum, the TSC needs to be constant (count at the same rate regardless
> of p-state, i.e. core frequency), which is referred to as invtsc by QEMU.  At
> a glance, I don't think "-cpu qemu64" advertises support for invtsc.  This can
> be forced via "-cpu qemu64,+invtsc", though that may spit out some warnings if
> the host CPU itself doesn't have a constant TSC.  You can also override this
> in the guest kernel by adding "tsc=reliable" to your kernel params.
>
> C-states are another possible issu.  The kernel will mark the TSC as unstable
> if C2 or deeper is supported (and maybe even C1 with MWAIT?) and the TSC isn't
> marked as nonstop.  I don't _think_ this is relevant?  QEMU/KVM doesn't
> support advertising a nonstop TSC, but I assume QEMU also doesn't advertise C2
> or deeper (I've never actually looked), or MONITOR/MWAIT by default.
>
> If the above are ruled out, the kernel can also mark the TSC as unstable and
> switch to the HPET for a variety of other reasons.  You can check for this
> by grepping for "Marking TSC unstable due to" in the guest kernel logs.
>
> > Note:
> >
> > I am using QEMU version 3.0. The guest runs a 4.4.0-116-generic linux kernel.
> > Both my qemu host as well as the target architecture is x86_64. The
> > host machine is
> > also using "tsc" clocksource.
> >
> > Best Regards,
> > Arnab
