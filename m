Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF14313C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 22:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390678AbfFLU4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 16:56:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34073 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388338AbfFLU4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 16:56:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id c85so10386608pfc.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 13:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TZPBYSKEoaIkhIv00E3WuJ5aJFmWavGoQVJ9IN5iIvo=;
        b=YKatqYp5ZMD0rZsPMDq0to0PJDreG1XUyrx5SqWGPFgdgJtrZRf5AOIxLF1RFphdWH
         R8Uycb+uWLqjH30x5HeS9diZaO6zEKBi4ehrFWwTQQhEoyWIgNqsqXzSVDTswGRL/9KD
         uhKfahNauFol7O1XFQvxQp5RulEWOEW7iex6oysSu++JNYIgkrqn3WOcSrgDk5zaBXNp
         8B+4btiQ/WZSa7P4mcOyuxUL08dr8X75WN0f9Llk7Bg6kYQ1G/dW5uqsTcyfJCabZyCo
         CSzxOII00f5vEnofzolLz3aqRMf0Y2IeopHbP2PjiAMHgx7OfqBg8uf57PLTsF74jSYO
         KVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TZPBYSKEoaIkhIv00E3WuJ5aJFmWavGoQVJ9IN5iIvo=;
        b=lsKtkVLePNq5awvqoI3AviukxHua9PoZ+1UO0GMpzpDVDvh+9+0fXculY4ayCJUfOT
         cORQYxf92BuZrrONUqFqHcMsPcMdtC6ak9V95Q6mDS3shJfuTpDU6jvf/NSe/loZQD3b
         dqEIvL1YVvXSRxLHaC7L6Y4wUlemLjZdjxSHbwMK0wi3r9BK7nFO/puw5t5YdPTT7pAb
         qGRh33rBVbMQFrmw3DKLgqdJaRFCF/tEpcDU3Qe3E+6O82nY63fo+r4+laTuVkI9G+oc
         eCTnw1TkyVHt6F5uOCVW4bZVAM8QScIaDz3ncWO8GO/KD8ZqySEr6aSqCo6CMq9jSGs7
         lCEQ==
X-Gm-Message-State: APjAAAUifvBNqTWlYfzLUe+uTl1nY+7EFYSg8JVKMvad2FKvh75KO2ns
        BIaOjb0PNZNgioJYLlqEg1KxHg==
X-Google-Smtp-Source: APXvYqxo/ItMtB3OUs84fhqaf0UCPf/u6DxMcudVwkkrFpAqbneRAxpY8FuZIOMzxuIx2mCUlvJvAg==
X-Received: by 2002:aa7:90ce:: with SMTP id k14mr89000454pfk.239.1560372995458;
        Wed, 12 Jun 2019 13:56:35 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:e92e:2d95:2c68:42e6? ([2601:646:c200:1ef2:e92e:2d95:2c68:42e6])
        by smtp.gmail.com with ESMTPSA id v18sm455164pfg.182.2019.06.12.13.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 13:56:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <3cd533c1-3f18-a84f-fbb2-264751ed3eeb@intel.com>
Date:   Wed, 12 Jun 2019 13:56:31 -0700
Cc:     Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD3482AC-3FB0-41DE-9347-5BD7C3DE8B11@amacapital.net>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com> <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <3cd533c1-3f18-a84f-fbb2-264751ed3eeb@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 12, 2019, at 1:41 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 6/12/19 1:27 PM, Andy Lutomirski wrote:
>>> We've discussed having per-cpu page tables where a given PGD is
>>> only in use from one CPU at a time.  I *think* this scheme still
>>> works in such a case, it just adds one more PGD entry that would
>>> have to context-switched.
>> Fair warning: Linus is on record as absolutely hating this idea. He
>> might change his mind, but it=E2=80=99s an uphill battle.
>=20
> Just to be clear, are you referring to the per-cpu PGDs, or to this
> patch set with a per-mm kernel area?

per-CPU PGDs=
