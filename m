Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDAB2FBA55
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405119AbhASOwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:52:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389309AbhASLvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 06:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611057005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+631dB54hObrupYubPtQkJyLL4fsiVTiIHAwNM3YpQ=;
        b=a5gBGH7rblHfU3/9o15hrxyC7nOEIHvPacNzLUKBIyPNwK4TLY0TCvPC+8ePD1qJQqUHp6
        CtrYfJBmy61pVQgCsYTT8ubHMum8Yk5oys0054dWvyRZFDiGj4kQ4+iAnZhmF6gQ2kye8j
        2/yVGDd09hLDq4KQzYTiBL3IXhooxEQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-RHs7KWtXOpezIaSNoGA_3Q-1; Tue, 19 Jan 2021 06:50:02 -0500
X-MC-Unique: RHs7KWtXOpezIaSNoGA_3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C51A1005513;
        Tue, 19 Jan 2021 11:50:00 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-157.ams2.redhat.com [10.36.112.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60C5F189A4;
        Tue, 19 Jan 2021 11:49:49 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
From:   Thomas Huth <thuth@redhat.com>
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        qemu-block@nongnu.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        BALATON Zoltan via <qemu-devel@nongnu.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
 <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
 <307dea8e-148e-6666-c6f1-5cc66a54a7af@redhat.com>
 <20210118145016.GC1799018@redhat.com>
 <a9d9fb1d-f356-adb4-3763-a015e0d13320@redhat.com>
Message-ID: <a5b6e842-6a9d-c702-d369-d97b03f79e19@redhat.com>
Date:   Tue, 19 Jan 2021 12:49:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a9d9fb1d-f356-adb4-3763-a015e0d13320@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 16.12, Thomas Huth wrote:
> On 18/01/2021 15.50, Daniel P. Berrangé wrote:
>> On Mon, Jan 18, 2021 at 03:44:49PM +0100, Thomas Huth wrote:
>>> On 18/01/2021 14.37, Jiaxun Yang wrote:
>>>>
>>>>
>>>> On Mon, Jan 18, 2021, at 6:11 PM, Daniel P. Berrangé wrote:
>>>>> On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
>>>>>> We only run build test and check-acceptance as their are too many
>>>>>> failures in checks due to minor string mismatch.
>>>>>
>>>>> Can you give real examples of what's broken here, as that sounds
>>>>> rather suspicious, and I'm not convinced it should be ignored.
>>>>
>>>> Mostly Input/Output error vs I/O Error.
>>>
>>> Right, out of curiosity, I also gave it a try:
>>>
>>>   https://gitlab.com/huth/qemu/-/jobs/969225330
>>>
>>> Apart from the "I/O Error" vs. "Input/Output Error" difference, there also
>>> seems to be a problem with "sed" in some of the tests.
>>
>> The "sed" thing sounds like something that ought to be investigated
>> from a portability POV rather than ignored.
> 
> The weird thing is that we explicitly test for GNU sed in 
> tests/check-block.sh and skip the iotests if it's not available... so I'm a 
> little bit surprised that the iotests are run here with an apparently 
> different version of sed...?

Oh, well, I've fired up a bootable ISO image of Alpine, and ran "sed 
--version" and it says:

  This is not GNU sed version 4.0

Ouch. But I guess we could add a check for that to our tests/check-block.sh 
script, too...

  Thomas

