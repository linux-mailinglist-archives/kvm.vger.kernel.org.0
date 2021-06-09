Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCAF3A1CDF
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhFISlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFISll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:41:41 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E8AC061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:39:46 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t9so20303553pgn.4
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dyisCbJs5UMiev0t7mRkkDpb8xBSDaqx6kusLdKkM7g=;
        b=Q9tv3eigee2r4gtIZWDaDmPO+gvJSjVMa0F5/MKY8bvyQcTYpjUn7JFROI9xO14Tnp
         V57oi4j1tsScLOR+RFCLFyVmpTae/zXG4yO2zjc+haoN6f+LUgrg1WdFfJeWkYgmQ10A
         rikm37cqaLq++c5v+7SavzGgytVGpDP4WHZc8KcNCnTSLRpM8hO4/YI/GzY7jOgUMfYp
         pAYSqq4wOj47ceQ/0ZfRDZHQkg4p1wugiFELL98qJD5z11XLmqfmydrjSNVngr9PMSpG
         wljMxR9XeUyrPZdOutB/cgBrA2DlN7+nIEJGXuUglThRnJpGpKKTyPecl2zvOEkg64IR
         ogqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dyisCbJs5UMiev0t7mRkkDpb8xBSDaqx6kusLdKkM7g=;
        b=kVgsl+PGUt/6ZecFoaBMEaFwTvL+Xj1ZyvzPDkmAKpQNpPSUSMGQE2k90eMiUrQJqU
         tG0bLmqgH+IqrifzRZ5iY1jY51p12ANgfEgY+Hk+K1fR4xtP5VLz8zEz7WvFHt+95v/G
         /Fud0Tx6L8S/YwfXtBOzkVd9kydpUO1OHYGHsnBICcyJJFBEabmUUpjPHkuT5kC8laFl
         KogRnoD/zjzstpL49CixXwqXJk8HoTR1dzSG6Ql+C+zKgkulMuzMx5qNSXzPPJiVV6De
         WGoAwN6Dm1Z0moWHNOYiaxx6g7f5cI34LSzC8hkCCFavR6ihtf3GQe72FFlSvHcbBKDC
         QoEQ==
X-Gm-Message-State: AOAM530SBOUQ69m0Yqh+27hVfQC7wbD9G4EUr0YzFU0IqxNfPjC5F4eK
        FFEIlrLO5YpKNvcVMtsHt1nSo2vKUuYJVQ==
X-Google-Smtp-Source: ABdhPJxk+EkT+3z4ZwJMZOIFpb3sTUbFHYcQVScHlA4MbIjUeyTA/mY6e9zqYs1VnpXWlnvP7fgLXA==
X-Received: by 2002:a65:584d:: with SMTP id s13mr1034077pgr.77.1623263986278;
        Wed, 09 Jun 2021 11:39:46 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id z7sm449010pgr.28.2021.06.09.11.39.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 11:39:45 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests PATCH 4/8] x86/hypercall: enable the test on
 non-KVM environment
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eReO7-L0hcMuMs8N6Aeb+JrfOcsNck95cc40f1Bj1Nvkg@mail.gmail.com>
Date:   Wed, 9 Jun 2021 11:39:44 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC124CA3-FF2E-416E-A0F3-993CDF1AA3F5@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
 <20210609182945.36849-5-nadav.amit@gmail.com>
 <CALMp9eReO7-L0hcMuMs8N6Aeb+JrfOcsNck95cc40f1Bj1Nvkg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 9, 2021, at 11:37 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Wed, Jun 9, 2021 at 11:32 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>=20
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> KVM knows to emulate both vmcall and vmmcall regardless of the
>> actual architecture. Native hardware does not behave this way. Based =
on
>> the availability of test-device, figure out that the test is run on
>> non-KVM environment, and if so, run vmcall/vmmcall based on the =
actual
>> architecture.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> lib/x86/processor.h |  8 ++++++++
>> x86/hypercall.c     | 31 +++++++++++++++++++++++--------
>> 2 files changed, 31 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index abc04b0..517ee70 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -118,6 +118,14 @@ static inline u8 cpuid_maxphyaddr(void)
>>     return raw_cpuid(0x80000008, 0).a & 0xff;
>> }
>>=20
>> +static inline bool is_intel(void)
>> +{
>> +       struct cpuid c =3D cpuid(0);
>> +       u32 name[4] =3D {c.b, c.d, c.c };
>> +
>> +       return strcmp((char *)name, "GenuineIntel") =3D=3D 0;
>> +}
>> +
> Don't VIA CPUs also require vmcall, since they implement VMX rather =
than SVM?

I would add VIA for the sake of correctness, although I presume it does =
not really matter in real-life.

