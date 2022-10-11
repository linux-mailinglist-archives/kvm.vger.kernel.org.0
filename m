Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C985FBDDC
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 00:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJKWYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 18:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJKWYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 18:24:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B7763AC
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:24:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-358c893992cso143025887b3.9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=scIFVLMhvIGzjgXLs0mh1a6DJd//CqMMPxWVpLV4yJI=;
        b=DGhOlyJ/7IrmBBs2WiRLdtm+AiDv/fFlWXPpZuIzUSAXFGvrfzgiuCDByq6CQSh6wS
         sTYk2MLglvWLcXlaw6FpTg58FrBK9JZeoY7FXtU6vW7R8JcBRi7v0f3vyKF3SUeX4JAs
         b1aZ3GltAVvxYBXnblzj/9g0+v9MhNYDAgmPwIJ2w3RZ7H7k/hVSveMbdEm9wxPwD/PM
         t8PXOHLU19gYMu+tnatMz8u8baxqQyK12UOOlrHLw/+ZMWEIu+QQvQLzRe4bn6LMOjlt
         kgtsdv8OrSj1eXiCTsDMurmtMduLEj6s/9I3F4SjEo2v8G8/KNsVUGj+M2GkzMNqM/I9
         pD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scIFVLMhvIGzjgXLs0mh1a6DJd//CqMMPxWVpLV4yJI=;
        b=dxEkH0T5PbWtqlH7JDSxRDhRiUeqv7t8OWxNSIVWz2maVCLAJCXK4GmPmdbr7Lj/x6
         GCF+haVZ2MY39mck/L+CkOEf1et6Iv5Wd6rkyssdOH8NDaYnY8CFYBK08GXXHk5F3Psb
         wn/87KyrXcOwkj5jo2UPNtLOIwjPM4CG/qOSOOrjUrJp/bpIqWGD/7ypeGkPSpGec3MR
         xoYWGAB6t3ANO+VySqV6JAebXBM+7uP8drwtyN2Rer1QtRWjq1pt7KA/IVkVlo9lmfqZ
         pZntTpXSQvnZg/wat7yO65MdjkkANzzkIapEC1o4RssbOj3qoCH+ZY3D4GhkvQxwbpjz
         tF8A==
X-Gm-Message-State: ACrzQf3xbjbFauYiOewif4JIBInkZuTCRakCvrLr70mE7PCsLZJWVDeV
        M8D+F41vn6j/nfJhJXwnH73eI4AiLfzTFTp9KA==
X-Google-Smtp-Source: AMsMyM5MTysYJ5zqfXTlABpizIwcgK4R0PTuryWaT94HAVQYQH6bGJv9dp9CRYvoOmwdlGu0wB7f+A5wmj22cgyDLQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:7344:0:b0:360:97a5:8716 with SMTP
 id o65-20020a817344000000b0036097a58716mr16557840ywc.459.1665527084083; Tue,
 11 Oct 2022 15:24:44 -0700 (PDT)
Date:   Tue, 11 Oct 2022 22:24:43 +0000
In-Reply-To: <Y0W4dImhloev7Iaq@google.com> (message from Sean Christopherson
 on Tue, 11 Oct 2022 18:39:48 +0000)
Mime-Version: 1.0
Message-ID: <gsnt8rlm2e38.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number generation
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Oct 11, 2022, Colton Lewis wrote:
>> Sean Christopherson <seanjc@google.com> writes:

>> > On Mon, Sep 12, 2022, Colton Lewis wrote:
>> > > diff --git a/tools/testing/selftests/kvm/include/test_util.h
>> > > b/tools/testing/selftests/kvm/include/test_util.h
>> > > index 99e0dcdc923f..2dd286bcf46f 100644
>> > > --- a/tools/testing/selftests/kvm/include/test_util.h
>> > > +++ b/tools/testing/selftests/kvm/include/test_util.h
>> > > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t
>> > > size)
>> > >   	return (void *)align_up((unsigned long)x, size);
>> > >   }

>> > > +void guest_random(uint32_t *seed);

>> > This is a weird and unintuitive API.  The in/out param exposes the gory
>> > details of the pseudo-RNG to the caller, and makes it cumbersome to  
>> use,
>> > e.g. to create a 64-bit number or to consume the result in a  
>> conditional.

>> To explain my reasoning:

>> It's simple because there is exactly one way to use it and it's short so
>> anyone can understand how the function works at a glance. It's similar
>> to the API used by other thread-safe RNGs like rand_r and random_r. They
>> also use in/out parameters. That's the only way to buy thread
>> safety. Callers would also have to manage their own state in your
>> example with an in/out parameter if they want thread safety.

>> I disagree the details are gory. You put in a number and get a new
>> number.

> Regardless of whether or not the details are gory, having to be aware of  
> those
> details unnecessarily impedes understanding the code.  The vast, vast  
> majority of
> folks that read this code won't care about how PRNGs work.  Even if the  
> reader is
> familiar with PRNGs, those details aren't at all relevant to  
> understanding what
> the guest code does.  The reader only needs to know "oh, this is  
> randomizing the
> address".  How the randomization works is completely irrelevant for that  
> level of
> understanding.


It is relevant if the reader of the guest code cares about reentrancy
and thread-safety (good for such things as reproducing the same stream
of randoms from the same initial conditions), because they will have to
manage some state to make that work. Whether that state is an integer or
an opaque struct requires the same level of knowledge to use the API.

>> It's common knowledge PRNGs work this way.

> For people that are familiar with PRNGs, yes, but there will undoubtedly  
> be people
> that read this code and have practically zero experience with PRNGs.

>> I understand you are thinking about ease of future extensions, but this
>> strikes me as premature abstraction. Additional APIs can always be added
>> later for the fancy stuff without modifying the callers that don't need  
>> it.

>> I agree returning the value could make it easier to use as part of
>> expressions, but is it that important?

> Yes, because in pretty much every use case, the random number is going to  
> be
> immediately consumed.  Readability and robustness aside, returning the  
> value cuts
> the amount of code need to generate and consume a random number in half.


Ok. This is trivial to change (or implement on top of what is
there). Would you be happy with something like the following?

uint32_t guest_random(uint32_t *seed)
{
	*seed = (uint64_t)*seed * 48271 % ((uint32_t)(1 << 31) - 1);
	return *seed;
}
