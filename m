Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE775F98
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 09:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfGZHUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 03:20:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48302 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfGZHUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 03:20:16 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hquWR-00046z-0R; Fri, 26 Jul 2019 09:20:11 +0200
Date:   Fri, 26 Jul 2019 09:20:09 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Wanpeng Li <kernellwp@gmail.com>
cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH] KVM: X86: Use IPI shorthands in kvm guest when support
In-Reply-To: <CANRm+CzTJ6dCv=NSHLGV-uWdaES2F0T7PXgu0LXXEsBCJ8mxEA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1907260917340.1791@nanos.tec.linutronix.de>
References: <1564121417-29375-1-git-send-email-wanpengli@tencent.com> <CANRm+CzTJ6dCv=NSHLGV-uWdaES2F0T7PXgu0LXXEsBCJ8mxEA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Jul 2019, Wanpeng Li wrote:
> On Fri, 26 Jul 2019 at 14:10, Wanpeng Li <kernellwp@gmail.com> wrote:
> >  static void kvm_send_ipi_all(int vector)
> >  {
> > -       __send_ipi_mask(cpu_online_mask, vector);
> > +       if (static_branch_likely(&apic_use_ipi_shorthand))
> > +               orig_apic.send_IPI_allbutself(vector);
> 
> Make a mistake here, just resend the patch.

Please don't use [RESEND] if the patch is different. Use [PATCH v2].

[RESEND] is used when you actually resend an unmodified patch, e.g. when
the first submission was ignored for a longer time.

Thanks,

	tglx
