Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102EE21EBEC
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGNIzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 04:55:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30695 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgGNIzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 04:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594716909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73S/IVSRb41NQET//LecZg2QFojO2k5JSxkBwEYr01g=;
        b=R6Kc1rrZZGFHxAJQnZMeLN5amBoXbx+grM8zPUONupJIV54DsBG2QxBqXpPlvfr7ifKBd6
        VmwAnSBKei92I6bFcqxMIx6GyITUD/ai8lkmYnBXbKNVmVDRmZh1Rr7OOptAYRmrSJqbMe
        jjQJ9TEqg1kLXbVS2YhrO9QGUlGnbWE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-URwmJ2kyOSWY7loRsZCqlg-1; Tue, 14 Jul 2020 04:55:08 -0400
X-MC-Unique: URwmJ2kyOSWY7loRsZCqlg-1
Received: by mail-wr1-f69.google.com with SMTP id g14so20745277wrp.8
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 01:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=73S/IVSRb41NQET//LecZg2QFojO2k5JSxkBwEYr01g=;
        b=ZrdaL24mXlAobpZiR7VlLVDGEeYDsRVDInRp/aet7TP/QBeUSQYQU0PKdX1vgF/ZXN
         1Xf2ZvviBTJ1ZQy6sJRovAqRdNNwm7wBwFAjemRv29p2R8hBWSWZnb4QMaOjPBMOVBb8
         z7lkX78BLwZ7P3JtnnvwCv6Gk0hbtMwujbWnd62xgnkdXrzuUL3Rjc6vxxhLcO5Svrzf
         GH/NxQuxOuVJ+Hi9LQj9+FToVayPSzLBootUbPv8tnCb8erLCvZtLXDLp5g3Z/koNMRy
         OcIAsiDZaxNDkdXH2GPrsiHWhwS2yNEAv8jJdjFwiBLdaOSKFZN+g4Ux6zqLZYQBb3Pu
         sHJw==
X-Gm-Message-State: AOAM532V/AZK6IIsLSh4BRbk+OrMmp3T5bhnQM7zFs7Z0a3Ztcfv46Aw
        JAVe6Flns7gVbzPT2C/lUynWF4Sp39Vo1Xs8eI6GySEnn7m4AzCgDascrH/7Tz0/kJaf7cJMp+W
        citaGAvAWPVrj
X-Received: by 2002:adf:9404:: with SMTP id 4mr3804660wrq.367.1594716907283;
        Tue, 14 Jul 2020 01:55:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpc9sR4tw7tvh47yW+jR4/3qcFEgQli9j7i7YqnWb9GTJR0Kq/zgQzCdCvkqBfrz3On5f+uw==
X-Received: by 2002:adf:9404:: with SMTP id 4mr3804647wrq.367.1594716907130;
        Tue, 14 Jul 2020 01:55:07 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id n5sm3324370wmi.34.2020.07.14.01.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 01:55:06 -0700 (PDT)
Date:   Tue, 14 Jul 2020 04:55:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     david@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org
Subject: Re: [PATCH] virtio-balloon: Document byte ordering of poison_val
Message-ID: <20200714045454-mutt-send-email-mst@kernel.org>
References: <20200713203539.17140.71425.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713203539.17140.71425.stgit@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 01:35:39PM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> The poison_val field in the virtio_balloon_config is treated as a
> little-endian field by the host. Since we are currently only having to deal
> with a single byte poison value this isn't a problem, however if the value
> should ever expand it would cause byte ordering issues. Document that in
> the code so that we know that if the value should ever expand we need to
> byte swap the value on big-endian architectures.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Queued, thanks!

> ---
>  drivers/virtio/virtio_balloon.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1f157d2f4952..d0fd8f8dc6ed 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -974,6 +974,11 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  		/*
>  		 * Let the hypervisor know that we are expecting a
>  		 * specific value to be written back in balloon pages.
> +		 *
> +		 * If the PAGE_POISON value was larger than a byte we would
> +		 * need to byte swap poison_val here to guarantee it is
> +		 * little-endian. However for now it is a single byte so we
> +		 * can pass it as-is.
>  		 */
>  		if (!want_init_on_free())
>  			memset(&poison_val, PAGE_POISON, sizeof(poison_val));

