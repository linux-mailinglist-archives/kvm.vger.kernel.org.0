Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C277B229A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjI1Qkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjI1Qkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:40:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF7BF
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:40:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81c02bf2beso20055199276.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695919248; x=1696524048; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3IyA4j5LRCjoh4Ka+kX4owAXyuP7hkypyJPhZH37Ck=;
        b=3bubFcmdG7jBnEvf1IuozEET78ap/1E1rltb0TaGcK3Jcjv2GPLcqV4v4L1pQCPes5
         q17PNTpzcwlFYRYieTa6jFoWMJ5iUe/9BArTQGb30HUh+ZwT9jKNcnG1ei0EodLG4/Uy
         YehyKnea63sqdq0SueVxo0JDMsgKxBkP2m7rjiL8RFhK94dP0155YLn4seR25ArkptYI
         tRexALClkv0PtY1jgSsrBbGcUMLFCuOWi7/R//02u3CJNJ/M9s1OJIsCR9DmlDumnFbO
         8+7eEE6wBZeBiEuXRp3lm/kQDlMsMMt7erkX0r57oFAeO0XQq36X/EciaNc9A0p4sbL9
         5ejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695919248; x=1696524048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3IyA4j5LRCjoh4Ka+kX4owAXyuP7hkypyJPhZH37Ck=;
        b=So4fBiXkti3mY1AsbR5Xw5vBn40ka/U5Ss/rcQHBHtGTZpWzTnVcXukV9Z1NJD2CKO
         PdiqzRxw6VrCtvFWTd8oWTeohUFeIElaHb+SSTPeYosRaK3yeqSqhS31id7evNU4nZw4
         X1gtNr5Fqxfeapm8bzEuD6uSqY53rFgZG0JLt8ALF+53cugu99Q1S875KF45EgCoebj6
         qB91x0q8RjGwun1xbTDXtAKa9VOozkwwPDkAKzaPmwQKRyQ0hn2KPBwBcw0NzV9Nk1HI
         yZaQmxwelzKUbuvYGsM40cvHpcuUfYJYlvZ2n/gP+sNPJHme6++nRXqTEC3ZIXlvo/zj
         7OeA==
X-Gm-Message-State: AOJu0Yx8mSOpn6S4uQ01AyCX7kpjTIawt5rAf0RUTATY85zqWC1sRbGw
        lqUuzzY9nbD17j32vYjamiejNqHrKug=
X-Google-Smtp-Source: AGHT+IEu2W2MHVe69US8d4pL7DITmeJTo7bFYFFaX72qfzDvR92vlvvhE0StfB20DsHIdO4xYChX2KBTdfM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:136b:b0:d81:4107:7a1 with SMTP id
 bt11-20020a056902136b00b00d81410707a1mr25891ybb.2.1695919248462; Thu, 28 Sep
 2023 09:40:48 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:40:36 -0700
In-Reply-To: <20230531075052.43239-1-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230531075052.43239-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169591408296.965784.15552125307182012260.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86/pmu: Add documentation for fixed ctr on PMU filter
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 May 2023 15:50:52 +0800, Jinrong Liang wrote:
> Update the documentation for the KVM_SET_PMU_EVENT_FILTER ioctl
> to include a detailed description of how fixed performance events
> are handled in the pmu filter. The action and fixed_counter_bitmap
> members of the pmu filter to determine whether fixed performance
> events can be programmed by the guest. This information is helpful
> for correctly configuring the fixed_counter_bitmap and action fields
> to filter fixed performance events.
> 
> [...]

Applied to kvm-x86 docs, thanks!

[1/1] KVM: x86/pmu: Add documentation for fixed ctr on PMU filter
      https://github.com/kvm-x86/linux/commit/b35babd3abea

--
https://github.com/kvm-x86/linux/tree/next
