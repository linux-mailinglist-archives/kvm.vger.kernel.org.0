Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9BF3E84D0
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhHJUy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234787AbhHJUyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PquKaDcRR+YnvRs9ZlK0t/qXSTbz8AOV/mTyg3IQF/A=;
        b=Qmzhs+g9Hy8Hg0iEUVDqquZC3SLG9Mz3+6z/XzUTpp0NOOjDAEgFm2NWhtiXmHj+X/5TMq
        jNPQCPWQVke6NUGhj5NXp/Tye5VldjXKh50bavXoMtOmICA55g4iQVNgtnUyXYLw93PwEZ
        uSE5TPPG58BYtVLB9WifFRq//PB0/GI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-lgDENOgcMzO5iB9mJhxpkA-1; Tue, 10 Aug 2021 16:54:21 -0400
X-MC-Unique: lgDENOgcMzO5iB9mJhxpkA-1
Received: by mail-qt1-f200.google.com with SMTP id m8-20020a05622a0548b029028e6910f18aso155348qtx.4
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 13:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PquKaDcRR+YnvRs9ZlK0t/qXSTbz8AOV/mTyg3IQF/A=;
        b=oGKzOSuTb08exr4wTm4VawzEC8YsDqWG7BvbpGBk0Tm1Rgbu4QRSTjGeuAyKHblQ5V
         x16PAX/Bz0pc1qd0+JPECCa5rFeYpk+p+Y+w2a8P2W7nQeW16G33GK3rQ6N2Rk8vu2eB
         5B+pFFrcXHic32lEhstXlNwrFmEUbo4M5erjXqC8rWTJpPdqI54iC6qEuZAi3Dypuywo
         QkiQjV/rHv34QB3gyFj+jCADrM+H9TbA/RqBAhvzp1EtEF0tishjR2nECxd31GIu0lT6
         rX//KYqMQTqKyraB1W/b+3K66sF20zTY5fPHSwOOhcRuiptsr1WDBTrT430nu5kwFKIv
         JbTA==
X-Gm-Message-State: AOAM532AEHx5c5TQV7HmGK96b1EVjJfd/UXGq8DW3TMMGQ6WsM7QSk1r
        wALavydChOvEhu2oV8sywePdhh/N6z6dcW21BJwyg/4fRPoxRbsx7e1KEWDbzDrhADpJjuG1Y+9
        OqraNQLKAvnu+
X-Received: by 2002:ad4:4087:: with SMTP id l7mr19752203qvp.37.1628628861321;
        Tue, 10 Aug 2021 13:54:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlooYZ0bGnYWz+gubLVP7tQocXuPUGfuPLGffaVUsAiveZD1nvQNJY3yVfdejJ0U+6prnPBg==
X-Received: by 2002:ad4:4087:: with SMTP id l7mr19752183qvp.37.1628628861100;
        Tue, 10 Aug 2021 13:54:21 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id m197sm11541159qke.54.2021.08.10.13.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 13:54:20 -0700 (PDT)
Date:   Tue, 10 Aug 2021 16:54:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] vfio/pci: Remove map-on-fault behavior
Message-ID: <YRLne7/S1euppJQr@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818330190.1511194.10498114924408843888.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <162818330190.1511194.10498114924408843888.stgit@omen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:08:21AM -0600, Alex Williamson wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 0aa542fa1e26..9aedb78a4ae3 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -128,6 +128,7 @@ struct vfio_pci_device {
>  	bool			needs_reset;
>  	bool			nointx;
>  	bool			needs_pm_restore;
> +	bool			zapped_bars;

Would it be nicer to invert the meaning of "zapped_bars" and rename it to
"memory_enabled"?  Thanks,

-- 
Peter Xu

