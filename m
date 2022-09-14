Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848F25B8F31
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiINTNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 15:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiINTNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 15:13:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2982840
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:13:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id iw17so16125593plb.0
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=S9L54d9ejf1NmwAUJDCigQttDKda2K6sfA3rObHzMpg=;
        b=c4hDS2zVBu9ei6ererX584QnTMU4ialGRb8hnZiD1e3jQuwv1JWFp9QHAvikvqEl39
         ZAnOR07KIs+mSq/734pcyXR9Vl2gV7hqDv5drUjZdLJD890ni9m2kiL2bKZoNS56KEe8
         QHmOU9EHw0fw0g7awK975CXDVvaP7ooYE5Gn1Hgb77HMtYvfZsEGUuYtnj1Wa1jZBNUt
         i4XHe6ReITMhxzY4tJnVT4WmbXiwVeoo9G655/n5tMa/1QuLotr0n9ZOcFL/9ed4k+8x
         Dc0kPWNsG/Xjozt/+GjLJnL1aeX+1PZTXrxD6MsQRu3s1Fyst7x5BqjiiD5EbcdtuGTy
         Q8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=S9L54d9ejf1NmwAUJDCigQttDKda2K6sfA3rObHzMpg=;
        b=eeSPBr55vBVJ3PzTnQ11qGM5Ew6jruxUkbpwYGUxmbUbk3LGQ51hi9yTo5u6wxSB0Z
         8aHlu9mLmBP3bbWsIae4vZ657g/PMzdnuDbQSLWqWtByZukDJjCR7O6sMraxJlzKTyak
         lAyabU7zWI3TDAcq7eybkPw4s5XVpVHotDt20qN/QZQ9/uVBLk3T6F/zFsd3G9OtpArv
         ta5Qq4f5Pi415qiJ9fSXlkHD/PJYI4t/r0KJIT6yiLmi31zOEbndkk8gBmVk/lNvboB/
         qf/9TWE/KyKYOVIpubzsh6KqXLONvufx9n6+whpdO1jgATsbXqAvJe0q5EC5uJVpkpbQ
         T+uA==
X-Gm-Message-State: ACrzQf1X1dILqXwZEWTZdAlDncLu8Yc6EKBdRXWIG9BimqZBy75zhMjj
        zxTeCyHVmNJeil128Vn9i9UUsSWY1m0ET6mU5hOJM7GX+Zk=
X-Google-Smtp-Source: AMsMyM5fHYc+9/PnP/ka9LKtMpxpCAUVFD+ABMudbEnATQqSfJ7PMh0Gh0dnoR+kbfgy/nNV/RKHgcL9W2zSnT40pV4=
X-Received: by 2002:a17:90b:38cc:b0:202:e0e8:e802 with SMTP id
 nn12-20020a17090b38cc00b00202e0e8e802mr6469336pjb.121.1663182820042; Wed, 14
 Sep 2022 12:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-3-vannapurve@google.com> <20220905074609.ga4tnpuxpcgppx4r@kamzik>
 <CAGtprH9Kaemwupgoo_kgM-Ci2cnN2kpXa+ZwEymSnYNFhS9Fsg@mail.gmail.com>
 <Yxpc8NDdtdOl9wpH@google.com> <20220909070125.dtqfa6neq46fvns2@kamzik>
In-Reply-To: <20220909070125.dtqfa6neq46fvns2@kamzik>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 14 Sep 2022 12:13:29 -0700
Message-ID: <CAGtprH_PaAWqvT+89nhUbBV3QjO2b0i=KS4s6dL0ZxZA3WZ8GA@mail.gmail.com>
Subject: Re: [V1 PATCH 2/5] selftests: kvm: Introduce kvm_arch_main and helpers
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     David Matlack <dmatlack@google.com>, x86 <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 9, 2022 at 12:01 AM Andrew Jones <andrew.jones@linux.dev> wrote:
...
> >
> > void __attribute__ ((constructor)) kvm_selftest_init(void)
> > {
> >         /* Tell stdout not to buffer its content. */
> >         setbuf(stdout, NULL);
> >
> >         kvm_selftest_arch_init();
> > }
> >
> > Per-arch:
> >
> > void kvm_selftest_arch_init(void)
> > {
> >         /* arch-specific pre-main stuff */
> > }
>
> WFM and I think that's what Vishal was suggesting as well.
>

Yes, this matches with what I was suggesting. Planning to post this
update in the next series.

- Vishal

> Thanks,
> drew
