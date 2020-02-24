Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89916ACA7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgBXRHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:07:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38174 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgBXRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:07:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so10947188ljh.5
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 09:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nrrl85tfP3+j8IN2SaZuMHvzDaxDKgXRAJCCGGXQ3oo=;
        b=P50dGBcAq+SlkOGoDSY2oS7hofcdNjtWGh+DTPGGuOUoK9eE0vJbL/KQuXIGj1qekS
         03ODufalYMd22NIHZvemi+3+e82UpvLqC9eA+sdHl61c1fVmMg/F3+JGNoFcUCE5WITL
         IjdEoVVREBLltBzVfVxEbAFFRkdYl8b/wU7Eyzf8WXoRxKs4C8gMlIcDgUn5b8ddEuR3
         RbjvASTit6iGXpxDCj3H81xeph1+MBQVNHyE9Ds4t5c+R9pyCYBbkAraA9KnIKUms+pv
         qKK13Ea7LIgl/iVKKhH3mQiPV7LzuyFkwMLs1YpBZxlD41wDWAEj1ji1qJYQAdsu+uKI
         8OYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrrl85tfP3+j8IN2SaZuMHvzDaxDKgXRAJCCGGXQ3oo=;
        b=Hp/nzIC2DETAOVf7HFilLMh57Qf1OwJzC0j6hNOoulGXd/v8JQfqZnR97/D9tTQv9o
         Pb3GR4hQFLr8wReO5TBoRsWCeeoEikujq37AnWtJnvPkL77/O2Pi5J8UTbcuSKGN8e6i
         7ioxX/YM2xQIo9YbTMeL1Pf1pgY62FqXeWI5rWflZBSzUp123z0htHAP0e5NK113vh6g
         RS45i4IoOizak6VgSajwy/9EGUCM5iB3/g6xlX+SCQfgiQmofl6GpSLw/veDHZSMy6as
         pSC3exkzLLH1jJRdsR+d4OfaG2bKsuphLgBWP4pNi6oP6afWgLgmm0lUMZKRRDabyXBX
         UQMw==
X-Gm-Message-State: APjAAAWe1zBARTqbIk8VSPhPGp8JQFPZBlQge8t5gL2/lW+e0l5n8Q38
        nSuHr6XmhhCGGmGsd2iQVm2m1SWa7nueEgh2/7TT9g==
X-Google-Smtp-Source: APXvYqxaDXcsjJVgERRtdyfPTI+w786LOeE0WURSB3GipQHeXd6m0WASZb59TrjCJdtVzD289XwzYHW1Qg/gzLhcORM=
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr29492608lja.165.1582564025902;
 Mon, 24 Feb 2020 09:07:05 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
In-Reply-To: <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Feb 2020 22:36:54 +0530
Message-ID: <CA+G9fYu3RgTJ8BM3Js3_gUbhxFJrY6QTJR-ApNQtwFh+Ci0q8Q@mail.gmail.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Mon, 24 Feb 2020 at 18:36, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/02/20 13:53, Naresh Kamboju wrote:
> > [Sorry for the spam]
> >
> > Greeting from Linaro !
> > We are running kvm-unit-tests on our CI Continuous Integration and
> > testing on x86_64 and arm64 Juno-r2.
> > Linux stable branches and Linux mainline and Linux next.
> >
> > Few tests getting fail and skipped, we are interested in increasing the
> > test coverage by adding required kernel config fragments,
> > kernel command line arguments and user space tools.
>
> The remainins SKIPs mostly depend on hardware, for example "svm" only
> runs on AMD machines and "pku" only on more recent Intel processors than
> you have.

Thanks for explaining the reason for skip.

>
> > FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> > failures, 5 skipped)
>
> This could be fixed in a more recent kernel.

I will keep running these tests on most recent kernels.

My two cents,
OTOH, It would be great if we have monthly tag release for kvm-unit-tests.

LKFT plan to keep track of metadata / release tag version of each test suites
and kernel branches and versions details.

Currently LKFT sending out kselftests results test summary on
each linux-next release tag for x86_64, i386, arm and arm64 devices.

The next plan is to enable kvm-unit-tests results reporting from LKFT.

>
> Paolo
>
