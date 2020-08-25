Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6B2519B6
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgHYNc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 09:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbgHYNcq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 09:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598362365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeiDq+nNatpwcxan8SGeTyk8iZoWTgdgAtfYpuUfG3g=;
        b=fMUV+twQqqvpv9gCUeWoPyh8ypgPfAhQj9Noal1PI0p4NoSXvt3QcCwmlS7++oBoiWwmBE
        LXs2MTLScjeeKrWxlgRMXgmC4/aGolJEIYrUzyK0blgvWKAleqyod9oERWDaCMYCkpnQ+e
        MYz36zUbcqp9udzZtBm5B0r+hGQpY/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-GQ8cezbxMFG4ST_xRwJ6Zg-1; Tue, 25 Aug 2020 09:32:41 -0400
X-MC-Unique: GQ8cezbxMFG4ST_xRwJ6Zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 871C918A2253;
        Tue, 25 Aug 2020 13:32:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-152.ams2.redhat.com [10.36.112.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E8205DA33;
        Tue, 25 Aug 2020 13:32:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/2] Use same test names in the default
 and the TAP13 output format
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <20200825102036.17232-3-mhartmay@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <561a201b-3796-8c99-77e5-43756b2556e3@redhat.com>
Date:   Tue, 25 Aug 2020 15:32:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200825102036.17232-3-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/2020 12.20, Marc Hartmayer wrote:
> Use the same test names in the TAP13 output as in the default output
> format. This makes the output more consistent. To achieve this, we
> need to pass the test name as an argument to the function
> `process_test_output`.
> 
> Before this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
> 
> vs.
> 
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest: true
> ok 2 - selftest: argc == 3
> ...
> 
> After this change:
> $ ./run_tests.sh
> PASS selftest-setup (14 tests)
> ...
> 
> vs.
> 
> $ ./run_tests.sh -t
> TAP version 13
> ok 1 - selftest-setup: selftest: true
> ok 2 - selftest-setup: selftest: argc == 3
> ...
> 
> While at it, introduce a local variable `kernel` in
> `RUNTIME_log_stdout` since this makes the function easier to read.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  run_tests.sh         | 15 +++++++++------
>  scripts/runtime.bash |  6 +++---
>  2 files changed, 12 insertions(+), 9 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

