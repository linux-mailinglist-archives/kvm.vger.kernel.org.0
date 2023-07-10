Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CDB74DC9B
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjGJRkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 13:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjGJRkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 13:40:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26F0EE
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 10:40:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a4e947a1so80641295ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689010803; x=1691602803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzbb7xS3YBuH/eMWilsy8aIsa55E6S/F+W5yfrdF6ps=;
        b=BjJnQeY+cn0AJlQsnIMteL/HbVSGc2GSkA2N9pH2OA1ubVjsVXqnRRTSobjrGGNoS9
         NTXL9wOdhFClIubW+nLDVkwMmRWrGFiUExc872o77xFOwmyqVtjtm4qKmOnGDn8GoQ74
         PhNW9cTg+3a1WdFqRmwaIwReuObKCfLmYZJ6hgmoUgbEli7N8mU8IPoeWZ7GLVamW7+A
         ZbRFCw0BVCwWyS9/5kynxXnmB+STIHCB45g52CtmelfjizDpkXs0hgZRbGQPU1N0lUmu
         tc+9wIw/3plQkXyf/anWxggtXvpgMKBN2XGl99V8msWmGdu6ihlV1Wqf2CGh/hMFoyFx
         y4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689010803; x=1691602803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzbb7xS3YBuH/eMWilsy8aIsa55E6S/F+W5yfrdF6ps=;
        b=l40bZbGpfWkwGHKC+DlREw3dQKhdWShqjd2iNJABk3pQ4/RnHYQnpCsKc8NbEON4Kn
         XRtOI6WyrAbj07HG7Hc1ufwOlkfN1pk27LHpOo5IuqTY5dZ97ZvP0pUypmOb8MDGcHJl
         BFaBLlQLAhrqUQlvh6LZF95nYV0xn7arvdyH7sSYL8j67r0qgZNahmWNyGSsYde/soqO
         og5f+stPdX0Bliv6BbH5/3EBo9dwsj5D6NgbTUqaXz9pY2G6pdilKgmpg8XEh+uZAKaz
         R2YXE/Vza+85Kdf6IZ+iaWJsCafAgWOpR1qE23YObUvm/wN/MMOuCYv67ASKGj2Ewg6T
         aDrA==
X-Gm-Message-State: ABy/qLa0i+W3YbSLyVB5dOvqyqFVvOvqbxp/Niiu3bBRsa5UsFsHP25+
        XDCy7HkChwRUx6cKjJf/0vFvPjdhzbM=
X-Google-Smtp-Source: APBJJlH+tM8Y/lsaXf9KUpXQAitRtchoryMAjw/RjTURKcbwg2RRlXgn3/drXmB42/p/dtkbirFn2NLNxoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ca81:b0:1b9:d23a:df78 with SMTP id
 v1-20020a170902ca8100b001b9d23adf78mr3957477pld.4.1689010803365; Mon, 10 Jul
 2023 10:40:03 -0700 (PDT)
Date:   Mon, 10 Jul 2023 10:40:01 -0700
In-Reply-To: <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-8-amoorthy@google.com>
 <ZIoUc2hLd0zMOhO+@google.com> <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Message-ID: <ZKxCcbeXauiOX94I@google.com>
Subject: Re: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023, Anish Moorthy wrote:
> Done
> 
> (somebody please let me know if these short "ack"/"done" messages are
> frowned upon btw. Nobody's complained about it so far, but I'm not
> sure if people consider it spam)

I personally think that ack/done messages that don't add anything else to the
conversation are useless.   The bar for "anything else" can be very low, e.g. a
simple "gotcha" can be valuable if it wraps up a conversation, but "accepting"
every piece of feedback is a waste of everyone's time IMO as the expectation is
that all review feedback will be addressed, either by a follow-up conversation or
by modifying the patch in the next version, i.e. by *not* pushing back you are
implicitly accepting feedback.

And an "ack/done" isn't binding, i.e. doesn't magically morph into code and guarantee
that the next version of the patch will actually contain the requested changes.
