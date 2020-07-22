Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D963229D91
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgGVQyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgGVQyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 12:54:54 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFC3C0619DC
        for <kvm@vger.kernel.org>; Wed, 22 Jul 2020 09:54:53 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m15so1043207lfp.7
        for <kvm@vger.kernel.org>; Wed, 22 Jul 2020 09:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QUxmdpqhygtgKfzN8W9vujh+GzdOa2S0bqyvDwXYyhA=;
        b=wV+co3N+GbqN/y0oexAFRRgA4x0zoc2MLgnobj+GtwIikjfaAX3O4tJp9+0E/QTE4a
         IBadGE3VzIlg/ZGN7ZdALOZfaOpWX+rFiBDJg++rJ9tbsdMABK7FuX5Ap8bNtP4kzCDk
         /tzLC4ZuQYtp3U9M0KzBCdHy9w2fhLm+ebpnJjmmCedEGqGKFyiwvNfxx8I6D3QozfXc
         7sA12yOo1tyb1vrs3KuCTZ+izv3FeBPQoWTTOD//8QCbEhSvhep5x4qulR1Tx9H8i8Cw
         3ApnTAVI2Of8xOV4GDoZTPTAl9H9G+sqlsZvPvejhMnpxeyZ5xCqSaLCZk8WoU2ORf6k
         Yfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QUxmdpqhygtgKfzN8W9vujh+GzdOa2S0bqyvDwXYyhA=;
        b=rxjb4RVWwqSyBuqV8hyCLOj/xb8fTB2bchjg2O6dXnFAjEmNzzSWS6snCU3LXpqBBv
         58RHkI41+Mhb17ELYrpR7TKK+A3LnsD1Zgv+x2nSKrlI9MTOoELFyILmnvvitq49ZfoW
         4TG5q+m+4p4N7MxJaVU67NuZ8r0d72VZtj3uJrt/t66Qz+Zaai0pZjh7WPaD81ixDdCn
         //yA+Pu8nBft4CQLypTuPD5FzVU6DEYmngrv/HfC25uC5vVkt/fMmCQ7blyUThNQ+5iK
         kUmPfZJpZYXUrZDUdcawC2aMDltfgaZ7KNg6WsZAatkAZHk1E0LtFS46gW+yYL0sZeV1
         Wrfw==
X-Gm-Message-State: AOAM5321DR2LMXYSwN5ZEueZ6miQ8twmxppC2JV+iYk8D0AkPltmHD1V
        tQ0ZEiI5wYyAUbwkwqSkmiinZ2hKG2xnCtxRVbh91A==
X-Google-Smtp-Source: ABdhPJziugCNOtA+haz6tPn4p1Sdw9jHB5V1BZaSpUkzo1SkrAuZ5w9XZAE+IuJ+QaTyXtQCEjaq7N+rEOxkaVHXQWU=
X-Received: by 2002:a05:6512:1182:: with SMTP id g2mr150606lfr.126.1595436891943;
 Wed, 22 Jul 2020 09:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200714120917.11253-1-joro@8bytes.org> <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de> <20200715095556.GI10769@hirez.programming.kicks-ass.net>
 <20200715101034.GM16200@suse.de> <CAAYXXYxJf8sr6fvbZK=t6o_to4Ov_yvZ91Hf6ZqQ-_i-HKO2VA@mail.gmail.com>
 <20200721124957.GD6132@suse.de> <CAAYXXYwVV_g8pGL52W9vxkgdNxg1dNKq_OBsXKZ_QizdXiTx2g@mail.gmail.com>
 <20200722090442.GI6132@suse.de>
In-Reply-To: <20200722090442.GI6132@suse.de>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Wed, 22 Jul 2020 09:54:40 -0700
Message-ID: <CAAYXXYxRzO+hFvge4sKvNyH64iW9N2eLNbbKOR2DZf0DDL6CUw@mail.gmail.com>
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am using a custom, optimized and stripped down version, OVMF build.
Do you think it is because of the OVMF or grub?

In my case, there are 2 places where the CPUID is called: the first
one is to decide if long mode is supported, along with few other
features like SSE support and the second one is to retrieve the
encryption bit location.

-Erdem

On Wed, Jul 22, 2020 at 2:04 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi Erdem,
>
> On Tue, Jul 21, 2020 at 09:48:51AM -0700, Erdem Aktas wrote:
> > Yes, I am using OVMF with SEV-ES (sev-es-v12 patches applied). I am
> > running Ubuntu 18.04 distro. My grub target is x86_64-efi. I also
> > tried installing the grub-efi-amd64 package. In all cases, the grub is
> > running in 64bit but enters the startup_32 in 32 bit mode. I think
> > there should be a 32bit #VC handler just something very similar in the
> > OVMF patches to handle the cpuid when the CPU is still in 32bit mode.
> > As it is now, it will be a huge problem to support different distro images.
> > I wonder if I am the only one having this problem.
>
> I havn't heard from anyone else that the startup_32 boot-path is being
> used for SEV-ES. What OVMF binary do you use for your guest?
>
> In general it is not that difficult to support that boot-path too, but
> I'd like to keep that as a future addition, as the patch-set is already
> quite large. In the startup_32 path there is already a GDT set up, so
> whats needed is an IDT and a 32-bit #VC handler using the MRS-based
> protocol (and hoping that there will only be CPUID intercepts until it
> reaches long-mode).
>
> Regards,
>
>         Joerg
>
