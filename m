Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDCC1346B6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 16:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAHPwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 10:52:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727090AbgAHPwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 10:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578498734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Evzwb36HtckuGOEG5Qs7DyOdRE+yUkO/doQt26KVrXo=;
        b=V1uJVOaFVBj08k6nvajlY/HD+Krd3WZhrepuc5StOsGvWQhWlXpFE/YogghV0H9cfyrVng
        dgq50oaKBVUcFYhGlgf4AG7DykhWk0eABQRqgVqS4gedrMeCtqZwOm59sfcpB2j/OJLwZK
        /qnRxS8bb6dl6aU0jPIHBVIkFhpDIt0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-lGU6UUNjPaqC6ylqpY5zgQ-1; Wed, 08 Jan 2020 10:52:13 -0500
X-MC-Unique: lGU6UUNjPaqC6ylqpY5zgQ-1
Received: by mail-qt1-f197.google.com with SMTP id o18so2240306qtt.19
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 07:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Evzwb36HtckuGOEG5Qs7DyOdRE+yUkO/doQt26KVrXo=;
        b=dRP8WYPbm2az70yWe/b8vxITG2FCU6u9cWMKYfoPX0sBhZpfS8yoFmlpqW7CSUK3GH
         mVi7M3hS9e0/CpebS0yUeF9/0JLWnpiMgmzdacsanW9vVp47HsePTHZJOATQn6epmAlj
         poNcZrKHq8vNge0bVPybicNbkn6uT4WqUGO/xoAuRUAp5iKIi19U46WzSVOnIYcwA5E3
         g3dyJZSPI85Jbd9QsC++/F4vwUGXn1zL6LwTTy6QgrIERYFv6bgwl7xpMmwHiZ2EElJU
         s/G3ltKJ5PDkPvPs5c1sGsgfPiRx+EUuabTJCGHlza37m3AxvZdohjRsxxNKy6c+GkrM
         vqUg==
X-Gm-Message-State: APjAAAV3v7k/HtLyUVQ+mr+dz9abmnY5MExcGUBeO5/3f66od4N+U7xa
        BHLcWw4TUQw7DFB++eef4CBaaypefG9zx/sFYgsMk/H3LoEt1dswjzW+93U9Pru1e8blDxsJXDE
        Q84PNAIb1XIY/
X-Received: by 2002:ad4:40c7:: with SMTP id x7mr4822606qvp.176.1578498732895;
        Wed, 08 Jan 2020 07:52:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjS5NH4TYqHmq2a3gtG1MUvRpvaKlgnlgJSexza/h1pH4XW1r3TEGv4O2f8Ty8j7f9lGQzKQ==
X-Received: by 2002:ad4:40c7:: with SMTP id x7mr4822581qvp.176.1578498732594;
        Wed, 08 Jan 2020 07:52:12 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id c84sm1569751qkg.78.2020.01.08.07.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:52:11 -0800 (PST)
Date:   Wed, 8 Jan 2020 10:52:10 -0500
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
Message-ID: <20200108155210.GA7096@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191221014938.58831-9-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 08:49:29PM -0500, Peter Xu wrote:
> +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> +{
> +	struct kvm_dirty_gfn *entry;
> +	struct kvm_dirty_ring_indices *indices = ring->indices;
> +
> +	/*
> +	 * Note: here we will start waiting even soft full, because we
> +	 * can't risk making it completely full, since vcpu0 could use
> +	 * it right after us and if vcpu0 context gets full it could
> +	 * deadlock if wait with mmu_lock held.
> +	 */
> +	if (kvm_get_running_vcpu() == NULL &&
> +	    kvm_dirty_ring_soft_full(ring))
> +		return -EBUSY;

I plan to repost next week, but before that I'd like to know whether
there's any further (negative) feedback from design-wise, especially
here, which is still a bit tricky to makeup the kvmgt issue.

Now we still have the waitqueue but it'll only be used for
no-vcpu-context dirtyings, so:

- For no-vcpu-context: thread could wait in the waitqueue if it makes
  vcpu0's ring soft-full (note, previously it was hard-full, so here
  we make it easier to wait so we make sure )

- For with-vcpu-context: we should never wait, guaranteed by the fact
  that KVM_RUN will return now if soft-full for that vcpu ring, and
  above waitqueue will make sure even vcpu0's waitqueue won't be
  filled up by kvmgt

Again this is still a workaround for kvmgt and I think it should not
be needed after the refactoring.  It's just a way to not depend on
that work so this should work even with current kvmgt.

> +
> +	/* It will never gets completely full when with a vcpu context */
> +	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
> +
> +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> +	entry->slot = slot;
> +	entry->offset = offset;
> +	smp_wmb();
> +	ring->dirty_index++;
> +	WRITE_ONCE(indices->avail_index, ring->dirty_index);
> +
> +	trace_kvm_dirty_ring_push(ring, slot, offset);
> +
> +	return 0;
> +}

-- 
Peter Xu

