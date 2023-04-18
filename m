Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D178A6E67B8
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjDRPEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjDRPEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:04:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FB497
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:04:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-517a6547b0aso2102390a12.1
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681830277; x=1684422277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldy/dP8LMWJf2sFNu83/G/+DCoW4Dq2T/rJBkIzeHGU=;
        b=4HPvwRuWBh0qciq/mCTwwRhTEnRWbbhCXt0Po3tpCUWUFabVtsh+DI0Ivtb7wsAvRD
         CY6gFqboRNNwBsB1ene6PROnmpkdNm3OH1VdowIYDELJD1sfqPuoBr7/z8sCtBQEEmCu
         /8knpfJnWL18npjPVaCm6wvFYFMJ+0WBJpgRkeP9MthVFJCsGYKN+P4H9ON7cGa9jthI
         BmjOPWaz74BIX514NpFiUkkKP4z6fJwbiMAoUWgl2lXn3BdDFQT5dhMhbAd5Ko4ztXJV
         F/xZhkKWIx+JuTO2gIAsRE0RFZ0p3fVMeab5zGwafiO9LCSfVJCUB/Sv+1RDBrmVI3Y7
         73IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830277; x=1684422277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldy/dP8LMWJf2sFNu83/G/+DCoW4Dq2T/rJBkIzeHGU=;
        b=kR3SS+VBf9h+vHHOBpUVu+/uHn4BdGZ9BPZd5voCXrHeBjVjbvqcqVuBOsLogWKzri
         DyDNdSgdQA2b4jbSlZvQVpf5/i6nJreGD7UnyTwiwXiK6Ae+Sv83xF94AdfU8h1g3her
         o5B/+itMWScjMvtMXSAtRtXOPpx2+I7aYcYEYltdom0celP3t49RWEIahOPZH1vtmpFs
         l9r1KznWqW50GKORrE40+n62S3v3Y7ySBKm1vafXgzMCLOGw1pP0PqV43KPJbR93fgXn
         IhfgBBF0YGhy55r4u3BHYd2DFJcW28geFR6zDYW8oT723FO098Ah9GflzFn/LE+/vCud
         ppLg==
X-Gm-Message-State: AAQBX9dt3X/VV2+Y+foUsFn0/AJYpj/D1+dUTODp7xLNAZ7iqr8GhU4K
        dKZxb2UpTxqyvVFCMUmYNcEWE+oE3Sk=
X-Google-Smtp-Source: AKy350ZSFO7dRmY7vCX21vAeh8pF8UFVjvb9MHePmInK+LfOBFV4NLEFFd+9Tmx0on7VChFQ1+0teA3T5XM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8f94:b0:1a1:ea19:8f5c with SMTP id
 z20-20020a1709028f9400b001a1ea198f5cmr973272plo.5.1681830277470; Tue, 18 Apr
 2023 08:04:37 -0700 (PDT)
Date:   Tue, 18 Apr 2023 08:04:35 -0700
In-Reply-To: <ZD1vGBz9FuKWKKGl@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-6-aaronlewis@google.com> <ZBzLpk/FXjhTJssQ@google.com>
 <ZD1vGBz9FuKWKKGl@google.com>
Message-ID: <ZD6xg1ULOgMsNe6h@google.com>
Subject: Re: [PATCH 5/8] KVM: selftests: Add vsprintf() to KVM selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023, Aaron Lewis wrote:
> On Thu, Mar 23, 2023, Sean Christopherson wrote:
> > On Wed, Mar 01, 2023, Aaron Lewis wrote:
> > > Add string formatting support to the guest by adding a local version
> > > of vsprintf with no dependencies on LIBC.
> > 
> > Heh, this confused me for a second.  Just squash this with the previous patch,
> > copying an entire file only to yank parts out is unnecessary and confusing.
> > 
> 
> Sure, I can squash them together.  I thought doing it this way would
> make it easier to review because you have a diff against the original in
> this series.  If that's not helpful there's no point in having it.

The problem is that including the original first means reviewing the entirety of
the original patch in the context of KVM selftests.
