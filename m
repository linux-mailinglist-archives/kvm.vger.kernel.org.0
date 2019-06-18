Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00B74A717
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfFRQgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:36:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40594 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbfFRQgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:36:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so7966858pfp.7
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 09:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IL1nW/+YbqMLhSW1samVerTY8Tv4aXFIAsLDfQFzMZQ=;
        b=u2mLIPKkGGTJlfOT8DyPvMbOrxkjRX35AmG/PHGn9N+8BTe14RT9Ij8iitPKyQLmFR
         wZSmx3Q4Z9agCYgcsZyxUI0L5UKzlAYSUUPFQBAyKt/WmYKvh2YXGAq6+/D85SQ39+d+
         b/vhEUVskV/SrzyR9tNTIBItPUHr4JjZT6lXrKC21zp8O1TD4sSwYFBlPVp1egY2xfk0
         5plXjFKxbsPmkNVUWhPTRXmWfqoQ8amD1yrULENsg1t2ngtBwwQjLekR8neR1u4UDu/L
         KWv71tTl1AC0zcA7z5Ig7Z5zxzE1/SP5ItTSUZ7V2PiHekbW+drpfBPQblCLwn+tIAjn
         ENZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IL1nW/+YbqMLhSW1samVerTY8Tv4aXFIAsLDfQFzMZQ=;
        b=r4n0yytSjKI+TkvqYUq75lCsmeXyYKfJql643Iej6h+mHUYITyBnnzQPrqmIsgh28s
         lL9K8YWWfYBH8N3VZuwhcvAcE0x8PjS67hUPTdx65adZ7kOMdAbSNFgd/O9aJaWbsKDr
         e3qVLZxyS55jfLerDCrCmwbEnpf1M4WnZ33ctuw9zk3BYSmw3YhN/DktYardggFbuvwX
         4dbLoM1FRS4CjCqiKVhpf2bMfYTwpgPYkIIvKOV5FR/KHWGJbu+DSoPvJpg++tb5aEd3
         J2dVlAi9V2gOwiCqhHcmb6MkQwateruzvS+syy6mlT7fwz+wfyWPcIlmwnWDGwi/WNlT
         fRLQ==
X-Gm-Message-State: APjAAAU1SYLZoqziudtyh3z4xsN4kxBJ48WsuWLe9k6oXcDGgoqFomUa
        JtzzqSatc3h1PTYxPsmxlYi+pA==
X-Google-Smtp-Source: APXvYqyQvU/+csIGlmtLO32PzNEQX2l+DPt+z+FAIRO0RdFTy04j53jWOmgqHKj+t/TS9lbmsrDlTA==
X-Received: by 2002:a63:e652:: with SMTP id p18mr3451756pgj.188.1560875800003;
        Tue, 18 Jun 2019 09:36:40 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:14b5:e5b0:c670:df13? ([2601:646:c200:1ef2:14b5:e5b0:c670:df13])
        by smtp.gmail.com with ESMTPSA id k4sm6458646pfk.42.2019.06.18.09.36.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:36:39 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <f701f859-0990-9f02-baa2-451dd6c8b3c4@intel.com>
Date:   Tue, 18 Jun 2019 09:36:38 -0700
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8FDB1E33-21BC-400D-9051-7BE61400ACD2@amacapital.net>
References: <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com> <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com> <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com> <1560816342.5187.63.camel@linux.intel.com> <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com> <1560821746.5187.82.camel@linux.intel.com> <CALCETrUrFTFGhRMuNLxD9G9=GsR6U-THWn4AtminR_HU-nBj+Q@mail.gmail.com> <1560824611.5187.100.camel@linux.intel.com> <20190618091246.GM3436@hirez.programming.kicks-ass.net> <2ec26c05-7c57-d0e0-a628-94d581b96b63@intel.com> <20190618161502.jiuqhvs3wvnac5ow@box.shutemov.name> <f701f859-0990-9f02-baa2-451dd6c8b3c4@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 18, 2019, at 9:22 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 6/18/19 9:15 AM, Kirill A. Shutemov wrote:
>>> We'd need two rules:
>>> 1. A page must not be faulted into a VMA if the page's page_keyid()
>>>   is not consistent with the VMA's
>>> 2. Upon changing the VMA's KeyID, all underlying PTEs must either be
>>>   checked or zapped.
>>>=20
>>> If the rules are broken, we SIGBUS.  Andy's suggestion has the same
>>> basic requirements.  But, with his scheme, the error can be to the
>>> ioctl() instead of in the form of a SIGBUS.  I guess that makes the
>>> fuzzers' lives a bit easier.
>> I see a problem with the scheme: if we don't have a way to decide if the
>> key is right for the file, user without access to the right key is able t=
o
>> prevent legitimate user from accessing the file. Attacker just need read
>> access to the encrypted file to prevent any legitimate use to access it.
>=20
> I think you're bringing up a separate issue.
>=20
> We were talking about how you resolve a conflict when someone attempts
> to use two *different* keyids to decrypt the data in the API and what
> the resulting API interaction looks like.
>=20
> You're describing the situation where one of those is the wrong *key*
> (not keyid).  That's a subtly different scenario and requires different
> handling (or no handling IMNHO).

I think we=E2=80=99re quibbling over details before we look at the big quest=
ions:

Should MKTME+DAX encrypt the entire volume or should it encrypt individual f=
iles?  Or both?

If it encrypts individual files, should the fs be involved at all?  Should t=
here be metadata that can check whether a given key is the correct key?

If it encrypts individual files, is it even conceptually possible to avoid c=
orruption if the fs is not involved?  After all, many filesystems think that=
 they can move data blocks, compute checksums, journal data, etc.

I think Dave is right that there should at least be a somewhat credible prop=
osal for how this could fit together.

