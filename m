Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A63AB7ED
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 17:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhFQPzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 11:55:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50360 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhFQPzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 11:55:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 06BC91FD7D;
        Thu, 17 Jun 2021 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623945192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruX4fi2ifgkWNs4skOvM6TBKlu05fQ6TCdKDNmE57zM=;
        b=YdeJkERcPZiS0AXoBC4HGNusCCR+/gPR1ZVC1/hQNJVUbHjT8HwZy+Ha2lWeigrdqQwmUA
        3oK8O39XHlyE2uzja6Lrj2MUqg8rLiCUywiJ0haczLf7pejU9e/818pS4MIVBz3SgrQ1+K
        4lc5vxfvFhpboO7pOmdQ1DhhG2IR14g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623945192;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruX4fi2ifgkWNs4skOvM6TBKlu05fQ6TCdKDNmE57zM=;
        b=4n6FTMznDCaugWVb6Cn0zF1zjMpqa8aUJdOLPqxNg/8O0VUiPXn3yPt53roHMTWXP6JXGd
        4ab/m0ghDgf2aoAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 87FC6118DD;
        Thu, 17 Jun 2021 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623945191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruX4fi2ifgkWNs4skOvM6TBKlu05fQ6TCdKDNmE57zM=;
        b=Eujx27+Jfn6V1sP/76KzbSbuYbSyqz1Tyvnman4PxCD2wwWfMl9kr+g6L7PmnUxpR3OgMa
        LwxnDJQaPeUf9h6h5Z7CkYe8e5I1K/BdlHO9nFJ8BBCLYjpe+kkk+Vnp/+UjcsAYQYeaKb
        5SuLyZlMd9LqAmY1mGyKKwdJ56Ayrbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623945191;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruX4fi2ifgkWNs4skOvM6TBKlu05fQ6TCdKDNmE57zM=;
        b=s/MzHNF8Vy8W3kM/By4ln4PDTedpss/wFdrQpGQ6mKvxlQzQa8FNvIXJ773YVvetOS0+bi
        iKfxyeah4leZcHDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 53m/Hudvy2ALFQAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 17 Jun 2021 15:53:11 +0000
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Denis Lunev <den@openvz.org>, Eric Blake <eblake@redhat.com>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <87a6no3fzf.fsf@dusky.pond.sub.org>
 <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
 <877dis1sue.fsf@dusky.pond.sub.org>
 <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
Date:   Thu, 17 Jun 2021 17:53:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
> On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
>> Claudio Fontana <cfontana@suse.de> writes:
>>
>>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
>>>> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
>>>>
>>>>> On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
>>>>>> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
>>>>>>
>>>>>>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
>>>>>>
>>>>>> It's actually a QMP command.  There are no "qapi methods".
>>>>>>
>>>>>>> get virtualized cpu model info generated by QEMU during VM initialization in
>>>>>>> the form of cpuid representation.
>>>>>>>
>>>>>>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
>>>>>>
>>>>>> virtual CPU
>>>>>>
>>>>>>> command line option. From there it takes the name of the model as the basis for
>>>>>>> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
>>>>>>> that state if additional cpu features should be present on the virtual cpu or
>>>>>>> excluded from it (tokens '+'/'-' or '=on'/'=off').
>>>>>>> After that QEMU checks if the host's cpu can actually support the derived
>>>>>>> feature set and applies host limitations to it.
>>>>>>> After this initialization procedure, virtual cpu has it's model and
>>>>>>> vendor names, and a working feature set and is ready for identification
>>>>>>> instructions such as CPUID.
>>>>>>>
>>>>>>> Currently full output for this method is only supported for x86 cpus.
>>>>>>
>>>>>> Not sure about "currently": the interface looks quite x86-specific to me.
>>>>>>
>>>>> Yes, at some point I was thinking this interface could become generic,
>>>>> but does not seem possible, so I'll remove this note.
>>>>>
>>>>>> The commit message doesn't mention KVM except in the command name.  The
>>>>>> schema provides the command only if defined(CONFIG_KVM).
>>>>>>
>>>>>> Can you explain why you need the restriction to CONFIG_KVM?
>>>>>>
>>>>> This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
>>>>> flag is set. I was choosing between this and writing empty implementation into
>>>>> kvm-stub.c
>>>>
>>>> If the command only makes sense for KVM, then it's named correctly, but
>>>> the commit message lacks a (brief!) explanation why it only makes for
>>>> KVM.
>>>
>>>
>>> Is it meaningful for HVF?
>>
>> I can't see why it couldn't be.
> Should I also make some note about that in the commit message?
>>
>> Different tack: if KVM is compiled out entirely, the command isn't
>> there, and trying to use it fails like
>>
>>     {"error": {"class": "CommandNotFound", "desc": "The command query-kvm-cpuid has not been found"}}
>>
>> If KVM is compiled in, but disabled, e.g. with -machine accel=tcg, then
>> the command fails like
>>
>>     {"error": {"class": "GenericError", "desc": "VCPU was not initialized yet"}}
>>
>> This is misleading.  The VCPU is actually running, it's just the wrong
>> kind of VCPU.
>>
>>>> If it just isn't implemented for anything but KVM, then putting "kvm"
>>>> into the command name is a bad idea.  Also, the commit message should
>>>> briefly note the restriction to KVM.
>>
>> Perhaps this one is closer to reality.
>>
> I agree.
> What command name do you suggest?

query-exposed-cpuid?


>>>> Pick one :)
>>>>
>>>> [...]
>>

