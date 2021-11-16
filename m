Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FF8453921
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbhKPSGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:06:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239262AbhKPSGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 13:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637085791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyiwGFV9nDr9Oh5QgswyHQLt8G1b9iomHWUtbCQgEdg=;
        b=iQetPDSmTobYRT83hkTqDR7ELB9qsDCvoj6FMh0Cr0N6cL4GQhWjHYaPEJPDirKaj6mjwN
        Lg1gsL8AB0Q1/4YKADHLDECgo01rsMKsKqJcWtl+b8vOivlHul3w8lSlXDYZkSX7IAYEwp
        qq5KbfKKDYieVMrLVRJdwRKCv/vTjDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-aInQcEeRP_ytE2YvZtSAkQ-1; Tue, 16 Nov 2021 13:03:09 -0500
X-MC-Unique: aInQcEeRP_ytE2YvZtSAkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46767875047;
        Tue, 16 Nov 2021 18:03:08 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F0A65D9DE;
        Tue, 16 Nov 2021 18:03:07 +0000 (UTC)
Message-ID: <ea98ccf5-059b-11b3-e071-a46bad687699@redhat.com>
Date:   Tue, 16 Nov 2021 19:03:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
References: <20211116105038.683627-1-pbonzini@redhat.com>
 <CALMp9eSy7-ziFeOrz+zsdBPOC7AqULYRSrP1kKSMWkFwrmzy8w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eSy7-ziFeOrz+zsdBPOC7AqULYRSrP1kKSMWkFwrmzy8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 18:49, Jim Mattson wrote:
> Thanks for fixing this. By the way, one of the reasons that we don't
> expose a virtual PMU to more customers is the conflict with the NMI
> watchdog. We aren't willing to give up the NMI watchdog on the host,
> and we don't really want to report a reduced number of general purpose
> counters to the guest. (On AMD, we *can't* report a reduced number of
> counters to the guest; the architectural specification doesn't allow
> it.)

FWIW we also generally use the PMU emulation only for debugging of guest 
performance issues.

> We can't be the only ones running with the NMI watchdog enabled. How
> do others deal with this? Is there any hope of suspending the NMI
> watchdog while in VMX non-root mode (or guest mode on AMD)?

Like, what do you think?

Paolo

>> This also hid a typo for the force_emulation_prefix module parameter,
>> which is part of the kvm module rather than the kvm_intel module,
>> so fix that.
>>
>> Reported-by: Like Xu <like.xu.linux@gmail.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

