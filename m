Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EF7BD2AC
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 21:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410142AbfIXTbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 15:31:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40318 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406532AbfIXTbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 15:31:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so1842154pgj.7
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 12:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p2pBnsZXxEg5rYmgidE9LBdx2FaY/2F4BEMdBS7KpeU=;
        b=I9OHVHn7cQ5l+k9iMlxbvpQwISoAvOi6GrQZK4LYfo5IzRUZ08OWDjvmevvV3bvcCu
         MTyS7U1Gartx2+AoQGvAGlOWt8rMeoujoaZbiWRhtv4gXt2MvuC2VJnWLMKY5NPHZ28B
         Q5+feuess4QsFcTMzrQvLxOSQvjqFuiPXDoLHr9JcI//OuxEtU7QdNmtSv5mIxwUJNx2
         vIrlBOWBoh5krnaoQl2u0xaWwiByR8Y8ccU2nEFA1Zvxea+LFphAOlk1/+qgpaUlqizE
         2NRM5koXdudgJAr+JxdbKr9zW5YJ49NaZJk4CqGi+HF9nC4wf71yp0m5osVLJr1abXRS
         M9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p2pBnsZXxEg5rYmgidE9LBdx2FaY/2F4BEMdBS7KpeU=;
        b=NFxN/S969ejI2vnEbvhgAUIHmAU+8C5rkLoCk3WLNrFHHJbtM5n0vFzFMvhXFotIUC
         tO2Dl7r1ueBsR1eoYFBEO2jQOYmKUbZ1+W2EOvRjp8T8xVVFQ+vB+akp64zH3RgPrF8c
         pF0kfTD0HNAg5Z8r3aJU6ae5tBfh6JMIyMkTy/YiFYYziE8BkBKw2he67Br68FvLZhJ2
         L/49e9jShz968S4lVrk1TqB2v6YButrsvT1QQnDfl/rMNOt5wvJbbUkQSk+ByxgUJGU5
         j1d12rbQqpkPGs9K/Wt2Dueq0AA2A0j/LkdH/l6P0lCWR0vFX5H+UVKSzW9FJmSrVCAY
         avzQ==
X-Gm-Message-State: APjAAAXl9iFt6xmaYDfYHR/xgzDtO7JRnhxm6QXy0m8vBXC3dvH+6LZC
        ApLmahTfIiSrIq9TNEMIXf4=
X-Google-Smtp-Source: APXvYqzckcw9tLzTz+AWY+bcfL7Q9LvXS7TCV1FaMwp8vGhztcGqYJrECO6rCISSnkZ1rKmCEELiPA==
X-Received: by 2002:a17:90a:b012:: with SMTP id x18mr1866951pjq.116.1569353467147;
        Tue, 24 Sep 2019 12:31:07 -0700 (PDT)
Received: from [10.33.115.159] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id s14sm2793981pfe.52.2019.09.24.12.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 12:31:05 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTiM4+ZnnnXLP-TNrrjfn3DLAurkcY+2Jom5wWqzFe0Jw@mail.gmail.com>
Date:   Tue, 24 Sep 2019 12:31:04 -0700
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <16025FFA-E83C-4DB9-B552-0480FA38AC77@gmail.com>
References: <20190919230225.37796-1-jmattson@google.com>
 <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
 <30499036-99CD-4008-A6CA-130DBC273062@gmail.com>
 <CALMp9eTT4mhVtkBCqW_YFDiYSoPCsir6u0j+rqOeoFZui+enzg@mail.gmail.com>
 <7ADCB7CB-605D-411A-A082-98B67B7982BE@gmail.com>
 <CALMp9eTiM4+ZnnnXLP-TNrrjfn3DLAurkcY+2Jom5wWqzFe0Jw@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 24, 2019, at 12:29 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Tue, Sep 24, 2019 at 11:14 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> On Sep 24, 2019, at 11:09 AM, Jim Mattson <jmattson@google.com> =
wrote:
>>>=20
>>> On Tue, Sep 24, 2019 at 10:29 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> On Sep 20, 2019, at 12:44 PM, Jim Mattson <jmattson@google.com> =
wrote:
>>>>>=20
>>>>> On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
>>>>> <krish.sadhukhan@oracle.com> wrote:
>>>>>> On 9/19/19 4:02 PM, Jim Mattson wrote:
>>>>>>> Ensure that support for RDPRU is not enumerated in the guest's =
CPUID
>>>>>>> and that the RDPRU instruction raises #UD.
>>>>>>=20
>>>>>>=20
>>>>>> The AMD spec says,
>>>>>>=20
>>>>>>       "When the CPL>0 with CR4.TSD=3D1, the RDPRUinstruction will
>>>>>> generate a #UD fault."
>>>>>>=20
>>>>>> So we don't need to check the CR4.TSD value here ?
>>>>>=20
>>>>> KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.
>>>>>=20
>>>>> However, I should modify the test so it passes (or skips) on =
hardware. :-)
>>>>=20
>>>> Thanks for making this exception. Just wondering: have you or =
anyone else
>>>> used this functionality - of running tests on bare-metal?
>>>=20
>>> I have not. However, if there is a simple way to add this testing to
>>> our workflow, I would be happy to ask the team to do so before =
sending
>>> submissions upstream.
>>=20
>> I guess I should build some script that uses idrac to automate this =
process.
>=20
> I'm not familiar with idrac. What sort of functionality do you need
> from the test infrastructure to automate this process?

Redirecting the serial port to the console and rebooting the machine
remotely.

