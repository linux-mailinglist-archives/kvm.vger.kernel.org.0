Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2252190F3
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGHTt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHTt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:49:56 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A582C08C5C1
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 12:49:56 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x9so49352ila.3
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I9bO2SvLDKet0zC0FnvNLQImEbF2fhapt4H2nUguyC4=;
        b=VQMutR39qCwX+rzcpy2tnhenXy7JQ8m0tuhbilG4X7au0sVK1MdJWPjVT1I6rFd/6W
         LpKtfFBaByCEYDWOL2MDdF9Zyd7eeeORwzRTzNepJvCCMyDv9T7TZRGDNwtRE5DS9ouU
         aWKzFsbyiwBaAGEKDO2+5uy1AYd8ZkMuQaIYc9d/yUdQoJKhtbGmSGKpDzHWkxkZS9AP
         r90hG4a6m9XEZMi0Iz8yHPEs00oqG4JYNAMRgNKIC+lW7VShiPEn0JOgrhBLMinkSDHf
         JkdNPXBIzQmQJfnkq0X+y30oG6/81fjweNvbjVXrd+8OsllzRICCvoyI9bTxiJueNfPG
         BWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I9bO2SvLDKet0zC0FnvNLQImEbF2fhapt4H2nUguyC4=;
        b=gFTeWRRe4Lhbd++6g5mtfHZZ5qJ1Jk9JndLAg2wc6kyW06E0kOYmdRaTGJywtMM1Od
         2GojAM6PlqNtPcQ62Ek+r+1H6uZkE3QnMUrI47jb+EYie9FhIRo6oM8ARMlSDohw9r2y
         0wVLQERy/gNLYHsabrdwU6ULlgJ7FLslHQ5oXXKT9eMYPJ1rTvNXMihfdC0x7MuGyQWh
         ByRBOaYi+nhhDTZr6e6YLCZmM7SblqYP0/tAmmG78d81sI7Yi7Y/YLp4DLbgca8gYlJE
         a6YolIGT3Dv+VJFPQ89mmk5eGWXzW6Qqo52PqPJ91UqBykjHLcVh+tZivbf6PXkdYMZa
         3s0w==
X-Gm-Message-State: AOAM531o3TAYvWSgcR8rtDBm3J8jKKH4oY4r1b8oYtmjP2Itl4fKLZYn
        8Jg69ST6S9Ew299a9tzfPLXuFY15MG9UXi/M84fB+Q==
X-Google-Smtp-Source: ABdhPJy9DOSdnQPU184rzJ43rhfRWcru5enbc3FbwYxuqR6UthrROMB5kbzwaT6IGXDS+2J3KMXKLi+H8r51JqyLq34=
X-Received: by 2002:a92:b685:: with SMTP id m5mr43580715ill.118.1594237794192;
 Wed, 08 Jul 2020 12:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200708192546.4068026-1-abhishekbh@google.com> <06f15327-f346-fb8d-cc8e-8e12c398324d@infradead.org>
In-Reply-To: <06f15327-f346-fb8d-cc8e-8e12c398324d@infradead.org>
From:   Abhishek Bhardwaj <abhishekbh@google.com>
Date:   Wed, 8 Jul 2020 12:49:17 -0700
Message-ID: <CA+noqohUFoCQdRKLTtGXOB=GAKYO5Er=-EVpOMowEufB9dnk_g@mail.gmail.com>
Subject: Re: [PATCH v4] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 8, 2020 at 12:34 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi again,
>
> On 7/8/20 12:25 PM, Abhishek Bhardwaj wrote:
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index b277a2db62676..1f85374a0b812 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -107,4 +107,17 @@ config KVM_MMU_AUDIT
> >        This option adds a R/W kVM module parameter 'mmu_audit', which allows
> >        auditing of KVM MMU events at runtime.
> >
> > +config KVM_VMENTRY_L1D_FLUSH
> > +     int "L1D cache flush settings (1-3)"
> > +     range 1 3
> > +     default "2"
> > +     depends on KVM && X86_64
> > +     help
> > +      This setting determines the L1D cache flush behavior before a VMENTER.
> > +      This is similar to setting the option / parameter to
> > +      kvm-intel.vmentry_l1d_flush.
> > +      1 - Never flush.
> > +      2 - Conditionally flush.
> > +      3 - Always flush.
> > +
> >  endif # VIRTUALIZATION
>
> If you do a v5, the help text lines (under "help") should be indented
> with one tab + 2 spaces according to Documentation/process/coding-style.rst.

Apologies for missing this. Fixed in v5 -
https://lkml.org/lkml/2020/7/8/1369

>
> --
> ~Randy
>


-- 
Abhishek
