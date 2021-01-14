Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF332F67C9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbhANRdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbhANRdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:33:15 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05E1C061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:32:34 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hs11so7039025ejc.1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oaLk6K/ziP0JrSWjUd9yUznepJpKpHz8SodeDVZyc4g=;
        b=GWCGEwBUT89R8ID7PJjuDrp5S3/2qLBz8lkSEggHBoncpJhuQX05ohgD3pibnBXJdi
         W/wjaMWx6cX60jzbnFHzbnh6eCuUIEFyAJ6ZNJbjNBuZcpAFm30vEyoFX0OX7sLCfQ4H
         VBGdlONQQCthSTN9lUkdHxVXmxa5Wwba+So89oDc3hDiAC9lD0o2w3oCuPt9V9T1dNVE
         uS3KkqkupscVrlg43emIU6KBxshTWcjcSyN7OszKlUL3h/iedyxOlz6rn4DfD9f2hWu2
         37xuugp76VAJh3BP8R1ZQyS4EExUjFJSmBGIyEyPgIeSizJ4dmyBRr0xzwBjbW8Z19+S
         31VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oaLk6K/ziP0JrSWjUd9yUznepJpKpHz8SodeDVZyc4g=;
        b=qG4g1HPTXcg5hiJOdreq1dc488mDZvLpmI8NypUydgTsSxxRQFM23vEtkSWIdLHDDe
         6KyzZOTgZGTHIiEbMhjc00EhE/xMVCnR+569UCf5P20FNFhENcGl2jZwmmDF7qdTv7qC
         OU3riqoKo9L+L3PyY8UPEzJpLOuBPrJbY+eEDpOGy0SUoXYWEbKYnF7QCsb/oiiVrqyB
         MMZNKgCJ6BgOfQY6Ms94Q91UEyEqd42mjL3iFZu1q2dkKs/tUW3SgOf97KuipfnKk1Qt
         JeVmDMC01a2f/J2WOts/ZYElSeON9spQY0T6+SuzDnmrS0l1pbGjWYUrdsU62IKd9+ot
         BlLg==
X-Gm-Message-State: AOAM531g5DQpB3uDfgPNbHG/nMnmKVH0BUt1so4vd7Vf4a1ISk5I2MBU
        o8Sekn9yZECzzx4QBQdEAKlzUQ==
X-Google-Smtp-Source: ABdhPJyWGuNgbGnfn6qKQQM5KwVrs3KxAw/sQ5/Phdx+0TwP4Nqgd8PsrwlAs/HuCHWwhAWmPewspQ==
X-Received: by 2002:a17:906:17c3:: with SMTP id u3mr5870629eje.304.1610645553317;
        Thu, 14 Jan 2021 09:32:33 -0800 (PST)
Received: from larix.localdomain ([2001:1715:4e26:a7e0:ed35:e18a:5e36:8c84])
        by smtp.gmail.com with ESMTPSA id n2sm2235623ejj.24.2021.01.14.09.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:32:32 -0800 (PST)
Date:   Thu, 14 Jan 2021 18:33:17 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Xieyingtai <xieyingtai@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        wangxingang <wangxingang5@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        qubingbing <qubingbing@hisilicon.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Message-ID: <YACAXaG+opCwDFTL@larix.localdomain>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
 <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
 <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d68b6269-ee99-9ed7-de30-867e4519d104@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Jan 14, 2021 at 05:58:27PM +0100, Auger Eric wrote:
> >>  The uacce-devel branches from
> >>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
> >>> (they track the latest sva/zip-devel branch
> >>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
> As I plan to respin shortly, please could you confirm the best branch to
> rebase on still is that one (uacce-devel from the linux-kernel-uadk git
> repo). Is it up to date? Commits seem to be quite old there.

Right I meant the uacce-devel-X branches. The uacce-devel-5.11 branch
currently has the latest patches

Thanks,
Jean
