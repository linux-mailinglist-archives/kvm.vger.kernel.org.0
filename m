Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F079F5A1A72
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbiHYUiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiHYUiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 16:38:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762CBB6D1E
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:38:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso6365930pjr.3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qD6ZliJsA6s2l8d9zqsn2AY7abAbXk8ip2gFp/mSy7I=;
        b=SJ8sYTc8JRQiaQ6oRRtWX4MFHMSCo2XdhGKk2xaj2unDvP5PMYQqkog+MOoXT+7SGu
         FnB/Q52IagX1LHZVxpWnLfWAp4L6Zw1AVWk5mM3Q+ywFeRoZbVD/hnXtvERF+1IWSM+l
         uCoQhVIdmMrpeqXwdcxfzNIjSqYx+x4wZxwcnuEsYnPq0s/+tZ/DPVNPQtJNklN5r1e2
         mWSgByYbM7JKLpAnCqdGc5xQqIk14WsKs+UnwONOeU4t0IasQlceDbmeHB1oCGOQx0Ls
         Efj0Y5AQzmG+HcDJwS/bxqDFrSMfg4Zx++xjIP/xMsjSosOs28/Sja/LIpJoRqY/G146
         1Y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qD6ZliJsA6s2l8d9zqsn2AY7abAbXk8ip2gFp/mSy7I=;
        b=yyvB3fe2CZ9+lwzCMLjehqhGq3TVtk6Z/rQCkmprdxN/djeMV91/rkxFkNRVSHKfPe
         zqZpN1QraaqY1xthVH6mwpiI8dTsr3e6XkE5/qFHTAB7jaAjM62l3yKY6j5QScjJmtko
         JH7wd9PXAvrNJ/xJIXasmt9xaGy4WOAi2XDEvEn7dvKg4QMgvTGMEjCXw7s91ABLUbZ8
         p9IVRBRl5luRXnyx+AZXrUkEws9d5fOL+ICzVc3P1Wu6F+Y3KK2XKtpfsfEr8Eu41TYY
         oiVuiTBYbG0vBVkHYGFQwUxmBqpnK0yn9F3proR9XPuJWFWTjdD7V5b1RdJQzMp40v3w
         2V6Q==
X-Gm-Message-State: ACgBeo0jPawqPUHf47ewYBEDPBDMdMi/+TgqKvFnCRQ/cJyJkI8tQWSo
        OXXjIjBpsdZ+8sKliEHcT5MjMQYFYBbd2/wRWrJaiA==
X-Google-Smtp-Source: AA6agR47cZbJGmgbFboUwNUYzROA3izsO3sSyXOTucCkOjNs+7Fw+S6vE+UX47d4aoDRINtSeST8midQ+VNOkzhh6As=
X-Received: by 2002:a17:90b:1b48:b0:1f4:f4e5:c189 with SMTP id
 nv8-20020a17090b1b4800b001f4f4e5c189mr860155pjb.226.1661459888889; Thu, 25
 Aug 2022 13:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com> <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com> <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
 <Ywa+QL/kDp9ibkbC@google.com> <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
 <YweJ+hX8Ayz11jZi@google.com> <CAL715WK4eqxX9EUHzwqT4o-OX4S_1-WcTr5UuGnc-KEb7pk6EQ@mail.gmail.com>
 <Ywe3IC7OlF/jYU1X@google.com> <CAL715WJEkT6heVT1P2RZw_5NxBcORCrBTS60L_RZT-05zr_zsw@mail.gmail.com>
In-Reply-To: <CAL715WJEkT6heVT1P2RZw_5NxBcORCrBTS60L_RZT-05zr_zsw@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 25 Aug 2022 13:37:57 -0700
Message-ID: <CAL715W+y6kRvLUOpY+u91mdY1XdfaJsgzJuwozrZW3=UqSp2nw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending interrupts
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Currently, KVM_SET_NESTED_STATE is a two-step process in which the 1st
> step does not require vmcs12 to be ready. So, I am thinking about what
> it means to deprecate KVM_REQ_GET_NESTED_STATE_PAGES?

typo:

"KVM_SET_NESTED_STATE is a two-step process" -> "Launching a nested VM
is a two-step process".
