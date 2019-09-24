Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2617CBD1A3
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395499AbfIXSOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 14:14:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42235 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730637AbfIXSOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 14:14:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so1826907pff.9
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 11:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=upOXHIee5tHDs4mG76dodwaA0+U6MEpa1E5wfP04+m0=;
        b=Hbjlx305pq786sL4r9SDZGAESG8ly+H4FbeiUVD2HY9+872L9ekzMQnCAj/v98GxID
         59T+q1qSwPdG3JRamNbzEzCO+BjsozhtRoIsNr0SobldMhLxhYEpVXaWEStHf9eOkPIA
         +5OdgerkcSe14Z8Obz4k2vvJsDlvpdOx/PsIXmGzKQdAul232a2JzDsLSExSqZuQrs4S
         pDWtmVnXd1PJUpg5eSM8+GEI9iaGJTZdnh7YZ1OSPGou+AHulGGjIdi6oX17/iVUFq5i
         zHimKLlaUaCQEmqGn5fWA6s3OJuADqCARD8dMZsQ3UzAfwwsNLfJc48J59SkA9jamc81
         W5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=upOXHIee5tHDs4mG76dodwaA0+U6MEpa1E5wfP04+m0=;
        b=NT+hztvsTIHPUcrj4PLFjQ1zmEJrMKwXuKeot9V03e1r8/TCi9BciA/jzzcxE3Pi1s
         ABv0I1qXP8qzXWO2cbXc3V9A/bGUv5DPjXhrITcCjdjgZx5FDa/D0QXg3p4qNyJndysJ
         IdLBImeGwu3E4BchsFn1+/6QUshKOogGz304bv1by+lxfe+WYG4cZ9qEH8p/IJyJdcxM
         kRuyLbQPuPtXpsUwsPiwWrKL+no17brjPOVxObN7ZO8olpIxv3DuV7UEE2CkwJ8btesB
         c8L2Wo8qWp1K3mCsFglaTXhM9t5hp7pRkcFcXKoBAu9/aTrHq9msMwssfSExhEymKCOk
         Y8ug==
X-Gm-Message-State: APjAAAUkJ5JQ1Q/3w7c2AdUDuRiEu2YoFErkrIu98LtKz8SzY5TLslfi
        mW+RErgdm5Z4SYUrMVY9jSc=
X-Google-Smtp-Source: APXvYqzRh/HUELlYpyKfS06NgCWSaznNsAO6E8/QPJlKQNsihCqVhZGfvnvp8qDEYoTfQ0c8iZB7PQ==
X-Received: by 2002:aa7:9f43:: with SMTP id h3mr4904381pfr.215.1569348862106;
        Tue, 24 Sep 2019 11:14:22 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id q204sm5957463pfq.176.2019.09.24.11.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 11:14:21 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTT4mhVtkBCqW_YFDiYSoPCsir6u0j+rqOeoFZui+enzg@mail.gmail.com>
Date:   Tue, 24 Sep 2019 11:14:20 -0700
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7ADCB7CB-605D-411A-A082-98B67B7982BE@gmail.com>
References: <20190919230225.37796-1-jmattson@google.com>
 <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
 <30499036-99CD-4008-A6CA-130DBC273062@gmail.com>
 <CALMp9eTT4mhVtkBCqW_YFDiYSoPCsir6u0j+rqOeoFZui+enzg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 24, 2019, at 11:09 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Tue, Sep 24, 2019 at 10:29 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> On Sep 20, 2019, at 12:44 PM, Jim Mattson <jmattson@google.com> =
wrote:
>>>=20
>>> On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
>>> <krish.sadhukhan@oracle.com> wrote:
>>>> On 9/19/19 4:02 PM, Jim Mattson wrote:
>>>>> Ensure that support for RDPRU is not enumerated in the guest's =
CPUID
>>>>> and that the RDPRU instruction raises #UD.
>>>>=20
>>>>=20
>>>> The AMD spec says,
>>>>=20
>>>>        "When the CPL>0 with CR4.TSD=3D1, the RDPRUinstruction will
>>>> generate a #UD fault."
>>>>=20
>>>> So we don't need to check the CR4.TSD value here ?
>>>=20
>>> KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.
>>>=20
>>> However, I should modify the test so it passes (or skips) on =
hardware. :-)
>>=20
>> Thanks for making this exception. Just wondering: have you or anyone =
else
>> used this functionality - of running tests on bare-metal?
>=20
> I have not. However, if there is a simple way to add this testing to
> our workflow, I would be happy to ask the team to do so before sending
> submissions upstream.

I guess I should build some script that uses idrac to automate this =
process.

