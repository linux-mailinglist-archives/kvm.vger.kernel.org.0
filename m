Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505933AB317
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 13:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhFQL6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 07:58:41 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55356 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFQL6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 07:58:40 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E4A0F21A95;
        Thu, 17 Jun 2021 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623930991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DmCOhhtzltFG5CHRXZ3zBITQgsJ1hWHdtissxEUw9nU=;
        b=jU+Yyf178D4p9fXbFM02dw/9Khko2QU+jogiEmYhW4neTp2N0r0uzHbVuBI4r/Dua6p/lh
        aJZfq8NYaYhfP3C41L3JUXP/UgKPbjwJ2YlyCCP6nJ7ZAf2MjVO9CE40uZKu6ND597ZjRY
        X8BD3C0Se935SuQ9q+uvdiRxtmGdnDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623930991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DmCOhhtzltFG5CHRXZ3zBITQgsJ1hWHdtissxEUw9nU=;
        b=ZxkYmsGJuJT027sM49gD/izXUi1aVDQ/e16bzXtevVDSQ7PkMM4iSf8MLS6EQqJg2lS6e4
        eEtBArrqOrDeRgCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7D58C118DD;
        Thu, 17 Jun 2021 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623930991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DmCOhhtzltFG5CHRXZ3zBITQgsJ1hWHdtissxEUw9nU=;
        b=jU+Yyf178D4p9fXbFM02dw/9Khko2QU+jogiEmYhW4neTp2N0r0uzHbVuBI4r/Dua6p/lh
        aJZfq8NYaYhfP3C41L3JUXP/UgKPbjwJ2YlyCCP6nJ7ZAf2MjVO9CE40uZKu6ND597ZjRY
        X8BD3C0Se935SuQ9q+uvdiRxtmGdnDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623930991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DmCOhhtzltFG5CHRXZ3zBITQgsJ1hWHdtissxEUw9nU=;
        b=ZxkYmsGJuJT027sM49gD/izXUi1aVDQ/e16bzXtevVDSQ7PkMM4iSf8MLS6EQqJg2lS6e4
        eEtBArrqOrDeRgCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id nGCYHG84y2CwEwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 17 Jun 2021 11:56:31 +0000
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
To:     Markus Armbruster <armbru@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Denis Lunev <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <87a6no3fzf.fsf@dusky.pond.sub.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
Date:   Thu, 17 Jun 2021 13:56:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87a6no3fzf.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/21 1:09 PM, Markus Armbruster wrote:
> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
> 
>> On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
>>> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
>>>
>>>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
>>>
>>> It's actually a QMP command.  There are no "qapi methods".
>>>
>>>> get virtualized cpu model info generated by QEMU during VM initialization in
>>>> the form of cpuid representation.
>>>>
>>>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
>>>
>>> virtual CPU
>>>
>>>> command line option. From there it takes the name of the model as the basis for
>>>> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
>>>> that state if additional cpu features should be present on the virtual cpu or
>>>> excluded from it (tokens '+'/'-' or '=on'/'=off').
>>>> After that QEMU checks if the host's cpu can actually support the derived
>>>> feature set and applies host limitations to it.
>>>> After this initialization procedure, virtual cpu has it's model and
>>>> vendor names, and a working feature set and is ready for identification
>>>> instructions such as CPUID.
>>>>
>>>> Currently full output for this method is only supported for x86 cpus.
>>>
>>> Not sure about "currently": the interface looks quite x86-specific to me.
>>>
>> Yes, at some point I was thinking this interface could become generic,
>> but does not seem possible, so I'll remove this note.
>>
>>> The commit message doesn't mention KVM except in the command name.  The
>>> schema provides the command only if defined(CONFIG_KVM).
>>>
>>> Can you explain why you need the restriction to CONFIG_KVM?
>>>
>> This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
>> flag is set. I was choosing between this and writing empty implementation into
>> kvm-stub.c
> 
> If the command only makes sense for KVM, then it's named correctly, but
> the commit message lacks a (brief!) explanation why it only makes for
> KVM.


Is it meaningful for HVF?


> 
> If it just isn't implemented for anything but KVM, then putting "kvm"
> into the command name is a bad idea.  Also, the commit message should
> briefly note the restriction to KVM.
> 
> Pick one :)
> 
> [...]
> 
> 

