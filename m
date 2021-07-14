Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4CA3C7C23
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbhGNC5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 22:57:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237436AbhGNC5O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 22:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626231263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8YuQd5Ts4JNGV6wtOAvCK5EPGDYCcnR+6g/ZGfnDJI=;
        b=BAyyWUmPNx1uQ/8+GV32/pc5x7Rumus9OvFX2Q7B90oCLYtPc44dll/3Z8x+mKKhLLZR50
        hR5Wi8i4IUDn4vg2V6DQfFOMeXfphdBlbGLSyU4mGiRjcs9gA7jgeikELD0nEgfHgRpOOP
        x+hR3SO36L31sP8e+CjakIO3APs1AuQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-wQgghPpsOQuz9uGGRSUm9w-1; Tue, 13 Jul 2021 22:54:22 -0400
X-MC-Unique: wQgghPpsOQuz9uGGRSUm9w-1
Received: by mail-pg1-f200.google.com with SMTP id i189-20020a6387c60000b0290228552e3ac7so397264pge.20
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 19:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=L8YuQd5Ts4JNGV6wtOAvCK5EPGDYCcnR+6g/ZGfnDJI=;
        b=Ui/lCWnZiSo0R9wsKNxHRXFxR7DlnUJjc4FJJJ+6lKWLDHsi1+fBS/cD9fRt0Kn+d3
         9RLR0FFwQnDee2/O9VpaT7VSJ2gBYBblXG5t1hjyOGQluNorTUYWlqDVL3BcBf7mOE1O
         UW1YUqrPBpqew+8hUsNfNuVKII5zZ5SB/VQr7/+Rxa2q9jzQgw0FOKia2BbGPWCmMXpp
         AhaSP92vC29EZBvNDe4UnxWd8HF5TRvFWmI0TyZaAsnh5AYIx3UcFJImX9euNeILX5wZ
         Hh3r1a06VKUgPbHkv1EoNdwaPKOnCHVh4pjLpdS4fJHCfN+IIm8iHGyJj7Js33j/xHNM
         oZew==
X-Gm-Message-State: AOAM533ue87LrIx4iniGw9PkgRFhYf++yEn9inAFT1ez5WsCRmar4oio
        Z4UMfCq214V+G9eMlyhlHmlcDhJLt7aUr2sw8J50jogGsL2ZyQH3F0QucI5VIh8IMSE7HKBIsnQ
        Bvf81FsSd5A4G
X-Received: by 2002:aa7:93cd:0:b029:328:9d89:a790 with SMTP id y13-20020aa793cd0000b02903289d89a790mr7769409pff.71.1626231261374;
        Tue, 13 Jul 2021 19:54:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVcvRFQIHUh/wToTzbSqcRq399rxXFtmmAr5rDXhIuYW/QN+SkST9rmMlarwJcwx/uWSDVUw==
X-Received: by 2002:aa7:93cd:0:b029:328:9d89:a790 with SMTP id y13-20020aa793cd0000b02903289d89a790mr7769384pff.71.1626231260928;
        Tue, 13 Jul 2021 19:54:20 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v11sm494452pjs.13.2021.07.13.19.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 19:54:20 -0700 (PDT)
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com> <20210713132741.GM1954@kadam>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c42979dd-331f-4af5-fda6-18d80f22be2d@redhat.com>
Date:   Wed, 14 Jul 2021 10:54:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713132741.GM1954@kadam>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/13 ÏÂÎç9:27, Dan Carpenter Ð´µÀ:
> On Tue, Jul 13, 2021 at 04:46:55PM +0800, Xie Yongji wrote:
>> +static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
>> +{
>> +	struct vduse_vdpa *vdev;
>> +	int ret;
>> +
>> +	if (dev->vdev)
>> +		return -EEXIST;
>> +
>> +	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
>> +				 &vduse_vdpa_config_ops, name, true);
>> +	if (!vdev)
>> +		return -ENOMEM;
> This should be an IS_ERR() check instead of a NULL check.


Yes.


>
> The vdpa_alloc_device() macro is doing something very complicated but
> I'm not sure what.  It calls container_of() and that looks buggy until
> you spot the BUILD_BUG_ON_ZERO() compile time assert which ensures that
> the container_of() is a no-op.
>
> Only one of the callers checks for error pointers correctly so maybe
> it's too complicated or maybe there should be better documentation.


We need better documentation for this macro and fix all the buggy callers.

Yong Ji, want to do that?

Thanks


>
> regards,
> dan carpenter
>

