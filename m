Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5FF6743E5
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjASVFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjASVDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:03:15 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F94DA258D
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:58:21 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4de8261cc86so31292507b3.13
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WlxoB9q2pqyPhdqN3UJwdEiySKFUITJXh+SsaNdwD0k=;
        b=UFCAxRSGjlCPBLmWO+W4D0UCcLK4hvpojriD82FJYWKOfkZ5fdgyw0mESAzegHXPQ9
         sVwdypOI8YkGYAWYHjsB1y80m/cLg+SoslZdROXSluLBkyNFD2NQ1Km7RhMYiq2Lqkqu
         WOVTZU79BIob5tme4zNECoTFXK+ng1I8T3SN04VkriT18RFgI5x1uKrabf/Ktqg3kOvN
         Wsf4LeRb0O+JD16+d/wbLBJU6pUDSeZ86cDmP52TtB+XqHmWxqcCUeT4M3v863NJbqog
         QD4xkmEjceIP6/14WORnxIdizM4SN718hxuelfvCZ8IYlA+KAHnAsHluJ2iUiMVtusWN
         Tiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlxoB9q2pqyPhdqN3UJwdEiySKFUITJXh+SsaNdwD0k=;
        b=vBBvnWQf9NhNpKEYyPW7LMFY1wI0NR2Y2wEbwyqy5LuDGeNlSM0OJs8hJcnhUYwTlt
         RVRkq1Lc2wMO73gUlB7s1gtVa/5WrCrOuOc6p343UU0XOL+vACmMKNPMRV5k8ZE/SAJI
         p39ai+KFOcRDzQjGa7JbQexDgY4pabmNlUK9PlWdVHjWwiObTl7dI9CaMK5kOidHhacZ
         14uCh053ThYkHcBYr+f7N8iaaFGCMHq1Bg1RVBZLOQJ/rIwY7mOjanEEaBXH7Ptf5yJ3
         uoo1Iz+mliCeB0tFxzTF/ACLIriBwnJsTy3jPGyAh6cFUHDsQTc8vuH2FgqJ7VbZPGPQ
         2jOg==
X-Gm-Message-State: AFqh2kpciAkT55XcVXcTMzMaeM7wID41WU7FjFviyk1D1nBWUD8nYnGO
        ZPFo/+S26IaniI5GFyBcvVDs2MHXOiM=
X-Google-Smtp-Source: AMrXdXvsSuoiRsTAH4Z7S1fU5eaCaMyuGHXp61i6AD+p06y3ILB/DRZfmxy+SZ3yWnqzT+tGTJSh5NrxQoQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9802:0:b0:800:9d2d:ac38 with SMTP id
 a2-20020a259802000000b008009d2dac38mr46858ybo.272.1674161901156; Thu, 19 Jan
 2023 12:58:21 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:57:29 +0000
In-Reply-To: <20221220161236.555143-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409081639.2375192.4460110033173378501.b4-ty@google.com>
Subject: Re: [PATCH v8 0/7] Introduce and test masked events
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Dec 2022 16:12:29 +0000, Aaron Lewis wrote:
> This series introduces the concept of masked events to the pmu event
> filter. Masked events can help reduce the number of events needed in the
> pmu event filter by allowing a more generalized matching method to be
> used for the unit mask when filtering guest events in the pmu.  With
> masked events, if an event select should be restricted from the guest,
> instead of having to add an entry to the pmu event filter for each
> event select + unit mask pair, a masked event can be added to generalize
> the unit mask values.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[1/7] kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
      https://github.com/kvm-x86/linux/commit/aa570a7481c3
[2/7] kvm: x86/pmu: Remove impossible events from the pmu event filter
      https://github.com/kvm-x86/linux/commit/778e86e3a2fd
[3/7] kvm: x86/pmu: prepare the pmu event filter for masked events
      https://github.com/kvm-x86/linux/commit/11794a3da07f
[4/7] kvm: x86/pmu: Introduce masked events to the pmu event filter
      https://github.com/kvm-x86/linux/commit/651daa44b11c
[5/7] selftests: kvm/x86: Add flags when creating a pmu event filter
      https://github.com/kvm-x86/linux/commit/6a6b17a7c594
[6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
      https://github.com/kvm-x86/linux/commit/b1a865796643
[7/7] selftests: kvm/x86: Test masked events
      https://github.com/kvm-x86/linux/commit/5ed12ae83c4c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
