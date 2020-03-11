Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D029C1825EC
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 00:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgCKXfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 19:35:41 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55436 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 19:35:41 -0400
Received: by mail-pj1-f65.google.com with SMTP id mj6so1585639pjb.5
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 16:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4zuCrPDHBtAX21eY9BKIbx4zaoZTw3vfx8hnGFwyk5I=;
        b=cI3xnRPtZ0gJ6SxtNkOLCMVb+rU2wbQIr1qQT3zyzkm25a4PHdXkTJmLgF8NNdcL4j
         t7TcMqn0aNyS+tfXA/dLMXUhSHppqsSrtI0k9oJhd+WCIalNioe2yRt3K/4Oyqxedf9o
         adS3FrGxExEwBUIu2JMe/qIwyuQGhwLMl8eeb4NnblFWpuQ/Tit/kCr2GDoGKHfKLx2g
         97YT0ualChmYVu2KPLQxj0eVcSVyWeYlADsulBWvThUAVVSoNy9GFdIKPTHlIZEq/IP1
         Nk0ydgwatI8aBEFK6+Y6+OtjAns06B7ymZBeTWYy5SJXlN4+EpXGpu3AF/938YH9dG77
         MkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4zuCrPDHBtAX21eY9BKIbx4zaoZTw3vfx8hnGFwyk5I=;
        b=OmnTa8Q0VMQRArnIAaEwfQVeFDhk9kb8aQkI3KFc8UygNmsv+3tRUmqepOsl3fR0Qk
         wCIrJgy6U+hi1tWDTxfCRFF4iyre8tFCdwlgD2ZAuEk3PBD1FmpQqrKlyzDecP+WP3G6
         vehwS2qfSfh4wRLg8I2aBZlfMOfqIR6maEn1CU3DCPQYwEp3zIFvYz/vXZs1Q1KXlkqU
         uonHa12o6yjqiBpoBbLMvKDyjJFompry7+Zvie6nezVUrOKmabWy+ngi9suYUC1SGRsi
         rjmSgH5FXzYMGlXXFW8EgVC4Rd8UweJe9eeqjPFVDV3oNPh3tgWm2w7xsCy+Y4NM7m8n
         wO+w==
X-Gm-Message-State: ANhLgQ2bIEc9hezSHNSpz8J2VOixA4poGBZhbDjAcTCsSgPAnInjxQW7
        uC/leX13UpXXy0ppsP1O0xw=
X-Google-Smtp-Source: ADFU+vv4EOxlxZA6nMxiSbmoDoebcBF87Zm8UZ5X5KHtpVI9Xq1EYO9Papi6EJJfd7Z5peb034cbfQ==
X-Received: by 2002:a17:902:467:: with SMTP id 94mr5163432ple.302.1583969739717;
        Wed, 11 Mar 2020 16:35:39 -0700 (PDT)
Received: from [10.235.171.60] ([73.93.152.208])
        by smtp.gmail.com with ESMTPSA id my6sm7406942pjb.10.2020.03.11.16.35.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 16:35:39 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200311232550.GM21852@linux.intel.com>
Date:   Wed, 11 Mar 2020 16:35:37 -0700
Cc:     Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E6A6C555-8750-41E4-AD34-68EB0769C4BE@gmail.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
 <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
 <d5f0ba6a-8c7f-60b6-871b-615d11b08a1b@oracle.com>
 <20200311231206.GL21852@linux.intel.com>
 <E0581325-7501-438D-B547-4FEC4F2C2D28@gmail.com>
 <20200311232550.GM21852@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 11, 2020, at 4:25 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Mar 11, 2020 at 04:21:08PM -0700, Nadav Amit wrote:
>>> On Mar 11, 2020, at 4:12 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> On Thu, Mar 12, 2020 at 12:54:05AM +0200, Liran Alon wrote:
>>>> Of course it was best if Intel would have shared their unit-tests =
for CPU
>>>> functionality (Sean? I'm looking at you :P), but I am not aware =
that they
>>>> did.
>>>=20
>>> Only in my dreams :-)  I would love to open source some of Intel's
>>> validation tools so that they could be adapted to hammer KVM, but =
it'll
>>> never happen for a variety of reasons.
>>=20
>> FYI: In 2014 I ran Intel=E2=80=99s fuzzing-tool (Cafe) to test KVM =
and found (and
>> fixed) ~100 bugs. And I did not even test nested virtualization=E2=80=A6=

>=20
> Heh, I worked on Cafe for 6+ years :-)

Well, I was working on its predecessor, Janus, for 5 years=E2=80=A6=20=
