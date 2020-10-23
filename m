Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9960297576
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 19:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751381AbgJWRDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 13:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464587AbgJWRDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 13:03:40 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429F3C0613D2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 10:03:40 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id z14so336993oom.10
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 10:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDz4gn4LXn8aroBJkBNj8TPyfOZEVwrvC4JEhPovxCc=;
        b=tjp99hRnrJBWxkp6Vt0ZTXhFtCr8W0JWcM22W0i9CA7yy4mHa6ojSztPNyjJ3u7rtD
         7sCLlloe1t0myru2qd38kAns9VptXqnUuhDcXVC5gohNzj3MXvXdYgxqizZ3I3VtllXf
         p5Xk4rlkLzsQHoKm9imbgsaeTbeHmYfx3sZz7CylGiqMZtt89WZzVA4LxCybWYkjDbXs
         UFgov1fNAKJ1g1C3CbOHJNiAiNpSzX2y2ovtd1Ekthm8VPID/De9cCy9ciEvaMT/P5Pt
         S++RquTwOhZMxYYRa1KSo/UDyv3g/bbC9cF0E5TRG0Jsn0GdNfx4nlaWOeGd8hoH+c5D
         f5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kDz4gn4LXn8aroBJkBNj8TPyfOZEVwrvC4JEhPovxCc=;
        b=tO1WVqP7fAl4hbpf9carxkx3PuCIhgwjxWDIeTVd5pKA49rN4yg/AXjuKeqfmFMEY0
         HhPbOl3UqFDmnmzAtjWArbU/yaK04nKyVn0v/TuId7kx9d2MFZfOPYk93GZd2fjexTHO
         Mae9AutOQq0N1SlWXbbGiv2x/0lxhNxmJ+Zozn+VLiOyH04GrsTL/t/mkbt2LuNoQ1cq
         m3jqq7Jue4rw07qXKk8eTveipo9fR270uKwXVDnP+RkXUvK2TmOaz38XjQLF9L9ZPBLh
         Jp77wbuyxozNmirQDvybnCk8u1oNrzODIcQI9IXRd9AdKcf82GlfjwyZZ1aZZVvCEjHQ
         fNaQ==
X-Gm-Message-State: AOAM533aiR5hGXxyaiK2qIBrVg38YYaOzWHZy4h5Fnsk2DW3F0jtAeuH
        R8i5Bls34M16yRB8dVvNrG54scG+iJ5VQfiMOVPMBA==
X-Google-Smtp-Source: ABdhPJyUiPATpJxZtE/yL8srFLqEuuE6XYH/4Xen/h6AQ79x3D9IEVDVce9xV4+7I+k6nfpkG46wmc1vDcpKbn81EoA=
X-Received: by 2002:a4a:dcc8:: with SMTP id h8mr2435632oou.81.1603472619282;
 Fri, 23 Oct 2020 10:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com> <CALMp9eR3Ng-WBrumXaJAecLWZECf-1NfzW+eTA0VxWuAcKAjAA@mail.gmail.com>
 <281bca2d-d534-1032-eed3-7ee7705cb12c@redhat.com> <CALMp9eQyJXko_CKPgg4xRDCsvOmA8zJvrg_kmU6weu=MwKBv0w@mail.gmail.com>
 <823d5027-a1e5-4b91-2d35-693f3c2b9642@redhat.com>
In-Reply-To: <823d5027-a1e5-4b91-2d35-693f3c2b9642@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Oct 2020 10:03:27 -0700
Message-ID: <CALMp9eQBnvMOxo7u2yEavTpKJB845OFmCQ6BnqUYUoMdbt9U9w@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 2:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/10/20 19:13, Jim Mattson wrote:
> > We don't actually use KVM_GET_SUPPORTED_CPUID at all today. If it's
> > commonly being misinterpreted as you say, perhaps we should add a
> > KVM_GET_TRUE_SUPPORTED_CPUID ioctl. Or, perhaps we can just fix this
> > in the documentation?
>
> Yes, I think we should fix the documentation and document the best
> practices around MSRs and CPUID bits.  Mostly documenting what QEMU
> does, perhaps without all the quirks it has to support old kernels that
> messed things up even more.
>
> Paolo

I'd really like to be able to call an ioctl that will help me
determine whether the host can support the guest CPUID information
that I already have (e.g. on the target of a live migration). At first
glance, KVM_GET_SUPPORTED_CPUID appeared to be that ioctl. Sadly, it
appears that no such ioctl exists.
