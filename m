Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C073AE48D
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFUIKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 04:10:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46112 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUIKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 04:10:00 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B441E21966;
        Mon, 21 Jun 2021 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624262865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6rFZ0lwQYZfsvuyDyVPU+tlvewx6b5mmFXLMKuhHrY=;
        b=XnVKLDyxLrsrbooI0OIUtLfV4G+zcMJ8d41UUZLB453X7BlgpYbhepRVSz/bTz/nwFR8Al
        lNfDx1vwlaZ88PdxWTcIcAM0G5uVJabzyuGrLrzEBWfP+dr4rPtgsCmws492NjxgkI0TJR
        AqPFW+fcv7KSDws6Wd0DEopvH+G67qI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624262865;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6rFZ0lwQYZfsvuyDyVPU+tlvewx6b5mmFXLMKuhHrY=;
        b=a91c8/2+fMFLdP2/WzTkRbFgGy4Ve0mcWTDe+FSMqsuw59nhNOOuFapJRetDB1eJWNXteF
        rIj4mJMrCrNglNCg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 3E66E118DD;
        Mon, 21 Jun 2021 08:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624262865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6rFZ0lwQYZfsvuyDyVPU+tlvewx6b5mmFXLMKuhHrY=;
        b=XnVKLDyxLrsrbooI0OIUtLfV4G+zcMJ8d41UUZLB453X7BlgpYbhepRVSz/bTz/nwFR8Al
        lNfDx1vwlaZ88PdxWTcIcAM0G5uVJabzyuGrLrzEBWfP+dr4rPtgsCmws492NjxgkI0TJR
        AqPFW+fcv7KSDws6Wd0DEopvH+G67qI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624262865;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6rFZ0lwQYZfsvuyDyVPU+tlvewx6b5mmFXLMKuhHrY=;
        b=a91c8/2+fMFLdP2/WzTkRbFgGy4Ve0mcWTDe+FSMqsuw59nhNOOuFapJRetDB1eJWNXteF
        rIj4mJMrCrNglNCg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id lVpNDdFI0GBmGwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Mon, 21 Jun 2021 08:07:45 +0000
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Denis Lunev <den@openvz.org>, Eric Blake <eblake@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <87a6no3fzf.fsf@dusky.pond.sub.org>
 <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
 <877dis1sue.fsf@dusky.pond.sub.org>
 <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
 <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
 <20210617165111.eu3x2pvinpoedsqj@habkost.net>
 <87sg1fwwgg.fsf@dusky.pond.sub.org>
 <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <6f644bbb-52ff-4d79-36bb-208c6b6c4eef@suse.de>
Date:   Mon, 21 Jun 2021 10:07:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/21 10:40 PM, Eduardo Habkost wrote:
> On Fri, Jun 18, 2021 at 07:52:47AM +0200, Markus Armbruster wrote:
>> Eduardo Habkost <ehabkost@redhat.com> writes:
>>
>>> On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
>>>> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
>>>>> On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
>>>>>> Claudio Fontana <cfontana@suse.de> writes:
>>>>>>
>>>>>>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
>>
>> [...]
>>
>>>>>>>> If it just isn't implemented for anything but KVM, then putting "kvm"
>>>>>>>> into the command name is a bad idea.  Also, the commit message should
>>>>>>>> briefly note the restriction to KVM.
>>>>>>
>>>>>> Perhaps this one is closer to reality.
>>>>>>
>>>>> I agree.
>>>>> What command name do you suggest?
>>>>
>>>> query-exposed-cpuid?
>>>
>>> Pasting the reply I sent at [1]:
>>>
>>>   I don't really mind how the command is called, but I would prefer
>>>   to add a more complex abstraction only if maintainers of other
>>>   accelerators are interested and volunteer to provide similar
>>>   functionality.  I don't want to introduce complexity for use
>>>   cases that may not even exist.
>>>
>>> I'm expecting this to be just a debugging mechanism, not a stable
>>> API to be maintained and supported for decades.  (Maybe a "x-"
>>> prefix should be added to indicate that?)
>>>
>>> [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net
>>
>> x-query-x86_64-cpuid?
>>
> 
> Unless somebody wants to spend time designing a generic
> abstraction around this (and justify the extra complexity), this
> is a KVM-specific command.  Is there a reason to avoid "kvm" in
> the command name?
> 

If the point of all of this is "please get me the cpuid, as seen by the guest", then I fail to see how this should be kvm-only.
We can still return "not implemented" of some kind for HVF, TCG etc.

But maybe I misread the use case?

Thanks,

C
