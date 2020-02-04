Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1CE151597
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 07:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBDGCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 01:02:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbgBDGCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 01:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580796119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RjdsRkXe77yTljkA9sXafvBdByUVdvxrTgCwvbrVV0w=;
        b=bPGJrEphWamsxL+uQ9P78Q3eSjfixaDLtAGa2bQ9B7DLfb6mW1CKUIBlzlDLITAeYLNBrQ
        vMJQV7SJbQPLn7Gj/TPTNOXLCjmKi4zw7emOXvdUpWLWCq/v0339/6/zH3by693GRCcGAF
        vMzq1PtmYMZUcPs38R/p+WhtZEL1RNc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-V_9P6IBrOUKtCA50Q0S0KQ-1; Tue, 04 Feb 2020 01:01:58 -0500
X-MC-Unique: V_9P6IBrOUKtCA50Q0S0KQ-1
Received: by mail-qv1-f70.google.com with SMTP id z9so11029273qvo.10
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 22:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RjdsRkXe77yTljkA9sXafvBdByUVdvxrTgCwvbrVV0w=;
        b=bgsNrOLNSq2YpaF/WVdF6tjZXol3bfjnV5vbUlTqM9zmNJrsMP4pQ5afXs/cHlHSS9
         aIVEYS/nsOLPyOVNxvDIN5b4NrxxjSh+Nu1lvNqg6GpKOdGdQ4HemNSlQcZVxOcsDe5X
         CnLDmlVVySMv3TqiPf+qc9gAtvh4Xgb7/wmGfM7Hxc0myo3lqVEOMcnYh80DWG01s6I1
         i+7SxeuQZZsT7hkiUmFRYmC4484TOHxgyIuFIJdbbim5bTD06cbOW1aeEgM2kcB0vrlF
         CupfHYEcOTiOgID2bIQ71vMAfwdPUKXs8O/3RUhea48w+GcCFHWO77myU/oHwI7HzrIN
         Iltg==
X-Gm-Message-State: APjAAAVDCxOUYofQ49mAri+XPGcx616/Q2HVMwUAqa9RirJV3fwWvu36
        Dw5GyreTS8fVPjI83a8OVOG3YurqB2Mg8sVdvOxwp87UsFcQwMI7G4ArhLnEJXXBRSosnVBvz6d
        5I03FMSeea/lR
X-Received: by 2002:a05:620a:102c:: with SMTP id a12mr25836898qkk.95.1580796117493;
        Mon, 03 Feb 2020 22:01:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwdvK3Ipy2qMCfUzq1ylzYT9IbitByfrekyORfLE2eptvuEIqJ12IuGLk9Wtkttgxshu+/I4A==
X-Received: by 2002:a05:620a:102c:: with SMTP id a12mr25836873qkk.95.1580796117247;
        Mon, 03 Feb 2020 22:01:57 -0800 (PST)
Received: from redhat.com (bzq-109-64-11-187.red.bezeqint.net. [109.64.11.187])
        by smtp.gmail.com with ESMTPSA id u24sm10612793qkm.40.2020.02.03.22.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 22:01:56 -0800 (PST)
Date:   Tue, 4 Feb 2020 01:01:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200204005306-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> 5) generate diffs of memory table and using IOMMU API to setup the dma
> mapping in this method

Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?

-- 
MST

