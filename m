Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380475E62C0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiIVMs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiIVMsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:48:54 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C28AE9F8
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:48:53 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id s18so6162650qtx.6
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=34Lt9N/BUGs8UWJJrJ6DB/Oxlm/vtVQqUvzqZywz8rI=;
        b=JLliEzbtm0npO7auHsY+RSIAtWoqy6ycPInR4mHir4amjBZa5jB43WRU0WU6FSPJax
         ntu8FP7TnqYgud2l5gEs7M+a6RXLYgeqzNUjaje2qPU/yaOTh6RNK+bmPeUI3Hs5lQZ+
         C6baKWntpUoGxK9E0ilffPoh3Qx3Qxcaf5IkXY97vJa3J6tbs+uuKoPtWMPu32wMaFMX
         9VP1XOGkWOSS/C7JAN+0TU+Rv0jwryHkFTZnVDQ6tpOhoBm6kJpzIbjBkbPob/6vhGLt
         w5ztwOLSaXwBwsdP7FELM+aAOF+Znx0zPM9hyHphbM9b83gh6XTM0Je/r20HoM+nlUbh
         TCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=34Lt9N/BUGs8UWJJrJ6DB/Oxlm/vtVQqUvzqZywz8rI=;
        b=qr2E4ed0WMoA7PjmezkY+SVhwpO2YbsIh9AzoqyxBpz8t21uSSh6TOdOaU6C6AgDUY
         35i3OMkZh1hdWcFldAZ6Cb2XizuWoVs7Uru9VcL7guE36B+SHxBPhqO/N+NuCvIQuI2F
         uP6IJDRWx1/2EWu2IHTVOEk0t24VObrbiXXlGMXF+Eo+DmYT4MrUb6kjPJTK9k1FqXUp
         S8hoexXEyRAhDZnw9tvEfUgssNialVMSxP4FCTgfEtmV/XcBGn+4ogGXW9aECKTDPgWy
         KSDtWBo8w3O2PZ8YvxA+YYTaPnmYOBSsuuZYxVCjzKb2M3QGyMnl9RwaKM21EHzy/FK5
         ihTQ==
X-Gm-Message-State: ACrzQf1YeBWfTFXR0eMoA/Jd2IIvNr6QfCRrbjRhS+rPzzfMn6VNDKeZ
        FiJtBrTNa4/VW8HuzMkjBtklFA==
X-Google-Smtp-Source: AMsMyM5WoXnQFApz2AOuLoZvyp4ocmFpHtZWwh/nlwH8cRlJ75Wneyht/DyjsGJfcgfFZaCvEf+9ow==
X-Received: by 2002:a05:622a:44c:b0:343:7b8e:2cb with SMTP id o12-20020a05622a044c00b003437b8e02cbmr2464192qtx.617.1663850932576;
        Thu, 22 Sep 2022 05:48:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q14-20020a37f70e000000b006bba46e5eeasm3505579qkj.37.2022.09.22.05.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 05:48:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1obLdK-001fq3-VA;
        Thu, 22 Sep 2022 09:48:50 -0300
Date:   Thu, 22 Sep 2022 09:48:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver() macro
Message-ID: <YyxZsonrThrjAYyv@ziepe.ca>
References: <20220922123507.11222-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922123507.11222-1-shangxiaojing@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 08:35:07PM +0800, Shang XiaoJing wrote:
> Since pci provides the helper macro module_pci_driver(), we may replace
> the module_init/exit with it.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
