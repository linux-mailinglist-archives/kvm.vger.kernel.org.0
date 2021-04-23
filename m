Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED66369296
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 15:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242532AbhDWNBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 09:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhDWNBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 09:01:45 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A99C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 06:01:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d21so37278370edv.9
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2rHamcAk69i1heErTD043nvHWdBaYcGMYqk0SxlLX3w=;
        b=AI4OF1eHAcLvyWD6iouxBu3wzPXbE7lqxD/nvUDlUK6sCGPvqEiURU18cQsgP60E9B
         79XpQibjTf/FlzQDqoN1m5Xox0apvDhFykYVGLADrOrtndSOh4jcTHehoSL6CP5+tm3A
         K0hA7VUPU7KcWWquu+KenypCJDq2PzLWPT13f3BEr3icJCOt6wvTHM2Vbdp3dw0p4ELx
         dJMs/UerJVfhV13oS+6JAVOptYzHzjOwPt3NZPtEdroHfd5ogVdtz78kjCWB/KMlKxrO
         UeVaHJ8m1HYcZ0RhK4C8RpAYQU5X1LCldsFsS/aQlKYGbqWoMuPE27tWoUwBkuhT49t9
         nruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2rHamcAk69i1heErTD043nvHWdBaYcGMYqk0SxlLX3w=;
        b=L728nheYZxPJ3O+erDutFxcdZXXZ6VjUMukGKLTi+xcEgQo7XOI2kfiNZ9LZIwdPUZ
         63C/GooxYsWZZHfLKIeZJyqLZKMOVUlunRSmi8mvQ7j4d5gd5mgrVx8yrOLcrjqTKv+x
         v6P0dRC+R0QCPISl+Vyj3Lm078Yaud5GP2Yq6Gdm10b2l1KO184+QKjyuLyWryOtoiba
         s4/hv4RuKTAGM15rx0eCMPDuY22L8zMGGGalAeNSHwzramf2+EnbfFKqrtI0Zfapmp7d
         b3n8/57QIVUsOAPvjDf2DmVsiRWAsdMBFGFe85vD1yP7u+Tg1BhnEIIkt3w4fU/0EaQT
         73Dw==
X-Gm-Message-State: AOAM530n5TGpHtKUN0JjEPwV3gDloJ/Sx4ybbo4sQVwDrdfEnMHrTaOP
        ir6P/luMnDk5APreCK3kY4kb8g==
X-Google-Smtp-Source: ABdhPJyDrw4UO6yanfUyRpsU9b8VpZWr1Al+SSF6+YcbsniqaahON/TAvV32FxXYlw+iumrp6+ExVg==
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr4292611edw.118.1619182867214;
        Fri, 23 Apr 2021 06:01:07 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id d14sm4537418edc.11.2021.04.23.06.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 06:01:06 -0700 (PDT)
Date:   Fri, 23 Apr 2021 15:00:48 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Sumit Gupta <sumitg@nvidia.com>
Cc:     eric.auger@redhat.com, alex.williamson@redhat.com,
        eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        jiangkunkun@huawei.com, joro@8bytes.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        lushenming@huawei.com, maz@kernel.org, robin.murphy@arm.com,
        tn@semihalf.com, vivek.gautam@arm.com, vsethi@nvidia.com,
        wangxingang5@huawei.com, will@kernel.org, zhangfei.gao@linaro.org,
        zhukeqian1@huawei.com, vdumpa@nvidia.com
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Message-ID: <YILFAJ50aqvkQaT/@myrica>
References: <f99d8af1-425b-f1d5-83db-20e32b856143@redhat.com>
 <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619103878-6664-1-git-send-email-sumitg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sumit,

On Thu, Apr 22, 2021 at 08:34:38PM +0530, Sumit Gupta wrote:
> Had to revert patch "mm: notify remote TLBs when dirtying a PTE".

Did that patch cause any issue, or is it just not needed on your system?
It fixes an hypothetical problem with the way ATS is implemented. Maybe I
actually observed it on an old software model, I don't remember. Either
way it's unlikely to go upstream but I'd like to know if I should drop it
from my tree.

Thanks,
Jean
