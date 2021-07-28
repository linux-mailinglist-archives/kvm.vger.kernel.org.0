Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB7C3D95B0
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 21:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhG1TAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 15:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhG1TAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 15:00:16 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F0C0613C1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 12:00:14 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q2so4311598ljq.5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CF9Ebtn1K2skoonIX3Kl5uPFwf6/mj0sEHZaqTsqkM8=;
        b=HnOKhABiYVDpWHTEotvy8TRmCEC1QtjeZ/HFGLg2UBX2JmDkodXeXj7V8WiZhzYcQS
         atrhZprD8sBKRVuteibupgTQvvlDMhN/zFROgRV4nT7LTYg0zAoNJXf32hK/4gVEQAP7
         iGKgws00WNSaAoGZiUOGR6gHSsSQnLT0XdCP8hF4l+lBNffzWJUUbag8n0ukQZduUZ7B
         f6YZC8A9czKHd8r+siKbxqI/iLbw8oEXwo82OXsgOkf/Oe0VixfheizX3VwZQTlJCgW8
         iCsjCsQWvAQ260/Ej27hnSOky7yZ1ZnTTK05RB8qcWyE+whZDV+huaBZEIuYPOknBOVh
         YrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CF9Ebtn1K2skoonIX3Kl5uPFwf6/mj0sEHZaqTsqkM8=;
        b=A+DMNmhrwxaTNhXMIA3v+tMajC6uRhhpG+8pSSQfO6oDE2xCL0jzEZQAgULreGd6MA
         OgCLesQ5PiH+wettfpL86dkUoboL/Y/6wNUkwBBSBCXaScOGw+fyfOI1wHb/WKDeL2TA
         Jh8Kd0BdTDQYiNvJUZVh1wMKLGynDHnWaCPR9Fe0mvG75kkkEo87jkZT8ZOJUR5TzIR8
         mI4Ed1OD7NVkGehY1ITnq8gCYPzO1mYuqIJAYUrBeNukDcxvvJLo/yMNSGovT9VhjPkn
         FI46Z2RSgPXXCHK3T3q5vAAwZ21d+A2Xa0/rNYhoILh5/EFyxXZEfh/BEO3gUgYw8aSc
         Y0DQ==
X-Gm-Message-State: AOAM531IFKEwCy9vx9M0X0wH+aC8iPamavG9wGDVD1fSWZfwaGBODa0t
        rxNNdiZJ0qhaPGJfGHpVxZXUjEmsSaFExW49pRo=
X-Google-Smtp-Source: ABdhPJwMmzz0ZTVyuI9BEf3qiVK5oQzhKIRnHD1Mde34Q4f9D/LqLbWCY4pnghV5lqF94ZnmaBPOR9mX6adE6Y0eBfc=
X-Received: by 2002:a2e:a90e:: with SMTP id j14mr751792ljq.250.1627498813006;
 Wed, 28 Jul 2021 12:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com> <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com> <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
 <YPC1lgV5dZC0CyG0@google.com> <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
 <YPiLBLA2IjwovNCP@google.com>
In-Reply-To: <YPiLBLA2IjwovNCP@google.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Wed, 28 Jul 2021 14:00:01 -0500
Message-ID: <CA+-xGqP7=m47cLD65DhTumOF8+sWZvc81gh+04aKMS56WWkVtA@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, sorry for the late reply. Thanks for your careful explanations.

> For emulation of any instruction/flow that starts with a guest virtual address.
> On Intel CPUs, that includes quite literally any "full" instruction emulation,
> since KVM needs to translate CS:RIP to a guest physical address in order to fetch
> the guest's code stream.  KVM can't avoid "full" emulation unless the guest is
> heavily enlightened, e.g. to avoid string I/O, among many other things.

Do you mean the emulated MMU is needed when it *only* wants to
translate GVAs to GPAs in the guest level?
In such cases, the hardware MMU cannot be used because hardware MMU
can only translate GVAs to HPAs, right?
