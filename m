Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC503310042
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 23:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBDWlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 17:41:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhBDWlc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 17:41:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612478403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBsjjTZzpZzHtjldrpCw+SVyqxdXjpA9LJZmLvdvn/s=;
        b=X1/p+359Ffxl0VY09oH7Zc/1KmYfs68Uvu+z90Pb/K9M1twzx/039w33tJ1dCug2mY5Ylj
        KHjwsbc5eG2Bzy01s99RjX6faaiaXLMG7v1JDTB1ScOcy2CaAImgBxVcv9AHZI/7iWJ2Zb
        xkTu8j5yVGUkCM6kYIEpPbR6i83eX4o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-B9z13AvKNtKDrojnFfu95Q-1; Thu, 04 Feb 2021 17:40:01 -0500
X-MC-Unique: B9z13AvKNtKDrojnFfu95Q-1
Received: by mail-wr1-f72.google.com with SMTP id p16so3763646wrx.10
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 14:40:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GBsjjTZzpZzHtjldrpCw+SVyqxdXjpA9LJZmLvdvn/s=;
        b=GTvb2WIQARyCUoj95FjFOsAJ5A2Qy1cPdDQeayg9b/xLVYS2+3bX/1jj7ctrTayW58
         z39Sdy9ICywUH0Dqie0IUHvSpHrzcPOaPl4d4hhnKS5fB2mVvXGJKGGsuNa3imVBNfl8
         xjJvVIQzuJV8OueqO9/paG+b4x10XEMVnnssAw3MkTn9JiFGEXwGBUqkbfNDqxxSnqND
         ibl32tEWdUFfJTC4KBPrpZ92mX+H66H5pRgR4YtNBWY5td6WKr7KRZpPUTjvcYKcuoVJ
         Wg5OS/q33Z8mAMa4efxDBNFBrwUo7i6yTOs2S0H2Mj4Yjhua3zv0UMyaMfpgT5yqrJQw
         ATLQ==
X-Gm-Message-State: AOAM532VDVBrDq3GuKZgGcdPPTEMnEFVF03zJglshVsVPjOvxJv1bNoC
        thrqP4DlYmNhMLAKijK5I9qkWiiPCLd05wbE7SbOACG8epDmRKS8h1Oe0XU2vtwUuclDrBnalix
        5Xgja3hn3ZpEf
X-Received: by 2002:a05:6000:12c8:: with SMTP id l8mr1574962wrx.81.1612478399886;
        Thu, 04 Feb 2021 14:39:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiACX91olwg//Ry6RmfPnaxN+GPPpFshRzxO/ndAyxdguZIlrYaq6Fu7Iphb/KQ4Lb7+60iQ==
X-Received: by 2002:a05:6000:12c8:: with SMTP id l8mr1574948wrx.81.1612478399709;
        Thu, 04 Feb 2021 14:39:59 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id d10sm9665506wrn.88.2021.02.04.14.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 14:39:59 -0800 (PST)
Date:   Thu, 4 Feb 2021 23:39:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     virtualization@lists.linux-foundation.org, kbuild-all@lists.01.org,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 08/13] vdpa: add return value to get_config/set_config
 callbacks
Message-ID: <20210204223956.3uuo7xskjpii3fvw@steredhat>
References: <20210204172230.85853-9-sgarzare@redhat.com>
 <202102050632.J7DMzsOi-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202102050632.J7DMzsOi-lkp@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 06:31:20AM +0800, kernel test robot wrote:
>Hi Stefano,
>
>I love your patch! Yet something to improve:
>
>[auto build test ERROR on vhost/linux-next]
>[also build test ERROR on linus/master v5.11-rc6 next-20210125]
>[If your patch is applied to the wrong git tree, kindly drop us a note.
>And when submitting patch, we suggest to use '--base' as documented in
>https://git-scm.com/docs/git-format-patch]
>
>url:    https://github.com/0day-ci/linux/commits/Stefano-Garzarella/vdpa-add-vdpa-simulator-for-block-device/20210205-020448
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
>config: parisc-randconfig-r005-20210204 (attached as .config)
>compiler: hppa-linux-gcc (GCC) 9.3.0
>reproduce (this is a W=1 build):
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # https://github.com/0day-ci/linux/commit/17cf2b1e6be083a27f43414cc0f2524cf81fff60
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review Stefano-Garzarella/vdpa-add-vdpa-simulator-for-block-device/20210205-020448
>        git checkout 17cf2b1e6be083a27f43414cc0f2524cf81fff60
>        # save the attached .config to linux build tree
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc
>
>If you fix the issue, kindly add following tag as appropriate
>Reported-by: kernel test robot <lkp@intel.com>
>
>All errors (new ones prefixed by >>):
>
>   drivers/vdpa/mlx5/net/mlx5_vnet.c: In function 'mlx5_vdpa_get_config':
>>> drivers/vdpa/mlx5/net/mlx5_vnet.c:1810:10: error: expected ';' before '}' token
>    1810 |  return 0
>         |          ^
>         |          ;
>    1811 | }
>         | ~


Ooops, I forgot to add mlx5_vnet.c on my .config.

Sorry for that, I'll fix in the next release and I'll build all vDPA 
related stuff.

Stefano

