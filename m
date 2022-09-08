Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174DA5B26B9
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiIHTaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 15:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiIHTan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 15:30:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2CEB0B03
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 12:30:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so3511477pji.1
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 12:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=fcvRd1O2Y/KANTtdyoesNTyIloFS4ke6vSyrx2yWl+0=;
        b=YZWQ3QL3kleCKGMOKPcZQTTSOUua7HgbvIaUm6127LKrx8FnGho8+fbe38fUZ3mXus
         I4+fZ22MlG2yyE/oHGF3F7xAoKg2jdpx1aF4TYRsQa3Rja6efqPFjUgHN06TJkCkS8so
         iMlrhf6QBFO7zAuWJjsL24NyPBEf9MAKVCDaWC8PZIwQJ422MXTan7yye+wc5RmpiX5M
         0Vn0k85hbArBGbbbuz917aMPyEmtjONANCEjBjKG6Safq26tq8Kxt2+v4SEsCK+mGr/v
         GzuwuLx9ZnUI4cccxfqxehBPd5pghz7iF9a0nfj3tFNumCpapuaL6O5UMyGyviCf7A8c
         9lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=fcvRd1O2Y/KANTtdyoesNTyIloFS4ke6vSyrx2yWl+0=;
        b=jiV79ywAGy3FYcXoRR+CtAHbQ334DhsehVT7Iegbd75AJzzJrowfNFIVNpZ4yDpaAO
         mwse/rDPgzMizWplA7cv6rh/ObD4q7gk/p3EzoSa1KusjCt6MxV6aX2EAKn1AsybSD13
         4r3RohvcaGiEGZX0djY3eEhHS1Oy08rkEK2ji5ZXdY2Wp0oxufI0NtUA1/fMpP+tMxFa
         R2EvdmsSvES+G2cGjbiVvMczj2bLXPO2VDWvahuxxc47LQPY/UHP1wH2Efx/bTTzRKei
         WjuprYyIwXri0OGEPS7PWodwOpN3A91VkHj4stjRx4GNua8v+jixYytR+6r6rFUlXJJ4
         6Y2A==
X-Gm-Message-State: ACgBeo2Cr34IRjN7jgJOBXERfkgWsBw1tgA2g6nwKr/mDF2fPwv3e+z0
        ePvjgSo71i+9BFhIpAAZkNQNjA==
X-Google-Smtp-Source: AA6agR7ATXILOLdSeMbYHQrC9oRCW+o2hRJZi32md31J4D4ms4v7fm8u6BpLJxaQZdloLRtUuEzgDg==
X-Received: by 2002:a17:90b:2398:b0:200:a861:2e86 with SMTP id mr24-20020a17090b239800b00200a8612e86mr5685302pjb.233.1662665442033;
        Thu, 08 Sep 2022 12:30:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 15-20020a63184f000000b00434abd19eeasm6086737pgy.78.2022.09.08.12.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:30:41 -0700 (PDT)
Date:   Thu, 8 Sep 2022 19:30:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: selftests: Use TEST_REQUIRE() in nx_huge_pages_test
Message-ID: <YxpC3du18wybv3OH@google.com>
References: <20220812175301.3915004-1-oliver.upton@linux.dev>
 <YvaWKUs+/gLPjOOT@google.com>
 <YvanIQoL3Y3TlxPB@google.com>
 <YvrVKbRAoS1TyO44@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvrVKbRAoS1TyO44@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022, David Matlack wrote:
> On Fri, Aug 12, 2022 at 07:16:49PM +0000, Oliver Upton wrote:
> > On Fri, Aug 12, 2022 at 11:04:25AM -0700, David Matlack wrote:
> > > On Fri, Aug 12, 2022 at 05:53:01PM +0000, Oliver Upton wrote:
> > > > Avoid boilerplate for checking test preconditions by using
> > > > TEST_REQUIRE(). While at it, add a precondition for
> > > > KVM_CAP_VM_DISABLE_NX_HUGE_PAGES to skip (instead of silently pass) on
> > > > older kernels.

...

> > > > +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
> > > 
> > > This cap is only needed for run_test(..., true, ...) below so I don't think we should require it for the entire test.
> > 
> > It has always seemed that the test preconditions are a way to pretty-print
> > a failure/skip instead of having some random ioctl fail deeper in the
> > test.
> > 
> > If we really see value in adding predicates for individual test cases
> > then IMO it deserves first-class support in our framework. Otherwise
> > the next test that comes along is bound to open-code the same thing.
> 
> Fair point.
> 
> > 
> > Can't folks just update their kernel? :-)
> 
> Consider my suggestion optional. If anyone is backporting this test to
> their kernel they'll also probably backport
> KVM_CAP_VM_DISABLE_NX_HUGE_PAGES ;). So I don't think there will be a
> huge benefit of making the test more flexible.

Yeah, I'm somewhat ambivalent as well.  All things considered, I think it makes
sense to skip the entire test.  Like Oliver said, without first-class support,
this will become a mess.  And I'm not convinced that adding first-class support
is a good idea, as that will inevitably lead to tests ballooning to include a big
pile of subtests, a la KUT's VMX test.  I would much rather steer selftests in a
"one test per binary" direction; IMO it's easier to do filtering via scripts, and
it also minimizes the chances of creating subtle dependencies between (sub)tests.

So, pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

but with a rewritten shortlog+changelog to capture this conversation.  And that's
a good lesson for the future as well: when piggybacking a patch, making functional
changes as the "opportunistic cleanup" is rarely the right thing to do.

This is what I ended up with, holler if anything about it bothers you.

    KVM: selftests: Require DISABLE_NX_HUGE_PAGES cap for NX hugepage test
    
    Require KVM_CAP_VM_DISABLE_NX_HUGE_PAGES for the entire NX hugepage test
    instead of skipping the "disable" subtest if the capability isn't
    supported by the host kernel.  While the "enable" subtest does provide
    value when the capability isn't supported, silently providing only half
    the promised coveraged is undesirable, i.e. it's better to skip the test
    so that the user knows something.
    
    Alternatively, the test could print something to alert the user instead
    of silently skipping the subtest, but that would encourage other tests
    to follow suit, and it's not clear that it's desirable to take selftests
    in that direction.  And if selftests do head down the path of skipping
    subtests, such behavior needs first-class support in the framework.
    
    Opportunistically convert other test preconditions to TEST_REQUIRE().
    
    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
    Reviewed-by: David Matlack <dmatlack@google.com>
    Link: https://lore.kernel.org/r/20220812175301.3915004-1-oliver.upton@linux.dev
    [sean: rewrote changelog to capture discussion about skipping the test]
    Signed-off-by: Sean Christopherson <seanjc@google.com>
