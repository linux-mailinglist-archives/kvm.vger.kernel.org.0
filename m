Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B685FF4F6
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJNVEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJNVEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:04:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC941DC4F3
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:04:03 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so5877335pjl.0
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FEPtKNTg7NezEV8TRfsVFDaZ2fJ2JKYBjP7uR8dhm+Q=;
        b=ghXdUokTFObMpYmEMyA5TGYHsb9p1yIdHyjKldJRnv8meEPZNLqDb6gaJC6CS3gCAU
         wKI/E9fp70U4GxOlUa9Tk49BfJ7YtDWHwV8siA1GOD5deWy8f1N9GPDcWEsqIoiobPr9
         cm18E706gRnczeSjs9KGMfnvsmBMRsFeBo5SFCK188aD8A0ErFSk0GNNO02uA7nPyrs7
         wAp1Q2/XdVvr5ekyAAwiJhTM/tinI0cw7rq0wFvrap7tnezgLnqlm1o+eFSi8REqPquv
         HCV5HrFWGZK2V9XrRGF08TekR6EyyL9a10mSlEBNtNAZG8s94GAn2iSkGRcZub6dcdYW
         xbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEPtKNTg7NezEV8TRfsVFDaZ2fJ2JKYBjP7uR8dhm+Q=;
        b=RLKaCpOJd8gfZUtI2J9YabPTtoBQzvmrHHOcNRWje8oUius4YLa1VcHZ+FQ9D7+UHd
         1pLWghuKOi2vM5viGd25HM7N5bgtZsy0FTBdpo6UrSixaxO+kt/zwjmHrIeEBLXrs8P9
         NDlpNwuasGme/cQJfGoKOe0ycObqoFwyShbCpCxUbrigvmLReYjI7ZloyA43ZThIRf7d
         ZOd3lFDxt0YX8enwqCA9RDSO6IkSTy4wx3y618pp9kPCwV3uvrxisx0yvB0WBYUry1tm
         mcWPZJl/UdfabG6l0gCXbSDVhxaYm0xlev4hIANTNXDhvfobk838rBw21NBC3a/lQabo
         NtqA==
X-Gm-Message-State: ACrzQf3fa9E15stQReIye88TiZzASp90ZAl3g20ha6Xb9pEIKd5BXIMg
        Vv/BkwaLLw2BKTMDhhtsR5qOGw==
X-Google-Smtp-Source: AMsMyM5JdhDG1UpOFIQKo1Xnh0Iup3kp8kSlAUfnxdMjkyOeWnzbt+R+akO078ePfB3UOfdracdJ7Q==
X-Received: by 2002:a17:902:9684:b0:17e:71b2:bd16 with SMTP id n4-20020a170902968400b0017e71b2bd16mr7234080plp.163.1665781443064;
        Fri, 14 Oct 2022 14:04:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b30-20020aa78ede000000b0053e6eae9665sm2253296pfr.140.2022.10.14.14.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:04:02 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:03:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Use TAP in some more KVM selftests
Message-ID: <Y0nOv6fqTe2NnPuu@google.com>
References: <20221004093131.40392-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004093131.40392-1-thuth@redhat.com>
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

On Tue, Oct 04, 2022, Thomas Huth wrote:
> Many KVM selftests are completely silent. This has the disadvantage
> for the users that they do not know what's going on here. For example,
> some time ago, a tester asked me how to know whether a certain new
> sub-test has been added to one of the s390x test binaries or not (which
> he didn't compile on his own), which is hard to judge when there is no
> output. So I finally went ahead and implemented TAP output in the
> s390x-specific tests some months ago.
> 
> Now I wonder whether that could be a good strategy for the x86 and
> generic tests, too?

Taking Andrew's thoughts a step further, I'm in favor of adding TAP output, but
only if we implement it in such a way that it reduces the burden on writing new
tests.  I _really_ like that sync_regs_test's subtests are split into consumable
chunks, but I worry that the amount of boilerplate needed will deter test writes
and increase the maintenance cost.

And my experience with KVM-unit-tests is that letting test writers specify strings
for test names is a bad idea, e.g. using an arbitrary string creates a disconnect
between what the user sees and what code is running, and makes it unnecessarily
difficult to connect a failure back to code.  And if we ever support running
specific testcases by name (I'm still not sure this is a net positive), arbitrary
strings get really annoying because inevitably an arbitrary string will contain
characters that need to be escaped in the shell.

Adding a macro or three to let tests define and run testscases with minimal effort
would more or less eliminate the boilerplate.  And in theory providing semi-rigid
macros would help force simple tests to conform to standard patterns, which should
reduce the cost of someone new understanding the test, and would likely let us do
more automagic things in the future.

E.g. something like this in the test:

	KVM_RUN_TESTCASES(vcpu,
		test_clear_kvm_dirty_regs_bits,
		test_set_invalid,
		test_req_and_verify_all_valid_regs,
		test_set_and_verify_various_reg_values,
		test_clear_kvm_dirty_regs_bits,
	);
