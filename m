Return-Path: <kvm+bounces-55-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDF57DB3A9
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B621B20DAB
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BD13D71;
	Mon, 30 Oct 2023 06:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bv87x68n"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E51C11
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:51:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7030CC1
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 23:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698648669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k/plvhVyykkxJgC+LDzB7nrVde68eR6Wbay50l+w4Jo=;
	b=bv87x68nSZSyuT168scufqbFCBUtb7QmCDG1X5jfaYRs6t9iGQMYtVIoo8bS6VvxkNeuG7
	r7gc82GZn9tyOGvsr0BMxWWfI9u2sSOaD1Z6QzE3zTsh+/8a2ucyoWESU+pFdY7TGreaJ2
	et0lgpeUPKYEPtXB9FVYZzR8uaOuLD8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-qrqUS6gHPGOQK27w47UOOg-1; Mon, 30 Oct 2023 02:51:08 -0400
X-MC-Unique: qrqUS6gHPGOQK27w47UOOg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-67012b06439so29609146d6.1
        for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 23:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698648667; x=1699253467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/plvhVyykkxJgC+LDzB7nrVde68eR6Wbay50l+w4Jo=;
        b=cwlVY6dJN7l/EPeh4KaNQWur1DyQvFFNt1P12STD7uYsIS7BAbyPEua/D3LVfcGL8G
         TUoRx56zdsjLeexIeARaWdhMxeYFv9/BrqoGL4r/JkWU+11lhMS+4chxIK+8htweTgGX
         cYXk91gV11tQaKIteHMUmDP/CTIZ9TlvnVNUyp+CBQX1Ska0QDVsGO/fkoPSSgcBHvxH
         fi7XH31HDQgBXsyd/nYhGJZJHOVKbpDZ50iOmie5avKl86jEDi2lrIy/bwuD2qGGvmCj
         bOIaf9gOmXQKCwjcVju+Z4Ti83rOBOT/chZMjpYxn/Xp1Eq41kyRvBH1tHQaVFZP8a2L
         PHag==
X-Gm-Message-State: AOJu0Yy8VHfuNQCfhHtHkv5x6CrRTCjTB9PK+SpMgUHevLRPL4hHsJ3m
	gGcWO8fS8JDt2IgnF1y6sFSdSGoUFfiE0i6ZMBixGGUBOehQBvx2cv7Z5pOVazpY0LNGLScQmsV
	rNjNAvs6dpfEd
X-Received: by 2002:ad4:5c65:0:b0:656:3b4c:b98b with SMTP id i5-20020ad45c65000000b006563b4cb98bmr13663441qvh.11.1698648667661;
        Sun, 29 Oct 2023 23:51:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcWTyJ/ls0PM/ts30s4JrMKonOhY6WcnFIQsH/9qqUm8IcFB7cyTLHbt51Omk+YQiO7SvxwQ==
X-Received: by 2002:ad4:5c65:0:b0:656:3b4c:b98b with SMTP id i5-20020ad45c65000000b006563b4cb98bmr13663439qvh.11.1698648667424;
        Sun, 29 Oct 2023 23:51:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:3f78:514a:4f03:fdc0? ([2a01:e0a:280:24f0:3f78:514a:4f03:fdc0])
        by smtp.gmail.com with ESMTPSA id x15-20020a0ceb8f000000b00670c15033aesm2179985qvo.144.2023.10.29.23.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Oct 2023 23:51:07 -0700 (PDT)
Message-ID: <356dd79e-9079-4bbc-9b64-9468b6f7b6a7@redhat.com>
Date: Mon, 30 Oct 2023 07:51:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 2/2] Documentation: add debugfs description for vfio
Content-Language: en-US
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
 jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 jonathan.cameron@huawei.com
Cc: bcreeley@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@openeuler.org
References: <20231028075447.41939-1-liulongfang@huawei.com>
 <20231028075447.41939-3-liulongfang@huawei.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20231028075447.41939-3-liulongfang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/28/23 09:54, Longfang Liu wrote:
> 1.Add an debugfs document description file to help users understand
> how to use the accelerator live migration driver's debugfs.
> 2.Update the file paths that need to be maintained in MAINTAINERS

Should we have 2 patches instead ?

Anyhow,

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>   Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
>   MAINTAINERS                            |  1 +
>   2 files changed, 26 insertions(+)
>   create mode 100644 Documentation/ABI/testing/debugfs-vfio
> 
> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
> new file mode 100644
> index 000000000000..445e9f58f924
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-vfio
> @@ -0,0 +1,25 @@
> +What:		/sys/kernel/debug/vfio
> +Date:		Oct 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices, it's a common directory for all vfio devices.
> +		Vfio core will create a device subdirectory under this
> +		directory.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration
> +Date:		Oct 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices that support live migration.
> +		The debugfs of each vfio device that supports live migration
> +		could be created under this directory.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/state
> +Date:		Oct 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration status of the vfio device.
> +		The contents of the state file reflects the migration state
> +		relative to those defined in the vfio_device_mig_state enum
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b19995690904..a6be3b4219c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22591,6 +22591,7 @@ L:	kvm@vger.kernel.org
>   S:	Maintained
>   T:	git https://github.com/awilliam/linux-vfio.git
>   F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
> +F:	Documentation/ABI/testing/debugfs-vfio
>   F:	Documentation/driver-api/vfio.rst
>   F:	drivers/vfio/
>   F:	include/linux/vfio.h


