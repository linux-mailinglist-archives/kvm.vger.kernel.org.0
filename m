Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDDD1ADFB9
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgDQOYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgDQOYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 10:24:39 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F20C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 07:24:38 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id z17so1553810oto.4
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 07:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bINL+whMY8JUFNkL3EiY+3GJ5yVCYEGHi/PyCcCo5+k=;
        b=ti9Tqq+xRiQSWOwWxj9UiETP/8S5aSWAzJtPZGbwp13sUdiugCAYbDNg4qDfP2L8kt
         KmgoOP1EvbVb2qC23VbUoqiuoJlFtXf1IeIJAvqcGaJ9aj2cVMHJWBzna/o+A2lyaM+D
         Xy8xZVYie4n0Xi8VIzZly8CXlsByG44AsvHodxnXIrJHHeYKayPWK5l+5iVH+DeV11mp
         mm6qKLsQwp0M2ivD9rRfo+AJDn2ycxxyfXX5/K9dEk6W87HtZKKLH62gtYUtQHsK3ZEk
         qtOufeaXyvVOUB0N+eOhQqKG3tWGkB26G/mnYiPp6/cyGoVo1Xd/Bwq5cEaZqmj7ugJ3
         2bTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bINL+whMY8JUFNkL3EiY+3GJ5yVCYEGHi/PyCcCo5+k=;
        b=Q+1+F2JgvtTgpcYc+dNjVTZ+p86DcRZskyL3TiSI+P6v/gG99zE1FbTNuDOD8JuFFl
         l2zpsB5zoT/l8YjW2wUdoe6i/ZzNtI190aw8fNK2VhLrjfKQ8ijBgjqAurBpVm91a4q1
         /vIQSdOYyIt85gbJh/7JIzItFz/9txJOK5znB/0TXpBWf5Gxjo0xFHyXconY8Nj+/vDR
         q7CCzZ+gbQiJWJdH2Znd6RL3NHq6TPwTcNHclJgtSDxiJxluxhP+TkjlP6oGOwS92NU1
         wwTdCzFX1s4Ie12amDu1GNHJ7WJaLJggzBDTk4HtkAnpJiWmqxa1sICq1s4b6xcq+c8X
         B1Mw==
X-Gm-Message-State: AGi0Pua/2PEmB5y1U2TEYQTgyPEMbdQUMwojEQtqmse8eiccDugemwKm
        QwxXiApvliHVp1S+us+HTunmctxhoeE2/ErmM9ShFInR5N2xbQ==
X-Google-Smtp-Source: APiQypJpUD2IU+gWxhauJfjP3/9GfO2pNn3i5Xg4of5Pd0BY0W3WBFVh2xfJeJThB9c+RV8vwtMhU7lGMJ+qioXhUz4=
X-Received: by 2002:a05:6830:22dc:: with SMTP id q28mr2594814otc.221.1587133477203;
 Fri, 17 Apr 2020 07:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200316160634.3386-1-philmd@redhat.com> <20200316160634.3386-4-philmd@redhat.com>
 <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org> <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
 <5d9606c9-f812-f629-e03f-d72ddbce05ee@redhat.com> <CAFEAcA-4+Jcfxc5dax8exV+kBJKYEnWZ2d-V1A6sm6uJafZdPg@mail.gmail.com>
 <16bd73d1-ec39-7da6-77c3-a18eea5992e0@redhat.com>
In-Reply-To: <16bd73d1-ec39-7da6-77c3-a18eea5992e0@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 17 Apr 2020 15:24:25 +0100
Message-ID: <CAFEAcA_1F2hpYp9TkKRGKgjQ7kjJ787s4Wr_6P+7fGBKeAwZPQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 at 15:19, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> On 4/17/20 3:54 PM, Peter Maydell wrote:
> > Your suggested patch isn't quite the same as RTH's suggestion,
> > because it puts the assert inside a stub probe_read()
> > implementation rather than having the ifdef at the level
> > of the writefn body. I have no opinion on whether one or
> > the other of these is preferable.
>
> I'll let Richard modify the writefn() bodies if required, as he
> understand what they do :)

RTH is suggesting

static void dccvap_writefn(CPUARMState *env, const ARMCPRegInfo *opaque,
                          uint64_t value)
{
#ifdef CONFIG_TCG
    entire current body of function goes here
#else
    g_assert_not_reached();
#endif
}

If we take that approach then the stub probe_read() would
be pointless, so we should do one or the other, not both.

> Btw since we have this rule:
>
> obj-$(call lnot,$(CONFIG_TCG))  +=3D tcg-stub.o
>
> I'll use the following patch which is less intrusive:

This is temptingly less ifdeffery, certainly

-- PMM
