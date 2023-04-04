Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1E66D6C97
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbjDDStM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDDStJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:49:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8EF3588
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:49:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d2-20020a170902cec200b001a1e8390831so19586623plg.5
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680634148;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KcGqalmtswcdZnLa66v1qrQlXLxvG7vJhdbOWQuiwCI=;
        b=fXou2NEhv3ab//I+xrpQoEzSFUS8RtTX2GDtCJ2S1LwzkzYscrvTnObdo/N8k1aW5R
         qGtW/wSm7VzK+mq7ANWs2cEF5DEprZ7dLQNpYOE0tCB5ldW7JdkKQR0GZokU/eCR9mPI
         +QpzmkV7LRMX66AKlaXsLcbohre8Wodra7/Sms6Me4XaumkH6uV41RA26hfKkedomXZl
         n7g6LY04For/kjfaPkLNGuUZf3HlPX/uJC1oH7yfBAtDa3/8bEPicv4X9xMRbJ5ZDhMG
         VNW06AYGcRTbpEIOsEfh/xQsm7bKu+O1mgf4R43PsTGghf9BQYT8sXNpOAGZaRthzrz5
         OzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680634148;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KcGqalmtswcdZnLa66v1qrQlXLxvG7vJhdbOWQuiwCI=;
        b=1xDHCUqT70jBDL7JRuEAa3l87wxu4xB9EvQnlpa0cBcdhiGm0eKeR12msmk6LM7q+v
         3pF2PEXfI9cY09w2+82DB5b0LuomUScEfrs2ABkv/4GCGfAlP3N8bFyMbLQ1VAAR24H0
         sIikHi/sspTj7jP6lJzUfkga6N1tXnBnsPwc8THZF7qHiBq4n8nyUw1BSZra6GTflvyD
         j1J0/1IEOBKfm42xlGWava6vMdZHVpnGvF94fmH19yeQvoTbhGhAvcxSb1Wjq8RfK0L9
         ZI87rOoQ4N3LJptoY+PT16iXtIBJcZ1gmOppeYi90AznJbK5WU364C2OMCTW0/CRIuLv
         BJQA==
X-Gm-Message-State: AAQBX9fypiSghj+xmq0PBAAtW0Zbs+LAHfQ7yh17hfFoZt5ja7g3K4fr
        Wspqi/A0fsfH4bsPmPpEdeeY31AGQEQ=
X-Google-Smtp-Source: AKy350aJJljDoT8VlsIAR5k+Z89iVvtwLT0EgWmFqbGdEGhfgC9mxG5gLao2jco5kDsd4Zgg3chrs8PHyco=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d20:0:b0:4fb:9bb1:46fa with SMTP id
 c32-20020a630d20000000b004fb9bb146famr1054172pgl.0.1680634148171; Tue, 04 Apr
 2023 11:49:08 -0700 (PDT)
Date:   Tue, 4 Apr 2023 11:49:06 -0700
In-Reply-To: <20230404165341.163500-6-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com> <20230404165341.163500-6-seanjc@google.com>
Message-ID: <ZCxxIj0Go5XA6LPU@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 5/9] x86/access: Add forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Sean Christopherson wrote:
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index f324e32d..6194e0ea 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -143,6 +143,12 @@ file = access_test.flat
>  arch = x86_64
>  extra_params = -cpu max
>  
> +[access_fep]
> +file = access_test.flat
> +arch = x86_64
> +extra_params = -cpu max -append force_emulation
> +groups = nodefault

Argh, this needs to override the timeout.  Ditto for the vmx_pf_exception_test_fep
variant.  If there are no other issues or objections in the series, I'll set the
timeouts to 240 when applying.
