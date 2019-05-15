Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10571E6BB
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 03:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfEOBl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 21:41:27 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39546 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEOBl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 21:41:27 -0400
Received: by mail-ot1-f68.google.com with SMTP id r7so753775otn.6;
        Tue, 14 May 2019 18:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J2mfwiE6nx3Yy6yAluRr22vHBggLySihK+ARf9SxdE8=;
        b=XKfP8DVZvjhInKSfi8Kk/88EGsjrYsfBjJKu4yYbwZtK2aRITQLSDpteGVOd59LAjK
         ZhLB4wvy5yZ2QHAOl+OsJjgDdkNMlLGfqmT+Zdd6ejrgkmqiNHO5RCaplpLfWp82ibf2
         Blqke4faM/UCbg0QNZbxtUL9WCfQkcxHkDHWdcY4fnrl7m1Dg2GDDpfp/9kDr/EfpDcZ
         ZUplK3AE4wj9Hz2VoBJ80uJaEQ7qaz1HR2Zv6vocmLuEZNXEJxFzi4MtNKL9RJlYuI7s
         t9E2Q7IuQkUkiPNs1n9em9Z4RK3hiD7sDfXF4Lt/45tIrrBURZeiC22BSDF5T+3zHrSJ
         8Mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J2mfwiE6nx3Yy6yAluRr22vHBggLySihK+ARf9SxdE8=;
        b=inXYkkgmu6WgNttBqnK9C4bIEyn2wuA7BsyD5iSjte92iFQd/gMuv7tNDmZl+kg5zI
         sfXVF8y3jwxTFgYI2/bmUfDo97bBL40roASLnB0RA4tu696xYq9P7AarGcmG5xycvd/X
         sLFpAk49C+tWKSt418TIvCBlAqburtJ3ImAEHd/Cr3qMtzj83PJgulB5KfbxXrljP+Xk
         YqG679LWzXuSXCRaAsC7DGabQ4zLNUR38qCutQZbgaoXaJ2EV7OKL09W47Xh1QleS9fd
         /e1V1FTQnNasH+2D2poY5oBVXNHODA4RuzsZVwPe0G71qrSHA7HELum9DBOiNBVNeOU4
         7mJg==
X-Gm-Message-State: APjAAAWmtwwuZzNZWLS0DAI+85xfdWrbdo/SdAzkOwi7vVbA9GDB4GTl
        pb+QAdvJ94Yv+m7460eRLnaW5qUvTbjwuLcY9AI=
X-Google-Smtp-Source: APXvYqwaKB2X66f/xf6bS1GuerYjrcGs9dfqgsW8d6lqy9wsrgS5/zG9giodZgzfFSFgquA5LsaE/wm+fAm52LBJpa4=
X-Received: by 2002:a9d:588b:: with SMTP id x11mr20086510otg.295.1557884486465;
 Tue, 14 May 2019 18:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190507185647.GA29409@amt.cnet> <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet> <20190514152015.GM20906@char.us.oracle.com> <20190514174235.GA12269@amt.cnet>
In-Reply-To: <20190514174235.GA12269@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 15 May 2019 09:42:48 +0800
Message-ID: <CANRm+CytV7PfS++RnYU0P3HT_QBufrO=bzd6Fx-7dC2=sotvmA@mail.gmail.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 at 02:20, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Tue, May 14, 2019 at 11:20:15AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, May 14, 2019 at 10:50:23AM -0300, Marcelo Tosatti wrote:
> > > On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> > > > On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > >
> > > > >
> > > > > Certain workloads perform poorly on KVM compared to baremetal
> > > > > due to baremetal's ability to perform mwait on NEED_RESCHED
> > > > > bit of task flags (therefore skipping the IPI).
> > > >
> > > > KVM supports expose mwait to the guest, if it can solve this?
> > > >
> > > > Regards,
> > > > Wanpeng Li
> > >
> > > Unfortunately mwait in guest is not feasible (uncompatible with multiple
> > > guests). Checking whether a paravirt solution is possible.
> >
> > There is the obvious problem with that the guest can be malicious and
> > provide via the paravirt solution bogus data. That is it expose 0% CPU
> > usage but in reality be mining and using 100%.
>
> The idea is to have a hypercall for the guest to perform the
> need_resched=1 bit set. It can only hurt itself.

This lets me recall the patchset from aliyun
https://lkml.org/lkml/2017/6/22/296 They poll after
__current_set_polling() in do_idle() so avoid this hypercall I think.
Btw, do you get SAP HANA by 5-10% bonus even if adaptive halt-polling
is enabled?

Regards,
Wanpeng Li
