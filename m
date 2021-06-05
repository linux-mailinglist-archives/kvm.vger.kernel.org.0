Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A839C7E9
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFELey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 07:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFELex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 07:34:53 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA5C061766
        for <kvm@vger.kernel.org>; Sat,  5 Jun 2021 04:32:51 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i5so9971952pgm.0
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 04:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=saBLQb1l1jx5NXLMvmuVHK3+H6dwAC6PpoeXZHcBM4A=;
        b=QasWxpDNwyBBCMoo+S8I9Hasg2QUYCFDVFZpGN3DHf8kmKd+5FB0+bj93i2nuwvQyJ
         YPVVe/ElfKlhjRRQ00NLxvkrRaknEbkuna7BGqZMLAJZ7jm+5nxwDQ3SksJAJYNcoEIA
         +PoKWAccdjQ6JZSOyjE4H9JxBbpFAVjeatvdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=saBLQb1l1jx5NXLMvmuVHK3+H6dwAC6PpoeXZHcBM4A=;
        b=WM14JaoTAO+UXbUr2XjaZW6zWdOipEihmpBQwgCaHj+vn8DmSCrarTwkOiGJnXKBLK
         UHrjAeKMEwPGvf2drM8WQ//7Ac14zXcHqn3iWgwo8CP9zrxSh8CzkedXqZjeffi4fjIV
         DfTKzQQRf68JmHrvELHCobqzKwzuwJz7NMH0ZyuiloVLkmE7Fv1+GvwRUXyBt8us+Qr6
         dyy4cPp83mzOChRC8FoPlYJepnzfR5/Sorl0zZGGETCxwFNyOAkixiUTpEtehdjj/zMz
         5fbXeqoNHk7bfU1SV52LxvEejZg6jlgWlSJeFc5hRFDCw81ZUxj4GW8RArWMcCaHyn4k
         R23Q==
X-Gm-Message-State: AOAM5309Va1tPFq9TyjyOjVxrbLW5YKiF9ZTSQ2rHOZ5l5hJ8IZas3bi
        vw6jCFLMQAs0qQ/SjUP5a4EoRg==
X-Google-Smtp-Source: ABdhPJz3MEw+ClzKyKv8vkGSQoDTHVFWGuJ+O0/MgmnD7dbIt6LC/xRREyJHlt4o8FyIfR0AEC/AKQ==
X-Received: by 2002:a63:1608:: with SMTP id w8mr9334263pgl.259.1622892770570;
        Sat, 05 Jun 2021 04:32:50 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id c20sm6770926pjr.35.2021.06.05.04.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 04:32:49 -0700 (PDT)
Date:   Sat, 5 Jun 2021 20:32:45 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
Message-ID: <YLtg3TVc8nxUo57b@google.com>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
 <20210605023042.543341-2-senozhatsky@chromium.org>
 <87k0n8u1nk.wl-maz@kernel.org>
 <YLtWjiFb62RFLWzA@google.com>
 <a304706273ff750b4aa8b822606fb03e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a304706273ff750b4aa8b822606fb03e@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/05 12:27), Marc Zyngier wrote:
> > Do other printk-s contain such info? All I can see so far is
> > `#define pr_fmt(fmt) "kvm-guest: " fmt` which doesn't point
> > at any particular VM.
> 
> Look for kvm_{err,info,debug...} and vcpu_{err,debug...}, all of
> which will at least give you a PID. Even x86 uses it.

Oh, I didn't notice it, arch/x86/kvm/x86.c has very few of them (2?).

Great, thanks.
