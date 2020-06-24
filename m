Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC02073BC
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 14:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390775AbgFXMwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 08:52:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55670 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388942AbgFXMwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 08:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593003132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUzO0qEqu9arcmCuZtUfpn6KlJSu5wBZTCa9jOa4Guk=;
        b=LxulAwUuG0K2lPZuG8sOCRifMSroUmW1ockCXOOFiHMrMCqQb6314nUpWcwDgBwKdtiWdu
        47KTr/2Py/SyaLEHMX1+W9OVtjoutS+4joq/+MO0VPzDuBIjDtcsHHzB4R2rMQSwXhrTx3
        J9/lqZRw3fOC29AdYlZyhJofsp1CiKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-Pw4DkEHOPyijq7vu6OSxUg-1; Wed, 24 Jun 2020 08:52:07 -0400
X-MC-Unique: Pw4DkEHOPyijq7vu6OSxUg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6AFD464;
        Wed, 24 Jun 2020 12:52:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-35.ams2.redhat.com [10.36.114.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18B032B47C;
        Wed, 24 Jun 2020 12:52:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
To:     Nadav Amit <namit@vmware.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200623084132.36213-1-namit@vmware.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <40203296-7f31-16c7-bebb-e1f1cd478a19@redhat.com>
Date:   Wed, 24 Jun 2020 14:52:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200623084132.36213-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 10.41, Nadav Amit wrote:
> Currently, the BSP's segment selectors are not initialized in 32-bit
> (cstart.S). As a result the tests implicitly rely on the segment
> selector values that are set by the BIOS. If this assumption is not
> kept, the task-switch test fails.
> 
> Fix it by initializing them.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>   x86/cstart.S | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)

I'm sorry to be the bearer of bad news again, but this commit broke 
another set of tests in the Travis CI:

  https://travis-ci.com/github/huth/kvm-unit-tests/jobs/353103187#L796

smptest, smptest3, kvmclock_test, hyperv_synic and hyperv_stimer are 
failing now in the 32-bit kvm-unit-tests :-(

  Thomas

