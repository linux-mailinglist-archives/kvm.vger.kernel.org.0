Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C273B367CFE
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhDVI5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhDVI5x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 04:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619081838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eDm0zu9SkqJeIJbwtGQk/q6WMyuzc06WeeMEfWgbdAw=;
        b=HME7EbGkhlUK35N3OE6+DcyfgaeoR3/XipxC0VSLdADJHm6dKCWkPV0mOmKUQwhiB63Dnf
        vOs4VFteW/XTrFq3nayiGa8hBJwBiGDkQSiN3NXyTnkqSd4WkSka9CuJhfXmWcUh8coRSu
        W1QOYzzxZbB5hdjV+eeAAjvxkziqbWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-Gj19dTFkP0a8efZ6-HaZjQ-1; Thu, 22 Apr 2021 04:57:16 -0400
X-MC-Unique: Gj19dTFkP0a8efZ6-HaZjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8838107ACF7;
        Thu, 22 Apr 2021 08:57:15 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A344C66FFF;
        Thu, 22 Apr 2021 08:57:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] update git tree location in MAINTAINERS to
 point at gitlab
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210421191611.2557051-1-jacobhxu@google.com>
 <edc3df0e-0eb7-108d-3371-2e13f285d632@redhat.com>
 <97adb2d3-47f4-385a-18b4-90572c9f486a@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <491fcafe-c7b1-f285-341b-f134dbe202b9@redhat.com>
Date:   Thu, 22 Apr 2021 10:57:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <97adb2d3-47f4-385a-18b4-90572c9f486a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/2021 09.39, Paolo Bonzini wrote:
> On 22/04/21 05:42, Thomas Huth wrote:
>> On 21/04/2021 21.16, Jacob Xu wrote:
>>> The MAINTAINERS file appears to have been forgotten during the migration
>>> to gitlab from the kernel.org. Let's update it now.
>>>
>>> Signed-off-by: Jacob Xu <jacobhxu@google.com>
>>> ---
>>>   MAINTAINERS | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 54124f6..e0c8e99 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -55,7 +55,7 @@ Maintainers
>>>   -----------
>>>   M: Paolo Bonzini <pbonzini@redhat.com>
>>>   L: kvm@vger.kernel.org
>>> -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
>>> +T:    https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
>>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> You're too humble, Thomas. :)  Since Drew and you have commit access this 
> could very well be:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ef7e9af..0082e58 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -54,8 +54,9 @@ Descriptions of section entries:
> Maintainers
> -----------
> M: Paolo Bonzini <pbonzini@redhat.com>
> +M: Thomas Huth <thuth@redhat.com>
> +M: Andrew Jones <drjones@redhat.com>
> L: kvm@vger.kernel.org
> -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> +T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git

Acked-by: Thomas Huth <thuth@redhat.com>

:-)

