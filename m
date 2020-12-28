Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817A2E3486
	for <lists+kvm@lfdr.de>; Mon, 28 Dec 2020 07:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgL1Gcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Dec 2020 01:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgL1Gck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 01:32:40 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308B0C061794
        for <kvm@vger.kernel.org>; Sun, 27 Dec 2020 22:32:00 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 30so2108803pgr.6
        for <kvm@vger.kernel.org>; Sun, 27 Dec 2020 22:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NQV9G1n3ZRJSWtmvuLfC74SPPVcLgQRYvsA0jba/+L0=;
        b=cgd8huXSuc+8jRPviawDAd5dCe4q8hULZajtBkSVYY+fYwRe7EN54rW8E07YaghOJD
         pIXY/v+3T6yNqnJX/P/a7fxiWrtIa5oFqISj6n9HZMbQaJ4kQzaWutPM8q+LUml/i3hG
         JVlJn1AkOlFKHigk86oEVbGv/7KbyQkqfO2trS7iuzPs2e3et9z8MREkL/7/bRUY5MnO
         5MFkaptLmfho5mwbDvWDOKmHkFxRnm4un4d8wa812cO4qbQ5RyfMXWqMbf5MGbe9Sj1S
         7T8PWbg0hm1tVovDueHbOqR+5L2jXL/0STF4zPqefiKTcFbxKLdJMpItZLdPB22gDjWN
         lwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NQV9G1n3ZRJSWtmvuLfC74SPPVcLgQRYvsA0jba/+L0=;
        b=mwdwhxmh246f70frD2hm37Ivr00VYIbp0Q/Iy0qt+guCZoBterd6o3nKmyz19ny+H4
         DVleBbwFp2qohxvUfP9Muy/s5EPGrwUMtTUpU5PrL7+q1r4LjIBSj4BVYEXerjP2+Qyk
         N1NP4C9l054Vbm+4AkIshc0Pdg85yyvIKT7Dtm0z6cXF2BkaDhchNtR1/eI/shEYp9t2
         12DLqtbhDSME0ShLf1kwXiu/TDuqEXd2W4/zX1FGefCB3FgfyYSQKR4JbCQviaUarU1s
         CIK1L/36D+kqShDhmP02PfWKGtD7dtHkXPoXpwXuAYMVY2dddo+f9NcapKb4XAZ5vbIz
         bKwA==
X-Gm-Message-State: AOAM530EoP4AZIh+Otn50t3EgPnET7KZUrc5i22NnOLw7oLUVz+qHMeM
        jRs2OSA7rS3OJ7k5kfEqAUQ=
X-Google-Smtp-Source: ABdhPJySn/TEPXknqR2iPA5qgRUtH/NRDKAsJFpFGX1XrXIKBixQTxedOVwjok0Su6pE1ZiKqAjSyA==
X-Received: by 2002:a62:ac09:0:b029:1a9:dd65:2f46 with SMTP id v9-20020a62ac090000b02901a9dd652f46mr22439419pfe.15.1609137119535;
        Sun, 27 Dec 2020 22:31:59 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:694a:9377:336e:5ed6? ([2601:647:4700:9b2:694a:9377:336e:5ed6])
        by smtp.gmail.com with ESMTPSA id s10sm37381771pgg.76.2020.12.27.22.31.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Dec 2020 22:31:58 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v1 00/12] Fix and improve the page
 allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201218151937.715bf26f@ibm-vm>
Date:   Sun, 27 Dec 2020 22:31:56 -0800
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C13936BE-B930-4822-AC69-8165B8636896@gmail.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <8A03C81A-BE59-4C1F-8056-94364C79933B@gmail.com>
 <20201218151937.715bf26f@ibm-vm>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 18, 2020, at 6:19 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> On Thu, 17 Dec 2020 11:41:05 -0800
> Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>>> On Dec 16, 2020, at 12:11 PM, Claudio Imbrenda
>>> <imbrenda@linux.ibm.com> wrote:
>>>=20
>>> My previous patchseries was rushed and not polished enough.
>>> Furthermore it introduced some regressions.
>>>=20
>>> This patchseries fixes hopefully all the issues reported, and
>>> introduces some new features.
>>>=20
>>> It also simplifies the code and hopefully makes it more readable.
>>>=20
>>> Fixed:
>>> * allocated memory is now zeroed by default =20
>>=20
>> Thanks for doing that. Before I test it, did you also fix the issue
>> of x86=E2=80=99s setup_vm() [1]?
>>=20
>> [1] https://www.spinics.net/lists/kvm/msg230470.html
>=20
> unfortunately no, because I could not reproduce it.
>=20
> In theory setup_vm should just work, since it is called twice, but on
> different address ranges.
>=20
> The only issue I can think of is if the second call overlaps multiple
> areas.
>=20
> can you send me the memory map of that machine you're running the =
tests
> on? (/proc/iomem)

Sorry for the late response.

I see two calls to _page_alloc_init_area() with AREA_LOW_NUMBER, one =
with
(base_pfn=3D621, top_pfn=3Dbfdd0) and one with (base_pfn=3D100000 =
top_pfn=3D240000).

As for /proc/iomem:

00000000-00000fff : Reserved
00001000-0009e7ff : System RAM
0009e800-0009ffff : Reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c7fff : Video ROM
000ca000-000cafff : Adapter ROM
000cb000-000ccfff : Adapter ROM
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : Reserved
  000f0000-000fffff : System ROM
00100000-bfecffff : System RAM
  01000000-01c031d0 : Kernel code
  01c031d1-0266f3bf : Kernel data
  028ef000-02b97fff : Kernel bss
bfed0000-bfefefff : ACPI Tables
bfeff000-bfefffff : ACPI Non-volatile Storage
bff00000-bfffffff : System RAM
c0000000-febfffff : PCI Bus 0000:00
  c0008000-c000bfff : 0000:00:10.0
  e5b00000-e5bfffff : PCI Bus 0000:22
  e5c00000-e5cfffff : PCI Bus 0000:1a
  e5d00000-e5dfffff : PCI Bus 0000:12
  e5e00000-e5efffff : PCI Bus 0000:0a
  e5f00000-e5ffffff : PCI Bus 0000:21
  e6000000-e60fffff : PCI Bus 0000:19
  e6100000-e61fffff : PCI Bus 0000:11
  e6200000-e62fffff : PCI Bus 0000:09
  e6300000-e63fffff : PCI Bus 0000:20
  e6400000-e64fffff : PCI Bus 0000:18
  e6500000-e65fffff : PCI Bus 0000:10
  e6600000-e66fffff : PCI Bus 0000:08
  e6700000-e67fffff : PCI Bus 0000:1f
  e6800000-e68fffff : PCI Bus 0000:17
  e6900000-e69fffff : PCI Bus 0000:0f
  e6a00000-e6afffff : PCI Bus 0000:07
  e6b00000-e6bfffff : PCI Bus 0000:1e
  e6c00000-e6cfffff : PCI Bus 0000:16
  e6d00000-e6dfffff : PCI Bus 0000:0e
  e6e00000-e6efffff : PCI Bus 0000:06
  e6f00000-e6ffffff : PCI Bus 0000:1d
  e7000000-e70fffff : PCI Bus 0000:15
  e7100000-e71fffff : PCI Bus 0000:0d
  e7200000-e72fffff : PCI Bus 0000:05
  e7300000-e73fffff : PCI Bus 0000:1c
  e7400000-e74fffff : PCI Bus 0000:14
  e7500000-e75fffff : PCI Bus 0000:0c
  e7600000-e76fffff : PCI Bus 0000:04
  e7700000-e77fffff : PCI Bus 0000:1b
  e7800000-e78fffff : PCI Bus 0000:13
  e7900000-e79fffff : PCI Bus 0000:0b
  e7a00000-e7afffff : PCI Bus 0000:03
  e7b00000-e7ffffff : PCI Bus 0000:02
  e8000000-efffffff : 0000:00:0f.0
    e8000000-efffffff : vmwgfx probe
  f0000000-f7ffffff : PCI MMCONFIG 0000 [bus 00-7f]
    f0000000-f7ffffff : Reserved
      f0000000-f7ffffff : pnp 00:08
  fb500000-fb5fffff : PCI Bus 0000:22
  fb600000-fb6fffff : PCI Bus 0000:1a
  fb700000-fb7fffff : PCI Bus 0000:12
  fb800000-fb8fffff : PCI Bus 0000:0a
  fb900000-fb9fffff : PCI Bus 0000:21
  fba00000-fbafffff : PCI Bus 0000:19
  fbb00000-fbbfffff : PCI Bus 0000:11
  fbc00000-fbcfffff : PCI Bus 0000:09
  fbd00000-fbdfffff : PCI Bus 0000:20
  fbe00000-fbefffff : PCI Bus 0000:18
  fbf00000-fbffffff : PCI Bus 0000:10
  fc000000-fc0fffff : PCI Bus 0000:08
  fc100000-fc1fffff : PCI Bus 0000:1f
  fc200000-fc2fffff : PCI Bus 0000:17
  fc300000-fc3fffff : PCI Bus 0000:0f
  fc400000-fc4fffff : PCI Bus 0000:07
  fc500000-fc5fffff : PCI Bus 0000:1e
  fc600000-fc6fffff : PCI Bus 0000:16
  fc700000-fc7fffff : PCI Bus 0000:0e
  fc800000-fc8fffff : PCI Bus 0000:06
  fc900000-fc9fffff : PCI Bus 0000:1d
  fca00000-fcafffff : PCI Bus 0000:15
  fcb00000-fcbfffff : PCI Bus 0000:0d
  fcc00000-fccfffff : PCI Bus 0000:05
  fcd00000-fcdfffff : PCI Bus 0000:1c
  fce00000-fcefffff : PCI Bus 0000:14
  fcf00000-fcffffff : PCI Bus 0000:0c
  fd000000-fd0fffff : PCI Bus 0000:04
  fd100000-fd1fffff : PCI Bus 0000:1b
  fd200000-fd2fffff : PCI Bus 0000:13
  fd300000-fd3fffff : PCI Bus 0000:0b
  fd400000-fd4fffff : PCI Bus 0000:03
  fd500000-fdffffff : PCI Bus 0000:02
    fd500000-fd50ffff : 0000:02:01.0
    fd510000-fd51ffff : 0000:02:05.0
    fd5c0000-fd5dffff : 0000:02:01.0
      fd5c0000-fd5dffff : e1000
    fd5ee000-fd5eefff : 0000:02:05.0
      fd5ee000-fd5eefff : ahci
    fd5ef000-fd5effff : 0000:02:03.0
      fd5ef000-fd5effff : ehci_hcd
    fdff0000-fdffffff : 0000:02:01.0
      fdff0000-fdffffff : e1000
  fe000000-fe7fffff : 0000:00:0f.0
    fe000000-fe7fffff : vmwgfx probe
  fe800000-fe9fffff : pnp 00:08
  feba0000-febbffff : 0000:00:10.0
    feba0000-febbffff : mpt
  febc0000-febdffff : 0000:00:10.0
    febc0000-febdffff : mpt
  febfe000-febfffff : 0000:00:07.7
fec00000-fec0ffff : Reserved
  fec00000-fec003ff : IOAPIC 0
fec10000-fec10fff : dmar0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:04
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : Reserved
fffe0000-ffffffff : Reserved
100000000-23fffffff : System RAM=
