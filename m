Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159D827BFEE
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgI2Ir1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:47:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI2Ir1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 04:47:27 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601369246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luLObbOwqnxrQyYoa4jawznqwHfZyvh5EioUv34w8xg=;
        b=YOqVZo1r6TEkyJnMMCvtJj+0FGlK9YhdoDQR90mD52sdcLks4fIRJewlNNsUX8FPIvk3Pc
        WEAV3F1r8THTSr4H20SVjKSoB/SM7Bb4Hol892yGCjw6UT0T7oHsMvwcVD7jyr1vK8leCt
        gBPOa2wEFS/y1sz5Lr4iwGK/66CbkY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-5Bc1VQpFNeuDn3mPZPw2Nw-1; Tue, 29 Sep 2020 04:47:23 -0400
X-MC-Unique: 5Bc1VQpFNeuDn3mPZPw2Nw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66EDF186840C;
        Tue, 29 Sep 2020 08:47:22 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.193.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4ECF10013BD;
        Tue, 29 Sep 2020 08:47:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
 <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c7b332f9-b81e-1bc8-7337-d525e8d033c5@redhat.com>
Date:   Tue, 29 Sep 2020 10:47:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/2020 10.38, Paolo Bonzini wrote:
> On 28/09/20 19:49, Thomas Huth wrote:
>>  Hi Paolo,
>>
>> the following changes since commit 58c94d57a51a6927a68e3f09627b2d85e3404c0f:
>>
>>   travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory (2020-09-25 10:00:36 +0200)
>>
>> are available in the Git repository at:
>>
>>   https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-09-28
>>
>> for you to fetch changes up to b508e1147055255ecce93a95916363bda8c8f299:
>>
>>   scripts/arch-run: use ncat rather than nc. (2020-09-28 15:03:50 +0200)
[...]
> Pulled, thanks (for now to my clone; waiting for CI to complete).
> Should we switch to Gitlab merge requests for pull requests only (i.e.
> patches still go on the mailing list)?

Fine for me, though I'm not sure whether the other maintainers are
already using gitlab or not... And do we need e-mail notifications for
such merge requests sent to the mailing list, in case anybody else still
wants to object?

 Thomas

