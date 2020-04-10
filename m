Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF321A4025
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 05:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgDJDxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 23:53:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35472 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgDJDxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 23:53:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id k5so486088pga.2
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 20:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vSIPEPOc5ZIkDepQBj4MVQxNI/hKIwhnPMzWb3j2cdg=;
        b=mOOFt0UftnQV7EQlLU/Z0Ws7IhdatJylqfsoCmwhaBgUZWrsNA6/RJ0YUzROT0KiVL
         vdG9y4QVZ1Rl8giDRDcZMulEKGaFFQsydDGGKc4ARLVcPxDxStAiHkBvtD2+jeK01+uT
         1GVs7W/T71S8PY9ewZMfiIaI4lFRnegc1qhwagu3hj+uG0QydUzrlPLTmTjCeFwjO9YQ
         KcVlUlV6lbKQXZ0Oz5GU1/tLDDkRhQHClHOTGOJnN8kafIHAfeF1TsUuElWWsKz76dop
         mky8pwdExPPlHT4HvPnKJLaQDljxBlF+uOgxWfUsmpuYyFZ/NXPT6CO9xlbAGRfKCgpS
         b/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vSIPEPOc5ZIkDepQBj4MVQxNI/hKIwhnPMzWb3j2cdg=;
        b=ohOqHRFroaHam7dLdmNn8+8iY3s3OfhbhgMXKaocmsTcOMx5CpWHq1G5B4CFvtRdic
         EfXPtpGvSqZqxYOK+hlUBo+CzLl9/zBFpJioSq1B4oWQDQPqWb0oqMeC6LGhhYGpR80D
         ZOsv0DkBXadx+2WeL3Gsb4EeDlQP27Fdc6njJ0uv18nqpSSvjeG53f1oPC8zAzSMsmyO
         UwihglIHojTmDf54ZsKnoKmFRLQnXT+oto7X2oM8GbaEln4Y9mAFUW3RaPuY4xCPZ88+
         nj9YotJIX4A8K0w5VgybY/9CcEMuy3CwnHwm12u6uolrup43AwOgFbSEpdPOvELtCHkH
         Daiw==
X-Gm-Message-State: AGi0PuZsaxyv+p7dcYi/rWdK+T4F5ULA2qzp3+M5vPBcv2Y1R6cr93oz
        +wMt3c0FcUQ29QIaSZxa52c=
X-Google-Smtp-Source: APiQypJgEoPdhrJZvgMTrP0qIAy3rcKbJUAcjDjl3RwOCMwNaIkRgzs/3XW0Ty2wP8MV6mYBuLqHfw==
X-Received: by 2002:a63:cf50:: with SMTP id b16mr2600005pgj.189.1586490779975;
        Thu, 09 Apr 2020 20:52:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:d8e9:9b3c:bb20:8b56? ([2601:647:4700:9b2:d8e9:9b3c:bb20:8b56])
        by smtp.gmail.com with ESMTPSA id w2sm521868pff.195.2020.04.09.20.52.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 20:52:58 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Contribution to KVM.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
Date:   Thu, 9 Apr 2020 20:52:57 -0700
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Liran Alon <liran.alon@oracle.com>, like.xu@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
To:     Javier Romero <xavinux@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 9, 2020, at 8:34 PM, Xu, Like <like.xu@intel.com> wrote:
>=20
> On 2020/4/10 5:29, Javier Romero wrote:
>> Hello,
>>=20
>>  My name is Javier, live in Argentina and work as a cloud engineer.
>>=20
>> Have been working with Linux servers for the last 10 years in an
>> Internet Service Provider and I'm interested in contributing to KVM
> Welcome, I'm a newbie as well.
>> maybe with testing as a start point.
> You may try the =
http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> and tools/testing/selftests/kvm in the kernel tree.
>> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at =
disposal.
> If you test KVM on Intel platforms, you will definitely get support =
from me :D.

If you are looking for something specific, here are two issues with
relatively limited scope, which AFAIK were not resolved:

1. Shadow VMCS bug, which is also a test bug [1]. You can start by =
fixing
   the test and then fix KVM.

2. Try to run the tests with more than 4GB of memory. The last time I =
tried
   (actually by running the test on bare metal), the INIT test that =
Liran
   wrote failed.

Regards,
Nadav

[1] =
https://lore.kernel.org/kvm/3235DBB0-0DC0-418C-BC45-A4B78612E273@gmail.com=
/T/#u=
