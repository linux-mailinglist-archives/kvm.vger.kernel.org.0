Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8888E69B742
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 01:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBRA6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 19:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBRA6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 19:58:15 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A3A5EC
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 16:58:13 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mj16so2857846pjb.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 16:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NjXQxU0MTNlezU2eGAKfedmw+7iHhF9c4Ur7D8yHd+o=;
        b=KHqIhrEDQSsz66Prz1EANNc1398H2HOk82HkHJPGXy4CaKATL7pajs8GcY/bMqSLId
         +s2i6sGBOZb/zbZFAJNB1/UPdX76Y2B/cOiEtsCqhvGQuiz/rVOVCmj/OrqIxHEHaDki
         Uz9+uEMCed9ZkphZ5xU//eQd8rZJQa/i3GVUoMZeQC0HpoXqwr/GWPZ4iiOUrq1+MmAH
         HeX4p2f1PTr/W4jPO0PrFnrXlw8OXpilSG182D6WPwPhBVBh0oMuF2zWRaTYUDERQJ16
         Cwaka4JpbHg81gpRmfesX/hlbI+jGPhAE2tTL7b31Sx+ywDHiP+1d6PRrv1eIOrZHoUr
         9LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjXQxU0MTNlezU2eGAKfedmw+7iHhF9c4Ur7D8yHd+o=;
        b=atlx13HCgQuTVvDQUfzh8IgQI3gtLL1M7dQSLghoaSwb2Vjc+/gH44N1jLifPdXGtn
         eUm6wZGUC0eMYYAJWmBYTs/fPmKdSQyuWO58mZnuHolKF4wIdLqTeoiAIqJ6BmIPn/0R
         cFzGUPcnGNTxvWohT8yNxQ5YZ56gzt9mTmlhtT1+YrIIjJsLgwuUzaHHiX2N3QoewRuv
         9Iti6gkiPjzC5jihPv5C9ZTqBqZhJ4IOxGttp8sTcnidCqZO15i3TdALoKbqPW/PezpO
         Vg0MlPwqTSjeA5niefanywzBtHHowCJ49C6MlF02AVpJaXIiZCj211PZqmLjVUkRH9O6
         tVtA==
X-Gm-Message-State: AO0yUKU/JdB/px0P3fgGiShXmVkpeq509wwISTUwA1T3hUl5kZV8dLq9
        Oyc6ZjY9j1d4z+I4QtwSNe3+Fw==
X-Google-Smtp-Source: AK7set8E+2CThG5C4mr5NX+XGSjdAd+deenCdQbsgIaZS18SAZATQEGrR/qt5BA3BWpBzJoSiyfgPw==
X-Received: by 2002:a17:902:ce84:b0:19a:9880:1764 with SMTP id f4-20020a170902ce8400b0019a98801764mr2588533plg.59.1676681892880;
        Fri, 17 Feb 2023 16:58:12 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id h22-20020a170902ac9600b001963a178dfcsm3697533plr.244.2023.02.17.16.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 16:58:12 -0800 (PST)
Date:   Sat, 18 Feb 2023 00:58:08 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>
Subject: Re: [PATCH v2 0/7] Overhauling amx_test
Message-ID: <Y/AioE5iY4clmUIB@google.com>
References: <20230214184606.510551-1-mizhang@google.com>
 <CAAAPnDF9qKq5+PpqjN+1g8=zn0tkQ=aPQupwM+gJiuSE12zb4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDF9qKq5+PpqjN+1g8=zn0tkQ=aPQupwM+gJiuSE12zb4Q@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Aaron Lewis wrote:
> On Tue, Feb 14, 2023 at 6:46 PM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > AMX architecture involves several entities such as xstate, XCR0,
> > IA32_XFD. This series add several missing checks on top of the existing
> > amx_test.
> >
> > v1 -> v2:
> >  - Add a working xstate data structure suggested by seanjc.
> >  - Split the checking of CR0.TS from the checking of XFD.
> >  - Fix all the issues pointed by in review.
> >
> > v1:
> > https://lore.kernel.org/all/20230110185823.1856951-1-mizhang@google.com/
> >
> > Mingwei Zhang (7):
> >   KVM: selftests: x86: Fix an error in comment of amx_test
> >   KVM: selftests: x86: Add a working xstate data structure
> >   KVM: selftests: x86: Add check of CR0.TS in the #NM handler in
> >     amx_test
> >   KVM: selftests: Add the XFD check to IA32_XFD in #NM handler
> >   KVM: selftests: Fix the checks to XFD_ERR using and operation
> >   KVM: selftests: x86: Enable checking on xcomp_bv in amx_test
> >   KVM: selftests: x86: Repeat the checking of xheader when
> >     IA32_XFD[XTILEDATA] is set in amx_test
> >
> >  .../selftests/kvm/include/x86_64/processor.h  | 12 ++++
> >  tools/testing/selftests/kvm/x86_64/amx_test.c | 59 ++++++++++---------
> >  2 files changed, 43 insertions(+), 28 deletions(-)
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
> 
> Would you be open to adding my series to the end of this one?  That
> way we have one series that's overhauling amx_test.
> 
> https://lore.kernel.org/kvm/20230217215959.1569092-1-aaronlewis@google.com/

Sure, I will integrate your changes into this series.
