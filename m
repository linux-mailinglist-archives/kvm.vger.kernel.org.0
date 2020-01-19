Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4152E141D36
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 10:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgASJ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 04:59:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726452AbgASJ7d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jan 2020 04:59:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579427971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RBsez8nF60syx6uO6vVLgbM1Sl7Se03CnUJjUyZLN0=;
        b=LtKSH9DOyfw8EF9G03ARlTHQMwKRbs3PRTcM/l2nmUGBH0OerN4r/ouxzYU/Ia9fbotOg2
        sZtOfJj61KdOZ5yditstL8k3awVCa7ow9npCy//qo+Qm9zCiaQkj30Q/2VKQ9j0UzL/H3m
        xF7DSLdCp0qdq9mP2RcNOryKkWmW1Uw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-YKLZszD5Mv-bkfuMkQLPJQ-1; Sun, 19 Jan 2020 04:59:30 -0500
X-MC-Unique: YKLZszD5Mv-bkfuMkQLPJQ-1
Received: by mail-qk1-f199.google.com with SMTP id x127so18537849qkb.0
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 01:59:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RBsez8nF60syx6uO6vVLgbM1Sl7Se03CnUJjUyZLN0=;
        b=SU1wyxKjmazSf/8o4uHl/sb1ZyeaXsCjCvNdw7+ZXTpJzq0NelCMotERs3hriLa3dF
         5zfhJU1xr5O+d63KOnf92e0ku3yCB0L4zJRquoJgq9UFqFYwPeaLxmsvpuhII696yqLP
         JMCAnxdV5Q633AVnFy8vRHqmHHi1OOA01Y7AMVW1ySw3DjCfiftQ7FfJR+6UeVkt3wft
         IHu08/iEawvOkBJa91CLUZFVjLUQwY+/3JNPhg5hX+eY1gZnDE0p8PjtFIKDcAf5AxVT
         22Ur/18SMckvxpA9/yXhXbiqJiwlG25Qic41XXuFUTgybSiAP7eF8dxcZVWQTutvRXMS
         X7OQ==
X-Gm-Message-State: APjAAAXzDY9OFFledIPEZDDxtl0teFuUnwSEhUEdnn+cql2IALe3Gjuc
        S1Em6+W/ig72x/GGjoa/tAPv116YKpp5pNz3SyPhaqdvjlYVSnM0X85ECw+NQ66p18PDapYHAXT
        O56XfWzMEJ8GG
X-Received: by 2002:a05:620a:166a:: with SMTP id d10mr45426256qko.37.1579427970353;
        Sun, 19 Jan 2020 01:59:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQHb/giklfzhDUxPQigzeGmKW4ihwH4cIVdw4qNSRvx+9dDqW3AslJF469jKiTK5R9qVYMmg==
X-Received: by 2002:a05:620a:166a:: with SMTP id d10mr45426237qko.37.1579427970157;
        Sun, 19 Jan 2020 01:59:30 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id h1sm16162903qte.42.2020.01.19.01.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 01:59:28 -0800 (PST)
Date:   Sun, 19 Jan 2020 04:59:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shahaf Shuler <shahafs@mellanox.com>
Cc:     Rob Miller <rob.miller@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200119045849-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 19, 2020 at 09:07:09AM +0000, Shahaf Shuler wrote:
> >Technically, we can keep the incremental API 
> >here and let the vendor vDPA drivers to record the full mapping 
> >internally which may slightly increase the complexity of vendor driver. 
> 
> What will be the trigger for the driver to know it received the last mapping on this series and it can now push it to the on-chip IOMMU?

Some kind of invalidate API?

-- 
MST

