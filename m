Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0BD4479D6
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 06:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhKHFOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 00:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKHFOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 00:14:52 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDE9C061570;
        Sun,  7 Nov 2021 21:12:08 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j75so40303880ybj.6;
        Sun, 07 Nov 2021 21:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTzUedNCNQEHveRyHIbZkdaiKokaUWSg5tuoQ1CJU2c=;
        b=VW8ISBH/mMgF4Daj8nQbWD9UZyiOcQZmRXBWIJQFO861Fo0W6iRXv5uvYcsVNwBeYv
         PIMiR4m8m4YQEHNNcOcSnFuYiyt0gaFXoz8kjYZNCJUEnRJbFMPcp2QFg2bSPd5zAbGc
         tQMzrMUpDHi9V7f2jX+fDPe8y9Ot3c4WIGtqLyUcCJ7CwDi8rC4MQ894hraQf36Rd+jI
         yVsOEiEGeO7DNo7CWV07XhQmn79mNaTqEdSYB28SUKHyx2y6Au0y0zd9IRIo2/QvO4pJ
         IYFq/k/FZGzvq//mNcg4DwDlx0u+UkrHoTPmH0OZMdI/AZ/rhiz2hTye5tqWnUaRsqNq
         BgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTzUedNCNQEHveRyHIbZkdaiKokaUWSg5tuoQ1CJU2c=;
        b=wvEJW/8WtJrg0ORR23el4RjyoI/i8pCfehuTKG+V0KZynyN+LJDIibKPh7rmMJo9iI
         U9hUm3x2ModBQe49TO7WwSM9C8HAXIL4/m4qSyUOdKC9uN8E2vJx0HtmV+iLemvS/VwX
         E1L/DG3e34BC7Wdrwfx0rD3TX7MqOxGotN/Hw1u8G0G+Ko6GBhbKEbMyNnmdRv01divV
         a/flaieL3ARqPpiv4uJtp0S/ZXIHo+OAF36Cw9jbgQh3cAC35bUPAmWFp34nZKAhKo65
         /C/Pha57Cilg8v5QD4oRtFDxOxPFWhiTB6dXia1RYOwKV3N1H6qH62ItEKIih692W6RZ
         AOTg==
X-Gm-Message-State: AOAM532Q52PrZBKFSNdH1MH/41qO/pk6o+zP7SREV+Tap7oCPNs42gtw
        ETM56RxiiT6+CEPC5kfYvuNG+DP3okAA0Pzyb9dtT3HK2+0OYQ==
X-Google-Smtp-Source: ABdhPJx7zRklEPdFkJA21WPFugYpNHL6WIa+/pnFSQ+H+ZR/x2OdLL7W5E6nOO0xxx73yXfHllsdEE25foyNu5OTEPE=
X-Received: by 2002:a05:6902:10c4:: with SMTP id w4mr64523717ybu.439.1636348328184;
 Sun, 07 Nov 2021 21:12:08 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
In-Reply-To: <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Mon, 8 Nov 2021 13:11:57 +0800
Message-ID: <CAFcO6XMe9RXRHxbjXoNBE3xFaATJggrpiRH-9127XBrBzf3eeg@mail.gmail.com>
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, No one pays attention to this issue?

Regards,
  butt3rflyh4ck.

On Fri, Oct 22, 2021 at 4:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/10/21 19:14, butt3rflyh4ck wrote:
> > {
> > struct kvm_vcpu *vcpu = kvm_get_running_vcpu();  //-------> invoke
> > kvm_get_running_vcpu() to get a vcpu.
> >
> > WARN_ON_ONCE(vcpu->kvm != kvm); [1]
> >
> > return &vcpu->dirty_ring;
> > }
> > ```
> > but we had not called KVM_CREATE_VCPU ioctl to create a kvm_vcpu so
> > vcpu is NULL.
>
> It's not just because there was no call to KVM_CREATE_VCPU; in general
> kvm->dirty_ring_size only works if all writes are associated to a
> specific vCPU, which is not the case for the one of
> kvm_xen_shared_info_init.
>
> David, what do you think?  Making dirty-page ring buffer incompatible
> with Xen is ugly and I'd rather avoid it; taking the mutex for vcpu 0 is
> not an option because, as the reporter said, you might not have even
> created a vCPU yet when you call KVM_XEN_HVM_SET_ATTR.  The remaining
> option would be just "do not mark the page as dirty if the ring buffer
> is active".  This is feasible because userspace itself has passed the
> shared info gfn; but again, it's ugly...
>
> Paolo
>


-- 
Active Defense Lab of Venustech
