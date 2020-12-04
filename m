Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23E82CEB7A
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 10:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgLDJyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 04:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgLDJyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 04:54:40 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75F2C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 01:53:59 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so7825004ejb.1
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 01:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uv2efItsQUhEgfX7SeOo28N5gNOKYGwcTRvbk7tp5sk=;
        b=Y+yQmo30CQFiR5TTzDwrmyJatxpqtANqRpaIncgY2A8s2nWuzGUeyn1tlf4gOxugd2
         hh8E3nHhmj4zo93RilCZjKplbsTkCbNxNPF8uYID9W5PuMKVGbJigGgWD9afGHl880zK
         58XjKXOHPeMO/smMTfgANFsLPDLJ7SGTQmRGvK5+9rVbt5ynuxcXqQInlbHiTr3T4N4V
         w8Wu7TpMV552x6QPPvqgAlSK6lmA7BRml4jRWHiI63XOeYUq0EO1/mbxl22WqthPcaDm
         nfWp3DFvC6vgW0kGiJ+NqG+v0vXx7/6/rIRANPewGZH1nMCdkpAXWjUQbYAPRfIXi/R1
         CaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uv2efItsQUhEgfX7SeOo28N5gNOKYGwcTRvbk7tp5sk=;
        b=lCwdn5LXKz13tUQ0N5EsZTnTXZlOyp0lwWPFhBse2O3XLmxRzbU6WtamUUy2aNKb/H
         T5+21x9WJVNGILcU5DzSkFctmjCyU0sl0Ss7EAY4J4Qw058f4++RP5l3l9oONuaGpH9K
         OBTEBBAfnpjtF1pZS6DcniUpWRYfCe/x2zuZH8a2jB8wKH7UeKmxSeK025+01W0GO634
         trmasldW+per8BTsh7tUDJTwc/c3cBGfv1ticdLmgWW615RQAXO50sWup/1eiThRaXMb
         38oaffeqCQpOxRl0UAj6btsnsPLkZCgHWoHqtoJCuffqyabFgT5CWkjcuCniqc+NLBVC
         xDmQ==
X-Gm-Message-State: AOAM530F640WdVq5PWXjiTWo/32R7fHUted5XEs+ZHluPZKbzZ9l8QJz
        +DOLTwqwfVhVSCQMJkRP22/s3g==
X-Google-Smtp-Source: ABdhPJwXvl8nLosqnGM8eU8JP87XsB+l9fv0jbHDns3+jJMfPKJqM1nwHazVtadoe4qIEMJGSczwsg==
X-Received: by 2002:a17:906:81ca:: with SMTP id e10mr6195735ejx.449.1607075638385;
        Fri, 04 Dec 2020 01:53:58 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id k2sm2690147ejp.6.2020.12.04.01.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:53:57 -0800 (PST)
Date:   Fri, 4 Dec 2020 10:53:38 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        wangxingang <wangxingang5@huawei.com>,
        Xieyingtai <xieyingtai@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Message-ID: <20201204095338.GA1912466@myrica>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
> Hi Jean/zhangfei,
> Is it possible to have a branch with minimum required SVA/UACCE related patches
> that are already public and can be a "stable" candidate for future respin of Eric's series?
> Please share your thoughts.

By "stable" you mean a fixed branch with the latest SVA/UACCE patches
based on mainline?  The uacce-devel branches from
https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
(they track the latest sva/zip-devel branch
https://jpbrucker.net/git/linux/ which is roughly based on mainline.)

Thanks,
Jean

