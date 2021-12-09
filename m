Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9854646E0ED
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 03:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhLICj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 21:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhLICj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 21:39:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4E8C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 18:35:55 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so14906776edd.3
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 18:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DX/WjP+WxAwM1uaLwhVKb1R2kcyv9DFh1kSje4L7bYM=;
        b=mvLoiyR7m0mnJT56iSdYQm9G0NMNro8Jw/DkP6SILM7ufll3g2rrwwe9vNEwdk2keM
         9ZjwImwOUvt5BgoUakkpMViG57CYxfJN4P1ki4mRpPdlG9ChhNM5fjZ06fbvJcEfKcRU
         WLSfYLtNrB5wIfwfUvG0ay73jDcVPb/3be6lKm8n4REbVAI7GA7mju4KcuBlohxwiM6o
         MlPcyENFDnRX4W8grwzUZMDZYxXc9iM6QPkuX9EMAH4OcQE48vDP3vW9ovmSwI/vkUyg
         UeWerVzWzESi7EOYRKRZYRhlt6nHbok7JBoVfwNxey9+PQyxp4zQrjLiBOeXvha4Ekra
         brnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DX/WjP+WxAwM1uaLwhVKb1R2kcyv9DFh1kSje4L7bYM=;
        b=1SUwcLgIYwBLyRGeSMWz8r1GVr0hrYKTYAIEAwkp0Tj9+3m2g0ttTr5KUbVOxTQNjG
         czlXJJ0+HolO3LE8ImCmWQkdTqx/GZA6iU4o3d61ZLeEUDwqIpEwvuu7iheLN0RPJ/55
         9SwIkCNp2awx16X6VOuHoruveeoFYexBCN5VhscuE3geDvCEp/sS326qUkOO/SfqipI6
         GsYZqX8apfr4+skv5GLZwEu5GDS9QBF9IPLQ1TGUIxXvKApPrW1OCAVZYvxCf6qf+2oQ
         cHU5vPNEvjmv4KZfrCNWsrSQOoF0uQwWWlQfzWV9908+18iagV48wP7GSDAqp3IXrQQ0
         //hQ==
X-Gm-Message-State: AOAM533igTxttrCddlLarwfBIcaBcDfKtgDnpXDe72PMsZLCwoGfgOws
        sK4s6KO+jHzOhN+5axRgTM581fieEdNSscBvnjXxCyrLjQ==
X-Google-Smtp-Source: ABdhPJyyLaIvdzkwXpNU9DT3kgXtEhX8xkS8vCGrE/6za1mWysUFfwUvfzuvk0FX/A+rTcmuOu+upvoxdOeRlEqsbjc=
X-Received: by 2002:a17:907:972a:: with SMTP id jg42mr12432313ejc.398.1639017354250;
 Wed, 08 Dec 2021 18:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20211208103307.GA3778@kili> <20211208103337.GA4047@kili>
In-Reply-To: <20211208103337.GA4047@kili>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 9 Dec 2021 10:35:43 +0800
Message-ID: <CACycT3un+oTFoOrYiegOrpRLw2RFyU0j4OBrVBhzGZJqU9Z1sA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] vdpa: check that offsets are within bounds
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 8, 2021 at 6:33 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> In this function "c->off" is a u32 and "size" is a long.  On 64bit systems
> if "c->off" is greater than "size" then "size - c->off" is a negative and
> we always return -E2BIG.  But on 32bit systems the subtraction is type
> promoted to a high positive u32 value and basically any "c->len" is
> accepted.
>
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Reported-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
