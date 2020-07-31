Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12B2346EE
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbgGaNbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731291AbgGaNbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 09:31:08 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBDC061574
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 06:31:08 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f24so10944082ejx.6
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 06:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m1Ya0mFiuP28PxLyqssy3rNHO1I6I4Yh0BjcRwBcwN4=;
        b=vyfZFuONBpt2qShaHeLqHt+AF3cAZPxBu3pKL1s9kuTj/KHxXzaFjN+OPCuFgCcFcW
         e6X2bGdfPDpjW8yELng82cQlQS6J00+9FIxbPDUBeECEj/mvc53QEfzLoKSrCNUzbH1u
         ONSxTYYyk/EtocZ+CYvVnXZa0fSbp+mZPoQtKsI7C8EWLXwNSIgwRRDa+JqX7HkK67Lu
         dts0TAg9g659yPTJQn1Rn/CZxFNuuUlisLHt8RCM/dlhz/r6ESSyw1Q/NNCk1vwUarLF
         noT4wU947NgZLeVCsXNnt/1y1cmh78CEJPd9F8OMBYfdcd9W20txB6xg1lj8G+Gd/2m6
         2yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1Ya0mFiuP28PxLyqssy3rNHO1I6I4Yh0BjcRwBcwN4=;
        b=DBH3i2bq1AgFFf13PQv/avyWcBkfluKlnK+bHFIs4A5dWhs2M6AYpleIP8+4FpI/dL
         xi2rPZQJHjAXxosvfgzAoD+gniZ5y6z9gRBfd5+vd5eS/CQSX3OFb/GjXM8XwRYUtkzP
         SSe+AVIDCt6j7OeqBNNAIh77BRiNr/3d8XsrxDJyD6ST0xtgCb4l0wbGtjyzEmApB66i
         8+Kgcn8DLXwJCqkwAPK6dEtYxaXXhzMJOAWK6C3br7xqx0hSc3ZpyWNzMjgqMoC1UuVc
         C4aZSNPWZ9ZCIderNx5xDKacboKBPBPL4DCmQRwF298LovH4LOi8+2t4eEhcaAODHKIG
         Febw==
X-Gm-Message-State: AOAM530EkWeKgVOFSMQ9Adnx/G65tJkDraNphVpUjKrLsQJomUgIzB+p
        GwWYAVyKmqGwldAa5r3/0wlsXw==
X-Google-Smtp-Source: ABdhPJxD7gXAD8Im0heTzYHOuAJJceTrq55X9jq0+M0PPIcuIz6DxvQrj1pZxiMMIXxEsYe9V0cbGA==
X-Received: by 2002:a17:906:98c1:: with SMTP id zd1mr4243620ejb.410.1596202266681;
        Fri, 31 Jul 2020 06:31:06 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id i26sm9351360edv.70.2020.07.31.06.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 06:31:05 -0700 (PDT)
Date:   Fri, 31 Jul 2020 15:30:50 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, milon@wq.cz, julien.thierry.kdev@gmail.com,
        will@kernel.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
Subject: Re: [PATCH kvmtool] virtio: Fix ordering of
 virt_queue__should_signal()
Message-ID: <20200731133050.GB2486217@myrica>
References: <20200731101427.16284-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731101427.16284-1-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 11:14:27AM +0100, Alexandru Elisei wrote:
> The guest programs used_event in the avail queue to let the host know when

                                 nit: "avail ring"...

> it wants a notification from the device. The host notifies the guest when
> the used queue vring index passes used_event.

... and "used ring" are more consistent with the virtio spec.

> The virtio-blk guest driver, in the notification callback, sets used_event
> to the value of the current used queue vring index, which means it will get
> a notification after the next buffer is consumed by the host. It is
> possible for the guest to submit a job, and then go into uninterruptible
> sleep waiting for the notification (for example, via submit_bio_wait()).
> 
> On the host side, the virtio-blk device increments the used queue vring
> index, then compares it to used_event to decide if a notification should be
> sent.
> 
> A memory barrier between writing the new index value and reading used_event
> is needed to make sure we read the latest used_event value.  kvmtool uses a
> write memory barrier, which on arm64 translates into DMB ISHST. The
> instruction orders memory writes that have been executed in program order
> before the barrier relative to writes that have been executed in program
> order after the barrier.

Not sure this sentence is necessary.

> The barrier doesn't apply to reads, which means it
> is not enough to prevent reading a stale value for used_event. This can
> lead to the host not sending the notification, and the guest thread remains
> stuck indefinitely waiting for IO to complete.

It might be helpful to detail what the guest does, to identify which
barrier this pairs with on the guest side. I had a hard time convincing
myself that this is the right fix, but I think I got there in the end.

Kvmtool currently does:

	// virt_queue__used_idx_advance()
		vring.used.idx = idx
		wmb()
	// virtio_queue__should_signal()
	if (vring.used_event is between old and new idx)
		notify()

When simplifying Linux virtblk_done() I get:

	while (last_used != vring.used.idx) {
		...
		vring.used_event = ++last_used
		mb() // virtio_store_mb() in virtqueue_get_buf_ctx_split()
		...
		// unnecessary write+mb, here for completeness
		vring.used_event = last_used
		mb() // virtqueue_poll()
	}

(1) Kvmtool:
    writes vring.used.idx = 2
    wmb()
    reads vring.used_event = 1
    notifies the guest.

(2) Linux:
    (reads vring.used.idx = 2)
    writes vring.used_event = 2
    mb()
    reads vring.used.idx = 2
    returns from virtblk_done()

(3) Kvmtool:
    writes vring.used.idx = 3
    wmb()
    reads vring.used_event = 1
    doesn't notify, stalls the guest.

By replacing the wmb() with a full barrier we get the correct store buffer
pattern (SB+fencembonceonces.litmus).

> Using a memory barrier for reads and writes matches what the guest driver
> does when deciding to kick the host: after updating the avail queue vring
> index via virtio_queue_rq() -> virtblk_add_req() -> .. ->

Probably worth noting you're referring to Linux here.

> virtqueue_add_split(), it uses a read/write memory barrier before reading

                                or "full" memory barrier?

> avail_event from the used queue in virtio_commit_rqs() -> .. ->
> virtqueue_kick_prepare_split().
> 
> Also move the barrier in virt_queue__should_signal(), because the barrier
> is needed for notifications to work correctly, and it makes more sense to
> have it in the function that determines if the host should notify the
> guest.
> 
> Reported-by: Anvay Virkar <anvay.virkar@arm.com>
> Suggested-by: Anvay Virkar <anvay.virkar@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Regardless of the nits above, I believe this patch is correct

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
> This was observed by Anvay, where kvmtool reads the previous value of
> used_event and the notification is not sent.
> 
> I *think* this also fixes the VM hang reported in [1], where several
> processes in the guest were stuck in uninterruptible sleep. I am not
> familiar with the block layer, but my theory is that the threads were stuck
> in wait_for_completion_io(), from blk_execute_rq() executing a flush
> request. It would be great if Milan could give this patch a spin and see if
> the problem goes away. Don't know how reproducible it is though.
> 
> [1] https://www.spinics.net/lists/kvm/msg204543.html
> 
>  virtio/core.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/virtio/core.c b/virtio/core.c
> index f5b3c07fc100..90a661d12e14 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -33,13 +33,6 @@ void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
>  	wmb();
>  	idx += jump;
>  	queue->vring.used->idx = virtio_host_to_guest_u16(queue, idx);
> -
> -	/*
> -	 * Use wmb to assure used idx has been increased before we signal the guest.
> -	 * Without a wmb here the guest may ignore the queue since it won't see
> -	 * an updated idx.
> -	 */
> -	wmb();
>  }
>  
>  struct vring_used_elem *
> @@ -194,6 +187,14 @@ bool virtio_queue__should_signal(struct virt_queue *vq)
>  {
>  	u16 old_idx, new_idx, event_idx;
>  
> +	/*
> +	 * Use mb to assure used idx has been increased before we signal the
> +	 * guest, and we don't read a stale value for used_event. Without a mb
> +	 * here we might not send a notification that we need to send, or the
> +	 * guest may ignore the queue since it won't see an updated idx.
> +	 */
> +	mb();
> +
>  	if (!vq->use_event_idx) {
>  		/*
>  		 * When VIRTIO_RING_F_EVENT_IDX isn't negotiated, interrupt the
> -- 
> 2.28.0
> 
