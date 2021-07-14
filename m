Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E503C8A0D
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGNRuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 13:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhGNRuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 13:50:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF228C06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 10:47:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso4355169pjz.1
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 10:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/9pS1QCv9xpqY6zBCLWOgW4Q4GovlrCgOON/GP7k/MM=;
        b=Gz8IK/zPySNLRA9LzukO74GvNd7If2jgfUZU2DUeZ3TGBlnpnsrQrlGMqOcsv7/amR
         vPoYn/B13dKV1duqUnsuYByAVZS5Oq0Pt7nED44iL1erSdzPULHEoIcPL/v4qdeOkH20
         0pbxHkuNEmstHDSkh6wdT3wACC9+ckfe77X7GcTwBpWOHL9axtd5EfYWvmzLs/e7lZ2p
         eUWbrGjRGqkpuMzHszTpcLD7JaAxZe5XavWxm+wZ5no8wEeOjYa9bbKHzQkIQH9iQ21o
         SlOxujX1fLDDY+Cv6vKEeWxk1eRjQumfFe07xwKJ3//lcPNB+jdZYY1KC1dz8JrsfK7j
         4uuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/9pS1QCv9xpqY6zBCLWOgW4Q4GovlrCgOON/GP7k/MM=;
        b=XcgX6xvQT+HpcPdzyF34NPXpoVuRfW39r5er1/iEIV9cL8TIS99KKhyWjIiDpDR2o6
         lKm1NAeXQXIfULCEVklPjHV29dC90WqfOHW4xqpgdFIt31KPyv87hqib7m10eWCdi+x/
         qHseg+abR58gaJ6pd5MqVhqdkBwcg20arwRK/E7EpiXY9ukscj5R9Fim1P5O/FZ/YvfI
         WDsYXdb9qzZK8AzNFn1AQY7dSiuo/yAohZEupbf20GmI/s0Lzcj1UloFKOA/vBQM7deq
         Ul1ddBmR0915OJgu4mMIzhh8UKEOpjyaNmUTTYUiq/Q2gTTTc/gjYy0Cdwrjv1P9Up0l
         0WwA==
X-Gm-Message-State: AOAM532u/csHbyr9dBcPX+Y3WmN1KMvryOTxvKp5sCtNGnOU46CSQJZq
        kYj6LmHN+8n01aLGrbqn/ih2KA==
X-Google-Smtp-Source: ABdhPJxg4D1y8Sj9rVBv04R+sLhAh7a7fMtuK9QDtH+fvY8IszXx7xFpeDh3rYaZJ67mxx9XbSbByA==
X-Received: by 2002:a17:90a:710a:: with SMTP id h10mr4844569pjk.103.1626284867227;
        Wed, 14 Jul 2021 10:47:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10sm3615500pfg.160.2021.07.14.10.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 10:47:46 -0700 (PDT)
Date:   Wed, 14 Jul 2021 17:47:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
Message-ID: <YO8jPvScgCmtj0JP@google.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com>
 <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14, 2021, harry harry wrote:
> > Heh, because the MMUs are all per-vCPU, it actually wouldn't be that much effort
> > beyond supporting !TDP and TDP for different VMs...
> 
> Sorry, may I know what do you mean by "MMUs are all per-vCPU"? Do you
> mean the MMUs walk the page tables of each vCPU?

No, each vCPU has its own MMU instance, where an "MMU instance" is (mostly) a KVM
construct.  Per-vCPU MMU instances are necessary because each vCPU has its own
relevant state, e.g. CR0, CR4, EFER, etc..., that affects the MMU instance in
some way.  E.g. the MMU instance is used to walk guest page tables when
translating GVA->GPA for emulation, so per-vCPU MMUs are necessary even when
using TDP.

However, shadow/TDP PTEs are shared between compatible MMU instances.  E.g. in
the common case where all vCPUs in a VM use identical settings, there will
effectively be a single set of TDP page tables shared by all vCPUs.
