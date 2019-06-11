Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307D13D31A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 18:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405553AbfFKQ5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 12:57:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33819 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404099AbfFKQ5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 12:57:41 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so5374925plt.1;
        Tue, 11 Jun 2019 09:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LRf7jr0/HLf72a+GCXiXIigk1cbBqM+c/XCEYVEbVfg=;
        b=eRXbtH0f1kXlU/cWfbn2hNQ0rQG8fc8+TxdPwtiZfqj/7Okr/zjWiIo1pjc5NtrpGS
         qroG2rFEMyH02ZhC+Mllt9e351NOylIugvL3xEybuCPelPlWQ+IagF9emLex4b2Tj+Zp
         9NOFE66x219JcSYURURWOPD3Ec5nwdvLh3U5u3HxiSsXKd0KbP0ELQuu6Lf9r9Bc2VHe
         UGqoZQm5kDnvTjiqglU8e3f/XlZ6Sz82MA14d6HIZgnTFZFXDwy2Pi+323YkZW3RBY4X
         toZRcrKRW1evx4JP7mAuiZyiYsuo/erougOEJoxqfv1HYkEMMnqRIjl/goKTkIT8p5B6
         sRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LRf7jr0/HLf72a+GCXiXIigk1cbBqM+c/XCEYVEbVfg=;
        b=H9GXAObt9aUT/9hKsleHNKiA2uxh0zpM0h6t06uwo46sZiwdQG5H/qdH90qzvrnBe2
         cKFSzV9RFD4aKpF+VcQ2fTJOVkXje1tC93AsrguFiI3S4NclCU0gRxu1rQhDZoS6pWxZ
         ySPKDA0qlQ4Jsoy1Gv2sA2KK7RR+av7TLebBjGyBrZ5JpHl1iQ32+VpwRSOXeIBkEvYZ
         3BS1kJQYGAdNu+EI4obJc7FL8WB+SDIAZl88sw1DIuXGKhAyw4DwSUcPExWyARuE33nb
         33hz0rV2iS/0/reZBPBfVGw9nBZJOfBVHHnaNYyAF2FLTRBMryDUEUTtoHuyZMVRQ3Nr
         htNg==
X-Gm-Message-State: APjAAAWI4tE2jorl+ioUyd9USDozHDbGzJs2s86zEfoLabXLeO+9ZwaN
        WcS/ase+hJyiG1RKasxqmJQ=
X-Google-Smtp-Source: APXvYqzWMsD88MKj9it03NOFc2BtSLO1KcHll6YadGFk1Xj33L6yRvIe8cG87oclg6m35xQDh+5Dag==
X-Received: by 2002:a17:902:8d92:: with SMTP id v18mr53873863plo.211.1560272260451;
        Tue, 11 Jun 2019 09:57:40 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id c11sm5644951pgg.2.2019.06.11.09.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 09:57:39 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
Date:   Tue, 11 Jun 2019 09:57:36 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
 <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com>
 <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 11, 2019, at 3:02 AM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> wrote:
>>> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>>>=20
>>> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99=
 wrote:
>>>>> 2019-05-30 09:05+0800, Wanpeng Li:
>>>>>> The idea is from Xen, when sending a call-function IPI-many to =
vCPUs,
>>>>>> yield if any of the IPI target vCPUs was preempted. 17% =
performance
>>>>>> increasement of ebizzy benchmark can be observed in an =
over-subscribe
>>>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush =
call-function
>>>>>> IPI-many since call-function is not easy to be trigged by =
userspace
>>>>>> workload).
>>>>>=20
>>>>> Have you checked if we could gain performance by having the yield =
as an
>>>>> extension to our PV IPI call?
>>>>>=20
>>>>> It would allow us to skip the VM entry/exit overhead on the =
caller.
>>>>> (The benefit of that might be negligible and it also poses a
>>>>> complication when splitting the target mask into several PV IPI
>>>>> hypercalls.)
>>>>=20
>>>> Tangetially related to splitting PV IPI hypercalls, are there any =
major
>>>> hurdles to supporting shorthand?  Not having to generate the mask =
for
>>>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to =
way
>>>> shave cycles for affected flows.
>>>=20
>>> Not sure why shorthand is not used for native x2apic mode.
>>=20
>> Why do you say so? native_send_call_func_ipi() checks if allbutself
>> shorthand should be used and does so (even though the check can be =
more
>> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)
>=20
> Please continue to follow the apic/x2apic driver. Just apic_flat set
> APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.

Indeed - I was sure by the name that it does it correctly. That=E2=80=99s =
stupid.

I=E2=80=99ll add it to the patch-set I am working on (TLB shootdown =
improvements),
if you don=E2=80=99t mind.

