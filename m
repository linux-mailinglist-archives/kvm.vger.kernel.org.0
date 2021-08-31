Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A7B3FC3EB
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhHaHop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 03:44:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239924AbhHaHon (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 03:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630395828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=15PBX2yOi5tPLhGBJ3hiEPEVIZyqqoOP2n8un1ckZwc=;
        b=NTxeDboHtUyA5zz9rNEldp0N0mFM4clGLlRilp7JFegTKP8BJw8DcupZ3xqWQtOTXgLWau
        gBA2Ag/Pse/2WPbLKVmE4IYd0fxiOMBAlhjqKzWHdzR3DJwAJhX2qTFvnrc6CfkMNfYoXT
        evLm7rWSW15nkgvIFNF2sHb5DukhlqU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-GheH4XZpPOmkJfK-gQEhgg-1; Tue, 31 Aug 2021 03:43:45 -0400
X-MC-Unique: GheH4XZpPOmkJfK-gQEhgg-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402270a00b003c8adc4d40cso5672873edd.15
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 00:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15PBX2yOi5tPLhGBJ3hiEPEVIZyqqoOP2n8un1ckZwc=;
        b=oCmxHfQgNEUc05B0eQgAfTsiFEs/JJ8aFrXRuhdy/gTMYoAouWY6pr83aX14TkXWvL
         9LiNbJkPvD/3xjtVrPBPpx2QIwWWDare72REyNGDlXA2DMwC1YT4JRX5PC6s9OKBeu9n
         ny0W8rMxGTr2bQHYW9ye1eVAbu6DPvHnKJpcT+7cYzQkX0p0f/1/bqMrALdlFGSkavUA
         bBYBiNG+b254BbQkuMIHg1y6cg9w81dkoYCeMCASKQean0wDf6zlrfmJch52q5MiPUIX
         gFweDEvElrInP5HJxYFAnmiucKsFDUIsjqtb//r72ACz4qih84dwYIupDaX7MlY0vBZF
         jGSg==
X-Gm-Message-State: AOAM5323WH671ztjkssPf2uYijSHXOjlouFfjTtRCVZc3J0vhErHtbiQ
        EfrnLj3j31z4nEchadb1N8nBQKZeuwIZPlzCGqzA/lkvmvxxSputc/kdfU/qySAT+CGVbkurGIJ
        sQDemFWcfPk+O
X-Received: by 2002:a17:906:a01:: with SMTP id w1mr29482763ejf.117.1630395824701;
        Tue, 31 Aug 2021 00:43:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7MtdjI8o1VZXCbnzLBNcGiS8PwS9GtflTAom1HaHa12cMI48iDS7D5rGq8eKSV0deHgXKoQ==
X-Received: by 2002:a17:906:a01:: with SMTP id w1mr29482749ejf.117.1630395824465;
        Tue, 31 Aug 2021 00:43:44 -0700 (PDT)
Received: from steredhat (host-79-51-186-21.retail.telecomitalia.it. [79.51.186.21])
        by smtp.gmail.com with ESMTPSA id u4sm3176037ejc.19.2021.08.31.00.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 00:43:44 -0700 (PDT)
Date:   Tue, 31 Aug 2021 09:43:41 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v3 2/7] nitro_enclaves: Update documentation for Arm64
 support
Message-ID: <20210831074341.e74quljmvp36gy5a@steredhat>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-3-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:25PM +0300, Andra Paraschiv wrote:
>Add references for hugepages and booting steps for Arm64.
>
>Include info about the current supported architectures for the
>NE kernel driver.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
>Changelog
>
>v1 -> v2
>
>* Add information about supported architectures for the NE kernel
>driver.
>
>v2 -> v3
>
>* Move changelog after the "---" line.
>---
> Documentation/virt/ne_overview.rst | 21 +++++++++++++--------
> 1 file changed, 13 insertions(+), 8 deletions(-)

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

