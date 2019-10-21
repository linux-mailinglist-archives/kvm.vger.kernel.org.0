Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05C8DF839
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 00:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbfJUWuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 18:50:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38592 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbfJUWuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 18:50:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id o25so10379521qtr.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gfF1ioU7EczSu/q1Wum/fmOHdZe3H+HZ7s6mXORUq+M=;
        b=eH+NvA/bRaAoD9Qq4o93iZZNRNszkl0dvMIGOahIAu4G+dL3RCRm0Ixa0bgcE3Tty2
         7pb4XbgPcAOgEe0HGM+LVph0BrSEo3trBUqBVf+7VSbhSlJpRg///diViKYdSEhW3UT5
         6+3yG656PtXFSgxEMqxWXEHX/m2OI1sCAh6gBHDx1BL6eNjIUCDOc0eCzdQLNq8fqmcv
         pxHH6PAi1/86vg4W+IuSmU+ln7hWAK0WoUQ3W7H/41UUh5KUgOUbtzbxXELAm9UFdSAZ
         zwVo5l5Y8IBXZOFM24gx4f/4FXtN/aNWhA7TbnD2EIekJqUKf2gjnPU2VENT7BcXoPWS
         atLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gfF1ioU7EczSu/q1Wum/fmOHdZe3H+HZ7s6mXORUq+M=;
        b=ZFewAOXUygyDDQfqa4O0P3phDOKqHgPawuhDEB9cIrCo1bk4GFIBTP7LKIuwfDP7pz
         GwKLUVm2gCcdkHWrmsptfcxwaVDZ8W1TPlPVM1eVAS1qB+e3pTgEx82V6axLZW/EeMmv
         4Qvd8+wJSKVvpHFEmkdH6VUS6xZoolHMUlemMUZkM0t4fwUJpGA3VHg8KTrdsP2gFhov
         58juFOLMLlJROtMO3qBlbVwHrfBPdDfOgrJ82KmEjgBW5Cg3HRr8mCQHuhScMhgHq7zU
         cjKqapbiYtIS3hfWBuT3JmoRrizqE/yM5FzWzARKoaJtXO3QxZJdFE1bWjHkCYqAcemx
         L49w==
X-Gm-Message-State: APjAAAXMA541OuLkRuxPsF4ROquJJx9COO83n92MARBT4ek7pk3Ya9pZ
        s8mt1DII9tIrw+/xJiVwc85sMjpXM+E=
X-Google-Smtp-Source: APXvYqzYPuEbzSj63HBanLAlAg+M+79k6CvKc3gr5PikEUKEbeiaEKGFJkhnso/4FzFx01BnIPiPDQ==
X-Received: by 2002:ad4:480e:: with SMTP id g14mr108405qvy.39.1571698213484;
        Mon, 21 Oct 2019 15:50:13 -0700 (PDT)
Received: from u3c3f5cfe23135f.sea.amazon.com (54-240-196-171.amazon.com. [54.240.196.171])
        by smtp.googlemail.com with ESMTPSA id t127sm6929409qke.133.2019.10.21.15.50.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Oct 2019 15:50:12 -0700 (PDT)
Message-ID: <34e212a851eb0d490fad49f8b712b2c6e652db76.camel@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Skip pv ipi test if hcall not
 available
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com
Date:   Mon, 21 Oct 2019 15:50:11 -0700
In-Reply-To: <87pniu0zcw.fsf@vitty.brq.redhat.com>
References: <20191017235036.25624-1-sjitindarsingh@gmail.com>
         <87pniu0zcw.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, 2019-10-18 at 18:53 +0200, Vitaly Kuznetsov wrote:
> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> 
> > From: Suraj Jitindar Singh <surajjs@amazon.com>
> > 
> > The test in x86/apic.c named test_pv_ipi is used to test for a
> > kernel
> > bug where a guest making the hcall KVM_HC_SEND_IPI can trigger an
> > out of
> > bounds access.
> > 
> > If the host doesn't implement this hcall then the out of bounds
> > access
> > cannot be triggered.
> > 
> > Detect the case where the host doesn't implement the
> > KVM_HC_SEND_IPI
> > hcall and skip the test when this is the case, as the test doesn't
> > apply.
> > 
> > Output without patch:
> > FAIL: PV IPIs testing
> > 
> > With patch:
> > SKIP: PV IPIs testing: h-call not available
> > 
> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > ---
> >  x86/apic.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/x86/apic.c b/x86/apic.c
> > index eb785c4..bd44b54 100644
> > --- a/x86/apic.c
> > +++ b/x86/apic.c
> > @@ -8,6 +8,8 @@
> >  #include "atomic.h"
> >  #include "fwcfg.h"
> >  
> > +#include <linux/kvm_para.h>
> > +
> >  #define MAX_TPR			0xf
> >  
> >  static void test_lapic_existence(void)
> > @@ -638,6 +640,15 @@ static void test_pv_ipi(void)
> >      unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 =
> > 0x0;
> >  
> >      asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI),
> > "b"(a0), "c"(a1), "d"(a2), "S"(a3));
> > +    /*
> > +     * Detect the case where the hcall is not implemented by the
> > hypervisor and
> > +     * skip this test if this is the case. Is the hcall isn't
> > implemented then
> > +     * the bug that this test is trying to catch can't be
> > triggered.
> > +     */
> > +    if (ret == -KVM_ENOSYS) {
> > +	    report_skip("PV IPIs testing: h-call not available");
> > +	    return;
> > +    }
> >      report("PV IPIs testing", !ret);
> >  }
> 
> Should we be checking CPUID bit (KVM_FEATURE_PV_SEND_IPI) instead?
> 

That's also an option. It will produce the same result.

Would that be the preferred approach or is the method used in the
current patch ok?

