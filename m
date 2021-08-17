Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A060C3EF60F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhHQXVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 19:21:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhHQXVU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 19:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629242446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CEwhor+Z+8oa4WM8Oi5cJsChDqCNGSHq7j3GEIZe8Nw=;
        b=fHiNewyF8Z5HzF+J0BDtIf7w9VVheq+c2hsGKavXRfM3SxrChMbuWCwVsuMQc8YWr6jMM5
        jWyPG9sD65hTLv3Vbo8QtrHkasjcfWaTAEDzL9kDmBl5g8WgsNzSMdiIHe4TBWiOh8NaCl
        t8N+vJDJ4tPaB6et53UCC9iZUzznN+0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-MZODdHxYPQCnJXmyhzM-Eg-1; Tue, 17 Aug 2021 19:20:45 -0400
X-MC-Unique: MZODdHxYPQCnJXmyhzM-Eg-1
Received: by mail-pj1-f72.google.com with SMTP id h21-20020a17090adb95b029017797967ffbso568710pjv.5
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEwhor+Z+8oa4WM8Oi5cJsChDqCNGSHq7j3GEIZe8Nw=;
        b=Rj1OoTA6sN7pYBrjm+H8zOtU0o1g371ZzyLrxARIapcUr9XbmRlhsyuOnZTNf8ZTwu
         mugiQBk6N74s9wcfCWkxKw77BLnncgse7muS12Boi2lPNF85BXUHVf+UpilcYgH68RKo
         hYRz91OlyjxGUQ7k7X0uVPorVS9OzdKvWuiIDRtAPiJlYCG8wUYPj8QE5rE/+KkUyMKS
         jBXuO3HAozztjawi+RNZ+g8kADOgAIvZuXgd0UwvY2Hu+9E48aXc11jmN92JZtssktTj
         BuXV99Xt0L972WG/pJlq0g8/ugzNbUUsEoX5ZsmN9s6+cYT1NAq1Cx91CbtZmImFjBOb
         +gZA==
X-Gm-Message-State: AOAM533G4blwVGPM1ti7IRwtW8hC9VQMH+VB4xKl+zU0A4Br+w2cj685
        HdhmB77vjfU62u5BXQRf5FP1+6mcswyQEzUFFZBFZgL/L6aYUiLbvB5jxpEwtwN9fXL9clMF286
        i8Ka5xibeUcJabj8m8LEfRu6hwH9v
X-Received: by 2002:a63:5fcc:: with SMTP id t195mr5711415pgb.146.1629242444189;
        Tue, 17 Aug 2021 16:20:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTwNjlO02zRXcWFcI9eLHyW5ECSSGVrU7Ymey0gNtRDmaWq9MUtZjMO0REfPSw5PQYLTxrmLK3CwPE9pyeFMI=
X-Received: by 2002:a63:5fcc:: with SMTP id t195mr5711389pgb.146.1629242443919;
 Tue, 17 Aug 2021 16:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com> <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com> <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
In-Reply-To: <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 18 Aug 2021 01:20:31 +0200
Message-ID: <CABgObfYz8=+u1nsiSiLbOo7t7uSyQzro+crRsK4fANS1_TZR9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        David Gilbert <dgilbert@redhat.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 10:51 PM Tobin Feldman-Fitzthum
<tobin@linux.ibm.com> wrote:
> This is essentially what we do in our prototype, although we have an
> even simpler approach. We have a 1:1 mapping that maps an address to
> itself with the cbit set. During Migration QEMU asks the migration
> handler to import/export encrypted pages and provides the GPA for said
> page. Since the migration handler only exports/imports encrypted pages,
> we can have the cbit set for every page in our mapping. We can still use
> OVMF functions with these mappings because they are on encrypted pages.
> The MH does need to use a few shared pages (to communicate with QEMU,
> for instance), so we have another mapping without the cbit that is at a
> large offset.
>
> I think this is basically equivalent to what you suggest. As you point
> out above, this approach does require that any page that will be
> exported/imported by the MH is mapped in the guest. Is this a bad
> assumption?

It should work well enough in the common case; and with SNP it looks
like it is a necessary assumption anyway. *shrug*

It would be a bit ugly because QEMU has to constantly convert
ram_addr_t's to guest physical addresses and back. But that's not a
performance problem.

The only important bit is that the encryption status bitmap be indexed
by ram_addr_t. This lets QEMU detect the problem of a ram_addr_t that
is marked encrypted but is not currently mapped, and abort migration.

> The Migration Handler in OVMF is not a contiguous region of memory. The
> MH uses OVMF helper functions that are allocated in various regions of
> runtime memory. I guess I can see how separating the memory of the MH
> and the guest OS could be positive. On the other hand, since the MH is
> in OVMF, it is fundamentally designed to coexist with the guest OS.

IIRC runtime services are not SMP-safe, so the migration helper cannot
coexist with the guest OS without extra care. I checked quickly and
CryptoPkg/Library/BaseCryptLib/SysCall/RuntimeMemAllocation.c does not
use any lock, so it would be bad if both OS-invoked runtime services
and the MH invoked the CryptoPkg malloc at the same time.

Paolo

