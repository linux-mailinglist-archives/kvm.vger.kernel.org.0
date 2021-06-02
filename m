Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A229399652
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFBXZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhFBXZv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 19:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622676247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32yapjM7P2WKlGgXTw+cmudjE2tHbVURPSGd4GZ1TRs=;
        b=J3VdWDFw0OL+Oq/ywe04xT/wdFtwGvfmEgODzEFjUomO7UBsV+Yrf+wCK0e1MU9rikxNHe
        l6h9jYG/L3l1HwhYRTy3X6hmK4KiPDOW+7Pi9QvmniakoMObYM+eW7HtjqdbvyuQqP4sr2
        ZisQ3GMZ6IeoMLk8BcJ9rC2s8S9ujC4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-2YiF1Q6DOmKeyw94KIjFxQ-1; Wed, 02 Jun 2021 19:24:06 -0400
X-MC-Unique: 2YiF1Q6DOmKeyw94KIjFxQ-1
Received: by mail-ed1-f70.google.com with SMTP id x8-20020aa7d3880000b029038fe468f5f4so2253176edq.10
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 16:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=32yapjM7P2WKlGgXTw+cmudjE2tHbVURPSGd4GZ1TRs=;
        b=lEGLfuXomlFL1jb8jZ3r/f3Uv291IjdUgxWGyqDvaduvChJHrzj9mtSDFwZycKZSD3
         iwIVQAyE40zDQa3DdANyquhNzRd9L6CgrpVodF0oZfHqkdnd58c2pG1jRDI7S6z/6qPV
         U04y547BB5LsniP8Zpzhcxa9XSvVtvBOMOwdzVB2nrZFM0qsaePH3SJSxakbsLugwrGB
         BexmgBBGed3iJwItffgdc0pms/ezNZoipREZMAsORPEZHqpYWfktlRK/bvMTCfxx9WXO
         fzuncNVcv53FEBbWlil4PQnRHjDGqWM/4d6s9UldXV4UB8t7CMdo1A2WV2wIxA+0ah6S
         lSnQ==
X-Gm-Message-State: AOAM533b1RxrkymbdDrblry85FXrsx6wy3LHe6EDU2Fb4czD8CJ3XaPa
        x11FXSq/u7Wu9bie6VpRFco8qdG+VvyltAW+4peJlinBA0QduYBn3loIaI5boeSA3Ylyhp/n6un
        U5ebtL6KRk2ZM
X-Received: by 2002:a17:906:6c88:: with SMTP id s8mr10970068ejr.129.1622676244496;
        Wed, 02 Jun 2021 16:24:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEBz6BrPcvbQgWkbTtc7tntpee6QnsimtFGcGxwdyc60NnAEn6IvC0i7FqK1ccayc+NGrvpQ==
X-Received: by 2002:a17:906:6c88:: with SMTP id s8mr10970059ejr.129.1622676244290;
        Wed, 02 Jun 2021 16:24:04 -0700 (PDT)
Received: from [192.168.1.36] (235.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.235])
        by smtp.gmail.com with ESMTPSA id r1sm724495edp.90.2021.06.02.16.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 16:24:03 -0700 (PDT)
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
 <266974fa-da6c-d0fc-ce12-6a7ce1752fa6@redhat.com>
 <20210602204604.crsxvqixkkll4ef4@habkost.net>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <4e53e323-076c-da89-4239-cb15df8de210@redhat.com>
Date:   Thu, 3 Jun 2021 01:24:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210602204604.crsxvqixkkll4ef4@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/21 10:46 PM, Eduardo Habkost wrote:
> On Wed, Jun 02, 2021 at 08:17:28PM +0200, Philippe Mathieu-Daudé wrote:
>> Hi Valeriy,
>>
>> (Sorry for not looking earlier than v8)
>>
>> On 5/31/21 2:38 PM, Valeriy Vdovin wrote:
>>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
>>> get virtualized cpu model info generated by QEMU during VM initialization in
>>> the form of cpuid representation.
>>>
>>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
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
>>>
>>> To learn exactly how virtual cpu is presented to the guest machine via CPUID
>>> instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
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
>>> return 4 words in registers EAX, EBX, ECX, EDX.
>>>
>>> Use example:
>>> qmp_request: {
>>>   "execute": "query-kvm-cpuid"
>>> }
>>>
>>> qmp_response: [
>>>   {
>>>     "eax": 1073741825,
>>>     "edx": 77,
>>>     "in_eax": 1073741824,
>>>     "ecx": 1447775574,
>>>     "ebx": 1263359563,
>>>   },
>>>   {
>>>     "eax": 16777339,
>>>     "edx": 0,
>>>     "in_eax": 1073741825,
>>>     "ecx": 0,
>>>     "ebx": 0,
>>>   },
>>>   {
>>>     "eax": 13,
>>>     "edx": 1231384169,
>>>     "in_eax": 0,
>>>     "ecx": 1818588270,
>>>     "ebx": 1970169159,
>>>   },
>>>   {
>>>     "eax": 198354,
>>>     "edx": 126614527,
>>>   ....
>>>
>>> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>

>>> +##
>>> +# @query-kvm-cpuid:
>>> +#
>>> +# Returns raw data from the KVM CPUID table for the first VCPU.
>>> +# The KVM CPUID table defines the response to the CPUID
>>> +# instruction when executed by the guest operating system.
>>
>> What is specific to KVM here?
>>
>> What about 'query-accel-cpuid' or 'query-vm-cpu-id'?
> 
> The implementation is KVM-specific.  I believe it's a reasonable
> compromise because the implementation is trivial, and a raw copy
> of the KVM CPUID table makes it a more useful (KVM-specific)
> debugging/testing mechanism.
> 
> I don't really mind how the command is called, but I would prefer
> to add a more complex abstraction only if maintainers of other
> accelerators are interested and volunteer to provide similar
> functionality.  I don't want to introduce complexity for use
> cases that may not even exist.

Fine, fair enough.

