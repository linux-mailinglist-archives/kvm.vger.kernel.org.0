Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E77759806
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjGSOUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjGSOUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:20:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223BFC5
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:20:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-577323ba3d5so13466897b3.0
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689776408; x=1692368408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nhEe8Ro3m3xzVle4clHGMPuyDiBtjYljaeIOHNrxaD4=;
        b=W5CztIfb2WV1OWqLAThymisnkJPQVhPq+rptaayQR88+SC3tZCZIZmDvoAzm9Rc0mr
         zT4hx1GUSD1sD7nHriR2nT+8WYZ7RQfzs61CwB0q/PMbEhe3SFBgktQsio2IgawVLhkr
         BYDmSWHJnulfQ8y8LqLZCLucqszhaZj4dHelTBP4r/9HO2L1uU5wOUOiH5/IVgelIGbW
         N228nAnoKOTr9l2EvlOOpnDIJHzBpPdiKrtJ3o6nFYbhcUXMBIE81Eb98RTXzJ+AIlgW
         5TLxT88Puoptxkgyii/kXfJ8SjYs2YpNsxVtYoegULEMlwsk198zpQZnISGnP+Gbm39y
         dCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689776408; x=1692368408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nhEe8Ro3m3xzVle4clHGMPuyDiBtjYljaeIOHNrxaD4=;
        b=V3PWJeqG997glDrj5tHraeMika9LkMVpbGutcbfH7PD51XGk3h6DYPcnSY6BGAMoWV
         5wDLdgxrKMTwN9/v26lH2tk1nRHXQ1leZzfizvbgZcOgExOoFY03bEf7WK9nuRcgdE45
         7wPw1ZWFj/gOCZ+kiSqoagj3tRUuOl804sLSAOJkwGSQWDE/aUFPECDojNOtBuFkvzG9
         3yiOO+1IkqTRNEB4mGZ+WZIJXtzPs+5cUi9rGrwC41OPVeqJg2+CCgRoPp0y8dyLhjhd
         g0CHhAaHw72/CsZwsvYg6aHPo7ue6Y/abqmc4aOMIwUpMwx3JSsXGRgH9A+4zO+LxPZV
         b7KQ==
X-Gm-Message-State: ABy/qLbhVQOEWH3jhR1hnG1kRFHVDkJRnCVQuGFmpOG4J9LkiUOps05n
        aDT7IJYpmsoOcQ22RfBQBQVApFSGpRE=
X-Google-Smtp-Source: APBJJlF2IkKp6n6PH2OlPb2WtD4mLbCloSic8/PuahGhbvnmxuxv/ezql90pF+Be+RGqIUM1q5hZ9k9FdQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f509:0:b0:ca3:3341:6315 with SMTP id
 a9-20020a25f509000000b00ca333416315mr33581ybe.0.1689776408256; Wed, 19 Jul
 2023 07:20:08 -0700 (PDT)
Date:   Wed, 19 Jul 2023 07:20:06 -0700
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1687991811.git.isaku.yamahata@intel.com>
Message-ID: <ZLfxFkFTotkOumRG@google.com>
Subject: Re: [RFC PATCH v3 00/11] KVM: guest memory: Misc enhacnement
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023, isaku.yamahata@intel.com wrote:
> Isaku Yamahata (8):
>   KVM: selftests: Fix test_add_overlapping_private_memory_regions()
>   KVM: selftests: Fix guest_memfd()
>   KVM: selftests: x86: typo in private_mem_conversions_test.c

Folded these fixes into the guest_memfd RFC[*].

>   KVM: Fix set_mem_attr ioctl when error case

And this one too.

>   KVM: Add new members to struct kvm_gfn_range to operate on

And also included patches that achieve this (and will also post them separately
as non-RFC, mainly to coordinate with MGLRU).

[*] https://lore.kernel.org/all/20230718234512.1690985-1-seanjc@google.com
