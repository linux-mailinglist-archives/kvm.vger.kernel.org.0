Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED15FCCCF
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 23:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJLVLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 17:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJLVL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 17:11:29 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F9D114DD5
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 14:11:28 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so12024564ioz.8
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 14:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BU0PmmEyqdDZtH0P95soOoLlcvNj0UCw8s+AE9RKqZA=;
        b=l8K1Ymw3j4umU1WkgYkyA4IcN0FCf/rcfX8Et+q/aNSANMGcmN0n/Njey8Sk1Uf9v1
         /EnQXrbP2nLWpyodxNkUUK9wfm4Bz+F+xOPFV+MMAEvBe1E+Iu1EHSXkaPaAXOsWS8wd
         jKuLhbJPKSGyMtDRMUdJPjhjkETfcZH4D17IY0xhEXZPMbwp1TOdXig29FAI247xfdpQ
         WWK/BtwHfkpdKsy1reagXWCyMbi1xyR8z6WIRl6QRDq+ZzC0WNKWqgYDz/KjVcBmYfWq
         H/dsz5/R08j5bVPHakD4Wr9E8yCVg7pWaeCiCvrOqsg+O1yu5G04E0zOifaJHmy0mvCe
         J61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BU0PmmEyqdDZtH0P95soOoLlcvNj0UCw8s+AE9RKqZA=;
        b=vfSe07O8niUk9N1TCDtmiAAuTI+JHoqGlNeBull33hcDlDy09Ctx9Yt2pC0u5lJExL
         m4GSKBIQUQRQWCQ5/9D7+MG4PAwwFyRFTMWnzaf74tZY0xF5h1Wh6SumEyF+nE2q86bx
         MdvnXVEcO8xLnvfk2z0/D4RaqqS5CLimkh5B+PXBWhbxUjA/E8NTekEANrmO57SM6WkN
         VGUQdvq69eqmqAiAZFZPHjmB0LDcyM273F8YfFx2Ih/SzS3zrswHG4V6B1IBoWEsjdi4
         xpNZ6sv18i4IsRvkK46W7PrBD/i2/XskcP2Q7vohXtmXuufdJMf+bNr5ZwNKtZPpPyRb
         j8kg==
X-Gm-Message-State: ACrzQf0HSBQVsPYm+TrLm6S+PG2Le3Zz9BXtiw6ZHRtDdOLKE/kdyDI9
        A+srH8qdBc+yQcLTEibUwGN8IZgXtdkyi2Otpg==
X-Google-Smtp-Source: AMsMyM5uCuGRZ2TGzsD82V9IYYbBScxYI9Dk0AaZunTjzuPzRiVOLkA29UPPjx0MXpDWkn0qPWlmOlZeYp7RlZU94w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1b88:b0:2fa:cf20:3a21 with
 SMTP id h8-20020a056e021b8800b002facf203a21mr14986833ili.137.1665609087620;
 Wed, 12 Oct 2022 14:11:27 -0700 (PDT)
Date:   Wed, 12 Oct 2022 21:11:26 +0000
In-Reply-To: <Y0YAdQC7eP1TN90b@google.com> (message from Sean Christopherson
 on Tue, 11 Oct 2022 23:47:01 +0000)
Mime-Version: 1.0
Message-ID: <gsnt1qrc3fy9.fsf@coltonlewis-kvm.c.googlers.com>
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
>> > Regardless of whether or not the details are gory, having to be aware  
>> of
>> > those details unnecessarily impedes understanding the code.  The vast,  
>> vast
>> > majority of folks that read this code won't care about how PRNGs work.
>> > Even if the reader is familiar with PRNGs, those details aren't at all
>> > relevant to understanding what the guest code does.  The reader only  
>> needs
>> > to know "oh, this is randomizing the address".  How the randomization  
>> works
>> > is completely irrelevant for that level of understanding.

>> It is relevant if the reader of the guest code cares about reentrancy
>> and thread-safety (good for such things as reproducing the same stream
>> of randoms from the same initial conditions), because they will have to
>> manage some state to make that work. Whether that state is an integer or
>> an opaque struct requires the same level of knowledge to use the API.

> By "readers" I'm not (only) talking about developers actively writing  
> code, I'm
> I'm talking about people that run this test, encounter a failure, and  
> read the code
> to try and understand what went wrong.  For those people, knowing that  
> the guest is
> generating a random number is sufficient information during initial  
> triage.  If the
> failure ends up being related to the random number, then yes they'll  
> likely need to
> learn the details, but that's a few steps down the road.


Ok. That makes sense to me.

>> > > I agree returning the value could make it easier to use as part of
>> > > expressions, but is it that important?

>> > Yes, because in pretty much every use case, the random number is going  
>> to
>> > be immediately consumed.  Readability and robustness aside, returning  
>> the
>> > value cuts the amount of code need to generate and consume a random  
>> number
>> > in half.

>> Ok. This is trivial to change (or implement on top of what is
>> there). Would you be happy with something like the following?

>> uint32_t guest_random(uint32_t *seed)
>> {
>> 	*seed = (uint64_t)*seed * 48271 % ((uint32_t)(1 << 31) - 1);
>> 	return *seed;
>> }

> Honestly, no.  I truly don't understand the pushback on throwing the seed  
> into
> a struct and giving the helpers more precise names.  E.g. without looking  
> at the
> prototype, guest_random() tells the reader nothing about the size of the  
> random
> number returned, whereas <namespace>_random_u32() or  
> <namespace>_get_random_u32()
> (if we want to more closely follow kernel nomenclature) tells the reader  
> exactly
> what is returned.


If that's what you care about, I'll wrap the state and put better
information in the names. I think I misunderstood your original comments
to mean you wanted something much more expansive than you really did and
I'm getting tired of redoing this patch.

> The code is trivial to write and I can't think of any meaningful  
> downside.  Worst
> case scenario, we end up with an implementation that is slightly more  
> formal than
> then we really need.

As a matter of personal taste, I don't like the additional formality
making things look more complicated than they are. The stakes are small
here but that kind of extra boilerplate can add up to make things
confusing.

Thanks for your patience. I never wanted to cause trouble.
