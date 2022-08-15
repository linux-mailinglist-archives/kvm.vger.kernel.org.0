Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA96594EDD
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiHPCw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiHPCwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:52:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363107E02F
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:22:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso15809056pjo.1
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4qR24wezB7XIRlvkETA/N7hT8rAPhGQSgUyjo2ZKxB8=;
        b=jDLc3zBHP8SIyt9maXsLdiecLEpzeenXTuoAhbCOraWlinvnPSMpU1XtED2FY69va+
         Sc6vLmAM5znnAb5VemkidVqifnTO6fryHK/zcxkXgEkbgkz1hhVFhPw3PEhXcRgaGeQU
         ewm/LgFd0d6ed/DQ7qW3iMxhYTcieFYLzpeSWzbKte3YUDyjm8oWjEXNQiYKgSGP/BNn
         3naP2+de/18KxoCkpPnmkaXjVfDhHlfQM3itQqTnJRO1EXyOcd03bzc8Sbv07KJRdjl8
         BvMsj0ILb/0lHOJKf5LJpPHpyjWAYl6ymCIEyA8qtL0D7W3h2IOnzJxlLmhWTCKtH2Kx
         Bzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4qR24wezB7XIRlvkETA/N7hT8rAPhGQSgUyjo2ZKxB8=;
        b=DhJGVY2XCIA/QDc0QPsAZcbCjGKCW2GSRepWBQ7TTNf7jHAO4Al2U1WP3kNwA7XtiF
         z2GbWomcrom/wUOovkCyOX2y9nQUiPHc+ffr0JsBM0BoydQZt/1qJnrsXFo8CZHMCGRH
         TE4TpZfAi7F6Kn/QE9Il+EQdT1OQNjBEBLgQRyMzysdQq/y2ihnPUBJObJ2Xc75PBrbe
         KLCz/rcJq0wxv8Fo++vyWc6DG9HA8awrRvCEcDWSwCTJ2zQ6NxPr0SfrSdORJcEAqg32
         nnPLlFMIgXjm1q7dHa1iY0NVPZFPuwMnpxU4ayGetTYMSHEjeM8ehHaY4UiDznRu+Pke
         WK7A==
X-Gm-Message-State: ACgBeo0ttSTi2oJBQDlHeD6vpZqWhMnVq7ROHpS/4nnwgbL7maIV0qD6
        +fQFXTX85QwHzFO2EBXHoYSH7w==
X-Google-Smtp-Source: AA6agR67FDv0ahWYbqJlGdfmccXGi2J7JhtNduZITfHHAjHHuwLBGmN0nDKXf/EqxUf/PwJWzihYPw==
X-Received: by 2002:a17:902:b114:b0:16e:f1e0:51da with SMTP id q20-20020a170902b11400b0016ef1e051damr9214135plr.0.1660605743263;
        Mon, 15 Aug 2022 16:22:23 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090276c400b0016c09a0ef87sm7490714plt.255.2022.08.15.16.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 16:22:22 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:22:17 -0700
From:   David Matlack <dmatlack@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Use TEST_REQUIRE() in nx_huge_pages_test
Message-ID: <YvrVKbRAoS1TyO44@google.com>
References: <20220812175301.3915004-1-oliver.upton@linux.dev>
 <YvaWKUs+/gLPjOOT@google.com>
 <YvanIQoL3Y3TlxPB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvanIQoL3Y3TlxPB@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 07:16:49PM +0000, Oliver Upton wrote:
> On Fri, Aug 12, 2022 at 11:04:25AM -0700, David Matlack wrote:
> > On Fri, Aug 12, 2022 at 05:53:01PM +0000, Oliver Upton wrote:
> > > Avoid boilerplate for checking test preconditions by using
> > > TEST_REQUIRE(). While at it, add a precondition for
> > > KVM_CAP_VM_DISABLE_NX_HUGE_PAGES to skip (instead of silently pass) on
> > > older kernels.
> > > 
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 24 +++++--------------
> > >  1 file changed, 6 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > index cc6421716400..e19933ea34ca 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > @@ -118,13 +118,6 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
> > >  	vm = vm_create(1);
> > >  
> > >  	if (disable_nx_huge_pages) {
> > > -		/*
> > > -		 * Cannot run the test without NX huge pages if the kernel
> > > -		 * does not support it.
> > > -		 */
> > > -		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> > > -			return;
> > > -
> > >  		r = __vm_disable_nx_huge_pages(vm);
> > >  		if (reboot_permissions) {
> > >  			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> > > @@ -248,18 +241,13 @@ int main(int argc, char **argv)
> > >  		}
> > >  	}
> > >  
> > > -	if (token != MAGIC_TOKEN) {
> > > -		print_skip("This test must be run with the magic token %d.\n"
> > > -			   "This is done by nx_huge_pages_test.sh, which\n"
> > > -			   "also handles environment setup for the test.",
> > > -			   MAGIC_TOKEN);
> > > -		exit(KSFT_SKIP);
> > > -	}
> > > +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
> > 
> > This cap is only needed for run_test(..., true, ...) below so I don't think we should require it for the entire test.
> 
> It has always seemed that the test preconditions are a way to pretty-print
> a failure/skip instead of having some random ioctl fail deeper in the
> test.
> 
> If we really see value in adding predicates for individual test cases
> then IMO it deserves first-class support in our framework. Otherwise
> the next test that comes along is bound to open-code the same thing.

Fair point.

> 
> Can't folks just update their kernel? :-)

Consider my suggestion optional. If anyone is backporting this test to
their kernel they'll also probably backport
KVM_CAP_VM_DISABLE_NX_HUGE_PAGES ;). So I don't think there will be a
huge benefit of making the test more flexible.

That aside,

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> --
> Thanks,
> Oliver
> 
> > That being said, it still might be good to inform the user that the test is being skipped. So perhaps something like this:
> > 
> >   ...
> >   run_test(reclaim_period_ms, false, reboot_permissions);
> > 
> >   if (kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> >           run_test(reclaim_period_ms, true, reboot_permissions);
> >   else
> >           print_skip("KVM_CAP_VM_DISABLE_NX_HUGE_PAGES not supported");
> >   ...
> > 
> > > +	TEST_REQUIRE(reclaim_period_ms > 0);
> > >  
> > > -	if (!reclaim_period_ms) {
> > > -		print_skip("The NX reclaim period must be specified and non-zero");
> > > -		exit(KSFT_SKIP);
> > > -	}
> > > +	__TEST_REQUIRE(token == MAGIC_TOKEN,
> > > +		       "This test must be run with the magic token %d.\n"
> > > +		       "This is done by nx_huge_pages_test.sh, which\n"
> > > +		       "also handles environment setup for the test.");
> > >  
> > >  	run_test(reclaim_period_ms, false, reboot_permissions);
> > >  	run_test(reclaim_period_ms, true, reboot_permissions);
> > > 
> > > base-commit: 93472b79715378a2386598d6632c654a2223267b
> > > -- 
> > > 2.37.1.595.g718a3a8f04-goog
> > > 
