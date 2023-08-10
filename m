Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBBB77844A
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjHJXsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjHJXsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:48:16 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9808BC5
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:48:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-268441d0e64so1931386a91.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711296; x=1692316096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV/Ct/Ds/CxS4v6ir6EHRWsoOhvufSz0INvujsP8hqY=;
        b=vSrGdjpvDxTK/XL3At5KxkEi3BN7xLVQpPmnORZMhNG6jd39wJsns/R42KS5xfvvXi
         yWOf3T02bs2cFYxM2Bhrzrfj0k6Po0wWmcQm6G/LaTfmxV81Ct/0B2yvJpQ1Ac5przBM
         YI/COf8QXx2m5sSQcKF+l2LSoIpkzb5A89S15N5HYQ3pppUclgQ+9/xmB/68xZHvAKfB
         JSU6pgtHKdHo4h0gV0hA/MMNZT85qAuZCuamTpFwYhHNi9iSZMFI/PgHP9+N4m/gs0vU
         jiL9rOS/C5ipEbZb8SH5IHTEyqot9sQ8y5Uv8dfoZAg4iBI1zrE098pJmeiz2Px/Socu
         EZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711296; x=1692316096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV/Ct/Ds/CxS4v6ir6EHRWsoOhvufSz0INvujsP8hqY=;
        b=kKl4FJGONJBa7E/y56xsDgwXx0oBPL9feNQMCHZgrb2MwNrlzkJUvX03DP93ze4UfT
         96x7G2Put7GltIv9a/sUAmYo4WCdcQHmlUgHLW3ysNWQbbTY2m7pvKjDUkxCqf6ZFOSJ
         aySlsHWAdTg6NrY2UVLLt0idptW/QWqK+EXVGigzYPp7rEHh71S/IlkzPA5yNdQaiq0+
         cbs3tLMOUAEucX0+ZeOCm8jj4fPgvfuJnKw6wKUf97zWWRune61UXSSQ/nL19p5+jG+S
         akfSQJ/MpJE7uK/SwRROX4cPRfTW2sQzMiPO5jK0ZW/VPKDzJbu9nLzvY92HRsFDO+S4
         Y6ew==
X-Gm-Message-State: AOJu0YxirLjh41sU0HEm3aRYdIvOd2kwRjKqJqtD3DeJuhtwRHs6cMp6
        dqxTTc6s9UIkh4aQqwNz0ylQQmaBb+I=
X-Google-Smtp-Source: AGHT+IFvQV9B4i2e4uuA2RI0E1Gm8UGPYDS/BYnwMbmvrRmW8AeG2hCnUB9az9bEpN0laGy/rlEDrxMOA1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:811:b0:262:ffae:56cf with SMTP id
 bk17-20020a17090b081100b00262ffae56cfmr9678pjb.8.1691711296149; Thu, 10 Aug
 2023 16:48:16 -0700 (PDT)
Date:   Thu, 10 Aug 2023 16:48:14 -0700
In-Reply-To: <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com> <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
 <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Message-ID: <ZNV3Pnqczf6PrNrs@google.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023, Anish Moorthy wrote:
> I figured I'd start double checking my documentation changes before
> sending out the next version, since those have been a persistent
> issue. So, here's what I've currently got for the commit message here
> 
> > hva_to_pfn_fast() currently just fails for read faults where
> > establishing writable mappings is forbidden, which is unnecessary.
> > Instead, try getting the page without passing FOLL_WRITE. This allows
> > the aforementioned faults to (potentially) be resolved without falling
> > back to slow GUP.

Looks good!  One nit, I would drop the "read" part of "read faults".  This behavior
also applies to executable faults.  You captured the key part well (writable mappings
forbidden), so I don't think there's any need to further clarify what types of
faults this applies to.
