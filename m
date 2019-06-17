Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BE748CF2
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 20:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfFQSui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 14:50:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41784 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQSuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 14:50:37 -0400
Received: by mail-pl1-f196.google.com with SMTP id m7so879648pls.8;
        Mon, 17 Jun 2019 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YT9HuF+UAL5f5ci7H4JzJ/S6XavqO8+S9ops45crT04=;
        b=Zfpt3uunBLYcSG089usKV8UfK0qMkW9RgZ/ht+cK7fx45yQdRXzuM4k6DPI6zvCSfi
         0b3jkIINqBOHb/zU/1f0XcGlK9C4FAg1iZvHzrqz40G30DXvdJOSbiC4XdmQGerLkQoR
         aT5EgFrx3EcOeDl7CDlpQ/A7/rYmh9HJ3rnFe7W2D9/WpSraIO3SQSjJc5BPwRcg+dHw
         SPuWuixjDd2kTd8bJJKGjPMpHwnDksjI2b6kT33SjyErxJAJ+adv5BIpRJz1FUgmsg31
         WMNCDArPFaqyMrcsw7wSYB32SF083r7pR7XN3BQJ2niCYfBu5lNlOnPi4o+qmzNvSq00
         xS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YT9HuF+UAL5f5ci7H4JzJ/S6XavqO8+S9ops45crT04=;
        b=UCSgS4deqGLCX+CSokBFkOSjx9KcNevDlb5p2/llRSeV1MpdubiliUxSpp8WMYQDXk
         d8yD7QqsjpZnqEcjXUqWK5c6lvnjNmTf0QYZX4gYzPUivvN/2GAakSWwWSN7blbORHF2
         HZCECwKA1x7G8VizXXXv6mUUQNX1QIvNi5Nitf+cYfDX/ExNnuyelrv3jCbwS1DSGJcE
         DrDE18LDdglKCE0tmD7jmbdl8LtT6O3pWl9Z329QSLK9uuZMbW2hcozVushzcmueLpSi
         1NJeU8ehfLMCFWAalMedjt+AXsfuEPtSnCTXSYC1wGvmDxKsRFuM/GaXaxM0KLCDOoga
         h7XA==
X-Gm-Message-State: APjAAAWQLRTdHCIlPL/rbOPtyzfjQvXKQqUhpDFRgwtlgGgt11IuW/yJ
        71730fD6F54fZNWUDV1olL/+XSqJ
X-Google-Smtp-Source: APXvYqx5UAroLnXpaBq2i2aaY3z6bqvsMT+mzSSAf5PPJfwRApihHPP0h7obDCWJIslPN6lv94WgXg==
X-Received: by 2002:a17:902:2862:: with SMTP id e89mr110159490plb.258.1560797436896;
        Mon, 17 Jun 2019 11:50:36 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x25sm12686727pfm.48.2019.06.17.11.50.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:50:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
Date:   Mon, 17 Jun 2019 11:50:34 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3131CDA2-F6CF-43AC-A9FC-448DC6983596@gmail.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
 <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
 <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2019, at 11:07 AM, Dave Hansen <dave.hansen@intel.com> =
wrote:
>=20
> On 6/17/19 9:53 AM, Nadav Amit wrote:
>>>> For anyone following along at home, I'm going to go off into crazy
>>>> per-cpu-pgds speculation mode now...  Feel free to stop reading =
now. :)
>>>>=20
>>>> But, I was thinking we could get away with not doing this on =
_every_
>>>> context switch at least.  For instance, couldn't 'struct =
tlb_context'
>>>> have PGD pointer (or two with PTI) in addition to the TLB info?  =
That
>>>> way we only do the copying when we change the context.  Or does =
that tie
>>>> the implementation up too much with PCIDs?
>>> Hmm, that seems entirely reasonable.  I think the nasty bit would be
>>> figuring out all the interactions with PV TLB flushing.  PV TLB
>>> flushes already don't play so well with PCID tracking, and this will
>>> make it worse.  We probably need to rewrite all that code =
regardless.
>> How is PCID (as you implemented) related to TLB flushing of kernel =
(not
>> user) PTEs? These kernel PTEs would be global, so they would be =
invalidated
>> from all the address-spaces using INVLPG, I presume. No?
>=20
> The idea is that you have a per-cpu address space.  Certain kernel
> virtual addresses would map to different physical address based on =
where
> you are running.  Each of the physical addresses would be "owned" by a
> single CPU and would, by convention, never use a PGD that mapped an
> address unless that CPU that "owned" it.
>=20
> In that case, you never really invalidate those addresses.

I understand, but as I see it, this is not related directly to PCIDs.

