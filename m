Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2AB763AC1
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjGZPSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 11:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbjGZPSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 11:18:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02938FC
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 08:18:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583d1d0de65so51099917b3.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690384712; x=1690989512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/SbDOlC/PTsalgsldKN8oRk7xsGDZQfDFDqWN22Gtfc=;
        b=jNDsxmZ0oStRlchdDZ2vKABh73bfMOOqsM4aL53+BOIDYlwxVU6KJgL+k7cfdCRkvW
         4MUBsnRv1nDNxyyhBMe8GnkqUg8je753+8tMHvZyt3Sn2mtgK+xz8R7ofO3z9DB/NbHc
         HnoyaG3W3d0BWBXp0InXiUlFYsKC8ExVqeQZVAlSYMsA0UR4GHnsj0ZyagXrtz+0///3
         dVK034DAg+wFoZj/cFr17KVUy923RYAc13G4oI1TUrbfb5B3QGKI/BMpGsP0z/13r/mx
         vRuz3twPx903wtlXZUbrWQwKy8IXTH6qYmBliNx8/+wsO+Gc+Y8HiPslFpg2/gOMt5Bk
         ZZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690384712; x=1690989512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/SbDOlC/PTsalgsldKN8oRk7xsGDZQfDFDqWN22Gtfc=;
        b=bx23LgaHSlWjXotVDkO4Eds9/yRGKz2rJco8ijdTFA49ooo+OfOHEUjrWvDLtSFik2
         f0cmfo4x5xD58uZ0w3ivST6c+jpF7GWTbCjbHiOugwe9LYRARNVCremnQvjlfN1vahAx
         dlgLaPsdlQqLjWTDPYvj1+VPWLHIn1TpdTCuHAjcqzk0I5WvqfLihyq5giXLW0OimdXK
         i9voKAro3Q3s3fUEi37aALk3MWoZCc020znajILnmP3xHdcSIVyH6ASgmYhj+gC5EMw4
         0Us61WXyPs1Gitcz8HnS/0AKgL6XLnWrD/fIL/AOf4e09VlVkJsu27F965jyqGiDdALD
         mp7A==
X-Gm-Message-State: ABy/qLZkHzPV6Boh2tHSdDaDO+AVbDazUN65mbc5kDg2IPMBTXc+zVix
        ZjRvRRIlzJ5ZMaZ+okJBZdPZdQjkgU8=
X-Google-Smtp-Source: APBJJlEMDrb4UHGIfGROgVMNUXWl0cyGq0IuQE+Td6NipqfkdQ7JkcIJonCw/hGblzl/Rdrt0TJAIeGTDIw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1803:b0:d0b:c67:de3b with SMTP id
 cf3-20020a056902180300b00d0b0c67de3bmr13899ybb.13.1690384712290; Wed, 26 Jul
 2023 08:18:32 -0700 (PDT)
Date:   Wed, 26 Jul 2023 08:17:50 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <169023385531.113049.17747041541704393217.b4-ty@google.com>
Subject: Re: [PATCH 0/7] KVM: Grab KVM references for stats fds
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jul 2023 16:01:24 -0700, Sean Christopherson wrote:
> Grab a reference to the VM when handing a userspace stats fds for VMs and
> vCPUs to ensure the stats files don't outlive the VM and its vCPUs, and add
> a regression testcase in selftests.
> 
> Sean Christopherson (7):
>   KVM: Grab a reference to KVM for VM and vCPU stats file descriptors
>   KVM: selftests: Use pread() to read binary stats header
>   KVM: selftests: Clean up stats fd in common stats_test() helper
>   KVM: selftests: Explicitly free vcpus array in binary stats test
>   KVM: selftests: Verify userspace can create "redundant" binary stats
>     files
>   KVM: selftests: Verify stats fd can be dup()'d and read
>   KVM: selftests: Verify stats fd is usable after VM fd has been closed
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/7] KVM: Grab a reference to KVM for VM and vCPU stats file descriptors
      https://github.com/kvm-x86/linux/commit/0d6d1727a21e
[2/7] KVM: selftests: Use pread() to read binary stats header
      https://github.com/kvm-x86/linux/commit/ba6ed5058b1e
[3/7] KVM: selftests: Clean up stats fd in common stats_test() helper
      https://github.com/kvm-x86/linux/commit/34ffae5d4294
[4/7] KVM: selftests: Explicitly free vcpus array in binary stats test
      https://github.com/kvm-x86/linux/commit/0dec04897a5c
[5/7] KVM: selftests: Verify userspace can create "redundant" binary stats files
      https://github.com/kvm-x86/linux/commit/518f3fde1f28
[6/7] KVM: selftests: Verify stats fd can be dup()'d and read
      https://github.com/kvm-x86/linux/commit/a4b51af2c290
[7/7] KVM: selftests: Verify stats fd is usable after VM fd has been closed
      https://github.com/kvm-x86/linux/commit/00b6b7e96803

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
