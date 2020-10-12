Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C388828BFF2
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgJLSqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgJLSqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:46:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC17C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:46:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n61so16733564ota.10
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AIUOfjvEalibEOMS1HqaFhKw8FWbHrQSvVLFBmzV0Yw=;
        b=NcJ1o3Aq9NPR3ZeLpuUXon5bg02gpJQ7bKtLdNE/CUyVPK7XJ/h3knzy0qU87S3Rlo
         hfVPxCVS+VVr51GSM+QKXU2Gan1Z0wg6+OoH9p/haRwWgq0TmJD7DuH1aKpR2zfGrRKj
         NA/dpwPwew5RJh66rfXjLVJAVRXeurSOQeYomaGYhZLCuAVMBPzYTSQ2+USLokIihVOb
         FWdzcrOf7qA8HmUP4c0wmT9RBGyxrFCC4eXT1+3idInK6AMlsdmR8rrhBkkU+P8EtLbL
         Mqt9ucfVUZhCK+Eevmn9XUAtG4SveVNTXn5+pKB53hDGvxra0HkejGNWFTaZFfVfs3zx
         XUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AIUOfjvEalibEOMS1HqaFhKw8FWbHrQSvVLFBmzV0Yw=;
        b=W4a3xo2upzMXt956DD0dD6ijIk8GV5asKZw/J+9rDkY7qZP7mLFD8mLPHxTdr+QrpL
         fci6aZianYF5dJePFSaRmXE3kDgD17pGSJ/hdEqfb2E3tAqrdg6JL4e/csSc6r6dr867
         hcp+u/7TMUKnjPl7tFDvv+e1R8f0Ac0+2b4akb24D/2OOt36+dcmSBuwMHqv3CVa1xj1
         Mw4xLUcCISUeeHa9F8u2u5bEY3fW6r3wLygi1yu5rG/rGFKPiaiQvC+T7szuZnH4ZDZz
         MXlmFSjTEtpwbsFFEVpYHchefQhFYW38pYyXcFzhkFR8hSQZBJeWSa1X2u1PdlTC7LXj
         BOtg==
X-Gm-Message-State: AOAM533L4L2MjK4BlCBkdDLJSIPr2bLnKhc0DQjewi5GLUsMVOVOjOYv
        Vo1WDkggug6xIoTJk3fbbT89+AdoQxgbdllLXXMreTNASNQP5A==
X-Google-Smtp-Source: ABdhPJxy5tP6bGtOj5+z2RAVKsyh15D4xs2TvaplmIXT+6A/WwNfthz7sftRGxHxxWw/gSaPbptjhyl/Skz8g7vbac4=
X-Received: by 2002:a9d:51c4:: with SMTP id d4mr7286220oth.56.1602528375359;
 Mon, 12 Oct 2020 11:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200508203938.88508-1-jmattson@google.com> <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com> <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
 <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com> <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
 <354EB465-6F61-4AED-89B1-AB49A984A8A1@gmail.com>
In-Reply-To: <354EB465-6F61-4AED-89B1-AB49A984A8A1@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Oct 2020 11:46:03 -0700
Message-ID: <CALMp9eSe35-8jCzXjYkGVkHfam2CPGCO5+A=1+OGGCnKb_yEPA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 11:31 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Oct 12, 2020, at 11:29 AM, Paolo Bonzini <pbonzini@redhat.com> wrote=
:
> >
> > On 12/10/20 20:17, Nadav Amit wrote:
> >>> KVM clearly doesn't adhere to the architectural specification. I don'=
t
> >>> know what is wrong with your Broadwell machine.
> >> Are you saying that the test is expected to fail on KVM? And that Sean=
=E2=80=99s
> >> failures are expected?
> >
> > It's not expected to fail, but it's apparently broken.
>
> Hm=E2=80=A6 Based on my results on bare-metal, it might be an architectur=
al issue or
> a test issue, and not a KVM issue.

From section 25.5.1 of the SDM, volume 3:

If the last VM entry was performed with the 1-setting of =E2=80=9Cactivate
VMX-preemption timer=E2=80=9D VM-execution control,
the VMX-preemption timer counts down (from the value loaded by VM
entry; see Section 26.7.4) in VMX non-
root operation. When the timer counts down to zero, it stops counting
down and a VM exit occurs (see Section
25.2).

The test is actually quite lax, in that it doesn't start tracking VMX
non-root operation time until actually in the guest. Hardware is free
to start tracking VMX non-root operation time during VM-entry.

If the test can both observe a TSC value after the VMX-preemption
timer deadline *and* store that value to memory, then the store
instruction must have started executing after the VMX-preemption timer
has counted down to zero. Per the SDM, a VM-exit should have occurred
before the store could retire.

Of course, there could be a test bug.
