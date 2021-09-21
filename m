Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33256412E01
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhIUEnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 00:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhIUEnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 00:43:09 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C696C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:41:41 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so73890232lfu.2
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 21:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxuHzOsvRgy/5dce+IhPa3iHX7pzR+LP0s9bgaXkyTQ=;
        b=etsazZMoZ49BYH4Sk4QpPwknhay8m3DLJNL/cEembJ1aXaEP0SFzSHK3BIBjDGF4yR
         YB3L74zQJojzxL1TX/MS9y0BuVRmlTspr2sTL6LBnXoFOcbfNla5uMezlJWE5V9I7FO4
         i2rmV5wvb/MWTSSChAWjIb/cy96XYrgYYnpFA/0hjWsfR5S/fTiUTZHXMIVeqggWN5JD
         Ogg71hj+UYluZkxaVnku4L4gOYp7I09QLpUPI+2W7L4aSV4CX8vwgUPssXYBj1FQrS/q
         I2jeIqNNOQbEbSTKM8VyIv0X27TF9D8b811+AdcHik+MFgjmPI5MKI50tQP/y0pOwXkl
         NMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxuHzOsvRgy/5dce+IhPa3iHX7pzR+LP0s9bgaXkyTQ=;
        b=6nAqZN9tAAzXT9PKIW49tgkllXHlLw6bCMvTJqER1lseu6ffmF8kvTQekqGOCkx0Jj
         zLkaQRmha+f+P7AdR4XfCJunvZNejV7bGCyhgiD12hh2Q6QnH72egrm44rdI82e4q38J
         HLLzCRVVFXyiU+Ut1QfNFOiwKU5R7gV+7qvRowYX6VWQS0kjefYtpoJRXNqMefHAfDl1
         DW6uZLz6Mi1gsHsfe2hLoeUcl32996Bc9PrSAhRHf1vYhpKbbQhlfX0gZk/Iht4e9d2W
         Vs2lZaPY4PQ6CR4j2jNB8sHofJGOrrQP/M9MRVVxwFVp319IfkgA1n3MQ+5dxeuEx0DL
         gi3A==
X-Gm-Message-State: AOAM530cTFTlEaU6Aalsbhg8m1FD+EbJvjP6VbPnOoWspYKeEMF8p3Qb
        3Cr5bhuDieVFmQ0U8wckjG/drhMXmfCGMP9RJwhe40LSeL+FmA==
X-Google-Smtp-Source: ABdhPJzOLZmsNOtmgRHcleJE96ZtM0vlTW26x8zhuiZTlPCmFPEieGd4ZkJ+rIYhhggMmbb0lCKHVa9vemi/YPvR3rU=
X-Received: by 2002:ac2:446e:: with SMTP id y14mr5516190lfl.326.1632199300032;
 Mon, 20 Sep 2021 21:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-15-zixuanwang@google.com> <34173c4c-d704-5d28-8aac-c2debf224a86@redhat.com>
In-Reply-To: <34173c4c-d704-5d28-8aac-c2debf224a86@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 20 Sep 2021 21:41:04 -0700
Message-ID: <CAEDJ5ZQEcmV8d_YXyV-7c6u1Q7FTGSY7esw-08vYyYzoNfLVsg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 14/17] x86 AMD SEV-ES: Load GDT with
 UEFI segments
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

On Mon, Sep 20, 2021 at 6:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/08/21 05:12, Zixuan Wang wrote:
> > + *
> > + * This is because KVM-Unit-Tests reuses UEFI #VC handler that requires UEFI
> > + * code and data segments to run. The UEFI #VC handler crashes the guest VM if
> > + * these segments are not available. So we need to copy these two UEFI segments
> > + * into KVM-Unit-Tests GDT.
> > + *
> > + * UEFI uses 0x30 as code segment and 0x38 as data segment. Fortunately, these
> > + * segments can be safely overridden in KVM-Unit-Tests as they are used as
> > + * protected mode and real mode segments (see x86/efi/efistart64.S for more
> > + * details), which are not used in EFI set up process.
>
> Is 0x30/0x38 the same as kvm-unit-tests's 0x08/0x10?  Can kvm-unit-tests
> simply change its ring-0 64-bit CS/DS to 0x30 and 0x38 instead of 0x08
> and 0x10?  I can help with that too, since there would be some more
> shuffling to keep similar descriptors together:
>
>   * 0x00         NULL descriptor               NULL descriptor
>   * 0x08         intr_alt_stack TSS            ring-0 code segment (32-bit)
>   * 0x10 (0x13)  **unused**                    ring-3 code segment (64-bit)
>   * 0x18         ring-0 code segment (P=0)     ring-0 code segment (64-bit, P=0)
>   * 0x20         ring-0 code segment (16-bit)  same
>   * 0x28         ring-0 data segment (16-bit)  same
>   * 0x30         ring-0 code segment (32-bit)  ring-0 code segment (64-bit)
>   * 0x38         ring-0 data segment (32-bit)  ring-0 data segment (32/64-bit)
>   * 0x40 (0x43)  ring-3 code segment (32-bit)  same
>   * 0x48 (0x4b)  ring-3 data segment (32-bit)  ring-3 data segment (32/64-bit)
>   * 0x50-0x78    free to use for test cases    same
>
> or:
>
> old     new
> ----    ----
> 0x00    0x00
> 0x20    0x08
> 0x48    0x10
> 0x18    0x18
> 0x28    0x20
> 0x30    0x28
> 0x08    0x30
> 0x10    0x38
> 0x38    0x40
> 0x40    0x48
>
> Thanks,
>
> Paolo
>

Thank you for the detailed explanation! Updating KVM-unit-tests GDT is
one way to solve the problem, but we found a more straightforward
solution [1]:

We found it possible to update the 'code segment selector' field in
the #VC IDT entry and point it to the KVM-unit-tests code segment.
This allows the UEFI #VC handler to use KVM-unit-tests segments, and
we do not need to copy the UEFI segments.

I will update this into the next version.

[1] https://github.com/TheNetAdmin/KVM-Unit-Tests-dev-fork/commit/ab480fd0fbad813c2922526a0bccadf121cb9240

Best regards,
Zixuan
