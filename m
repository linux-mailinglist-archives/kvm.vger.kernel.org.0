Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9F61B026
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 08:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfEMGNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 02:13:32 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55078 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfEMGNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 02:13:32 -0400
Received: by mail-it1-f193.google.com with SMTP id a190so18444381ite.4
        for <kvm@vger.kernel.org>; Sun, 12 May 2019 23:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fYlD/4DIIZXXi+61adsuOYQU8CnEJQ3dJpwaeb2i0Vs=;
        b=iYP95yFRcX5vjZrD0kchXNcHAVUNjbCiXCjDGhhPBhT2VvCEUE1TAkdqZ23dUrBkza
         rJltTvR4A7i02EBiDmrXqszR42BlzZp4DdrwQb+G6xDoV+uFJ/G6doPWU48drjWSKeAj
         SK9tlgjLmaKw45RwOdad8RRfi6q0A9BLTycvX3lC59he5UEvkoF8hSiuE1BQyw+nM9qs
         IbxaZGhFBzQ3Rfz7bmC20ttZcYqobouF/VuiYGqsfwPL5a6iZ3WZWfXWCD5h8Vv7hGtg
         0zA5VlGjcsTsQsrh+3uWqecnKf6dZMOu7jpT8rpQFdwdvfantejuuGxqyjT8GzXeaMcP
         92wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fYlD/4DIIZXXi+61adsuOYQU8CnEJQ3dJpwaeb2i0Vs=;
        b=liBH4Gffi21ACdYlq3dNTyVCOrTN2eBBk0FQkXVE5pmU9sUOWxhIolIBpkWE01fGBQ
         +U2g5Wawqx7eiFlPKmqysV7P5jOOTWM3/vG9lMtO5VVyn5a/407zA9y1TOuWZTr7+TY6
         2EWm9K1tZAEu/898tmHVLRSULrgFZ4YhLPfr03bOMoJE6xSOf4Rt+mEGqQg1Gih2oHu4
         06erKzOB+FEkIIOojr3CNKMoKgEihPjCuEOZ1R6i5sZslw+Eo94CGXMeyUHY1cGCEwyM
         awlkPGJKmksE9HY2uJ1xk/ZzXyS60Cf1H1Rt3QTd9IHhrr21bVURhROFHAsr5sYzz9r3
         9R2w==
X-Gm-Message-State: APjAAAXhSAK7rHt7/GH42m8KtsgIRJL/Ln1QVUSUfK9a5vPXmTeIzQiR
        0YSBponwAZDCzSM8iKRjydI=
X-Google-Smtp-Source: APXvYqy/7VHr3bRh0W+DrnZZ1UvmCn0L2b0wgSi39Sww0bEtWseEPGceIJEQFYAyyIfp7XFHStgWbA==
X-Received: by 2002:a24:4f4b:: with SMTP id c72mr18215115itb.55.1557728011482;
        Sun, 12 May 2019 23:13:31 -0700 (PDT)
Received: from [10.20.61.37] (50-204-119-4-static.hfc.comcastbusiness.net. [50.204.119.4])
        by smtp.gmail.com with ESMTPSA id p132sm7315715ita.2.2019.05.12.23.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 23:13:30 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH] x86: Halt on exit
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <493fe8e3-e6d3-72ce-4cbf-b17898f1b0b7@intel.com>
Date:   Sun, 12 May 2019 23:13:28 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <36923465-1343-4D83-92B8-0278B60C5190@gmail.com>
References: <20190509195023.11933-1-nadav.amit@gmail.com>
 <6A5B897E-FF0F-4CD9-85D8-2C071CEF59CC@gmail.com>
 <493fe8e3-e6d3-72ce-4cbf-b17898f1b0b7@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 12, 2019, at 11:05 PM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>=20
> On 5/10/2019 11:34 AM, Nadav Amit wrote:
>> Err=E2=80=A6 kvm-unit-tests patch if there is any doubt.
> you should contain kvm-unit-tests in the subject as
> [kvm-unit-tests PATCH]
>=20
> otherwise, we don't know it's a kvm-unit-tests patch.

Thanks, I know. The =E2=80=9CErr=E2=80=A6=E2=80=9D meant to say =E2=80=9CO=
ops, I forgot the --subject-prefix,
please excuse me."

>=20
>>> On May 9, 2019, at 12:50 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>=20
>>> In some cases, shutdown through the test device and Bochs might =
fail.
>>> Just hang in a loop that executes halt in such cases.
>>>=20
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>> lib/x86/io.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>>=20
>>> diff --git a/lib/x86/io.c b/lib/x86/io.c
>>> index f3e01f7..e6372c6 100644
>>> --- a/lib/x86/io.c
>>> +++ b/lib/x86/io.c
>>> @@ -99,6 +99,10 @@ void exit(int code)
>>> #else
>>>         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
>>> #endif
>>> +	/* Fallback */
>>> +	while (1) {
>>> +		asm volatile ("hlt" ::: "memory");
>>> +	}
>>> 	__builtin_unreachable();
>>> }
>>>=20
>>> --=20
>>> 2.17.1


