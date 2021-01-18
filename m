Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F5A2FA44D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 16:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393324AbhARPOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 10:14:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393304AbhARPOT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 10:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OjettLIT0srMQXm6M8vqujMH7mAhY+HWU2AczcxjVhs=;
        b=Y3FEXTbCDY7xADfskwER86svBJuBOMKfYfhp4kwV/BZ/Y9Zy6W+jYspD+RaKuGrSEjk1vl
        QG9h1JIvVSpuGXhaKqalypZjdEfLhKCsl7xQGeVak+GSFqqlDKCtxQMuhoxD4QYeNWSzX+
        8mqUhkdFoRiaYT2TYmZ8HDGt0JScCtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-LT9BCj9vPFKexSP63dSzXw-1; Mon, 18 Jan 2021 10:12:51 -0500
X-MC-Unique: LT9BCj9vPFKexSP63dSzXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C758066E5;
        Mon, 18 Jan 2021 15:12:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BCB410016FA;
        Mon, 18 Jan 2021 15:12:43 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        qemu-block@nongnu.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        BALATON Zoltan via <qemu-devel@nongnu.org>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
 <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
 <307dea8e-148e-6666-c6f1-5cc66a54a7af@redhat.com>
 <20210118145016.GC1799018@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a9d9fb1d-f356-adb4-3763-a015e0d13320@redhat.com>
Date:   Mon, 18 Jan 2021 16:12:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118145016.GC1799018@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 15.50, Daniel P. Berrangé wrote:
> On Mon, Jan 18, 2021 at 03:44:49PM +0100, Thomas Huth wrote:
>> On 18/01/2021 14.37, Jiaxun Yang wrote:
>>>
>>>
>>> On Mon, Jan 18, 2021, at 6:11 PM, Daniel P. Berrangé wrote:
>>>> On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
>>>>> We only run build test and check-acceptance as their are too many
>>>>> failures in checks due to minor string mismatch.
>>>>
>>>> Can you give real examples of what's broken here, as that sounds
>>>> rather suspicious, and I'm not convinced it should be ignored.
>>>
>>> Mostly Input/Output error vs I/O Error.
>>
>> Right, out of curiosity, I also gave it a try:
>>
>>   https://gitlab.com/huth/qemu/-/jobs/969225330
>>
>> Apart from the "I/O Error" vs. "Input/Output Error" difference, there also
>> seems to be a problem with "sed" in some of the tests.
> 
> The "sed" thing sounds like something that ought to be investigated
> from a portability POV rather than ignored.

The weird thing is that we explicitly test for GNU sed in 
tests/check-block.sh and skip the iotests if it's not available... so I'm a 
little bit surprised that the iotests are run here with an apparently 
different version of sed...?

  Thomas

