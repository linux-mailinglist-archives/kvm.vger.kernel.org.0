Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37252C3AC
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 11:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfE1J5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 05:57:54 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35526 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfE1J5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 05:57:53 -0400
Received: by mail-oi1-f194.google.com with SMTP id a132so13789981oib.2;
        Tue, 28 May 2019 02:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZxUx9/0XpsNkuHkZIZc8kE57BDMIB0rWqNkkuQgzAg0=;
        b=IYgKoX/xMOL0sUMR9casKcbEw510z1iSIJ2M604fa0u+2PkjidFvyzr1wgsQCDta2j
         InALDsn/ZHKxkpi7G5zWdrd5xgrX2dbuQCdur6fzJKHkmyUmB6HhMxcF7ZKHyZzVnlRk
         OSQRBbeeYG/y8hqK8yztSrFgMPLP99HyMpd4xzA8n70E3k3d/PYwyu10qwqtEOgg//Yr
         xPdd4nudpksd1qmAd9OEUo7I1919bpPfKHls5pwnA6ZAl82WLZzcJTtoQi5jJ36ChfvK
         au4HoT9zkx6O8LBhGeYKrYwAgUTjK7GEgQ1ZEGFWnuhxF3EV5He5k7nesW0gy7WN0F+I
         5RNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZxUx9/0XpsNkuHkZIZc8kE57BDMIB0rWqNkkuQgzAg0=;
        b=oBgwi/56kOJYR7bwLuBlUFQwJvCEd+1vL41oUTHYmMe/jpr9a7TEVjJSU5pHLvc2Mo
         e7VWnL4Gv1vJx3pv3QaYbzPc+1o0AnLfj557K2LxYwaJFCSYhYDNl2tKI7QS71piT3bi
         TNySx3Bs6/3RYURccttN73QKX9FwWq0U/a+A3tw8/df0Y5GHZZ/98DLIT+/DcfAWMGOi
         5mcOkqsoJRGjK9s2ToBmTZtQKFJb6tCkIkwMBiH/n8XFnfw5SSK8rQwxkJhjH0+NDDHU
         lscgnYvWAkEnrdfe+5x9tYONJT/NGO75DZwyPFH4RyZCRNTZgUvu9pneZhTmEYNDeIgk
         axkw==
X-Gm-Message-State: APjAAAVb4jm8c0biN6U4B8jBdVu0p2e21xudALU8q4/DmQ0GwU4MQkdE
        e/1bQYR0/JY6lb7jKRD2W9408d4JkTs85BpT06I=
X-Google-Smtp-Source: APXvYqxaxzDFYV0ejSvXPme9ryOZxi2rqz1XBxiDFyXc1jtbllTKowLDM2c8rHFeB/rdzgMHbqHlLB2QzUL5RBDtd8w=
X-Received: by 2002:aca:b7c1:: with SMTP id h184mr2165646oif.5.1559037473152;
 Tue, 28 May 2019 02:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
 <1559004795-19927-3-git-send-email-wanpengli@tencent.com> <9f3ff1f4-8173-3037-0a3f-a6036076bca5@de.ibm.com>
In-Reply-To: <9f3ff1f4-8173-3037-0a3f-a6036076bca5@de.ibm.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 May 2019 17:57:46 +0800
Message-ID: <CANRm+Cx+Uhy+C4KUCkyhxQ9UPOak4Kwo0JNyxEtZ4vHQHRWmPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Implement PV sched yield hypercall
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 at 17:12, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> On 28.05.19 02:53, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The target vCPUs are in runnable state after vcpu_kick and suitable
> > as a yield target. This patch implements the sched yield hypercall.
> >
> > 17% performace increase of ebizzy benchmark can be observed in an
> > over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush
> > call-function IPI-many since call-function is not easy to be trigged
> > by userspace workload).
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> FWIW, we do have a similar interface in s390.
>
> See arch/s390/kvm/diag.c  __diag_time_slice_end_directed for our implemen=
tation.

Good to know this. :)

Regards,
Wanpeng Li
