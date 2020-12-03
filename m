Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F002CDCB1
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgLCRuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:50:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbgLCRuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607017713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2znfyDTasZiN4yQYMDc5gMmoOgqrihF/GJzDFa8ibc=;
        b=N7m5PTTPXyrYZ32gbYXMrzf+/4HlIMBIw+pAWCw59GUu+avG1brG43Rl0sM7P8B3aekB+s
        Lalep/yMv7VOzE+boRa7MonWl2iLmwx08ycX+9PN+ii6eGf1x4d+Jqd04JUhGtnJXFfw7R
        xepCJ8WVeM9PlrQfp6cRVeNy0u1POKg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-4wnA2atwN1iL-b4qpYWFzQ-1; Thu, 03 Dec 2020 12:48:31 -0500
X-MC-Unique: 4wnA2atwN1iL-b4qpYWFzQ-1
Received: by mail-ej1-f69.google.com with SMTP id dc13so1063405ejb.9
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:48:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t2znfyDTasZiN4yQYMDc5gMmoOgqrihF/GJzDFa8ibc=;
        b=spsxMsaeh1XEJ7qd7ErM+QsmzeaPPoBfT9qHbCZ57ZXw/kcDgdq6Bh0lIv2Q1K62YW
         77vtw4/D2FLVFoXQ0K8YaCBoEPlFwZ5XS8PCWanI7R7brPL3XpiEpZiMbbbsmGsH2ByP
         cI94N9jjAOqOoEQx8rVeyEXYkB+cU5j9JQcSjYO/0swaOVut/sZtQI+sbvBO2wPw66KT
         6mi+Q7DkdPY48+hXBhzZELKAqMPZCPfJc2a+qUP1YFPQniaCnAFZ1xqn8+rYt/mEy7zd
         guANXJeT8iyP+sboXXQtGIURiFiF/xyPIej0vKPJBj2g3h3Iq8Bx0sT7gZSgmY5WP0+r
         2lAw==
X-Gm-Message-State: AOAM533Dio6rIfmrVrh3X+hwU5GGzd2g/qozKpFu/O41L+xFTV79/EiD
        VSjLtnpNKBQiqttlaJQpHtgk2wWqFaKvLLG4zOdNFhUQAwGIYk1OC4rtIByc+qnEX7aOlvB+Sgx
        QYzQE3wKZVQ+3ZYGUog0PQaSwNuRFtFeEd4pqABzagzhBXbVfa6f2OhG+++N8O8VA
X-Received: by 2002:a50:cf8b:: with SMTP id h11mr3445434edk.294.1607017710433;
        Thu, 03 Dec 2020 09:48:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbq9iUB601y/81BtWCQaauRR3Qe+Lnqa1Xti3s3GfReypghATFDUjkGB7DYYxtDRaRwXJYmA==
X-Received: by 2002:a50:cf8b:: with SMTP id h11mr3445417edk.294.1607017710191;
        Thu, 03 Dec 2020 09:48:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j22sm1138000ejy.106.2020.12.03.09.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:48:29 -0800 (PST)
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com>
 <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
 <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com>
 <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71f1c9c0-b92c-76f9-0878-e3b8b184b7f0@redhat.com>
Date:   Thu, 3 Dec 2020 18:48:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/20 16:31, Aaron Lewis wrote:
> On Mon, Nov 9, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 09/11/20 17:58, Aaron Lewis wrote:
>>>> Signed-off-by: Aaron Lewis<aaronlewis@google.com>
>>>> Reviewed-by: Alexander Graf<graf@amazon.com>
>>>> ---
>>>>    tools/testing/selftests/kvm/.gitignore        |   1 +
>>>>    tools/testing/selftests/kvm/Makefile          |   1 +
>>>>    tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
>>>>    .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
>>>>    4 files changed, 564 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
>>>>
>>> It looks like the rest of this patchset has been accepted upstream.
>>> Is this one okay to be taken too?
>>>
>>
>> I needed more time to understand the overlap between the tests, but yes.
>>
>> Paolo
>>
> 
> Pinging this thread.
> 
> Just wanted to check if this will be upstreamed soon or if there are
> any questions about it.

Yes, I'm queuing it.  Any objections to replacing x86_64/user_msr_test.c 
completely, since this test is effectively a superset?

Paolo

