Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6803C17613D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgCBRkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:40:40 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33550 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgCBRkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:40:40 -0500
Received: by mail-il1-f196.google.com with SMTP id r4so270672iln.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 09:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ksD8dmttNXm4+inhvFStNZSPi/gQ9lBZA/qTTCxdeU=;
        b=mSqxHJ2+c/jBWiHLSWxaAbxahVU8ObgqQnRzD9e6LBPbhAHMZ4bPULCRAR6ndafm20
         2Taqrg/JYOqyRD0HzS90xaZOy/OFkea4vTJe8DzSw1Zrt/Ppdti446gVt/iOb3KQpAcW
         u0N+FH8rE/dDGCmq55dntIkGRQVKcZAyyhp1OyD4OTs1XVMLO5YKA+c2w3Fi1zqXoyDC
         qyidBtduQydYw/Nxmj1YXeCh2Dw4ey9ziw3DEZnUvqEyEMb2vLIsjinZeOAqiVf8Wpv6
         9hnuUed26pUQx0eIj6Xmar94z7Ej4pXzcd/LOusYwMimGeDhVwPxotAVTLUE39ApvZMu
         mfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ksD8dmttNXm4+inhvFStNZSPi/gQ9lBZA/qTTCxdeU=;
        b=ttO2blDRMSMreYbbfVkuSp0rr6LQQjaT7aQzvRh7Em4D/Bo5oTdjaDqcmtun+jilXv
         GPw9vrJ4CjWYQn83+BjNelGUi4Gx7hB1g3uM1ZS5l2A6gKPL6x5WExZnpqdgRams+8Su
         B/iFsEurMPfNcyWC7o2E4C/Yevacp3HFo1iCKJZc0mYejCFRNQqMvm8GbymeKkGDdiBC
         Yv0Y90jcrGtb1U0ZI5nJpokwo2L+rUljV6Kmc2W5LCcOnf13VAXORKXE3UwXAQ+ouJFY
         WLMtXuADrcxevp3BDXEHztL25wagd/kG+yp5c0ajJpxlr6G1V6Cm7Hd/xC9ii166gED1
         lrzg==
X-Gm-Message-State: ANhLgQ2lkTRTtYvomuEfEs1EV/nttkAi6uWlwceQZTiqFqtG9dthfyPR
        2Uoubfou4GX9p8QjwIYKTfpTe8cCMkHGXCdsbywVvQ==
X-Google-Smtp-Source: ADFU+vtji4jtuFdVSISD0TFeUATVqU3fVoefcW5GeZgC7PFacB7z75v4J0ttrcpRHzD+QT18Ayt7hrQtMbDwPNUkX0I=
X-Received: by 2002:a92:c510:: with SMTP id r16mr681031ilg.119.1583170839039;
 Mon, 02 Mar 2020 09:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20200228085905.22495-1-oupton@google.com> <20200228085905.22495-2-oupton@google.com>
 <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com> <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
In-Reply-To: <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 09:40:28 -0800
Message-ID: <CALMp9eTj2ypUjpa-9FU_Pz1KdgvDSa_AVqbkOgUErUC5oJJWWg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Wei Huang <whuang2@amd.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 2:47 PM Wei Huang <whuang2@amd.com> wrote:

> I personally don't suggest enable AVIC by default. There are cases of
> slow AVIC doorbell delivery, due to delivery path and contention under a
> large number of guest cores.

Under what conditions would you suggest enabling AVIC?
