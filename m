Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2D15EED5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 18:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbgBNRn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 12:43:27 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36320 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389771AbgBNRnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 12:43:25 -0500
Received: by mail-io1-f67.google.com with SMTP id d15so11451519iog.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 09:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vH6F7s/7KJOmKxjFPtdbua/0bzQH273F8zOPdozonb8=;
        b=Ux0PhWNqk4sJNEs0icorJrDWXp824NUdWvxe43XntaFe4SR1FlgGObmsib+qpD1Ty7
         umGaCdf7ZDRykv+Sv2UF5ntf+qG8pt5dWqR/xopxpGobdyEjt5xGlt4rw1j4DFllB77o
         FOztyw1X44q3OjHuAhB1kKDHPd0QVA4rXe0fj30RB2ZhUuqqjhwAILokrOlystz9aCtH
         BuJQ4pE3vnGZV+wn6vUDXCbeHqMTyxNMwnukmyBKdCF353gbp6mq3IwTWL+1hDurD3Vq
         OEXtqLyEqHCMjGkg5XDUqbWHcyfnFD5fNCN7/5hBPPH64kCTgNVhIl1huzTna60C8xnK
         fgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vH6F7s/7KJOmKxjFPtdbua/0bzQH273F8zOPdozonb8=;
        b=uUH5LW4gskYhPtycb2O08QyFTaKY9wvdnBXaaETGTlm4rAtvQBrnuXR7V6cW+tiHND
         lbkqTi2D42wP29kKYbJpAbbgsLorVExIUgNVAT06ivlq0bdpiy1uSrw0403DvDNqG0/w
         2LpE8YysGbLdJECYdSR0PncEZoC7TG273XBq7/yb0TrCmMsaotUEKAITQr5OkZut0UnO
         UNihNd4NJM9MjR7TFk+qfwNpq5Jb9gCJ56sNr839PqjMqxOx7hYw1GtB9FG1XjUKUrML
         oFbkJpXjyT6jX8RBW4Rl2JVpicuSVl+grJztsEgtuAZuWjzf++/CRoxhtnIcsqrra6w/
         Y8AQ==
X-Gm-Message-State: APjAAAUTSqwUEbgx7niGxmTXZpLskZjx58PcKBXtiVxeg9P990tOUgUn
        AcxVxjUesMTmGCMXn5sKOF7Rn9w1ukKDNrMuHl1g1Q==
X-Google-Smtp-Source: APXvYqzLzSD4wBOn+oU2MaRsuKpeItnXRIq8O1WrWQrL68J+eAQXMFVizCcOMm7FYVALf8go9yilwPgtCiPr2/V3muY=
X-Received: by 2002:a5e:8e4c:: with SMTP id r12mr3089863ioo.119.1581702203932;
 Fri, 14 Feb 2020 09:43:23 -0800 (PST)
MIME-Version: 1.0
References: <20200214143035.607115-1-e.velu@criteo.com>
In-Reply-To: <20200214143035.607115-1-e.velu@criteo.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 14 Feb 2020 09:43:13 -0800
Message-ID: <CALMp9eSdOz4NMHEM_J1V3PiyTsivPG3AJ-NX1CTvyxF_uJFaAQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
To:     Erwan Velu <erwanaliasr1@gmail.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 6:33 AM Erwan Velu <erwanaliasr1@gmail.com> wrote:
>
> The current behavior is to print a "disabled by bios" message per CPU thread.
> As modern CPUs can have up to 64 cores, 128 on a dual socket, and turns this
> printk to be a pretty noisy by showing up to 256 times the same line in a row.
>
> This patch offer to only print the message once per host considering the BIOS will
> disabled the feature for all sockets/cores at once and not on a per core basis.

That's quite an assumption you're making. I guess I've seen more
broken BIOSes than you have. :-) Still, I would rather see the message
just once--perhaps with an additional warning if all logical
processors aren't in agreement.
