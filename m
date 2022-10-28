Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2686106E2
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiJ1Aef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiJ1Aec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:34:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C5365AB
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:34:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 20so3388371pgc.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwZM1Z+/ByDUrMF7vIE1QPzS4Rucz7dd/HrCKuTpeAQ=;
        b=QBohqzyNO60f8oRca4cWRh0XtyrcY+f+/oMt2NHC0kjN2gucNJxOl2Os2LzD676VIv
         YAml34CZ9zK+Gql09TtQkGvRIRYaYSl76HtIeDJScJqyroffRHBxB2zk453JRE4GL+F1
         Yog4SiWgzcpasnP0ELgAWOKBWB5UzTZgVJIAiVGbljJzLxv7GqXfZbLyF8xjZsilIRim
         JsctoHT7Ark5mntxzBXGyxsWI/FNBwy6jaZxOf83yTx3/Xb45XJ281GsR9pZ0atg6CS0
         RhJnur8QTKzkNyfWjY7k+IB+6vi4LyRVSqHZSh9dh3QGnzhK56EoxSQ7isQxECtZjDKh
         xH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwZM1Z+/ByDUrMF7vIE1QPzS4Rucz7dd/HrCKuTpeAQ=;
        b=jK4sYCcEoeAZq1+i3eTix83RExM3d84ydJtbbF+NmK1ZYC2LnHJwz14fc61k2EP6cE
         TEV0sQg19KPjepWhCXs3alJdIGDQbkSRJy+IYRYybYZgtnlTL05Qeod39I5QKm4fTTxY
         /FmeiCEVOcOWxogwDBv89dQyJALGCgeIEahUHPAd7j70ieKB1hKM8jE4YQKHpLuR8rHu
         tFjZLxiXUm125heQezj2P9e29HvEBqwh9qXRPCnp5TMVjy1w/vSSXCBjxb+mE1ID8G1x
         vsqybjFuzG8qiWDlQ22VKmWjkneO9o5vX+Gn1NaKkio9MAae6SWNoSyUiWeIUOMykEg9
         xn6Q==
X-Gm-Message-State: ACrzQf2Ofw5kVtJErbKJD5lr6nMtQXJvpXyj82ZjyqPKGseWUlhNMATc
        zoVyFiBAdpVVBNXMuoqAYkKHaA==
X-Google-Smtp-Source: AMsMyM7mcfC1fL05OP06KeB5nTvH5y0ELEOyeCYFHfU1TCH2ncNNcmrW9I7v2BQjgn3zIKZ6YL1XTw==
X-Received: by 2002:a05:6a00:2288:b0:56b:fe9d:b4b7 with SMTP id f8-20020a056a00228800b0056bfe9db4b7mr19663230pfe.79.1666917265938;
        Thu, 27 Oct 2022 17:34:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v1-20020aa799c1000000b00565b259a52asm1744133pfi.1.2022.10.27.17.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 17:34:25 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:34:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/8] KVM: selftests: Copy KVM PFERR masks into
 selftests
Message-ID: <Y1sjjs/wlYdHvmgf@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-7-dmatlack@google.com>
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

On Tue, Oct 18, 2022, David Matlack wrote:
> Copy KVM's macros for pafe fault error masks into processor.h so they

s/pafe/page

> can be used in selftests.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
