Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54133BE81F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 00:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfIYWKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 18:10:51 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39372 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfIYWKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 18:10:50 -0400
Received: by mail-io1-f66.google.com with SMTP id a1so1047043ioc.6
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 15:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gWrtMO/1hZ/o86Hyus1zQo+xeKnPuBEenuj+vizXnyo=;
        b=koGSocaoGdmmz2EAifg+USVuephOpKxacLGEobTQDZHxSK8IPRGIsHXPLo6+ji3M02
         he/qi3ePlQUkYeQETTqk6AZqfafzx33eWntchMyfmH1i41z911ZRRnr2h55zLnAH5DhU
         Lk0XXvyS1BLAy2Cwap8ZXQ8O3zH7LAUKwTky6dCiToae2EpAvzExqPX+0L911zwFJktD
         bk8OgO6YJl2QwKvw9+mZEEWeACNFH03tolWaXQUwHtYrbqL+bvuZT7CgPAZvmRZJ3pic
         +96DCQ7muxwH9sOoNIVQ7UCzL5I3RRD7yVBokZLVs97ENcqyAmMFESn8KH5hGlFskgu4
         gs6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gWrtMO/1hZ/o86Hyus1zQo+xeKnPuBEenuj+vizXnyo=;
        b=G9P4pgV8tuFGV0Bz46KOr/3ewOo2qemy8gS87+Unv9CskNp1SHweMeQo1MafH1h7b4
         W5ULAJUYeBJIOirqVahEO5CwmC21L93sDBOen7okteRef5T6cjrqJKjtydFwm2sxyKYY
         jBWQJHYf/EWltM0CQi1krbtNfL5mCWJhWMNwwv4+sbfqdasXu2RJizTrRdESz1cw/+Vp
         7ftvxCCLE6HHZVvpXCcyH30WUQwX9TgEGu2fOxbcdwykiGIxdYZNzPMs/vDtDOv/Yd3c
         kjj+lGeMwI5oiUd5g8HjuFDSOAQl3DBo+PdAaztbH6/WP6lbI7H1nyu/yI/KinUgcnF2
         jj7g==
X-Gm-Message-State: APjAAAXT5LiAEx067Y3JUKkH22GdF5Gsg4n+ShpNFDGdQnCTNzZDUw3M
        dZzpVizc73xZRCqdc3ORahFkNRJKAkw+qE8Y6pWrug==
X-Google-Smtp-Source: APXvYqw7QpmXVqKEg5vShGZiPGspkFNybObjpkFqQvNP5oupXedhZJ240Iitpdpp2r68VTNCQn/h86Bi/pJJmifkXTE=
X-Received: by 2002:a92:5ad1:: with SMTP id b78mr7934ilg.118.1569449449584;
 Wed, 25 Sep 2019 15:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190925213721.21245-1-bigeasy@linutronix.de> <20190925213721.21245-3-bigeasy@linutronix.de>
In-Reply-To: <20190925213721.21245-3-bigeasy@linutronix.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Sep 2019 15:10:38 -0700
Message-ID: <CALMp9eSc__WyxA9Zswt8pNYJ6vSiWBV+itLvcW--q=yWRfZe-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Expose CLZERO and XSAVEERPTR to the guest
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 2:37 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> I was surprised to see that the guest reported `fxsave_leak' while the
> host did not. After digging deeper I noticed that the bits are simply
> masked out during enumeration.
> The XSAVEERPTR feature is actually a bug fix on AMD which means the
> kernel can disable a workaround.
> While here, I've seen that CLZERO is also masked out. This opcode is
> unprivilged so exposing it to the guest should not make any difference.
>
> Pass CLZERO and XSAVEERPTR to the guest if available on the host.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948e..0ae9194d0f4d2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -473,6 +473,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>
>         /* cpuid 0x80000008.ebx */
>         const u32 kvm_cpuid_8000_0008_ebx_x86_features =
> +               F(CLZERO) | F(XSAVEERPTR) |
>                 F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>                 F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
>
> --
> 2.23.0

Didn't someone just post "[PATCH] kvm: x86: Enumerate support for
CLZERO instruction" yesterday? :-)
