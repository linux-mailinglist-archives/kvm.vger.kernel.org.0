Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A2F39E17B
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 18:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFGQKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 12:10:51 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:39789 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhFGQKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 12:10:50 -0400
Received: by mail-pg1-f177.google.com with SMTP id y12so2323546pgk.6
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 09:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pT+fPdmYDqDMFuFLXYZiJ/4/kBu8OXPCoDOzFw+hto=;
        b=s8B6/VkuyXq4qdYRCmbgDg+SuezH6hOi58cGFA8q/J9XqHQlocG8YjLu7ejgMWS/xX
         fed8XbG0wA0QUN4lym+108KLQDsbNs4KIbRKYo6ilZOvq0o+d6UyoR//aLXn1Hu/vlAq
         yP1ZP+cxFayYOfDE9LeAJPdGGrWedrAAUYMHZSd48ZxJfOHA8eMFXyZJhu15By4aWLpE
         wE70dG4QXBHkg2XblNgK4vtxL/COW5tWSLBPuBynh4Db6gExW4b3XTknI75Gwm8TIZ5b
         4pEaSRuON5OtGFW4NYQDPLWQvFtE4A0IvVd/m1uWCVKDTMruHgrAinkwRR9JPq0A+Iss
         gf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pT+fPdmYDqDMFuFLXYZiJ/4/kBu8OXPCoDOzFw+hto=;
        b=eAT7IQOay1d33nekSovmHnrgqtHpkjBty4k4sKbGtvpoec9w/ch05rXeFnWsrNaUmM
         rJ/tNVPnrk4yAT7h8MdECQzdVr0/5H9UXsPuKcLrt2wUvDkauSPt9LyGotihOr87NP8V
         bhLU6SadTCxPbRxiWoyN0P4AKXUFY5EY9hlVlgcC0uSn/eXB9XQMUVc4pQazidlrVnxi
         gk10YIsPNLqpPh3E84BBBoNO0J8a/Lk9H37K7jRLl/z83/KQCIu08280/wHSe/iogWJ6
         jgZyaFJJid+12O3lMvsOeaoiT1s2wYzlSVWKmlM8Xn+yzZ3PUoaI+Px2pqrduwAN36C0
         pXGQ==
X-Gm-Message-State: AOAM533Le/B8EyjPoA5mkKTcK5/PuGG7g9D2m45f36EsqSZb/CE0TidH
        NvpcBzs5Nh9jA5n52EGhWbSk79HpTbdoLg==
X-Google-Smtp-Source: ABdhPJwlwJ6AkmZNuLpzKISd0pSadI1yVpmHR5ZCOBmzeB1TAshfbuXw/bugo1uFnF0tkAOa9I2F0g==
X-Received: by 2002:a62:8204:0:b029:2ea:2647:bb4f with SMTP id w4-20020a6282040000b02902ea2647bb4fmr17635905pfd.23.1623082065121;
        Mon, 07 Jun 2021 09:07:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g63sm8580661pfb.55.2021.06.07.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 09:07:44 -0700 (PDT)
Date:   Mon, 7 Jun 2021 16:07:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        eric.auger@redhat.com, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YL5ETJatW+BM9vKS@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com>
 <YLqzI9THXBX2dWDE@google.com>
 <6d1f569a5260612eb0704e31655d168d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d1f569a5260612eb0704e31655d168d@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 06, 2021, Marc Zyngier wrote:
> This is becoming a bit messy. I'd rather drop the whole series from
> -next, and get something that doesn't break in the middle. Please
> resend the series tested on top of -rc4.

That'd be my preference too.  I almost asked if it could be (temporarily)
dropped, but I assumed the hashes in -next are intended to be stable.

Thanks!
