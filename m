Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58217251856
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 14:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgHYMNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 08:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726159AbgHYMNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 08:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598357602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRb84yoWU02bJKdC05IFdd6POVTxOi7K/S0IjcbWkww=;
        b=ejbes7ABGzDNClv/FNdKgL85sLR+atHya1am9OPUtmlMewRdsEB7NHWVw6gYsoSYeWDK3t
        BHyrHb0TUeiUk5YgTz2gsDgX7gu4xt208zH36Lql1npBPHeDMMkNKD0ai+Z7fgWnOQop5o
        bMxb14IxmYq9XhD6A5DaFlCuVt01h7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-jY0FI__rNTO-NRKp7mQ4Ag-1; Tue, 25 Aug 2020 08:13:19 -0400
X-MC-Unique: jY0FI__rNTO-NRKp7mQ4Ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BA40427C4;
        Tue, 25 Aug 2020 12:13:18 +0000 (UTC)
Received: from gondolin (ovpn-112-248.ams2.redhat.com [10.36.112.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BC557D4E3;
        Tue, 25 Aug 2020 12:13:13 +0000 (UTC)
Date:   Tue, 25 Aug 2020 14:13:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] Use same test names in the
 default and the TAP13 output format
Message-ID: <20200825141312.07f52184.cohuck@redhat.com>
In-Reply-To: <20200825102036.17232-3-mhartmay@linux.ibm.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
        <20200825102036.17232-3-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Aug 2020 12:20:36 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

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

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

