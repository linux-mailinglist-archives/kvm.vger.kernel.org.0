Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEFE395692
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 09:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEaH56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 03:57:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhEaH5x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 03:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622447774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twMQBKVBYP+3C668h6+k4MZ8lCmQRLRa2Kt2PzgnD7I=;
        b=frTbzk6m+V8n9nk6Vc29zr1OGF5531GuXea0mtLOGQANtaXvvAjragSOJJ4viesbcQEkMN
        tsQ3mEIBmUVPAA97k3lUQ31zcYbvoz1mq8jKJs0cq3gINAZ8BBrnXueyRYtj0PcKEYOgX/
        QBcII7yJ9yIjxTPoMbMau8LIxLMUtl0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-ZpZNPemxPJiSD-2XNBz5wA-1; Mon, 31 May 2021 03:56:12 -0400
X-MC-Unique: ZpZNPemxPJiSD-2XNBz5wA-1
Received: by mail-pf1-f197.google.com with SMTP id e19-20020aa78c530000b02902e9ca53899dso1030453pfd.22
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 00:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=twMQBKVBYP+3C668h6+k4MZ8lCmQRLRa2Kt2PzgnD7I=;
        b=V5xQoIFTjjjKpfhXpsPRiQATm56eBTbZmszDwiY2C4hHSQi+VSM/KW+CAvJdapcTIV
         e8jKVZ8YFrVC0OwkrXM2CnnHJyILlAp+UhJ9R9typ7LwWK3g6viaOf1U8PUoeypcZMTK
         dA4QVwQiejPFiF722/xRyhGDaPjEBydDi7oLOGmJm25Sv+v66GN6G0mxNqBrLIvz8M/b
         oO/sT8rSDn6zwv2izgghkAfpqEJQ7dfNC4fCZ7IHXATBhaRcYfcWm2XJvOnsTIkp92fk
         BKRbndllJJe2UYaFFnPaOfgFevDOnHoK67oioDluLicMRFEfOHPvSiptw7owvSVlTzWC
         7VhA==
X-Gm-Message-State: AOAM531aPXV45zdpn63tSr/TsfUjF69xYJ0+tU8xwMj81rQ2sVxvX9tm
        E9ANRSABvwkmsEN8zFhJGyZxvJe9+7kk7KjY40c+rPsf6tbNNj3iEtq5dQoedGaRT9JUn1IFkeH
        2hDfUpo1RxDR4KeSQJ8lkBrjvReBUErhv+RWBzm6rde6hVMisTY9TcL6JSSq1cpbN
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr64996pjw.19.1622447771272;
        Mon, 31 May 2021 00:56:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8TC88Xtx7F14ZsQpXbpJHfPDYW9N6L5JuXudwujjTwdCrrK/LGYsXmWWRMwVYIznSPLKRCw==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr64969pjw.19.1622447770917;
        Mon, 31 May 2021 00:56:10 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 76sm920482pfy.82.2021.05.31.00.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 00:56:10 -0700 (PDT)
Subject: Re: [PATCH V2 RESEND 2/2] vDPA/ifcvf: implement doorbell mapping for
 ifcvf
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210531073316.363655-1-lingshan.zhu@intel.com>
 <20210531073316.363655-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f3c28e92-3e8d-2a8a-ec5a-fc64f2098678@redhat.com>
Date:   Mon, 31 May 2021 15:56:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531073316.363655-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/31 ÏÂÎç3:33, Zhu Lingshan Ð´µÀ:
> This commit implements doorbell mapping feature for ifcvf.
> This feature maps the notify page to userspace, to eliminate
> vmexit when kick a vq.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ab0ab5cf0f6e..effb0e549135 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -413,6 +413,22 @@ static int ifcvf_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev,
>   	return vf->vring[qid].irq;
>   }
>   
> +static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
> +							       u16 idx)
> +{
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct vdpa_notification_area area;
> +
> +	area.addr = vf->vring[idx].notify_pa;
> +	area.size = PAGE_SIZE;
> +	if (area.addr % PAGE_SIZE)
> +		IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE aligned\n", idx);


Let's leave the decision to upper layer by: (see 
vp_vdpa_get_vq_notification)

area.addr = notify_pa;
area.size = notify_offset_multiplier;

Thanks


> +
> +	return area;
> +}
> +
>   /*
>    * IFCVF currently does't have on-chip IOMMU, so not
>    * implemented set_map()/dma_map()/dma_unmap()
> @@ -440,6 +456,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.get_config	= ifcvf_vdpa_get_config,
>   	.set_config	= ifcvf_vdpa_set_config,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
> +	.get_vq_notification = ifcvf_get_vq_notification,
>   };
>   
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)

