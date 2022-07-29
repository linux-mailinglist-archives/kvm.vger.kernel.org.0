Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A835849F5
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 04:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiG2Cx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 22:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiG2Cx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 22:53:27 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863713D32;
        Thu, 28 Jul 2022 19:53:26 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u12so2535978qtk.0;
        Thu, 28 Jul 2022 19:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JPLI0WWwSnl4pZNOOpeBG8692rahbBSQ0znuFgYvBFg=;
        b=XaXVR+jYg2staz8aCLZqU9DmuYK80sPqSTynrBms0nahy22/otZr48Z9zu6Fy3ZkcZ
         T/uaQyWwib4ZFMB2j9e4q5EEjXqPjH5pAz6uBcXG7UURRkXa/6z3JjIQ9qYn209z0fAw
         YhpSc1DAPZqDyvc9h9VprGCqOiXJZr9qbyQrFI53Mx5FclEkYi6mTiHzsoaPIEp561al
         +EIbzKMjcQHq8e23ErwIUU+hDTS87GCiYvH2/1qQ4xcGWDHUR7DDehP9K8zzEUOrLvYq
         D8uT6XI7RyLvAN7hoTJuh7n9xSnPCW34gydyHr/uxqlKtIp4xk4zsRMxpY6/pNAH6dCK
         hktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JPLI0WWwSnl4pZNOOpeBG8692rahbBSQ0znuFgYvBFg=;
        b=qvBRrbBIKZWVbdluAJs0phU2Ul6OUOgqJ2vCP+AvIe5uVSiEzzwYnGcFmJzB4lBvMr
         pxAd0e5orBm3d3NQIIKorvM7w6mMQl14X69UezvpE5/QO2yd1rCz6D7tPg/kHqOHtE1P
         zO6A6NBIpILy4n2+tQtc0IWpbmcqwWA6RD+3OFss5275eu9LCAz2pEIcEqL8U/8gZYha
         ZF3cvrjcXSUd9xukXZ18PjhPA3halBx5L8Oa4A4crGhEKAnAtZAzc+GAikVd/vv3F0xi
         RaZGb+3GJ+sX+twdQzjZgOLSJtekrSeoyMnd5Ads7teANQ99Fds47loJeokTJ5BR9KRU
         AGYA==
X-Gm-Message-State: AJIora92G/2rU7neZrutz1Kat2h8E8uy631hQmuiJLs9KT7vnsl+nbKi
        mwlQiQUjr6zn4xcQGodO3T4e6Nbkum/GT7yDhb0=
X-Google-Smtp-Source: AGRyM1uXyM/GFYf79M1B6V4cB/eppkGvUk8CIrlhehEw6hNZFNiIz4Ghf2U/AYDYrQtEAwc7i78DK2UJy4GlCfrWvJE=
X-Received: by 2002:a05:622a:1911:b0:31e:eef1:9d5a with SMTP id
 w17-20020a05622a191100b0031eeef19d5amr1746740qtc.233.1659063206009; Thu, 28
 Jul 2022 19:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220707135552.3688927-1-aik@ozlabs.ru> <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru> <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
 <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
In-Reply-To: <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Fri, 29 Jul 2022 12:53:14 +1000
Message-ID: <CAOSf1CHxkSxGXopT=9i3N9xUmj0=13J1V_M=or23ZamucXyu7w@mail.gmail.com>
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rodel, Jorg" <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022 at 12:21 PM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> *snip*
>
> About this. If a platform has a concept of explicit DMA windows (2 or
> more), is it one domain with 2 windows or 2 domains with one window each?
>
> If it is 2 windows, iommu_domain_ops misses windows manipulation
> callbacks (I vaguely remember it being there for embedded PPC64 but
> cannot find it quickly).
>
> If it is 1 window per a domain, then can a device be attached to 2
> domains at least in theory (I suspect not)?
>
> On server POWER CPUs, each DMA window is backed by an independent IOMMU
> page table. (reminder) A window is a bus address range where devices are
> allowed to DMA to/from ;)

I've always thought of windows as being entries to a top-level "iommu
page table" for the device / domain. The fact each window is backed by
a separate IOMMU page table shouldn't really be relevant outside the
arch/platform.
