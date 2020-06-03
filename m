Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFE31ED4C9
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 19:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgFCROY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 13:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCROX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 13:14:23 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73477C08C5C0;
        Wed,  3 Jun 2020 10:14:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d5so3105446ios.9;
        Wed, 03 Jun 2020 10:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1fN4KADaSCEVr+fi2VR4+YYdyW02dzdqKarwAuE5JM=;
        b=Db0LhHXVPJ1WDh4jiINB0XFaVbDBzWenltsB/4/hA7fJZ6Hr8v0Xht83c3199T1yxi
         wj6zyxjnOytfhPMMJoqYDdWPXy13gaAApB9OAijKtHKZiI2X6rX0gFcT05L+2PIc7wEg
         sAuGgs0Oi2thTotzd7Kz3DVQyVc8wOdDv9YLmxxRVFSbxdfo00cEj51yRXyPEQgVNuyt
         iyg2XZsVkEYuK83zco2OpPkPFOjgxshuaW61s4O6ttmYKWrMzjenifBmbDHToXgSUmod
         ZOa0ddWhfLP1JZosxFIKMvhxA97FHlf/ANjJkOFh5wPRfryMd9a0NPvJSIsP4dsX+tUB
         NhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1fN4KADaSCEVr+fi2VR4+YYdyW02dzdqKarwAuE5JM=;
        b=BZCJNKcCFrQMpxHIv9ih39Jy616RSiG99ggmG5p08bjNCxemRKr2uXnzK2mg4Dendz
         ijV2ymCTiVPk7Sj7VzJ9m5er4nTmPJME0eDbuMqUIAV2HNdNPTryJX2VsNYgrkb3SIOm
         oXDxZ+gewz7vRujmA1F6KlrIIPsCWLyDpBBO0WtwOx66qnBN57YeHj/ANTpOi6uhnqpL
         QRgFBrYKmoUK3AII8nuQMuaqY00OH2js5nynIcqRHhrtKGf5ff5Dluynds8pVNLsctWB
         ZIeDFdp+2S2BRcBEoC3X8AoK2u0b/9TE3593dr0FOYegX5GAPzLi9xBgjE16m330vg70
         Uzvw==
X-Gm-Message-State: AOAM533jrY6mBM89GspVoLSIcjln40p6+McWlE24kfSuOr1oitHmiQkc
        fbNlNxyLo8nW7Iy8VsdTvv6H/d6HkijI/sVl5g==
X-Google-Smtp-Source: ABdhPJwjZZNidpPXbWcqeOMttWh4MrMd0WNuRBvM2NVR4bh1JG/Y8s7Xe8ro/oDnN+4cwCNlt5lqXFhGvn0iRNhKMj8=
X-Received: by 2002:a6b:fc0d:: with SMTP id r13mr715961ioh.40.1591204462837;
 Wed, 03 Jun 2020 10:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200428151725.31091-1-joro@8bytes.org> <20200428151725.31091-36-joro@8bytes.org>
 <CAMzpN2gfiBAeCV_1+9ogh42bMMuDW=qdwd7dYp49-=zY3kzBaA@mail.gmail.com> <20200603151857.GC23071@8bytes.org>
In-Reply-To: <20200603151857.GC23071@8bytes.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Wed, 3 Jun 2020 13:14:11 -0400
Message-ID: <CAMzpN2j4t7UwOFwSR8gVo-FpAQ_RS5pE1c8JZns3xyUXP3yANQ@mail.gmail.com>
Subject: Re: [PATCH v3 35/75] x86/head/64: Build k/head64.c with -fno-stack-protector
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 3, 2020 at 11:18 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> On Tue, May 19, 2020 at 09:58:18AM -0400, Brian Gerst wrote:
> > On Tue, Apr 28, 2020 at 11:28 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> > The proper fix would be to initialize MSR_GS_BASE earlier.
>
> That'll mean to initialize it two times during boot, as the first C
> function with stack-protection is called before the kernel switches to
> its high addresses (early_idt_setup call-path). But okay, I can do that.

Good point.  Since this is boot code which isn't subject to stack
smashing attacks, disabling stack protector is probably the simpler
option.

--
Brian Gerst
