Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D9FB333
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfKMPGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:06:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45315 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfKMPGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:06:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id z10so2731622wrs.12
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ma5s1m+zjBkjGGrP/Kt27aEjBmanveR5yh6rwsj31Og=;
        b=HxkvHT9Y6TxlCUwxt8h1uCETkkYtG1Hi2vz5E0sqzAXazUq5jWNMEPk282UNvU9hIO
         Ckf1YN/ZEcweVohBG9N8EvLK2vlJFJEzqVu6ptxyzgUibVX/Gl38NhD4epTESQEvfqKe
         jDCd0BIPe+kG1WAQbIPH3s5k/griiZ4eiQ3aoWP8u36zyFn03Oj0ixHjOpBKs6YbJziK
         rkiiXKwhblB6Y0kVaSNTzM2uwfXAUswXrJvVd8+0fd3QQ5AQty72Lmqe9lvRfFGLCRne
         nTKEUGfAbSGJoiAYYRI3pwj7oAL0OzvUDNCfZ2baLlwrS/oITKzBleP7+/0U4daUaLN3
         tRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=Ma5s1m+zjBkjGGrP/Kt27aEjBmanveR5yh6rwsj31Og=;
        b=d0dIlmnBfRmy2ZfxBisKAUE7JPszZmHkT+30A02In0wDIfQBITau60fEY6eu7u+NBk
         kvIgcpIZzIQ/JmaHsc/2+8B89ni5r4AFo3G6SdwYifuNHtzPiWTYxMXHZCgX16YmBV67
         hhDtfYpv/0WqmKcdtZSq6Tnn03SND5aF0Z/WWDcBycFrQXxyyvcbh5HUyGirXyGyLXtC
         tmCsP6GVAwlwxKxAFAtOTUAU3DEi1kQfRJqrIEGhcC4EGmZyipsx1bNKuUuidF2QVzsM
         5I4IEThKUae+Eak1gu7vPVV6ZpTrbIgDMfNNFLcKRiH68ovGRVJ4Uv6V4tlM9KQA3Gps
         /0Vg==
X-Gm-Message-State: APjAAAUjMbYf2FzGOeHMhzge576X87L+Gd7EVytPiAiLrXExpk1X5ulu
        AWqbEp9dKnEDCtlS0ntKpWwOfA==
X-Google-Smtp-Source: APXvYqxce2CBtihPakdjKEWeAOxp+odUfE46hEQGMlYMOvwm+3S5B1ueO3MN1/mGk5eq+xCt9TXdgw==
X-Received: by 2002:a5d:694d:: with SMTP id r13mr3083435wrw.395.1573657609212;
        Wed, 13 Nov 2019 07:06:49 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a186sm2090035wmc.48.2019.11.13.07.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 07:06:48 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 259491FF87;
        Wed, 13 Nov 2019 15:06:47 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-6-thuth@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 5/5] travis.yml: Expect that at least one
 test succeeds
In-reply-to: <20191113112649.14322-6-thuth@redhat.com>
Date:   Wed, 13 Nov 2019 15:06:47 +0000
Message-ID: <87mucz7r3s.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> While working on the travis.yml file, I've run into cases where
> all tests are reported as "SKIP" by the run_test.sh script (e.g.
> when QEMU could not be started). This should not result in a
> successful test run, so mark it as failed if not at least one
> test passed.

But doesn't this mean you could have everything fail except one pass and
still report success?

>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/.travis.yml b/.travis.yml
> index 9ceb04d..aacf7d2 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -115,3 +115,4 @@ script:
>    - make -j3
>    - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
>    - if grep -q FAIL results.txt ; then exit 1 ; fi
> +  - if ! grep -q PASS results.txt ; then exit 1 ; fi


--
Alex Benn=C3=A9e
