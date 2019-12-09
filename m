Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5BE117271
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfLIRIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:08:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726230AbfLIRIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575911284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hc7Y6g0yjTZ9XoXaqWide8ysWgzKcR0UkXKsv7vM0Ns=;
        b=dm1kNFFNRPiAZlD8LC2o3Qso0QxSUzugV2Vv4KOQap4uPp/bWB2W15+xF6DnqTDkcMWGNK
        wke6Qgyp08huOjEqPzKEmEHu/jYbPdfDL3CT4GMWFEVjW1KHhORp9tq4ixfbCt7DimEuuF
        OrczBUDLBeU7oxUrPEhhQQtwH34mHS0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-gbnqPQ7FMamynVquXlDrDA-1; Mon, 09 Dec 2019 12:08:01 -0500
Received: by mail-wm1-f70.google.com with SMTP id l13so13137wmj.8
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hc7Y6g0yjTZ9XoXaqWide8ysWgzKcR0UkXKsv7vM0Ns=;
        b=Qu8w7ex6uGUBotCdSbZZm3rVi6gp47fokVb8hahehXqDqi8JDpRN4qGhjrImEKDfq6
         Gj/O0rZdAHHD4eovxNhsTCKQ9CNi8WpWItPnsGkQP0WSipuC1nmtpcqb4bHJb79CtuRW
         No0x3pr0BAZ33iugL+oekAE5xIbt1KSiEKGvV1SFqkYdIwZ1p1U25hO+YnSf81Orp2AP
         s3olin3RvurjJuWZMv7OZbl8y3n+H9QSDHrmG6hh9+GkgV46mWLi8eHwWRN6jlD8TLBt
         nPOUNXSCTEEZ+aJkK+yBl3YyVkUYcSFQfUCGLIOGlDAwpeA9NHPfAMLS1aSJyho+zyy1
         nb0Q==
X-Gm-Message-State: APjAAAXLhpka/eK4L64Ewu6iWHa+TW1cBKTvLTSmEqYRdZ+kDXcP9NCe
        sbUM/1R95VGQfrfFv8eIRrLt6HWMksY7HXKTVcCHKwaIWWJs+qRJGkXK29MHfss9Wfm7IAMwL/E
        8Q8KrHsGMehYI
X-Received: by 2002:adf:fc4b:: with SMTP id e11mr3273477wrs.326.1575911280026;
        Mon, 09 Dec 2019 09:08:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxD+PP6v5nLXTHHBzsFyAqa5JV/1UiwEvWozXK8XXMHtVK8UZyMqhpjC1encwUqCyeozsPxSA==
X-Received: by 2002:adf:fc4b:: with SMTP id e11mr3273438wrs.326.1575911279694;
        Mon, 09 Dec 2019 09:07:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id t12sm63254wrs.96.2019.12.09.09.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:07:59 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Run 32-bit tests with KVM, too
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20191205170439.11607-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <699a350a-3956-5757-758c-0e246d698a7d@redhat.com>
Date:   Mon, 9 Dec 2019 18:07:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191205170439.11607-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: gbnqPQ7FMamynVquXlDrDA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 18:04, Thomas Huth wrote:
> KVM works on Travis in 32-bit, too, so we can enable more tests there.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 4162366..75bcf08 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -34,15 +34,19 @@ matrix:
>        env:
>        - CONFIG="--arch=i386"
>        - BUILD_DIR="."
> -      - TESTS="eventinj port80 sieve tsc taskswitch umip vmexit_ple_round_robin"
> +      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
> +               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"
> +      - ACCEL="kvm"
>  
>      - addons:
>          apt_packages: gcc gcc-multilib qemu-system-x86
>        env:
>        - CONFIG="--arch=i386"
>        - BUILD_DIR="i386-builddir"
> -      - TESTS="vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_mov_to_cr8
> -               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
> +      - TESTS="tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
> +               vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robin
> +               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall"
> +      - ACCEL="kvm"
>  
>      - addons:
>          apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> 

Applied, thanks.  But there are also some 32-bit specific tests
(taskswitch, taskswitch2, cmpxchg8b) that we may want to add.

Paolo

