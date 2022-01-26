Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0138E49CFBA
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbiAZQad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:30:33 -0500
Received: from beetle.greensocs.com ([5.135.226.135]:35912 "EHLO
        beetle.greensocs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiAZQac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:30:32 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 11:30:31 EST
Received: from [192.168.1.102] (cable-24-135-22-90.dynamic.sbb.rs [24.135.22.90])
        by beetle.greensocs.com (Postfix) with ESMTPSA id 97DE821C69;
        Wed, 26 Jan 2022 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=greensocs.com;
        s=mail; t=1643214074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uqh4KsL2gMxH4281NwmFQFGLD8dC2GISW8I2RMN2qa4=;
        b=ogpc7z33MBwwcdMUM/Aq/9Fz4eULAw5sKBbS1ekso8hjBo5r/e7SQtZ6/5g7INvYH36dUS
        wfO8APCXkwFufLhVociCyuUFCWjw2v2zJu4Os762A31pnCJQ29JXVnuAyZ5RuwlKzKpMEK
        fUi+ErLeYDz0lSUwCkJURx1yLvHwMiI=
Subject: Re: KVM call minutes for 2022-01-25
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        quintela@redhat.com, kvm-devel <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org
References: <87k0enrcr0.fsf@secure.mitica>
 <6ba8efb0-b4e0-dbda-e1f1-fac9dfa847fd@amsat.org>
From:   Mirela Grujic <mirela.grujic@greensocs.com>
Message-ID: <9fa5088c-0f43-747a-77f3-90fb68a05945@greensocs.com>
Date:   Wed, 26 Jan 2022 17:21:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6ba8efb0-b4e0-dbda-e1f1-fac9dfa847fd@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/25/22 5:54 PM, Philippe Mathieu-Daudé wrote:
> On 25/1/22 17:39, Juan Quintela wrote:
>>
>> Hi
>>
>> Today we have the KVM devel call.  We discussed how to create machines
>> from QMP without needing to recompile QEMU.
>>
>>
>> Three different problems:
>> - startup QMP (*)
>>    not discussed today
>> - one binary or two
>>    not discussed today
>> - being able to create machines dynamically.
>>    everybody agrees that we want this. Problem is how.
>> - current greensocs approach
>> - interested for all architectures, they need a couple of them
>>
>> what greensocs have:
>> - python program that is able to read a blob that have a device tree 
>> from the blob
>> - basically the machine type is empty and is configured from there
>> - 100 machines around 400 devices models
>> - Need to do the configuration before the machine construction happens
>> - different hotplug/coldplug
>> - How to describe devices that have multiple connections
>
> - problem realizing objects that have inter-dependent link properties
>
> Mirela, you mention an issue with TYPE_CPU_CLUSTER / TYPE_CPU, is that
> an example of this qom inter-link problem?
>

Yes, for cluster/cpu specifically it is the parent-child relationship 
between objects.


>> As the discussion is quite complicated, here is the recording of it.
>>
>> Later, Juan.
>>
>>
>> https://redhat.bluejeans.com/m/TFyaUsLqt3T/?share=True
>>
>> *: We will talk about this on the next call
>>
>>
>
