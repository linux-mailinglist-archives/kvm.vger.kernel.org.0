Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6181653F471
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 05:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiFGDXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 23:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiFGDXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 23:23:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F485F8EA;
        Mon,  6 Jun 2022 20:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654572220; x=1686108220;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vzgEhhW4kNaICa/n+qlgLmF5Vog9iKUmfkdT1yy8unU=;
  b=AvvUfJNC59mEf0LR+dJI9kYlHRwUaTlynJ2FGx7omMpxLaf2wpbWGFnz
   i2uv2N8Iy/MnNUFAtGKOK+FwsaWHlfVg4yKhGZ7pldj1I/kP1CSc5waEr
   VDYg46XvRnSksS8mh3xEDiYSeI2UsUbElc1Z8pDNzD/Q25hs+LaftEQbg
   EWekYbI4vzLfTByRnjhC7w14E4/JMQzkOSLwU8gTF+gsI1L003gpdkdZC
   ZWP3UBG5HSd5hSIRUSamaybxVUqI+I6hlV+KTGr8JL1L5wRNCePCFDPHU
   iiY/SaPU6rx7nTCd6jVt+YzRS5XTxwBWzpqewtkNw1rGZgPJV77014HRa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="337906376"
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="337906376"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 20:23:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="583980445"
Received: from zwang64-mobl1.ccr.corp.intel.com (HELO [10.249.174.202]) ([10.249.174.202])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 20:23:29 -0700
Message-ID: <f81b8b8f-b811-3be2-5dda-139dc1bd7bdd@linux.intel.com>
Date:   Tue, 7 Jun 2022 11:23:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, alim.akhtar@samsung.com, dwmw2@infradead.org,
        yong.wu@mediatek.com, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
        joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        m.szyprowski@samsung.com, krzysztof.kozlowski@linaro.org,
        agross@kernel.org, bjorn.andersson@linaro.org,
        matthias.bgg@gmail.com, heiko@sntech.de, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        jean-philippe@linaro.org, alex.williamson@redhat.com
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-2-nicolinc@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220606061927.26049-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/6 14:19, Nicolin Chen wrote:
> +/**
> + * iommu_attach_group - Attach an IOMMU group to an IOMMU domain
> + * @domain: IOMMU domain to attach
> + * @dev: IOMMU group that will be attached

Nit: @group: ...

> + *
> + * Returns 0 on success and error code on failure
> + *
> + * Specifically, -EMEDIUMTYPE is returned if the domain and the group are
> + * incompatible in some way. This indicates that a caller should try another
> + * existing IOMMU domain or allocate a new one.
> + */
>   int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
>   {
>   	int ret;

Best regards,
baolu
