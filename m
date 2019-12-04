Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE40F112E06
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 16:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfLDPHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 10:07:53 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35975 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfLDPHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 10:07:53 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so7148020oic.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 07:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ctF7i3YtaWmAPKJFqGq+fBuSBQxGx/l8PItlK/C7Eo=;
        b=hUQVOwdmFC9xwg7/Ve37lsNCG6PtBBrZi+lRiu9Ki5QARiteTFoWW4qiYJj3C/70nY
         7TitbHQQkRxiZEUS3klsV40tLT8rkp774g0yCbVmbjWk0C5MEqy5hWeF4tQB+N+ab5w1
         /dqTGur7jQvVV9j3MkOWRcJZh/GgmK20d68ERS0gQlNIkF0sEnjotboBeZlq2iqOkvA9
         sj/F4KNkS1fnDpD8iiFSgSEOvFcqGt/fgZyY2TEOQ4P+UxsjTmumMvIWl1AR7d2QSz8S
         HmVWoo6adrh5PEa4d1qv89bSsT/mwQNemlymhPkeeFvSP8MvFEshri0Uo1qYmfqISexr
         s+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ctF7i3YtaWmAPKJFqGq+fBuSBQxGx/l8PItlK/C7Eo=;
        b=UUODe08D6kftOfMu/2dU2cevLB/It+ACof45udUEKWtxoiD72dtOCwBxetAVjvO/EN
         +6TQxF2xfAaVgo3jzxHfSWm/j7RvYs+R7B453+kQIMyFc+86RNIaSloojCN8YDvHKiUT
         nfdwGal8g1q0NJilVTs1ZzqSzqwLEgZnE+pMdpXTFnm4FQt7fVvCZRDnvFLw1BrlsQlf
         ztFEUC/fM97OrnSOkoWRD2KRpNDoANlZ75xeAV8NUnioLeCuhDW7e7z4JhegNrFJBgFJ
         8VuZWcICE4mrjS+CUJn/bvEZHtObRJldtd3kTMNzZSpl5k3+/nCw2uI9o4Y+/kM/tRgH
         Rc6A==
X-Gm-Message-State: APjAAAXGXLTmFe3m4+3E0WoBhjeiyJVVNssI9PzjlfZwOU6r25R0BSDi
        ZOw0Hujl2K9uVu+EC+G16F2wFbkFuWMTpuCwipzryGWE57E=
X-Google-Smtp-Source: APXvYqwlVzccHWoUnndVXD/fSaLr9oIIxWv9l1YrNMvD8H8Rb/h63ukjjNcKXQuVAxyXR9S/QoCJIOIusbFgT7Fb3/o=
X-Received: by 2002:aca:4712:: with SMTP id u18mr609507oia.93.1575472072501;
 Wed, 04 Dec 2019 07:07:52 -0800 (PST)
MIME-Version: 1.0
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
 <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com> <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
 <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
In-Reply-To: <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
From:   Catherine Ho <catherine.hecx@gmail.com>
Date:   Wed, 4 Dec 2019 23:07:39 +0800
Message-ID: <CAEn6zmHnTLZxa6Qv=8oDUPYpRD=rvGxJOLjd8Qb15k9-3U+CKw@mail.gmail.com>
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo


On Wed, 4 Dec 2019 at 21:53, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/12/19 14:33, Catherine Ho wrote:
> > Hi Paolo
> > [sorry to resend it, seems to reply it incorrectly]
> >
> > On Wed, 4 Dec 2019 at 19:23, Paolo Bonzini <pbonzini@redhat.com
> > <mailto:pbonzini@redhat.com>> wrote:
> >
> >     On 04/12/19 09:50, Catherine Ho wrote:
> >     > Commit 20a78b02d315 ("target/i386: add VMX features") unconditionally
> >     > add vmx msr entry although older host kernels don't include them.
> >     >
> >     > But old host kernel + newest qemu will cause a qemu crash as follows:
> >     > qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
> >     > target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
> >     > cpu->kvm_msr_buf->nmsrs' failed.
> >     >
> >     > This fixes it by relaxing the condition.
> >
> >     This is intentional.  The VMX MSR entries should not have been added.
> >     What combination of host kernel/QEMU are you using, and what QEMU
> >     command line?
> >
> >
> > Host kernel: 4.15.0 (ubuntu 18.04)
> > Qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
> > cmdline: qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 8 \
> >                   -m 4G,maxmem=4G
> >
> > But before 20a78b02d315, the older kernel + latest qemu can boot guest
> > successfully.
>
> Ok, so the problem is that some MSR didn't exist in that version.  Which
I thought in my platform, the only MSR didn't exist is MSR_IA32_VMX_BASIC
(0x480). If I remove this kvm_msr_entry_add(), everything is ok, the guest can
be boot up successfully.

> one it is?  Can you make it conditional, similar to MSR_IA32_VMX_VMFUNC?
Ok, I will. Thanks for the suggestion

Best regards
Catherine
