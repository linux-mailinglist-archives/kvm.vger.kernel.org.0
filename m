Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB9456D9F
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 11:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhKSKh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 05:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231841AbhKSKh4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 05:37:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637318094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbGLzkjgNaEv+2n1GPe5cuw5S72/BV9iwPVdzuqnx0E=;
        b=GteTPlUB6Yea4KnsaqPsSydb6UXIgdb3hozuSBdi1Ant08DgjxjMnDnZxkXkTnHfPpZTb5
        OCaG2+r2ZscB/l+8wIecbSD1zOyouPGGDPF3ErjlzqE7R/+eoS6dKOOSTDFOO3v358Pzgw
        U4YpIt4bFIVx2+Nx8tUSXdJW+G5bQKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-ZmCHQHdKO4aQUyRwvYZOHQ-1; Fri, 19 Nov 2021 05:34:51 -0500
X-MC-Unique: ZmCHQHdKO4aQUyRwvYZOHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0541871810;
        Fri, 19 Nov 2021 10:34:48 +0000 (UTC)
Received: from [10.39.194.192] (unknown [10.39.194.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B31846787F;
        Fri, 19 Nov 2021 10:34:31 +0000 (UTC)
Message-ID: <82b0cbf0-0afb-29c8-ae8c-3d302f966014@redhat.com>
Date:   Fri, 19 Nov 2021 11:34:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct
 map
Content-Language: en-US
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-16-jiangshanlai@gmail.com>
 <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
 <bcfa0e4d-f6ab-037a-9ce1-d0cd612422a5@linux.alibaba.com>
 <65e1f2ca-5d89-d67f-2e0e-542094f89f05@redhat.com>
 <1c3d50f5-8f42-f337-cecc-3115e73703e5@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1c3d50f5-8f42-f337-cecc-3115e73703e5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 11:30, Lai Jiangshan wrote:
>> 
> 
> Hello
> 
> Since 13, and 14 is queued, could you also queue this one and I will
> do the rename separately in the next patchset.  I found that the
> intent of this patch is hidden in the lengthened squashed patch (of
> this patch and the renaming patch).

Then you can do the renaming first?

Paolo

