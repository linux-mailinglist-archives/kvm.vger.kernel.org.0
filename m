Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CA2588FF3
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiHCQAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 12:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbiHCQAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 12:00:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233C2F28
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 09:00:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id pm17so11378580pjb.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 09:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TnL6Z7gPDsAzl4E22/lYC/c8b9hCptQxGpX2XrfTXsM=;
        b=taTUbRxSaAlDUkwmEee2E1/jjyxFZlncjPIqgD71yvHHHv1cz7dftnY+g07ANm8OtB
         seurE1R/lE7/8y0sZthcX5u6uXB9XG7vTNpqjFPCvbVdF4z2t7teSrROI/RcNJeiC602
         WwsuqQmIx+r/a9KhZ7f+JmTRLrWtCutS+BQ1V/MgJo6Z1UKFxBZ4Rcfy31jjbBci7k+L
         iE4FNymh11KFFGT0y6CSl1k4/Wgvdqxz1XdLTwHQX9AyniKnhhO4LF63xvO8mYrdElqZ
         bNoHBU/2qb4YDj9zGOqeG7skSUOV31nPoCzObCBpvXy684C31t5EW426XAQ1+L7VMwmk
         tn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TnL6Z7gPDsAzl4E22/lYC/c8b9hCptQxGpX2XrfTXsM=;
        b=lXGxybWc0wDLijPefPWFuXcSH5HXeBKMIxVrHRgjMAOR0txX6aNQ2LpUvRR4pLiS7U
         z3vntxjVJwliTujD8oJM1xo6wOu8YsCd45Vfzs/QtHEOO/cmEMJAGsZQf13cq/1UV/9o
         DxyJ8iwCKqzJwVxl7G1YGxAmziQb+hyRNDvDLou2jN47v+RHF124HYd/VQNlW/vRg1QG
         BAHGw50Vz0J5wgXq9mpItUCU3Ws/ph6DLP1YbQg3sVITayMXTH64kperYHNyWtpv0Fwr
         jWkIvRepAuc0OnFeC6bmbN9jVFY9ik68duwMg7uufNEnblWExaTYkElOp8uvc5ONSGk4
         a5eA==
X-Gm-Message-State: ACgBeo3bqyxSTVje2gTWwOYOr2JoU7xyT5y4Gh9EF1mdjL20QgkMl9a0
        IZ3I4zxPXiokNwl4ste4rq7amg==
X-Google-Smtp-Source: AA6agR62rnw906v6qY62bcnzZ6pz5FlLwVe85O1as/2aNzO2VnCaQOii5/CqP5e4RvYcn5rJaMZP0A==
X-Received: by 2002:a17:902:d64a:b0:16d:570c:9d7b with SMTP id y10-20020a170902d64a00b0016d570c9d7bmr26603326plh.1.1659542414547;
        Wed, 03 Aug 2022 09:00:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016dbdf7b97bsm2172550plg.266.2022.08.03.09.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:00:13 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:00:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: kvmclock: Fix a non-prototype
 function declaration
Message-ID: <YuqbiVTntu1MOV9H@google.com>
References: <20220722230157.2429624-1-jmattson@google.com>
 <CALMp9eSkB8KN4sm==VOZWaa1jJfzoiPWen4OGE0fTdAHSdGxzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSkB8KN4sm==VOZWaa1jJfzoiPWen4OGE0fTdAHSdGxzQ@mail.gmail.com>
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

On Wed, Aug 03, 2022, Jim Mattson wrote:
> On Fri, Jul 22, 2022 at 4:02 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > Avoid a -Wstrict-prototypes clang warning.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
