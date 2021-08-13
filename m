Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379253EB41F
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhHMKj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 06:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239856AbhHMKj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 06:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628851141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WyJt1iH3dxmh/Y0kduNYxEXL6oIxprnJALE21j5tTvI=;
        b=LYUhozwR/oteXC4Y26cgMh/YX7MIb5LxcrgyrH6RL0PQIQIU07IJUnpeqbX/m51KWFF1DI
        cBScVrVrj+wMjtE7PrnJxH9hq3PHclBn0rdQenlH1MnMqbXzxkmy/th9vwyOJC1rUSX3+d
        IrjgdPZAhfX+lXF87N77CjO7/NzqtwU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-sgJTm8eXPTe_9W0-xmDkUQ-1; Fri, 13 Aug 2021 06:39:00 -0400
X-MC-Unique: sgJTm8eXPTe_9W0-xmDkUQ-1
Received: by mail-ed1-f72.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so4624517edr.16
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 03:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WyJt1iH3dxmh/Y0kduNYxEXL6oIxprnJALE21j5tTvI=;
        b=Z4pTkJErjqbd9XF4y0Sf5uZc9jzx14RRJMyGjI2mK9JlTJWqPDV8krkq7VhOU+fdC7
         kclI6GyF9f7fA/WgMKDElIvzg50o9NroRzouJ+qju9U4SQO87szg8gj6QO7iGlVIVC63
         oXAgTeMaO6Jic05+jzygIEpCcMPu42a8RDqfB/Pj/akcX4PGNX0msGVZMvV9ex1n4g9l
         6z5x7Fq65OlWSYOLcvOsSo53HvpANaoSPKNQnwm3CcKy+bpCxq0LS9gpP+Z4PptNBwRi
         VTS2rN4CDRstloTNLpz/hHrfN49Xh/QB1RBUSxkywUVaQlvrAtsRnm7Gk/aTzNeEhWXz
         Jt7w==
X-Gm-Message-State: AOAM5326R7hWf+Dk1Bd2GoPGvN1NWLDKlX7V9tTBfqi7UOXsldGlcX5y
        5ZVHLdAOBnC9JuORX22SsndVlfyjle+ALkg9y2dSp74zwlujweguOBpfJbHa4h1d4M5k99adpw3
        1WbHWIRPamq5+msQtWDp6eD+Hl7wALgLkaNaiSzZU3wtIa0HiJIJtGnoKurcY/zNK
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr2170954edt.321.1628851138881;
        Fri, 13 Aug 2021 03:38:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYb5LC6tQ7HWsXPHihPKsKLKd5zF/LIm85bbUQUZ58mH8zJnUZOSCeW3s0wTrmWPLXdVYhfw==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr2170931edt.321.1628851138654;
        Fri, 13 Aug 2021 03:38:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jo17sm460250ejb.40.2021.08.13.03.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 03:38:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Couple of SVM unit test fixes
To:     Babu Moger <babu.moger@amd.com>
Cc:     seanjc@google.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
References: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5d156e5-e23d-4c82-42f2-33566af06ae1@redhat.com>
Date:   Fri, 13 Aug 2021 12:38:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 00:46, Babu Moger wrote:
> This series fixes couple of unittest failures for SVM.
> 1.The test ./x86/access is failing with timeout.
> 2.The test ./x86/svm failure with infinite loop.
> ---
> v2:
>   1. Modified the check in ac_test_legal to limit the number of test
>      combinations based on comments from Paolo Bonzini and Sean Christopherson.
>   2. Changed the rdrand function's retry method. Kept the retry outside the
>      function. Tom Lendacky commented that RDRAND instruction can sometimes
>      loop forever without setting the carry flag.
>    
> v1:
>   https://lore.kernel.org/kvm/162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu/
> 
> Babu Moger (2):
>        x86: access: Fix timeout failure by limiting number of tests
>        nSVM: Fix NPT reserved bits test hang
> 
> 
>   lib/x86/processor.h |   11 +++++++++++
>   x86/access.c        |   11 +++++++----
>   x86/svm_tests.c     |   28 ++++++++++++++++++++++++----
>   3 files changed, 42 insertions(+), 8 deletions(-)
> 
> --
> 

Applied, thanks.  I'm looking at a few more limits to the number of 
tests as well as optimizations to ac_emulate_access, which should reduce 
the runtime further.

Paolo

