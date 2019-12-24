Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7AD12A2EE
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfLXPWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 10:22:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33846 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbfLXPWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 10:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577200969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuI7b+nn3459lNvQkwSbmuvlvnSiMF65nG57H/ptVY8=;
        b=aqCGKHMSg0Dq51SuGimgMrNqN/GqJMzJv2hgbfNuvAXFtX0nFKI7D9b/TNDuPSoZ/yBXTQ
        vFFdfwhsRn2AzizwRzSvGw0rSU0whtJPdVSb/zoL3hUoLecceZ49AclW6Tb03KYFq6CDoy
        9iBpvg66aWW8v43ReewHEO7/R6VbS30=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-qA4cHORhOemkmn_YEN1Qcw-1; Tue, 24 Dec 2019 10:22:48 -0500
X-MC-Unique: qA4cHORhOemkmn_YEN1Qcw-1
Received: by mail-qv1-f69.google.com with SMTP id l1so13365037qvu.13
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 07:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MuI7b+nn3459lNvQkwSbmuvlvnSiMF65nG57H/ptVY8=;
        b=VQITdDiD5Lt0+t3IRafnW3v+TJasR25j8Q/DQQ+BMdjZYH82iQ0OWs7R4B5boeKzgU
         fQRTPjiGPEE/fqN4u3Kga6J9AJ+46aJhyqUm2S/H9A2uYdsXGnnWvmdvxI1a6UoEUU2K
         e/2ghMzPjotO77SmtUf5xNjfQZUyScH3eOtxZ9c3VFr/g38jMNUu2dhmuBgaqtru9J7f
         j24OEQDOsOT5o1Oj6SnPtVYsn2OrCpq34xnR0lJEVUJUBDtq1ynPWknfgnlMiu2MLgUy
         sd45zcOfSq0pAI0tVuhV9pMla56dLLn3haDch4oVDrt2QVbWWg6bvdWiDuaJYlNFyPiM
         P9AA==
X-Gm-Message-State: APjAAAUJsmQ3bdN3glQKYxGnaekGV/ZyqKqvCtLrY1rRUGO9C+dP8LmI
        u/slwYPQchX7SRmw+CbQbNM0ota0mAKOqyOteYJpWUoJcdJo3GMNKdK/5VjMw8kekLrEDm+POsg
        kkiU1mGOvFJry
X-Received: by 2002:a05:620a:1014:: with SMTP id z20mr30191052qkj.196.1577200967807;
        Tue, 24 Dec 2019 07:22:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxm9X0Ulp164MwCgzA6asjIcE8aiO1u/sC2ZnBoMfHFDI+t0HcMgrLoAcn6xNfXVagojVgfow==
X-Received: by 2002:a05:620a:1014:: with SMTP id z20mr30191028qkj.196.1577200967586;
        Tue, 24 Dec 2019 07:22:47 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id s11sm6954216qkg.99.2019.12.24.07.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 07:22:46 -0800 (PST)
Date:   Tue, 24 Dec 2019 10:22:45 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RESEND v2 15/17] KVM: selftests: Add dirty ring buffer
 test
Message-ID: <20191224152245.GA17176@xz-x1>
References: <20191221020445.60476-1-peterx@redhat.com>
 <20191221020445.60476-5-peterx@redhat.com>
 <521fcdf6-db45-566d-7a83-e8c7a22cf7c5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <521fcdf6-db45-566d-7a83-e8c7a22cf7c5@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 24, 2019 at 02:18:37PM +0800, Jason Wang wrote:

[...]

> > +	while (fetch != avail) {
> > +		cur = &dirty_gfns[fetch % TEST_DIRTY_RING_COUNT];
> > +		TEST_ASSERT(cur->pad == 0, "Padding is non-zero: 0x%x", cur->pad);
> > +		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
> > +			    "%u != %u", cur->slot, slot);
> > +		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
> > +			    "0x%llx >= 0x%llx", cur->offset, num_pages);
> > +		DEBUG("fetch 0x%x offset 0x%llx\n", fetch, cur->offset);
> > +		test_and_set_bit(cur->offset, bitmap);
> > +		fetch++;
> 
> 
> Any reason to use test_and_set_bit()? I guess set_bit() should be
> sufficient.

Yes.

> 
> 
> > +		count++;
> > +	}
> > +	WRITE_ONCE(indices->fetch_index, fetch);
> 
> 
> Is WRITE_ONCE a must here?

No.

[...]

> > +void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +	struct vcpu *vcpu;
> > +	uint32_t size = vm->dirty_ring_size;
> > +
> > +	TEST_ASSERT(size > 0, "Should enable dirty ring first");
> > +
> > +	vcpu = vcpu_find(vm, vcpuid);
> > +
> > +	TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
> > +
> > +	if (!vcpu->dirty_gfns) {
> > +		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
> > +		vcpu->dirty_gfns = mmap(NULL, size, PROT_READ | PROT_WRITE,
> > +					MAP_SHARED, vcpu->fd, vm->page_size *
> > +					KVM_DIRTY_LOG_PAGE_OFFSET);
> 
> 
> It looks to me that we don't write to dirty_gfn.
> 
> So PROT_READ should be sufficient.

Yes.  Thanks,

-- 
Peter Xu

