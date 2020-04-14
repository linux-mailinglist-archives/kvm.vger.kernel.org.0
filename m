Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851621A8E30
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 00:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407844AbgDNWFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 18:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730942AbgDNWFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 18:05:42 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B567C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:05:42 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s30so11698940qth.2
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rho72t/grqivLnBH+PklFSxpwiueGuqi0ajo0adYzNQ=;
        b=f70DQ47vcid5baI+mw5CyhlKMHsllW1tmruiovqlxdCrb/F5Rq9fqmBbsVdV/DgXmq
         l+Lr44Xm1oZoLGP/r0kCWzA2NfVxWqVaz5eXyo7w1d+q7P72nK4JTr8PF610fGYVskrW
         825lMbtmFB/euwetkAT2MetLpl/MOZAGpnusSnq7CqpKfmRrL3V9L/XRCpKQs1cgpueu
         +SWtvzfbep7Wa79uZ6IJ7VCe6kxhp45cDrP6H5rVPGj3d2vW2S/jCMfNnhED/G7zF7Bw
         CTUodO5UNn4NvQbsfZ8CCVnVJElp/8o24Il+m6twwYJmS/Tp+XfrDJnlxOPzKWdHQweD
         LSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rho72t/grqivLnBH+PklFSxpwiueGuqi0ajo0adYzNQ=;
        b=iLAoqzhLOkS4JraSZXdUxsrqMVRXpFqen5x8YfJk6mKu5D6yNxPi5T39OWbsaeQE1Q
         hwzF90tT3amFslbIN0918lqnJfgwE0ddmAstrg3gpSAIbnQYM0k2mQdsykUUMGF+xxsA
         yTC7GmEYXYz/NV3Ar+hoKeETuYfnMViH9pRiX/XousBkKHGp6jSvelgZJl/LsLN7RvEn
         vqoALRhfMI5H6puXxcM8KCYu0zs1H6ouGlUT4RxotJDuoItNrPGiiHLXg/zrdy8uW3mr
         SxgQvo4kqd9lfo3/zY3mEUuTWdE9UaTwu5gTFcImZtwE8lFvh0E2jkzsxgLQM1R3UXRg
         fo6Q==
X-Gm-Message-State: AGi0Pubr6kf+2Nifa5fK4XQbGHt62zC0BJpxQN506Yl5rALUAkuVBKWF
        DPNTBPKgfQdaKq4CuE50uly5vxK9aNs2u/GiDBKlHA==
X-Google-Smtp-Source: APiQypLLwe2wtXeN1XL26pEaKBv98X9XX7cTkAz9QnXDwA4H37mpHowXRpYajE3NvGvoh5TOFgCP6ruFaFO8wxIQGOI=
X-Received: by 2002:ac8:1bb8:: with SMTP id z53mr18677015qtj.132.1586901941373;
 Tue, 14 Apr 2020 15:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200414214634.126508-1-oupton@google.com> <20200414214634.126508-2-oupton@google.com>
In-Reply-To: <20200414214634.126508-2-oupton@google.com>
From:   Peter Shier <pshier@google.com>
Date:   Tue, 14 Apr 2020 15:05:29 -0700
Message-ID: <CACwOFJTzdCAq1hVfPLfTFzH3QAEJSXKJxEy6yf7ku9GqxB-=0w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: test MTF VM-exit event injection
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Peter Shier<pshier@google.com>
