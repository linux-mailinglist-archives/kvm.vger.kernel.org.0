Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34E1FB493
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfKMQD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:03:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43511 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfKMQD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 11:03:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so2974632wra.10
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 08:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zGLPuyVxtuszQvVr+PvbPMiAYqFWg6vZLJsgh8NrlMc=;
        b=sh4Aok8iZCH/hfgkHGZMqQ8CWXBS3FKV++sdhMTQVn8mHrte/ntk+k8va9X3z5ETn/
         ilYu/rEVtMHZ/a3Czx/SZYpOEp2Pzk9k62D4KWhVSOLcHYkqXqlYO5ogkestt77Ay6uQ
         ySoumQp6tU5n63BV0sWEr71BMwmMYpJWwM7zyUdUW9+Tewl2wg/ywAM0PDXfDIiDTPT8
         oD+NhZsjZvUGdPKcLUQuSAsqtaEpUOCDZEywQPEXj+pUszLzwBPQ5N09WEx9qzoj3SlG
         YjhnW6cY+tgc6bltdXxomVQ1RqvplIM9F/9z9GQhqp+SPIW6HxaVdNQEEW8GY69FGoGB
         wEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=zGLPuyVxtuszQvVr+PvbPMiAYqFWg6vZLJsgh8NrlMc=;
        b=mm0bmCTuKJ9Ri4/itY99cnBV/Polym6iQricHbs5j2dJf5WlXdfeMhgpgbUZRSB+Ep
         Y5aaqbdlv1Gvty+h0MSN/rLYyTGVnI+UaiaAEHiBtd7ReXxmtAjo1fTJPv+NaiQYauZg
         J7IUPGCrn4lzpJpA3UvyBxGimnhBpj26rDxX95BFyy0TqtkQC1or9ESig6PfeN5joboF
         kpwkgHVftCGulzrSkpEqHeAbC5QujJP3xfrwtuC4TIYjXEssXKCgZIN6XA/JjCW8nV7G
         Jy2ooN84Ic1/Q7so80u6zfDOAelfEKSFh41u6oyQiRcsGpBOCqRHzgZ5znRZSvzxJRR7
         DSeA==
X-Gm-Message-State: APjAAAWdxTSo4mOmPbm6JxLaoP290fyjd6jtBtuotVDJ2UNT5C3pE36e
        O79PfQGjMDSSV2/IbeM1eFVU9A==
X-Google-Smtp-Source: APXvYqw+Cb1XYoEPG5GEdRkLzoFtDPZ1vbn1oFcECbI+wRKA52UFEsg1JlNMofDwQUnlapcVQWdzog==
X-Received: by 2002:adf:e881:: with SMTP id d1mr3627902wrm.296.1573661003409;
        Wed, 13 Nov 2019 08:03:23 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id 11sm3048523wmb.34.2019.11.13.08.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 08:03:22 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 29D6A1FF87;
        Wed, 13 Nov 2019 16:03:21 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-6-thuth@redhat.com> <87mucz7r3s.fsf@linaro.org>
 <417bee9b-578b-5b3c-25a6-9998020ba514@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 5/5] travis.yml: Expect that at least one
 test succeeds
In-reply-to: <417bee9b-578b-5b3c-25a6-9998020ba514@redhat.com>
Date:   Wed, 13 Nov 2019 16:03:21 +0000
Message-ID: <87h8377ohi.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> On 13/11/2019 16.06, Alex Benn=C3=A9e wrote:
>>
>> Thomas Huth <thuth@redhat.com> writes:
>>
>>> While working on the travis.yml file, I've run into cases where
>>> all tests are reported as "SKIP" by the run_test.sh script (e.g.
>>> when QEMU could not be started). This should not result in a
>>> successful test run, so mark it as failed if not at least one
>>> test passed.
>>
>> But doesn't this mean you could have everything fail except one pass and
>> still report success?
>
> The FAILs are already handled one line earlier...

Oops I should have noticed that:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

>
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  .travis.yml | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/.travis.yml b/.travis.yml
>>> index 9ceb04d..aacf7d2 100644
>>> --- a/.travis.yml
>>> +++ b/.travis.yml
>>> @@ -115,3 +115,4 @@ script:
>>>    - make -j3
>>>    - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
>>>    - if grep -q FAIL results.txt ; then exit 1 ; fi
>
> ... here -----------^
>
>>> +  - if ! grep -q PASS results.txt ; then exit 1 ; fi
>
> Maybe it would also be nicer to provide proper exit values in the
> run_tests.sh script, but the logic there gives me a bad headache...
> grep'ing for FAIL and PASS in the yml script is way more easy.
>
>  Thomas


--
Alex Benn=C3=A9e
