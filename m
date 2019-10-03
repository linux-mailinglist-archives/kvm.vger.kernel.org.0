Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE2EC9E2B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 14:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfJCMP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 08:15:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41683 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJCMP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 08:15:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id q9so2656568wrm.8
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 05:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FzacPTlNUKnQ43tm7EzyKmuGlJNT1pooGj2dsuQ39pw=;
        b=oJeYotOZ1UzvleQWhszkAyIkJPhKs5qAMr6JOyrtGbygYrJcdlKsGsyAzt9rJz/FfD
         e7vf50UlsZ6N3ch1fT3EN+Rfsop0TwQO67KwiMMFG8JazsjZbtYs1v5zIQ2Rcs1RL8Ms
         kvEfUQSj5tdD1EcdKK5QJ9qAzT5hJif+Zxt8T+4OgCGVGW2rYfR0XBa7hXF2R0V50LnK
         i2ewCGySu1TDtYCRnAjoa5aNsy4oDAR6/Cs3r+Q6NinbMx/IQUmt6WQkuXiTwKuS73Mu
         mDmKwDYkY99FlX7nNY1ydo/P5N2ldp7DVfeO6Dbh8wiI8V3Dx3rdQ53vD+Kzvp+MlZfJ
         Z2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=FzacPTlNUKnQ43tm7EzyKmuGlJNT1pooGj2dsuQ39pw=;
        b=C9y/ckKsFmNt0oyU1IXMm4yV9Ta2Sy+KNDUWTfZALYaV2FAsw0KrlBjp4l5mzRQS17
         MfxFkhpsPKlB/QMF0W2rFJ8gxMREmjii8dtxAHpmr+hKv+CRdP2j6Em+iPlAEihF7ZHP
         AbNDertQSu3CsBX0FizWahNDexeV2x3bLjO8Bsn29kmYRtVUVaQHAN49Co7Q+5mUSMUB
         Tk6wDTfVvdfd5oM/c8j4aqXI4jAkvaiwS3aemIWqMGoPwFNR/KgOCYonOtgbpxlX6Zu4
         TFKdvaCkdWKIU6FeognNxov88+7cBh3I7v/ja6MWKPYuxQOCldetx3Qm8ao3BxlOg1XF
         HcIw==
X-Gm-Message-State: APjAAAXmi+pP5EPfuD0myA59oeQNy5wy1cM3GQmAu1pyAS2ercFmPJ3m
        mrAGw34nHpr9LKI6cu7RgUzmiA==
X-Google-Smtp-Source: APXvYqz6rb7lG0LDt/54GH/jok0jKcNhwWSfXupI21g4plWQlcz86hc0mG1FRlSJMcAkobpAhb0FMQ==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr6565642wrv.327.1570104952445;
        Thu, 03 Oct 2019 05:15:52 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id h14sm2337574wro.44.2019.10.03.05.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 05:15:51 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 39E881FF87;
        Thu,  3 Oct 2019 13:15:50 +0100 (BST)
References: <20191002102212.6100-1-alex.bennee@linaro.org>
 <05d59eb3-1693-d5f4-0f6d-9642fd46c32a@redhat.com>
 <20191003092213.etjzlwgd7nlnzqay@steredhat>
 <e85b2eaa-1190-c372-5875-6a024ae3a9cd@redhat.com>
User-agent: mu4e 1.3.4; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        "open list\:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH] accel/kvm: ensure ret always set
In-reply-to: <e85b2eaa-1190-c372-5875-6a024ae3a9cd@redhat.com>
Date:   Thu, 03 Oct 2019 13:15:50 +0100
Message-ID: <87sgoaja89.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> On 10/3/19 11:22 AM, Stefano Garzarella wrote:
>> On Wed, Oct 02, 2019 at 01:08:40PM +0200, Paolo Bonzini wrote:
>>> On 02/10/19 12:22, Alex Benn=C3=A9e wrote:
>>>> Some of the cross compilers rightly complain there are cases where ret
>>>> may not be set. 0 seems to be the reasonable default unless particular
>>>> slot explicitly returns -1.
>>>>
>> Even Coverity reported it (CID 1405857).
>
> And GCC ;)

So my normal gcc didn't catch that - which is odd as I didn't expect the
shippable gcc's to be ahead of my local buster install.

>
> /home/phil/source/qemu/accel/kvm/kvm-all.c: In function =E2=80=98kvm_log_=
clear=E2=80=99:
> /home/phil/source/qemu/accel/kvm/kvm-all.c:1121:8: error: =E2=80=98ret=E2=
=80=99 may be
> used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
>      if (r < 0) {
>         ^
> cc1: all warnings being treated as errors
> make[1]: *** [/home/phil/source/qemu/rules.mak:69:
> accel/kvm/kvm-all.o] Error 1
>
> Fixes: 4222147dfb7
>
>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>> ---
>>>>   accel/kvm/kvm-all.c | 6 +++---
>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index aabe097c41..d2d96d73e8 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -712,11 +712,11 @@ static int kvm_physical_log_clear(KVMMemoryListe=
ner *kml,
>>>>       KVMState *s =3D kvm_state;
>>>>       uint64_t start, size, offset, count;
>>>>       KVMSlot *mem;
>>>> -    int ret, i;
>>>> +    int ret =3D 0, i;
>>>>         if (!s->manual_dirty_log_protect) {
>>>>           /* No need to do explicit clear */
>>>> -        return 0;
>>>> +        return ret;
>>>>       }
>>>>         start =3D section->offset_within_address_space;
>>>> @@ -724,7 +724,7 @@ static int kvm_physical_log_clear(KVMMemoryListene=
r *kml,
>>>>         if (!size) {
>>>>           /* Nothing more we can do... */
>>>> -        return 0;
>>>> +        return ret;
>>>>       }
>>>>         kvm_slots_lock(kml);
>>>>
>>>
>>> Queued, thanks.
>>>
>>> Paolo
>>>
>>


--
Alex Benn=C3=A9e
