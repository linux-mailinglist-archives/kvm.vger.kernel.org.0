Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0AEB55CE
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfIQS7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 14:59:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35604 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfIQS7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 14:59:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id y21so4426243wmi.0
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ELIQh6IWfVdqaS8EqVoPumHZcxFuhZ9B2s+JIfk9bEk=;
        b=sHkNVVSNsleS5vw2i1Ja86o/PcSxhphsasx/uqFli/HY665c9agLNbBT8X96+L1Uo0
         Q+nMjkAuiYK9yiE5HV7vrBIQ+dLHJSS8PJ7lmGqXYvYhjST67hseahNWY2zKyuDgttH+
         Fexorq5QFqCletDn1Hgo3UjYoqPOZHxZKCgRRPL00pN6utEfWw5b6vrONy5nW5tV96gB
         XBJH75CNPrJhcf15wgZOxG8kovzNqF4B/eEuPS6+xWkAzwerrdzmu3H1x3vhWy506h5u
         s48hw7r8jvVtsB/QHcLWQxva5kVs3EtCI+T2kT7D9jgImpn7MpBRCNvd+TfV4hQy6sR/
         Jcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ELIQh6IWfVdqaS8EqVoPumHZcxFuhZ9B2s+JIfk9bEk=;
        b=o83h/Ft10vrd8XJ5xqetfh+ChIXwXODta3XG/GtU+SkuPTHkVMhqLU+t7tvuvMe86A
         OZjnCfXxGTXNuAdgZ/x13QjBbfY8Vl9s54MQspV55+zIt8wQ8ar9Rvp+fNvUENzYl5hg
         JxY9kyGSsg7La2PVPjLxhDEUEit4wLrKe5uFQ+/zn9grh60pUhXzpbka+GSzQcjgIfFG
         RSgc2hP9RR1zSvFEC2X9/tPNnIFvJG4W+3lzTMyo8w9xQoeMOLsXWo0BTlBEC1IQLGmS
         u0Cys4D8eESKzBc8iI4k6rYtO5SXzW6xZDD/142SuPDihyTHXybz9K+nqPtmsn9Jlj2L
         Mi0Q==
X-Gm-Message-State: APjAAAX0dZZp0kAOR/STudUrsh+ORrgIHv8qR1xqyKuV5wfu/54qgJun
        zKfo5rnGG+DLLGjKNAZl11Wds0cWgAVPiKfnPcxEyw==
X-Google-Smtp-Source: APXvYqyDSfCO/j4lCNjqIXxNRvogjY6ES3XpwtfeajFkIPESwdJtEys55YfM0+YAAFJdfQ1dh1WEZcLEWUPDV818Fek=
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr5157353wmi.151.1568746776509;
 Tue, 17 Sep 2019 11:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190914004919.256530-1-marcorr@google.com> <6537afdb-2e0e-0933-3f7d-2a474378edf5@oracle.com>
 <CAA03e5E-rv+49X_qSukGwmP2z48GR4LCMM6dp3b2_QqC3f24Sw@mail.gmail.com>
In-Reply-To: <CAA03e5E-rv+49X_qSukGwmP2z48GR4LCMM6dp3b2_QqC3f24Sw@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 17 Sep 2019 11:59:25 -0700
Message-ID: <CAA03e5G-wGeurUzCosRSSxND+2Ae9ZQAUyw8MNOi-wc+xioyTA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: nvmx: test max atomic switch MSRs
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > v1 -> v2
> > > * Replaced 2M page allocations with 128 kB allocations.
> > > * Broadly, updated test to follow Sean's draft:
> > >    * Got rid of loop + individual test cases. Instead combined all test cases.
> > >    * Got rid of configure_atomic_switch_msr_limit_test().
> > > * Updated cleanup code to free memory. I added a new helper,
> > >    free_pages_by_order() to help here.
> > > * Changed virt_to_phys() to explicit u64 cast.
> > > * Renamed original test case from atomic_switch_msr_limit_test() to
> > >    atomic_switch_max_msrs_test(). Added opt-in
> > >    atomic_switch_overflow_msrs_test() test case to test failure code path
> > >    during VM-entry.
> > > * Fixed a bug in transitioning VMX launched state when the first
> > >    VM-entry fails.
> >
> > Can we move this bug-fix to a separate patch so that it can be
> > identified easily when searching in git history ?
>
> SGTM. I'll wait to see if there are any more comments before splitting this out.

Done.
