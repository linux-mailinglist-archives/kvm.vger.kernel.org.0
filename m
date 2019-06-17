Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692FD48957
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 18:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFQQx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 12:53:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33211 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQQx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 12:53:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id k187so6152518pga.0;
        Mon, 17 Jun 2019 09:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5GIOr0j5QD0GGMq5iNvz4pmaxjrJeMOWrcA3ngAjb7A=;
        b=WK8FGkjUVKq18qGzWscm8ahQHW1GUCF+ILUXe63ay3w9JUKolPUj+3YphhK0E8VUiO
         D3VHOeRgF69Os5dNYBD+3tBeL+QGWRxe4O1lUNffI+ciOxTZnQUOovBJ8QJgdVFafc4r
         vr9ia4ySytk0IJYT5noK89/yQrr24KTxwjB0P6wOHHrL6IXBMlSQnoyT65V9bcz8SQCW
         DT5wZDEmNGYbA9YuMMPBYvx3OLXoNdO+ZjLbq7Clkt9R8M322Au0gCU1XYbms5dQt9A3
         L+pOus4Fm3NyuNx6wxOGaBpjSeM0X2q/+qEIzrCnDdowFRbhBFU73gJDmUhuaF/pQcMj
         BBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5GIOr0j5QD0GGMq5iNvz4pmaxjrJeMOWrcA3ngAjb7A=;
        b=AflwHAJSDSYflgJBJ4vS5Cd0d1sRbILBAwPvDGCmydEBFMZ5y0HRNN/kIPAB8RVCmj
         6g11e+dGWT5rzxU60MvkmJinj//SfoKa51UosawCm+ecpPvuT/FEuWVd+os5BZPjC0YA
         N+0oi99bw475RlvIZ+9LUuNt7Q2Ac58UC7GMaaYfZ83sHCstvDwD024IjsbxnIrkbYcE
         EHniCzRcGzqfGgYRg6Uojz9d0BGfcd5xdYc3f3Ii6DBxx3VMCBwNjvpx+ZHw7fHEn0ue
         5dXB2W0D2MjOLpiIMMgOEC4QNM0lxxYt3VMS7iugao+HyMGczDQlk/7fwcBBPKXuWcAi
         mWdA==
X-Gm-Message-State: APjAAAW5zfdKFzByziCNbcpQgSIaRxejd3whD+RRmCYUo5TZCX7mqh7h
        wPgTPbn+M75yRDSz7A6mMe/2JioH
X-Google-Smtp-Source: APXvYqxQvlJR/5/Ch56UVr+neR0wtCeYjFoYvDMw4Dtm/ZsiOnsiu5rpaDFdeLO8KgOLgtgCCaiS3A==
X-Received: by 2002:a63:5211:: with SMTP id g17mr46491750pgb.405.1560790437276;
        Mon, 17 Jun 2019 09:53:57 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id t14sm13687953pfl.62.2019.06.17.09.53.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 09:53:56 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
Date:   Mon, 17 Jun 2019 09:53:54 -0700
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Content-Transfer-Encoding: 7bit
Message-Id: <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2019, at 9:14 AM, Andy Lutomirski <luto@kernel.org> wrote:
> 
> On Mon, Jun 17, 2019 at 9:09 AM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 6/17/19 8:54 AM, Andy Lutomirski wrote:
>>>>> Would that mean that with Meltdown affected CPUs we open speculation
>>>>> attacks against the mmlocal memory from KVM user space?
>>>> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
>>>> still have pair of PTI PGDs just like we do know, they'd just be a local
>>>> PGD pair.
>>> Unfortunately, this would mean that we need to sync twice as many
>>> top-level entries when we context switch.
>> 
>> Yeah, PTI sucks. :)
>> 
>> For anyone following along at home, I'm going to go off into crazy
>> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
>> 
>> But, I was thinking we could get away with not doing this on _every_
>> context switch at least.  For instance, couldn't 'struct tlb_context'
>> have PGD pointer (or two with PTI) in addition to the TLB info?  That
>> way we only do the copying when we change the context.  Or does that tie
>> the implementation up too much with PCIDs?
> 
> Hmm, that seems entirely reasonable.  I think the nasty bit would be
> figuring out all the interactions with PV TLB flushing.  PV TLB
> flushes already don't play so well with PCID tracking, and this will
> make it worse.  We probably need to rewrite all that code regardless.

How is PCID (as you implemented) related to TLB flushing of kernel (not
user) PTEs? These kernel PTEs would be global, so they would be invalidated
from all the address-spaces using INVLPG, I presume. No?

Having said that, the fact that every hypervisor implements PV-TLB
completely differently might be unwarranted.
