Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE4429D5BC
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgJ1WIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbgJ1WH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:26 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4D324807;
        Wed, 28 Oct 2020 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603909907;
        bh=5BucDVHZQvwlTSTEduBaar9yCmoffLVOearlQ0OHBHo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vX5fAM27qRsEFJIqkCkk9A3Pn8WUH3OySCiuASrT/tWNJHzc3YADvUTlPZdOVMkjU
         nJuDaIi5DotRlLLG6ZDkGzILTw088LpoZhBnv8IcVcCl4PcoeIQrFJ3RrIea6HgT96
         t2FciXTo3k6YzbXOfwce+u5OQLjBa+j7H7w2njVc=
Received: by mail-qk1-f182.google.com with SMTP id r7so5495184qkf.3;
        Wed, 28 Oct 2020 11:31:47 -0700 (PDT)
X-Gm-Message-State: AOAM533EJ27Eb9XXI4+QszjZ77XwZQsUlBdn7Krz190nezL3rx7xQbJu
        dpC7nIn2RdSFpUWJRpCVj6JKCVq0LBLIT5gquQQ=
X-Google-Smtp-Source: ABdhPJxlFKG/zE1Kq9StIutb28uQpPQF+Hw1v4rZnYJlGy3eG2z1nHFo/tuK1HzD0mc4AEay0zsiJPm5QzU/pY1sT4E=
X-Received: by 2002:a05:620a:b13:: with SMTP id t19mr153994qkg.3.1603909906767;
 Wed, 28 Oct 2020 11:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201026161512.3708919-1-arnd@kernel.org> <20201028170430.GC7584@linux.intel.com>
In-Reply-To: <20201028170430.GC7584@linux.intel.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 28 Oct 2020 19:31:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a28R9k2xt-=EDACpY1_WKP0BBU4E08H6AAOnx-eHV2Prg@mail.gmail.com>
Message-ID: <CAK8P3a28R9k2xt-=EDACpY1_WKP0BBU4E08H6AAOnx-eHV2Prg@mail.gmail.com>
Subject: Re: [PATCH] x86: kvm: avoid -Wshadow warning in header
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 28, 2020 at 6:04 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Oct 26, 2020 at 05:14:39PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > There are hundreds of warnings in a W=2 build about a local
> > variable shadowing the global 'apic' definition:
> >
> > arch/x86/kvm/lapic.h:149:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
> >
> > Avoid this by renaming the local in the kvm/lapic.h header
>
> Rather than change KVM, and presumably other files as well, e.g. kvm/lapic.c and
> apic/io_apic.c also shadow 'apic' all over the place, what about renaming the
> global 'apic' to something more unique?  KVM aside, using such a common name for
> a global variable has always struck me as a bit odd/dangerous/confusing.

Yes, good point. I'll send a new patch for it later. Any suggestion
for a better name?

     Arnd
