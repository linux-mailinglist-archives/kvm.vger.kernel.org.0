Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C679A3925F1
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 06:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhE0EOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 00:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhE0EOp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 00:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622088792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3igEycLd8J73C7Vxb8Ui44QuvOprk+cULPfcPtYoIg=;
        b=QFdc+ari0AIkQho7ZuWviXnT6YLKKHox7vh4d/LpQ7EaRavPHH0nekqPuTcJEIztGRMmuV
        SXATnMWMK4sDVnHvVXgpJFQAe5RByazoRNWWOxzVEagnHCOwcAZ50xNFfv6JE+m4SO29u9
        t/U+pFUY8xRs4sIZ3hoWB37rjK81GuE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-FlU6jLdfP4uDEJwk8HLPLQ-1; Thu, 27 May 2021 00:13:08 -0400
X-MC-Unique: FlU6jLdfP4uDEJwk8HLPLQ-1
Received: by mail-pj1-f72.google.com with SMTP id cv23-20020a17090afd17b029015cdd292fe8so1657205pjb.8
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 21:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q3igEycLd8J73C7Vxb8Ui44QuvOprk+cULPfcPtYoIg=;
        b=AAYrC/G9TKe7LVNu+cZ+UEtBGUXLTAw6JBc3W5o279Dre+H08O9+yD309gXq5CkHWG
         rCQboB+7KXngVhegW13YI/GZ9eC/bBVP5gEhLEOxKt1jWUp4Hlh+ybcEBWe/y5e37nRU
         T2/g/gtUv5DOtVLRGceqFRCdQSfz/0tax16pEIDRbCP0+nCn7b7M9RxTscVLT+fKp5OJ
         b6i24vjA5RbIScSZjBPS6Dy4HHHzAjdL/h3/wK8zHs+SitKMjhYV0bibHH4U1tRRQJpA
         YrG1Jj36jERz1VIr0olhbd3xfpz+0uFbLczNBdA41VkyqJzjku1yjO5YfOs2K7S+1XC4
         T3dg==
X-Gm-Message-State: AOAM530FrWoQu+GSvEx6g0C1b2UGzkwhnFMGpbtFD1xyg1lQUYCXU2xh
        cahm5zFvJxi3KGxesomxWiiWuzvIuvSNSgtXoo88C1r797c4cOe9i1SGIwNXkVa7hEMCLd5u/YH
        /xQ1nVTX/16Zi
X-Received: by 2002:a63:3c0e:: with SMTP id j14mr1842312pga.427.1622088787573;
        Wed, 26 May 2021 21:13:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNWCYMnMC1HxMoP07R/3S3m3jilU3dNCIEmruTMAtVdxqR2yiJbYdkUNhO/NZQxyTwe/4ddA==
X-Received: by 2002:a63:3c0e:: with SMTP id j14mr1842274pga.427.1622088787269;
        Wed, 26 May 2021 21:13:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c134sm622801pfb.135.2021.05.26.21.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 21:13:06 -0700 (PDT)
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
Date:   Thu, 27 May 2021 12:12:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210517095513.850-12-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/17 ÏÂÎç5:55, Xie Yongji Ð´µÀ:
> +
> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> +			      struct vduse_dev_msg *msg)
> +{
> +	init_waitqueue_head(&msg->waitq);
> +	spin_lock(&dev->msg_lock);
> +	vduse_enqueue_msg(&dev->send_list, msg);
> +	wake_up(&dev->waitq);
> +	spin_unlock(&dev->msg_lock);
> +	wait_event_killable(msg->waitq, msg->completed);


What happens if the userspace(malicous) doesn't give a response forever?

It looks like a DOS. If yes, we need to consider a way to fix that.

Thanks


> +	spin_lock(&dev->msg_lock);
> +	if (!msg->completed) {
> +		list_del(&msg->list);
> +		msg->resp.result = VDUSE_REQUEST_FAILED;
> +	}
> +	spin_unlock(&dev->msg_lock);
> +
> +	return (msg->resp.result == VDUSE_REQUEST_OK) ? 0 : -1;
> +}

