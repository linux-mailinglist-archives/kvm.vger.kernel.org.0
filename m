Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83506182B9
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 01:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfEHXfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 19:35:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45423 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfEHXfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 19:35:23 -0400
Received: by mail-pg1-f193.google.com with SMTP id i21so157487pgi.12
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 16:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L9RAl7uvR3W5HgPnuNV109FyAix9C3Kt1lwKVF2B1+I=;
        b=cGVvKitS+3q+EK/t/tp402Knk3V8MQK3wFm5TE3j1NLaMKbuaDvShoBnaphDGaZ4ay
         tkAxZ3e5VJ6T12M6L31kwgAFQ7j3X+t4oDoRuZzA8XwBtJGXQnDWIUqH/MGBWVjPw0X7
         pE80ocx1aS9+XGLg8fqUaRURVMuyC7ZSuuKLwUKzu2vcSfTYxTfTY2GCVyGDHedr2PNB
         fUSFjoDm2zeSNCvGYDfnbPY53fzrXzlmsTC6n+elRzFnzmw/yPDWFoOxBeZ5aiYBFbdY
         C4MTvL1N4V1195liShhzMGpWwvb/SKP3TxV7MiWnMTcEw33O+ybvotbzzn7Z46cosq7S
         As8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L9RAl7uvR3W5HgPnuNV109FyAix9C3Kt1lwKVF2B1+I=;
        b=hjc85ORBohZ6AQbOJ5hSwBpKc/PAKSXEV36qnJ13T81Nv/VQPKqYVAyqFs9FMzzE+f
         hC+YpIXBZeKzQM3GVVxOQhtuzCgkMI+T6YxPwlifCiz/2a/7YHGK98EOo1lMz1xH8Tpm
         RdoPs7pYPSfScLpInqeVBQo48iK6GpaoZsxc8VYYIv2NY9o5u4Y7hKzjDGkKGd4BTjHS
         QQnZFYJ8tdxVkO+psc7g2JvMa1KNoIOCbhIYqj9WYNc9ToFlckGj9uBxrhGkZOY+9pLk
         Nnb5dmoMTIj764lKBsyDdYYE79iB0LYRr0YTREkEnrmVMkfZYLl5nhjx0DYE8NVGxegJ
         DMBQ==
X-Gm-Message-State: APjAAAUZgVpVNRjzB2Pf9/0yDjcUD2qSFaCC+KpF8aGq7ItBzy3k6l8+
        HSHWxvydPLQKdNE0DTbscFU=
X-Google-Smtp-Source: APXvYqzR177o6jiYau48TbWXaXfYr851WiLwum3sxnmSYYLJ5eY5NrnqSMGIMTcY2mXChpprDGDxmw==
X-Received: by 2002:a63:d816:: with SMTP id b22mr1129203pgh.16.1557358522963;
        Wed, 08 May 2019 16:35:22 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 129sm400812pff.140.2019.05.08.16.35.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 16:35:22 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr
 tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
Date:   Wed, 8 May 2019 16:35:20 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B8B0BFD-3D85-4062-9F44-7BA8AC7F9DAE@gmail.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-2-namit@vmware.com>
 <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 8, 2019, at 4:11 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> From: Nadav Amit <nadav.amit@gmail.com>
> Date: Wed, May 8, 2019 at 10:47 AM
> To: Paolo Bonzini
> Cc: <kvm@vger.kernel.org>, Nadav Amit, Jim Mattson, Sean =
Christopherson
>=20
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> According to Intel SDM 26.3.1.5 "Checks on Guest Non-Register State", =
if
>> the activity state is HLT, the only events that can be injected are =
NMI,
>> MTF and "Those with interruption type hardware exception and vector 1
>> (debug exception) or vector 18 (machine-check exception)."
>>=20
>> Two tests, verify_nmi_window_exit() and verify_intr_window_exit(), =
try
>> to do something that real hardware disallows (i.e., fail the =
VM-entry)
>> by injecting #UD in HLT-state.  Inject #DB instead as the injection
>> should succeed in these tests.
>>=20
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
>=20
> Thanks for the fix!
>=20
> It has always bothered me that there is no easy way to validate a
> kvm-unit-test on physical hardware. Do you have a mechanism for doing
> so? If so, would you be willing to share?

I call this mechanism =E2=80=9Cgrub=E2=80=9D. ;-)

If you saw my recent kvm-unit-tests patches - they are needed to run
kvm-unit-tests on physical hardware. Once I am done sending the =
remaining
fixes, I=E2=80=99ll send an RFC that enable test execution on physical =
hardware
(e.g., by skipping tests that require test devices).

I just hope that this support would convince you, and others, to prefer
(when possible) kvm-unit-tests over the selftest environment.

> I don't suppose you have a patch for kvm to fail the VM-entry in this =
case?

I am trying to keep my day job.

