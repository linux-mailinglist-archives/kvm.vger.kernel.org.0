Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9057A2FBDDB
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbhASRiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 12:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731123AbhASRiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 12:38:09 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E22C061573
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:37:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id x20so335749pjh.3
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MdqFOwVOrDv/uHtp7zhA7eRG5q/biM80PO2TPXjvwKo=;
        b=pPFA+iKzu/L+bavWAJcMVzsHHZflOSQq4KTrLUQGclf2Dbg/GVhRODHVq++nqtQBCa
         vGU++txXX0DZAT6DuUrhppZqQ5NEgK528hyWpBpetd2/fCFXBZ/XLzQbvlivqYDqP0Ym
         bsL8AoZSFTytLialJnzhsI8kr0WXmxMdz11dmvg1g2KkBbzCR56QQeSgBEXYvT8yF6FB
         CC4C+mTGK0lCfUVrHOcGStp4qTFecTfIrXfa7wrO6IiQMpswJJMwTzw7Ru01RYZMOjxb
         B2s9FK398qB1qKtgpOXRwqIs2WT88iiutEwe1NGitKhPXp5ylpcZ0LUKGQHLO03yxnRl
         OVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MdqFOwVOrDv/uHtp7zhA7eRG5q/biM80PO2TPXjvwKo=;
        b=t7gfUdmq4qO2mk5kKO6SBHjV0UdxJY1gQhpVKP0KZCEqvWakt75HKoRO/DIhPHg2JE
         AD5k/LYiBsdr93XbJ37hIAAthdExIXn0SdOidg+KV5eXh6Acf6D5RrkjNMJwSNNbV5s8
         FAXIAcA/sT3Cs7MRbu3+mFM9w2zimh4bKMZkvk/sRGglcB4/TkLFB4xDbYJIwX9Q/8RQ
         seUVJnYpx31xibhGRx69WKsUpFYV+DnwXT4KcsOHG7336Fwtk1GGEEWJQDNf72/iiPdL
         SW1Nl5bmoz24Tb2R3KGB2cXikgNGz0HZ+DmVKNdgiMFox2m8f/pOS0EqtChWluxz623R
         Y/Tg==
X-Gm-Message-State: AOAM5336iwz4FHkevSk3+fXpOex6FvGfq8wZPUKEA8TBK4gURD6wyovu
        Qew5VCsLCWdCsZwXxASBNmZ/OA==
X-Google-Smtp-Source: ABdhPJweqnR4okQhtyD4rMeuhLq1nWF87H03P3+0KTSPq6NaIFgceeFGmFiK1hq7HNKwvLxnHbv4qw==
X-Received: by 2002:a17:90a:e38a:: with SMTP id b10mr874146pjz.12.1611077846917;
        Tue, 19 Jan 2021 09:37:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p13sm3926797pju.20.2021.01.19.09.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 09:37:26 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:37:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <YAcYz4nxVXHKfkXu@google.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
 <20210118110944.vsxw7urtbs7fmbhk@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118110944.vsxw7urtbs7fmbhk@kamzik.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021, Andrew Jones wrote:
> On Thu, Jan 14, 2021 at 12:13:22PM -0800, Sean Christopherson wrote:
> > On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> > > On 12/01/21 23:28, Sean Christopherson wrote:
> > > > What's the biggest hurdle for doing this completely within the unit test
> > > > framework?  Is teaching the framework to migrate a unit test the biggest pain?
> > > 
> > > Yes, pretty much.  The shell script framework would show its limits.
> > > 
> > > That said, I've always treated run_tests.sh as a utility more than an
> > > integral part of kvm-unit-tests.  There's nothing that prevents a more
> > > capable framework from parsing unittests.cfg.
> > 
> > Heh, got anyone you can "volunteer" to create a new framework?  One-button
> > migration testing would be very nice to have.  I suspect I'm not the only
> > contributor that doesn't do migration testing as part of their standard workflow.
> >
> 
> We have one-button migration tests already with kvm-unit-tests. Just
> compile the tests that use the migration framework as standalone
> tests and then run them directly.

Do those exist/work for x86?  I see migration stuff for Arm and PPC, but nothing
for x86.

> I agree, though, that Bash is a pain for some of the stuff we're trying
> to do. However, we do have requests to keep the framework written in Bash,
> because KVM testing is regularly done with simulators and even in embedded
> environments. It's not desirable, or even possible, to have e.g. Python
> everywhere we want kvm-unit-tests.

True, I would probably be one of the people complaining if the tests started
requiring some newfangled language :-)
