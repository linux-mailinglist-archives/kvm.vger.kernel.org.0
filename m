Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A455965392
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfGKJOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 05:14:09 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33409 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbfGKJOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 05:14:09 -0400
Received: by mail-oi1-f193.google.com with SMTP id u15so3957700oiv.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 02:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEZG43r6RWPqN4gSL/BMuAlx0Ls8cNhdW0tYLDnHU8A=;
        b=Zv+KUbRkxwDNfleJFVK3oTMNs+Ze4+tknfaP0s/vKQbHstBLp8Kt9h2lUWkuBVeDZq
         kqWrEo3Pw+hajDCbmhJixJFHWsKh3NJ1nfS0+yF9zZzZUT4isdT0hlyjtQsxfJ/FuCWF
         vwzoxorUfH+yRc3JH3QpKUdQK85PlIWLSNGFYo10e8ZVK+DR0H110bcrtT9nCvUZ1K73
         hfIWm6JqMhp5ehH6f38sqQdOP1kCGeqtdznLScxPNPEehUAEajUQ9tEFUL1GTrCobUkY
         HTZjIcjL8eDVpj3zWKwVgDRZBGlehYIwYrO4jTY7ABzx6yfrUz1ZKCQ2LShDyWS+eKPg
         oYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEZG43r6RWPqN4gSL/BMuAlx0Ls8cNhdW0tYLDnHU8A=;
        b=d85EiDCsKf07IShdvfM3D2eOlnaYCNa72DjQNND5Cusfr81WoSYB+ALDNA8GtFo59H
         QChPvv+osGBwlhHLpLDhGxUCvL3qUAlZ9uBr9Heq3oyXpyXwBbYNRVX7g7oYPi+PnX0K
         y7hM4UB90S/hBWTgShKUD9fdY5Xu+dSyepuirMkQ1mh6EqAW1U5fgJXwS/toXTBmpVJ5
         Tv9VHvHpFa6GrgIsX6fcZZ57lqHqDpATewJe8xGP008nY4ejP064BSQnbEf2bsX8C4/X
         Cr7onBhhsUCoNU5jJR25cxrlEapm77qiS/8UXzuJNe0UgIVM7yrqudSEtN3tyUCp3K14
         zJhA==
X-Gm-Message-State: APjAAAVre6YYDhRdtSPAQqE0y7R9Z/pLkNNK5d6ZcbgyWrvpCtBrxqlV
        6Ka/ICIOcNRvDzDiaF6xa4G+SASbmRVrgvPPDNyhIg==
X-Google-Smtp-Source: APXvYqzQhZHQWC6BrWJ9rVgTKnyu2xj51GbJRtgxsikp+PgoFMpk/4509qrz9K6SAZJgfcpPiLZs6ARrqQFt119+joM=
X-Received: by 2002:aca:6185:: with SMTP id v127mr1833969oib.163.1562836448490;
 Thu, 11 Jul 2019 02:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190710132724.28350-1-graf@amazon.com> <CAFEAcA81mQ780H5EY8uV6AvbXzeZA60eCHoE_n9yzeZgw+ru4w@mail.gmail.com>
 <a29ea772-0565-98cb-61d8-3042b2df39b1@amazon.com>
In-Reply-To: <a29ea772-0565-98cb-61d8-3042b2df39b1@amazon.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 11 Jul 2019 10:13:57 +0100
Message-ID: <CAFEAcA_qRksJGiOZXFss+7Bcuwy97LydQXcw-R=LD7zBTmEm6g@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 at 10:11, Alexander Graf <graf@amazon.com> wrote:
> On 11.07.19 10:51, Peter Maydell wrote:
> > Have you tested this against a real hardware pl031?

> Do you have any pointers to devices I might own that have one?

Heh, fair point. I'd expect to find one in most of the devboards
Arm has shipped over the years, but I dunno if you'll find one
anywhere else.

thanks
-- PMM
