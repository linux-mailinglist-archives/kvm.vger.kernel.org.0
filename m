Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C528C233
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 22:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgJLUVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 16:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgJLUVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 16:21:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0BBC0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 13:21:11 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y14so15458590pgf.12
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 13:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AbVAphQjIeAuu/p/kwzxwOsNmWNyEZjm06zXvDPZDwI=;
        b=Tu+20qkv0gufJ3jn6iuMtXxfRvwv+2UxYCcTLAj8E3MVVP4zf35HLC2Lc7QEW0uNih
         U8Ufzp8AMxnnUB7JOBgQKLJew0mY2WpB12/NI6pfhZq2M89WYkfQK8ToptVu2spmXx6A
         bz0tRcLlQESwBMLc0E7Zsp+DThGcmY5uwSljLXmkVJfy4kAad49NvYn6Km4Sb6hIGO47
         3G8yUVxTwvoKk9vIQ8vJrX8yZHwuPyCoHix9vpdghGeISG0vsg/3gBob3Jsv0IFqXcxF
         U1wLQcXUXv48IC5rFLS/9RU/y14Ab6j2DxPxtTby7wRsErSXIG6mSsxW22lKIHzJKyMc
         BZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AbVAphQjIeAuu/p/kwzxwOsNmWNyEZjm06zXvDPZDwI=;
        b=eBOrtxtdWmBn6z1uuPE0vgReiS8Rhs4qV6zXH/VqOQoZhWTOCTy5Sffv9ujzPWA5j5
         u7lKBkNwwnzHm+bRgaPxH37KzX68+KS5pyukV81rhAB3rbvIAAqMu3UOl8MbHFKBkYNy
         lnaJUn3jWSvOOQRtQg8XlP1DY/mC+x16cIaIIu+FyB/7E3asGPyWC48CbeqPGmXhbYsO
         aWA0X9ZULEfCAqtxZGlrx5uQnK4DsM9rcFPWEfaXEn+HZN96hN7toGQPKBAIAacREx9f
         7KUNq0NMdBijjapAG/P3XJj7Tz0S2aiA6WzE7NYpld4ZGOIAMHtnsK20GlBUfXgQ9RfP
         2kqQ==
X-Gm-Message-State: AOAM532eEjK3YTLBFxEsWB7zfaSmX8bNoOXH+1UPxXyfGMGuLisSVdi1
        Z8pHNov33uYBxwsQMx7JHG8=
X-Google-Smtp-Source: ABdhPJyGk/jsY2mcZzL3VIVaJ3dmW/sBKMIUStOW20OO+fssPrlsviH1npJwb5yBQv1QCsC+9JDGTQ==
X-Received: by 2002:a17:90a:f683:: with SMTP id cl3mr22120265pjb.84.1602534071074;
        Mon, 12 Oct 2020 13:21:11 -0700 (PDT)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id r16sm24888009pjo.19.2020.10.12.13.21.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 13:21:09 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eSe35-8jCzXjYkGVkHfam2CPGCO5+A=1+OGGCnKb_yEPA@mail.gmail.com>
Date:   Mon, 12 Oct 2020 13:21:08 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <14261223-68E0-4D2B-9669-B3F48F4BDCA1@gmail.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com>
 <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
 <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com>
 <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
 <354EB465-6F61-4AED-89B1-AB49A984A8A1@gmail.com>
 <CALMp9eSe35-8jCzXjYkGVkHfam2CPGCO5+A=1+OGGCnKb_yEPA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 12, 2020, at 11:46 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Mon, Oct 12, 2020 at 11:31 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> On Oct 12, 2020, at 11:29 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> On 12/10/20 20:17, Nadav Amit wrote:
>>>>> KVM clearly doesn't adhere to the architectural specification. I =
don't
>>>>> know what is wrong with your Broadwell machine.
>>>> Are you saying that the test is expected to fail on KVM? And that =
Sean=E2=80=99s
>>>> failures are expected?
>>>=20
>>> It's not expected to fail, but it's apparently broken.
>>=20
>> Hm=E2=80=A6 Based on my results on bare-metal, it might be an =
architectural issue or
>> a test issue, and not a KVM issue.
>=20
> =46rom section 25.5.1 of the SDM, volume 3:
>=20
> If the last VM entry was performed with the 1-setting of =E2=80=9Cactiva=
te
> VMX-preemption timer=E2=80=9D VM-execution control,
> the VMX-preemption timer counts down (from the value loaded by VM
> entry; see Section 26.7.4) in VMX non-
> root operation. When the timer counts down to zero, it stops counting
> down and a VM exit occurs (see Section
> 25.2).
>=20
> The test is actually quite lax, in that it doesn't start tracking VMX
> non-root operation time until actually in the guest. Hardware is free
> to start tracking VMX non-root operation time during VM-entry.
>=20
> If the test can both observe a TSC value after the VMX-preemption
> timer deadline *and* store that value to memory, then the store
> instruction must have started executing after the VMX-preemption timer
> has counted down to zero. Per the SDM, a VM-exit should have occurred
> before the store could retire.
>=20
> Of course, there could be a test bug.

My guess was that TSC_OFFSET is left set by one of the previous tests. =
But
unfortunately, I do not manage to reproduce the failure.

