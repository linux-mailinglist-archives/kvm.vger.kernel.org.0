Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D98C1D4D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 10:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfI3IoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 04:44:01 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:41135 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfI3IoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 04:44:01 -0400
Received: by mail-wr1-f51.google.com with SMTP id h7so10225670wrw.8
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 01:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=8ivFXGaU+9KGTOiUArTbg0dkRY7nBcmcXaR7GuIZKl8=;
        b=M+cIxjWzwFOrh+TnpYEKQPOMT8afqIBvmm0ZF9RZyEaLt7T1vmlq5QERbD/IXxsQ32
         Efh6AhvIKEg8d5gDAFYIcP5QLiuIDJaHj+ZruG0vCc1ypG42qnnXCxyRHI6wjvJqWK7n
         Pj1NgiZj9/gOSE8LDDyIP0Zp3xb0KD4CR4CDBXXC4h8tCmK0BSmfrq8h7oUKO6/kVpTT
         1+RHuR+AQvQk3Otu4m86eBGBg0Yp95JKRJ+5MYFpIoOZM1ujXu8hXT+XdMsAwyXY0YB9
         DIlpqFiDOl54PcCHbFqHQgXZQQrENJ6VFfl5yg6q+xzLGwy565hCWtq4RwA2FBRXB8Jo
         GvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8ivFXGaU+9KGTOiUArTbg0dkRY7nBcmcXaR7GuIZKl8=;
        b=QpuPzEoUtK/vq10sKCxeubnbgGRG9DiKIHdK2AbimolWc6bzmLcRPxSoFofVxFx5p0
         IZO9J4n+ttVfTGPX/orUPsfg0lGeL/9vD4KQcMe4dm9FEASKC16/DUuwb2NRNOTPZMPL
         sEU8UgfEquPDvViIdTe7YSycF8yVvtgXIuk9fHm8/sMv2uO6pIJsvIXAbF3xLTPpJMqx
         m1KiKY+jU1+btOHh131HLj/pRkuRPvG0KHnKGLm/HjZVre7fgg68/k3zHVV/5a0MzqBE
         /SEGT8Y9A0X3q7dBqbvX4C3YMeksZFnmcQd6LgaGVss7vWr+tLGaeKajKV3mVB9fyo6k
         1gTQ==
X-Gm-Message-State: APjAAAUOcQs/3HAskvMA/pDWAduTVneP2uTq5BqeAur29hYuFRo5ppn4
        53G1gNP0Xy5sL9BfN0shZh3JLryhVXt7oBsAvoNHr/N9c2Y=
X-Google-Smtp-Source: APXvYqzXDRVxb/yolhR+aVuAH7tPW4HmW0I4yRUNEfGXxM7ECwajijIUVhbhgK2et1qM9cIVHXz9ABRv1WzDjfMp3Q4=
X-Received: by 2002:adf:f406:: with SMTP id g6mr11821333wro.325.1569833038953;
 Mon, 30 Sep 2019 01:43:58 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 30 Sep 2019 10:43:48 +0200
Message-ID: <CAMGffE=JTrCvj900OeMJQh06vogxKepRFn=7tdA965VJ9zSWow@mail.gmail.com>
Subject: Broadwell server reboot with vmx: unexpected exit reason 0x3
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear KVM experts,

We have a Broadwell server reboot itself recently, before the reboot,
there were error messages from KVM in netconsole:
[5599380.317055] kvm [9046]: vcpu1, guest rIP: 0xffffffff816ad716 vmx:
unexpected exit reason 0x3
[5599380.317060] kvm [49626]: vcpu0, guest rIP: 0xffffffff81060fe6
vmx: unexpected exit reason 0x3
 [5599380.317062] kvm [36632]: vcpu0, guest rIP: 0xffffffff8103970d
vmx: unexpected exit reason 0x3
[5599380.317064] kvm [9620]: vcpu1, guest rIP: 0xffffffffb6c1b08e vmx:
unexpected exit reason 0x3
[5599380.317067] kvm [49925]: vcpu5, guest rIP: 0xffffffff9b406ea2
vmx: unexpected exit reason 0x3
[5599380.317068] kvm [49925]: vcpu3, guest rIP: 0xffffffff9b406ea2
vmx: unexpected exit reason 0x3
[5599380.317070] kvm [33871]: vcpu2, guest rIP: 0xffffffff81060fe6
vmx: unexpected exit reason 0x3
[5599380.317072] kvm [49925]: vcpu4, guest rIP: 0xffffffff9b406ea2
vmx: unexpected exit reason 0x3
[5599380.317074] kvm [48505]: vcpu1, guest rIP: 0xffffffffaf36bf9b
vmx: unexpected exit reason 0x3
[5599380.317076] kvm [21880]: vcpu1, guest rIP: 0xffffffff8103970d
vmx: unexpected exit reason 0x3

Kernel version is: 4.14.129
CPU is Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz
There is no crashdump generated, only above message right before server reboot.

Anyone has an idea, what could cause the reboot? is there a known
problem in this regards?

I notice EXIT_REASON_INIT_SIGNAL(3) is introduced recently, is it related?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/x86/kvm?id=4b9852f4f38909a9ca74e71afb35aafba0871aa1

Regards,
Jinpu
