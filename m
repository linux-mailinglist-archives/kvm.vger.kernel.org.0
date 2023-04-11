Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855C56DD572
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 10:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjDKI3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 04:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjDKI2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 04:28:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479823C23
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 01:28:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e2so6602110wrc.10
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 01:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681201697; x=1683793697;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQ0drIWzBl8+TPE9EFtuKvjJ26MgcK8N50RWv3O5VHo=;
        b=ldfLULADu6snRA2bB6QD6/b5ZvdowkwKJ9mCRSCCor0CJsRGit0mkSUUgRNbHxI+zW
         S8oBv3MHt8hnRiHrJ99DyAaUKGIX7y3LM9tGoNu6/LbGOZ6/B5F/IVxaZzN4ZwA0VdlD
         NhVYVo0cdvq6D4nwF1coVzR5MDIyDeDV1cRwSohYBOpPeQr/OsukVL6jHy2rN8FSKk6U
         /EQOt7CJYz+bPZXdpu20FGaVVDt8k/ccDfrSS4zcupundRRjGiEfRuSJUTuhC/caH8Fm
         QCmEMARYZSiUeHq1Y5bbztc9Z4xNxOkk96v5v1+Hrt8EpArblKBOFERxzbQt78pohk0x
         eTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681201697; x=1683793697;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MQ0drIWzBl8+TPE9EFtuKvjJ26MgcK8N50RWv3O5VHo=;
        b=b5V1xk4UnrolBjD3JTojG/jxr/EYO/UtW+DEkv7cKEa7Jb2OlZenovLiD37UUNkoBz
         t9Bq0gT+OLlrZo4YXqGUvorcPla/kQve640A6d9CRaWSzZBpN4Bszd9vZee21m6vteRF
         UNY3qowRpH76yuEY2RbdyD6eVUYjTlcAzrPBQh1+UQMGDd/bFcTnq3YQpKLb5A4+QCFI
         ATHVBU/Xr1ejemXHHJ9cJ+N7P8hI69hBFmkqI90Ur0pAhsT/k76tUcDtPR+lzCWGDocC
         NB7lX5qRCvhVRZAfCttGRKtxTbQK2OqS02UsHRA8hOcEavVSxd/VDCL31jv2qIxaWBre
         Ru9w==
X-Gm-Message-State: AAQBX9dnnNZh9LMvCbtJ0Ql9sBb8QAW2kaMjXooALyIQSGJPiDKNNAXO
        vQRObq+rHXGebtdpgqLTu/MvIA==
X-Google-Smtp-Source: AKy350ZqH49K+BAAmm735ZwwqN+arqWQEaqXtjDVehw3IW1uBc6FBRptmMKZQ89c1AY3FMzFcvegGw==
X-Received: by 2002:a5d:4204:0:b0:2cf:f04b:fb23 with SMTP id n4-20020a5d4204000000b002cff04bfb23mr9173789wrq.59.1681201695275;
        Tue, 11 Apr 2023 01:28:15 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id m13-20020a5d4a0d000000b002efebaf3571sm7327060wrq.64.2023.04.11.01.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 01:28:14 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 732391FFB7;
        Tue, 11 Apr 2023 09:28:14 +0100 (BST)
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-5-alex.bennee@linaro.org>
 <20230321150220.mfrvgxg3ebju5e6k@orel>
User-agent: mu4e 1.10.0; emacs 29.0.90
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush
 during code execution
Date:   Tue, 11 Apr 2023 09:26:56 +0100
In-reply-to: <20230321150220.mfrvgxg3ebju5e6k@orel>
Message-ID: <87ile2rffl.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <andrew.jones@linux.dev> writes:

> On Tue, Mar 07, 2023 at 11:28:42AM +0000, Alex Benn=C3=A9e wrote:
>> This adds a fairly brain dead torture test for TLB flushes intended
>> for stressing the MTTCG QEMU build. It takes the usual -smp option for
>> multiple CPUs.
>>=20
<snip>
>
> BTW, have you tried running these tests as standalone? Since they're
> 'nodefault' it'd be good if they work that way.

It works but I couldn't get it to skip pass the nodefault check
automaticaly:

  env run_all_tests=3D1 QEMU=3D$HOME/lsrc/qemu.git/builds/arm.all/qemu-syst=
em-aarch64 ./tests/tcg.computed=20
  BUILD_HEAD=3Dc9cf6e90
  Test marked not to be run by default, are you sure (y/N)?

>
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::page_other]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'page'
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::all_self]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'self'
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::page_self]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'page self'
>> +groups =3D nodefault mttcg
>> +
>> --=20
>> 2.39.2
>>
>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
