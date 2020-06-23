Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF42F204D5A
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgFWJEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:04:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731786AbgFWJEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592903070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGieKfyK5EqEvIJm2Uhtek3MXs3nrz2LXOt+Sfu/fVc=;
        b=G6yFMilqei+Uh/WISr6hO3MTDqCjGgYysbe6TGLZP0yDUd/h/EzD3FnWPEXyPddt7yj/N7
        V5RZiZZDJLK/2H/xK07VCUbGtSK6djwu6CI+3/mzuLT42BNW2txXXusoxGf1zE2s8Mdh4p
        xw7nrLn78VuSCZb6qyDsT4uwJM8dHTk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-dC1oaOkjPpaL8Xg5In35sA-1; Tue, 23 Jun 2020 05:04:28 -0400
X-MC-Unique: dC1oaOkjPpaL8Xg5In35sA-1
Received: by mail-wr1-f70.google.com with SMTP id l3so5335646wrw.4
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGieKfyK5EqEvIJm2Uhtek3MXs3nrz2LXOt+Sfu/fVc=;
        b=iHQeUpYJuiTM2FOXJ0OLhA7SSq5Jvt8LorjYChaf3IHJSpUBcGlAUmTATBTWf6UDrT
         L7s00yPfW2IftT3R0FmSmbwB1YgncXcfrU7LTJPK62RaFdaaSCrc7P/iwSV3XBJaCAJM
         IFMy9quMD6gzGFHuagOoi5p/z9w3QSU77Dkw+d9YxyWfsE/qLF8KTO25LfxbiV0A5iTa
         quqCoWM9cwoR11Wl9afAZHQKt5kRZBgSUfwxenJmLEDOeWFfpIy3I9u/LYK7o96zHZnV
         11OhahI3ng0Wx5NlGWnVwNShOOazVlqPc56dklveX722negxQtg7afXkn+A9TRuWwbVo
         4FEw==
X-Gm-Message-State: AOAM533vYvD60b400Wen7ZEZK5k3l12T2iyEntPwAr57Lvap2EpneyZV
        P2uJ+VHM4F/yWxd/PEUNq2qnQYvVuxtUQNG3jKx5ziQNbjdbrQccOff70k+X9Lui/6hnzNlgRG8
        Xa9gvyqnjxYRw
X-Received: by 2002:adf:de12:: with SMTP id b18mr16010378wrm.390.1592903067313;
        Tue, 23 Jun 2020 02:04:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrLMdyOT1yS66Or/wZR6Ty2z8rs5YtCrhaoKF5RKYeeJOu55RR8lINTGxXQ/PqiR9RBZlDhw==
X-Received: by 2002:adf:de12:: with SMTP id b18mr16010359wrm.390.1592903067012;
        Tue, 23 Jun 2020 02:04:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id b19sm2945206wmj.0.2020.06.23.02.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:04:26 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: nSVM: Check reserved bits in DR6, DR7 and EFER
 on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <357fca54-25ed-4b58-f685-7c5d1546b4c6@redhat.com>
Date:   Tue, 23 Jun 2020 11:04:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/20 00:19, Krish Sadhukhan wrote:
> Patch# 1: Moves the check for upper 32 reserved bits of DR6 to a new function.
> Patch# 2: Adds the KVM checks for DR6[63:32] and DR7[64:32] reserved bits
> Patch# 3: Adds kvm-unit-tests for DR6[63:32] and DR7[64:32] reserved bits and
> 	  reserved bits in EFER
> Patch# 4: Removes the duplicate definition of 'vmcb' that sneaked via one of
> 	  my previous patches.
> 
> 
> [PATCH 1/4] KVM: x86: Move the check for upper 32 reserved bits of
> [PATCH 2/4] KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not
> [PATCH 3/4] kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32]
> [PATCH 4/4] kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
> 
>  arch/x86/kvm/svm/nested.c | 3 +++
>  arch/x86/kvm/x86.c        | 2 +-
>  arch/x86/kvm/x86.h        | 5 +++++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> Krish Sadhukhan (2):
>       KVM: x86: Move the check for upper 32 reserved bits of DR6 to separate fun
>       KVM: nVMX: Check that DR6[63:32] and DR7[64:32] are not set on vmrun of ne
>  x86/svm.c       |  1 -
>  x86/svm.h       |  3 +++
>  x86/svm_tests.c | 59 ++++++++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 42 insertions(+), 21 deletions(-)
> 
> Krish Sadhukhan (2):
>       kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32] and EFER reserved b
>       kvm-unit-tests: x86: Remove duplicate instance of 'vmcb'
> 

Queued, thanks.

Paolo

