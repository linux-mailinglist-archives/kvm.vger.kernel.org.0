Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D90241A73
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgHKLdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 07:33:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46686 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728738AbgHKLdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 07:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597145628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GiCPzZPtpDgWrMbwVo68Gc9UUX4p+0NK8qKoCf+Lg2k=;
        b=gI/FeK23M41k5meXY2J3IjYS42tHdB/K+Q1SVuMTLjw/wOcxZKxrHCBl5TYqCEDw3L38MC
        vOvtkbvH0nJ7WoGChrB5viI0Sqm8a6EcILU1BhptpSKGVDYxRKVdGHZoKy0wL5MbqRxTLb
        0b6Duxx1rjRItchpsi4zA7l+V2aYmWk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-c6qa_V4tPzq2Kj4iK3TrtA-1; Tue, 11 Aug 2020 07:33:46 -0400
X-MC-Unique: c6qa_V4tPzq2Kj4iK3TrtA-1
Received: by mail-wr1-f72.google.com with SMTP id 5so5464057wrc.17
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 04:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GiCPzZPtpDgWrMbwVo68Gc9UUX4p+0NK8qKoCf+Lg2k=;
        b=Z2zYpVdw4p/sE7xA2bFQgq07VfJAu5Ms5gWrHavQozwMKNrHs797e7cP9ZcNYdm0Pt
         tlGgno/ro6yJiWcVeHXGNnCEVRQ/UUxjl4pFsarZh6l5SBDpP/bsQJhHNhMIDBWOU+89
         wpeEVWEKT4mpI2igWvs2+ISSPTlmxcNO5bCgTxcvc+eriVHRUFFrPNz6AkYuhe2CokHG
         6rY8xbNLd3N6DXpvCcE0WrgbyojdUMu/6J0N8zsRRO2CVk2cZ+QOAbYH28SUh/JoeOqu
         QDUWZq7+VM0gBx/TfKiD4GDBHd2rz94E3AGBYQeXN67pDuMN9lEb/WsVjhOBsCst10rY
         Jg9g==
X-Gm-Message-State: AOAM530sbGCSMtF+DkexOM57l2jwBWt5Lt67+eMWdsg7zhLuXarE53IW
        XHTZdZ/+2bHqIEewurH99RWq0i8Z9Fzkvp+mKWhSQ+nmUVKK405DoH0O2brp2qewam4VWwC9IAM
        NeyTji+nHH0VV
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr3499785wmt.94.1597145625676;
        Tue, 11 Aug 2020 04:33:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEaIvjLTJL/NIBPByzAEwifrGXrzHsoFwTXAZoU9RkSJbGkn6bslOVl7J4dDyoTVHhx7FazQ==
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr3499766wmt.94.1597145625527;
        Tue, 11 Aug 2020 04:33:45 -0700 (PDT)
Received: from redhat.com ([147.161.8.240])
        by smtp.gmail.com with ESMTPSA id 32sm27064327wrn.86.2020.08.11.04.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 04:33:44 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:33:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>
Subject: Re: VDPA Debug/Statistics
Message-ID: <20200811073144-mutt-send-email-mst@kernel.org>
References: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 11, 2020 at 11:26:20AM +0000, Eli Cohen wrote:
> Hi All
> 
> Currently, the only statistics we get for a VDPA instance comes from the virtio_net device instance. Since VDPA involves hardware acceleration, there can be quite a lot of information that can be fetched from the underlying device. Currently there is no generic method to fetch this information.
> 
> One way of doing this can be to create a the host, a net device for each VDPA instance, and use it to get this information or do some configuration. Ethtool can be used in such a case
> 
> I would like to hear what you think about this or maybe you have some other ideas to address this topic.
> 
> Thanks,
> Eli

Something I'm not sure I understand is how are vdpa instances created
on mellanox cards? There's a devlink command for that, is that right?
Can that be extended for stats?

-- 
MST

