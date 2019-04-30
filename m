Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F231005E
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 21:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfD3Tea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 15:34:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41799 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfD3Tea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 15:34:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id 188so7555707pfd.8
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 12:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QiXn4xRoEve5QTiQnhqL5X9oVseDAypikFFfuPJXnU4=;
        b=eSml1lzrdipd8s5iVFyZ3YLOlnYQcuiN0zAhILrrzeed4uqzIYjWJ4IRLWrqozTukn
         mTJH/YXja7kZhwu26iw0DE7H/IeGgv1lZa90eEMhk1GfBAqYPW7q3PAnovhM2wl6wPhG
         U8HjOTlXS4KP2KidR7W6Ro11+SotfD0Lmv5djNhQNaSBiS2hDBs3ZTvQmndVdPvXChvl
         JI7K5tllOkPFKpg1YinCzUnDZhtgo2jEcnq2svfQvX5+ywKnSIW4KWgvTzt3dmn8JxWV
         e4RpdpOSGsEf8frfjHerY1OoCdxFTeYDPvFr9OzgdBDDBTP4+cQMERxK24ud6w3BBMud
         hGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QiXn4xRoEve5QTiQnhqL5X9oVseDAypikFFfuPJXnU4=;
        b=aA4WZut4GVu+Kz3nsog55B1OwjxUBc76Jm1tTaV4DxlfiA1KqKPx9JUoEUlP1MTbqP
         bBQTCabeXXLMw0e1w4DClSC8UMN/3yE1l9jN6chItHvBTj7f1A0EoZ7qqA0nzfveWD+v
         ZZidyzclmnsO/Ng/cExPVurGI51MWuchcYwcZMjDS3fmQBRkNkid2yXGyBdD7FYtphsU
         QTAF/giBaKcNZrXFz2sfxAAcO+HpBnVNpP3ZMpL5JEQRRsmqLpCNLmpXEa/B7/LMqsM7
         T4Ku5KkOslEK7pJIG7n7fcKHJm7abP7L7Vx7D2M4C7CU9PQ6O1Re148QNk+ZTlWKmRdw
         Adaw==
X-Gm-Message-State: APjAAAVT8c/RO3z6Y2jDcHDcFsjHkOuFmaCSQI33OXIZp8ZZw64/Bb02
        Hq5EF4VrNzrbw2ANxUy/fQE=
X-Google-Smtp-Source: APXvYqw+/RaK3R2evvL8GAop7vFUXvl5uezXMnOEyRAXhGCN1Uau4kPU7QsCQeiRsbKQjjypZfJhNQ==
X-Received: by 2002:a63:2c06:: with SMTP id s6mr69049562pgs.245.1556652868915;
        Tue, 30 Apr 2019 12:34:28 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id p66sm73433884pfb.4.2019.04.30.12.34.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 12:34:27 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: Allow xapic ID writes to silently
 fail
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ce8e71f8-bbec-9324-39cd-ec0f0ad72297@redhat.com>
Date:   Tue, 30 Apr 2019 12:34:26 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FA7E59EA-64FA-430F-99EF-8FD45D1A63A7@gmail.com>
References: <20190424212218.15230-1-nadav.amit@gmail.com>
 <ce8e71f8-bbec-9324-39cd-ec0f0ad72297@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 30, 2019, at 12:13 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 24/04/19 23:22, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> According to Intel SDM: "Some processors permit software to modify =
the
>> APIC ID.  However, the ability of software to modify the APIC ID is
>> processor model specific."
>>=20
>> Allow this behavior not to cause failures.
>>=20
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> x86/apic.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/x86/apic.c b/x86/apic.c
>> index d1ed5ea..6772f3f 100644
>> --- a/x86/apic.c
>> +++ b/x86/apic.c
>> @@ -210,7 +210,7 @@ static void __test_apic_id(void * unused)
>>     newid =3D (id + 1) << 24;
>>     report("writeable xapic id",
>>             !test_for_exception(GP_VECTOR, do_write_apic_id, &newid) =
&&
>> -            id + 1 =3D=3D apic_id());
>> +	    (id =3D=3D apic_id() || id + 1 =3D=3D apic_id()));
>>=20
>>     if (!enable_x2apic())
>>         goto out;
>=20
> Queued, thanks.

Thanks. Silly question - when you say =E2=80=9Cqueued=E2=80=9D, what do =
you mean exactly?

In other words, when will it be reflected on the kvm-unit-tests =
repository?
I want to send a few more fixes, but I lost track which ones I sent, so =
I
want to rebase first.

