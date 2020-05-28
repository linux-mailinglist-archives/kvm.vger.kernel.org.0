Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105101E6CC2
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 22:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407341AbgE1UnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 16:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407321AbgE1UnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 16:43:09 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0460C08C5C6;
        Thu, 28 May 2020 13:43:08 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jePMl-00009i-6f; Thu, 28 May 2020 22:43:03 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A0D11100D01; Thu, 28 May 2020 22:43:02 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: system time goes weird in kvm guest after host suspend/resume
In-Reply-To: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
References: <CAJfpegstNYeseo_C4KOF9Y74qRxr78x2tK-9rTgmYM4CK30nRQ@mail.gmail.com>
Date:   Thu, 28 May 2020 22:43:02 +0200
Message-ID: <875zcfoko9.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:
> Bisected it to:
>
> b95a8a27c300 ("x86/vdso: Use generic VDSO clock mode storage")
>
> The effect observed is that after the host is resumed, the clock in
> the guest is somewhat in the future and is stopped.  I.e. repeated
> date(1) invocations show the same time.

TBH, the bisect does not make any sense at all. It's renaming the
constants and moving the storage space and I just read it line for line
again that the result is equivalent. I'll have a look once the merge
window dust settles a bit.

Thanks,

        tglx




