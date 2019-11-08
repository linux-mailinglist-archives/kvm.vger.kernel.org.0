Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29133F5BA8
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKHXKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 18:10:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfKHXKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 18:10:07 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1CC686662
        for <kvm@vger.kernel.org>; Fri,  8 Nov 2019 23:10:06 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id l15so2155646wrr.22
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 15:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6K74qceCeqa8g/2rCGVXRQpYc9szmQov/Xnm7zc5Fls=;
        b=SVdEWkFr3BqMd0dxMeACNOpXx9kgHqbbo82j+wezCt1UaD9uxzHKIqaXlssmzvdnSQ
         QvDSx8HLv2XHRjM7AOyCCU4WCsKJfzq653H8M4NNw5g3LeQnq6Bc27KbVxZyFrn+zPqz
         W/W9NJFtV4yoN/STFp62S/8pzNfB8C6HB9NUygqKd/pEbMTpmlspoTMw9xDc9iyHlW9S
         5hLnr/C1JRMQ+0Z2mg/JaIBAwekcDVx7A2Q3F/IJMPoBc8O5pTeSi02BWQbKj5GzaTZH
         e/xsbH+7XUDLikhE49f3lleFU6JtNlVr92SEOinjEegvqg1+E76fsjqj/q5EIhZZudtc
         WnJw==
X-Gm-Message-State: APjAAAXIH8VwK/YEcxkZjBWyuNo4l3vEK6z/WSuCCMWNQTUvRKvAPwyC
        9vTc9DZNjuQMuGHCOah3LKjAKFDQ5iG6NsBcoRUtHF9zL1c/h53fdkWZxl/j0FgW8/J8uN6FeNP
        NslErb5wEoHgb
X-Received: by 2002:a1c:bc56:: with SMTP id m83mr10009258wmf.11.1573254605436;
        Fri, 08 Nov 2019 15:10:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhUONlSbfaDaTUuX7ouAl87Nm5Cp1aD2Xh2cVF/Oo+Vjy7wKQkujU2V8eh4AhaanmckjMYog==
X-Received: by 2002:a1c:bc56:: with SMTP id m83mr10009236wmf.11.1573254605114;
        Fri, 08 Nov 2019 15:10:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5? ([2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5])
        by smtp.gmail.com with ESMTPSA id a15sm6809956wrw.10.2019.11.08.15.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:10:04 -0800 (PST)
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
References: <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
 <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
 <20191108135631.GA22507@linux-8ccs>
 <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
 <20191108200103.GA532@redhat.com>
 <9a3d2936-bd26-430f-a962-9b0f6fe0c2a0@redhat.com>
 <20191108212625.GB532@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <953e95ba-6bb6-25e1-64e8-20e1ea903652@redhat.com>
Date:   Sat, 9 Nov 2019 00:10:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108212625.GB532@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/11/19 22:26, Andrea Arcangeli wrote:
> On Fri, Nov 08, 2019 at 10:02:52PM +0100, Paolo Bonzini wrote:
>> kvm_intel.ko or kvm_amd.ko, I'm not sure why that would be worse for TLB
>> or RAM usage.  The hard part is recording the location of the call sites
> 
> Let's ignore the different code complexity of supporting self
> modifying code: kvm.ko and kvm-*.ko will be located in different
> pages, hence it'll waste 1 iTLB for every vmexit and 2k of RAM in
> average.

This is unlikely to make a difference, since kvm.o and kvm-intel.o are
overall about 700 KiB in size.  You do lose some inlining opportunities
 with LTO, but without LTO the L1 cache benefits are debatable too.  The
real loss is in the complexity, I agree with you about that.

> Now about the code complexity, it is even higher than pvops:
> 
>    KVM				pvops
>    =========                    =============
> 1) Changes daily		Never change
> 
> 2) Patched at runtime		Patched only at boot time early on
>    during module load
>    and multiple times
>    at every load of kvm-*.ko
> 
> 3) The patching points to	All patch destinations are linked into
>    code in kernel modules       the kernel
> 
> Why exactly should we go through such a complication when it runs
> slower in the end and it's much more complex to implement and maintain
> and in fact even more complex than pvops already is?

For completeness, one advantage of patching would be to keep support for
built-in Intel+AMD.  The modpost patch should be pretty small, and since
Jessica seemed quite open to it let's do that.

Thanks,

Paolo

> Furthermore by linking the thing statically we'll also enable LTO and
> other gcc features which would never be possible with those indirect
> calls.
> 
> Thanks,
> Andrea
> 

