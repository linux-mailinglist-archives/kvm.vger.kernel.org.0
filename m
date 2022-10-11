Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB55FBA4C
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiJKSYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiJKSWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:22:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB035F49
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:22:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e129so13466430pgc.9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G1Eub1xEFYhW9cba/hA1fRceBukA9n4AZ4E7eeXvmJ8=;
        b=mpjx2nPO5zT4KaIDDay2TVSvCBm0T5XktW5cqSfj//CH8ecKTmW7skoiodnVqIHXkC
         8TzTRTDQ18ICS0/JudIECKsyr387JOSYFKO5pJbKOZj/kcSMZvJafockyNA8CN12/HG/
         EXrWYgaJE2pXqJ9YLp4a36LiwYmK76TYzHEBAfS3zvAOhQFbwfFdqfoUp6a35G1e9FPo
         WI7RE/iAvdW3LmFGzZ+4ZrxQmHDUL3Mw70Z9gOD+Pvb3J2b2GttYmPO4Bm/hOoPXePil
         8i4Iuvxi+8peXNjqwt2rc8y5gIRZxyfHR9IMPR2SB1RWQV/SHjjuS18I1nB59SNC1HlB
         lNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1Eub1xEFYhW9cba/hA1fRceBukA9n4AZ4E7eeXvmJ8=;
        b=4YgYZyZrvCSdNE4pKm1DCB8mAtGvcTeN1xrMLGhk1RHS3PP13WIar+d4VSA1jf+y9n
         i3fk+28rD4nMl1sGsEo9wdRlBjhAHxa0us90UEosuKqVzoLD4cnIEs+p4hOgo81CbRAs
         qcf1uqgy91+lk6qwfV/jkZFtn3Ajmusl1vTM9sQFyc4uOADItsyMUqpyoqIdkrwvs4vT
         YAUA85x+0Zzu9837f+fYqo3wSkZGF7d2MaUv/k6eZ6sqHfFqasUXaTjWndBcnwV7tmEt
         V30hMon9cNF0/MaV0GElXGp/CCziCgCxWoqX0+HNBOKDKYfY1/M5Jk2gX6LLlYaU8cwF
         drwg==
X-Gm-Message-State: ACrzQf2lnFF7EKwtvpmx6kAPaeXjU9ImRkUD2ry/s470V7GzkmgIS9ex
        65sg5GWFOS5MGNnyE3081KDXFQ==
X-Google-Smtp-Source: AMsMyM6ZmrQs85a67zjIL/v9jVTdVy8M7d5CDMPsw4cUXzIpWRAZDs/7apQXOOAiTp5Jk8Ah0abrEg==
X-Received: by 2002:aa7:838a:0:b0:536:101a:9ccf with SMTP id u10-20020aa7838a000000b00536101a9ccfmr26369476pfm.18.1665512540039;
        Tue, 11 Oct 2022 11:22:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l4-20020a635704000000b0045dc85c4a5fsm8075844pgb.44.2022.10.11.11.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 11:22:19 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:22:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 3/3] KVM: selftests: randomize page access order
Message-ID: <Y0W0V5hsTkKLg59D@google.com>
References: <Y0CVmS9rydRbdFkN@google.com>
 <gsntedve2pqz.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntedve2pqz.fsf@coltonlewis-kvm.c.googlers.com>
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
> > Ya, I'm trippling (quadrupling?) down on my suggestion to improve the
> > APIs.  Users
> > should not be able to screw up like this, i.e. shouldn't need comments
> > to warn
> > readers, and adding another call to get a random number shouldn't affect
> > unrelated
> > code.
> 
> Previous calls to PRNGs always affect later calls to PRNGs. That's how
> they work.

Ya, that's not the type of bugs I'm worried about.

> This "screw up" would be equally likely with any API because the caller
> always needs to decide if they should reuse the same random number or need a
> new one.

I disagree, the in/out parameter _requires_ the calling code to store the random
number in a variable.  Returning the random number allows consuming the number
without needing an intermediate variable, e.g.

	if (random_bool())
		<do stuff>

which makes it easy to avoid an entire class of bugs.
