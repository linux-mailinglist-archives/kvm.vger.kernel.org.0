Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603AF15C65B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 17:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbgBMP7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 10:59:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34849 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729127AbgBMP7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 10:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581609584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjESY5U+42gtKNpvEnDRTyHV+mXqJmvUAfYgrE7ny0Y=;
        b=iEuMHtMDQJGT4zIAt7kB0SgAoxppHf57ldT9HPdxkD0viABA+r+tkEXUR26GeUm2ouQMxX
        vUkUtdcFyX4wI0ATfy/TXFUoxc11eKOZpJAsUid0VKbVNl1tF78z1mQaMh5JdrbWqT7eGe
        ssShISjdGZKx/w8/nlOOL0vz229uI1U=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-X_hL0zgxNySBrA5zE5R_Fw-1; Thu, 13 Feb 2020 10:59:42 -0500
X-MC-Unique: X_hL0zgxNySBrA5zE5R_Fw-1
Received: by mail-qk1-f198.google.com with SMTP id 24so3986216qka.16
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 07:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjESY5U+42gtKNpvEnDRTyHV+mXqJmvUAfYgrE7ny0Y=;
        b=WqyUIteLBvbE3AxOif93m+ywDEgikxwbhrh8ARfvfNwOZWODHQvcx83dAw1eDJ2zGP
         MfvIhgHpo0EBxRaPqxsD+Ph1GMkQw8AoVLfjpV1hc+1gKRT5y/FWjpKp5+zvG1EkvweT
         4VylFMJsdc2aGZoRYaUCSVbN5hRvv9Or6kNEPxx8Kg1o43VnPVqoHGLyA5tcO7owvvNz
         2T/Ps7jhnMuxKwd+s7ybv75cCoQSh09fDHOKOJH4vApENKsVv/BFEWSNS7upVOZ0E5fx
         3EkS1JHSIE0WaOXxLz18/vdccDQ1FRSizmvsc8uaaY9BsMZvw2hoVVKH8JSAtAdqvV/b
         h0vQ==
X-Gm-Message-State: APjAAAUoo1vjZujzfWQph6IfH4PgrABFxXQzJAiE3yAOAIfYsyqAqBUR
        HogxTVIAAwTwgE75YbOTu7Xsqh3eWIXz3wU1yzV7jkqoDiguPp2oOCAFXOeGfNRC2454MJKJezR
        nTYTko/e5TB60
X-Received: by 2002:a37:648c:: with SMTP id y134mr12655819qkb.112.1581609582442;
        Thu, 13 Feb 2020 07:59:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwblUv4o0toVmVYl/HEAfrRzni+p8oGrxwrOCdC64VBDuyyCDEhJs814GPsgJHzOlkKNS9BGQ==
X-Received: by 2002:a37:648c:: with SMTP id y134mr12655792qkb.112.1581609582252;
        Thu, 13 Feb 2020 07:59:42 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id b7sm1490925qka.67.2020.02.13.07.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:59:41 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:59:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200213105743-mutt-send-email-mst@kernel.org>
References: <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213155154.GX4271@mellanox.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
> The 'class' is supposed to provide all the library functions to remove
> this duplication. Instead of plugging the HW driver in via some bus
> scheme every subsystem has its own 'ops' that the HW driver provides
> to the subsystem's class via subsystem_register()

Hmm I'm not familiar with subsystem_register. A grep didn't find it
in the kernel either ...

-- 
MST

