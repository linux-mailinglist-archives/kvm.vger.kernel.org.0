Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801E31EAD7
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 11:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfEOJUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 05:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfEOJUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 05:20:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E84F34CF;
        Wed, 15 May 2019 09:20:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D6DB60F9C;
        Wed, 15 May 2019 09:19:58 +0000 (UTC)
Date:   Wed, 15 May 2019 11:19:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] lib: Remove redundant page zeroing
Message-ID: <20190515091955.dwvy2bbz6gyha35t@kamzik.brq.redhat.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
 <20190509200558.12347-4-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509200558.12347-4-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 15 May 2019 09:20:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 01:05:57PM -0700, Nadav Amit wrote:
> Now that alloc_page() zeros the page, remove the redundant page zeroing.
> 
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/virtio-mmio.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
> index 57fe78e..e5e8f66 100644
> --- a/lib/virtio-mmio.c
> +++ b/lib/virtio-mmio.c
> @@ -56,7 +56,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev,
>  	vq = calloc(1, sizeof(*vq));
>  	assert(VIRTIO_MMIO_QUEUE_SIZE_MIN <= 2*PAGE_SIZE);
>  	queue = alloc_pages(1);
> -	memset(queue, 0, 2*PAGE_SIZE);
>  	assert(vq && queue);
>  
>  	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
