Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B61269C59
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 05:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIODN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgIODNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 23:13:25 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EBC06174A
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 20:13:24 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id g96so1823671otb.12
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 20:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojKPEzvRLUdfYQPqEdOhGlB7fMW+g2bTbo5aBMqgBC4=;
        b=onmt++0FBBdXbvK0mLvoJtNhm3G4nJ8l49q408ljTowQTE0xuuQmV8uY9lpFmDhF+I
         iu8Amq6l9S4TAejFvFRyjiaj2tKRQOEnZy0jQS8l44nwhB0nRQcCDBnpWa4gYMF//VrE
         9nbCH2cXM1gd3Ic6cOWSl4DprVvSvywwGOf0BgaRjwposSN+pDOaC9dsSupEULOUeFUD
         i9dup8qBCmcu9/nY2QqmyZlMne1SqGUjEU2Tzij1khBP44Pr5kY8PHFOSIrJPR7/VAq+
         CVB4TwyIgmVGXc4E/AC2je7XcwkZ3wdiXnPfr24FsV0cuKw1qjhUrLQBm1UKYpGM9wf5
         gwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojKPEzvRLUdfYQPqEdOhGlB7fMW+g2bTbo5aBMqgBC4=;
        b=QeiMeOv/0zMvWyvVvbLT5wzfUya6lZ2z9mHDi8p60o+UTT73RsuCJl/wiZz44uvYw5
         yRA0kU8eaNSRTJgCvlI9y1Yk8fxUFm54SVsdnUIUZwAnnT0gMlWl0IFlT+gkhsJp4r0J
         AOW92uBrFPrwYi3vEeNFqL9bxCqN7lBI0IEI8kRgSK1VCEZ5+75XX44IdJDvNjsIgL1N
         +OlsgqxYUms07/XisZXFm98Rb/VeY2D3Qn9Pwt4T3o8gUvZDPpTLkyV5rHRnYObZD3JB
         ymy2dDSsLB2h2rwFWvQ7/52xBbjPof4bHQh8/ueWJZqYk6CheQ4FUpz+RIqgjJx800nb
         Ykvw==
X-Gm-Message-State: AOAM531uboGkF4iF8gxzU1wX+KlamfmGNPcEyW3/GoNQ0M4/5+7nm/mh
        3nwpsGnz2eYubQVEM3E+63a3xTo3ByIEM5piB20TxWMXPdvSdA==
X-Google-Smtp-Source: ABdhPJxQj42Wc+A+hv02YwSX0ZOxYDY3m35JTLQmnXa48t0uqJFbhRgR1vBN6bavWnOfUYMQ1qOKQwuJS3A8WaGHLqQ=
X-Received: by 2002:a05:6830:18ca:: with SMTP id v10mr11883018ote.295.1600139600846;
 Mon, 14 Sep 2020 20:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
 <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com> <CALMp9eTUT-tsGu0gfVcR8VTcq7aVH87PsegnsbU6TXOoLHkfMA@mail.gmail.com>
In-Reply-To: <CALMp9eTUT-tsGu0gfVcR8VTcq7aVH87PsegnsbU6TXOoLHkfMA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Sep 2020 20:13:09 -0700
Message-ID: <CALMp9eS+Vgo2O5=ApWEYCrDz80QE0E7OQyLYwrEjErXD2+uZUw@mail.gmail.com>
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 5:18 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Sep 11, 2020 at 8:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 31/08/20 23:55, Jim Mattson wrote:
> > > Moreover, older AMD hardware never sets bits 32 or 33 at all.
> >
> > Interesting, I didn't know this.  Is it documented at all?
>
> You'll have to find an old version of the APM. For example, see page
> 56 of http://www.0x04.net/doc/amd/33047.pdf (this was back when SVM
> was a separate document).

Ah ha. It looks like bits 32 and 33 weren't there in version 3.14 of
the APM volume 2 in September 2007. (See
http://application-notes.digchip.com/019/19-44680.pdf, pages 410-411.)
They had appeared by version 3.17 in June 2010. Maybe someone from AMD
can enlighten us. My memory's just not that good.
