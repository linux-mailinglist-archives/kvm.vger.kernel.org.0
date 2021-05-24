Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C2738F28A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhEXRwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233648AbhEXRwS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKWHlvDpAOX2YOjXaO7xKlEtaWi7F8jzMufsyo9XHgc=;
        b=hA0azu6KVUXHUv9T6ZdhRT8GTf9VHpXXnjng/i3hUP4yn3Ya+bKKXNyl75Cw1gmHkAVRyI
        Js3ZkakApfR6mJOgJ9EX7oJqEYPCHFEN8qoSI6EYr5NMUf3vWK+E4+N6ykbUjVmbK8/tN2
        PLHntCVvUxyn7fb2hANI/qkM235jNGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-9xodV7ZwNni65W4xj53_Tw-1; Mon, 24 May 2021 13:50:46 -0400
X-MC-Unique: 9xodV7ZwNni65W4xj53_Tw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9FF419611B7;
        Mon, 24 May 2021 17:50:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A0870C26;
        Mon, 24 May 2021 17:50:00 +0000 (UTC)
Message-ID: <e0b30fb0ee3460c02685d0d7767686bab98db741.camel@redhat.com>
Subject: Re: [PATCH v3 03/12] KVM: X86: Rename kvm_compute_tsc_offset() to
 kvm_compute_tsc_offset_l1()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:49:59 +0300
In-Reply-To: <4526ec66-c531-262d-9661-13d134e2a84a@redhat.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-4-ilstam@amazon.com>
         <4526ec66-c531-262d-9661-13d134e2a84a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-24 at 16:21 +0200, Paolo Bonzini wrote:
> On 21/05/21 12:24, Ilias Stamatis wrote:
> > +			u64 adj = kvm_compute_tsc_offset_l1(vcpu, data) - vcpu->arch.l1_tsc_offset;
> 
> Better: kvm_compute_l1_tsc_offset.  So far anyway I can adjust this myself.

Nothing against this either!
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



> 
> Paolo
> 


