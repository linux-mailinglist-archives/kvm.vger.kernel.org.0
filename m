Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A0228671
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgGUQtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUQtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:49:06 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AEAC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 09:49:04 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id d17so24834013ljl.3
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 09:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Od+zTycOXgLO8KxOLxcSpm14nyLCP4jZwV8jGWRnKLg=;
        b=lpFuK9OAa+wE2Ulyz7amAwN9pME8grhLmFBJmxuxYbgbyPwDqYiXKVlZRutm696IoP
         CucdkfpNKHu1dC6W5osl2PoysYrfTz7tKtBYUJCzu/VlEh9Xe5pnjhL6A8Cwyk99gIy7
         /fnpKlTDy7dEKz6P6+g8l78OCPsXrP6qVBwQWim0bZpWZ87T1RLAAGbdcvZAgGOdCF/e
         ky3e+cJQeznHXmg0f781bisBn+BB/dgYXYmeLaQp/82EeSVX6mt9LJW/Ss77Xm4nEnwa
         PZNKC7fb+OnbHqgP5oKOtxA45slZ5xFazzEC5V/m4kiZiIMelPi1u1zWTbpxfr2o5W9Q
         JaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Od+zTycOXgLO8KxOLxcSpm14nyLCP4jZwV8jGWRnKLg=;
        b=V1J15kDNRH/q7biXwX37raJnkoXZ9Cnp7fqDx7cPQl1pVhM67NQwZzASy17v1SzZWh
         7YT/dBCOqvVHNTNb7Nfj0rWyT7EPSPM/WQtrWiA6dcmDvjB9JRtCRrpv2U0q8ZqsCfC7
         IuLkk+DUe5REOIl5eFFCVkNm9r8ZknzRsJ9/IN/5qd57K1SXiDAaPC87mIxCj3xr3T+z
         tcYxUC+E1k57IPyidoqTc7cQM3ulzWPlLBHtRtNQBFp/zsa0JFWp2KGfOfTAd5rL3J5s
         1U04NIGNusrUd/9/JufawAwsj0moJA9UAIfanYSnYAYvA3IdOPcOl33VPpHa8j+pzLjO
         QbPw==
X-Gm-Message-State: AOAM5330m+YvsHeU0osSVVe2ESPLatEmTD/RWw8hEtnKKb7+Ue9M06Xl
        XoOTLKt5ArX8BLwyaXe75aeq7B9MEBc5CZRQBZiuTw==
X-Google-Smtp-Source: ABdhPJwYDlDFxMbND8/mrk/EvLJEg1yVZ7yDt8/GKj1m85S0l/2vvZs0Ab4E7ekx1j+8SWGe5O2g2dCiYC100eQoheU=
X-Received: by 2002:a2e:8851:: with SMTP id z17mr13816631ljj.225.1595350143051;
 Tue, 21 Jul 2020 09:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200714120917.11253-1-joro@8bytes.org> <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de> <20200715095556.GI10769@hirez.programming.kicks-ass.net>
 <20200715101034.GM16200@suse.de> <CAAYXXYxJf8sr6fvbZK=t6o_to4Ov_yvZ91Hf6ZqQ-_i-HKO2VA@mail.gmail.com>
 <20200721124957.GD6132@suse.de>
In-Reply-To: <20200721124957.GD6132@suse.de>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Tue, 21 Jul 2020 09:48:51 -0700
Message-ID: <CAAYXXYwVV_g8pGL52W9vxkgdNxg1dNKq_OBsXKZ_QizdXiTx2g@mail.gmail.com>
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

Yes, I am using OVMF with SEV-ES (sev-es-v12 patches applied). I am
running Ubuntu 18.04 distro. My grub target is x86_64-efi. I also
tried installing the grub-efi-amd64 package. In all cases, the grub is
running in 64bit but enters the startup_32 in 32 bit mode. I think
there should be a 32bit #VC handler just something very similar in the
OVMF patches to handle the cpuid when the CPU is still in 32bit mode.
As it is now, it will be a huge problem to support different distro images.
I wonder if I am the only one having this problem.

-Erdem

On Tue, Jul 21, 2020 at 5:50 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi,
>
> On Mon, Jul 20, 2020 at 06:09:19PM -0700, Erdem Aktas wrote:
> > It looks like there is an expectation that the bootloader will start
> > from the 64bit entry point in header_64.S. With the current patch
> > series, it will not boot up if the bootloader jumps to the startup_32
> > entry, which might break some default distro images.
> > What are supported bootloaders and configurations?
> > I am using grub ( 2.02-2ubuntu8.15) and it fails to boot because of
> > this reason. I am not a grub expert, so I would appreciate any
> > pointers on this.
>
> This is right, the only supported boot path is via the 64bit EFI entry
> point. The reason is that SEV-ES requires support in the firmware too,
> and currently only OVMF is supported in that regard. The firmware needs
> to setup the AP jump-table, for example.
>
> Other boot-paths have not been implemented. Booting via startup_32 would
> require exception handling in the 32bit-part of the boot-strap code,
> because verify_cpu is called there. Also an AMD specific MSR can't be
> accessed there because this would #GP on non-AMD/SEV-ES machines and,
> as I said, there is no way yet to handle them.
>
> How did you get into the startup_32 entry-point, do you have an SEV-ES
> BIOS supporting this? If it is really needed it could be implemented at
> a later point.
>
> Regards,
>
>         Joerg
>
