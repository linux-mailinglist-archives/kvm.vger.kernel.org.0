Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56659B2493
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbfIMRVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 13:21:25 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40315 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbfIMRVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 13:21:24 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so64121671iof.7
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mb7YxE07spFTA7feQS2XwQnnwK7lOnI+PJj6imIp0jE=;
        b=vWJ8NRIGnoEuZqpAm9UihCviqETrG/Xl+LEA6NSp9tYl0XPDpuPV1Gbfv1RghvVjL4
         JqO8XfJHeywECoY/BkXid/kSjfvkQPhwA/kZlHpC5tnucsmbsuMLqZF+RH7PTdvKHt9f
         qTn/NO/J2q5oVpSg4ep/Xr7vCrHVL19SFd6YLXVBBuNS0Wbd0J/IoKlA3+OpYxKUzIXO
         Q1x53Ci9N0nmw5llTkC2+8f0iOIKZpRYVDAJTPOCZi6sKvQjaKkA6nlKEBPnv4vagOoh
         jSGTBuwR+C1vnRXYhDb65vxS4aGyXgqnrbsJXfHEnz0JpSj7g/rHG8l0a7XiyEYfgBFt
         GkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mb7YxE07spFTA7feQS2XwQnnwK7lOnI+PJj6imIp0jE=;
        b=m+jhEioR8sYL7o0ajZkMkaE+aMV+YjQkpUWQq1xiNsIzaBPnXlzOQu0qoqPZl+CX7j
         a5a1i1ftdXE16FgQ9f2bMmAPbHxVDnDxYCOTfdptqYjuWp6Voz4LsurffzOm7ykbmDE9
         3vdRsd6vCLt+MxGl5Fs5HjZPwVkK4XCzokxhSxc2cHoQpkBINdl3UnrXbXDzaQzcounr
         PPbCpaO0vnUAkkYbD/+u3bsqeZrgAwVTpHZJZkOyZfGTDL2voK5DvdeeDxOucn17V7fn
         HwqzDSoiyGTP7NOl1tyKoU5NgXioHyGC2oYYqGrqb/rGcgreUaKROW0Saiy9opnMFwqQ
         OuuA==
X-Gm-Message-State: APjAAAX9pCg0NIb4saqgLc5x/2OmK61V9tyDHwivaRcdKpgLNwieBTW8
        ZExmyx6lcJaFPs868UtCrpENTbwjMGS+o2pqW9F9qw==
X-Google-Smtp-Source: APXvYqz1Q7ke4b1phjxjmxiCTp22bdg60MQ6RLgmsGbR3sDfTOQzPLVtezp6hoB3Msb7cfDZXlkSpZd0uHDuQVvbjPQ=
X-Received: by 2002:a02:ba17:: with SMTP id z23mr4357170jan.24.1568395283748;
 Fri, 13 Sep 2019 10:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190912180928.123660-1-marcorr@google.com> <20190913152442.GC31125@linux.intel.com>
 <CALMp9eQmQ1NKAd8qS9jj5Ff0LWV_UmFLJm4A5knBpzEz=ofirg@mail.gmail.com> <20190913171522.GD31125@linux.intel.com>
In-Reply-To: <20190913171522.GD31125@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 Sep 2019 10:21:12 -0700
Message-ID: <CALMp9eSrEuLGCWj12gD=zjKSL63co-Tf9O0hQApwCj_63dJQoA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 10:15 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 13, 2019 at 09:26:04AM -0700, Jim Mattson wrote:
> > On Fri, Sep 13, 2019 at 8:24 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > This is a misleading name, e.g. it took me quite a while to realize this
> > > is testing only the passing scenario.  For me, "limit test" implies that
> > > it'd be deliberately exceeding the limit, or at least testing both the
> > > passing and failing cases.  I suppose we can't easily test the VMX abort
> > > cases, but we can at least test VM_ENTER_LOAD.
> >
> > It's hard to test for "undefined behavior may result." :-)
>
> Fortune favors the bold?
>
> > One could check to see if the test is running under KVM, and then
> > check for the behavior that Marc's other patch introduces, but even
> > that is implementation-dependent.
>
> Hmm, what if kvm-unit-tests accepts both VM-Enter success and fail as
> passing conditions?  We can at least verify KVM doesn't explode, and if
> VM-Enter fails, that the exit qual is correct.
>
> The SDM state that the max is a recommendation, which leads me to believe
> that bare metal will work just fine if the software exceeds the
> recommended max by an entry or two, but can run into trouble if the list
> is ludicrously big.  There's no way the CPU is tuned so finely that it
> works at N but fails at N+1.

It would have been nice if the hardware designers had seen fit to
architect a hard failure at N+1, but I guess that ship sailed long
ago. :-(
