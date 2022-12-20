Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765B66524A6
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiLTQcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLTQcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 11:32:03 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320F11169
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:32:02 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-434eb7c6fa5so148543297b3.14
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XrImwGduolMTyoyh8B4xmu2CI/C3wDtB3hW/6WtZSt8=;
        b=QYMLt5UshIud2hfhO6Xvx67bOysbCE2PlS8smMxii+jnx2XrX+Q5+IBqlnd7fwXZoA
         Kp5vXgqNGcnhkb6NgI3Y96WHlCoNZPiyxrfvAJK3ix5hWdyKaNP0SGy6bSoTRiUudY3/
         cY8F4IJYHzK3FaMsuE0wy2C82L1l7YUkonERzGOwSskkEVFJ8sHT7Xxl+7OFLwPIGfkQ
         pom6CKeqJjSsQq9D3t07sQvT315+iasLL0kSKcGSl+949Lpfvn2DkAGv1knmfnQu3arn
         sYGxcxyTRTjaCeWiygSq2gJ6PiT7vJWiMhWsaq+ARSKvtB7q9nco7iGW+YU3lhvQbwJk
         AgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrImwGduolMTyoyh8B4xmu2CI/C3wDtB3hW/6WtZSt8=;
        b=O5TxFYHKVK4oTDQoY+5CSu8f8ss7Z2cc0gwyfZGHcd1zCDgqh7oZJaMGvUiiWNP0nl
         iCX/fYGExyIieDVuJWaxRqANhkbm5XM2T1+hoBRPVRYLdTNvpkfllMDMgiRQPQwlmrHU
         g76OsYa78VSyOKvp1u/pe93LjN8F4b3JXyF4/N7RS4+JDeDqFhDgNUklpWrYrJQ8dUSD
         2DBb6jrYRYu0cQSyLyxrcUZWD2XGV8hCj4eK7eFmv5rcw/CE+TbxCmY0Xgopbu70VLZw
         rjb6olTBdm8hrqMISlV9TKQ/qmOp3F9TzaDtnoy146hZo5f6Ex3a+egT+FWxZBWqrPgE
         TChw==
X-Gm-Message-State: ANoB5plToP1Qgq0+JJxwo2fa6JBgocQXEvrz10VVd8QtdNSDEo8y9GDB
        dA0WejjEZPrdBdYx9dTeGSeQj7ymyMIwU2SJzw==
X-Google-Smtp-Source: AA0mqf7oHCF0W41mhDrjdzczDyjNBOgKqzvgVg5lQDJFYRpKE81aajcpRRzlPnT1UDYepvbYCCwBsqs2yOgViGTVFw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:f90d:0:b0:404:7030:e1c0 with SMTP
 id x13-20020a81f90d000000b004047030e1c0mr6793086ywm.53.1671553921890; Tue, 20
 Dec 2022 08:32:01 -0800 (PST)
Date:   Tue, 20 Dec 2022 16:32:00 +0000
In-Reply-To: <Y6GRXreBu56PqCyG@monolith.localdoman> (message from Alexandru
 Elisei on Tue, 20 Dec 2022 10:41:55 +0000)
Mime-Version: 1.0
Message-ID: <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com, ricarkol@google.com
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

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Though I'm not sure how you managed to get MAX_SMP to go down to 6 cores  
> on
> a 12 core machine. MAX_SMP is initialized to $(getconf _NPROCESSORS_ONLN),
> so the body of the loop should never execute. I also tried it on a 6 core
> machine, and MAX_SMP was 6, not 3.

> Am I missing something?

To be clear, 12 cores was a simplified example I did not directly
verify. What happened to me was 152 cores being cut down to 4. I was
confused why one machine was running a test with 4 cores when my other
machines were running with 8 and traced it to that loop. In effect the
loop was doing MAX_SMP=floor(MAX_SMP / 2) until MAX_SMP <= 8. I printed
the iterations and MAX_SMP followed the sequence 152->76->38->19->9->4.
