Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0B276D46A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 18:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjHBQ6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 12:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjHBQ6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 12:58:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441F1712
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 09:58:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d2a7ec86216so33558276.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690995498; x=1691600298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PzbCDXFnk3w2SSf45TXB2yxLMTvmATReUsA4zCcZwws=;
        b=lyoh2SBz23Xi/1oythXCvD4eYT/mDAOe1c1NCuMnLDbp/ZF1fVWTZSS7U8LfcMunzP
         jkvpro9VFgWnjS2rIuQKBJORICyNhyf5NOWNBck6eMYluV3+8yr9OmHJ345iUgzR1c0R
         tRd6tvQUb71r2RPXSvUWe2DEcA4tQcmDlsNvbWIQUYfsb6stBllbtNrWVjJy6HEnXGoJ
         zZat4XSMBiInPICo94A+caZSdOnVvOcAzZvymmXkKrO3bOSubnDyPyZ+k50A3aT/BK3z
         AucwqqUgcTPSCT8zRp6TNveYxdxmpZNU2X3TsgfbiaSFvqUqk0vEnyCDp0KIvCrp74RX
         u5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690995498; x=1691600298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PzbCDXFnk3w2SSf45TXB2yxLMTvmATReUsA4zCcZwws=;
        b=khf8bRy/Yv8YVlvLTMHBkiZDQQFspLni+HgcROFv/TMex0Vldqd0mPmOcHayE1p9U+
         KocJFSjxxY0OJG/yxj1nTr86B3XW2tGD13wDH0fOj1d61ckfobGl8Bw+gZhifdKA2mBc
         tLZTdb7XzZfHTYzcg1odl1BxMY4xTetmIISMtSUJTzBXtKbC90Aupjvq3Ydmmk2U+0ZQ
         laH6mVj07s2Mc4D/iOAxZ/X3jwrwGET0vxcKmBwVI7PP92w/1+JmLGgLjhFQWB8qEsEE
         ibh5GrvE8Qxmwk7ksx7qmhJR00G5PZ6M4owLAdUHtch84chfCQLh6jmh/ZPvucUpEdtc
         27HA==
X-Gm-Message-State: ABy/qLa3Mx3EEOJWxz2UsFNvWmc+OXFol15o8QxIeij7pMRzXN/9TxoY
        WTo21piRrfvIU3rEji18esw01U5b0Do=
X-Google-Smtp-Source: APBJJlE6rEuH8LasDnQfODkiDH09tFBtZ4sbu1M/IsR0DKMHMrqdBmEz7WgWDwSbKp4OvDE+w/rV2l2PoNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4109:0:b0:d10:c94a:be7e with SMTP id
 o9-20020a254109000000b00d10c94abe7emr109911yba.8.1690995497821; Wed, 02 Aug
 2023 09:58:17 -0700 (PDT)
Date:   Wed, 2 Aug 2023 09:58:16 -0700
In-Reply-To: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
Mime-Version: 1.0
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
Message-ID: <ZMqLKAWRapQjGgWR@google.com>
Subject: Re: [PATCH v1 0/4] selftests: kvm: Add LoongArch support
From:   Sean Christopherson <seanjc@google.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please use "KVM: selftests:" for the scope.  There's no "official" requirement,
but I've been heavily pushing "KVM: selftests:" and no one has objected or
suggested an alternative, and I'd really like all of KVM selftests to use a
consistent scope.

On Tue, Aug 01, 2023, Tianrui Zhao wrote:
> This patch series base on the Linux LoongArch KVM patch:
> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>

Is there an actual dependency?  I ask because I'm shepherding along a series[*]
that will silently conflict with the ucall support, and in a way with the Makefile
changes.

If there's no hard dependency, one option would be take this series through
kvm-x86/selftests (my topic branch for KVM selftests changes) along with the
guest printf series, e.g. so that we don't end up with a mess in linux-next and/or
come the 6.6 merge window.

https://lore.kernel.org/all/20230731203026.1192091-1-seanjc@google.com

>  tools/testing/selftests/kvm/Makefile          |  11 +
>  .../selftests/kvm/include/kvm_util_base.h     |   5 +
>  .../kvm/include/loongarch/processor.h         |  28 ++
>  .../selftests/kvm/include/loongarch/sysreg.h  |  89 +++++
>  .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
>  .../selftests/kvm/lib/loongarch/processor.c   | 367 ++++++++++++++++++
>  .../selftests/kvm/lib/loongarch/ucall.c       |  44 +++
>  7 files changed, 571 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/sysreg.h
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c
> 
> -- 
> 2.39.1
> 
