Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F9354A20
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 03:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbhDFBgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 21:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241929AbhDFBgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 21:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2C0B610CC;
        Tue,  6 Apr 2021 01:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617673001;
        bh=vAKgY/w88o4JyfifHbYX0gz1dz93+w7bT3qgEGRK2+g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BTtGcGh+zFemR4MouSS3Vp9rmKPyS0tvqRX6pInfYGcM69gWMmQhNYTrbXVW9aIKp
         HN7i7GMMzsQJFGYOgDrNeTAH0bdVBL06oabV6ktBwh7LVcvnaCUFz5JqfwnJrNjgc0
         eM/LhGT5aI+2cBKz+E/yJ6XCkgKB2Az3nCAI68+CgYtezmlqAerfex6cBbm8f4nHYk
         af8pKYG+KwwbXIPoZd3gXj4D0XI0BYgCzI9RNY47GWe8So3xBE+1I7pqJbu4cvjt3z
         524MJRKRuBeVE+g4kgQ0/isjeB8lqJLqv8R2an5H2u1roz1l/ynwPYgU3F7bD1397F
         nU8Q6IOr25fhg==
Received: by mail-il1-f178.google.com with SMTP id r17so3943534ilt.0;
        Mon, 05 Apr 2021 18:36:40 -0700 (PDT)
X-Gm-Message-State: AOAM531Acu4i75fJuuxTMD/ob7TUwBPjxWcB62hgktKWiZ2LxwnNUwMh
        ZeG5ZRUQS5uYlPzehpiV5Hprm2PGP77l6ARAiNg=
X-Google-Smtp-Source: ABdhPJzWSmikNXg5FMS/wC0dVQ759wtwRUK+hMolhUWYKc1R/+lCAuh7T+qb1Tw/ng25rQu0VjJgRKtq5v7y4qpUYpQ=
X-Received: by 2002:a05:6e02:1286:: with SMTP id y6mr21855088ilq.270.1617673000386;
 Mon, 05 Apr 2021 18:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210402155807.49976-1-pbonzini@redhat.com> <20210402155807.49976-3-pbonzini@redhat.com>
 <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com> <aab8a915-6e73-3cba-5392-8f940479a011@redhat.com>
In-Reply-To: <aab8a915-6e73-3cba-5392-8f940479a011@redhat.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Tue, 6 Apr 2021 09:36:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H72z9DbbV=_fEhCeeOaP8fQ_qtr4rQMD=f5n08ekG=Ygw@mail.gmail.com>
Message-ID: <CAAhV-H72z9DbbV=_fEhCeeOaP8fQ_qtr4rQMD=f5n08ekG=Ygw@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: MIPS: rework flush_shadow_* callbacks into one
 that prepares the flush
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        seanjc@google.com, "open list:MIPS" <linux-mips@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Sat, Apr 3, 2021 at 6:43 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/04/21 04:31, Huacai Chen wrote:
> > Hi, Paolo,
> >
> > TE mode has been removed in the MIPS tree, can we also remove it in
> > KVM tree before this rework?
>
> I tried the merge and it will be enough for Linus to remove
> arch/mips/kvm/trap_emul.c.  So I will leave it as is, but next time I'd
> prefer KVM MIPS changes to go through either my tree or a common topic
> branch.
Emmm, the TE removal series is done by Thomas, not me. :)

Huacai
>
> Paolo
>
