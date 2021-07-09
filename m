Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0622D3C1D82
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 04:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhGICcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 22:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhGICcc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 22:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625797789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jC8ebqLDwty//t4KfVA7RFoJa+JDs1zz/7ayauIgC5s=;
        b=T2dZn3qqtixeMaAy9fnk6V/vRgwfEGGCntCSTFc1K1+rluxWA88zsW5MNUwXvo873ngYDt
        gS0HKuAT9OkYe0WkeuGmdTLlGLnspsI09t8SH3iO7kaRjEUYkAEtNcEzTltSpxaO52l8Sd
        WvSAT1RQ9bXXbRoO4rh1mWW0eWs0jtI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-gmMOhLSCPKqz9C4cGMJjpQ-1; Thu, 08 Jul 2021 22:29:48 -0400
X-MC-Unique: gmMOhLSCPKqz9C4cGMJjpQ-1
Received: by mail-pg1-f197.google.com with SMTP id o15-20020a655bcf0000b029022c1a9c33b7so5941509pgr.18
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 19:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jC8ebqLDwty//t4KfVA7RFoJa+JDs1zz/7ayauIgC5s=;
        b=sa77lgT7mVMsXqp5LAdd36pmMGzeopCykzJoYHHGQgasYVwoYRzE4ywwQXv9oQXCo1
         3nSE7Ks3qf5lvauAs5t5yUA3oCd/HPvTNzG2kxqCBQyBIhl/0nnKFM1Uia9yHQ1KaI+2
         TI6mzQbu89dhtBSbqZ5BCTLk6eX5vSr1D4SdNYt8YTIcPZ1XrA1aP8zewtXOGYf9lqzw
         GXWc8wt54aTx3tmJLmeyk2+d4iaNo5419faDGIWV2YXHg8ksCTC6vshG2h1Po1B9U+OB
         NRvSm/av4PvTzK9P4XFCDI4+O3UolEaSU2nMFTQUGjHoqTeI72qgzpFsQ8gSDJ08iz5/
         ii4w==
X-Gm-Message-State: AOAM531ozBS4XBWfNi4cCYGPr8tNVDHqmDPufRkUSmx3VMumtIlRHTN4
        jHle5GfeM8kGOOFd8vaCiuXQI+ucY/l87794OQk6ocLoxSmUyL06oCDJb1hSmRntIX32Dnz3TFZ
        h9xUD+54C0v7910D1osQ7jYsT6+J0d9hZE6p0C7prvh4+RHyJaxxGQm9YTyqa33Lm
X-Received: by 2002:a62:1708:0:b029:31b:113f:174a with SMTP id 8-20020a6217080000b029031b113f174amr30557499pfx.68.1625797787008;
        Thu, 08 Jul 2021 19:29:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcSNDEpisA7AaUQv65sNC7SSxSvR5Hd5rr7dX1Ad3A6kno6Tgb6OvZoPwEHv5RC/WjWhzHRg==
X-Received: by 2002:a62:1708:0:b029:31b:113f:174a with SMTP id 8-20020a6217080000b029031b113f174amr30557471pfx.68.1625797786688;
        Thu, 08 Jul 2021 19:29:46 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v6sm4947769pgk.33.2021.07.08.19.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 19:29:46 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] vDPA/ifcvf: introduce get_dev_type() which returns
 virtio dev id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210706023649.23360-1-lingshan.zhu@intel.com>
 <20210706023649.23360-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <abe284e0-7f0a-2cca-04ad-ef69fa1cc1d7@redhat.com>
Date:   Fri, 9 Jul 2021 10:29:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706023649.23360-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/6 ÉÏÎç10:36, Zhu Lingshan Ð´µÀ:
> This commit introduces a new function get_dev_type() which returns
> the virtio device id of a device, to avoid duplicated code.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 34 ++++++++++++++++++++-------------
>   1 file changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index bc1d59f316d1..5f70ab1283a0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -442,6 +442,26 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>   };
>   
> +static u32 get_dev_type(struct pci_dev *pdev)
> +{
> +	u32 dev_type;
> +
> +	/* This drirver drives both modern virtio devices and transitional
> +	 * devices in modern mode.
> +	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
> +	 * so legacy devices and transitional devices in legacy
> +	 * mode will not work for vDPA, this driver will not
> +	 * drive devices with legacy interface.
> +	 */
> +
> +	if (pdev->device < 0x1040)
> +		dev_type =  pdev->subsystem_device;
> +	else
> +		dev_type =  pdev->device - 0x1040;
> +
> +	return dev_type;
> +}
> +
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   {
>   	struct device *dev = &pdev->dev;
> @@ -486,19 +506,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	pci_set_drvdata(pdev, adapter);
>   
>   	vf = &adapter->vf;
> -
> -	/* This drirver drives both modern virtio devices and transitional
> -	 * devices in modern mode.
> -	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
> -	 * so legacy devices and transitional devices in legacy
> -	 * mode will not work for vDPA, this driver will not
> -	 * drive devices with legacy interface.
> -	 */
> -	if (pdev->device < 0x1040)
> -		vf->dev_type =  pdev->subsystem_device;
> -	else
> -		vf->dev_type =  pdev->device - 0x1040;
> -
> +	vf->dev_type = get_dev_type(pdev);
>   	vf->base = pcim_iomap_table(pdev);
>   
>   	adapter->pdev = pdev;

