Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4C292662
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgJSLcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 07:32:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgJSLcG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 07:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603107125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ptl7vRIaOfhTh1SxbIQwG+fPk66SVT/MuKx0UtvcdXc=;
        b=RRSZrOUGkInqH8lyloD3Bc3I7Qr9824w1PFHCLx7kwM+PyO8WJUYy9b1z2IXyWBny3fMcK
        wMgNFicA+omWRqHlqh3yHP9DhHyakXMchbABRtFF1MYWl+Ne43A+uj1ioGiL5V2lET08y1
        mJXVZ1RsdoA1R7suk7KBjLVbJvUqGWQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-t0p5fOd6MnimLITatBXUEw-1; Mon, 19 Oct 2020 07:32:03 -0400
X-MC-Unique: t0p5fOd6MnimLITatBXUEw-1
Received: by mail-wr1-f70.google.com with SMTP id 33so7233068wrf.22
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 04:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ptl7vRIaOfhTh1SxbIQwG+fPk66SVT/MuKx0UtvcdXc=;
        b=Wptsl+ycj4qIX69eH8UjXWXxLSPbZPMlIlgA8LaSqJEBgE+oeRM0q1jtRWe4DI9HlX
         eotDTMnJm6qSDUfda02h5oCUciKmuN5dF5gsIS9ONMYg85GZeJAglVLF+THByflwvqnf
         ZATkKmGhjFTG1XBUd1W1ZalqFdxUpOE+yhOAvNWBoQNMaYwnCVi+gC3Alk61wh2yz2wB
         STSmPaiz4Bc9Srg9rK8+nGrgMgRywt4Mcc3naEYDFD6bSDUKBmLYQJcbBmL1EFlCTe9m
         o3A1q7UNmuYfLKIYZqQXdcVaww2uK1lGMyDCuhoouskeLV0qg3AnFGmkVFl8ix+e5dw2
         a5HQ==
X-Gm-Message-State: AOAM53039ucjphG+Rf9yPe9bj1NbPuwElg9G+kfLPASyB90UB6FjtOql
        DRV+3+F/PgZyJpReOzS5geWkWgOlE8UOP85r0z3zFTll/qduGsfbs0xwEPXKfvfZdqnuVOqNF1M
        GAMV9Oq7vyt5k
X-Received: by 2002:a5d:54c8:: with SMTP id x8mr18532418wrv.286.1603107122089;
        Mon, 19 Oct 2020 04:32:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1UlYRDR2wC2GRdawB5/xH5ms9+5r1dpNboENJ7L6TOK3IsUWj+pQ+6TsdSBPm36GqVsDrWA==
X-Received: by 2002:a5d:54c8:: with SMTP id x8mr18532398wrv.286.1603107121855;
        Mon, 19 Oct 2020 04:32:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q10sm17306696wrp.83.2020.10.19.04.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 04:32:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic test
In-Reply-To: <20201015163539.GA27813@linux.intel.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com> <87d01j5vk7.fsf@vitty.brq.redhat.com> <20201015163539.GA27813@linux.intel.com>
Date:   Mon, 19 Oct 2020 13:32:00 +0200
Message-ID: <87o8ky4fkf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Oct 15, 2020 at 05:59:52PM +0200, Vitaly Kuznetsov wrote:
>> Po-Hsu Lin <po-hsu.lin@canonical.com> writes:
>> 
>> > We found that on Azure cloud hyperv instance Standard_D48_v3, it will
>> > take about 45 seconds to run this apic test.
>> >
>> > It takes even longer (about 150 seconds) to run inside a KVM instance
>> > VM.Standard2.1 on Oracle cloud.
>> >
>> > Bump the timeout threshold to give it a chance to finish.
>> >
>> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>> > ---
>> >  x86/unittests.cfg | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> > index 872d679..c72a659 100644
>> > --- a/x86/unittests.cfg
>> > +++ b/x86/unittests.cfg
>> > @@ -41,7 +41,7 @@ file = apic.flat
>> >  smp = 2
>> >  extra_params = -cpu qemu64,+x2apic,+tsc-deadline
>> >  arch = x86_64
>> > -timeout = 30
>> > +timeout = 240
>> >  
>> >  [ioapic]
>> >  file = ioapic.flat
>> 
>> AFAIR the default timeout for tests where timeout it not set explicitly
>> is 90s so don't you need to also modify it for other tests like
>> 'apic-split', 'ioapic', 'ioapic-split', ... ?
>> 
>> I was thinking about introducing a 'timeout multiplier' or something to
>> run_tests.sh for running in slow (read: nested) environments, doing that
>> would allow us to keep reasonably small timeouts by default. This is
>> somewhat important as tests tend to hang and waiting for 4 minutes every
>> time is not great.
>
> I would much prefer to go in the other direction and make tests like APIC not
> do so many loops (in a nested environment?). The port80 test in particular is
> an absolute waste of time.

I don't think these two suggestions are opposite. Yes, making tests run fast
is good, however, some of the tests are doomed to be slow. E.g. running
VMX testsuite while nested (leaving aside the question about who needs
three level nesting) is always going to be much slower than on bare metal.

>
> E.g. does running 1M loops in test_multiple_nmi() really add value versus
> say 10k or 100k loops?

Oddly enough, I vaguely remember this particular test hanging
*sometimes* after a few thousand loops but I don't remember any
details.

-- 
Vitaly

