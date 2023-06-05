Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029C97230B7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjFEUJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbjFEUJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:09:09 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491F999
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:09:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565c380565dso114723817b3.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 13:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685995746; x=1688587746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=waSzY/YBXUDNVBBxcyEWarzX7p9eOgWdNZXiEb6mO3I=;
        b=ftfhgS76kYFI1mQHwaqA99pxljTeUef2aRxb9nE9ZdNHslcvV6Ae9Jmo3UfDRV6LAv
         XaPgBs99dJcCaC3rNQFSf2vwQEvOZMWByDS0g7wsb//nYXowIBD10o4ami/OE8n75Yh1
         /a8Z0oKsUDmk6yv0Vbtg45fH+JFBDuykDNpnoJrg0Ko97/VIgaeRFbjnyJFnsGE//UDP
         MKkhQlUCSHgk4n1fmFcYPHU/5//asEYP/+vqdEJkyPF/AKnHcUE5wkLfte6i4jCrv0Mk
         +YDtiGePZrz29eR7TMn5TPNrUBUhRZkd3b1XLbZhmoiko+aFwnwuiq5TVXTiCYfYB2av
         Dyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685995746; x=1688587746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=waSzY/YBXUDNVBBxcyEWarzX7p9eOgWdNZXiEb6mO3I=;
        b=ZxM9Y959Vexjlvrg5vVpSmKGSa/ZFz9CcIHISutk+OiwjhF1FuCNm37dIySbNlp0b3
         l8wTPCqItfYd+VT2s4t4mYyMeMTD8J6/LGivHVwQfIdbaBg0Bpp5AlgqVN8g9Dqr/50d
         CfIZVhlPUZARIR4rBxuYzV5+DuDjk9BF3cOSCv1qlIh6Skh0C+DjVYe18oQhwsG6+3CT
         VfY4R1mEIh7qjD8LOyBjHhV6Q7Uv/tTSTPMlU8o70sFbxJmTOPkNRGhQe//lRnGZ+cMe
         j4KwIUGK+rQp++LH9LIZnrYwzP2zf6+90elY86IkOcFbEFlwQ/k8mHhF4bWQLUADIt19
         mNmg==
X-Gm-Message-State: AC+VfDxjj5o1Hlev2SXv6i5lGz+5NURMzd7SWdjcKnZKRQGVaNGh+61V
        XEemzfz50HHlXZFhF/PFmXzsFZUWmWE=
X-Google-Smtp-Source: ACHHUZ7XPe+A4mVVEv2cg2BdI9QXuQ2EEGF6oe+DvxtmbipaTMfs9SkxHwoX+bLJiyHRJF71iOnZiOsTGMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca13:0:b0:559:d859:d749 with SMTP id
 p19-20020a81ca13000000b00559d859d749mr36958ywi.5.1685995746567; Mon, 05 Jun
 2023 13:09:06 -0700 (PDT)
Date:   Mon,  5 Jun 2023 13:08:58 -0700
In-Reply-To: <20230518091339.1102-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168599391997.1128436.16066419374996262965.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] KVM: Fix some comments
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>
Cc:     pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 17:13:36 +0800, Binbin Wu wrote:
> Fix comments for KVM_ENABLE_CAP.
> Update msrs_to_save_all to msrs_to_save_base in comments.
> Fix a typo in x86/mmu.rst
> 

Applied [1/3] to kvm-x86 generic, and [3/3] to kvm-x86 misc.  I'll post a
separate patch for [2/3], thanks!

[1/3] KVM: Fix comment for KVM_ENABLE_CAP
      https://github.com/kvm-x86/linux/commit/22725266bdf9

[3/3] KVM: Documentation: Fix a typo in Documentation/virt/kvm/x86/mmu.rst
      https://github.com/kvm-x86/linux/commit/06b66e050095

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
