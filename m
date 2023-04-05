Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15296D8AD8
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDEXB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjDEXB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:01:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EDF40DA
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:01:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d13-20020a17090ad98d00b00240922fdb7cso13563720pjv.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWfM8y2kFVlT4b7N+Pj0fdzIhc7SGyOvZzzAY7GF6ws=;
        b=tJaGHplXDeF20Sr7DVA+eMujD9NFrKH+FAuG/CTdJhNF1tijWH/c4VP8fdqa0j1WXF
         bUdYaTMkTsfL/Gj7pLoyguCh2J6IK3si+vXTPURZFyTU9as/lI7DxfRyHyoe0UvIVSwN
         xzZ4R++bCMVkFjRIBzqvhVvLthmUYtSSrRjv5wz05fr85XrZUS5VKcgQCanpOCedYdQV
         wPu8MVcBaeH+1ceU6IUeYrgm1rw7nLev+jVBH6wAYmhTYHQczb43iG8EJzuSHwAP9Mls
         QLAEV6gWabBMN9AcAw3ESl4MtH5J+A4aC0ZvNpPSu7wlg6wCxjCywQ/5g71yfExVW6rd
         RXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wWfM8y2kFVlT4b7N+Pj0fdzIhc7SGyOvZzzAY7GF6ws=;
        b=FhFF+OqX7qV/AQgCIRBBmB1gBmMO+nZM3uBWfT4kidnNd8KcDIPmvr5FS0BNzPRBmp
         jl2gt3wTvAoEe/nt9xDiMUZ14BY86SDZJk8BuDSOo/kI+i8tPnaveuzfS3uknud1EZ8y
         8Zr+X73q5qi8h+RSZHq4uvrZAkunrN237P2VHtEAs+wc9hVIa1RthpUTMjjasyL7bChS
         RErKUJyH4G+PjxJkaEgW3BgSEO6sOmk58BvnN85qbALtL/CI4RG6T+NUpbeDsTIvHxI4
         jUqKhoOlS9K1yf9/W4suYDHGwd8YPk4djSJH9i8oZrX5VbgK/yOimSZ2Sms3bwOHQozG
         VqTA==
X-Gm-Message-State: AAQBX9dtuHtS3QtsEGiEnXLnR9720icJf+qQ5yT9dIY2zbTfMh4DiM73
        qG2H8laXblF6lMBhmPxhW/NDj2vCh8o=
X-Google-Smtp-Source: AKy350ZEa6PBr2N2FZ3vu2+2ydtO1gTW+GB27m8qbCFgJ5MH7Jy8SfxOv8adj/I8S5JGpmmjKazBAF6pBHU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8a:b0:1a2:8fa0:fbd7 with SMTP id
 j10-20020a170902da8a00b001a28fa0fbd7mr1863886plx.2.1680735714725; Wed, 05 Apr
 2023 16:01:54 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:00:54 -0700
In-Reply-To: <20230404234112.367850-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404234112.367850-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073536200.619199.2380630060446751838.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: Fix goofs in FEP access configs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 16:41:10 -0700, Sean Christopherson wrote:
> Fix goofs in the config from the FEP access changes.  I tested the changes
> manually before posting, but only did the standard "run everything" after
> the fact.
> 
> Sean Christopherson (2):
>   x86: Set forced emulation access timeouts to 240
>   x86: Exclude forced emulation #PF access test from base "vmx" test
> 
> [...]

Applied to kvm-x86 next (PULL request finally incoming).

[1/2] x86: Set forced emulation access timeouts to 240
      https://github.com/kvm-x86/kvm-unit-tests/commit/a1fae402cbc2
[2/2] x86: Exclude forced emulation #PF access test from base "vmx" test
      https://github.com/kvm-x86/kvm-unit-tests/commit/32b8b88e7eb0

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
