Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4826520582B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbgFWRC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWRC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:02:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AC6C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:02:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so9347470pld.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hBYapAhWIOf0yfzh5Sy0kQURgE1MviISrIh1um9hujs=;
        b=c7T8G/9Q4UEEmHYn0Jx7Rx2Rk/GBybUUoKCa0aLL3t8AXQhFq37GpUgDW//MwFu1B4
         W7/qEmgFX5Jj88WA7yv3plv6iXDQasioXkAvbvCEcC+1lvcSet0xwjkNlqr1dwoTlfXs
         SfSoI0c6dnOhq98S+DvjH8SSDwa29IkAJZOmRT+BXk06zUpiDUZatub7u46lgQ3nGUOt
         R29RhC8ixtlXCc1jgW/uPlLiXrPBcYMM80XbXPT1HFncx4nZmdWi9HCXY5+W/JfHhE7F
         ex3oBo/NNtx6f5MYNn+N8CDp0mWrOxF1a7D1IAC+VOrVcT5RJZ6YTW8wX3Ems2OViLMp
         BGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hBYapAhWIOf0yfzh5Sy0kQURgE1MviISrIh1um9hujs=;
        b=I/Ya32uMVO++92F4WY5d0pGjfLY0Sz/sYD63fIFvHnE02uPKn0ZehwshPI4nMtC3Ky
         nVJiseeZRq0SgcB9b4hkxPrGVSUBGDI2vs1l0mJe2S2ZsuNjGW4H0Qro+IfsSkC7X2VA
         ENnNRE4Pt6RbcAUMcE8VfXQO4HU78rH6fVvbr2OYksim7R8bS/28aYrGL1tgsiqJ1jab
         jArbyHa7A+mruIB0IyvJYTP3zmzr/ea8k6mcg3wEi+L18fJAfULgjSmlTcHC2KyC2fIT
         ZKD5ZA38WWwM/trztth3039A3XV8fsSAWu63xO6kvDeZOQbVdhnxrOHHU23bV9LqDfEc
         rd8g==
X-Gm-Message-State: AOAM5305VWovJZz69a7FDflX/sP6WoFO43rZVkaaEoc4kaH45Ol1Rb92
        fJ17ApGfFGfFva/i9h0496c=
X-Google-Smtp-Source: ABdhPJyCL5WEyZEZYENX0ywdXLvGojQiiEhDKvvJdn+nGZT+bg2WyRe7SX7uUhzXE8V30aJooH655g==
X-Received: by 2002:a17:902:bd0b:: with SMTP id p11mr24552983pls.91.1592931748022;
        Tue, 23 Jun 2020 10:02:28 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:55dc:2130:bbc8:d35e? ([2601:647:4700:9b2:55dc:2130:bbc8:d35e])
        by smtp.gmail.com with ESMTPSA id j36sm14815285pgj.39.2020.06.23.10.02.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 10:02:26 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] vmx: remove unnecessary #ifdef __x86_64__
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200623092045.271835-1-pbonzini@redhat.com>
Date:   Tue, 23 Jun 2020 10:02:25 -0700
Cc:     kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <AB6977D0-7844-49AE-A631-FF98A74E60FB@gmail.com>
References: <20200623092045.271835-1-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 23, 2020, at 2:20 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> The VMX tests are 64-bit only, so checking the architecture is
> unnecessary.  Also, if the tests supported 32-bits environments
> the #ifdef would probably go in test_canonical.

Why do you say that the VMX tests are 64-bit only? I ran it the other day on
32-bit and it was working.

