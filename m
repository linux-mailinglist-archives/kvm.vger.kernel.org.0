Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8E655DB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGKLlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:41:10 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:46908 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbfGKLlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:41:09 -0400
Received: by mail-ot1-f48.google.com with SMTP id z23so5475742ote.13
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 04:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6/ihvuG+Zz2knpTKa3HCbLWQcxpbQDC96GCD7P4u6Y0=;
        b=CEqSRnHZMl5hYYkCLLgBtdldODBB3zkXuQ6Yh6KWtkBeLP7DZ0TS16tCkKh0zMkNx7
         Un4T4+EpPmz9AnnF+WxFm5fZiHXBFS9E6ibSyI6SEgxMljKWIfGPPw3DPV/9aPsKDPIY
         /Li4JFIA7eb6R4Vf8yVS2ni4/lpQFo0wslGfgWPy9lYAtRTo8AQ9Hq/OIydJW6wXe7Nu
         KcbX+M+KhIVkrsDkCXNn1+n0P2LYyEKkSA/uTh5XlaV2lJhlJIRspUliFdYfloMK381W
         kLRWc++ZLRTDVPT3EDd0ufPxNa5UA3xu5wCAafEquwuU0+DpIXZ1zbXrfEfPBas0pjRJ
         GuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6/ihvuG+Zz2knpTKa3HCbLWQcxpbQDC96GCD7P4u6Y0=;
        b=rLtMweRf1uuvEo2+uQ/M2KnlJzUPRuv1CvTnb5K7MSZWOe+2kA65ssWgb+4FFAtrJd
         Xt+CEH7OwP73KmFj/ntCLts88rV5Qve7Uq2co0yURrycinGOwqCzAgmBpCTFKDdbGimy
         wPNu/ThuJw/RernM/EEca4jKKX5mZyUC1nD/KPzMjUgrXckTnl+aWwOY+FSemht5Ny8b
         3fH1uTDE2JSoOBpY2TvXpjPQ+5xxEOWZGT6DmGMlDXxFjr73rG4dTT719C8pZ0Wguvbe
         TX+ozfflHy64sCv1s1Gy/63HT0bhmWRqvY5LMXh0NOaerw98MoDxZb1gJrUx2Wfcr8QV
         HENg==
X-Gm-Message-State: APjAAAU3tbNc/3x9aXi+xFFrQX7C1FW2v9rp5yyJBjOnfQUq3v8lo1Xx
        dSIACZUZ1tf6k5V4tVaEylnSb++968WKNcYOGMS+n3SM4SQ=
X-Google-Smtp-Source: APXvYqy0Tb678D01LSWx+o+6Zw78Scs1IqJfTLAPAlqUyks2As5G9ZCR+avslPTzavnk/DdVd5BXCoKYr+hhEZpqOAY=
X-Received: by 2002:a9d:4d81:: with SMTP id u1mr2847957otk.221.1562845268790;
 Thu, 11 Jul 2019 04:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190711104412.31233-1-quintela@redhat.com> <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com>
 <20190711113404.GK3971@work-vm>
In-Reply-To: <20190711113404.GK3971@work-vm>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 11 Jul 2019 12:40:57 +0100
Message-ID: <CAFEAcA_6-F_8OhX4vw7m1sCPrEZfeVjGP25=Cz7nGJOHSXy1kQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 at 12:34, Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Paolo Bonzini (pbonzini@redhat.com) wrote:
> > On 11/07/19 12:43, Juan Quintela wrote:
> > > The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
> > >
> > >   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://github.com/juanquintela/qemu.git tags/migration-pull-request
> > >
> > > for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
> > >
> > >   migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)
> >
> > Aren't we in hard freeze already?
>
> They were all sent and review-by long before the freeze.
> This pull got stuck though; the original version of the pull was also
> sent before the freeze but some stuff has got added.

This is the sort of detail which it's useful to include in
the pull request cover letter...

thanks
-- PMM
