Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451B82FA391
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbhAROtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 09:49:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405209AbhAROq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 09:46:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610981102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CtRRqyhOZNrMklCShy3k+WSqpjnR9LT9mE9ABLmCb3M=;
        b=fWdLwYvMtf8Y135lk9gbRXp25BkheM78zB9DWGRtQ1gllabuEgCvzDvaAOmpr/5mBLuJgR
        YXF8lLBxMIIdxv0Iu/qs3SA7WxwTFxQRbN05TeKQiBMbUce9V3zQy1r9TcstAkh/3ZT/wR
        GM3wY9MswtlW+txEwo00f8xDNI0J1JY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-LfXy7sJrMBCjdVz3TU6q0w-1; Mon, 18 Jan 2021 09:45:00 -0500
X-MC-Unique: LfXy7sJrMBCjdVz3TU6q0w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ACD010054FF;
        Mon, 18 Jan 2021 14:44:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2054C100239F;
        Mon, 18 Jan 2021 14:44:50 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     BALATON Zoltan via <qemu-devel@nongnu.org>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
 <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <307dea8e-148e-6666-c6f1-5cc66a54a7af@redhat.com>
Date:   Mon, 18 Jan 2021 15:44:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 14.37, Jiaxun Yang wrote:
> 
> 
> On Mon, Jan 18, 2021, at 6:11 PM, Daniel P. Berrangé wrote:
>> On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
>>> We only run build test and check-acceptance as their are too many
>>> failures in checks due to minor string mismatch.
>>
>> Can you give real examples of what's broken here, as that sounds
>> rather suspicious, and I'm not convinced it should be ignored.
> 
> Mostly Input/Output error vs I/O Error.

Right, out of curiosity, I also gave it a try:

  https://gitlab.com/huth/qemu/-/jobs/969225330

Apart from the "I/O Error" vs. "Input/Output Error" difference, there also 
seems to be a problem with "sed" in some of the tests.

Jiaxun, I think you could simply add a job like this instead:

check-system-alpine:
   <<: *native_test_job_definition
   needs:
     - job: build-system-alpine
       artifacts: true
   variables:
     IMAGE: alpine
     MAKE_CHECK_ARGS: check-qtest check-unit check-qapi-schema check-softfloat

That will run all the other tests, without the problematic check-block part.

  Thomas

