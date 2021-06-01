Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192FA397534
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhFAOQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 10:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhFAOQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 10:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622556868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KpiWH2OF1AIjpHGMXBLG1eY5FgHukExavmmxWGJkjnQ=;
        b=XFdRstnBjTlGk82H16xoh/fWyDeNfMLSNgHFOvsB3v3C3tas4mCjSdMouuxGelY0RbscVo
        b4flUpvlGgyTGO4UA13m0XCISlRFQaH0+JVd48KqNBg+BpmqDLwxs2wVQXwSh6miv14XHI
        n6OXf8P9yGks0E0+IXlHN72JiKuDFCE=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-aAciphlvM2GOjNMHlYbHZQ-1; Tue, 01 Jun 2021 10:14:27 -0400
X-MC-Unique: aAciphlvM2GOjNMHlYbHZQ-1
Received: by mail-ot1-f70.google.com with SMTP id r22-20020a0568301216b029031135dd0858so8759308otp.22
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 07:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KpiWH2OF1AIjpHGMXBLG1eY5FgHukExavmmxWGJkjnQ=;
        b=BFNOZNxC7n9phDrLaKTg+Mr10moT5ydingGcVKn/9jIGARn/pFXE0/QImJxdXg2mjI
         lL9icFtTGWlkw20FxzFQJ4ZONQTbsm053JA38OOxZEGWGLxh8wX7Twgr+/9SZl+2ecDz
         kklVOX4wTTGYZF8IBWvadjyjU4HL02t5wb8vcMViXgey/sqJ01Qg05gZ7UUWa2x146Rj
         2HY1rvizhK2l6+SFUKJXoSudDd88+YJBw3Ml8akMJcAqfBvkyGu6OkEc0EhIiW/awZvj
         Afzxmey4UlkyHpMEKMR0LCIjlf7cdZLWPEZo949hhPYADDBvRPcQ/o+7bESxWZ66cK0X
         mQxA==
X-Gm-Message-State: AOAM531/x8F4nXd1qBQeKrr5gEFtXCbRzj34JI4Yc30wtiIDIxRmVP6B
        Qe3N1zsE3BNPayQNxW7Olg/yDistA0UglIsYYCRKGIz58pLrQHqhQIQ1HM1+AK7KZyrTgw8Fgqd
        NqIbbOlIuDwbk
X-Received: by 2002:a9d:6756:: with SMTP id w22mr9616041otm.369.1622556866639;
        Tue, 01 Jun 2021 07:14:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypX5OsdgNqG/xhEKJRirJFbF8Kz/olgrue4ZioE6i9lq13z56SQDOo8JHl9jrBJLQT6BsJcQ==
X-Received: by 2002:a9d:6756:: with SMTP id w22mr9616027otm.369.1622556866443;
        Tue, 01 Jun 2021 07:14:26 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a7sm188619oos.45.2021.06.01.07.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:14:25 -0700 (PDT)
Date:   Tue, 1 Jun 2021 08:14:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thanos Makatos <thanos.makatos@nutanix.com>
Cc:     "vfio-users@redhat.com" <vfio-users@redhat.com>,
        John Levon <john.levon@nutanix.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: semantics of VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
Message-ID: <20210601081423.47689d7a.alex.williamson@redhat.com>
In-Reply-To: <CH0PR02MB7898402DC183E37BF74FF8868B3E9@CH0PR02MB7898.namprd02.prod.outlook.com>
References: <CH0PR02MB7898402DC183E37BF74FF8868B3E9@CH0PR02MB7898.namprd02.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Jun 2021 13:48:22 +0000
Thanos Makatos <thanos.makatos@nutanix.com> wrote:

> (sending here as I can't find a relevant list in
> http://vger.kernel.org/vger-lists.html)

$ ./scripts/get_maintainer.pl include/uapi/linux/vfio.h 
Alex Williamson <alex.williamson@redhat.com> (maintainer:VFIO DRIVER)
Cornelia Huck <cohuck@redhat.com> (reviewer:VFIO DRIVER)
kvm@vger.kernel.org (open list:VFIO DRIVER)
linux-kernel@vger.kernel.org (open list)

> I'm trying to understand the semantics of
> VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP. My (very rough) understanding
> so far is that once a page gets pinned then it's considered dirty and
> if the page is still pinned then it remains dirty even after we're
> done serving VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP. Is my
> understanding correct?

This is the current type1 implementation, but the semantics only
require that a page is reported dirty if it's actually been written.
Without support for tracking DMA writes, we assume that any page
accessible to the device is constantly dirty.  This will be refined
over time as software and hardware support improves, but we currently
error on the side of assuming all pinned pages are always dirty.
Thanks,

Alex

