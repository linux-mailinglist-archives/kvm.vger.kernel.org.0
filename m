Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C595E29E82F
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 11:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJ2KCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 06:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgJ2KCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 06:02:23 -0400
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB54215A4;
        Thu, 29 Oct 2020 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603965098;
        bh=9kcfotFFJ47rYdLC6ZxzdCDBa1k7PeFD878Gh2iRMYw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vMd1WTw46NmbdjDfGERZXE49CkIxTu62Lo98SE3sftOXo2ak1wjE9ZykA5QSCJ4f6
         RDyWIZLY0FUMnquHbcpT2wuFgnwMWGJcElPYN/dCVDOBDKjwtw6POjOBjpvi7Bxxzs
         IPD7rWkW0qA5Zp3lwpn5CoP9SOsl9SQ1SBIW0R2s=
Received: by mail-qv1-f54.google.com with SMTP id b11so1072516qvr.9;
        Thu, 29 Oct 2020 02:51:38 -0700 (PDT)
X-Gm-Message-State: AOAM531iPFjBDH77Fzh6gQbCnPxvw2RSjiH09W81ktIs33bDifYtZd2Z
        iZ9fVclvnvl4DqzGCkdGa0d2BHxI6WBsCG1nBpw=
X-Google-Smtp-Source: ABdhPJxaZEntygitIVQOXS85Gb8nGw1osAMMJulsU6ZeD1uTGkc5sotJk4c97dNCIKL6ORL8v2BjlIfOh3rRL6d2/zw=
X-Received: by 2002:ad4:4203:: with SMTP id k3mr2986180qvp.8.1603965097361;
 Thu, 29 Oct 2020 02:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201028212417.3715575-1-arnd@kernel.org> <ea34f1d3-ed54-a2de-79d9-5cc8decc0ab3@redhat.com>
In-Reply-To: <ea34f1d3-ed54-a2de-79d9-5cc8decc0ab3@redhat.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 29 Oct 2020 10:51:21 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0e0YAkh_9S1ZG5FW3QozZnp1CwXUfWx9VHWkY=h+FVxw@mail.gmail.com>
Message-ID: <CAK8P3a0e0YAkh_9S1ZG5FW3QozZnp1CwXUfWx9VHWkY=h+FVxw@mail.gmail.com>
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-hyperv@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 8:04 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/10/20 22:20, Arnd Bergmann wrote:
> > Avoid this by renaming the global 'apic' variable to the more descriptive
> > 'x86_system_apic'. It was originally called 'genapic', but both that
> > and the current 'apic' seem to be a little overly generic for a global
> > variable.
>
> The 'apic' affects only the current CPU, so one of 'x86_local_apic',
> 'x86_lapic' or 'x86_apic' is probably preferrable.

Ok, I'll change it to x86_local_apic then, unless someone else has
a preference between them.

> I don't have huge objections to renaming 'apic' variables and arguments
> in KVM to 'lapic'.  I do agree with Sean however that it's going to
> break again very soon.

I think ideally there would be no global variable, withall accesses
encapsulated in function calls, possibly using static_call() optimizations
if any of them are performance critical.

It doesn't seem hard to do, but I'd rather leave that change to
an x86 person ;-)

      Arnd
