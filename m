Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BCB3CB115
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhGPDXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 23:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbhGPDW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 23:22:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1C7C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 20:20:04 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 22so13550619lfy.12
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 20:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1YJZ1CWMmebpSmtQddMMIIyxPUmJh3e5O5JeZSNpVGs=;
        b=nxKomr+4b8nUr5nZA7o0Un2l3lcqOxbFjPG9P8ddAeJpxbPxqCIK43r3pTnzv2WoUM
         DK52SNtlDCj+0MGDyWA9LkQXWJGwDn4p5L02XE6rJNDEpSRBbn/4WZfQGPWIcoQCeDsx
         JBPcRwHKiZa1PRrV9YE9ECOq7o2eBqmkPfMPd9Ma/AZzKa4EMqCVMBdmFEECQ0nwqMxn
         OInSDMsAasv51sOB23FHYqowemSr/t/4JeEU7QW+lQ4ijvWz+hHlM2H/qce2oz/v42fA
         JV5rnRwzyNSIekiHaomTSkv9WU23rbYSl1RV6mP66ZfIWiKlAkGlb2RH9k7WXdDAr+2o
         POyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1YJZ1CWMmebpSmtQddMMIIyxPUmJh3e5O5JeZSNpVGs=;
        b=JuvL4r2B7fpo8n7zV29ihBU+V1UqOjwXkAGeBvkwoDMYUmCZPmQ5iBsAuSd1kLnvgI
         siYJ4FxSv93JjQmjT+wQnSkoXBNVTacds9yZFZyS+DupZQ5yvqRpKHvIA/2jMon9hCAf
         NcO6t0YDU49/OuxA/z5iGbpZBU3tnetxoHwY+npFUd6i+/iG247KGLvG29s0bKv7yrlR
         piSSKLwRiyeW5UTUj3w3VOK/JtIlW5CGD38JKxF6N/ptyIfF5L+yoZBJV1C0J5t2rLv2
         wKHMcCNgUKl7o8b5BOcQhogRXZAouwCXa2PZq9dkBiTkA5c2KrKAF6b1mdPSQA+e7BP7
         A4Lw==
X-Gm-Message-State: AOAM533ejdIijKhNGoLHA9854TPclgKf23BstiRURY2RLXvw0oYU8syh
        3rbhQHKTIqAwCPAr1BziqPOpD/wXohmYp5XPay4=
X-Google-Smtp-Source: ABdhPJyVq5th++qXg53cvve/xs6hma3tAScm8LW1cQsaL++a+pZcGEmQN+gylMMwVZhPapBUf9LoENsGX/SAV+/xXSg=
X-Received: by 2002:ac2:50c3:: with SMTP id h3mr6102308lfm.126.1626405603089;
 Thu, 15 Jul 2021 20:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com> <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com> <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
 <YPC1lgV5dZC0CyG0@google.com>
In-Reply-To: <YPC1lgV5dZC0CyG0@google.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Thu, 15 Jul 2021 22:20:04 -0500
Message-ID: <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for the explanations. Please see my comments below. Thanks!

>  When TDP (EPT) is used, the
> hardware MMU has two parts: the TDP PTEs that are controlled by KVM, and the IA32
> PTEs that are controlled by the guest.  And there's still a KVM MMU for the guest;
> the KVM MMU in that case knows how to connfigure the TDP PTEs in hardware _and_
> walk the guest IA32 PTEs, e.g. to handle memory accesses during emulation.

Sorry, I could not understand why the emulated MMU is still needed
when TDP (e.g., Intel EPT) is used?
In particular, in what situations, we need the emulated MMU to
configure the TDP PTEs in hardware and walk the guest IA32 PTEs?
Why do we need the emulated MMU in these situations?

Best,
Harry
