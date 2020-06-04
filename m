Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D921EE971
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgFDRbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 13:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgFDRbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 13:31:00 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BADC08C5C0;
        Thu,  4 Jun 2020 10:30:59 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jgthd-0007YA-D9; Thu, 04 Jun 2020 19:30:53 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A9315FFBE0; Thu,  4 Jun 2020 19:30:52 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: system time goes weird in kvm guest after host suspend/resume
In-Reply-To: <87pnagf912.fsf@nanos.tec.linutronix.de>
Date:   Thu, 04 Jun 2020 19:30:52 +0200
Message-ID: <87367a91rn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Miklos,

Thomas Gleixner <tglx@linutronix.de> writes:
>> Of course this does not reproduce here. What kind of host is this
>> running on? Can you provide a full demsg of the host please from boot to
>> post resume?
>
> Plus /proc/cpuinfo please (one CPU is sufficient)

thanks for providing the data. Unfortunately not really helpful. The
host has a non-stop TSC and the dmesg does not contain anything which
sheds light on this.

I grabbed a similar machine, installed a guest with 5.7 kernel and I'm
still unable to reproduce. No idea yet how to get down to the real root
cause of this.

Thanks,

        tglx


