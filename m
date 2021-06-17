Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6B23AB31F
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhFQMAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 08:00:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55478 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhFQMAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 08:00:18 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 502F121AA9;
        Thu, 17 Jun 2021 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623931090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HQzr/oBQrFVndjXMoJnRWNt/IYubj/nwj8QqaGhIaQ=;
        b=MjDBQgAZYCsi948sSCtkSBixD6GOtSdJH6Brk6uY5coR7n6avh/h69+5yS1X4DZu2rBBcO
        eMI5VQSEXzuMytoR5+APq6vlyYJA+uan08CjpRsRvmj9trCwV05rlBdk5m7c9hUk9sZB1r
        zkygJftEntWNpwAVfsJX6FRdT/l8XjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623931090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HQzr/oBQrFVndjXMoJnRWNt/IYubj/nwj8QqaGhIaQ=;
        b=KjGtRtsOJUzUDE9uDuJkcBXmcJOvTnKsMF58tkVKl4BANEa1zDgAgzRfaA6B7IeGsiBVL6
        JEbnSHoAkhRd74AA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id CD5F6118DD;
        Thu, 17 Jun 2021 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623931090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HQzr/oBQrFVndjXMoJnRWNt/IYubj/nwj8QqaGhIaQ=;
        b=MjDBQgAZYCsi948sSCtkSBixD6GOtSdJH6Brk6uY5coR7n6avh/h69+5yS1X4DZu2rBBcO
        eMI5VQSEXzuMytoR5+APq6vlyYJA+uan08CjpRsRvmj9trCwV05rlBdk5m7c9hUk9sZB1r
        zkygJftEntWNpwAVfsJX6FRdT/l8XjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623931090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HQzr/oBQrFVndjXMoJnRWNt/IYubj/nwj8QqaGhIaQ=;
        b=KjGtRtsOJUzUDE9uDuJkcBXmcJOvTnKsMF58tkVKl4BANEa1zDgAgzRfaA6B7IeGsiBVL6
        JEbnSHoAkhRd74AA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id RFxyMNE4y2CDFAAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 17 Jun 2021 11:58:09 +0000
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <353d222f-7fc1-61ea-d302-517af8f01252@suse.de>
Date:   Thu, 17 Jun 2021 13:58:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/21 9:49 AM, Valeriy Vdovin wrote:
> On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
>> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
>>
>>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
>>
>> It's actually a QMP command.  There are no "qapi methods".
>>
>>> get virtualized cpu model info generated by QEMU during VM initialization in
>>> the form of cpuid representation.
>>>
>>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
>>
>> virtual CPU
>>
>>> command line option. From there it takes the name of the model as the basis for
>>> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
>>> that state if additional cpu features should be present on the virtual cpu or
>>> excluded from it (tokens '+'/'-' or '=on'/'=off').
>>> After that QEMU checks if the host's cpu can actually support the derived
>>> feature set and applies host limitations to it.
>>> After this initialization procedure, virtual cpu has it's model and
>>> vendor names, and a working feature set and is ready for identification
>>> instructions such as CPUID.
>>>
>>> Currently full output for this method is only supported for x86 cpus.
>>
>> Not sure about "currently": the interface looks quite x86-specific to me.
>>
> Yes, at some point I was thinking this interface could become generic,
> but does not seem possible, so I'll remove this note.


Why is it impossible? What is the use case, is it something useful for example for ARM?


> 
>> The commit message doesn't mention KVM except in the command name.  The
>> schema provides the command only if defined(CONFIG_KVM).
>>
>> Can you explain why you need the restriction to CONFIG_KVM?
>>
> This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
> flag is set. I was choosing between this and writing empty implementation into
> kvm-stub.c
>>> To learn exactly how virtual cpu is presented to the guest machine via CPUID
>>> instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
>>
>> QMP command again.
>>
>>> method, one can get a full listing of all CPUID leafs with subleafs which are
>>> supported by the initialized virtual cpu.
>>>
>>> Other than debug, the method is useful in cases when we would like to
>>> utilize QEMU's virtual cpu initialization routines and put the retrieved
>>> values into kernel CPUID overriding mechanics for more precise control
>>> over how various processes perceive its underlying hardware with
>>> container processes as a good example.
>>>
>>> Output format:
>>> The output is a plain list of leaf/subleaf agrument combinations, that
>>
>> Typo: argument
>>
>>> return 4 words in registers EAX, EBX, ECX, EDX.
>>>
>>> Use example:
>>> qmp_request: {
>>>   "execute": "query-kvm-cpuid"
>>> }
>>>
>>> qmp_response: {
>>>   "return": [
>>>     {
>>>       "eax": 1073741825,
>>>       "edx": 77,
>>>       "in-eax": 1073741824,
>>>       "ecx": 1447775574,
>>>       "ebx": 1263359563
>>>     },
>>>     {
>>>       "eax": 16777339,
>>>       "edx": 0,
>>>       "in-eax": 1073741825,
>>>       "ecx": 0,
>>>       "ebx": 0
>>>     },
>>>     {
>>>       "eax": 13,
>>>       "edx": 1231384169,
>>>       "in-eax": 0,
>>>       "ecx": 1818588270,
>>>       "ebx": 1970169159
>>>     },
>>>     {
>>>       "eax": 198354,
>>>       "edx": 126614527,
>>>       "in-eax": 1,
>>>       "ecx": 2176328193,
>>>       "ebx": 2048
>>>     },
>>>     ....
>>>     {
>>>       "eax": 12328,
>>>       "edx": 0,
>>>       "in-eax": 2147483656,
>>>       "ecx": 0,
>>>       "ebx": 0
>>>     }
>>>   ]
>>> }
>>>
>>> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
>>> ---
>>> v2: - Removed leaf/subleaf iterators.
>>>     - Modified cpu_x86_cpuid to return false in cases when count is
>>>       greater than supported subleaves.
>>> v3: - Fixed structure name coding style.
>>>     - Added more comments
>>>     - Ensured buildability for non-x86 targets.
>>> v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
>>>     - Fixed comments.
>>>     - Removed target check in qmp_query_cpu_model_cpuid.
>>> v5: - Added error handling code in qmp_query_cpu_model_cpuid
>>> v6: - Fixed error handling code. Added method to query_error_class
>>> v7: - Changed implementation in favor of cached cpuid_data for
>>>       KVM_SET_CPUID2
>>> v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
>>>     - Modified documentation to qmp method
>>>     - Removed helper struct declaration
>>> v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
>>>     - Pasted more complete response to commit message.
>>>
>>>  qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
>>>  target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
>>>  tests/qtest/qmp-cmd-test.c |  1 +
>>>  3 files changed, 81 insertions(+)
>>>
>>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>>> index e7811654b7..1e591ba481 100644
>>> --- a/qapi/machine-target.json
>>> +++ b/qapi/machine-target.json
>>> @@ -329,3 +329,46 @@
>>>  ##
>>>  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
>>>    'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
>>> +
>>> +##
>>> +# @CpuidEntry:
>>> +#
>>> +# A single entry of a CPUID response.
>>> +#
>>> +# One entry holds full set of information (leaf) returned to the guest in response
>>> +# to it calling a CPUID instruction with eax, ecx used as the agruments to that
>>
>> Typi: agruments
>>
>>> +# instruction. ecx is an optional argument as not all of the leaves support it.
>>
>> Please wrap doc comment lines around column 70.
>>
>>> +#
>>> +# @in-eax: CPUID argument in eax
>>> +# @in-ecx: CPUID argument in ecx
>>> +# @eax: eax
>>> +# @ebx: ebx
>>> +# @ecx: ecx
>>> +# @edx: edx
>>
>> Suggest
>>
>>    # @eax: CPUID result in eax
>>
>> and so forth.
>>
>>> +#
>>> +# Since: 6.1
>>> +##
>>> +{ 'struct': 'CpuidEntry',
>>> +  'data': { 'in-eax' : 'uint32',
>>> +            '*in-ecx' : 'uint32',
>>> +            'eax' : 'uint32',
>>> +            'ebx' : 'uint32',
>>> +            'ecx' : 'uint32',
>>> +            'edx' : 'uint32'
>>> +          },
>>> +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
>>> +
>>> +##
>>> +# @query-kvm-cpuid:
>>> +#
>>> +# Returns raw data from the KVM CPUID table for the first VCPU.
>>> +# The KVM CPUID table defines the response to the CPUID
>>> +# instruction when executed by the guest operating system.
>>> +#
>>> +# Returns: a list of CpuidEntry
>>> +#
>>> +# Since: 6.1
>>> +##
>>> +{ 'command': 'query-kvm-cpuid',
>>> +  'returns': ['CpuidEntry'],
>>> +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
>>
>> Is this intended to be a stable interface?  Interfaces intended just for
>> debugging usually aren't.
>>
> It is intented to be used as a stable interface.
>> [...]
>>
> 

