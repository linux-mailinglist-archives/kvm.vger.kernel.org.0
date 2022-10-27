Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5708610289
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiJ0USF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiJ0USC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:18:02 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A62C8BB8B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:18:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h2so2688740pgp.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vxZA1znDy2Dwa1rmOwbVomIIU9aSxHQFmkAXwl2pUiI=;
        b=E9xAtk27u+gomJ2geVGml8dHpTtRuCOjTijQ9WhsaUHwIoV9YNlmmz0BJ08YEpZtrT
         gareTQD2qM9w/94K0jnDlsev7NpMCNhRQFAPw8g7929FBB0CP0s3ZC0pIPI+U4dWs/OD
         8HnAMh7U2HBCF/bEbg4LeHpJ6KhTTC5gzqvdus8Di1IAWkZpMIw3SHMLruNWc9YlC8iB
         zAb5qxXCn7hPWYEdcRkZ+nB4vNk/SjK5wNwY8irMOgMkksNFKWWlHhqqTpm733NA56+p
         MDgezKH3UFdjHysuI7V8LsNq8iozRMfgP5fo1MwosnLZBHd4OvhJd0OLf2KX25iacoFY
         mvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vxZA1znDy2Dwa1rmOwbVomIIU9aSxHQFmkAXwl2pUiI=;
        b=24130LMEu0+d8v0cjU5SWLrz0v7w+kDVzVkYVAD/nY+6h7RapOKw4yaMoGWFOFLlLN
         TgoEU9rjLF7qXQDah/gj6w3tdwHF2zTUOYDtybga30Tjq14NvygVEWd6uEJQf6ubOLDe
         9On9qMEm+6S737K96sVzb5EQ4DQNwuEfe56p3LVQ0hhSphCq496BrVWA6jv7n79WmEkM
         8HQHsk55FGBq9zcCt2rmyWEBS4a4VcmoCZYoPaNEUen6slwQieGmfbuvW8Fxzghkfoj6
         fds+JPVS1Kc1Z/N6l2jITgKJx6MS00O0xToUVqqHqpR/RTJOkhq6LPzu81k34ykFu5mw
         b/6w==
X-Gm-Message-State: ACrzQf295m2CCXHanzxpP0oruKoSL2kP84I+GDaeVdI3kHJs6m8IDNne
        O/t7S8w5+7rSIqB7V50iNf13vA==
X-Google-Smtp-Source: AMsMyM4Ck4Uw9EU5nVym+B7u9G6sWKV+Zi/3X5c7wDMybCNYntNamYLbhrR7859icN98RRhureqCxw==
X-Received: by 2002:a63:2c90:0:b0:439:ee2c:ab2f with SMTP id s138-20020a632c90000000b00439ee2cab2fmr5103592pgs.2.1666901880453;
        Thu, 27 Oct 2022 13:18:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jc19-20020a17090325d300b00186ae20e8dcsm1544786plb.271.2022.10.27.13.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:18:00 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:17:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v7 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y1rndFkw7LcfQkZU@google.com>
References: <Y1miBTa4cID5yH3Z@google.com>
 <gsntv8o5126y.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <gsntv8o5126y.fsf@coltonlewis-kvm.c.googlers.com>
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

On Thu, Oct 27, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Oct 19, 2022, Colton Lewis wrote:
> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > > Reviewed-by: David Matlack <dmatlack@google.com>
> 
> > This patch has changed a fair bit since David and Ricardo gave their
> > reviews, their Reviewed-by's should be dropped.  Alternatively, if a patch
> > has is on the fence so to speak, i.e. has changed a little bit but not
> > thaaaaat much, you can add something in the cover letter, e.g.
> > "David/Ricardo, I kept your reviews, let me know if that's not ok".  But in
> > this case, I think the code has changed enough that their reviews should be
> > dropped.
> 
> 
> I talked to Ricardo privately and he thought it was ok to leave the
> names in this borderline case.

Heh, damned if you do, damned if you don't.  On a more serious note, this is why
I avoid doing off-list reviews except for the most basic sanity checks.  Ask two
people for their opinion and inevitably you'll get two different answers :-)
By asking and responding on-list, there's is (a) a paper trail and (b) a chance
for others to object before the decision is "finalized".

> IMO, changing this interface doesn't change anything important of what the
> patch is doing.

Right, but the code is different.  E.g. hypothetically, if you botched something
while reworking the code to fit the new interace, then it looks as if multiple
people gave a thumbs up to broken code, which can cause a maintainer to not give
the patch as much scrutiny as that might to a patch without reviews.

A recent example that's somewhat similar is commit 4293ddb788c1 ("KVM: x86/mmu:
Remove redundant spte present check in mmu_set_spte"), where a conflict during a
rebase of a relatively simple patch was mishandled and resulted in a buggy commit
with three Reviewed-by tags where none of the reviews were given for the buggy
code.  There's no guarantee the bug would have been caught if the Reviewed-by
tags had been dropped, but a "hey, I dropped your reviews from patch XYZ" likely
would have drawn eyeballs to the patch in question.

> Nevertheless, I'll drop the names and ask them to reconfirm.

FWIW, if you've confirmed offline that someone is ok keeping _their_ review, that's
totally fine, though throwing a comment in the cover letter is probably a good
idea in that case.  That's a decent rule of thumb in general; if a decision was
made off-list, make a note of it on-list to keep others in the loop.

> > I think it makes sense to introduce "struct guest_random_state" separately
> > from the usage in perf_test_util and dirty_log_perf_test.  E.g. so that if
> > we need to revert the perf_test_util changes (extremely unlikely), we can
> > do so without having to wipe out the pRNG at the same time.  Or so that
> > someone can pull in the pRNG to their series without having to take a
> > dependency on the other changes.
> 
> Will do. Was attempting to avoid adding unused code in its own commit
> according to
> https://www.kernel.org/doc/html/latest/process/5.Posting.html
> 
> "Whenever possible, a patch which adds new code should make that code
> active immediately."

Yeah, this is another "rule" that is sometimes subjective, e.g. in this case it
conflicts with the "one change per patch" rule.  Since the RNG code can't be made
completely active without pulling in yet more code (the guest_random_u32() usage
in the next path), the intended benefit of the "use immediately" rule isn't really
achieved, and so forcing the issue is a net negative.

> > > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > index 9618b37c66f7..5f0eebb626b5 100644
> > > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > @@ -49,6 +49,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > >   	uint64_t gva;
> > >   	uint64_t pages;
> > >   	int i;
> > > +	struct guest_random_state rand_state =
> > > new_guest_random_state(pta->random_seed + vcpu_idx);
> 
> > lib/perf_test_util.c: In function ‘perf_test_guest_code’:
> > lib/perf_test_util.c:52:35: error: unused variable ‘rand_state’
> > [-Werror=unused-variable]
> >     52 |         struct guest_random_state rand_state =
> > new_guest_random_state(pta->random_seed + vcpu_idx);
> >        |                                   ^~~~~~~~~~
> 
> > This belongs in the next path.  I'd also prefer to split the declaration
> > from the
> > initialization as this is an unnecessarily long line, e.g.
> 
> Understood that this is implied by the previous comment. As for the line
> length, checkpatch doesn't complain.

Checkpatch now only complains if the line length is >100, but there is still an 80
column "soft" limit that is preferred by most of the kernel, KVM included.
Checkpatch was relaxed because too many people were wrapping code in really weird
places "because checkpatch complained", but preferred style is still to say under
the soft limit.

In other words, stay under the soft limit unless the alternative sucks worse :-)
