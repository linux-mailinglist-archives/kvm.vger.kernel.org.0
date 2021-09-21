Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06EA412DB5
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 06:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhIUERt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 00:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhIUERs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 00:17:48 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841E7C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:16:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id y28so74583381lfb.0
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcb3wJE9gMKVwldLLii1JAfRYSFkk8uUx31DUviWJhs=;
        b=PPyDPnqKTEUxXA9mZZ1Gj7uTkBDzaX30ks5lK7u5VKBlH+ykfarjsIvBUmw/Lk/W77
         Lnv6kynv5Q17nm8cZvTo3gfEkXya/xlY24VT4eyarzregG04rCdtItVQ9L08h+hZaB3E
         a2OFKCLf4zSIu6+XndKRhCt06MgLIoPWihKdP6qc+322Z/wlzpWn6EATcIKq8BKkIc6s
         yiZD2ja2qib6TVRFTNfMiEXnWk7a9113cV+zAAXa3d0FfiP4QsezaKTuleqTRP/SNHm+
         n+MG530zU0+MTZ7h33BH2QZhqZKbNK7u73SvtdKAQIOz9qLzeDduLsNXc+liTNknsKe+
         4Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcb3wJE9gMKVwldLLii1JAfRYSFkk8uUx31DUviWJhs=;
        b=X3TJ8E7WlrrjKV4KnqT/WuT5kr6pW68YkFU33wklSQQ2RjWOtR0o3MVgm8rfXfCT+f
         +pIGIW2iuPeqCTSCY6T5u8XLCU9BizFu+tkF5mEUzePvUgsVL3MhGjQMyhNMBff0upeg
         o309d0BA89ECBD6Ti0VrTgizaamU5pUldjRA8Y+7trhhs6s6zypInYOsVYxP2RHTWRf3
         Zt0XuwFXjAXXS0ZcrRQ/Y92zt8HB9MkZkjuqAuo8kfhQ0KX3X6cp//nvb0vzJVZbHq+1
         LLB6C3/WgR6D5DAVqRdQGodzj3rCZjyzd0mM+AEcu+QCQma9Urr8PjsTbasd9dZdJAUQ
         mX1Q==
X-Gm-Message-State: AOAM532bSV0UERMIIQ7s2G3yqIbVE9OktaBBUYT1SxVVT8q9WDUCOqiq
        sgQfg0vJbUXOhAfI6KpYOzlTB/PhvuapgZrpZAE=
X-Google-Smtp-Source: ABdhPJxAQAnJ5T7xomTB7PhXe4t147EE/2A21izuYxG5hqtpv6NgechMKX4IhNqd0KFqxW78+BfflYyM/eaA1k0NUyw=
X-Received: by 2002:a05:6512:10cf:: with SMTP id k15mr5071168lfg.617.1632197778852;
 Mon, 20 Sep 2021 21:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-7-zixuanwang@google.com> <47de7f60-cfe7-0207-9c68-01dc38acc857@redhat.com>
In-Reply-To: <47de7f60-cfe7-0207-9c68-01dc38acc857@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 20 Sep 2021 21:15:42 -0700
Message-ID: <CAEDJ5ZQxZLj0RwnG=-02DWjyTk0+S8+tY7j-Jn_isOcKtO5nMg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 06/17] x86 UEFI: Load GDT and TSS after
 UEFI boot up
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com, Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 6:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/08/21 05:12, Zixuan Wang wrote:
> > +.globl gdt64
> > +gdt64:
> > +     .quad 0
> > +     .quad 0x00af9b000000ffff /* 64-bit code segment */
> > +     .quad 0x00cf93000000ffff /* 32/64-bit data segment */
> > +     .quad 0x00af1b000000ffff /* 64-bit code segment, not present */
> > +     .quad 0x00cf9b000000ffff /* 32-bit code segment */
> > +     .quad 0x008f9b000000FFFF /* 16-bit code segment */
> > +     .quad 0x008f93000000FFFF /* 16-bit data segment */
> > +     .quad 0x00cffb000000ffff /* 32-bit code segment (user) */
> > +     .quad 0x00cff3000000ffff /* 32/64-bit data segment (user) */
> > +     .quad 0x00affb000000ffff /* 64-bit code segment (user) */
> > +
> > +     .quad 0                  /* 6 spare selectors */
> > +     .quad 0
> > +     .quad 0
> > +     .quad 0
> > +     .quad 0
> > +     .quad 0
> > +
> > +tss_descr:
> > +     .rept max_cpus
> > +     .quad 0x000089000000ffff /* 64-bit avail tss */
> > +     .quad 0                  /* tss high addr */
> > +     .endr
> > +gdt64_end:
> >
> > +.globl tss
> > +tss:
> > +     .rept max_cpus
> > +     .long 0
> > +     .quad 0
> > +     .quad 0, 0
> > +     .quad 0, 0, 0, 0, 0, 0, 0, 0
> > +     .long 0, 0, 0
> > +     .endr
> > +tss_end:
> > +
>
> Please place the IDT (from the previous patch), GDT and TSS in a common
> source file for both UEFI and multiboot.  It could in fact be
> lib/x86/desc.c even.
>
> Duplicating the descriptors is fine, since they're only referred from
> the startup code.
>
> Paolo
>

I will make this update in the next version.

I think placing descriptors in lib/x86/desc.c is also a good idea. In
this way, compilers can automatically generate position-independent
code (PIC) for data structures written in C, and the following
descriptor address setup code can be removed.

> + /* Set GDT runtime address */
> + lea gdt64(%rip), %rax
> + mov %rax, gdt64_desc+2(%rip)

Best regards,
Zixuan
