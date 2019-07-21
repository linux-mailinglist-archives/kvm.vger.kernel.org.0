Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41DC6F424
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfGUQkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 12:40:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40361 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfGUQkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 12:40:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so16491352pgj.7
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 09:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=X12uJwiXMAYvoLkxHkyXEpVLsPxDMtNRsXA7SQ74XQg=;
        b=L93JBpqY+AWamMq3jOdaDOLAL3wYWH1cdQzf/y1UzF49YdSuigGytEqAq+0ooP1Vsi
         gA4HxxuoZ72l8ECOyisK3DuMMvUHv8crmQJ+5fPNxOUzzzyy03qJ0Xep69g0INkXZILI
         b4JFnsqG10YqtS8jqp3KtBXQoKCzZIyhQzw/TbC8U4EkmtJW26R4UHZbhV6whErmVBy/
         KOYC7NL6u2DKH73/CiRHsY0uhx9quSNNsF8xu2AJ0b7BSi7VuGN7NddcL63nt4GLOv94
         PZZbj42TUYcHrKWOnzLURWuhCs1pg6P2HbzaQl0YZPkyH7RIc8edaKBIVTOf9D8Ar5El
         E4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=X12uJwiXMAYvoLkxHkyXEpVLsPxDMtNRsXA7SQ74XQg=;
        b=TLLe+igXsmglTMTIkvjUfX2tti9EZHxGibpRfgqYwX647N3Yh6UOU5kPZY32LfaTbB
         9nT3IZBqFMUTHIInKDJ8ykfFg1jYBTJnf7oP81elRUkzvlprV72X/fpRHtWapnStuLaZ
         +SZmevOdhJMfz67pY3Py7Qo4mhgQqQu0tbSuWV0k86XmltoM5sMwNLruIU7i7arjaMdP
         WpN6X71rIoDgVwHjAhhDNxpGOyPWrGeREpj16Nqs8ChcDPBaJytJ4kWOKitj4UXw0jAu
         dfNYvV3qBF78CD5Zl1p5h5PzBUzyWq4RoqQBEsPKzCEtzM1TfJZlVLW3iWDarQkUxevh
         g0Cw==
X-Gm-Message-State: APjAAAVQ0KashCJITqCcsUwjqQwdW6MqE3ME+udERpGrrNaVZFsl9KQh
        aYcJi7y7GS//3QcvLDOfDx0=
X-Google-Smtp-Source: APXvYqy3xBK7QpA4pVghp8fOzzX+oiMo8q2ZAU/A0djQZbP5a5s2I1blZbj3KVztmGfxBTcuqQDD3w==
X-Received: by 2002:a17:90a:372a:: with SMTP id u39mr72226010pjb.2.1563727238720;
        Sun, 21 Jul 2019 09:40:38 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id j6sm49101853pjd.19.2019.07.21.09.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 09:40:37 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <91f59a9e-f225-b225-079b-f4ef32724163@redhat.com>
Date:   Sun, 21 Jul 2019 09:40:36 -0700
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <08914961-07E1-4B78-AC80-1755F0B98BCE@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
 <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
 <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
 <9A78B004-E8B8-427A-B522-C0847CBEFDD3@gmail.com>
 <91f59a9e-f225-b225-079b-f4ef32724163@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 15, 2019, at 11:54 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 15/07/19 20:43, Nadav Amit wrote:
>>> On Jul 15, 2019, at 11:26 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>> On 15/07/19 20:08, Nadav Amit wrote:
>>>>> This works because setup_multiboot() looks for an initrd, and =
then,
>>>>> if present, it gets interpreted as a list of environment variables
>>>>> which become the unit tests **envp.
>>>>=20
>>>> Looks like a nice solution, but Paolo preferred to see if this =
information
>>>> can be extracted from e810 and ACPI MADT. Paolo?
>>>=20
>>> It was mostly a matter of requiring adjustments in the tests.  =
Andrew's
>>> solution would be fine!
>>=20
>> Ok, but I must be missing something, because the changes I proposed =
before
>> did not require any changes to the tests either (when they are run on =
top
>> of KVM).
>=20
> You're right, I was confused.  There were changes to a couple tests =
but
> they are not related to fw_cfg.  I only disliked having to repeat the
> same information (as opposed to just the initrd path) in all the
> entries.  Memory map and MADT would be my preferred choice, but as a
> stopgap Andrew's idea is okay.
>=20
> Paolo
>=20
>> Andrew=E2=80=99s solution would just make it easier to set =
=E2=80=9Cfixed=E2=80=9D boot-loader
>> entries, although they would still need a different root and
>> boot-relative-path on different machines.

Paolo, can you please push all (or at my) queued patches?

I prefer to work on the latest code (including my patches that were =
queued),
and anyhow kvm-unit-tests repository is broken right now and does not =
build.

