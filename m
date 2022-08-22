Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA3559C648
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiHVSbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiHVSaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:30:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61A2491D4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:30:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m2so10706204pls.4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=I08aAorT8lqXpia6za3e7c1Fim/NzBnEo/nXECBMKCM=;
        b=MUHV7Du5Kvle+zSFR4vKYqo2a/OWv2YdW44N0bTFZvUqhsNM967mc4r3i0zJEOUJE6
         1WgKf3OLQ1tUFkc6PUoaKMwk8R6a5diIc4XcUtU7iRqtg/9SbdYTwOGGW8E8SQ4bH1ID
         Rzyn8ZF+S0NHJ4gkfBHXIp0mCFk94HLFhhGJeVmBw6sr7EARN0XjvyV+cOwb8ASz7hBD
         DRIqKoGYOHXbI8pNRuA4iDGTnssm4kf9Th0YSwMC9KnieW5btBpbuAIPKhu4tWR5owFW
         LoaPeSYOgNM441KJr5eOVcD1ML7HelkIUq6g3gT3dvKz+ZCac6HC8eA83ORgjz97cBQk
         dqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc;
        bh=I08aAorT8lqXpia6za3e7c1Fim/NzBnEo/nXECBMKCM=;
        b=FyphB3bIiJU0B5a1qiKhcC7QVOTdHRbRyxG/FqpCgxB7sdi+A3p/MA9iD7yQfvxRN+
         3jQEWLYTrjJhq4qTc4MbpFijz0IDqfFXqrFsSAb/DNgh2IKkZVzb6aPltMpki3BF6W2o
         6Ts5y128sNbyBydtsNeHL/3PtqpEF0jghF1GhLsJzIDp8CQwCakk+WeykXVHXX6IqFxj
         PgdGlKjWS4om//NSlKitYEJFPWNrt9iDRP6ybpz1LR3muXIBFpF91QxgSWQudoCgSfaB
         zXB+cbmS7WqyPYTNLNrArxQH3ggCIuuTxop2X/FkxmNlnHWvqwm73XZq8Q0DkKNfGg/Y
         mV0A==
X-Gm-Message-State: ACgBeo0wmoRfPN5em3la4QzGmlcIsBtElg+L56u8V/CKGe7a4eApB4UM
        WeSUSrxPkutYXW/aZTNtEtSZKAq7fiG1Wg==
X-Google-Smtp-Source: AA6agR44F8KKciQzWf5MQAFwCcOCO/VCt0zThJPrkxv5YEAeB3h7VOr8pw6b1TCLdp+Tlals2YWBxQ==
X-Received: by 2002:a17:903:18a:b0:16f:9027:60dc with SMTP id z10-20020a170903018a00b0016f902760dcmr21169249plg.147.1661193026107;
        Mon, 22 Aug 2022 11:30:26 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016c574aa0fdsm8852949plg.76.2022.08.22.11.30.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Aug 2022 11:30:25 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <YwOj6tzvIoG34/sF@google.com>
Date:   Mon, 22 Aug 2022 11:30:24 -0700
Cc:     Michal Luczaj <mhal@rbox.co>, kvm <kvm@vger.kernel.org>,
        pbonzini@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <87756239-CB76-4D9B-AB63-49B70C8CAFD3@gmail.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co> <YwOj6tzvIoG34/sF@google.com>
To:     Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Aug 22, 2022, at 8:42 AM, Sean Christopherson <seanjc@google.com> =
wrote:

> On Mon, Aug 22, 2022, Michal Luczaj wrote:
>> On 8/22/22 00:06, Michal Luczaj wrote:
>>> Note that doing this the ASM_TRY() way would require extending
>>> setup_idt() (to handle #DB) and introducing another ASM_TRY() =
variant
>>> (one without the initial `movl $0, %%gs:4`).
>>=20
>> Replying to self as I was wrong regarding the need for another =
ASM_TRY() variant.
>> Once setup_idt() is told to handle #DB,
>=20
> Hmm, it might be a moot point for this patch (see below), but my vote =
is to have
> setup_idt() wire up all known handlers to check_exception_table().  I =
don't see
> any reason to skip some vectors.  Code with __ASM_TRY() will explode =
no matter what,
> so it's not like it risks suppressing completely unexpected faults.

I would just like to point out that this whole FEP approach is not =
friendly
for other hypervisors or bare-metal testings. While people might have =
mixed
feelings about other hypervisors, the benefit of running the tests on
bare-metal should be clear.

Specifically in this test, it is rather simple to avoid using FEP.

Oh, well.

