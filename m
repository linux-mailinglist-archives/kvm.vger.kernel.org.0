Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533E71FAF05
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPLWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:22:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbgFPLWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 07:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592306571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8p95dLYGiXlhS7tSjGAgFmp7iPVWRq1rt4vWUwLbkVU=;
        b=PBoSd5QuE0c9ut70xzhxJXsH1+Fl9RaGskRTK/3QK3asZX+ZjALlQHBX4mWLAVEIRI86gn
        j9nkHzViY9gDwnbbWOqDXpVLFglDWXqU0sLSsmefvYXgxjODXSDoVBqJHzMMJCR8bX9Qlh
        KxN6V64erhMI7mfYgHN+9GDgjPTjJqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-R-Pju4okOpajrFCEW3uA6g-1; Tue, 16 Jun 2020 07:22:48 -0400
X-MC-Unique: R-Pju4okOpajrFCEW3uA6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FB798730E3;
        Tue, 16 Jun 2020 11:22:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B153F60BEC;
        Tue, 16 Jun 2020 11:22:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Fix compilation on 32-bit hosts
To:     like.xu@intel.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     like.xu@linux.intel.com, vkuznets@redhat.com
References: <20200616105940.2907-1-thuth@redhat.com>
 <b7a62302-1d6f-c007-0358-dd9f85a698ca@intel.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <10dfe482-1f32-c70b-d6fe-7124e8c8e35e@redhat.com>
Date:   Tue, 16 Jun 2020 13:22:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b7a62302-1d6f-c007-0358-dd9f85a698ca@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/2020 13.13, Xu, Like wrote:
> On 2020/6/16 18:59, Thomas Huth wrote:
>> When building for 32-bit hosts, the compiler currently complains:
>>
>>   x86/pmu.c: In function 'check_gp_counters_write_width':
>>   x86/pmu.c:490:30: error: left shift count >= width of type
>>
>> Use the correct suffix to avoid this problem.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>
> Thanks, I admit I did not test it on a 32-bit host.

No problem, that's what the CI is good for :-)

(if you have a github or gitlab account, you can also run the tests
there before submitting a patch)

 Thomas

