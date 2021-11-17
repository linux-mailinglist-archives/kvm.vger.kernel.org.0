Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BC0454D0E
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhKQS2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:28:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239962AbhKQS2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 13:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637173508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9x1CusrT8igLfM6MhA9CmHxdNVbcyZMsrBDw9/aXMSY=;
        b=NauNFe/Rjy1f1VOXhUMhsCjsxcVKqR7fiVF8Y8mNV6tNhijZAaDUHlbMowSiKTx6pxo/3f
        QSLZOnM2FLO+9hwqwP0n+YkXBkbqNZf/1L7W1hbFSXN6dOuWa9SVWjQgK/3zsK6fIOEYDE
        PHFgtabadF5AgkmDLbvDSjCmLlK0Qn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-38xd67xOP8-mFlkhoY4Opw-1; Wed, 17 Nov 2021 13:25:02 -0500
X-MC-Unique: 38xd67xOP8-mFlkhoY4Opw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61E5F8799E0;
        Wed, 17 Nov 2021 18:24:58 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62AE45BAE6;
        Wed, 17 Nov 2021 18:24:57 +0000 (UTC)
Message-ID: <1daca220-1b16-b318-5b77-7c53789cae67@redhat.com>
Date:   Wed, 17 Nov 2021 19:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/4] selftests: sev_migrate_tests: free all VMs
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
References: <20211117163809.1441845-1-pbonzini@redhat.com>
 <20211117163809.1441845-2-pbonzini@redhat.com>
 <CAMkAt6q15oP9MwBDGabD5+wJWVevUVxOwYVCgzwGTi64syL-9g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6q15oP9MwBDGabD5+wJWVevUVxOwYVCgzwGTi64syL-9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 17:52, Peter Gonda wrote:
> I think we are still missing the kvm_vm_free() from
> test_sev_migrate_locking(). Should we have this at the end?
> 
> for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
>      kvm_vm_free(input[i].vm);

Yes, we should.  Thanks!

Paolo

