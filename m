Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B63104313
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 19:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfKTSOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 13:14:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37042 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfKTSOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 13:14:03 -0500
Received: by mail-il1-f194.google.com with SMTP id s5so529544iln.4
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 10:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ez2lUXBKpLiwoVe9oLe2TZZZ3tWVoF2Ipwbf+bWbA4=;
        b=kCdclKd/4CZbBkxgNREBf41/zwE6EaZrcGUwsf/cCagxcHVFo0m8qbtg5uQLXsIoxN
         ykWO7cwl4qW9KHHeMFMuZ9TMnZ3qhU9bnbNKSJdZMzWMmsT96FiYHTq86Ffy7Ywfwn1e
         v9B9orSaLiE68/rz6frimayfe2KVvq+rwxqTxbXCkvn3M3tBOo1MGrSQcJt9NxlWphPh
         Gn+3NAW3Zeyco5q9nTEkkpE5xk3wB7cWfAvW3q7g8DLVJErL7jmG31Kxfl8aHkWnXgMV
         aq+DYELpiP3H2peXQSUAz0zK13uTABq1TnH8C/8F9J5HLdsmosnwa0VyLnECTX0QtPNH
         STSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ez2lUXBKpLiwoVe9oLe2TZZZ3tWVoF2Ipwbf+bWbA4=;
        b=jJnIudJWDAImnG5/7W7lS97Fw3mLDprfEFVodrDvuACigEX2hKB2XUxLBtigj0aDz9
         N8kSV5Uhlkma7QgWi0T3SOorUwXTd3u/cwXXP0BUuSl2StedIcKxEZada/eulSnH27U0
         42rqDXXm5mY4GxZw0tqbmyhZkZY1gxW+mzjbbDykPB0rWlftVy7kv6th8kv8CfA5mJH/
         JMmxRRe82NwIUOGQJAoyOdPioqGGdXUzSQcKPYFu9cNmaXvmCBScKbmmjOea99zYgtrz
         KBS9ClYPzgSGetuoGCUGP+adoegzPiZVQgi3kFEuBvIhs86lujq6mjVBwjn+hYs5KSbj
         CRKQ==
X-Gm-Message-State: APjAAAVXQ2CCH89UJYcP5A+44jvusEkyVIpsv3nhcjKdaaGRXzZ7zC6U
        9o9uh8F2SpPlXB4RA6UvCYYX0efe2Ts+xChhEpw75g==
X-Google-Smtp-Source: APXvYqz9J0MwTXm5XSKzWj15toUdYlK8GpN2CIVqJFY/y9J1rhrm1hWnxJLJ8LCKkyLnzqPgf/bsF0T081z5fRZTgoc=
X-Received: by 2002:a92:9ace:: with SMTP id c75mr5048263ill.296.1574273642704;
 Wed, 20 Nov 2019 10:14:02 -0800 (PST)
MIME-Version: 1.0
References: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Nov 2019 10:13:51 -0800
Message-ID: <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I had to add tsx-ctrl to x86/unittests.cfg:

+[tsx-ctrl]
+file = tsx-ctrl.flat
+extra_params = -cpu host
+groups = tsx-ctrl
+

With qemu 4.1, I get:

timeout -k 1s --foreground 90s /root/kvm-unit-tests/deps/qemu.sh
-nodefaults -device pc-testdev -device
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
pci-testdev -machine accel=kvm -kernel x86/tsx-ctrl.flat -smp 1 -cpu
host # -initrd /tmp/tmp.7wOLppNO4W
enabling apic
SKIP: TSX_CTRL not available

Maybe qemu is masking off ARCH_CAP_TSX_CTRL_MSR? I haven't investigated.
