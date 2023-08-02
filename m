Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9376D988
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 23:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjHBVbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 17:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjHBVbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 17:31:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C95319A0
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 14:31:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb982d2603so2750375ad.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 14:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691011891; x=1691616691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7O3ldpuvwn/jLEEsGaVER0W5WQz6QQVB4o4mWJTPHw=;
        b=0MpUaXqNR3yN2ZePV6Ehw88TdkHVM4wwC2Ax9LBcBwhrccVQmDk4pUsO2m/W60T/kh
         4ALsk63SSuRBd3UXVMnSiQB5v2iI8UQfYCb+eIiV9ztG6S6KlhNhk233zQbbCY6jDG0m
         rtdmAzFLXMLRYfEzbyZNqny8nmMx5u7NTub/RYML7Xn31Nyl8a4U+e01kHF6VCiqYOVM
         xpL0WtRUyR6fLic8o7wZFKDajLk8nUgQ1I14uVXOA6NUMtV+htB3i1ARMO6mRJ2oAjcz
         bO63UUfjpoeGbzSi8UO3Ogv8fLbD7MT+Agmc+my/+J8Ci2lSUSrXLjoKrVyUkepwfc+B
         m9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691011891; x=1691616691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7O3ldpuvwn/jLEEsGaVER0W5WQz6QQVB4o4mWJTPHw=;
        b=EhkvqGRz2tE+vTnkHN63kXYtfxZdrqdYxNedwAiXnXhZ1E7OMcJ+EXIO5s18LPZfoU
         L1U5pG1/L3V3sN5iM/tiNAcJ+KBXFzbOAIaJItBaeDL0KktLHaTldy/BKu9SX5gsidET
         OCJX2LZJl3XtbmRp2GrDuCLhdPdjDNMTnq6e1qcxJL2/EQFkeR7I54wg9nuKj3HYRJVC
         gGKsFEsc0ug3ZpO1ivlBxLJTIQeulQZBHFp7ykk6BHyaycfw6PEMLRVOjrT0jJ3zk7FY
         PBcxTNsGrjwhatsTxjuU04csNZ/xGuHM+xmlE6sdYECDLkutfyMECGqQ+kl511VLS3LV
         hUuw==
X-Gm-Message-State: ABy/qLakmXxvxDbZw/ASVQ7m2e6+8DWKklLdDizwqzHF7okHXc4X9ExA
        peo7l75JLeVqszqK89/7kcwL/4g4akw=
X-Google-Smtp-Source: APBJJlFDudSBR591hmxo+SrOS4iiKae4bolkQa4eRRqibf6eAaJJjg2NfepfTGffX1GgLKifjQS3uqiIERY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e885:b0:1b3:e4f1:1b3f with SMTP id
 w5-20020a170902e88500b001b3e4f11b3fmr93178plg.2.1691011891629; Wed, 02 Aug
 2023 14:31:31 -0700 (PDT)
Date:   Wed, 2 Aug 2023 14:31:29 -0700
In-Reply-To: <ZMq0nYYDbOX1cOKN@google.com>
Mime-Version: 1.0
References: <20230712075910.22480-1-thuth@redhat.com> <20230712075910.22480-3-thuth@redhat.com>
 <ZMq0nYYDbOX1cOKN@google.com>
Message-ID: <ZMrLMYxj3s+vHGrQ@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: x86: Use TAP interface in the
 sync_regs test
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Sean Christopherson wrote:
> Oh, and no need to post "KVM: selftests: Rename the ASSERT_EQ macro" in the next
> version, I'm planning on grabbing that one straightaway.

After paging this all back in...

I would much prefer that we implement the KVM specific macros[*], e.g. KVM_ONE_VCPU_TEST(),
and build on top of those.  I'm definitely ok doing a "slow" conversion, i.e. starting
with a few easy tests.  IIRC at some point I said I strongly preferred an all-or-nothing
approach, but realistically I don't think we'll make progress anytime soon if we try to
boil the ocean.

But I do think we should spend the time to implement the infrastructure right away.  We
may end up having to tweak the infrastructure down the road, e.g. to convert other tests,
but I would rather do that then convert some tests twice.

[*] https://lore.kernel.org/all/Y2v+B3xxYKJSM%2FfH@google.com
