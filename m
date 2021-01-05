Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75EE2EA5F3
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 08:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbhAEH2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 02:28:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbhAEH2p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 02:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609831638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLi+sRfWovFP4SWZkCDhE0WXKSyNbBNcSRSqglRIET0=;
        b=CMvb3195xdMlswDBqqAbA6aZR60exgikCFeEW3ILf5+EqScpp48WMsNVE/JUOU9xsofWOn
        Kot2LBt7juqbTKpcQJ+++bL+2gMB2iQCvREPtCCnFn9ezkQhldHe45pZ5ysRzaKDhYfpE4
        JUBp7Z+oMWRjNboj3bsjZjnW3f4J0PU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-gzwbhRciO-2wZo9a7TmgYg-1; Tue, 05 Jan 2021 02:27:16 -0500
X-MC-Unique: gzwbhRciO-2wZo9a7TmgYg-1
Received: by mail-wm1-f70.google.com with SMTP id w204so886429wmb.1
        for <kvm@vger.kernel.org>; Mon, 04 Jan 2021 23:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yLi+sRfWovFP4SWZkCDhE0WXKSyNbBNcSRSqglRIET0=;
        b=HK6ajQiu2HwU7HThALgfrC6ESSU9QizfekiMk+IJfBe7s8AnAD+T/1Gv45GVU9UeiD
         TkSI+j7zYNth7Jb2pEdmInLUCEP1ZMFgjHKNTIuSmDoc3E3NGp2W6ZGqKxWbpAkMsNac
         Q8KN4iUCtIf7KGz9FoZQtgqAJxpkHvcLR9sSFtsAS37YmU+B01Ci0HroceO2Avh2YwSF
         MzFO7EOdEalmrXvUkpaEjpzKDuEIHwqm9HhAcir5ac2eS+M3KBoxdlp/ijm2n8mMUKqT
         DfuG3VJebnse0eg1X5WZjvOyMLv1jt8rsLSjJymBaVWH8D3sFw7iU+mIDLACD+2QiKaz
         1RVA==
X-Gm-Message-State: AOAM530GmJTdSeSJ5vvaQN/3BMvevJ3qJ62N8jF473gcetfy0oR06F3a
        34ahYS1hGOP6YNSi6S8B58K60SKo6oi1l4OBuDcXvdTMS4p+S12FwClWqJG0Hj4HjuMBy3f++A5
        PbExySXbKhhpd
X-Received: by 2002:a5d:674c:: with SMTP id l12mr82014902wrw.399.1609831635448;
        Mon, 04 Jan 2021 23:27:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXOvkNcqBuyy0EkHXdQlPxr86w8if4j/0XYHqZCidCHd3pSnhLPYbVcoCMZxikKIYvl6WJdw==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr82014894wrw.399.1609831635230;
        Mon, 04 Jan 2021 23:27:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r20sm2685257wmh.15.2021.01.04.23.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 23:27:14 -0800 (PST)
Subject: Re: Possible regression in cpuacct.stats system time
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, alexandre.chartre@oracle.com,
        peterz@infradead.org, w90p710@gmail.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com
References: <12a1b9d4-8534-e23a-6bbd-736474928e6b@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49664b8e-8b14-eb5c-f25c-da604b7c077b@redhat.com>
Date:   Tue, 5 Jan 2021 08:27:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <12a1b9d4-8534-e23a-6bbd-736474928e6b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/21 22:24, Nitesh Narayan Lal wrote:
> Hi,
> 
> Last year I reported an issue of "suspicious RCU usage" [1] with the debug
> kernel which was fixed with the patch:
> 
>      87fa7f3e98 "x86/kvm: Move context tracking where it belongs"
> 
> Recently I have come across a possible regression because of this
> patch in the cpuacct.stats system time.
> 
> With the latest upstream kernel (5.11-rc2) when we set up a VM and start
> observing the system time value from cpuacct.stat then it is significantly
> higher than value reported with the kernel that doesn't have the
> previously mentioned patch.
> 
> FWIU the reason behind this increase is the moving of guest_exit_irqoff()
> to its proper location (near vmexit). This leads to the accounting
> of instructions that were previously accounted into the guest context as a
> part of the system time.
> 
> IMO this should be an expected behavior after the previously mentioned
> change. Is that a right conclusion or I am missing something here?

Yes it's expected and I think it's more precise, since this is host 
overhead rather than guest operation .

> Another question that I have is about the patch
> 
>      d7a08882a0 "KVM: x86: Unconditionally enable irqs in guest context"
> 
> considering we are enabling irqs early now in the code path, do we still
> need this patch?

No, we don't.  Since the code is a bit simpler without it, feel free to 
send a revert.

Thanks,

Paolo

> 
> [1] https://lore.kernel.org/lkml/ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com/
> 
> --
> Thanks
> Nitesh
> 

