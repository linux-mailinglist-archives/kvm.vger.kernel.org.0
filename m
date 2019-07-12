Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A3D67388
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfGLQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:45:11 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43344 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfGLQpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:45:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so7748133oif.10
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6LnAzjOasKxUwXGzTNC0/064h+/s+kUgeRd8GGr+dNc=;
        b=y+5JhhgmNMeM1wyuwj/XzOeYCh3l6ziC7Q771WlrgOuxNGzdruLij0Bd0bIoG5jM3d
         Db3yFOQe9oJ72rqInCLv5IT5U/tzZ44PeQK0oBMW4m+IauKOslZy7IC+GgteBJcQrXLS
         w3h9o5dlT/8wb9rL46HzQKkWKfxY+n/JIPNZ9G2FZIINBpDbDTRFNRtcHxKDRJVpwEqH
         nipdZSzIaSUQBX0DYu19v+AM+C3QxQZUmy1qXgyaytK38F3Sv+yUnmfjmLiB7/oZYGXu
         73n0iYnMYyaID7e2Y6q3kyCjzXOYqsuihAlcYX+2cpr0DFcDvSj1C1ys/nJkkUVByenh
         Fn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6LnAzjOasKxUwXGzTNC0/064h+/s+kUgeRd8GGr+dNc=;
        b=fCtybrjFTTjmqYGbuY8ZsbvQV677MZVfM1/EEGgY92wBOgDYZVuifUnBRrgrg6Xnos
         GT5YUey0YLd9juyZLZPjCEaEmoMm3GL65mQkVy8ngO1vOQNS7IhSjxO0ywaXCK/1ixCb
         hcJqZYYAsEj95dvmzALN64XeXbW4EjuKW3HR1iYXGqrLDmR957mdAypyempIveT08Wkm
         1mYVGWig/jrOalRYslxpIVTNCxQFSiamBWx2rwWokhxBxPV+WTYUzkhfqGJWAbOzLcRa
         E2HaFOSBKLwQoWLEmFCasdSVaXPZVVpyNQI4t9G0Ycsm47AHv4QxgEZz+JsI87rVhWth
         c70g==
X-Gm-Message-State: APjAAAXwmmyiZmWKxbDCWJyFAHz+Or/jwRuVz6l9sMxEX2qhbTUM2bp7
        Y/u/mskYfO2SwIt2ShRrgOHinQ==
X-Google-Smtp-Source: APXvYqz43gvQBuChWBqcRDiu2PX0SnPMLctG+UPHeFtjNbnJ7Bi0dOA9Iyg8NVe3bAqg2MsnU8zG+w==
X-Received: by 2002:aca:cfd0:: with SMTP id f199mr6026297oig.50.1562949909275;
        Fri, 12 Jul 2019 09:45:09 -0700 (PDT)
Received: from ?IPv6:2600:100e:b03e:b:3dba:7fb8:8988:ae37? ([2600:100e:b03e:b:3dba:7fb8:8988:ae37])
        by smtp.gmail.com with ESMTPSA id l5sm3141381otf.53.2019.07.12.09.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 09:45:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
Date:   Fri, 12 Jul 2019 10:45:06 -0600
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7FDF08CB-A429-441B-872D-FAE7293858F5@amacapital.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de> <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com> <20190712125059.GP3419@hirez.programming.kicks-ass.net> <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de> <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jul 12, 2019, at 10:37 AM, Alexandre Chartre <alexandre.chartre@oracle.=
com> wrote:
>=20
>=20
>=20
>> On 7/12/19 5:16 PM, Thomas Gleixner wrote:
>>> On Fri, 12 Jul 2019, Peter Zijlstra wrote:
>>>> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
>>>>=20
>>>> I think that's precisely what makes ASI and PTI different and independe=
nt.
>>>> PTI is just about switching between userland and kernel page-tables, wh=
ile
>>>> ASI is about switching page-table inside the kernel. You can have ASI w=
ithout
>>>> having PTI. You can also use ASI for kernel threads so for code that wo=
n't
>>>> be triggered from userland and so which won't involve PTI.
>>>=20
>>> PTI is not mapping         kernel space to avoid             speculation=
 crap (meltdown).
>>> ASI is not mapping part of kernel space to avoid (different) speculation=
 crap (MDS).
>>>=20
>>> See how very similar they are?
>>>=20
>>> Furthermore, to recover SMT for userspace (under MDS) we not only need
>>> core-scheduling but core-scheduling per address space. And ASI was
>>> specifically designed to help mitigate the trainwreck just described.
>>>=20
>>> By explicitly exposing (hopefully harmless) part of the kernel to MDS,
>>> we reduce the part that needs core-scheduling and thus reduce the rate
>>> the SMT siblngs need to sync up/schedule.
>>>=20
>>> But looking at it that way, it makes no sense to retain 3 address
>>> spaces, namely:
>>>=20
>>>   user / kernel exposed / kernel private.
>>>=20
>>> Specifically, it makes no sense to expose part of the kernel through MDS=

>>> but not through Meltdow. Therefore we can merge the user and kernel
>>> exposed address spaces.
>>>=20
>>> And then we've fully replaced PTI.
>>>=20
>>> So no, they're not orthogonal.
>> Right. If we decide to expose more parts of the kernel mappings then that=
's
>> just adding more stuff to the existing user (PTI) map mechanics.
>=20
> If we expose more parts of the kernel mapping by adding them to the existi=
ng
> user (PTI) map, then we only control the mapping of kernel sensitive data b=
ut
> we don't control user mapping (with ASI, we exclude all user mappings).
>=20
> How would you control the mapping of userland sensitive data and exclude t=
hem
> from the user map?

As I see it, if we think part of the kernel is okay to leak to VM guests, th=
en it should think it=E2=80=99s okay to leak to userspace and versa. At the e=
nd of the day, this may just have to come down to an administrator=E2=80=99s=
 choice of how careful the mitigations need to be.

> Would you have the application explicitly identify sensitive
> data (like Andy suggested with a /dev/xpfo device)?

That=E2=80=99s not really the intent of my suggestion. I was suggesting that=
 maybe we don=E2=80=99t need ASI at all if we allow VMs to exclude their mem=
ory from the kernel mapping entirely.  Heck, in a setup like this, we can ma=
ybe even get away with turning PTI off under very, very controlled circumsta=
nces.  I=E2=80=99m not quite sure what to do about the kernel random pools, t=
hough.=
