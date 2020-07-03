Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C578A213215
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 05:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGCDS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 23:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGCDS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 23:18:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBA6C08C5C1
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 20:18:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so19163793ljj.10
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 20:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SnMOmiMqg2WYRkuEFv442IXE+//Cr5LIjZGsSifmgGU=;
        b=pz8std7zGDPAzQbBHwIU8GQ9PYnki3vnQg1S+g8xcStJyQGOf7h9K2tjws4NQYZGVn
         KG+gviz7YmCOqXx/N7MmeNy+aFleVzwoqH2WbDjnomfwn6gePzftQrM62+nmZa2FtTgN
         3RPWN0kwjqNMvGYLXzy2bON6GrITj44PHfVeO+Rv4wkKVyU6mdbNZsnmfbmyyQSXwF+S
         eReoo3Tzt2k9gGnEUktUPKb20MqyGVaZ+vFpFro4FZBP+VqMYFMMluPQF82pBjnSBJ8e
         V1dvRqOAUpJHUYQR/LbT6oy8TKpsbqnkwACdXO6k/jzAm1YCry5i5JBmdwVekF+KP9xP
         G+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnMOmiMqg2WYRkuEFv442IXE+//Cr5LIjZGsSifmgGU=;
        b=mIuBUbZr2Ku1xhlRoB16hOHgwdTu/2AByIx/bzLU9Z4YfSRbQWGle84BJb1BSEtMjG
         2l2CyBck1zGGM7gl574rxbxpefQepEugDIkWSU5gdSmbAy2Z77vFQ5eCq1lGJLe1SeSA
         LmDm3hK+pzLmkSOVmUo8mjVToLHt78NIIgZDKtOH3j88XMj5tFEwkvsI5nm6yx10FZrn
         tLmM1sHo62U6nVjZDHPvd5OYjTWiSy4y+pzZM9hJtzABf/L8rWUEFHUoIh7oAmX4cnpq
         mrwmo/IcuVPEDaf2pdJII2bkM3Gjh1iTKUbip52vXW2ZoLdVL8j+L2j36SRQ7UsJQQCL
         UdJw==
X-Gm-Message-State: AOAM531BiAxgwP3nniwkA/Jgq8Kll1yFmrTXOoYeQG+uOUSxTLtSz0JV
        z3AFmY0O6PVQCpiZ8Ggm/t90Rw8Hty30UotDJSrJ
X-Google-Smtp-Source: ABdhPJwPFU+9EQTP5K1YXtpLPRAQ3J3q2LA6wf+jGVOsBO3Wr5BMBI8imsYtPUbefbuQhAsWeMrSO92HOLH3cKIYsqw=
X-Received: by 2002:a2e:4b12:: with SMTP id y18mr16378986lja.117.1593746304544;
 Thu, 02 Jul 2020 20:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221237.2517080-1-abhishekbh@google.com> <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com>
In-Reply-To: <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com>
From:   Anthony Steinhauser <asteinhauser@google.com>
Date:   Thu, 2 Jul 2020 21:17:39 -0600
Message-ID: <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Abhishek Bhardwaj <abhishekbh@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yes, this probably requires an explanation why the change is necessary
or useful. Without that it is difficult to give some meaningful
feedback.
