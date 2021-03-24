Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF99347408
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 09:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhCXI5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbhCXI5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 04:57:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75BEC0613DF
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 01:57:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kt15so22065914ejb.12
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 01:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bGrFoUWO78DHinCnOm8Cd58bA9eS8nD5CEjgHc47CWU=;
        b=xkodvHDrCcm1mswly1za4QGf6ZYnOgQE5f2au/oESMx8I5h2ptJirNaU0N1uFCDLxE
         e0BNzu7HuM/ULiCLPYp76cMv3qtgpd3RgyVcP6sABo8hVer4WQHhq7spzcrjK6etWmI+
         KqPmMymhqALvhT5mQgHHVySBkZ8GCjT9yMsA6PsPIGc4csqsTNrPEEvItlctaD1of15B
         k0NeSlSpm2mAUYeoie9NR1PAK0wxuuLaK7bzAW3WrpXPfvpaHm1Eg7+JDDxseYG6hjVh
         4jL3ifJ2S3VxMTJIS4uem4cC9e7gaOiVGYtsFCCtnukKZlol9aIAnE6nsYIjG/sfjgxM
         lc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bGrFoUWO78DHinCnOm8Cd58bA9eS8nD5CEjgHc47CWU=;
        b=cLxEcUvaS+KWk60i44jSfArg72/VKPzvBmUpC7/INosj/q1PD6//i0qvTk6NBSizoA
         bAciC1RvSv+AiYHPTF4qPQTPk2SlMQamRXQLHIc5Hn/n4pQbdS2CgcdoGTiPDpq4ulXd
         8WUkTCha9G3TOr6mmPUvnmSRg8y4LcbDjJgp/NdJga4P2huSO3dft7Ss914uc77GSkag
         /QWxhs6ZxuTgPj35DatAjCHQkvNLB0UOsO0fdEpGVj1BlsH43OooI1f6FX4BPTRvPjek
         K17jnTvzPtp2iKdIg+cAF0ho8IdfirPAT9DFXNPkMBmwvRnaOJLcyCwCt+XuuEuFsTCr
         W/yg==
X-Gm-Message-State: AOAM531qOqzTKTrFp6WMAf+r/E7tqFLoT+zpXMUab5vFkR4fkduqL8oH
        DhEc2KmIX7F5pu9/jXetcDQqBn8ro8c7RyLMo/lm
X-Google-Smtp-Source: ABdhPJy1amFIC8PhAf53lebi6UrN3nLJlRvNr8nkHWtZ1LH1vCCA+ReclSL3bXScIhTgASF5pFEXwnHMDawdZcwejYQ=
X-Received: by 2002:a17:907:a042:: with SMTP id gz2mr2474707ejc.174.1616576229395;
 Wed, 24 Mar 2021 01:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-11-xieyongji@bytedance.com>
 <9a2835b1-1f0e-5646-6c77-524e6ccdc613@redhat.com>
In-Reply-To: <9a2835b1-1f0e-5646-6c77-524e6ccdc613@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 24 Mar 2021 16:56:58 +0800
Message-ID: <CACycT3uosBGNwTEaW7h8GdDvHjoXWR1Se_kszQJ5Vubjp5C8MA@mail.gmail.com>
Subject: Re: Re: [PATCH v5 10/11] vduse: Add config interrupt support
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:45 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=93=
:
> > This patch introduces a new ioctl VDUSE_INJECT_CONFIG_IRQ
> > to support injecting config interrupt.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>
>
> I suggest to squash this into path 9.
>

Will do it in v6.

Thanks,
Yongji
