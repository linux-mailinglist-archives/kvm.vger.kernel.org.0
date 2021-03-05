Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28AC32E3D4
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 09:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCEIio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 03:38:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbhCEIii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 03:38:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614933517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YAI/I8B7wpZIUjXzzsxu1gO3qnb8MhXPXX1hsky7UW0=;
        b=duCFqQf9ho5cF8PRY81PeT0PQX2EvfSTw5kljqfcPP4SfiVRMq7nAPoVI1+OYIINSyKKDo
        2ILs46jzXb9vwBcBYoH3liCmKlRwfkSIqTPqdUF5nyjgF4MzAxTitzYyVKR9o9WiVinmcp
        HpVUFxwE+rW9/pRFheGv+kmb0Ro+dNc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-B8FaFc5PNyOYGi3PHT9qHw-1; Fri, 05 Mar 2021 03:38:36 -0500
X-MC-Unique: B8FaFc5PNyOYGi3PHT9qHw-1
Received: by mail-ed1-f71.google.com with SMTP id h5so584690edf.17
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 00:38:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YAI/I8B7wpZIUjXzzsxu1gO3qnb8MhXPXX1hsky7UW0=;
        b=tpiwb5Xs7T20qc44Y1wrR7cNX7CQTGDHsRs8yh2JNcXSNv0QKdtW9uxYACRIBg/Kwg
         vXBLJzi9ry8jOQil+35H54/BsDNGTb9LuHWodtK/bAkW5OmWECPuB1zfqhadrqSFiZQ8
         TlWplAceMCb1V1+zYx2x4P3nPUsiLG/+2twMAVSBIynhb/CAFPX7ksWYuh3yIPDUHhHa
         L1guvgk0HKldwNHz62GROU0AX3ev1WofxBBZ7sWTXRI8/AqVcUeFhn54lpd6JDznqWEf
         sUlOOO+AmkfHl6ayb8QvOX1luJqJ+wBixHXpWpqWcma/gBOSFpxMldNApFytVU//Zjyk
         s5zw==
X-Gm-Message-State: AOAM530bs64viyFCW+ZhEW1YQ8fLKk/1JPnJ0hcKEGCJMuXFFamA4KjI
        iHpGAroPj7W+BlRv60OW0VXmBk02mZOfe8DJ4wAbYpRkJO9ksjjrSaZ4eWBoewhosWm0+8Cio0/
        hLEIGmb2tqYPu
X-Received: by 2002:aa7:c4c2:: with SMTP id p2mr8145829edr.213.1614933514896;
        Fri, 05 Mar 2021 00:38:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpKQMBiWEPcNeeOxJLoLVSCp4kYG/AfcmBBA9HYJJaMxhtQXqPnopI+sO2MueR69Vo1Ksn1A==
X-Received: by 2002:aa7:c4c2:: with SMTP id p2mr8145823edr.213.1614933514755;
        Fri, 05 Mar 2021 00:38:34 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s18sm1227188edc.21.2021.03.05.00.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 00:38:34 -0800 (PST)
Date:   Fri, 5 Mar 2021 09:38:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] vdpa: add get_config_size callback in
 vdpa_config_ops
Message-ID: <20210305083832.hotg52p7kluus2xq@steredhat>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-2-sgarzare@redhat.com>
 <5de4cd5b-04cb-46ca-1717-075e5e8542fd@redhat.com>
 <20210302141516.oxsdb7jogrvu75yc@steredhat>
 <8a3f39ab-1cee-d0c3-e4d1-dc3ec492a763@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a3f39ab-1cee-d0c3-e4d1-dc3ec492a763@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 04:34:52PM +0800, Jason Wang wrote:
>
>On 2021/3/2 10:15 下午, Stefano Garzarella wrote:
>>On Tue, Mar 02, 2021 at 12:14:13PM +0800, Jason Wang wrote:
>>>
>>>On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>>>This new callback is used to get the size of the configuration space
>>>>of vDPA devices.
>>>>
>>>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>---
>>>> include/linux/vdpa.h              | 4 ++++
>>>> drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
>>>> drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
>>>> drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
>>>> 4 files changed, 25 insertions(+)
>>>>
>>>>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>>>index 4ab5494503a8..fddf42b17573 100644
>>>>--- a/include/linux/vdpa.h
>>>>+++ b/include/linux/vdpa.h
>>>>@@ -150,6 +150,9 @@ struct vdpa_iova_range {
>>>>  * @set_status:            Set the device status
>>>>  *                @vdev: vdpa device
>>>>  *                @status: virtio device status
>>>>+ * @get_config_size:        Get the size of the configuration space
>>>>+ *                @vdev: vdpa device
>>>>+ *                Returns size_t: configuration size
>>>
>>>
>>>Rethink about this, how much we could gain by introducing a 
>>>dedicated ops here? E.g would it be simpler if we simply introduce 
>>>a max_config_size to vdpa device?
>>
>>Mainly because in this way we don't have to add new parameters to 
>>the vdpa_alloc_device() function.
>>
>>We do the same for example for 'get_device_id', 'get_vendor_id', 
>>'get_vq_num_max'. All of these are usually static, but we have ops.
>>I think because it's easier to extend.
>>
>>I don't know if it's worth adding a new structure for these static 
>>values at this point, like 'struct vdpa_config_params'.
>
>
>Yes, that's the point. I think for any static values, it should be set 
>during device allocation.

Yeah, I see.

>
>I'm fine with both.
>

@Michael any thoughts?

Thanks,
Stefano

