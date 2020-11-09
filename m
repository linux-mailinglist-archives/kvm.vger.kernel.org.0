Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106E92AC951
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 00:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgKIX0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 18:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbgKIX0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 18:26:15 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD2DC0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 15:26:15 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id w145so12171232oie.9
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 15:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=38DeofOFUIYkLHO9imZX1OTrjAgZGAGUoTcq8TI1vbI=;
        b=mPXtDnpUWNsQDQKU4BEqEb6c+IKqIlLrne9ZlTQSv44suRs0UqF/YUjFdlHDtAjMs1
         RmYGq+keKmTrlrYEuEclEQfb2G/lvHqtTA9FuxUhMqU3BDrJHzmm5M3YdxYCauA1xBr4
         gtILKmrT1UgfmYGzsf4NaQUa5F4PAkylF2fQSexEdt9ZZ1k87Iw5onaGdbtAhGlzGgej
         aZQu8shSDccyRce7ufVFqQcd6j0bieruHqbOPvWPTLLdyCBkxW9B70n6psBiLinZz+5k
         W1EDXWHJsd7h/UOKG32Kv5ZYSUB8dyaWBhkHfBd/VMkfy1lbASGoD0qDdseQS/ghNn1k
         ZmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=38DeofOFUIYkLHO9imZX1OTrjAgZGAGUoTcq8TI1vbI=;
        b=UaNlkPThaZKR0pB1A/X0FvNquInrQUSoieKCf38eO3OKJ85GotL0aX5fn3J7udfvoN
         y/sfhCU6ODuAEDkh2WoK6R3Zggq7StvTYAbqi4b3ohKAqN2VOQkuAyf7LorFFJoenNUM
         i1vG9EU0ZcZ0xa5/IfWdD5HsKnHFDtJir/8TQHXArs5jY3+xaIwN3bslD6pp9337wpdN
         P+EYq/0hwT8GgxE5SwVok/mjskGuq2aVYBmccr2dqwbKCS9SGDcvvQ1inhU0snfceO6J
         Etj8GkqPgBASI19O8C4LXCZZ7egdqaD1qu6zRrHDrDdBjO8ruVEGqb8eLXnzUf8NhACh
         sGyw==
X-Gm-Message-State: AOAM533yglzMAH+8I4vK/fdgQ/46KHCWo0PDm45IOYqPWHm7azHfsP+I
        oZTIKCtkuYujbmDracnTpcjb/POTcJ5S4RyYYmWMzw==
X-Google-Smtp-Source: ABdhPJzPGvNiGQt38mG6elvI4UW6ZTgvh7re8iq8Ub9xo68tgHOVP7tdGXalhNBroZjoV4oXYZYvIP66JnOFv8geHnk=
X-Received: by 2002:aca:5505:: with SMTP id j5mr1012865oib.6.1604964374323;
 Mon, 09 Nov 2020 15:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2> <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com> <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
In-Reply-To: <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Nov 2020 15:26:02 -0800
Message-ID: <CALMp9eS+SYmPP3OzdK0-Bs1wSBJ4MU_POZe3i5fi3Fd+FTshYw@mail.gmail.com>
Subject: Re: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 9, 2020 at 2:57 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> > I thought Linux had long ago gone the route of turning rdmsr/wrmsr
> > into rdmsr_safe/wrmsr_safe, so that the guest would ignore the #GPs on
> > writes and return zero to the caller for #GPs on reads.
>
> Linux just switched that around for the machine check banks ... if they #GP
> fault, then something is seriously wrong.
>
> Maybe that isn't a general change of direction though. Perhaps I
> should either use rdmsrl_safe() in this code. Or (better?) add
>
>         if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
>                 return;
>
> to the start of intel_imc_init().

I wouldn't expect all hypervisors to necessarily set CPUID.01H:ECX[bit
31]. Architecturally, on Intel CPUs, that bit is simply defined as
"not used." There is no documented contract between Intel and
hypervisor vendors regarding the use of that bit. (AMD, on the other
hand, *does* document that bit as "reserved for use by hypervisor to
indicate guest status.")
