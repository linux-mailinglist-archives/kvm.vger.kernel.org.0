Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6DBDEBD
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfIYNQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406302AbfIYNQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:16:02 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15AEEC01F2E8
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 13:16:02 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id j3so2369933wrn.7
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=li+RJAZERyAnlpLvPEO2mCJT9+G6j7Ld/SRjBrvxHfc=;
        b=eeRJG5SafkwDL/J7PgNnEGhfkeYuo8ZpOpPGB9pMmQY5+QcEI8M1Jh8WIpQuXsXYKn
         cpUkFIlTmBG0kpOFXqaBZFHW44EQ5uTZ9IKjoSmHzhk4u5xWzwbfdWU8vIEiMhHGGdbc
         qXw+m0qZmK0fn1eRaAyG+wV3bzzGmdm87rlQ6wMSuyncyp4cHMU52IM16aMNuBGtHLP0
         1oWsQgmg8zJ3JdYG3W7G6BCDGjlFICRgHPgYAMFAyCf5Q91fi5nH8Ccqbr5LPjaYch1H
         9onbwapxjDZaRH9td6MwG50FUC2tXrdJK4GvvHif6O3VW/SK4DmVpEinCgxSmlFn85Ti
         Gqeg==
X-Gm-Message-State: APjAAAUh/4GNerU0EOy68IUkWIhHeamPe50IWbnc+tzqQLK7RHWJRAqN
        YNlQzP3rqzsftoR8lVsRriLfegyh980BXcjyYxISxVTVy2CQllwhhRqVb9aORs88e5+eDZx1sby
        /PjYrvV2LnXI+
X-Received: by 2002:a5d:6302:: with SMTP id i2mr10060835wru.249.1569417358047;
        Wed, 25 Sep 2019 06:15:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwFI9mAjWpOt1irI66Kj1UbIBIjLaK0zHtCoXzv3fBHCXtZCPMf+523IuWV+vq98Z0jwtHItA==
X-Received: by 2002:a5d:6302:: with SMTP id i2mr10060604wru.249.1569417355789;
        Wed, 25 Sep 2019 06:15:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id x5sm9112207wrg.69.2019.09.25.06.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:15:55 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: fix ucall on x86
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20190925131242.29986-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7151fc11-b434-1114-cbd0-023b0b8ca6d3@redhat.com>
Date:   Wed, 25 Sep 2019 15:15:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925131242.29986-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 15:12, Vitaly Kuznetsov wrote:
> After commit e8bb4755eea2("KVM: selftests: Split ucall.c into architecture
> specific files") selftests which use ucall on x86 started segfaulting and
> apparently it's gcc to blame: it "optimizes" ucall() function throwing away
> va_start/va_end part because it thinks the structure is not being used.
> Previously, it couldn't do that because the there was also MMIO version and
> the decision which particular implementation to use was done at runtime.
> 
> With older gccs it's possible to solve the problem by adding 'volatile'
> to 'struct ucall' but at least with gcc-8.3 this trick doesn't work.
> 
> 'memory' clobber seems to do the job.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> s390 should, in theory, have the same problem. Thomas, Cornelia, could
> you please take a look? Thanks!
> ---
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index 4bfc9a90b1de..da4d89ad5419 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -32,7 +32,7 @@ void ucall(uint64_t cmd, int nargs, ...)
>  	va_end(va);
>  
>  	asm volatile("in %[port], %%al"
> -		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax");
> +		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
>  }
>  
>  uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
> 

Queued, thanks.  s390 already clobbers memory.

Paolo
