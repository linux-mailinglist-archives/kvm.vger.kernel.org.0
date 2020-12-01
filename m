Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2379B2CA1BC
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgLALo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbgLALo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 06:44:56 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBADC0613CF
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 03:44:10 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so2874351ejb.1
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 03:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/8WbJ0QbX7L8X+aJDfplrJPO+Eempayk1gs8oZ+WVk=;
        b=Sw/i1lI80YpfVf5jJookAHX9tzW2PescyXTPe+nKi5EW8D9BIeXbhcCkQAUKTH2Dyu
         /UfbOzwvKDAthAjZHfbV5MuzZaFb6jtEfFpLNV1GEv7M9OE8wDJaWVfb8jqNBNNsEc5H
         wtrJryXXEo1Z1z1SfuH0tWaJRVzgYTdbepIGqr+HpBpETHsoLG1d0ua6k5EAnIwttGYW
         m5xO3VUwb3RBNwpxu+WpMdytxIq2Ua37iB60JrDwBzaNpbtdU00iVMh6L3Tgji0NA+5i
         yVw4V+A4TSRudg8RdaaakyHIA/hKyU7vCIUqdR6xsq0n6Omo7oQZMYLz3pzI8ugq3K1q
         p6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/8WbJ0QbX7L8X+aJDfplrJPO+Eempayk1gs8oZ+WVk=;
        b=r5f6MlZU8kOKS2Vaf33yhJzoF2PDNWmPblwcqTu/JfCVng9d5u+b5itPkjGL29kJnL
         KEmcfiT0dZi86x+lbKXXDipTBN1EG7FSNG6A0NMC1kydEKMoly+0qgK4KK9C6mTl/9CL
         6TzUoVq6cV+gCe+CvzgceqOCuYBTVyoKBH9i3aaUD7iTGEAuREwEWUEqeaTWOSOQO7dA
         41xtVm36DXv7I0sJDmOp9iMBNMaW1BW9pOBThyHUwfhDyBP8YXIB/06amX0KoqUMb47u
         p0OEVWUMrTwbmBix0MVYs82xt4zqpH9m1bmQdiUeTDQAULD7UQPxELHj893p9CZiMF/E
         j6dQ==
X-Gm-Message-State: AOAM5324NDCmnw70Ko+kTw4nylbofuGmo8NO1Uvi1ozG+LG3B8aucsCC
        5qpmOCeWu0gn4xacAHXovxiROayTXy85VRUJFL83bg==
X-Google-Smtp-Source: ABdhPJyuEDp2HeovEehyEAmUd/CclFSMhRjl70vCjfOMMoQYnYue98WSFIhAk5aIymDYvnEwXVuAPF0Dm8MaH7tvnyU=
X-Received: by 2002:a17:906:2741:: with SMTP id a1mr2566040ejd.85.1606823049365;
 Tue, 01 Dec 2020 03:44:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
In-Reply-To: <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 11:43:58 +0000
Message-ID: <CAFEAcA8eiyzUbHXQip1sT_TrT+Mfv-WG8cSMmM-w_eOFShAMzQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] memattrs: add debug attribute
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 at 19:28, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as
> general indicator that operation was triggered by the debugger.
>
> A subsequent patch will set the debug=1 when issuing a memory access
> from the gdbstub or HMP commands. This is a prerequisite to support
> debugging an encrypted guest. When a request with debug=1 is seen, the
> encryption APIs will be used to access the guest memory.

So, what counts as "debug" here, and why are debug requests
special? If "debug=1" means "can actually get at the guest memory",
why wouldn't every device model want to use it?

thanks
-- PMM
