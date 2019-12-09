Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B5A1174EA
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 19:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLISxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 13:53:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726335AbfLISxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 13:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575917580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=CWcZRJEpZKDqCIG7TiqGR99UZOB6+8bAvDVIMbEFGq0=;
        b=ZjhefA+lcxesTLkAFiCNs9cspzZYANv8zChnL09tad7T+lNKIeSteesDyByFpE1V3VtCPq
        USM9RHQiwQp+/i6WVr1KEeTNt/1qYIlMCObwzgErURvhtVHs8DGmiERn2QCTskmlB3lm56
        W9HTKCbml9gDbfB6/Y/L0PYHX1XnP1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-F8WGKYxLODKlBgLPf7mNbA-1; Mon, 09 Dec 2019 13:52:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27CA710054E3
        for <kvm@vger.kernel.org>; Mon,  9 Dec 2019 18:52:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-86.ams2.redhat.com [10.36.116.86])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C97B60BE1;
        Mon,  9 Dec 2019 18:52:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Run 32-bit tests with KVM, too
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20191205170439.11607-1-thuth@redhat.com>
 <699a350a-3956-5757-758c-0e246d698a7d@redhat.com>
 <e319993e-4732-d3ed-bca6-054c78103a61@redhat.com>
 <75b0e3d3-4d74-de4b-822f-e125711dbf56@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <077bbd45-7db6-83d8-88f2-100111db4775@redhat.com>
Date:   Mon, 9 Dec 2019 19:52:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <75b0e3d3-4d74-de4b-822f-e125711dbf56@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: F8WGKYxLODKlBgLPf7mNbA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/2019 18.42, Paolo Bonzini wrote:
> On 09/12/19 18:14, Thomas Huth wrote:
>> On 09/12/2019 18.07, Paolo Bonzini wrote:
>>> On 05/12/19 18:04, Thomas Huth wrote:
>>>> KVM works on Travis in 32-bit, too, so we can enable more tests there.
>>>>
>>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>  .travis.yml | 10 +++++++---
>>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/.travis.yml b/.travis.yml
>>>> index 4162366..75bcf08 100644
>>>> --- a/.travis.yml
>>>> +++ b/.travis.yml
>>>> @@ -34,15 +34,19 @@ matrix:
>>>>        env:
>>>>        - CONFIG="--arch=i386"
>>>>        - BUILD_DIR="."
>>>> -      - TESTS="eventinj port80 sieve tsc taskswitch umip vmexit_ple_round_robin"
>>>> +      - TESTS="asyncpf hyperv_stimer hyperv_synic kvmclock_test msr pmu realmode
>>>> +               s3 sieve smap smptest smptest3 taskswitch taskswitch2 tsc_adjust"
>>
>> taskswitch and taskswitch2 are here ----------------^
> 
> You're right, but I'm confused: what are the two separate configurations
> for?  Worth a comment?

For all architectures we've got one entry for in-tree builds and one
in-tree entry for out-of-tree builds. Since we've got these two entries
anyway, I simply split up the set of tests to speed up the CI process a
little bit.

 Thomas

