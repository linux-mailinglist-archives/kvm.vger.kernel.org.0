Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358FA32A782
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449256AbhCBQRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:17:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351388AbhCBORX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 09:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614694524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjOoUYxeG19DT5eJ2WuZnRhWzkvWoRa4HG3rYru+1nk=;
        b=VyvCZVLZOgTmE4ZmabP9YB9dS7N0agz0vdeW1Efc8BuFskFpPYHIctNTNrcF4yHm11GRKN
        aGAsmYsxDjdqGZxqAjCE84KJo1jmeS0tFZveTJBYXyuBxziP+DA86wNm21rOVyHjOIQvSb
        ioxdGD8TOvng2ivxRYLrhCBUtLh+5Rg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-F56ATpnSO7uS9Pf1TIcS5w-1; Tue, 02 Mar 2021 09:15:21 -0500
X-MC-Unique: F56ATpnSO7uS9Pf1TIcS5w-1
Received: by mail-ed1-f71.google.com with SMTP id k8so1980024edn.19
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:15:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rjOoUYxeG19DT5eJ2WuZnRhWzkvWoRa4HG3rYru+1nk=;
        b=fZktbkVGhmS9oDkjwmLXK3N8/HsEChqcGGTH4lCF4e4xK0/7YS1Npb/oIhlxYEnMKh
         PQg3YK4X+/lTpIqmj3C4c+ASSQze4I6dDJfuV0rNaxIyG+uumt4jJr1/l2M795BVAcUu
         twAGQtMPZpUwomSDp/AiGLktbqzSLBhiCwm55uVArfkSHxmSsS13Rebc6UnnNxDywFoa
         3cpEb9XWWnJaKG7cgp5ZLHjD5xqCCd7RnIvJKxacWbouWxeaB1axAbeIAZyhfax9fC42
         MPXrTKFWGxhYYCz/Vm67BZzCtWdXvWdgb3TCN4qHqDvWNN6NRMbVZExzLQRdmePaigqQ
         ++Fw==
X-Gm-Message-State: AOAM533kytiqwZj988oQBa7vlvBFJh06y5zKOG1o7RM3jkSbsP4/qzUi
        JrCMUWSfABVlAGKFexEBlt7chqZ/vyXF7nIEUyt4JRISH+13WruYqap8yj5GgaDrLdJB91c50QU
        FnAJCLTp9b8cI
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr21120900ejb.69.1614694520443;
        Tue, 02 Mar 2021 06:15:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygE29SnX3D3HuuzIHfSkf8dbUaigd8KEMZKU0eY9r+w462+eOcRfQHeat9otGJbyl2OKaNyA==
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr21120877ejb.69.1614694520244;
        Tue, 02 Mar 2021 06:15:20 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id c17sm18013380edw.32.2021.03.02.06.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 06:15:19 -0800 (PST)
Date:   Tue, 2 Mar 2021 15:15:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH 01/10] vdpa: add get_config_size callback in
 vdpa_config_ops
Message-ID: <20210302141516.oxsdb7jogrvu75yc@steredhat>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-2-sgarzare@redhat.com>
 <5de4cd5b-04cb-46ca-1717-075e5e8542fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5de4cd5b-04cb-46ca-1717-075e5e8542fd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 12:14:13PM +0800, Jason Wang wrote:
>
>On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>This new callback is used to get the size of the configuration space
>>of vDPA devices.
>>
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>  include/linux/vdpa.h              | 4 ++++
>>  drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
>>  4 files changed, 25 insertions(+)
>>
>>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>index 4ab5494503a8..fddf42b17573 100644
>>--- a/include/linux/vdpa.h
>>+++ b/include/linux/vdpa.h
>>@@ -150,6 +150,9 @@ struct vdpa_iova_range {
>>   * @set_status:			Set the device status
>>   *				@vdev: vdpa device
>>   *				@status: virtio device status
>>+ * @get_config_size:		Get the size of the configuration space
>>+ *				@vdev: vdpa device
>>+ *				Returns size_t: configuration size
>
>
>Rethink about this, how much we could gain by introducing a dedicated 
>ops here? E.g would it be simpler if we simply introduce a 
>max_config_size to vdpa device?

Mainly because in this way we don't have to add new parameters to the 
vdpa_alloc_device() function.

We do the same for example for 'get_device_id', 'get_vendor_id', 
'get_vq_num_max'. All of these are usually static, but we have ops.
I think because it's easier to extend.

I don't know if it's worth adding a new structure for these static 
values at this point, like 'struct vdpa_config_params'.

Thanks,
Stefano

