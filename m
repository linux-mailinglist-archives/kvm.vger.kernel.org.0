Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675F3B697B
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 22:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhF1UM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 16:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233112AbhF1UMZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 16:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624910998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GcUi3W4j9bCnAK214Ds5fcL7OghjM76ZAY3mDl17NWE=;
        b=KNogKfXcS/gVYIHoV9f9x2WpdTqBSDbbQbebDN0ECvlQSwWbnqLvnizQBTHIHQEMQAZoga
        2yzxlCWSmqVoOZRTsUC3z0aVv3wvHborXt/F8L7ywyGMX3LM+dS+qz4TstwQOSh58lW6bC
        thJyTG3ldzRnadQnV3ARj8504/STjFc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-FQVhjGFnNAawEpHy67q0yQ-1; Mon, 28 Jun 2021 16:09:57 -0400
X-MC-Unique: FQVhjGFnNAawEpHy67q0yQ-1
Received: by mail-oi1-f199.google.com with SMTP id q31-20020a056808201fb02902242061b668so9500668oiw.8
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 13:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GcUi3W4j9bCnAK214Ds5fcL7OghjM76ZAY3mDl17NWE=;
        b=cKTnynlrLgrYZ+pf6DOiKFv3FiHjWNchCrIQBvfKPU4bZUJs2B9nporDqZhgPUdwOq
         TFfZ6S6PRwCZGCRjeH1mhDuo8ZuKUU8YBYGPbvs9tEhVhzY0hvrwVPIXp0+N5eZ1vXYV
         Z+e/76Z4c7rKxpxS/FreenKB8s9rkohdvE3dad8hiSXHtuv417cfsSyIlDBn4av5qccy
         062bLedQaEqTZL3YNiCmogK63IN+0uuYP6Qouf150IdhIcDX5MIZ1QG2C8q+VXeD0g5G
         L51qU8FCKO+skXS41gjLIjNofdTrXiSslJz06PXp6LVD+y+t/VopH3V/U3LXhQlOHhM/
         fo5Q==
X-Gm-Message-State: AOAM531fB3hsKWiW4dYxtUvEHMVZZZPXN475lE05AhDmMmObgXT51Cpv
        4cj3u4QF17359wVq97dBUHDvBmeqYo7qov3lis8PqPyCF1VKCIu5yi49g8AZL/s8AnPyySmAX/x
        wvRmDSchY6HhM
X-Received: by 2002:a9d:2eb:: with SMTP id 98mr1117112otl.297.1624910996800;
        Mon, 28 Jun 2021 13:09:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxvgkuJCkP8FaMaWBqXZ3yhxO6gzSOe/UIQ9vZvArYTVkEENW1WrRNMhzfo7YDVfxnVPh6pg==
X-Received: by 2002:a9d:2eb:: with SMTP id 98mr1117096otl.297.1624910996562;
        Mon, 28 Jun 2021 13:09:56 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o24sm3636373otp.13.2021.06.28.13.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 13:09:56 -0700 (PDT)
Date:   Mon, 28 Jun 2021 14:09:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
Message-ID: <20210628140955.17e770ec.alex.williamson@redhat.com>
In-Reply-To: <641a865f-a45b-10ed-8287-3759191a9686@nvidia.com>
References: <162465624894.3338367.12935940647049917981.stgit@omen>
        <ee949a98-6998-2032-eb17-00ef8b8d911c@nvidia.com>
        <20210628125602.5b07388e.alex.williamson@redhat.com>
        <641a865f-a45b-10ed-8287-3759191a9686@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Jun 2021 01:22:00 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 6/29/2021 12:26 AM, Alex Williamson wrote:
> > On Mon, 28 Jun 2021 23:19:54 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 6/26/2021 2:56 AM, Alex Williamson wrote:  
> >>> The sample mtty mdev driver doesn't actually enforce the number of
> >>> device instances it claims are available.  Implement this properly.
> >>>
> >>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>> ---
> >>>
> >>> Applies to vfio next branch + Jason's atomic conversion
> >>>      
> >>
> >>
> >> Does this need to be on top of Jason's patch?  
> > 
> > Yes, see immediately above.
> >   
> >> Patch to use mdev_used_ports is reverted here, can it be changed from
> >> mdev_devices_list to mdev_avail_ports atomic variable?  
> > 
> > It doesn't revert Jason's change, it builds on it.  The patches could
> > we squashed, but there's no bug in Jason's patch that we're trying to
> > avoid exposing, so I don't see why we'd do that.
> >  
> 
> 'Squashed' is the correct word that 'revert', my bad.
> 
> >> Change here to use atomic variable looks good to me.
> >>
> >> Reviewed by: Kirti Wankhede <kwankhede@nvidia.com>  
> > 
> > Thanks!  It was Jason's patch[1] that converted to use an atomic
> > though, so I'm slightly confused if this R-b is for the patch below,
> > Jason's patch, or both.  Thanks,  
> 
> I liked 'mdev_avail_ports' approach than 'mdev_used_ports' approach 
> here. This R-b is for below patch.

Got it, added.  Thanks Kirti!

