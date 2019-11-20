Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C90104652
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 23:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfKTWQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 17:16:26 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41237 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTWQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 17:16:26 -0500
Received: by mail-io1-f67.google.com with SMTP id r144so1016767iod.8
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 14:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRG9xcNvXozEWxBI/L5nJMyi24rWgVFOD5PNrAnvnok=;
        b=j7QVg4xdhGgHHeaIuiqCfW7SnWMc8SMkHz0hRoTmHetv5V6fr7zzHdLSq4a2gxJ2yx
         6ao3cP4AkrhI/jqgPNJREQ4yxLn8xmurko3kxK7QSNNTLrc3bBEIWFM+5a3RU62Lb5BB
         a3Xb+Jde4TPAC6Bf7e4mdCH+WLhGC6rusMMJQftBKf3ygMMm2u5qqhH2D5maQwex2zcI
         N2x9gBC6CpEJLJDr6hKp56W0OkNXDLaDEKEbav6i6veJ/EM4xxobPFzZGCR++HW5qJ52
         PWuZHgzaL7tfBH0Gf62KyG1TpHo8ov6edEfTkdNL1ZTntKnjk7chETYvpwlj0k7nxz06
         t7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRG9xcNvXozEWxBI/L5nJMyi24rWgVFOD5PNrAnvnok=;
        b=S7UZJT4cv77A2+VzaNbgdishS8qELvTtC5bg3kOyFSqe+EHVjq4ZtFbZph/nSqWojV
         M7OiH42rj0esGIRrxG5oftiMDQLbRCm2FcxgZJdslRcjZlQHXK0EVOK+qFmOo1LhZKuX
         4zXUc1bErHGxFF7WWx5OIsCUwvI5wfUhQxJPFkSMt2m+JMiIXGYA8t6b+gE7gh3VSr7i
         3Cjl7+J1x7gcGt83ErnbsWBQrZC7Na/U+jeHHHq8ye2AFEEd+4nmyaRtjQtxdg1E0hWf
         Q42SPhgarlzMFDlxIRPbDx7KOfJChvVa9dwC9IKbvuMetWMrDU4h/ZW+4sXCkI3iGl13
         gbmA==
X-Gm-Message-State: APjAAAXER3tO3DEGLJ4e8H84nduNTc6VeZ7DtENuSRddXob/gpiuMEQl
        qUmSrm9WUZJC32UTN2WBg1/z0Mc4nP2xPJRCrdODzqTgWBs=
X-Google-Smtp-Source: APXvYqwuYfwRwcE2/oQu7vBn0NWMKJ6ZZAtEztaN+kXK5/LpkI71zwtooTK5GU03mBVbxYSnYiI707j9OqVw2HQlyg8=
X-Received: by 2002:a6b:908a:: with SMTP id s132mr4596846iod.118.1574288184638;
 Wed, 20 Nov 2019 14:16:24 -0800 (PST)
MIME-Version: 1.0
References: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com> <710cd64e-b74e-0651-2045-156ba47ce04b@redhat.com>
In-Reply-To: <710cd64e-b74e-0651-2045-156ba47ce04b@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Nov 2019 14:16:13 -0800
Message-ID: <CALMp9eTnTOsch_fjSc92Jo+DoWE1AHwx04Vij7KKb4-Fy6nWEA@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/11/19 19:13, Jim Mattson wrote:
> > On Mon, Nov 18, 2019 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > I had to add tsx-ctrl to x86/unittests.cfg:
> >
> > +[tsx-ctrl]
> > +file = tsx-ctrl.flat
> > +extra_params = -cpu host
> > +groups = tsx-ctrl
> > +
> >
> > With qemu 4.1, I get:
> >
> > timeout -k 1s --foreground 90s /root/kvm-unit-tests/deps/qemu.sh
> > -nodefaults -device pc-testdev -device
> > isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
> > pci-testdev -machine accel=kvm -kernel x86/tsx-ctrl.flat -smp 1 -cpu
> > host # -initrd /tmp/tmp.7wOLppNO4W
> > enabling apic
> > SKIP: TSX_CTRL not available
> >
> > Maybe qemu is masking off ARCH_CAP_TSX_CTRL_MSR? I haven't investigated.
>
> Yes, you need "-cpu host,migratable=off" if you don't have the
> corresponding QEMU patches (which I've only sent today, but just
> allowing unmigratable features in extra_params will be okay for you to
> test).

Okay, that works!

enabling apic
PASS: TSX_CTRL should be 0
PASS: Transactions do not abort
PASS: TSX_CTRL hides RTM
PASS: TSX_CTRL hides HLE
PASS: TSX_CTRL=0 unhides RTM
PASS: TSX_CTRL causes transactions to abort
PASS: TSX_CTRL=0 causes transactions to succeed
SUMMARY: 7 tests

...and, for the vmexit test...

enabling apic
paging enabled
cr0 = 80010011
cr3 = 61e000
cr4 = 20
pci-testdev at 0x10 membar febff000 iobar c000
wr_tsx_ctrl_msr 2058
