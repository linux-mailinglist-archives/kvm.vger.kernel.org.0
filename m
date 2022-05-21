Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF0C52FA58
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiEUJc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 05:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiEUJc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 05:32:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74BF264700
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 02:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653125545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvxdXwOHitcBIpGs6wIQPCxkxQb56H4Xqa134ITbFFo=;
        b=KjPKvMT4/JKDHwt1VaWIOxUUl/giI3sEMf7IUIZu4IsrS14OXDBrMCxzEkltqub5d5IQlj
        8FJ/BLd8aXXXyBBmcOzlUxPoJF4oYraPitH0SRI/pEbLyoIs5+OEbJgcs12FFQ+mKRWPVb
        i9DzpE3JJ2987DPL+e2I9QaI1NHnFBA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-Z3wGf9chPP2tlhgVcZgApQ-1; Sat, 21 May 2022 05:32:24 -0400
X-MC-Unique: Z3wGf9chPP2tlhgVcZgApQ-1
Received: by mail-pl1-f199.google.com with SMTP id p16-20020a170902e75000b00161d96620c4so3924938plf.14
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 02:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvxdXwOHitcBIpGs6wIQPCxkxQb56H4Xqa134ITbFFo=;
        b=7hNK+CRyX/AhVJg3y/n+py/XPlelANZyCEHfvsReA1lgPFct9ERKDwNY/GE7dqEbQB
         dANTK165muzvDl8IjKWKiitSn+oE0GpouyzjftV7Uc2D8W2ZzvEUUIVPelqSPdQOO9TX
         1GBdghL41rQMyQBfTdVlhe43Xn9cwNoXVCPMMuo83hoWG0gcGj1bLqo1uQpjxGlBy7EZ
         httY6fTfDoDTukTDTmIDk9fnbrLqHoFzWICSd16hgi09HQgUEimGJQn1cYSLLHe9/ctL
         i5N1ittIvsmo22EJRu6siWz7OwWtkuy8d23T+fNIiMucmHH991445ESiDCEwfKqqEi5m
         pLnw==
X-Gm-Message-State: AOAM531ac7ruRFwygQ6pZbmmWzhxiL2ydL5Pk/iJIrOIekDnsW72MDCG
        M3Kroadh1dGp0XeCppjducB2R/+xSYKf1jtWsAeupvwXEYFjyLWy79ZuzOO+h9YEJFGFJtj5q9w
        1y9BvcDiu+ugv8MJcjSKfTko1qZQ1
X-Received: by 2002:a17:90a:de02:b0:1df:3f94:811c with SMTP id m2-20020a17090ade0200b001df3f94811cmr15866272pjv.112.1653125543198;
        Sat, 21 May 2022 02:32:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZSU2qJUc3vst7EcYhkZxGtYX1NO9nd4dXQIH+kq11dwaVfU8QzctRDQMSoJsmOb3HNifMH180iKdF5vsCY3w=
X-Received: by 2002:a17:90a:de02:b0:1df:3f94:811c with SMTP id
 m2-20020a17090ade0200b001df3f94811cmr15866253pjv.112.1653125542902; Sat, 21
 May 2022 02:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220521093017.148149-1-usama.anjum@collabora.com>
In-Reply-To: <20220521093017.148149-1-usama.anjum@collabora.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 21 May 2022 11:32:11 +0200
Message-ID: <CABgObfauKbK5oepM49CKH4yJ3mBVzYTtLD8ycsobtmxTtgMCqA@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: correct the renamed test name in .gitignore
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        Yang Weijiang <weijiang.yang@intel.com>, kernel@collabora.com,
        kvm <kvm@vger.kernel.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 21, 2022 at 11:31 AM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Correct the vmx_pmu_caps_test test name from vmx_pmu_msrs_test in
> .gitignore file.
>
> Fixes: dc8a9febbab0 ("KVM: selftests: x86: Fix test failure on arch lbr capable platforms")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

Hi, this is fixed already.

Paolo

