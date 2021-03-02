Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0386432A703
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839003AbhCBPzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577775AbhCBJw6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 04:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614678688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=taBd6uLnFKceyekg9FzDQkJCAu7LLfUBn3MWlZnlhHs=;
        b=TRo3OewXdMJMAQxrGAYGYISDSDtd8leYQnX4LLxTihOXio+Ko8fWa+Bulfhql2mzihJcNq
        CW/KSd2q7ZeRgraPg2CNxzXkV6jNPANkImcn/QIhIpI3PB5u+0WO8niZEXXeEUBKl/tdGj
        bGIoGBqth7WGxqbeKzme8fpUhzfOXTQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-MpGU5_EhNySo4hxFAq6yIA-1; Tue, 02 Mar 2021 04:51:27 -0500
X-MC-Unique: MpGU5_EhNySo4hxFAq6yIA-1
Received: by mail-ed1-f71.google.com with SMTP id l23so10154634edt.23
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 01:51:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=taBd6uLnFKceyekg9FzDQkJCAu7LLfUBn3MWlZnlhHs=;
        b=lpoPqKBzt/ADduoF1X8sRZnn/w66CyNnaDTEgFUgE4FtCQP+DK6ZI/Svv9rT6CaQ5P
         3jEc9phMwVU/7YlUStUmVDUX6hU/J4bZUdnPPDBoQ2xnZowpB23Z/oLOfjFGfsoTwyuH
         FG/FoxXhzkv8uQ4l19ET9sdMUS6Z5ssRIuruHX4k9NfNkyp2nJ46X0Vi6Im/cpN8ITbU
         3nSBsuvk4YqVyMBX1U+PPI/KMnStm5bpngjhwnQIZWD6ffo8Jggemx8klHdfmTtqQf1I
         pL8IbU533ot1Sp9Llu3UYZRsNqxkY+3u0vb/uQAxth258j7f/aFlyRsW+rdB4Hsap4Ji
         K1Fw==
X-Gm-Message-State: AOAM532nsuFZ5eAwpKc+2mrg8yplWUuF/aLmBiaFIrW6fnFeYDQnNl0s
        i6SILOt7rnt1J9e6A0Ind3d/fV6OK3X9Hc1yCqLCb2se+A0+cQsxoAN8VsGZXAhGU0Z6LRA5diK
        06COFI42gSwXH
X-Received: by 2002:a50:e183:: with SMTP id k3mr20106117edl.45.1614678686032;
        Tue, 02 Mar 2021 01:51:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVGIo5XKn8nNvUOxG42+dGS0VnbP0nQwS9Jyziu/Fx8Ig8UChySv7eaRLgbNCVP6IBt5vl/w==
X-Received: by 2002:a50:e183:: with SMTP id k3mr20106110edl.45.1614678685903;
        Tue, 02 Mar 2021 01:51:25 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id v11sm17608252eds.14.2021.03.02.01.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 01:51:25 -0800 (PST)
Date:   Tue, 2 Mar 2021 04:51:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: honor CAP_IPC_LOCK
Message-ID: <20210302044918-mutt-send-email-mst@kernel.org>
References: <20210302091418.7226-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302091418.7226-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 04:14:18AM -0500, Jason Wang wrote:
> When CAP_IPC_LOCK is set we should not check locked memory against
> rlimit as what has been implemented in mlock().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Indeed and it's not just mlock.

Documentation/admin-guide/perf-security.rst:

RLIMIT_MEMLOCK and perf_event_mlock_kb resource constraints are ignored
for processes with the CAP_IPC_LOCK capability.

and let's add a Fixes: tag?

> ---
>  drivers/vhost/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..e93572e2e344 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -638,7 +638,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  	mmap_read_lock(dev->mm);
>  
>  	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
> +	if (!capable(CAP_IPC_LOCK) &&
> +	    (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit)) {
>  		ret = -ENOMEM;
>  		goto unlock;
>  	}
> -- 
> 2.18.1

