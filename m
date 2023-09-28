Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A867B229F
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjI1Qlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjI1Qlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:41:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE8698
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:41:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81ff714678so20708568276.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695919308; x=1696524108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tst+DkwAdXu9j1qECuGBuQkZRSzWpTr/alcWwqp/AhY=;
        b=Xt9bVJaUfiQM+ktTarSQYkoBERcf6ErLh/Wlis0fTXVTFYlfi4pOsCGRTZSe62xuPX
         ECqRXrWyohSEcwnPNcim272ECck72N1ASIx8TIvSze6xgR5zWOor/Zn+mFICjzJHBk4b
         4gfvfqBvExQxhfuX3ft84LcgSDwpGWecyGWaEsj4wCTYrJz7ItfjOu08gc80dnYjhdZP
         jzlJar3wGKyJR08J0xs2sRkFXRKQoYbbOnkxMI36hJtkV2QaXNCOOEqurdEDZ6h8Q0NG
         E7D/Zgm5iU7oHgVD6Zc0Er2RCfFWRv1deHVRofY/dXj470emhjJS2oMWoiTFFvH18sMI
         XQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695919308; x=1696524108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tst+DkwAdXu9j1qECuGBuQkZRSzWpTr/alcWwqp/AhY=;
        b=QXtYFHvwuJm09uBPM1AcrH+RO8gEQUg2QCtvEVL2u0W0ua9v8G10za9hMKJVttDYON
         feBoIK3VeByUq3OXpRH9ckj9juzMNFSSJoYov8toBghKSZ54IQ9Witv480OVfk+aAAJf
         IDIc/BIq4fSrLHM/d9tmB03wrWDMLBSUfAN81QfaWWn42T80u2kTXmO8IgcamQB8XmUk
         yu4/xRHZE9TS2Q6bA5RAlKzJxpfkd/kDN626BV60fOZBorW+npI+wzzcaw/JAj3Uqbms
         IEF8aW8j1gIUZ8f5TqtZnSCMO/lbnMRYaViaPyBuBefwNa57OlWBF23j8HIvV9Xv0XJb
         8mwg==
X-Gm-Message-State: AOJu0YwPMneCDFKC7TprC3F5T4cEAaQYWlqJ29BvU3cnXGhJ7nsKqqus
        +kF6j53OeQhiIPaXAqTgpO7/EceaohU=
X-Google-Smtp-Source: AGHT+IExaZe3ClyQm7iReg/qKD8VwVIU1XHlBbop9bQFhbTJ9lqecCG/Toz6PDGQmAkB3wS+XZ8ulxQWu/4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:544:b0:d78:3c2e:b186 with SMTP id
 z4-20020a056902054400b00d783c2eb186mr26580ybs.5.1695919307879; Thu, 28 Sep
 2023 09:41:47 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:41:04 -0700
In-Reply-To: <20230814222358.707877-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230814222358.707877-1-mhal@rbox.co>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169584540630.785163.7027615129119311145.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        corbet@lwn.net, Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org
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

On Tue, 15 Aug 2023 00:08:34 +0200, Michal Luczaj wrote:
> As discussed[*], some minor clean-ups. Plus an attempt to smuggle a fix for
> a typo in API documentation.
> 
> [*] https://lore.kernel.org/kvm/e55656be-2752-a317-80eb-ad40e474b62f@redhat.com/
> 
> Michal Luczaj (3):
>   KVM: x86: Remove redundant vcpu->arch.cr0 assignments
>   KVM: x86: Force TLB flush on changes to special registers
>   KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
> 
> [...]

Applied 1 and 2 to kvm-x86 misc, and 3 to docs.  I massaged the changelog for
patch 2 to make it clear that flushing whenever the MMU context is reset is
overkill.  I had to go back to the original discussion between you and Paolo to
understand why Paolo suggested blasting a guest TLB flush.

Thanks!

[1/3] KVM: x86: Remove redundant vcpu->arch.cr0 assignments
      https://github.com/kvm-x86/linux/commit/9dbb029b9c44
[2/3] KVM: x86: Force TLB flush on changes to special registers
      https://github.com/kvm-x86/linux/commit/4346db6e6e7a
[3/3] KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation
      https://github.com/kvm-x86/linux/commit/57f33f1a8756

--
https://github.com/kvm-x86/linux/tree/next
