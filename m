Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1A16C26
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 22:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGUZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 16:25:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43281 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfEGUZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 16:25:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so4033975pfa.10
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 13:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SDTbfUna34Qd79ay/PvHpXeLqKHYqAqzFBtMK1XzxGI=;
        b=ON/NQjQWEi3fON/DDBAYu5HG4F3A9wQYYX3ZHXewW6rdfpyfN6GDeKnlxgf9/si9a9
         9JHSodUWXjDvUXWyvoEwEE0DgwhDeKMop/6LDrDPkGLUCYR03QkkfX5S7JFJ8pfilSDZ
         xvvi21rJRzAsyyhE+/kT6jH7WSjJD4+uklULukm2H+Pokk9wj1CJ1/NtVElLjBkK6KcS
         JqikN21lQ/W3kOqZE29va5iKvC/1zmXoxZvy0PuN6Nh+lQFN6TTKu80Ldt+bYozlFh95
         K/LSeCc2Mr0qC2NpnPv30EkDStUnE9M9IgeET/tA/SjNLgtMCQoX8YEn/nGCjEfLlQaU
         jpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SDTbfUna34Qd79ay/PvHpXeLqKHYqAqzFBtMK1XzxGI=;
        b=UFyAMEotPYk0tDuVdmcEEsAXbKxpGjia/wvWikL9cSsd0O8Rgr3XiouZqvklHkaQh4
         YfvjzxleVd7/u9d2jbM837QHR3hEbqwcBD9cxs1Ev55PR2+S/yqjdbh2UMOgmyHmC/+r
         t5nelQdeJrQyaNXKDTxJd1CtkjF09uiWEY1K5Ib9tHZST+ZweDoMBkUhLWGhE+0j1HKW
         3EKjxi6gXalNhygIfbISlLnlwGXcx1VUKKb9zPwkZXZ9+cyW8/UPcF5Sb3e6nJmLhLag
         1WEEkM4PYchLHZPkptL/jVaw0jHgu0zJ9FZT1ZK5a4Uubw1k/52ofurgNn5P/yWkRWSD
         0n4Q==
X-Gm-Message-State: APjAAAWT9zaefim8x0p/bS6rgQfQSoOb8/DKq+TxSk243DuJYJNQShxr
        8ObKHIinGhQftMzfesMEfK3hXA==
X-Google-Smtp-Source: APXvYqxbPfJ5tBulG/r6tvcVjjtvKQlgkwdEbMW3aGkGHvRkjNKPxepulcAi/TILththSdbF+vLDMw==
X-Received: by 2002:aa7:8dc3:: with SMTP id j3mr43498542pfr.141.1557260757236;
        Tue, 07 May 2019 13:25:57 -0700 (PDT)
Received: from jstaron2.mtv.corp.google.com ([2620:15c:202:201:b94f:2527:c39f:ca2d])
        by smtp.gmail.com with ESMTPSA id f5sm15855223pgo.75.2019.05.07.13.25.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 13:25:56 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH v7 2/6] virtio-pmem: Add virtio pmem driver
To:     Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Cc:     jack@suse.cz, mst@redhat.com, jasowang@redhat.com,
        david@fromorbit.com, lcapitulino@redhat.com,
        adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com,
        dave.jiang@intel.com, darrick.wong@oracle.com,
        vishal.l.verma@intel.com, david@redhat.com, willy@infradead.org,
        hch@infradead.org, jmoyer@redhat.com, nilal@redhat.com,
        lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com,
        yuval.shaia@oracle.com, stefanha@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, kwolf@redhat.com, tytso@mit.edu,
        xiaoguangrong.eric@gmail.com, cohuck@redhat.com, rjw@rjwysocki.net,
        imammedo@redhat.com, smbarber@google.com
References: <20190426050039.17460-1-pagupta@redhat.com>
 <20190426050039.17460-3-pagupta@redhat.com>
From:   =?UTF-8?Q?Jakub_Staro=c5=84?= <jstaron@google.com>
Message-ID: <3d6479ae-6c39-d614-f1d9-aa1978e2e438@google.com>
Date:   Tue, 7 May 2019 13:25:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426050039.17460-3-pagupta@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/19 10:00 PM, Pankaj Gupta wrote:

> +void host_ack(struct virtqueue *vq)
> +{
> +	unsigned int len;
> +	unsigned long flags;
> +	struct virtio_pmem_request *req, *req_buf;
> +	struct virtio_pmem *vpmem = vq->vdev->priv;
> +
> +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> +		req->done = true;
> +		wake_up(&req->host_acked);
> +
> +		if (!list_empty(&vpmem->req_list)) {
> +			req_buf = list_first_entry(&vpmem->req_list,
> +					struct virtio_pmem_request, list);
> +			list_del(&vpmem->req_list);

Shouldn't it be rather `list_del(vpmem->req_list.next)`? We are trying to unlink
first element of the list and `vpmem->req_list` is just the list head.

> +int virtio_pmem_flush(struct nd_region *nd_region)
> +{
> +	int err;
> +	unsigned long flags;
> +	struct scatterlist *sgs[2], sg, ret;
> +	struct virtio_device *vdev = nd_region->provider_data;
> +	struct virtio_pmem *vpmem = vdev->priv;
> +	struct virtio_pmem_request *req;
> +
> +	might_sleep();
> +	req = kmalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	req->done = req->wq_buf_avail = false;
> +	strcpy(req->name, "FLUSH");
> +	init_waitqueue_head(&req->host_acked);
> +	init_waitqueue_head(&req->wq_buf);
> +	sg_init_one(&sg, req->name, strlen(req->name));
> +	sgs[0] = &sg;
> +	sg_init_one(&ret, &req->ret, sizeof(req->ret));
> +	sgs[1] = &ret;
> +
> +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> +	if (err) {
> +		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
> +
> +		list_add_tail(&vpmem->req_list, &req->list);
> +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> +
> +		/* When host has read buffer, this completes via host_ack */
> +		wait_event(req->wq_buf, req->wq_buf_avail);
> +		spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +	}

Aren't the arguments in `list_add_tail` swapped? The element we are adding should
be first, the list should be second. Also, shouldn't we resubmit the request after
waking up from `wait_event(req->wq_buf, req->wq_buf_avail)`?

I propose rewriting it like that:

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 66b582f751a3..ff0556b04e86 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -25,7 +25,7 @@ void host_ack(struct virtqueue *vq)
 		if (!list_empty(&vpmem->req_list)) {
 			req_buf = list_first_entry(&vpmem->req_list,
 					struct virtio_pmem_request, list);
-			list_del(&vpmem->req_list);
+			list_del(vpmem->req_list.next);
 			req_buf->wq_buf_avail = true;
 			wake_up(&req_buf->wq_buf);
 		}
@@ -59,17 +59,33 @@ int virtio_pmem_flush(struct nd_region *nd_region)
 	sgs[1] = &ret;
 
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
-	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
-	if (err) {
-		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
+	/*
+	 * If virtqueue_add_sgs returns -ENOSPC then req_vq virtual queue does not
+	 * have free descriptor slots. We add the request to req_list and wait
+	 * for host_ack to wake us up when free slots are available.
+	 */
+	while ((err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC)) == -ENOSPC) {
+		dev_err(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue, postponing request\n");
+		req->wq_buf_avail = false;
 
-		list_add_tail(&vpmem->req_list, &req->list);
+		list_add_tail(&req->list, &vpmem->req_list);
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 		/* When host has read buffer, this completes via host_ack */
 		wait_event(req->wq_buf, req->wq_buf_avail);
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	}
+
+	/*
+	 * virtqueue_add_sgs failed with error different than -ENOSPC, we can't
+	 * do anything about that.
+	 */
+	if (err) {
+		dev_info(&vdev->dev, "failed to send command to virtio pmem device, error code %d\n", err);
+		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+		err = -EIO;
+		goto ret;
+	}
 	err = virtqueue_kick(vpmem->req_vq);
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);


Let me know if it looks reasonable to you.

Thank you,
Jakub Staron

