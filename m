Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155B4344FAE
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhCVTMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:12:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231782AbhCVTMG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 15:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616440323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfnyDJKd+AIhgsgjhm7fjzOjPp4nvTJYPKMus8kh4Is=;
        b=bcI7cGLe1VaPHFnfFGAygbBQvRmRm6Uj120jXr/uSJ8N+Kpxhzps0Yzw5aKFELXgDsZ938
        C8cXWjlmhkJCKWgDQ1mNxFZFHe93xvtGmdxnOi+cpn/+4JU3tBnawt2OtlOeSenKtApKYU
        wcZs07JSh6pNQvvMuo12H/kve++jgy8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-cwzgFPBPNd690bXxy4CTTw-1; Mon, 22 Mar 2021 15:12:01 -0400
X-MC-Unique: cwzgFPBPNd690bXxy4CTTw-1
Received: by mail-wr1-f70.google.com with SMTP id s10so26590944wre.0
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 12:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UfnyDJKd+AIhgsgjhm7fjzOjPp4nvTJYPKMus8kh4Is=;
        b=WLJTaw2NI7XLpe31FIkNfXMKLJ7mx0VEtrM/7BswhCaYyC5SNANGSALE7/3xjHL++4
         OH1bIau7JryL/Pu0oQWaXmOcZBqfG/fwnzO6ploJhnkEcrUNLSQc7Satv3eA3hZ+yM9P
         05HHdNO7xbMsYIOaO5F7qtkxklM6ExaDdxtaAkrp+aIVtp73odLtd/9S5iMRbYdsT8r+
         ybtKZ+YKNTI4GGpO2/48+0BVHKHInw/0no+6RxcV7Ese08R5CdRYnBYg4pymIGMUDfVT
         SsQFucbmUO4FgowjDN+ekrmT7wVGgTrAkc3JJrUZn4hZrlmIAcaAe0tLPsEEcIidPiQU
         owcg==
X-Gm-Message-State: AOAM533wppDOox8e9zZpMq9E8fSCO3ZTmqeCTj1dYO8ebw3iMAA3hqXM
        filckIjzz8a1LfCuYeHDtoUmcxQV0CDHSYy9FocNS8XVeOyeEVm45+/lAN73jJHq6+dX8/7L9Xm
        3/WAHHfyBMpZt
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr71229wrd.47.1616440320267;
        Mon, 22 Mar 2021 12:12:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/cLnNqtKWv7V1/Fpeb5aRH7hZpgdnHA/Zo2qiXqHKF8asFjWbETSgysqD6vFP3G2Q+t5LNw==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr71209wrd.47.1616440320100;
        Mon, 22 Mar 2021 12:12:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x11sm347291wme.9.2021.03.22.12.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:11:59 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic> <YFjoZQwB7e3oQW8l@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2e01d7b-255d-bf64-f258-f3b7f211fc2a@redhat.com>
Date:   Mon, 22 Mar 2021 20:11:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YFjoZQwB7e3oQW8l@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/21 19:56, Sean Christopherson wrote:
> EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> running as a guest).  IME, nearly every kernel/KVM bug that I introduced that
> led to EREMOVE failure was also quite fatal to SGX, i.e. this is just the canary
> in the coal mine.

That was my recollection as well from previous threads but, to be fair 
to Boris, the commit message is a lot more scary (and, which is what 
triggers me, puts the blame on KVM).  It just says "KVM does not track 
how guest pages are used, which means that SGX virtualization use of 
EREMOVE might fail".

Paolo

