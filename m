Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C71AD2D4
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 00:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgDPWdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 18:33:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728251AbgDPWdE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 18:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587076383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUf9DXimPD8UBiVLdfnQM98oUkmHdl6eiPE6mf0vIko=;
        b=Sps5ULMq4ITIhAj/rLvb95C6Fp04EONH3OvrUE5JSk4+D6z3FivwwiNo2AqBQkSrgLJf2F
        CzTaNbUZ/ExTmC94a7wvFhU0QW24k+p+0kRpIyD6NGAo9RwBt6QjOfSdbSVTNyiaeGqzC5
        oFGeC3SD4d38HRyq63tF0KQP4t15RXQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-KrlR-wwlNtGu9F7gI_QQQg-1; Thu, 16 Apr 2020 18:33:01 -0400
X-MC-Unique: KrlR-wwlNtGu9F7gI_QQQg-1
Received: by mail-wr1-f69.google.com with SMTP id d17so2465545wrr.17
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 15:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qUf9DXimPD8UBiVLdfnQM98oUkmHdl6eiPE6mf0vIko=;
        b=pzk7MDnjWbs3RD+2IC+l+t3BTyLl4NZC1l7485Fctr1gzAv8Sy0Jkz9I3CpAeVNOhf
         Fz1LEF2ZfvNmOC3HVVlQT+5BTbboyz88mMQ+hLWbqnVCKl5yhZUNNRaY9BWy8FsID0yI
         3SBSmTlwDOGVNmaXX1Sy65aYi8uRnlL0FA1fAVuMN1+Lkf12A8hSEjoPp0hBRGdhWKiF
         cnqcB/I07SBEaV7Ho9YRqbvsjWOEOI7gN3a5lZbl6B1afOHeDJx7f44MWAa5DnhM3OfE
         dtvUVMt/z7yzeZ2Ly2cnI8JcYxQLmhMKfiMdn7M1nOwFMLbPZ6fmVyMi//Y+lWxsOJs0
         vcBw==
X-Gm-Message-State: AGi0Puap3K78kNhks4Buqor+zDy0LZMOEznbds/4qSxyzh631b9p/+fy
        KCRC9OKxUenke7xefGjWoJ5f2N81zY69wtNqAtad2W0aJAkpWcJRr+1wQ+AmG3+rNLtqsO5NF55
        mVUk6SbdgWxw7
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr106315wmj.156.1587076380275;
        Thu, 16 Apr 2020 15:33:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypIy+rWP6GLwQOV39yuKvCoJ5WM3R60eHJj8M3PsMQSHsFk9lyxG27YOo0I93W1RyqT/v7nwTQ==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr106300wmj.156.1587076380092;
        Thu, 16 Apr 2020 15:33:00 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id h137sm6135220wme.0.2020.04.16.15.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 15:32:59 -0700 (PDT)
Date:   Thu, 16 Apr 2020 18:32:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] tools/virtio: Use __vring_new_virtqueue in
 virtio_test.c
Message-ID: <20200416183244-mutt-send-email-mst@kernel.org>
References: <20200416075643.27330-1-eperezma@redhat.com>
 <20200416075643.27330-6-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416075643.27330-6-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 09:56:40AM +0200, Eugenio Pérez wrote:
> As updated in ("2a2d1382fe9d virtio: Add improved queue allocation API")
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>

Pls add motivation for these changes.

> ---
>  tools/virtio/virtio_test.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index 1d5144590df6..d9827b640c21 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -106,10 +106,9 @@ static void vq_info_add(struct vdev_info *dev, int num)
>  	assert(r >= 0);
>  	memset(info->ring, 0, vring_legacy_size(num, 4096));
>  	vring_legacy_init(&info->vring, num, info->ring, 4096);
> -	info->vq = vring_new_virtqueue(info->idx,
> -				       info->vring.num, 4096, &dev->vdev,
> -				       true, false, info->ring,
> -				       vq_notify, vq_callback, "test");
> +	info->vq =
> +		__vring_new_virtqueue(info->idx, info->vring, &dev->vdev, true,
> +				      false, vq_notify, vq_callback, "test");
>  	assert(info->vq);
>  	info->vq->priv = info;
>  	vhost_vq_setup(dev, info);
> -- 
> 2.18.1

