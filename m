Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE56423DAB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392645AbfETQjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 12:39:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34747 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392641AbfETQjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 12:39:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id w7so6983153plz.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=h4TXKwltQVSNZVkvop7ugxrHRWNwUjSnY0rEJSTNaIo=;
        b=gBhzfp2ZOcBGedRZRdpx1Q+CB8FTBWGvHZFSWCuMKKm3pTomh3e/4jekZNp+f6/umX
         brZsCH+0QgbwlY7ZTa5H9ZzJHvzN8/dGa40O7uQmRVet6qokrWY8GNeiHm9OOl+tiyej
         DsBaTWZmbQ2anjYN6UBIsEUKl3IihkCVaaER7CP/jy++yuZGnicq43US7ZD0h+mDjO9Y
         Rw6Zxc85rkT4aD1gaHZxg3reD7ZVGfAXOtotnityU0ZPTXtZXr2sF2oz4xua9I7pX/lq
         Ilb2NSQSNbpwaj2X1EcrizO+PCzLsynsJKZWiw5uywGFXfEYgcLVLyM+psa9SFoknrXE
         bsWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=h4TXKwltQVSNZVkvop7ugxrHRWNwUjSnY0rEJSTNaIo=;
        b=HXEydTrxBI/BfBJQzC9EYulba/8D3b7iK3o41Bo+F9M/vDu0yfQMp5ILdlm/pa/dW5
         nJH2KIQu1E3C7GobMG337VKFpdhUGUwPXJNNlOJdSMyguWrrAn2hRaTTASfzrkoG/gY7
         fVGvBGyQDRXDr2uLM0TyIgKhi6ZyDoDNqlgVqmXkZ/RnVqrbSVWUPPCnWJTw55hczqzI
         Y4PIA7yg+6HV394Fgwyo3gDu/5fWbH93FTO+Dq+Lcypsl6lUYC1ieSKGKDQmm/hUwFb1
         jr/BvB5xkATH+QRshqWmFlsg11/AEDxbyWDEewMBuPT+mk66b1USw2zQPWT5DNnJDwUg
         M5Hg==
X-Gm-Message-State: APjAAAUV4VtAGaGgRKahUcIMI59erUlrhcFKtDvfI8PqWHVyeDvzSmBo
        mzsScD12Ze2zb+ZLtU0f6p4=
X-Google-Smtp-Source: APXvYqxL3/eonAOmGOc9XCfQz2HdrX3TaXOAcpp9CyKjWmvwt94sEoKaCOMrHp+AOMTT3F9GpeFEnA==
X-Received: by 2002:a17:902:9007:: with SMTP id a7mr75807249plp.221.1558370362220;
        Mon, 20 May 2019 09:39:22 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 14sm21479506pfx.13.2019.05.20.09.39.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 09:39:21 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr
 tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <76ffb0ca-c007-05c4-7bef-5f72f03a7a4e@redhat.com>
Date:   Mon, 20 May 2019 09:39:20 -0700
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FAC1484C-8157-45F4-BF1A-514DDF4E0ABC@gmail.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-2-namit@vmware.com>
 <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
 <7B8B0BFD-3D85-4062-9F44-7BA8AC7F9DAE@gmail.com>
 <76ffb0ca-c007-05c4-7bef-5f72f03a7a4e@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 20, 2019, at 8:52 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 09/05/19 01:35, Nadav Amit wrote:
>> I just hope that this support would convince you, and others, to =
prefer
>> (when possible) kvm-unit-tests over the selftest environment.
>=20
> kvm-unit-tests are not superseded by selftests; selftests are mostly
> meant to test the KVM API.  While they are more easily debuggable than
> kvm-unit-tests, the benefit is not big enough to justify the effort of
> rewriting everything.
>=20
> Furthermore, being able to run kvm-unit-tests on bare metal is useful,
> even if it's not something that people commonly do, and consistent =
with
> KVM's design of not departing radically for what bare metal does.

I understand.

And just to clarify - my corporate overload deserves the credit for this
work. I just prefer not to shout it too loudly.

I=E2=80=99m sorry for not collecting the patches into a set, but I know =
that it
would just cause me to resend all of them for individual patch issue.

I still have some more pending patches that I will send after rebasing =
and
cleanup.

