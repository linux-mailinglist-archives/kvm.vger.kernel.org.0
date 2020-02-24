Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375B316B21D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 22:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXVWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 16:22:38 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41845 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBXVWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 16:22:37 -0500
Received: by mail-yw1-f66.google.com with SMTP id l22so5914675ywc.8
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 13:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6PxC0BCfbx3csMqVviwI+8pCKIZ0mnMxq1BJVToobLM=;
        b=eDCixjPg1Cj4kONZfEo6D2XdR/wX18fyuyJQMzSwr7LhoDss1pqjcv+8QXOor7g4/m
         gv34ckOefr7VDnkKwMIwVF0e+C21L5t3nuf5ehmZe/UVNzExqRtbfOMTb6gVLaHpAOys
         gbbZe5p5dib1x4ZI8LDSHdurHAe5yoxLkmhPyjh7q5b6FSYWFIC0vJY1s96JvOjANNrH
         Elgfz+7a+0eD9H15AYsAoU0HV4pTlgH0H3Gg1guHvvP0oh+HxvpPUL4c00OTHDogzAdn
         1AyDSXNkZalM3xV+z3yXqEoWeF/rFVqtEqt2vQH6GmogLVQq8zny6D0wJDO8JaTSwLOB
         sSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6PxC0BCfbx3csMqVviwI+8pCKIZ0mnMxq1BJVToobLM=;
        b=NS7QWSI6qbl6pzj84SQjeBi4LQDB4crUwqe4/dxd0C9wvP198NNMBy/1fUz+AWtbZz
         mttqC1ac0ufUN5F2r476K86WRUlf4GgbrjBMVhr401pbltrbQTGUBNo5U+12eikEznAb
         VhaqOzzTfXNW+yfX1ovbMu2nNwX96eRfXdWvqvmPMEnrXV/qyo4MNw+mARNBhl/Pq/AK
         Zj7eGEM9eFYur/HeSHkUHONP4qZXbr/hHkUl1TGL2iZTaRkcTOM21bboxJ8+5LbCbIRB
         eRGiMqpdpfGGOFryskjzDUej3FSbpB2JEtTMiASgQMFMIzzrpuEO0wVFWHT/rRZmPvD+
         EJIw==
X-Gm-Message-State: APjAAAVt38k8lpdNRQqv5L2ZwWpBo1S78bc87USDBoVArk1BW4OOwldR
        61f5BF3gEL8GmUiuzyYXrR0B7Q==
X-Google-Smtp-Source: APXvYqytWobHp3Rn6vYl4RGK5uX33Jz9ESjlJh0QQ1hVIhs+T9MfhBF9zAEgBwfjApYbDWUOpNLOnw==
X-Received: by 2002:a0d:d9d4:: with SMTP id b203mr45497957ywe.297.1582579356337;
        Mon, 24 Feb 2020 13:22:36 -0800 (PST)
Received: from localhost (c-75-72-120-152.hsd1.mn.comcast.net. [75.72.120.152])
        by smtp.gmail.com with ESMTPSA id o127sm132931ywf.43.2020.02.24.13.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:22:35 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:22:34 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        kvm list <kvm@vger.kernel.org>, yzt356@gmail.com,
        lkft-triage@lists.linaro.org, namit@vmware.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        jmattson@google.com
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
Message-ID: <20200224212234.m4gqvgxoqj3elni2@xps.therub.org>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
 <CA+G9fYu3RgTJ8BM3Js3_gUbhxFJrY6QTJR-ApNQtwFh+Ci0q8Q@mail.gmail.com>
 <20200224173033.GE29865@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224173033.GE29865@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:33AM -0800, Sean Christopherson wrote:
> On Mon, Feb 24, 2020 at 10:36:54PM +0530, Naresh Kamboju wrote:
> > Hi Paolo,
> > 
> > On Mon, 24 Feb 2020 at 18:36, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 24/02/20 13:53, Naresh Kamboju wrote:
> > > > FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> > > > failures, 5 skipped)
> > >
> > > This could be fixed in a more recent kernel.
> > 
> > I will keep running these tests on most recent kernels.
> > 
> > My two cents,
> > OTOH, It would be great if we have monthly tag release for kvm-unit-tests.
> > 
> > LKFT plan to keep track of metadata / release tag version of each test suites
> > and kernel branches and versions details.
> > 
> > Currently LKFT sending out kselftests results test summary on
> > each linux-next release tag for x86_64, i386, arm and arm64 devices.
> > 
> > The next plan is to enable kvm-unit-tests results reporting from LKFT.
> 
> Rather than monthly tags, what about tagging a release for each major
> kernel version?  E.g. for v5.5, v5.6, etc...  That way the compatibility
> is embedded in the tag itself, i.e. there's no need to cross reference
> release dates against kernel/KVM releases to figure out why version of
> kvm-unit-tests should be run.
> 
> Paolo more or less agreed to the idea[*], it's just never been implemented.
> 
> [*] https://lkml.kernel.org/r/dc5ff4ed-c6dd-74ea-03ae-4f65c5d58073@redhat.com

The behavior of kvm in LTS kernels will change over time. In general, as
I wrote in that original thread as well, we would much prefer to use the
latest version of kvm-unit-tests against older kernels.

I think this is a valid example (right?): v4.19 (Oct 22 2018) until now
shows 245 kvm-related patches backported:

    $ git log --oneline v4.19..v4.19.106 | grep -i kvm | wc -l
    245

Just for curiosity I took a look at patch counts per recent releases,
and it seems to average around 250 or so. This means that a 6-year
extended LTS kernel branch will likely receive several releases worth of
fixes.

    $ git log --oneline v5.1..v5.2 | grep -i kvm | wc -l
    238
    $ git log --oneline v5.2..v5.3 | grep -i kvm | wc -l
    239
    $ git log --oneline v5.3..v5.4 | grep -i kvm | wc -l
    246
    $ git log --oneline v5.4..v5.5 | grep -i kvm | wc -l
    172

Indeed, 4.9 has received almost two releases worth of changes since Dec
2016, and is scheduled to still be supported until 2023.

    $ git log --oneline v4.9..v4.9.214 | grep -i kvm | wc -l
    387

We would also like to be able to verify the additional test coverage
that may be added to kvm-unit-tests against older kernels (I assume it's
not all just new features that tests are added for?)

Dan

-- 
Linaro LKFT
https://lkft.linaro.org
