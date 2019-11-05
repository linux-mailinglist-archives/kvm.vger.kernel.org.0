Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CECF00D8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 16:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389578AbfKEPKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 10:10:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388985AbfKEPKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 10:10:51 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9749E369AC
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 15:10:50 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id 92so12499652wro.14
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 07:10:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVrAMio36Q6kKW94w/mV9hSJkALDbxmAtiCfECylkvk=;
        b=uiIMcppHmpyKf5yDjpKc+Q6Kcp2q6hv8hmp++T5mC4YUGxJ7UFZ6EWmLecm5Rklo6N
         MT47ybrMmE6TKr9FKVId770nmuBMfo2UPgsnM1mTCUt9Bf8ImcWYu4PZVQnhNKDlXOAN
         gKoBjb+OJ3LWFM4HGFj0rlUNfFq9y5tWqJ1C0e9Z2ISm+REbeJx9GsyDI8I8EKtIXz1t
         7Y83PipCZrlL8rvRKgRYPFELghcotBE90QbqXNa4cdpPKIHNwyTh7plQqUWQ5XXKWJze
         6Ub/gIe98Kz4zubNEFVPTtgU3MJ/hjIYE3l+Bd/Hpu6rBlZMyyxxo2MPTXZcmPEyTMh+
         2IPQ==
X-Gm-Message-State: APjAAAXWv6vw1zDSlQdZEv2exX6y6/flDDKwep6ZFXZCQ6/d+PY1GRdU
        s52HeJdspEnXoc9qey+ro64mysaymHxYz4uom0spTREs4oJ8/g61ZB8E4n1gwsusaUAb+GsmgwV
        lMIxji+2Y6lnH
X-Received: by 2002:a1c:67d7:: with SMTP id b206mr4554596wmc.68.1572966649245;
        Tue, 05 Nov 2019 07:10:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4i4e/q0Sa4nnexI0PLDlDkB5K02RJOOefw63TuKDz9JzNgSQf8/7dd6FWjGMKPDiJFaP+8Q==
X-Received: by 2002:a1c:67d7:: with SMTP id b206mr4554564wmc.68.1572966648914;
        Tue, 05 Nov 2019 07:10:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id s21sm1905806wmh.28.2019.11.05.07.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 07:10:48 -0800 (PST)
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jessica Yu <jeyu@kernel.org>,
        Matthias Maennich <maennich@google.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
Date:   Tue, 5 Nov 2019 16:10:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105145651.GD30717@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 15:56, Andrea Arcangeli wrote:
>>> I think we should:
>>>
>>> 1) whitelist to shut off the warnings on demand
>>
>> Do you mean adding a whitelist to modpost?  That would work, though I am
>> not sure if the module maintainer (Jessica Yu) would accept that.
> 
> Yes that's exactly what I meant.

Ok, thanks.  Jessica, the issue here is that we have two (mutually
exclusive) modules providing the same interface to a third module.

Andrea will check that, when the same symbol is exported by two modules,
the second-loaded module correctly fails insmod.  If that is okay, we
will also need modpost not to warn for these symbols in sym_add_exported.

>> The answer is maintainability.  My suggestion is that we start looking
>> into removing all assignments and tests of kvm_x86_ops, one step at a
>> time.  Until this is done, unfortunately we won't be able to reap the
>> performance benefit.  But the advantage is that this can be done in many
> 
> There's not much performance benefit left from the removal
> kvm_x86_ops.

Indeed; what I mean is that until then we will have to keep the
retpolines.  Not removing kvm_x86_ops leaves an unsustainable mess in
terms of maintainability, therefore we will need to first refactor the
code.  Once the refactoring is over, kvm_x86_ops can be dropped easily,
just like kvm_pmu_ops in this version of the series.

The good thing is that the modpost discussion can proceed in parallel.

> The removal of kvm_x86_ops is just a badly needed code cleanup and of
> course I agree it must happen sooner than later. I'm just trying to
> avoid running into rejects on those further commit cleanups too.

>> That is good enough to prove the feasibility of the idea, so I agree
>> that was a good plan.
> 
> All right, so I'm not exactly sure what's the plan and if it's ok to
> do it over time or if I should go ahead doing all logic changes while
> the big patch remains out of tree.

Yes, the changes to remove tests and assignments to kvm_x86_ops must
happen first.  I understand that the big patch is a conflict magnet, but
once all the refactoring is done it will be very easy to review and it
will get in quickly.

Paolo
