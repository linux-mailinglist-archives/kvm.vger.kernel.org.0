Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578612E00AD
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgLUTIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 14:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgLUTIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 14:08:15 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1E0C0613D3;
        Mon, 21 Dec 2020 11:07:35 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id n142so9791663qkn.2;
        Mon, 21 Dec 2020 11:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbpsUkSd+e7TcRd395bHWxiDfx2JhrbmRFnL9iD0Fcw=;
        b=V4A2jgjsTtSbL4AIeYrZtfIBmEeLyvlfBpsYIX6S3vpeFDmp2s/WaVynIWbTuW85Lu
         JYcFRu0h2VN2oBwFd+zmqjZ3GnstDOQD+siFMK4fTPFJhOEegcMTIkFxbCDKgLkdeCnH
         V1AkvxKvI6b+5Z9+lvjlPCokTLtIzJJQshpalkxyrSS5DJ/ilbAcW6/sGHotXDnEZF0s
         8gj1TyD6x5ss8vvnk2H+1dPAHGg1gRtjZbuvNyQMDQWIxos8su3o0O/5glmuPyJ8wOtN
         3hUkk5ZJIRs17ifSM0eR4sJVKfYyuBvR04Rfco2xYuVOsyGVi1WetCPmGbwXWSmizUo3
         5OmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbpsUkSd+e7TcRd395bHWxiDfx2JhrbmRFnL9iD0Fcw=;
        b=IBTh/PyhPNdPuSsl6HzJnD6dJS3wpDqy3bI1JBSsi/cZas4MdJfwwPK9WuG3FHfELN
         sIanYC53cgEEchy/tON40BwGuPILR2oNKjWr1eC+lsSrOlAFMyE/hwdGMlMPZnlkOrrT
         xqtdCxj8+QujP7J9NY5cqhkGFI/14iKTGjSrnfaf/CmpSXS33LCf4YZ32DvKHJWRvPRd
         7D9q7MtzQ+8rMrXTJ3qCBXgj2U+RYvToD7FOX9YDjb9M9ydDtMV3vp1DadknLu7TjWpr
         0CNIRm99EoW4f8f9UMV9CPuugCrEoJiRYn4KRXCJsGGK7aoSdCXCO5B6i3P7qg3OYZAj
         keOw==
X-Gm-Message-State: AOAM532nhAsQfPWvUZP6HuzDXgW2tOMy68uJNwYlLRGt75sbVn4iFd0a
        Fb5wKVPvCm5Toe4sPr9Ma1frsaT0mN5a27+41fc=
X-Google-Smtp-Source: ABdhPJw09jvOJD6qujUAvKr0CkXCtF9DtgsGFZ0Ku0R+3kyJCKvf68vCm4EMsfkimMWKPJEzk/DR28vl5I95QfNydI4=
X-Received: by 2002:a37:a0cb:: with SMTP id j194mr18854122qke.292.1608577654243;
 Mon, 21 Dec 2020 11:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20201220211109.129946-1-ubizjak@gmail.com> <X+DnRcYVNdkkgI3j@google.com>
 <CAFULd4aBWqQmwYNo74_zmP22Lu79jnRJVu5+PrKkOD2Dbp6-FQ@mail.gmail.com>
In-Reply-To: <CAFULd4aBWqQmwYNo74_zmP22Lu79jnRJVu5+PrKkOD2Dbp6-FQ@mail.gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 21 Dec 2020 20:07:23 +0100
Message-ID: <CAFULd4Zc4V1x19bzyP4-xLMtBATkB1AYh=+-jQ3yttLRcuYxtA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM/x86: Move definition of __ex to x86.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020 at 7:57 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> On Mon, Dec 21, 2020 at 7:19 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sun, Dec 20, 2020, Uros Bizjak wrote:
> > > Merge __kvm_handle_fault_on_reboot with its sole user
> >
> > There's also a comment in vmx.c above kvm_cpu_vmxoff() that should be updated.

IMO, this comment could read:

/* Just like cpu_vmxoff(), but with the fault on reboot handling. */
static void kvm_cpu_vmxoff(void)

Uros.
