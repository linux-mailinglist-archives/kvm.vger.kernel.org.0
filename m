Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D5E73216B
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjFOVNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 17:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjFOVN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 17:13:28 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193A22735
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 14:13:27 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b162127472so63586a34.0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 14:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686863606; x=1689455606;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZDhRhUq3DfLmNXVoNlWULDE3rDnopfLnw5Y4xrcDns=;
        b=lnhKjV35ZFD5gT/eOusgpEPLm4nh8MsskJt73a6occhM07GyFEcuE74Gvc6dB1G1Yg
         ZZJ9VopDWKRMu1xyU/Eu/KJ80VSY7z9gjIBgg2YUse5EqZd8P999pm6vJhIONa1Cl1OR
         2urUCbiiMr18Dfw2o8Eg61OLZl1j1lqmafWEQr4taRf/6xKE1CJaLiNxPOLe96xyLC4V
         rKt28IB8viNVGjcLo/motmB/yapuz0AFbVk/fByoEYoXH6HCXj9TQZ/x1E635jXK0xZt
         EJtlsuvx6gycEhddxa2U5Chwj9tDgcWzjSy7y/uyQlX2StUbIdup5zJ1WbalpWpbJ/SU
         q7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686863606; x=1689455606;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZDhRhUq3DfLmNXVoNlWULDE3rDnopfLnw5Y4xrcDns=;
        b=JYJ1tn0LDuobqJAy9Lzr6Zawb5mODj5LhbKUkht2qCzZn7AitYUu4uqh8w/+lcUQqL
         X6VC5b6Quqf0T6NcOgSY59Yravty4P7gkHdvHAfYOrhMSJtNqbmVn56Mni7autywk77a
         Rccex7pwX+g6bvUqvLRjK/QSiP7zk8vDfXid9ad6cCeRNPRwgUcmG0ixnjNkDhOylhww
         NYZecSDqD4QRdKIInmbzJVAGl2YFCh4trtoM/PAhBL5Kl9oVFXbdDGiZ43aDRFY/Fi26
         jkJzd1ELCtRrtTALU/5oDqF9w/CvT8F2UZw+ik5na7bVhHSjKD40keVLuBVZ63pTq2Tm
         X7bw==
X-Gm-Message-State: AC+VfDy+5ff723iBSq4NwK54JCXig23HNA+RydDGY7hNyRihQwQO9A/V
        7mPn9XvaDou2emX/HhDW2v4=
X-Google-Smtp-Source: ACHHUZ6yzeRgZNuDIT2AWjFGsT1UPFRqpgWodbkirdCORIRdR6vMQBJYJFnsMgt5ovQ1gNP0oEQ69w==
X-Received: by 2002:a05:6359:227:b0:129:b810:926b with SMTP id ej39-20020a056359022700b00129b810926bmr12072303rwb.4.1686863606060;
        Thu, 15 Jun 2023 14:13:26 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id y3-20020a636403000000b0053ba104c113sm2511875pgb.72.2023.06.15.14.13.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jun 2023 14:13:25 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
Date:   Thu, 15 Jun 2023 14:13:13 -0700
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        android-kvm@google.com, Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79503FB6-6000-49BA-A7BF-9435A5FD0401@gmail.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
To:     Dmytro Maluka <dmy@semihalf.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jun 8, 2023, at 2:38 PM, Dmytro Maluka <dmy@semihalf.com> wrote:
>=20
> On 3/14/23 17:29, Jason Chen CJ wrote:
>> On Mon, Mar 13, 2023 at 09:58:27AM -0700, Sean Christopherson wrote:
>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>> This patch set is part-5 of this RFC patches. It introduces VMX
>>>> emulation for pKVM on Intel platform.
>>>>=20
>>>> Host VM wants the capability to run its guest, it needs VMX =
support.
>>>=20
>>> No, the host VM only needs a way to request pKVM to run a VM.  If we =
go down the
>>> rabbit hole of pKVM on x86, I think we should take the red pill[*] =
and go all the
>>> way down said rabbit hole by heavily paravirtualizing the KVM=3D>pKVM =
interface.
>>=20
>> hi, Sean,
>>=20
>> Like I mentioned in the reply for "[RFC PATCH part-1 0/5] pKVM on =
Intel
>> Platform Introduction", we hope VMX emulation can be there at least =
for
>> normal VM support.

Just in case the PV approach is taken, please consider consulting with =
other
hypervisor vendors (e.g., Microsoft, VMware) before you define a PV
interface.

