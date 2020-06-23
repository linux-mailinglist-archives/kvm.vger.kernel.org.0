Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AD204D93
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbgFWJL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbgFWJL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:11:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCE7C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:11:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l17so18096559qki.9
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cT+RuU2w9BqW778lKEk77wEdrGHjk4v0vMUGFYhdTBs=;
        b=WIOoDy9i08kcRYyRir2FFk15voyhsCBKRpQvYjPS7pfTScb9IMv6rH50BUt0hzt0Mi
         g5S2/YZfs9Pb9lPFWK+KUctMEQot/JFXeeg8dZdAlgXylOyg8kPA+lRWXmhzEUw3kUGF
         kaQnW3bE5kIZ7pZRg7Mbdc88ffCYS5CIW66b3Vm11beirZFDjbHlzsrHN6MfEkCyIbzp
         9lkaH1VxW8cPJS7oWzmmXAKxlhPFFz6t2D4LsTG3E3CYiJDjkwEJ0dlMP7UPDzouYv4/
         cz/kr9TaUnJhz+QXP/OcoKwlu07dWQ4e7IWmqROu2ZJ3IQ9uIosc9wj9Q3k0969ZisLm
         zvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cT+RuU2w9BqW778lKEk77wEdrGHjk4v0vMUGFYhdTBs=;
        b=AyV3p5/xCM9AFbVPaBgGuRfloVpNbncxPnxKuLRc4xynSPc0CXoHPuwhss7xSinu8B
         50/IojM9KL3Rodh8nS/O4mKV3KmpIUgIiEfA8WshSYoaTeNRl3hwr9u+4MvLrbpmA7r2
         Cb/OBXAU0xHcYSOIJ/qtpDzWDnEpZ4ADc5g2rGt7iBppktwrKlF/MPNkTtPanVDDqkBy
         0XyQagspO7kY4bDEa0iG782nulKp8jyVm5bQPNifKAiZ4BKGyKjuO2llifwZjwyAItlI
         CAi3xMDV9CNK+5+ALrxaNqgVvwvNUxUDRriZvtP4/aZG/YgSzBWiaxbYooZi+21ITTJO
         T6qQ==
X-Gm-Message-State: AOAM531EKRbYn/Ice9jmqMwP+pxiUrPF7GU71XN37bt1zl0ibnPPKgBg
        vMwcgGTbL3vb0fkW3yV2ZWQ=
X-Google-Smtp-Source: ABdhPJwdIHPQDaxVOLBYejxlQSIIu1uPAiS/oRg4pZqtjLSBQjbesBDsYO/5m6aMVk7C7ENwxtiwvw==
X-Received: by 2002:a37:a950:: with SMTP id s77mr19208929qke.171.1592903484812;
        Tue, 23 Jun 2020 02:11:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:55dc:2130:bbc8:d35e? ([2601:647:4700:9b2:55dc:2130:bbc8:d35e])
        by smtp.gmail.com with ESMTPSA id m13sm20390qta.90.2020.06.23.02.11.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:11:24 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] x86: always set up SMP
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <af2c5e61-3448-0869-22a2-7be5f11e72eb@redhat.com>
Date:   Tue, 23 Jun 2020 02:11:22 -0700
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        cavery@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <C6C2F636-A610-4880-A7E9-409EE260DDC3@gmail.com>
References: <20200608160033.392059-1-pbonzini@redhat.com>
 <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
 <af2c5e61-3448-0869-22a2-7be5f11e72eb@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 16, 2020, at 7:02 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 16/06/20 15:02, Thomas Huth wrote:
>> On 08/06/2020 18.00, Paolo Bonzini wrote:
>>> Currently setup_vm cannot assume that it can invoke IPIs, and therefore
>>> only initializes CR0/CR3/CR4 on the CPU it runs on.  In order to keep the
>>> initialization code clean, let's just call smp_init (and therefore
>>> setup_idt) unconditionally.
>>> 
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>> x86/access.c              | 2 --
>>> x86/apic.c                | 1 -
>>> x86/asyncpf.c             | 1 -
>>> x86/cmpxchg8b.c           | 1 -
>>> x86/cstart.S              | 6 +++---
>>> x86/cstart64.S            | 6 +++---
>>> x86/debug.c               | 1 -
>>> x86/emulator.c            | 1 -
>>> x86/eventinj.c            | 1 -
>> 
>> Hi Paolo,
>> 
>> this patch broke the eventinj test on i386 on gitlab:
>> 
>> https://gitlab.com/huth/kvm-unit-tests/-/jobs/597447047#L1933
>> 
>> if I revert the patch, the test works again:
>> 
>> https://gitlab.com/huth/kvm-unit-tests/-/jobs/597455720#L1934
>> 
>> Any ideas how to fix that?
> 
> I'm not sure why it starts failing now, the bug is unrelated and I see
> the same compiler output even before.

I encountered the same problem on my (weird) setup, and made some initial
triage. Apparently, it is only the #DE that causes the mess. As the #DE uses
vector number 0, and the IDT base is 0, it hints that the data in address 0
is corrupted.

I presume there is somewhere a rogue store into a NULL pointer during the
32-bit setup. But I do not know where.


