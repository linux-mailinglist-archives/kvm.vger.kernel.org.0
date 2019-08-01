Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376297D231
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 02:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfHAARb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 20:17:31 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43799 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHAARb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 20:17:31 -0400
Received: by mail-io1-f65.google.com with SMTP id k20so140353178ios.10
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 17:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5OGNJ2zIkCd2eyV8mt8HLf/hU6G3Prg746o+XeDun8g=;
        b=JCFsLphCWpry/6Z2MYbxZsoelgfg0dW6fPui5qNa86PZh7AC//uOmL1tF5DM0fWcws
         uVCWw7Gg5nO4WE12kTufLugnDNzFoToiSR5Kt7yBOVeK2bA5ME/qMOv+jcsbSex/54dE
         7H/wS8SOiUp9UGXC98OBEZDAmbeqjQep+T0MWjoGujTGJOOL9c/eMnJECmN+Ytt6gxyJ
         wgP4f8kweiH1k8wEvp4jF/KNc2Jh298x0TlgadHwnAap/nzwvIfBrHnAeKE2vPZFXHrB
         X/JIYcd6D4xrL9N14F89a13JYqFnzkne9eCIkAQR+T5HjRl9whFTOY1AQgXm1Y5HZ/DD
         OJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5OGNJ2zIkCd2eyV8mt8HLf/hU6G3Prg746o+XeDun8g=;
        b=dg7JfdUlgIZQrmd9swOuuPIiLHKKNg1TlnskwOefuFxHrdG/marzHfMmTFCvbRDdVk
         Ex03DPFCoe0LhYceSO9p82yJAi9Nb+wusIGGfIkTcf9zuI0mug53Kews3f0fPgGPObJl
         y1iQ7wXZnUOnbGzULb9BcF/PixXLU+KTsU7CLrz7Jy0wRTwHaOqb9D7k+Ih0OiSLr6vV
         9AI6cHvhP8rSXEk/leQWXsi9YjJQjUBlSQ/qJS+pk7zGAavoRQvPmMFh5QQk4UhxCNoa
         007zKd9a53RLMLLTQ+V4hRdhwKfVKkOpLfSyw3OdMB/ounH2+MbK9iDb5cuUqzY7ETDD
         FQkA==
X-Gm-Message-State: APjAAAW2I5u1Sj+OnoWpdQJ5BHDIPqGLkVBzNTGDX6x5bQGFuQFrXzV/
        NmJ+dYnbBepQbxA3g9k78cjy3mhxOoe1C47U8fEg1Q==
X-Google-Smtp-Source: APXvYqyFFqBV4DEKqLfGZ756X6zAkYSLEDdAzTvUc0fwEV47BgUGQsmryHFzasj08Mxw4FPOOGKkCfE0xT8+JctkT14=
X-Received: by 2002:a6b:f906:: with SMTP id j6mr32237818iog.26.1564618650462;
 Wed, 31 Jul 2019 17:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com> <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
 <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
 <20190731233731.GA2845@linux.intel.com> <CALMp9eRRqCLKAL4FoZVMk=fHfnrN7EnTVxR___soiHUdrHLAMQ@mail.gmail.com>
 <20190731235637.GB2845@linux.intel.com> <46f3cf18-f167-f66e-18b4-b66c8551dcd8@redhat.com>
In-Reply-To: <46f3cf18-f167-f66e-18b4-b66c8551dcd8@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Jul 2019 17:17:18 -0700
Message-ID: <CALMp9eS7W_n8Gk5bsGCre0pTr19mGiRhYLq5O5NkRct+AUJOPQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 5:13 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/08/19 01:56, Sean Christopherson wrote:
> > On Wed, Jul 31, 2019 at 04:45:21PM -0700, Jim Mattson wrote:
> >> On Wed, Jul 31, 2019 at 4:37 PM Sean Christopherson
> >> <sean.j.christopherson@intel.com> wrote:
> >>
> >>> At a glance, the full emulator models behavior correctly, e.g. see
> >>> toggle_interruptibility() and setters of ctxt->interruptibility.
> >>>
> >>> I'm pretty sure that leaves the EPT misconfig MMIO and APIC access EOI
> >>> fast paths as the only (VMX) path that would incorrectly handle a
> >>> MOV/POP SS.  Reading the guest's instruction stream to detect MOV/POP SS
> >>> would defeat the whole "fast path" thing, not to mention both paths aren't
> >>> exactly architecturally compliant in the first place.
> >>
> >> The proposed patch clears the interrupt shadow in the VMCB on all
> >> paths through svm's skip_emulated_instruction. If this happens at the
> >> tail end of emulation, it doesn't matter if the full emulator does the
> >> right thing.
> >
> > Unless I'm missing something, skip_emulated_instruction() isn't called in
> > the emulation case, x86_emulate_instruction() updates %rip directly, e.g.:
>
> Indeed.  skip_emulated_instruction() is only used when the vmexit code
> takes care of emulation directly.

Mea culpa. I had incorrectly assumed that "skip_emulated_instruction"
was used when an instruction was emulated. I retract my objection.
Having now been twice bitten by misleading function names, I'll be
more careful in the future.
