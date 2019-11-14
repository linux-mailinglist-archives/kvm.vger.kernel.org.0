Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F589FBD61
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 02:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfKNBRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 20:17:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40234 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKNBRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 20:17:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so2544544pgt.7;
        Wed, 13 Nov 2019 17:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fb25qvfujdxdo8Wp/TscIQafoa8vDn3JImH8zHJDGRo=;
        b=nWV069wdhWxufFLnTHg3xON/3b5ffmh1PzljI1qq9uQLEAIr3HPqWqdVmw6UwXBHWO
         cGTO4X4U4WCdk+jv/FM5DCkOD9KrXg/sKdjxK/NPqgjtLBgaywdZxiiHWikk3LZAz/K9
         y9LLc4/WW4kCt6JTFA8hVFk5Z4L1auQeyRY7N3HguCCbzTvvHVj3vnVFilJMbjVdepU7
         5eQ5ghDuSTfpgnigRe4W1UvLWb4bvvXkV4co8raQ4rCp67/Zdo+c0ZQw3rECjA27rNV5
         suiDuIOpz1xHfEZ9bQf83vSmKanWqbJaIbLO/XwcuiDV1cVi0LlzvB2eP+WQ+HkfDI3q
         Q1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fb25qvfujdxdo8Wp/TscIQafoa8vDn3JImH8zHJDGRo=;
        b=ikQ+k9b9tAt7d2d0ZXnMhAibbu/tncIdVkbHDybRL5NJEJW6OKi9Pd7rSTTX7ILS7M
         a3k6MmwcuRZ3ct/UQSpoazwKaSnPU+RM52WoqYTT0exGNMvrI2zcifPiVseuTL6llWgq
         miTVCS3vo7odJHTPYAMxtYag7nuSI5QXGVQnFGkXjXC6bNn9O0HsY3lke8JcBHQL4Zds
         c0AEA09cLv0HF8IxFsyxeO11p0QmTGOAiTeswUrmlyKniYRcpVmlhQ2HrGEaaM608dqG
         Ak3hfD/IopPJiHi7SRyB3olGrnLcRfJrndRq5mlTBOosrhMUHIj4OccDQKfCPDCyXaB2
         lU0g==
X-Gm-Message-State: APjAAAXtfQ907QUQxwyjDVE6hf8zOGB8npXZlMNrjD/Ixa8mWPoT2W4f
        L/FcvJPpkjPOBzfY7GJJ0yY=
X-Google-Smtp-Source: APXvYqyNCU20bt7U3yfySKv/YDCTQxJTKeiN+9Gr/ZHrtF2mI7StEy6d7I7UEyl3FnUxVkVproXyUg==
X-Received: by 2002:a17:90a:fa96:: with SMTP id cu22mr8849597pjb.121.1573694262672;
        Wed, 13 Nov 2019 17:17:42 -0800 (PST)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id l18sm855825pff.79.2019.11.13.17.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 17:17:41 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
Date:   Wed, 13 Nov 2019 17:17:39 -0800
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C0513A5-6C73-4F17-B73B-6F19E7D9EAF0@gmail.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Nov 13, 2019, at 1:24 PM, Dave Hansen <dave.hansen@intel.com> =
wrote:
>=20
> On 11/13/19 12:23 AM, Paolo Bonzini wrote:
>> On 13/11/19 07:38, Jan Kiszka wrote:
>>> When reading MCE, error code 0150h, ie. SRAR, I was wondering if =
that
>>> couldn't simply be handled by the host. But I suppose the symptom of
>>> that erratum is not "just" regular recoverable MCE, rather
>>> sometimes/always an unrecoverable CPU state, despite the error code, =
right?
>> The erratum documentation talks explicitly about hanging the system, =
but
>> it's not clear if it's just a result of the OS mishandling the MCE, =
or
>> something worse.  So I don't know. :(  Pawan, do you?
>=20
> It's "something worse".
>=20
> I built a kernel module reproducer for this a long time ago.  The
> symptom I observed was the whole system hanging hard, requiring me to =
go
> hit the power button.  The MCE software machinery was not involved at
> all from what I could tell.
>=20
> About creating a unit test, I'd be personally happy to share my
> reproducer, but I built it before this issue was root-caused.  There =
are
> actually quite a few underlying variants and a good unit test would =
make
> sure to exercise all of them.  My reproducer probably only exercised a
> single case.

So please correct me if I am wrong. My understanding is that the reason =
that
only KVM needs to be fixed is that there is a strong assumption that the
kernel does not hold both 4k and 2M mappings at the same time. There is =
indeed
documentation that this is the intention in __split_huge_pmd_locked(), =
for
instance, due to other AMD issues with such setup.

But is it always the case? Looking at __split_large_page(), it seems =
that the
TLB invalidation is only done after the PMD is changed. Can't this leave =
a
small time window in which a malicious actor triggers a machine-check on=20=

another core than the one that runs __split_large_page()?

