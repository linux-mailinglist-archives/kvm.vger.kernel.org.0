Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF94945EE13
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377552AbhKZMjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:39:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377182AbhKZMhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637930037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VPzVgc0AYP+sKhBkiolAFzffLls+sRar8XWgazVePtA=;
        b=WD3Mw0tTVQ5GpDSlQewA62FEaVliiY2PNT2H0bPa4QVHl1ncbBKlKbFp7qThesrEx65L4H
        VDzNVwRaj/MyBv6JGuT2+zueUEHGSKsULDlotGcz94dlTfxrlH9hsyWVLOYkHh0minnYsx
        neWiCWbReor072FA/2TLA77YMofYDyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-lecbiigyPvSggTsjaZoCPA-1; Fri, 26 Nov 2021 07:33:53 -0500
X-MC-Unique: lecbiigyPvSggTsjaZoCPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4AAA81CCB7;
        Fri, 26 Nov 2021 12:33:51 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 467C55D6B1;
        Fri, 26 Nov 2021 12:33:40 +0000 (UTC)
Message-ID: <086c9553-6ba1-411b-43db-b51670798938@redhat.com>
Date:   Fri, 26 Nov 2021 13:33:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5.5 00/30] KVM: Scalable memslots implementation
Content-Language: en-US
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
 <YYnNA5lZNXXdX/ig@google.com>
 <f3bc3bfc-37c3-bbfd-25b4-ef0a72e534ba@oracle.com>
 <5129f02d-7c0e-8e88-797f-95e8d968df88@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5129f02d-7c0e-8e88-797f-95e8d968df88@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/21 15:42, Maciej S. Szmigiero wrote:
> Paolo,
> 
> I see that you have merged the whole series to kvm/queue, even though it
> still needed some changes and, most importantly, a good round of testing.
> 
> Does this mean you want all these changes as a separate patch set on top
> of the already-merged series?

Hi Maciej,

you can squash your changes and post a v6.

Paolo

