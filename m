Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0345EF0C
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347139AbhKZNZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:25:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346771AbhKZNXO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 08:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637932801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMn0IHt58hMhIYB979E572IPiSJRHUyGPP5ZDhseN6I=;
        b=YZIvCLkh86ytu6Bm2DFQz4YudY9zvJ/MwhXGy3xnXH7+oNCZ32H9+aTUPJrHiyhDqya7CX
        H9y0QB5bkkcJyurSGpAkz/PZW4Ia46Q+FCyKZ1AzdFidMwmbnH6eswRPXYU4m4KilKmtd2
        Ir9BB1k6KbDyFhlSNlujNOm0GFipqIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-ooLAGVwWOnG5hwONK6pyHw-1; Fri, 26 Nov 2021 08:19:58 -0500
X-MC-Unique: ooLAGVwWOnG5hwONK6pyHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7079A92500;
        Fri, 26 Nov 2021 13:19:56 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3058E60854;
        Fri, 26 Nov 2021 13:19:54 +0000 (UTC)
Message-ID: <5611a352-7c09-5192-63fb-a00716ea051c@redhat.com>
Date:   Fri, 26 Nov 2021 14:19:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/3] KVM: Scalable memslots implementation additional
 patches
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
 <743fffd6-e0fb-6531-bfa6-c30103357ce2@redhat.com>
 <4062e0ca-88cf-3521-3cf1-b420fc6ca2f6@maciej.szmigiero.name>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4062e0ca-88cf-3521-3cf1-b420fc6ca2f6@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 14:18, Maciej S. Szmigiero wrote:
>>
>> You can go ahead and post v6, I'll replace.
> 
> Which tree should I target then?
> kvm/queue already has these commits so git refuses to rebase on top of it.
> 
> By the way, v6 will have more changes than this series since there will be
> patches for intermediate forms of code, too.

I'll undo them from kvm/queue shortly, since I've now updated all my 
development machines to 5.16-rc2.

Paolo

