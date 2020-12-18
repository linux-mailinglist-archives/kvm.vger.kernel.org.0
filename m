Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B42DE31C
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 14:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgLRNJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 08:09:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbgLRNJb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 08:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608296885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MskcXaVRg2L1i5qBmFnapiyeVlhmZhu0sI/jlzmviKY=;
        b=Bx8cnKPN7WyD7B96NASbtECtV1hTwMmQRaCpvoVOkWUUVtAmIz8ufdKTkDEgCHuqQknItm
        NtIqq8C0avH/dmiTZpfBUDoAWbhu7b599f24ES9b1WxjOnHE+aRj2FB2y8x2tlV1GboChy
        x5rwdg29BxxGlTBzhQf/xO1vuOWO3dc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-oo4wqSyTMXqKAfJz-glOSg-1; Fri, 18 Dec 2020 08:08:03 -0500
X-MC-Unique: oo4wqSyTMXqKAfJz-glOSg-1
Received: by mail-ed1-f70.google.com with SMTP id dc6so1043568edb.14
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 05:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MskcXaVRg2L1i5qBmFnapiyeVlhmZhu0sI/jlzmviKY=;
        b=pBuYEYEhW9WMCHVTLKtriqVo9xpnbpmUQOPPxqQdO4gQmIYqgmrwlaNTdNEd/5nXUK
         ci+E8bIbZpBPw/WiwatqcXYdojzkPMU8L5mVHxc7pA9Dxqu7oWPwzPc4UCYSfUaD6vFP
         fJdldycaQpZmbWIhNXI45MzP785KvyWEkBjRVegD5MMo/DBaCUxwQJ1lkvGc0UAwdFAv
         FCHnUo+aUJEV11Sl5GLa22ddwZTmrHlFuUXUvEocTJTb0XOoCA8WSmAmxjz2ce2Pr0Ji
         NfWKLOubnzprkL+gqLxT5lYB7FEvYYf5vLLzbMuEAYnchsUqZW1kGqusURD5yodOo+Dt
         Oy/A==
X-Gm-Message-State: AOAM532c/Nq2a8I45KBCg3oIvMh/31BLhWFp2BYVdsLH0P1yJS2+kKcI
        gqcIcKkK60Wibof59DKW1d7Zfx3pYcnW9tfgPrSQ6jgwERoDatzMBhwN5hREBdiY650zABpj5It
        xNkLja8l5ZGNn
X-Received: by 2002:a17:906:cc84:: with SMTP id oq4mr3933433ejb.513.1608296882183;
        Fri, 18 Dec 2020 05:08:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjbahq4jAtY2Lr3x6O/3x5Mhh+L8zMK95paHl/BNc0CS8OL6UHRNQIE8AqpaD15BWeJJmSmw==
X-Received: by 2002:a17:906:cc84:: with SMTP id oq4mr3933401ejb.513.1608296881945;
        Fri, 18 Dec 2020 05:08:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d6sm5382673ejy.114.2020.12.18.05.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 05:08:00 -0800 (PST)
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
 <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
 <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
 <72e73cdc-dcbd-871d-13fb-57ee3a65d407@redhat.com>
 <20201218111313.d6n6t4mrsgpvwxwu@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c029c321-4ab7-bf61-a34a-65c410b5368a@redhat.com>
Date:   Fri, 18 Dec 2020 14:08:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218111313.d6n6t4mrsgpvwxwu@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/20 12:13, Andrew Jones wrote:
> On Fri, Dec 18, 2020 at 11:32:02AM +0100, Paolo Bonzini wrote:
>> On 16/12/20 13:46, Andrew Jones wrote:
>>> On Fri, Nov 20, 2020 at 09:48:26AM +0100, Paolo Bonzini wrote:
>>>> On 20/11/20 09:05, Andrew Jones wrote:
>>>>> So I finally looked closely enough at the dirty-ring stuff to see that
>>>>> patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
>>>>> that says "Switch to dirty ring mode after VM creation but before any of
>>>>> the vcpu creation". I'd argue that that comment would be better served at
>>>>> the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
>>>>> here. Maybe someday we can add a patch that adds that comment and also
>>>>> tries to use common code for the number of pages calculation for the VM,
>>>>> but not today.
>>>>>
>>>>> Regarding this series, if the other three patches look good, then we
>>>>> can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.
>>>>
>>>> Yes, the rest is good.
>>>>
>>>
>>> Ping?
>>
>> Sorry, I was waiting for a resend.
>>
> 
> Oops, I understood that we'd just drop 2/4 while applying. Should I resend
> now?

Yes, please.  Maybe there were conflicts, I don't remember why I dropped 
the whole series on the floor.

Paolo

