Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7648CDCC
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 22:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiALVaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 16:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiALV3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 16:29:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667C7C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:29:54 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c3so6252284pls.5
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 13:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9/6LdT7clWbhj3g0oaPqru8a+FxuDPhGBh6SwjfBjFY=;
        b=KbhzU48CpLCcDiSSS1g7JHa1srdx449cyfHI9ksB5svS5hIhDU6hAnR1DklatqfcR0
         nFSJPG9mSGMOzL243yCAnKlOEl8YICpst9lCa8xR9eG/o0YBa2vEvO/g7YmyqNV0CJvW
         eg0XkKD0fjFILc99WvR2L6vONQOa0mgsLuWRYT3HHjhcFVyNdgtAmdsyqol20pbnZpQ3
         Tu/ZOCj0tilGXxa8LIRO2p7YwFSk7EXdw1VyEe3YRNKrr7AYZngrNrIHrsvPcJ+IjHEZ
         BIQsZDeU99AjFlSB0qGhECmAB6odYnSdektnD0XGKSiVOJiUST8kyCvI8cvEFQ+KI9u+
         dU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9/6LdT7clWbhj3g0oaPqru8a+FxuDPhGBh6SwjfBjFY=;
        b=jRJsjPTTYNytQkxWwEzAOVowIehipyPv4g37fVqP2Qwq9JW1ZdtORh3Wms93u/XNJX
         sZbRBfe7+pGhWQJP/SEhEj9QZj0TO+3wlp8WJpQ9HCjf9LFpI8K6j+dyC23cljgZBHdX
         1ssBDbRiEyp5Tmho2/Ga+1mx3cNW9FXSNLeYeX9Wue0j2ZpLZNs+El0UvCZOErjBomuH
         zvRgT04GJ4kAhU3zDulWl1vQ7jjZmURDPCuwWSBS6wt2G/m4dJZ58ibI+4N51IVX/mdp
         v69rrdiZHoAg4iryr9dBFNlR4yDt7RJ0HBuhEC5MMc82RFOHxzr/iTdzLftzdXH4uXbV
         A0Dg==
X-Gm-Message-State: AOAM533hc/7uJcUEQfb5BM/1LI9Bpc1T1FqbWrYvsF4RLY0kkIrk6ygF
        4XluM5JY8lBldfNV8BNYE4ULh8XiZDJcfA==
X-Google-Smtp-Source: ABdhPJwvEgRRix7ZqSyLneWQn8eQVOtdrPfgWjDmNltbLQSQNLrD8JHWJjgN6lKVLqMJU+AkfOSmZw==
X-Received: by 2002:a62:2f86:0:b0:4bc:fe4d:4831 with SMTP id v128-20020a622f86000000b004bcfe4d4831mr1226243pfv.23.1642022993756;
        Wed, 12 Jan 2022 13:29:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r11sm524977pff.81.2022.01.12.13.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 13:29:53 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:29:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit
 tests for nSVM
Message-ID: <Yd9ITZv48+ehuMsx@google.com>
References: <20211229062201.26269-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Aaron, and +Paolo who may or may not subsribe to kvm@ :-)

On Wed, Dec 29, 2021, Manali Shukla wrote:
> This series adds 3 KVM Unit tests for nested SVM
> 1) Check #NM is handled in L2 when L2 #NM handler is registered
>    "fnop" instruction is called in L2 to generate the exception
> 
> 2) Check #BP is handled in L2 when L2 #BP handler is registered
>    "int3" instruction is called in L2 to generate the exception
> 
> 3) Check #OF is handled in L2 when L2 #OF handler is registered
>    "into" instruction with instrumented code is used in L2 to
>    generate the exception

This is all basically identical in terms of desired functionality to existing or
in-flight nVMX tests, e.g. vmx_nm_test() and Aaron's vmx_exception_test() work[*].
And much of the feedback I provided to Aaron's earlier revisions applies to this
series as well, e.g. create a framework to test intercpetion of arbitrary exceptions
instead of writing the same boilerplate for each and every test.

It doesn't seem like it'd be _that_ difficult to turn vmx_exception_test into a
generic-ish l2_exception_test.  To avoid too much scope creep, what if we first get
Aaron's code merged, and than attempt to extract the core functionality into a
shared library to reuse it for nSVM?  If it turns out to be more trouble then its
worth, we can always fall back to something like this series.

[*] https://lore.kernel.org/all/20211214011823.3277011-1-aaronlewis@google.com
