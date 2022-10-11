Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1325FBA57
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJKS1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJKS1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:27:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DD51145
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:27:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 70so13202179pjo.4
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ebGGC0NAmauO3EAUTF/tm6oMVpDDaZatbkgPrqxFras=;
        b=GlgRgcwDvjxObgvTI70Tlr7IzIJv1UkUEANHR6ip/gHAXYJhLVWsgK1Lot7d4uYSS5
         VK+xiuimBr21UUc4RWkWslL4o/cUUwGMTg9eXQTbx9n02z8zST+MXbJBzBvLJaGegF/8
         ta10Xg5vyPAao7yHfSm7IVRUNlLm9QnlEswEUSYSuNewyzmCK663vB6BHM8ufViBDfIr
         RPk4usg081ev9lUrvELQ2yB25vpxZCKb1WJ1soCx1LnFa6xo7aGCS6hegTLZgZDypzgh
         7ucMI8PWOlcRUTgSm09dkrGD9IbWtW3T9A1t/12lH97i9lEPhbYqBSp1/6/f/b9Y0gWa
         2KgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebGGC0NAmauO3EAUTF/tm6oMVpDDaZatbkgPrqxFras=;
        b=5WNJjm1d+ZvLstih27M7Ek8qUYvrZwkuqvhVlasHnplh0TLkle935Es75C/VzSMwMY
         KiuCU6RwifMFN27yIQizJLZC+Lc1wgGACE8JvIsIFQs4/O/wf3ERgvKa75+vMpkqX3jC
         JOkOLniRSL1KC4DrDXQmuwqJVKhX7+U5i4jyE3w/62N9d3xxL6UmEU12ZfMxNH3SazLF
         /IH7geKZXvF42teNOni9/VYPyX4dCF9gbBJvyCIEqSUN0S6k2dU9HoaCUKLGKSPU+Uee
         qD/tUGmCxj13ULIpWxNzdFjBivzi0Qg2S7J/gXS/kS5uiVSA9PlVMCM3Pk1jNPINEQtt
         ilaQ==
X-Gm-Message-State: ACrzQf0LxVds3YZn/tzID0KtItCkOhhH+SNv992G3K+BeZM1RX588aGV
        uiDL9ALC+qGb+Frr52oC0qLvAQ==
X-Google-Smtp-Source: AMsMyM6nrvaQW2cCWAsEFCFoHeVipwMXsJX9upWmvXGNn0Gv5i+zGMxN1C7h4hSyGj4KpDxvImJteQ==
X-Received: by 2002:a17:903:22c2:b0:178:3c7c:18af with SMTP id y2-20020a17090322c200b001783c7c18afmr25787806plg.134.1665512820634;
        Tue, 11 Oct 2022 11:27:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a8b8900b001f8c532b93dsm8365409pjn.15.2022.10.11.11.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 11:27:00 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:26:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0W1cABIcI1FpDkc@google.com>
References: <Y0Rehzc6VbnOGIwF@google.com>
 <gsntczay2pqh.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntczay2pqh.fsf@coltonlewis-kvm.c.googlers.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Sep 12, 2022, Colton Lewis wrote:
> > > Implement random number generation for guest code to randomize parts
> > > of the test, making it less predictable and a more accurate reflection
> > > of reality.
> 
> > > Create a -r argument to specify a random seed. If no argument is
> > > provided, the seed defaults to 0. The random seed is set with
> > > perf_test_set_random_seed() and must be set before guest_code runs to
> > > apply.
> 
> > > The random number generator chosen is the Park-Miller Linear
> > > Congruential Generator, a fancy name for a basic and well-understood
> > > random number generator entirely sufficient for this purpose. Each
> > > vCPU calculates its own seed by adding its index to the seed provided.
> 
> > Why not grab the kernel's pseudo-RNG from prandom_seed_state() +
> > prandom_u32_state()?
> 
> The guest is effectively a minimal kernel running in a VM that doesn't
> have access to this, correct?

Oh, I didn't mean link to the kernel code, I meant "why not copy+paste the kernel
code?".  In other words, why select a different RNG implementation than what the
kernel uses?  In general, selftests and tools try to follow the kernel code, even
when copy+pasting, as that avoids questions like "why does the kernel do X but
selftests do Y?".  The copy+paste does sometimes lead to maintenance pain, e.g. if
the copied code has a bug that the kernel then fixes, but that seems unlikely to
happen in this case.
