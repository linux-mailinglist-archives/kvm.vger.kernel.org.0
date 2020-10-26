Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5292299401
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788047AbgJZRhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:37:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1781164AbgJZRhb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603733850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dgLbSSo+gwIjMjhb1TdrDhXyagceazXJeQgMeT6e9ug=;
        b=Now0h8qkeXEZRiu0XjUQBubIghpoK+FnCpph7rkyghbBJkL6YMUuLH0JSMJFvwhCxUCgPg
        dg2nt5OTv1WpI+84ZWnYDb5CpmcdwajRtwMmbKQhwI5Hpaaybp4+AkvIvbhBuDyXYOjlmZ
        vUcANRYieiRj4eaAXEQ68ArArY7tHfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-hA-fk-aYNMyDO67OlORgyQ-1; Mon, 26 Oct 2020 13:37:28 -0400
X-MC-Unique: hA-fk-aYNMyDO67OlORgyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D495757203;
        Mon, 26 Oct 2020 17:37:26 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42F035C1BB;
        Mon, 26 Oct 2020 17:37:17 +0000 (UTC)
Date:   Mon, 26 Oct 2020 11:37:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     cohuck@redhat.com, thuth@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, philmd@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 02/13] linux-headers: update against 5.10-rc1
Message-ID: <20201026113716.2c67aec6@w520.home>
In-Reply-To: <1603726481-31824-3-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
        <1603726481-31824-3-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Oct 2020 11:34:30 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h | 14 ++--
>  .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h        |  2 +-
>  include/standard-headers/linux/ethtool.h           |  2 +
>  include/standard-headers/linux/fuse.h              | 50 +++++++++++++-
>  include/standard-headers/linux/input-event-codes.h |  4 ++
>  include/standard-headers/linux/pci_regs.h          |  6 +-
>  include/standard-headers/linux/virtio_fs.h         |  3 +
>  include/standard-headers/linux/virtio_gpu.h        | 19 ++++++
>  include/standard-headers/linux/virtio_mmio.h       | 11 +++
>  include/standard-headers/linux/virtio_pci.h        | 11 ++-
>  linux-headers/asm-arm64/kvm.h                      | 25 +++++++
>  linux-headers/asm-arm64/mman.h                     |  1 +
>  linux-headers/asm-generic/hugetlb_encode.h         |  1 +
>  linux-headers/asm-generic/unistd.h                 | 18 ++---
>  linux-headers/asm-mips/unistd_n32.h                |  1 +
>  linux-headers/asm-mips/unistd_n64.h                |  1 +
>  linux-headers/asm-mips/unistd_o32.h                |  1 +
>  linux-headers/asm-powerpc/unistd_32.h              |  1 +
>  linux-headers/asm-powerpc/unistd_64.h              |  1 +
>  linux-headers/asm-s390/unistd_32.h                 |  1 +
>  linux-headers/asm-s390/unistd_64.h                 |  1 +
>  linux-headers/asm-x86/kvm.h                        | 20 ++++++
>  linux-headers/asm-x86/unistd_32.h                  |  1 +
>  linux-headers/asm-x86/unistd_64.h                  |  1 +
>  linux-headers/asm-x86/unistd_x32.h                 |  1 +
>  linux-headers/linux/kvm.h                          | 19 ++++++
>  linux-headers/linux/mman.h                         |  1 +
>  linux-headers/linux/vfio.h                         | 29 +++++++-
>  linux-headers/linux/vfio_zdev.h                    | 78 ++++++++++++++++++++++
>  29 files changed, 301 insertions(+), 23 deletions(-)
>  create mode 100644 linux-headers/linux/vfio_zdev.h
> 
> diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> index 7b4062a..acd4c83 100644
> --- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> +++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> @@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
>  
>  static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>  {
> -	const unsigned int idx = qatomic_read(var);
> +	const unsigned int idx = atomic_read(var);
>  
>  	if (pvrdma_idx_valid(idx, max_elems))
>  		return idx & (max_elems - 1);
> @@ -77,17 +77,17 @@ static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>  
>  static inline void pvrdma_idx_ring_inc(int *var, uint32_t max_elems)
>  {
> -	uint32_t idx = qatomic_read(var) + 1;	/* Increment. */
> +	uint32_t idx = atomic_read(var) + 1;	/* Increment. */
>  
>  	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
> -	qatomic_set(var, idx);
> +	atomic_set(var, idx);
>  }
>  
>  static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
>  					      uint32_t max_elems, uint32_t *out_tail)
>  {
> -	const uint32_t tail = qatomic_read(&r->prod_tail);
> -	const uint32_t head = qatomic_read(&r->cons_head);
> +	const uint32_t tail = atomic_read(&r->prod_tail);
> +	const uint32_t head = atomic_read(&r->cons_head);
>  
>  	if (pvrdma_idx_valid(tail, max_elems) &&
>  	    pvrdma_idx_valid(head, max_elems)) {
> @@ -100,8 +100,8 @@ static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
>  static inline int32_t pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
>  					     uint32_t max_elems, uint32_t *out_head)
>  {
> -	const uint32_t tail = qatomic_read(&r->prod_tail);
> -	const uint32_t head = qatomic_read(&r->cons_head);
> +	const uint32_t tail = atomic_read(&r->prod_tail);
> +	const uint32_t head = atomic_read(&r->cons_head);
>  
>  	if (pvrdma_idx_valid(tail, max_elems) &&
>  	    pvrdma_idx_valid(head, max_elems)) {


The above is clearly just going to revert Stefan's changes to this file
via:

d73415a31547 )"qemu/atomic.h: rename atomic_ to qatomic_")

For now I'm just going to drop these changes (with comment) to avoid
that.  I'll leave it to others to fix the header update script to either
reimplement the s/atomic_/qatomic_/ conversion or remove these code
blocks altogether.  Sound ok?  Thanks,

Alex

