Return-Path: <kvm+bounces-123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDEE7DBF9E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45508B20E62
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B8919BB0;
	Mon, 30 Oct 2023 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5brf9sK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198161945B
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 18:18:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C7CC2
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698689920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUJc6zFpUGnFUT0JQ67BCsiiQXvckJ5XNbOCdGJYiwI=;
	b=i5brf9sKLdIspCTjawH92RrfT7rRt52gNr8Q7nIUUQgrOiiDD0EpGykid9Yp24Lgo1GScx
	nMkxnqKKBZf1WyqNppeaM9YTBxcFy/AiPQKy+/3rGhJQNFcYvXLvZj1sdxCJ39nPKBUzvo
	+K+UH1S+J30vCSTkKzOxGSkSJa6TBG4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-hmy_yyZQOJWHlK3HuGVjeg-1; Mon, 30 Oct 2023 14:18:39 -0400
X-MC-Unique: hmy_yyZQOJWHlK3HuGVjeg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-41cbc7d2e58so55637211cf.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698689918; x=1699294718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUJc6zFpUGnFUT0JQ67BCsiiQXvckJ5XNbOCdGJYiwI=;
        b=dFTXuEFhv72lVJo3SgahSAFZsXszafkP8HbLlHdSWdzbpMY5t6oL/iZCnzYD0fUjM+
         UboAKDoyeDmBX6PxPWtov24nTNp9I66NpJF6iGOetg+JGyetRO8h4WmZ5ggo8WCQ5uU+
         XhlV/heVatt200k+Wh87FYC1ZloslWKC1ODYk7hNH4oTacK1pWbVruauyrHDYhKzgT7Z
         gT6ibGIjFUJf4zPqtRXGeRu32AyzRJgbwxevAVFlbyiWbiI4edwFgST1Z59mrQVuN7ab
         kVWENbkLcRDQwDrA2JgGgPtjyUly03bxRQeJzUH2p9lVcbCBJFdNRbXkPmQ8W55Nc2uO
         yc6w==
X-Gm-Message-State: AOJu0YwJkB7d8TVIz2nY7ViWu5+NP1Qf0u32AhvQ3nTpmoRZEUVRdYPU
	E529Hkkfo+9IkCPz/zlZIS5uJpHE3Xs3DlcX/kcWFSZqwzzr5CrniEnfqpKVeMFi6Hy6tO+UYmJ
	mXNgq7zrtkqzn
X-Received: by 2002:ac8:5f06:0:b0:418:b8c:1a0a with SMTP id x6-20020ac85f06000000b004180b8c1a0amr11534487qta.25.1698689918623;
        Mon, 30 Oct 2023 11:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNBVtmaj0P9JB+DbvtKdIkRMvHjbkplLaqZeShwkceMhq5L7YIm625hBgnYHJDZfqcg8b/7A==
X-Received: by 2002:ac8:5f06:0:b0:418:b8c:1a0a with SMTP id x6-20020ac85f06000000b004180b8c1a0amr11534477qta.25.1698689918398;
        Mon, 30 Oct 2023 11:18:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:3f78:514a:4f03:fdc0? ([2a01:e0a:280:24f0:3f78:514a:4f03:fdc0])
        by smtp.gmail.com with ESMTPSA id x5-20020ac84d45000000b00419c40a0d70sm3625383qtv.54.2023.10.30.11.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 11:18:38 -0700 (PDT)
Message-ID: <80db2551-c767-45a0-b66e-89ab52b8238f@redhat.com>
Date: Mon, 30 Oct 2023 19:18:35 +0100
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
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231028075447.41939-3-liulongfang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/23 09:54, Longfang Liu wrote:
> 1.Add an debugfs document description file to help users understand
> how to use the accelerator live migration driver's debugfs.
> 2.Update the file paths that need to be maintained in MAINTAINERS
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

I think the KernelVersion lines should be using tabs and not white spaces.

Thanks,

C.





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


