Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EC85696B8
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 02:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiGGAER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 20:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiGGAEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 20:04:13 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E992CE20
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:04:13 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id i190so2894028pge.7
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 17:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=70qEJk/1q3Dc54HdqEffROCpmHVBVttjElm44SoUSoE=;
        b=kr8NaV1FmOoEO2uHgm4xZdXKf7PoVpVFhAb6GKdGVsB8xjYDh2vyM1QTTwxM1FEQFF
         BkJFp56tvdFbwZNeGlwAHjJtowCjwbsxSymnODD1VNe6f4tkDWZDvHW/GP00mPucG48s
         uvxsfdqEprvVbvBs3KYRpH9QAeSj8NNMYNFw2+fsDJlGqgm4H83pAD73WGOKzOSeOVYA
         DcYtzgq+sCTGzSfRpAQzWMwCDkuwGkHLpqOXPsc2ufyeYLam7/ReKoqcmkb5r8jpFxYM
         IEu3CHKgQ9SwZhOwmOZFeFvow9EiMqKfVEjx5+gjum5f6tqt7940c2wnBTc9K0fpxZ+N
         e7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=70qEJk/1q3Dc54HdqEffROCpmHVBVttjElm44SoUSoE=;
        b=MlABZwD30q8kTSmR/BxIsdhJ0GnAkhY7MMhWd//YWwLsmeTxosjhpqWBYZG7yeNx/h
         WP80jmsE8d5DSMaw7fudmf1QPbeMxHB6G5kzr1N05qEloK0upCwcuLCpi6jyhPuvslpm
         NVXqq6tdeEDrN+i1ogikQVo7zrvVQOtZiArNVd3dr1WyggW+dd18Y9dY2S/grD97WJUc
         E5eFUJahLA1xtoneJKniKJqHD+8+4g/tR1dcEZbR6p2FrmDjT8W7t4HErUf4ssUQJ2Lb
         jhXPfyKNCK4roNdgX7shHJgMcboiobEAhQ1KRiC/dd6cg1KjYezNrNrNeFfFaoojlY25
         wBQQ==
X-Gm-Message-State: AJIora/wsnwuxou9WZWWEPc8VBo7j+3ucuNkp7/cPhA8GtjRP5Q3fVew
        x5SB2yjja2owUK1UJYKQDYawg4Uyx/g=
X-Google-Smtp-Source: AGRyM1teniPHqMsAoG6p11oApWQOPn0qxxM1jWowcxPs7wyTYDp+7QTr1qc4mCbu7s3YRiKbcLbWwA==
X-Received: by 2002:a63:595f:0:b0:412:5adc:fb07 with SMTP id j31-20020a63595f000000b004125adcfb07mr13608666pgm.296.1657152252107;
        Wed, 06 Jul 2022 17:04:12 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id x27-20020aa7957b000000b00528c4c735besm213448pfq.39.2022.07.06.17.04.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2022 17:04:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eQv6HKv4-gkpFOTw6A6k3awWcxgiQzyHH_6vLKxWAio8g@mail.gmail.com>
Date:   Wed, 6 Jul 2022 17:04:10 -0700
Cc:     "Yang, Lixiao" <lixiao.yang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6DCA1164-E5CC-46C2-8395-B32D687F4C55@gmail.com>
References: <20220629025634.666085-1-jmattson@google.com>
 <CY4PR1101MB22304D870D366B8483E6C9FCEABA9@CY4PR1101MB2230.namprd11.prod.outlook.com>
 <CALMp9eQv6HKv4-gkpFOTw6A6k3awWcxgiQzyHH_6vLKxWAio8g@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Jul 6, 2022, at 5:02 PM, Jim Mattson <jmattson@google.com> wrote:

> On Wed, Jun 29, 2022 at 7:37 PM Yang, Lixiao <lixiao.yang@intel.com> =
wrote:
>> This patch can fix the bug. I tried kvm-unit-tests vmx with your =
patch ten times on Ice lake and Cooper lake and the failure didn't =
happen. Thanks Jim!
>> -----Original Message-----
>> From: Jim Mattson <jmattson@google.com>
>> Sent: Wednesday, June 29, 2022 10:57 AM
>> To: kvm@vger.kernel.org; pbonzini@redhat.com; Yang, Lixiao =
<lixiao.yang@intel.com>; nadav.amit@gmail.com
>> Cc: Jim Mattson <jmattson@google.com>
>> Subject: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption =
timer expiration test
>>=20
>> When the VMX-preemption timer fires between the test for
>> "vmx_get_test_stage() =3D=3D 0" and the subsequent rdtsc instruction, =
the final VM-entry to finish the guest will inadvertently update =
vmx_preemption_timer_expiry_finish.
>>=20
>> Move the code to finish the guest until after the calculations =
involving vmx_preemption_timer_expiry_finish are done, so that it =
doesn't matter if vmx_preemption_timer_expiry_finish is clobbered.
>>=20
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>=20
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>

Thank you, Jim.

Sorry that I don=E2=80=99t have the time to test the patch right now, =
but I trust
you and Lixiao. :)=
