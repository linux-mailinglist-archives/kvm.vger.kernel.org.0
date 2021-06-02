Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545253984EE
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFBJIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 05:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhFBJI1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 05:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622624804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SKDhNmHqN2aKK0+XSIC4OXwk6NfJlgx4QyzKzOMn5g=;
        b=LihfZ3YVSxod1cNLQ5LhSyAD3NzgmK/hIsNkws4+8my5qz7rSZthyuvSkzg9o43b8qhvnu
        UeWbO7/PT5lvH+tczElj7uuSEOZOQULHzMqNG95tSJyufM5j/R/PRhM/wPHEyG35lDcKka
        aoL0joV2K+fhrj0gTu8oq5xak8rvb6o=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-9NcSkFfNN26fpckIKGoNTA-1; Wed, 02 Jun 2021 05:06:43 -0400
X-MC-Unique: 9NcSkFfNN26fpckIKGoNTA-1
Received: by mail-pg1-f199.google.com with SMTP id 30-20020a630a1e0000b029021a63d9d4cdso1285289pgk.11
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 02:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4SKDhNmHqN2aKK0+XSIC4OXwk6NfJlgx4QyzKzOMn5g=;
        b=WSilery/+JYIHrZsM9Z91CCIe3nmABQulAt7ecimvZfqo6KuwXAO2iLe/shdyR0LLf
         4UMU0DIqGOrELhhnvJ+0duTEHUMROHJYVqtd4RyUTKbbJJI1j5FD8SJxTWsn/XPB1fG5
         yhnZEhCDJGpl4SXyPvWcepM32y9C8RKLTYUjZhnuc6nFRfrOKWvgh+eV4df7FrZHD9Di
         dgMnfX2FH37mm8/Wai5mqtwq53t3RvCsFZUOL7Kv1JizFx6g9ntbbLp0MWBuRl6La5Xn
         Bwa6fWeboFuilhqic83esvcNsac39depLWsy2WSeeifJbAI9XZPn7HubLQLGNfe8mwI0
         HeMg==
X-Gm-Message-State: AOAM530k6/2IdaEpazrpajcaIgPleEWx+HJpMUynUAkrb3t+RecMlVCc
        ks359M4jjE8vIBYZNICMxQoqAUaRjRD/F/8pRdLbOz3pP3qUIhSJc2rK+U+qhma34b/YS45yUBK
        9gr8YBFzJbhmJKQT1B9I43JOx2dzlKnwfm4YUGndrHDF9EwDC7ALHe9KC8aC3ErsT
X-Received: by 2002:a17:90a:d106:: with SMTP id l6mr29442517pju.164.1622624802408;
        Wed, 02 Jun 2021 02:06:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywOxQ+NWTfjlQmSNDqckkjmrNWhEkCDBhZCvcjcZYkfXqk+RN3ycPoZAbDZtUF42apd9FTcg==
X-Received: by 2002:a17:90a:d106:: with SMTP id l6mr29442495pju.164.1622624802084;
        Wed, 02 Jun 2021 02:06:42 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bo14sm249140pjb.40.2021.06.02.02.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 02:06:41 -0700 (PDT)
Subject: Re: [RESEND PATCH V4 2/2] vDPA/ifcvf: implement doorbell mapping for
 ifcvf
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210602084550.289599-1-lingshan.zhu@intel.com>
 <20210602084550.289599-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <87adb0ea-689e-f014-d81d-37b2ee032c54@redhat.com>
Date:   Wed, 2 Jun 2021 17:06:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602084550.289599-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/2 ÏÂÎç4:45, Zhu Lingshan Ð´µÀ:
> This commit implements doorbell mapping feature for ifcvf.
> This feature maps the notify page to userspace, to eliminate
> vmexit when kick a vq.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ab0ab5cf0f6e..46a992eab3e5 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -413,6 +413,21 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
>   	return vf->vring[qid].irq;
>   }
>   
> +static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
> +							       u16 idx)
> +{
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	struct vdpa_notification_area area;
> +
> +	area.addr = vf->vring[idx].notify_pa;
> +	if (!vf->notify_off_multiplier)
> +		area.size = PAGE_SIZE;
> +	else
> +		area.size = vf->notify_off_multiplier;
> +
> +	return area;
> +}
> +
>   /*
>    * IFCVF currently does't have on-chip IOMMU, so not
>    * implemented set_map()/dma_map()/dma_unmap()
> @@ -440,6 +455,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.get_config	= ifcvf_vdpa_get_config,
>   	.set_config	= ifcvf_vdpa_set_config,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
> +	.get_vq_notification = ifcvf_get_vq_notification,
>   };
>   
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)

