Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076153B2D32
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 13:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhFXLIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 07:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232220AbhFXLIe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 07:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624532774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4CLu2lLUkZR70TNkgrROGO5qBpUhzA4ASPhaRYEcys=;
        b=g9eKwwZRHmWp9NDsyMJqpDkTpi+1e2PiZOru0cDdq77vIG237uWKufs6Dt785cTrehWIo7
        xFP6FYlghtfq+tbhSIfvP1FRxKJzpYWJ701Zng1iQc+CwQUoblmdcLtLnGdw3Qf7Q1psvD
        hALaaSYqfPIcNij8AYMBJ2ZcjgHB9KQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-1_ZU0xG9MUu_Fy2PNTsuMQ-1; Thu, 24 Jun 2021 07:06:13 -0400
X-MC-Unique: 1_ZU0xG9MUu_Fy2PNTsuMQ-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso1500121wmj.0
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 04:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U4CLu2lLUkZR70TNkgrROGO5qBpUhzA4ASPhaRYEcys=;
        b=pEwDMAnmC3KQEV97arkS/LoDkgjOCr7WfcyQ4k+VVaXYpocL+MLAaMWzX/DzUdQ+Ed
         vmhYxrML6DuMnMmqx82EbKJ4mLVQ50UC6ipEcgbDHe//OhDypLWihIjIn47WITyCSVog
         NLy+Wq/CNPYYpZeX2unra4DymZhQv48khdE/rcPpZi1lTkdzTo5C8s/X0unCH8kcDbYx
         eEviR68K4fM9M2XZREbewlYdXLat/2+1Idhr5E2mh3HWVo2FYp92tPu1Cj9EghwkQLnW
         Fs2CsNGHokNfOmgTiqOAe9aZLID/9l9M+SU2amTAqlwtfGHu6tN5EXUMjBnFwQE7PQ7a
         avkA==
X-Gm-Message-State: AOAM530AWhSxpXepIi/lFBS+FSjA3Yp4zog3nOG1dx84bByotEJ/WNHu
        F9UhfSI+cd7oPdmli5KywZCzgC6TrB2Xdv7BK6tmajYQPZvzN/BI1QYB73cqu9AEQX/lJdAf9u5
        iiZMlyhgpRb3V
X-Received: by 2002:adf:f688:: with SMTP id v8mr3759194wrp.209.1624532772446;
        Thu, 24 Jun 2021 04:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQ6JAQ/geg6p7DEfdGt8VJkL4A926Upld+wizuc/AIEcDJiSC15mwuf4BquwbrdXS/zwVnRg==
X-Received: by 2002:adf:f688:: with SMTP id v8mr3759172wrp.209.1624532772251;
        Thu, 24 Jun 2021 04:06:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n8sm9456581wmc.45.2021.06.24.04.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 04:06:11 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits tests
 (new one on the way)
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622210047.3691840-1-seanjc@google.com>
 <20210622210047.3691840-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
Date:   Thu, 24 Jun 2021 13:06:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622210047.3691840-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 23:00, Sean Christopherson wrote:
> Remove two of nSVM's NPT reserved bits test, a soon-to-be-added test will
> provide a superset of their functionality, e.g. the current tests are
> limited in the sense that they test a single entry and a single bit,
> e.g. don't test conditionally-reserved bits.
> 
> The npt_rsvd test in particular is quite nasty as it subtly relies on
> EFER.NX=1; dropping the test will allow cleaning up the EFER.NX weirdness
> (it's forced for_all_  tests, presumably to get the desired PFEC.FETCH=1
> for this one test).
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   x86/svm_tests.c | 45 ---------------------------------------------
>   1 file changed, 45 deletions(-)

This exposes a KVM bug, reproducible with

	./x86/run x86/svm.flat -smp 2 -cpu max,+svm -m 4g \
		-append 'npt_rw npt_rw_pfwalk'

While running npt_rw_pfwalk, the #NPF gets an incorrect EXITINFO2
(address for the NPF location; on my machine it gets 0xbfede6f0 instead of
0xbfede000).  The same tests work with QEMU from git.

I didn't quite finish analyzing it, but my current theory is
that KVM receives a pagewalk NPF for a *different* page walk that is caused
by read-only page tables; then it finds that the page walk to 0xbfede6f0
*does fail* (after all the correct and wrong EXITINFO2 belong to the same pfn)
and therefore injects it anyway.  This theory is because the 0x6f0 offset in
the page table corresponds to the 0xde000 part of the faulting address.
Maxim will look into it while I'm away.

Paolo

