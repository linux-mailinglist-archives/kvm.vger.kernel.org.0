Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A22A28BFCA
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgJLSec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgJLSeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:34:31 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99EAC0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:34:31 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id 16so19659450oix.9
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z58rwSPQhR4V7OPDLBovwEA1jbvlEWTdqVC/4LRYpbA=;
        b=EP4K6XdvRLW/lqLkMYlIVyjo5jg0GYMLvEQF0DoiPJEMc1lmnNq73epKNW6244YDVF
         4zU0YzWBWhmQjT5SllnAsnrM3iQp/a3VhVRkmS78N3nJZFhhyFOdzJz4gpNezD1OXk5x
         vOwIe/Ja+uTHgP+JKssWvh/kCgoasliNvOE0XPK6b/ADvbyOdT5QdPS+2naMBsyHkQsc
         wJjkAj2wIwCR8ZU8xwXZym7kQNtaIjxCcJxjCe4pNIPVBfIDYai5fEs25CZqXpdoWt6t
         kw1OmVas+FXSUy0QxTeT3E6dJBjyYBfoPMlmNcz9Vmtj3ol+F3kIontcpIaTON9Ktp5O
         ToOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z58rwSPQhR4V7OPDLBovwEA1jbvlEWTdqVC/4LRYpbA=;
        b=euwEkD5zKCSX9HNoN3E1qtRDfWQqWYlLupFD/Xh8XiNU1T+j/Dz30VAUa3EhzKhgqb
         MMd4CKDMa6oxUd2q3n9VBZT1N1z+ewwLOl6W2bJTe1Hlrn2d2PvxODQPrXfVernB1b6R
         0wJW6zOK0FesJQMT/0gKj99a2/+8rWhJNWZlqwn3BFiYDLf8fStac6ddnIgInUUHxbI2
         T7zpJKGyIownFJATlP7b5kSXvJ+Zp65DZPP1rI1B7/1Yd7IW0uYFiB2qaIkTh6CRf3YO
         nnLd4z10+lM3FDNgxNnSKwvM3cCoZ7c1SdGBOfQE8feKmMLmlA9EBCev9AuBud9f01CJ
         ksMA==
X-Gm-Message-State: AOAM533W9eXNAakdRTPzDp7KJlipm49DIHQ7a9+qZB2Dp1oxvlb0qYv7
        98b4vZoB5rJ8TjQ5otxbgHcotlN6AsNcKQP4ZzUN3w==
X-Google-Smtp-Source: ABdhPJyz53+uCVV1C/oIH9rTW9X6p6Nvc2SmBNMljYeHdM4YRXHxa5ZcdeSbnlWMimUpLx4qBsOQj4bPgrCcgIjCIpY=
X-Received: by 2002:aca:d9c2:: with SMTP id q185mr11443218oig.28.1602527670906;
 Mon, 12 Oct 2020 11:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200508203938.88508-1-jmattson@google.com> <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com> <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
 <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com> <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
In-Reply-To: <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Oct 2020 11:34:19 -0700
Message-ID: <CALMp9eTO+VcjOY9aoVgCuV6RGVzyBf_YXQoCEua9NEqyfqygmA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 11:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/10/20 20:17, Nadav Amit wrote:
> >>
> >> KVM clearly doesn't adhere to the architectural specification. I don't
> >> know what is wrong with your Broadwell machine.
> > Are you saying that the test is expected to fail on KVM? And that Sean=
=E2=80=99s
> > failures are expected?
> >
>
> It's not expected to fail, but it's apparently broken.

KVM uses a sloppy hrtimer to deliver the interrupt that emulates the
VMX-preemption timer, so it can't possibly work all of the time. Much
of the time, though, it gets lucky.
