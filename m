Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A611C6CF6
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgEFJak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:30:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59879 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgEFJaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588757437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRDsoW4PqOKDTvl02CnBAXvAH/isXXOqF537drR3NpQ=;
        b=PbLrTLBjF6kI8dCKTJx8j1L9hxs3NzqZZg9EfuNbt3Iw5SMeHsg6dddoa2PSDq38BKLi9h
        0A+cCifv5MiQwoDvieTdrXO6g+ETJ1zNTuS86gQHOzFoDrx+dNFLcc3FVNzfgk1920fKth
        vkrpf9CwstQ2vZElYgUL25tzATRa61U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-fCB_0z-cPkmScmG0ZbZS1Q-1; Wed, 06 May 2020 05:30:36 -0400
X-MC-Unique: fCB_0z-cPkmScmG0ZbZS1Q-1
Received: by mail-wr1-f69.google.com with SMTP id o6so1024038wrn.0
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 02:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KRDsoW4PqOKDTvl02CnBAXvAH/isXXOqF537drR3NpQ=;
        b=g1SiKuilkZlPhGLw+0WKWvrRtxq2AZfnYxkdwXdXAGN1yvL0gWdL2QNqAemN00TISb
         tA5zKmHNa8WO/ivgpsmTsh7s0KKqOjC+XhLtc4UukBv8gNUa5kwZdEVrET7qEzuUH14A
         mh9Vq2QPZ+A0SpOUipawpRs/hwj4X6/7+/8oDMfmaCWG95F+ZkpQ5gLVtKExbuS4LLs0
         sxIE09H7B1g4HOpTNzcgiqbEyVmbAz40jmMfNir2HdWkR6wlfZUmsk0d6TpvWtpK6f6i
         P5kKWr5h3kHMxYbTyL6BVxKjjwnzKyX5bI0vdmuyESZgWBWeIDgMeSI7xL/jY/1rP6X4
         CShQ==
X-Gm-Message-State: AGi0PuYTPm7pc4aRUTUj8d+Vw6ejQbEBD0H0oiihyD4oKVooE+N9s4pg
        diYi6oIdBjan8IwCqYX/3r5vYViQhDVs1WVpahPUdCMn+7UW8vOHBO5IO0V9qhsi+kHxrI0YfXG
        5k7z/ka20Z9/g
X-Received: by 2002:adf:80ee:: with SMTP id 101mr8745387wrl.156.1588757435331;
        Wed, 06 May 2020 02:30:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypK1zeUGnOlegWT/WV63eeUClJZUURP0CVxjtygCGm2d+x+81dM3Mdu5VfF57GS88O4fQlC22A==
X-Received: by 2002:adf:80ee:: with SMTP id 101mr8745370wrl.156.1588757435104;
        Wed, 06 May 2020 02:30:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id a67sm2275700wmc.30.2020.05.06.02.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 02:30:34 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: X86: Two fixes for KVM_SET_GUEST_DEBUG, and a
 selftest
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200505205000.188252-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a16352f2-73ef-b2fa-44e0-82b52dab8466@redhat.com>
Date:   Wed, 6 May 2020 11:30:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505205000.188252-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 22:49, Peter Xu wrote:
> The first two patches try to fix two issues I found (I think) with the
> selftest.  The 3rd patch is the test itself.  Note, we need below patches to be
> applied too for the test to work:
> 
>         KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
>         KVM: selftests: Fix build for evmcs.h
> 
> Please review, thanks.
> 
> Peter Xu (3):
>   KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
>   KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
>   KVM: selftests: Add KVM_SET_GUEST_DEBUG test
> 
>  arch/x86/kvm/vmx/vmx.c                        |   2 +-
>  arch/x86/kvm/x86.c                            |   2 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +
>  .../testing/selftests/kvm/x86_64/debug_regs.c | 180 ++++++++++++++++++
>  6 files changed, 194 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c
> 

Queued, thanks.

Paolo

