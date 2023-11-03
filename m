Return-Path: <kvm+bounces-466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F14CD7DFF70
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 08:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A0AE1C2104D
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 07:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A7A79CF;
	Fri,  3 Nov 2023 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYw2h6x1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B17468
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:39:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE121134
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 00:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698997158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZuQohmnOldmW1VHy4ROYujf3sIsVkqTMbg2gI0VTvA=;
	b=EYw2h6x1MoFfxlXvSMDzrTUJ88AIPH3Zzy7cHers9z24uAK9SW6D5Mg9XFmijz034N8Di/
	o9GsvITODwxbBiEll3cqyV1ODtqqTC2t3xZzFcNzeVq++b73OGPPcn2gaJTLJeqUKSKBq5
	v8Iqkzr1Q3vpin4Hhlmc7TDL/vDawu8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-3SJMamJ1N-6004TObv9Ojg-1; Fri, 03 Nov 2023 03:39:17 -0400
X-MC-Unique: 3SJMamJ1N-6004TObv9Ojg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40837aa4a58so11844405e9.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 00:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698997156; x=1699601956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZuQohmnOldmW1VHy4ROYujf3sIsVkqTMbg2gI0VTvA=;
        b=eZxOVTHL6s+Rh5+pBSA5Zb9xOeJH5vCgfG1Ndbm3wUlYfPfugZzDQ8uSH+9L28AWUS
         ubsVsmTmyIThJRhpXeffnkC2NHAgyHvJKHmzByDLfWFZ33JCTsqKlm9Ta/ORxjjd52/x
         NUBsbyjXeKwcCjCjJkCkgJhZULO2tfUHa703psC7Aki0JTHm272NwdRCy1i1mbrKlCRu
         VsH2uAZ70NECls1cGKNw+nCX2QhXbf7ZIN0lTysHgt7shQJkYdBQg924zf5nzX3U14Cd
         wtdX7PZHJDkbmC6Jt+UfLWtuiDwjj+36lnIcIRikneEKgAB7wFKMPzWWUR79v2btN0CX
         iVCw==
X-Gm-Message-State: AOJu0Yw3q/Zn0n33Ddynx87fjE4tjttgqn7q6HcgTedB4B0aQo86knzg
	TgnrXihHfKzsJJoVHChVxUkIa4qTJWojI4FGJ0qp7gZxiGabIACsCChXo5BJ0Gr4GagL4uJ3ED5
	8TrylJkg3JL+E
X-Received: by 2002:a05:600c:4313:b0:401:c7ec:b930 with SMTP id p19-20020a05600c431300b00401c7ecb930mr1838748wme.10.1698997156166;
        Fri, 03 Nov 2023 00:39:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsPxlKYqAwFNSXNswHyQdCOpU9lVHJsDEKqDQ0yhKTs/DCMk3R2BvFerg99LrQVPM6Xpycwg==
X-Received: by 2002:a05:600c:4313:b0:401:c7ec:b930 with SMTP id p19-20020a05600c431300b00401c7ecb930mr1838728wme.10.1698997155784;
        Fri, 03 Nov 2023 00:39:15 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:efc3:a5be:5586:34a6:1108])
        by smtp.gmail.com with ESMTPSA id bg19-20020a05600c3c9300b0040531f5c51asm1583577wmb.5.2023.11.03.00.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 00:39:14 -0700 (PDT)
Date: Fri, 3 Nov 2023 03:39:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
	jasowang@redhat.com, jgg@nvidia.com, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin
 commands
Message-ID: <20231103033834-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-6-yishaih@nvidia.com>
 <202311030838.GjyaBTjM-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202311030838.GjyaBTjM-lkp@intel.com>

On Fri, Nov 03, 2023 at 08:33:06AM +0800, kernel test robot wrote:
> Hi Yishai,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on awilliam-vfio/for-linus]
> [also build test WARNING on linus/master v6.6]
> [cannot apply to awilliam-vfio/next mst-vhost/linux-next next-20231102]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/virtio-Define-feature-bit-for-administration-virtqueue/20231030-000414
> base:   https://github.com/awilliam/linux-vfio.git for-linus
> patch link:    https://lore.kernel.org/r/20231029155952.67686-6-yishaih%40nvidia.com
> patch subject: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin commands
> config: i386-randconfig-061-20231102 (https://download.01.org/0day-ci/archive/20231103/202311030838.GjyaBTjM-lkp@intel.com/config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231103/202311030838.GjyaBTjM-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311030838.GjyaBTjM-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/virtio/virtio_pci_modern.c:726:16: sparse: sparse: restricted __le16 degrades to integer
> 
> vim +726 drivers/virtio/virtio_pci_modern.c
> 
>    673	
>    674	static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
>    675					    struct virtio_admin_cmd *cmd)
>    676	{
>    677		struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
>    678		struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>    679		struct virtio_admin_cmd_status *va_status;
>    680		unsigned int out_num = 0, in_num = 0;
>    681		struct virtio_admin_cmd_hdr *va_hdr;
>    682		struct virtqueue *avq;
>    683		u16 status;
>    684		int ret;
>    685	
>    686		avq = virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ) ?
>    687			vp_dev->admin_vq.info.vq : NULL;
>    688		if (!avq)
>    689			return -EOPNOTSUPP;
>    690	
>    691		va_status = kzalloc(sizeof(*va_status), GFP_KERNEL);
>    692		if (!va_status)
>    693			return -ENOMEM;
>    694	
>    695		va_hdr = kzalloc(sizeof(*va_hdr), GFP_KERNEL);
>    696		if (!va_hdr) {
>    697			ret = -ENOMEM;
>    698			goto err_alloc;
>    699		}
>    700	
>    701		va_hdr->opcode = cmd->opcode;
>    702		va_hdr->group_type = cmd->group_type;
>    703		va_hdr->group_member_id = cmd->group_member_id;
>    704	
>    705		/* Add header */
>    706		sg_init_one(&hdr, va_hdr, sizeof(*va_hdr));
>    707		sgs[out_num] = &hdr;
>    708		out_num++;
>    709	
>    710		if (cmd->data_sg) {
>    711			sgs[out_num] = cmd->data_sg;
>    712			out_num++;
>    713		}
>    714	
>    715		/* Add return status */
>    716		sg_init_one(&stat, va_status, sizeof(*va_status));
>    717		sgs[out_num + in_num] = &stat;
>    718		in_num++;
>    719	
>    720		if (cmd->result_sg) {
>    721			sgs[out_num + in_num] = cmd->result_sg;
>    722			in_num++;
>    723		}
>    724	
>    725		if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
>  > 726		    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)

yes, this is broken on BE. You need to convert enums to LE before you
compare.

>    727			ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>    728					       out_num, in_num,
>    729					       sgs, GFP_KERNEL);
>    730		else
>    731			ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
>    732					       out_num, in_num,
>    733					       sgs, GFP_KERNEL);
>    734		if (ret) {
>    735			dev_err(&vdev->dev,
>    736				"Failed to execute command on admin vq: %d\n.", ret);
>    737			goto err_cmd_exec;
>    738		}
>    739	
>    740		status = le16_to_cpu(va_status->status);
>    741		if (status != VIRTIO_ADMIN_STATUS_OK) {
>    742			dev_err(&vdev->dev,
>    743				"admin command error: status(%#x) qualifier(%#x)\n",
>    744				status, le16_to_cpu(va_status->status_qualifier));
>    745			ret = -status;
>    746		}
>    747	
>    748	err_cmd_exec:
>    749		kfree(va_hdr);
>    750	err_alloc:
>    751		kfree(va_status);
>    752		return ret;
>    753	}
>    754	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


