Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA1E7DA203
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjJ0UuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346580AbjJ0Utu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 16:49:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC7ED40
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5aecf6e30e9so24793707b3.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 13:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698439786; x=1699044586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f1ReUtUHakvXxrTTVPsvLxhNP/KZhPScACaGU9TuGJw=;
        b=TQx1+u8fPhIp9iPerUK8qDODmu3Ow5OuxQT+wXMahiZ9aj20lS5y1PBqvndUtKPX/W
         YMWbUOunZLXdZNgPrjPGSr8AVRnXtpqyu7zLkA19CvR0/d5CAIPRzHAx5nQ3vMn2fXSY
         n71+nZXI6LCShyCt9pbQV2wgYHMAyOX7BAOO+H/PBu7MZhQ5cNHBWB0OT+jInBaBRRR2
         yU9r9PseSQg+eS7Zz6oUH0zlZyKnuskp/RhCgGfepio4AHZUPswB86krG+tRUI0h5hEE
         VlTtwbSpqJaZgewRMZ2WoJhOqJ/tzHnCYMnwqhM0ci9ZMq+zwC8sEewMBJW84QoJZZ5j
         66Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698439786; x=1699044586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1ReUtUHakvXxrTTVPsvLxhNP/KZhPScACaGU9TuGJw=;
        b=puI51MGVmXRtCpdnHIzUjr1lCfOCk/aMX2KCWe28D9vSj+Q1YyJ8qHOVCNJ2nCAOJ5
         DHzTVlbCR+BKL5LRTP7vvqjlKWHEFU5onEDijED7CDw7SwdUcdgDoX3ZeP+jCH/qHpZV
         0iYvWEZaue6jhsteJk/fyWzYaSy0TfpTIddHlMP3rQeRssBnhXv2pXAz8vLUDLlj738s
         QQxgWtHBJtZhMccqaQ6LN3bAh8w2fKJ2wKhrHbRyFt4IOJKBcdmPBqxurrk0oRJtyhuB
         ydEzxR7bY64WtcFOl2qZNFvRcOsRo8z7jnCScLrbwL2XMKv4uOt9gOomTvsYHP5Sd5py
         P9Zw==
X-Gm-Message-State: AOJu0Yx/WfvvVYgU6YVHwljqNRCpmhJx+v2qwa+fZcEuzQXKw70D+k6W
        D/EkSaLCQZGLjdraMiieTB8bP6ItMfo=
X-Google-Smtp-Source: AGHT+IHTdW2tfl2nMaJGKat407EBX+WX4aVSCqNaQF4Ri9AlCie9Lxzi32ECryW9qGQSsuc1S1DJUQX5yDU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9214:0:b0:5a7:bbdb:6b39 with SMTP id
 j20-20020a819214000000b005a7bbdb6b39mr76039ywg.3.1698439786542; Fri, 27 Oct
 2023 13:49:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 Oct 2023 13:49:29 -0700
In-Reply-To: <20231027204933.3651381-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027204933.3651381-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PMU change for 6.7
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A single PMU change for 6.7.  Note, this _just_ got rebased because I had a
brain fart and used kvm-x86/next as the base when recreating the "pmu" branch
after the fixes for 6.6 were merged.  The commit has been in -next since October
16th as 4b09cc132a59.  This is not at all urgent and can definitely be deferred
to 6.8 if the late rebase is an issue.

The following changes since commit 2b3f2325e71f09098723727d665e2e8003d455dc:

  Merge tag 'kvm-x86-selftests-6.6-fixes' of https://github.com/kvm-x86/linux into HEAD (2023-10-15 08:25:18 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.7

for you to fetch changes up to fad505b2cb838fb52cb72fa22830824c80330f2f:

  KVM: x86: Service NMI requests after PMI requests in VM-Enter path (2023-10-27 13:20:29 -0700)

----------------------------------------------------------------
KVM PMU change for 6.7:

 - Handle NMI/SMI requests after PMU/PMI requests so that a PMI=>NMI doesn't
   require redoing the entire run loop due to the NMI not being detected until
   the final kvm_vcpu_exit_request() check before entering the guest.

----------------------------------------------------------------
Mingwei Zhang (1):
      KVM: x86: Service NMI requests after PMI requests in VM-Enter path

 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
