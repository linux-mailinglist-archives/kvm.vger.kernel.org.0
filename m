Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4EA23AE4B
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHCUjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 16:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgHCUjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 16:39:21 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7361C06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 13:39:20 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i138so26366233ild.9
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6R79EeWfuMX2SKWM8s4lyDqTNhR1QURGNSA573rE960=;
        b=hJ0u66ugudRL0ww7sVT/3vMwO4DsBtF/r/uJLoJaquJCJOmCfkAF+HKSjgftI4ORmn
         UFnrpUM2hTz4vW1o/LHfOjzXE+3FK4On4PbT0sKdFoxwVBNbZOFN+JM0h3ePxeV2vH5O
         We6OFnLMC1Fmj8zi927xXuVrSgP/xRMZjT4rkjS1nehgUNp9MUt6TsJFg8MTfLUi7eOc
         J2OMRB+rE+1TRuV5MR00cOehIFGdktGdF+mOhbNUpi+wk2j2SkdfDGIFeFZnC2mn2OQ+
         fRFRZ2TH6xQsfrV/D5e+SJ1y8oFRAhChYLDACrJPA7DqQHlW0TefTtxKrYb/WbNXCe00
         +gUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6R79EeWfuMX2SKWM8s4lyDqTNhR1QURGNSA573rE960=;
        b=CQ89zWgnTw2tHB0rUQoUUC7D6DM+LsMf3M0n7e2rvxVFXKupoElJQMV9sSJpBP1W+y
         UpjOgTmo/w04z7vpwCskycQhVpN3TD5cplC0FNzZ/7ure/Fw/mcSR7ikV6Qgq+cKMFax
         m88ThWApD+3j0jNdv5Q9xM3ClUeTA3PVp/ATIYYmjQt2XrTpPfzpFCxAcCbrUWe4Lxm8
         UVRvRsur+ChmE6o4JuvMGTSoijgSz/upH4bT3GA3SFsg09OC8CgXheu3OrgMJvv/Opgz
         aIZlRu084XQ3oBZp7cwIu5H7uPZcQZMYOLwiI0ZWiI+Txlq3XanMknRchi412Rwfvseo
         T5/A==
X-Gm-Message-State: AOAM533opnrlFYP7mgOyD0Egyf29Im7JlK1g8xN7Zrsbec1A1DZBNBxP
        DJexx5W1j2jQ4uTDqj+7A3VOthXmMq6LL1KBGUaDala5
X-Google-Smtp-Source: ABdhPJzXYjWKM+ac9bE5OByzfVxB3CEvlf1ckAvtqvArYqhX3KWuszfR7NTjOYZoUzv3qGMnjzAd1X3L/j1txt/Jo4A=
X-Received: by 2002:a92:7a0e:: with SMTP id v14mr1284758ilc.296.1596487160058;
 Mon, 03 Aug 2020 13:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <bug-208767-28872@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 3 Aug 2020 13:39:09 -0700
Message-ID: <CALMp9eRNYG+wO4CEZwnK-f0s7NmvcWhqHhSKn-Pbaf7Uxxi9KQ@mail.gmail.com>
Subject: Re: [Bug 208767] New: kernel stack overflow due to Lazy update IOAPIC
 on an x86_64 *host*, when gpu is passthrough to macos guest vm
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 2, 2020 at 2:01 AM <bugzilla-daemon@bugzilla.kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=208767
>
>             Bug ID: 208767
>            Summary: kernel stack overflow due to Lazy update IOAPIC on an
>                     x86_64 *host*, when gpu is passthrough to macos guest
>                     vm
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.6 up to and including 5.7
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: yaweb@mail.bg
>         Regression: No
>
> I have fedora 32 host with latest kernel on a double xeon v5 2630 workstation
> asus board and few vm with assigned gpus to them (linux windows and macos).

I didn't think the Mac OS X license agreement permitted running it on
non-Apple hardware. Has this changed?
