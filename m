Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4602CF2C0
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgLDRJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:09:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731166AbgLDRJp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 12:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607101698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJC4mvE44d2tsq5NOZBG+niQorIGdoMkDibEH0VVAX0=;
        b=hVhbwZW0VyTMwDH69pirJ1+trt/H+ddkCeOGd86wD+lLkBC8zYAknFaqdl/ngnnPzpdR0M
        4nrl8x/BHOpEYB7LktXJqlcp8skTt/HhW3XKTe7fdAZ4CjO8ZO8pEMIhR3dH+xsLCtbkcg
        zLvqzM4fkK+KwT3rYd+BaE8LExfbgEk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-nUYhv7QaO1CRzJ7sCNHxQA-1; Fri, 04 Dec 2020 12:08:17 -0500
X-MC-Unique: nUYhv7QaO1CRzJ7sCNHxQA-1
Received: by mail-ed1-f72.google.com with SMTP id i15so2593042edx.9
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 09:08:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJC4mvE44d2tsq5NOZBG+niQorIGdoMkDibEH0VVAX0=;
        b=khGAv09oYZOxMI245IFPvyifmUL53CNxmii3ZZWvuU5SIB0DFkNFUU4OXuEpWvNytJ
         DskJDSp/A3mmsAog0D83JvqLkC2qYV4bfTosv6o+paH+7POMuEBHuldRZwrzpVazyNoS
         5Zzx7NyuuWjxNgjoJ4M74VxOHN7YjTm9RUjtDEc7CjFa7Hl0S4IeGb5FGuNlRFr2tHAm
         BwaXA08XIvH3e9OhqEqkBL5tGls7B9lHiSAmbWtGnF4AES73Ctt3N0cJ49uEaIx60Eok
         bVncJeV0w+YHp9AL35sdY29NSLRDZCt9tLBggliH6zdraTZ74HVMFtIBUiVRm3LYOiCL
         Wh0A==
X-Gm-Message-State: AOAM532HWhHOkIOoPYKagaQMnFeNAifkKxMk9AW86cd08vHhZjX7trwl
        vMQ63WsI2uhDe1PP9Au8JAe8UEnTtd4pmtM5zRVNFLJYswLzW3DK6g3iFxVqGyYMbE8m6lAiBmx
        db7xt7S/R/Dat
X-Received: by 2002:a50:fc8b:: with SMTP id f11mr8619712edq.11.1607101695794;
        Fri, 04 Dec 2020 09:08:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlThmZUI57vW3KxIu7u8q5x2MUMq+MpfrShE4TQuVtlbHO9ZY1dP69sAeG/4NiTeBY0Zgf4A==
X-Received: by 2002:a50:fc8b:: with SMTP id f11mr8619692edq.11.1607101695613;
        Fri, 04 Dec 2020 09:08:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t8sm3642431eju.69.2020.12.04.09.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 09:08:14 -0800 (PST)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
 <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
 <20201130235959.GS643756@sasha-vm>
 <6c49ded5-bd8f-f219-0c51-3500fd751633@redhat.com>
 <20201204154911.GZ643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <d071d714-3ebd-6929-3f3b-c941cce109f8@redhat.com>
Date:   Fri, 4 Dec 2020 18:08:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204154911.GZ643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/20 16:49, Sasha Levin wrote:
> On Fri, Dec 04, 2020 at 09:27:28AM +0100, Paolo Bonzini wrote:
>> On 01/12/20 00:59, Sasha Levin wrote:
>>>
>>> It's quite easy to NAK a patch too, just reply saying "no" and it'll be
>>> dropped (just like this patch was dropped right after your first reply)
>>> so the burden on maintainers is minimal.
>>
>> The maintainers are _already_ marking patches with "Cc: stable".  That 
> 
> They're not, though. Some forget, some subsystems don't mark anything,
> some don't mark it as it's not stable material when it lands in their
> tree but then it turns out to be one if it sits there for too long.

That means some subsystems will be worse as far as stable release 
support goes.  That's not a problem:

- some subsystems have people paid to do backports to LTS releases when 
patches don't apply; others don't, if the patch doesn't apply the bug is 
simply not fixed in LTS releases

- some subsystems are worse than others even in "normal" releases :)

>> (plus backports) is where the burden on maintainers should start and 
>> end.  I don't see the need to second guess them.
> 
> This is similar to describing our CI infrastructure as "second
> guessing": why are we second guessing authors and maintainers who are
> obviously doing the right thing by testing their patches and reporting
> issues to them?

No, it's not the same.  CI helps finding bugs before you have to waste 
time spending bisecting regressions across thousands of commits.  The 
lack of stable tags _can_ certainly be a problem, but it solves itself 
sooner or later when people upgrade their kernel.

> Are you saying that you have always gotten stable tags right? never
> missed a stable tag where one should go?

Of course I did, just like I have introduced bugs.  But at least I try 
to do my best both at adding stable tags and at not introducing bugs.

Paolo

