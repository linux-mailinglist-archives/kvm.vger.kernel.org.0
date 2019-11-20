Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAF104659
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 23:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfKTWVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 17:21:40 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38713 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTWVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 17:21:40 -0500
Received: by mail-io1-f66.google.com with SMTP id i13so1056345ioj.5
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 14:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPZb5uc06E6ckJZfyVBVoO/p/GImtxauQ595lSsSogI=;
        b=EydN6cMM95cljwnqnIrfQMpMgLuKIQIlYA+RvzDmmRnuSKJ8XCZq8FvtODUOFJxt9u
         n1VkucUkFCdERiLEMM+afXx1VoslOMy9RYZ/qQgIOd/KOf2vHcIrH2uaii9og0pY81Bi
         jMwHvTirPdl7RdqWYSlOF9viYookF1itbrv7S19DHm+h8MQVku/A6rYQrGK2fb5XyNaC
         2922Y5DK44tvz+w046Llq+HQgkQXp5/E9LuJ+0/5m7ptRzJzwZGEo1yQAQsfshTAHFV8
         OFw13Hius1unNMGOQ04cJbZEROGvzGH1sVqRUIekeEvFVOpPa9Gxy+ePNfqTpI6PMGxs
         Sf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPZb5uc06E6ckJZfyVBVoO/p/GImtxauQ595lSsSogI=;
        b=XEOwBTXft3MVz6N8cT6Wdbatv2rZQ4uhuZS8iWcWeyTFxGHUelP9hZvCzGjGXwd2ng
         vnVO1gp49lOP7G1H7LygQhRzMocaeOEyYj4wlZn3YLpSi/MCQojlVTRdsTKP8DHiTAGX
         EIzbz3rg3ftwxJIUewtNXtU1pb/oTmCjeP767HvsV9FLRkdIA2lwbP9k+1en2IfAl7R/
         RMytNJ1YrR3nLtb8I7F7B7tcaXVtx1nIDqFYrp+7tpTicZ+JWA3u7VQrsdlY1XYHGy6G
         dYH1iS3GCbbebFDYvN6zCk7fWld7dESGfZopxqGK+FW7pWQZI4PMqEwhan3fPOsfuUul
         EBWg==
X-Gm-Message-State: APjAAAV3z82yg0daUNh4RlKKB3Jc+hoJq4Q1ZVueKSFwwngrh0t7cZXe
        mxwlCeMvA/+2bZs6Yjc8aV4HKsje43z85NKcp6Are7DA
X-Google-Smtp-Source: APXvYqwt3qG289AzlGvwsetVHVi1g9ZzP4+/ocXJ2Kbls3RPm3hYUpmMqf4w0GUgUGrH7NtEZedY3i7l0lGBUfnDkq4=
X-Received: by 2002:a02:846:: with SMTP id 67mr5618162jac.54.1574288498720;
 Wed, 20 Nov 2019 14:21:38 -0800 (PST)
MIME-Version: 1.0
References: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com>
 <710cd64e-b74e-0651-2045-156ba47ce04b@redhat.com> <CALMp9eTnTOsch_fjSc92Jo+DoWE1AHwx04Vij7KKb4-Fy6nWEA@mail.gmail.com>
 <f5fcab3a-21f3-8025-5773-1bed4ef75f13@redhat.com>
In-Reply-To: <f5fcab3a-21f3-8025-5773-1bed4ef75f13@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Nov 2019 14:21:27 -0800
Message-ID: <CALMp9eRz_G0rTMO4Omd_s78-=-zbRLGGxHzJsZBFpsfr0ysCgw@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 2:17 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/11/19 23:16, Jim Mattson wrote:
> > On Wed, Nov 20, 2019 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 20/11/19 19:13, Jim Mattson wrote:
> >>> On Mon, Nov 18, 2019 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>>>
> >>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >>>
> >>> I had to add tsx-ctrl to x86/unittests.cfg:
> >>>
> >>> +[tsx-ctrl]
> >>> +file = tsx-ctrl.flat
> >>> +extra_params = -cpu host
> >>> +groups = tsx-ctrl
> >>> +
> >>>
> >>> With qemu 4.1, I get:
> >>>
> >>> timeout -k 1s --foreground 90s /root/kvm-unit-tests/deps/qemu.sh
> >>> -nodefaults -device pc-testdev -device
> >>> isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
> >>> pci-testdev -machine accel=kvm -kernel x86/tsx-ctrl.flat -smp 1 -cpu
> >>> host # -initrd /tmp/tmp.7wOLppNO4W
> >>> enabling apic
> >>> SKIP: TSX_CTRL not available
> >>>
> >>> Maybe qemu is masking off ARCH_CAP_TSX_CTRL_MSR? I haven't investigated.
> >>
> >> Yes, you need "-cpu host,migratable=off" if you don't have the
> >> corresponding QEMU patches (which I've only sent today, but just
> >> allowing unmigratable features in extra_params will be okay for you to
> >> test).
> >
> > Okay, that works!
> >
> > enabling apic
> > PASS: TSX_CTRL should be 0
> > PASS: Transactions do not abort
> > PASS: TSX_CTRL hides RTM
> > PASS: TSX_CTRL hides HLE
> > PASS: TSX_CTRL=0 unhides RTM
> > PASS: TSX_CTRL causes transactions to abort
> > PASS: TSX_CTRL=0 causes transactions to succeed
> > SUMMARY: 7 tests
>
> Great, should I merge the patches in 5.5 with your Tested-by annotation?

Please do.
