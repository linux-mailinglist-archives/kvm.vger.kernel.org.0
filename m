Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730F3134545
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgAHOpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 09:45:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57670 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728468AbgAHOpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 09:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578494704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vG1ath56G+lAl5QaRIqxkcxGpxURDXQcxnpOGIL5ht4=;
        b=ewCOAH5LfJMe2FVr02AKJlgfwfi2UWhwwkhQKcUgxQs13Iu7znOF9QVU9938+x8A2BlFai
        ZsoPBqaVPEeFviMLa0fZxdGF84KMTZ0Gg19+VLDKkp9HH7jB8XL+HwdWuPHfQ3CXX92j1N
        2umf+T5ka/YUze4KE15BVrk5K/CIziE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-qE7QHYXwOQ2z1O2YmiRFHQ-1; Wed, 08 Jan 2020 09:45:01 -0500
X-MC-Unique: qE7QHYXwOQ2z1O2YmiRFHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C70F18024E0;
        Wed,  8 Jan 2020 14:44:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-114.ams2.redhat.com [10.36.117.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB4D67DB20;
        Wed,  8 Jan 2020 14:44:58 +0000 (UTC)
Subject: Re: [PATCH v3] KVM: s390: Add new reset vcpu API
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191205120956.50930-1-frankja@linux.ibm.com>
 <dd724da0-9bba-079e-6b6f-756762dbc942@de.ibm.com>
 <d0db08ef-ade9-93d4-105f-ace6fef50c81@linux.ibm.com>
 <3ddb7aa6-96d4-246f-a8ba-fdf2408a4ff0@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d3370e31-ca33-567d-ce0e-1168f603a686@redhat.com>
Date:   Wed, 8 Jan 2020 15:44:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3ddb7aa6-96d4-246f-a8ba-fdf2408a4ff0@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/2020 15.38, Christian Borntraeger wrote:
> 
> 
> On 08.01.20 15:35, Janosch Frank wrote:
>> On 1/8/20 3:28 PM, Christian Borntraeger wrote:
>>>
>>>
>>> On 05.12.19 13:09, Janosch Frank wrote:
>>> [...]
>>>> +4.123 KVM_S390_CLEAR_RESET
>>>> +
>>>> +Capability: KVM_CAP_S390_VCPU_RESETS
>>>> +Architectures: s390
>>>> +Type: vcpu ioctl
>>>> +Parameters: none
>>>> +Returns: 0
>>>> +
>>>> +This ioctl resets VCPU registers and control structures that QEMU
>>>> +can't access via the kvm_run structure. The clear reset is a superset
>>>> +of the initial reset and additionally clears general, access, floating
>>>> +and vector registers.
>>>
>>> As Thomas outlined, make it more obvious that userspace does the remaining
>>> parts. I do not think that we want the kernel to do the things (unless it
>>> helps you in some way for the ultravisor guests)
>>
>> Ok, will do
> 
> I changed my mind (see my other mail) but I would like Thomas, Conny or David
> to ack/nack.

I don't mind too much as long as it is properly documented, but I also
slightly prefer to be consistent here, i.e. let the kernel clear the
rest here, too, just like we do it already with the initial reset.

 Thomas

