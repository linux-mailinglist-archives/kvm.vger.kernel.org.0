Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2D699DCB
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjBPUeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBPUd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:33:59 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122BD505
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:33:58 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i3-20020a170902cf0300b00198bc9ba4edso1608596plg.21
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SZjk5loQdWFvTVeAEd1UgeUhfTRnNzA9KnZgkbqx04=;
        b=p784C8oxEMPboTnejSdHYKmskqvgDabkgWJ8NiSbYHkCISoMdbwOB43MBPwD2jXrJk
         YOeOORgxLmGZ288PuxW5Df0+mAi9y7rKYHs01W8xyL/5r9khiiog/rnAxIm1R/VZVNjA
         4cIzPhP6ayKdKtx+Mt36G+qnDUEtOAF9md9PUKkVqQinkwILsBJnV6AI4zfVFxTI0kru
         7ailEpS937BS4Fpu9UDgmpJ3hLyxa9xbeGIKO5mAgy9M99m1xm3RiXHU7uVILlclWIXX
         wGoO3qqP6xpHLiWZegzgMHgF94xt5EIAcGwDSBWdfrChkdCjCI0EJ4J+S6eOmeGzvic7
         2ShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SZjk5loQdWFvTVeAEd1UgeUhfTRnNzA9KnZgkbqx04=;
        b=AcLuwVRLnHIRBuGMDNshCSZGQwb+4zqodcUxD/x2YuGQIIPF0AB+fEG30U5zzdATIP
         RX6hrljnga9UnhDQHmBN2yIMC9BJI8M203/+YUv619hYA4Yo7p5ME9z3SjlNa65KG8X5
         LkXCQpl8DrQg9VbHYx8KPIQb2s9thHjJ2e0BQ5FnribPKQSCO26NRUJ9QSSMTsgAsMvL
         9NozHXggP1VaBwmfdrOLsWa/nkyR06+upEM5FiCu944eEAS7mYeyjUF8v4JmK/Mh/e6S
         VSungb/1N+Pe3GmlC7gAHz5i+054IPYcdpuI+5CIhQRk5TwGS8fYkPlJPtrMrvxBuFKH
         8hIQ==
X-Gm-Message-State: AO0yUKUMew0fgckQF9szqNrAw1S+fB/At1HqUZSIMQXlkFWgl9saLzDS
        oxzEcy4j/xr6MvPTeYbGc+1I6wB6OQQ=
X-Google-Smtp-Source: AK7set8TpedNvDQUP8NpQ16WJ185zMMDFTEV0xSEMVZoCcGEf3937wRMinI6lEiAFbeW5ChniCt06eLR76g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2653:b0:19b:e4c:2025 with SMTP id
 je19-20020a170903265300b0019b0e4c2025mr217269plb.0.1676579637808; Thu, 16 Feb
 2023 12:33:57 -0800 (PST)
Date:   Thu, 16 Feb 2023 12:33:56 -0800
In-Reply-To: <20230216202432.1033366-1-amoorthy@google.com>
Mime-Version: 1.0
References: <Y+6PWxGL5w+pwbhe@google.com> <20230216202432.1033366-1-amoorthy@google.com>
Message-ID: <Y+6TNC77RYyBv34A@google.com>
Subject: Re: [PATCH] selftests/kvm: Fix nsec to sec conversion in demand_paging_test.
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, jthoughton@google.com,
        oliver.upton@linux.dev
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

"KVM: selftests:" please.

And when sending a new version, bump the version number, i.e. the subject should
read "[PATCH v2] ..."

On Thu, Feb 16, 2023, Anish Moorthy wrote:
> demand_paging_test uses 1E8 as the denominator to convert nanoseconds to
> seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue and
> make the conversion obvious.
> 
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
