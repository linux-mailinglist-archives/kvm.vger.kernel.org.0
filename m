Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18D141FD5B
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhJBRUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 13:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbhJBRUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 13:20:22 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA7EC0613EC;
        Sat,  2 Oct 2021 10:18:36 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s69so15770512oie.13;
        Sat, 02 Oct 2021 10:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCMhrtix1SaJdraOyPsvWpY4qULx6HH4b0l2FJCif+s=;
        b=CqeIUySNilx89Gfas5OSnD5d/nqOtklsn4cge6Lnskw9WHu6z0tpXYqThb/5oqmjba
         TmuPVhxeQPz7CBFCm0iFVtyJVeVZVdp8D38lq0Y/m18U6hhjTULrhjJ6ixCYbS/EWN1N
         6UAXVMIviH5fQqLhFOGk1SqumVaA3GiDKHzoFIfWKd5nMCNesFk4igVR9Rxi7w5tF4Xq
         lBDXij3d88iEY2KpTB6ZAFXksHWFOoo3fASPl/sBKVHBoJdEDYiH7goDt0vwaFK1O+Zi
         g0Bud3wx/cht2Ov79p+dJdBITocNtyfkHS0n5MiKlRRBwaW/IOspkHAKNX9Ecxfn/f6x
         zZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCMhrtix1SaJdraOyPsvWpY4qULx6HH4b0l2FJCif+s=;
        b=ymExOmdhAOTcUBxA0/8pHdGdedxGHHcuZI/Oqif6S+VMxylDnISacZvcsPhBEi7aky
         MVD0SZss3QNueqp3JAgIZBkjpv9Mlg21HHXp3RDi8She77KOskAPOUGDS99JQdGdZK33
         +Df5fHJ+D28w4jP11aB0i1mOawhNN8y8GR1iyxvH0f4/zRi82dxvQ0W5ORgTLjS+nl6z
         VU16rHdbUP8wvXOVuWESUOFB97VvdGML0WOHPmye1M6DnigMUmgM0X4y7UcRAClntLD0
         kOiTTlcrSVbwX23u5zXInFg28diHmw5aQe1YtmcM3lMgYP+n1FhxQ7ONFsQ3JKz0Nuyf
         SeQA==
X-Gm-Message-State: AOAM531tCkEsnqpkmnQMQBIlAvTnNeoyyNODchOaKZuuLBAUNaOpYn59
        rPg9V/NRluzT82908it8AkS9G2aGv6JQlY97oACiowRv
X-Google-Smtp-Source: ABdhPJwZG5HdKsDLU1eNgRB+843KErY7M7wZ/Yvr087j5kazZZddpcsFvIfTlJuYPoieaA7sk/fHxcA8AE5VdMq6n9E=
X-Received: by 2002:aca:6009:: with SMTP id u9mr1497495oib.71.1633195116215;
 Sat, 02 Oct 2021 10:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com> <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com>
In-Reply-To: <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Sat, 2 Oct 2021 22:48:24 +0530
Message-ID: <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Lu for the reply.

>
> Isn't the domain should be switched from a default domain to an
> unmanaged domain when the device is assigned to the guest?
>
> Even you want to r-setup the same mappings, you need to un-map all
> existing mappings, right?
>

Hmm, I guess that's a (design) decision the KVM/QEMU/VFIO communities
need to take.
May be the patch could suppress the flooding till then?



Thanks and Regards,
Ajay
