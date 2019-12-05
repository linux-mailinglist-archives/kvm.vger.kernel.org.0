Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D571147E3
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 20:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfLET7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 14:59:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45174 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729187AbfLET7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 14:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575575977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWNSf29mI3MtykR8BlHVVbiXJxX25JJg8iyhbBzj48A=;
        b=hx44nlvtkq5WwynOFC26Au9+OiJdNhIaVhIOnFcXhrcEijZaRlQ7sah/ZZazYwDBvWGLfc
        g7w0prt4gGmTggj6G/9cQX/tUbOF3BCzE9NTSNRZTcqq2xlAd2CWNODED92JIdWO7q0UFz
        dXUyEzSILSxcOktilvE0khRArDOr0Qk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-9bkw6WrIM5mpuC8DgGgw7w-1; Thu, 05 Dec 2019 14:59:36 -0500
Received: by mail-wr1-f70.google.com with SMTP id b13so1998318wrx.22
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 11:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KWNSf29mI3MtykR8BlHVVbiXJxX25JJg8iyhbBzj48A=;
        b=AWuCXEVDcunX8I+KSKqrby5A8k9QZI4NE1NfZflhVNutV5FJMsgOcBSKIHJ/ayyeev
         H94muEUoNkkUG8r/ha9Mx5B4PY5sP08wjUU+xZxeC6QMjQRy/cMHigmLZz6tKEiwsBNM
         9U+WPSIBUk+XLcSbpXBLXVn7w/S55pgHn5Nq9TEhw7SZ4Og1HhGbTHJJ8hWCtzzXRR1R
         17C50E5piPwK7LjhGxU9ru5/tcU/eLWUMvyZC78v7KDzi3ZKKezp+WnNlktWWaQDwIsG
         xt6k9sgJ3bJvs5icc6x5TRp0MJGiyvmF3kc3FaWXw7Lxq9gH81ZSYGpGjGukc9zFOb8/
         kQUA==
X-Gm-Message-State: APjAAAWCSUMbxYM9pTQdrSJMZEcOtX5Y7WNF/rVqqE2KrAhMfdOCOCIQ
        qUW6ZW1FSdi/L3R9hKI4m/tbDfEcGQymEdgbm0FqhUueAZZnxKioteORLDmrQEc05dHfSAdJEWY
        UsqEQ6F9/tiWT
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr11594387wrt.339.1575575975181;
        Thu, 05 Dec 2019 11:59:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1+nxZUj2WeYhM+NnoFIwZZeGs5+NEtZLacBLSKNmWmfrA26sajlD3+6CNDAV4DoVVuD7YdQ==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr11594377wrt.339.1575575974905;
        Thu, 05 Dec 2019 11:59:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id h127sm980721wme.31.2019.12.05.11.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 11:59:34 -0800 (PST)
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
 <20191202021337.GB18887@xz-x1>
 <b893745e-96c1-d8e4-85ec-9da257d0d44e@redhat.com>
 <20191205193055.GA7201@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60888f25-2299-2a04-68c2-6eca171a2a18@redhat.com>
Date:   Thu, 5 Dec 2019 20:59:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191205193055.GA7201@xz-x1>
Content-Language: en-US
X-MC-Unique: 9bkw6WrIM5mpuC8DgGgw7w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 20:30, Peter Xu wrote:
>> Try enabling kvmmmu tracepoints too, it will tell
>> you more of the path that was taken while processing the EPT violation.
>
> These new tracepoints are extremely useful (which I didn't notice
> before).

Yes, they are!

> So here's the final culprit...
> 
> void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> {
>         ...
> 	spin_lock(&kvm->mmu_lock);
> 	/* FIXME: we should use a single AND operation, but there is no
> 	 * applicable atomic API.
> 	 */
> 	while (mask) {
> 		clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
> 		mask &= mask - 1;
> 	}
> 
> 	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> 	spin_unlock(&kvm->mmu_lock);
> }
> 
> The mask is cleared before reaching
> kvm_arch_mmu_enable_log_dirty_pt_masked()..

I'm not sure why that results in two vmexits?  (clearing before
kvm_arch_mmu_enable_log_dirty_pt_masked is also what
KVM_{GET,CLEAR}_DIRTY_LOG does).

> The funny thing is that I did have a few more patches to even skip
> allocate the dirty_bitmap when dirty ring is enabled (hence in that
> tree I removed this while loop too, so that has no such problem).
> However I dropped those patches when I posted the RFC because I don't
> think it's mature, and the selftest didn't complain about that
> either..  Though, I do plan to redo that in v2 if you don't disagree.
> The major question would be whether the dirty_bitmap could still be
> for any use if dirty ring is enabled.

Userspace may want a dirty bitmap in addition to a list (for example:
list for migration, bitmap for framebuffer update), but it can also do a
pass over the dirty rings in order to update an internal bitmap.

So I think it make sense to make it either one or the other.

Paolo

