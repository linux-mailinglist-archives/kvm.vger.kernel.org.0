Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F80227460
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 03:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGUBJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 21:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGUBJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 21:09:31 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7278C0619D5
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 18:09:31 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 12so15911366oir.4
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 18:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dt+Q1yBp4pDTEEa5JxC/tBw6WPMfkbJUYHcrzD2fQPw=;
        b=UvsgbLTUQVe3b9JkR+S3lcYaaULY2+DOIgYkocU2xTKRCoNAhp507MLqfV8Tr7TxY5
         SV2680GHMFFcbul/qFtIEHUMySCfPwia7v4SzLorXXNiUDtiD7SZ9pOE2+AnZPIxqCrp
         nAJ9T6tfwuFOr8XBFfc9SwXZAdsJkxeP/C6j/NqQJyf+3vXmHBVk56fpwRATQ6TWtoOt
         gkob0DsXY93bLDeEgFEEyShn8N6C7hky2zBopNoCIWijwswFg7cyrrQssMsACCIxfoXy
         8LJoO6CFPVZ32L5qPqKXFAVxKcNVCYvNxpdATzgIgnvq3t5A8Ld4C60w5CNENQWJM2M6
         d2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dt+Q1yBp4pDTEEa5JxC/tBw6WPMfkbJUYHcrzD2fQPw=;
        b=Fx/C6TZTxR8jfpb3eCxWPIW6Gr9Nk2ldthFDHL2pHI2l3G/zgiz4+HvnBFx5Sl3KRw
         VwSAyilLqN2JIrahX8lR9CDJ9nC53LoonwejltDE5Jw0UE8AAagjfmqSY0ZSVIz6MZnO
         Oqcws2jfVXPz4YpVFERD8NMQ8TG1tmG48eayxrHDVBohG96ytjT1lxuBQ1xdyP5f5aKF
         bRyp66PPNAKMLCZfq1tQmXqZl40AO1+ziVwwr5ns/5KOsI8vLgwyte/FgYjPoErYkLSG
         VzoTCV+JHavNn79XRVCXKv/IVedpY1imuB4wUqJ0pDB8eMgm4NmnhSkz7XtQJVTqBMWx
         KUlw==
X-Gm-Message-State: AOAM533r0hlO237T7seWsKNb+baVT6w0q6o0zvRczHz2O8I3Cz+VQM7D
        YZYdYlrSwgyIchUJZPcurByJ0fRsXbqTr/4YmbDdLw==
X-Google-Smtp-Source: ABdhPJzbi5+F2TpRM+GQt+/eaPnbEZR9u3OoIuc3AKHNzYvH8Zc12Ws1ii+wl9fUXQMMJAX4w6v2msuWZo+eFSwG/us=
X-Received: by 2002:aca:d643:: with SMTP id n64mr1432769oig.33.1595293770513;
 Mon, 20 Jul 2020 18:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200714120917.11253-1-joro@8bytes.org> <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de> <20200715095556.GI10769@hirez.programming.kicks-ass.net>
 <20200715101034.GM16200@suse.de>
In-Reply-To: <20200715101034.GM16200@suse.de>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Mon, 20 Jul 2020 18:09:19 -0700
Message-ID: <CAAYXXYxJf8sr6fvbZK=t6o_to4Ov_yvZ91Hf6ZqQ-_i-HKO2VA@mail.gmail.com>
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

Hi,

It looks like there is an expectation that the bootloader will start
from the 64bit entry point in header_64.S. With the current patch
series, it will not boot up if the bootloader jumps to the startup_32
entry, which might break some default distro images.
What are supported bootloaders and configurations?
I am using grub ( 2.02-2ubuntu8.15) and it fails to boot because of
this reason. I am not a grub expert, so I would appreciate any
pointers on this.
Also, it would be nice to put some error code in the GHCB MSR if the
guest dies for some reason in real mode. Currently, it just dies with
no information provided.

PS: sorry for sending twice due to the wrong email body type.

Regards
-Erdem


On Wed, Jul 15, 2020 at 3:10 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> On Wed, Jul 15, 2020 at 11:55:56AM +0200, Peter Zijlstra wrote:
> > And recursive #VC was instant death, right? Because there's no way to
> > avoid IST stack corruption in that case.
>
> Right, a #VC exception while still on the IST stack must instantly kill
> the VM. That needs an additional check which is not implemented yet, as
> it only becomes necessary with SNP.
>
> Regards,
>
>         Joerg
>
>
