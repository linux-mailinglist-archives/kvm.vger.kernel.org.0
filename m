Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091B4699D7E
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBPURg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPURf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:17:35 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00EC4C6D7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:17:33 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o10-20020a17090ac08a00b00233d3ac7451so1412550pjs.0
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KXO/sMRgR+rq5C1H+AUe//FrAstwKoUzse8qRjeYsDo=;
        b=O3WTDmw/BRLbWcBl8LO2fDR2TTcVCdniBNPeV0Pjm/DNIsqp1Ubldvl1CHSAcG844Z
         VkoJltbIUu0i2w0/D0qe1OhtcAzBBFICU+cG9foUg2uIIFC+bK19LXb5n8tF4utHDy4d
         vI1lfaz0VP9rjTbhb7DjRcDo35BFgs+P4h/N9HUmzenHgyKx2lZvlzBfeWVdOHSfAZht
         KjY7pbTrxmcHW1anbnWnWzFYOAyyLd+ukyfr4VaNLC/NQ5pNFMTmFcHXIR28gp96veef
         d7j4HcomCvttWFZkVj9bzpAeAjIGZ47QClo/uppIFmzyolMvvbeE2rIE/VqLfJYFhle0
         +vrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXO/sMRgR+rq5C1H+AUe//FrAstwKoUzse8qRjeYsDo=;
        b=kFxLrsrdnM32/gaUDofCppPY6uYO5DRmXA+irQp36wJUJ3XziESAqOS3KPd4EC5mnk
         CEXE6Sa7gJfXW8P1nVrtC9CzP/Y9PIZtA4cj//QTugrujerZlm6zahKlzFUKHG013jTj
         yg3yuTCoWPk0OE8/kGTtdoWQPxqHLIysaI9EC9cU197Zp+4BRGhZcNyPJ8L+RCLtCm4y
         tMwuRAXIls/HSC0wDZ5dVB9sj1WpaoYy21djdx0uV/JfpqZO+POp0kITIuFAfCrYudHb
         3hXrWjAYOSJ0rponkKLaS0SYGP/mpx0DgYMaL2Z5zD49WVhxwy0toxG0PMuPYimN7Bdy
         zwtA==
X-Gm-Message-State: AO0yUKVDzTzMdogp3UUXdpYQ1GWfW9K1fsOlHb85cAdlBe1BmmCEk0pB
        Vx05wY/XXpsVx/k6ZvwboKb8KWhAKL0=
X-Google-Smtp-Source: AK7set9JYQxhi6D0RAerpBPuJY8iPyiR9ud11f6qQKuR+s/1APo6XGe8uNPIMBjngYTQvPJSScYuaugcc2Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:96ca:0:b0:5a8:da1f:8672 with SMTP id
 h10-20020aa796ca000000b005a8da1f8672mr1120288pfq.18.1676578653224; Thu, 16
 Feb 2023 12:17:33 -0800 (PST)
Date:   Thu, 16 Feb 2023 12:17:31 -0800
In-Reply-To: <Y+6OVtw1kEO99Gah@linux.dev>
Mime-Version: 1.0
References: <20230216200218.1028943-1-amoorthy@google.com> <Y+6OVtw1kEO99Gah@linux.dev>
Message-ID: <Y+6PWxGL5w+pwbhe@google.com>
Subject: Re: [PATCH] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, jthoughton@google.com
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

On Thu, Feb 16, 2023, Oliver Upton wrote:
> The shortlog doesn't give any hint as to what the bug actually is.
> Maybe:
> 
>   KVM: selftests: Fix nsec to sec conversion in demand_paging_test

+1

> On Thu, Feb 16, 2023 at 08:02:18PM +0000, Anish Moorthy wrote:
> > The current denominator is 1E8, not 1E9 as it should be.
> 
>   demand_paging_test uses 1E8 as the denominator to convert nanoseconds
>   to seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue
>   and make the conversion obvious.
> 
> > Reported-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> 
> Bikeshedding aside:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

With Oliver's shortlog (I'm indifferent on the changelog),

Reviewed-by: Sean Christopherson <seanjc@google.com>
