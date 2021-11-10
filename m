Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7D644CDB7
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 00:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhKJXWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 18:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhKJXWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 18:22:30 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB1AC061766;
        Wed, 10 Nov 2021 15:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=xEqDTWAFLmx5Cn/nPzkjs/40QqO/RwaitF32KXxu59A=; b=0N1jHe9g2Kx7FDMkvMd+aqWqTd
        ES864jTKdeSH502Te2dAQgD5o074jRrvrbfjNkWxI7NeCcTG+DelqjTctGQwtF6QbU9P2Vca8O3PI
        tNPZtp37cfZrrdfpxFOZr5ErY8z+DFMafGmP38iNl8O5DbeFmSFg8ODoGBfOe1L6BpLlQoai3sBBv
        9rb5+2tOb3oz8QafYu+mSItUn7fhTy6oK05Ij3jE7B2Hw3+BNWTHfooGyZhgvETbi21/tvA+02TGt
        qqw3OzIqIOzOQVvmnn/U4/OBYvGnJ0g0RfaXAuIjRI8z/3WWAGa7/n9StQyJcRjtiCIXnQtCtNhXa
        gWTGaCbQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkwsW-006cCF-Md; Wed, 10 Nov 2021 23:19:40 +0000
Subject: Re: drivers/vfio/vfio.c:293: warning: expecting prototype for
 Container objects(). Prototype was for vfio_container_get() instead
To:     Jason Gunthorpe <jgg@nvidia.com>, kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <202111102328.WDUm0Bl7-lkp@intel.com>
 <20211110164256.GY1740502@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
Date:   Wed, 10 Nov 2021 15:19:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110164256.GY1740502@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 8:42 AM, Jason Gunthorpe wrote:
> On Wed, Nov 10, 2021 at 11:12:39PM +0800, kernel test robot wrote:
>> Hi Jason,
>>
>> FYI, the error/warning still remains.
> 
> This is just a long standing kdoc misuse.
> 
> vfio is not W=1 kdoc clean.
> 
> Until someone takes a project to fix this comprehensively there is not
> much point in reporting new complaints related the existing mis-use..

Hi,

Can we just remove all misused "/**" comments in vfio.c until
someone cares enough to use proper kernel-doc there?

---
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] vfio/vfio: remove all kernel-doc notation

vfio.c abuses (misuses) "/**", which indicates the beginning of
kernel-doc notation in the kernel tree. This causes a bunch of
kernel-doc complaints about this source file, so quieten all of
them by changing all "/**" to "/*".

vfio.c:236: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * IOMMU driver registration
vfio.c:236: warning: missing initial short description on line:
  * IOMMU driver registration
vfio.c:295: warning: expecting prototype for Container objects(). Prototype was for vfio_container_get() instead
vfio.c:317: warning: expecting prototype for Group objects(). Prototype was for __vfio_group_get_from_iommu() instead
vfio.c:496: warning: Function parameter or member 'device' not described in 'vfio_device_put'
vfio.c:496: warning: expecting prototype for Device objects(). Prototype was for vfio_device_put() instead
vfio.c:599: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * Async device support
vfio.c:599: warning: missing initial short description on line:
  * Async device support
vfio.c:693: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * VFIO driver API
vfio.c:693: warning: missing initial short description on line:
  * VFIO driver API
vfio.c:835: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * Get a reference to the vfio_device for a device.  Even if the
vfio.c:835: warning: missing initial short description on line:
  * Get a reference to the vfio_device for a device.  Even if the
vfio.c:969: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * VFIO base fd, /dev/vfio/vfio
vfio.c:969: warning: missing initial short description on line:
  * VFIO base fd, /dev/vfio/vfio
vfio.c:1187: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * VFIO Group fd, /dev/vfio/$GROUP
vfio.c:1187: warning: missing initial short description on line:
  * VFIO Group fd, /dev/vfio/$GROUP
vfio.c:1540: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * VFIO Device fd
vfio.c:1540: warning: missing initial short description on line:
  * VFIO Device fd
vfio.c:1615: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * External user API, exported by symbols to be linked dynamically.
vfio.c:1615: warning: missing initial short description on line:
  * External user API, exported by symbols to be linked dynamically.
vfio.c:1663: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * External user API, exported by symbols to be linked dynamically.
vfio.c:1663: warning: missing initial short description on line:
  * External user API, exported by symbols to be linked dynamically.
vfio.c:1742: warning: Function parameter or member 'caps' not described in 'vfio_info_cap_add'
vfio.c:1742: warning: Function parameter or member 'size' not described in 'vfio_info_cap_add'
vfio.c:1742: warning: Function parameter or member 'id' not described in 'vfio_info_cap_add'
vfio.c:1742: warning: Function parameter or member 'version' not described in 'vfio_info_cap_add'
vfio.c:1742: warning: expecting prototype for Sub(). Prototype was for vfio_info_cap_add() instead
vfio.c:2276: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * Module/class support
vfio.c:2276: warning: missing initial short description on line:
  * Module/class support

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
---
  drivers/vfio/vfio.c |   28 ++++++++++++++--------------
  1 file changed, 14 insertions(+), 14 deletions(-)

--- linux-next-20211110.orig/drivers/vfio/vfio.c
+++ linux-next-20211110/drivers/vfio/vfio.c
@@ -232,7 +232,7 @@ static inline bool vfio_iommu_driver_all
  }
  #endif /* CONFIG_VFIO_NOIOMMU */
  
-/**
+/*
   * IOMMU driver registration
   */
  int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops)
@@ -285,7 +285,7 @@ static int vfio_iommu_group_notifier(str
  				     unsigned long action, void *data);
  static void vfio_group_get(struct vfio_group *group);
  
-/**
+/*
   * Container objects - containers are created when /dev/vfio/vfio is
   * opened, but their lifecycle extends until the last user is done, so
   * it's freed via kref.  Must support container/group/device being
@@ -309,7 +309,7 @@ static void vfio_container_put(struct vf
  	kref_put(&container->kref, vfio_container_release);
  }
  
-/**
+/*
   * Group objects - create, release, get, put, search
   */
  static struct vfio_group *
@@ -488,7 +488,7 @@ static struct vfio_group *vfio_group_get
  	return group;
  }
  
-/**
+/*
   * Device objects - create, release, get, put, search
   */
  /* Device reference always implies a group reference */
@@ -595,7 +595,7 @@ static int vfio_dev_viable(struct device
  	return ret;
  }
  
-/**
+/*
   * Async device support
   */
  static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
@@ -689,7 +689,7 @@ static int vfio_iommu_group_notifier(str
  	return NOTIFY_OK;
  }
  
-/**
+/*
   * VFIO driver API
   */
  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
@@ -831,7 +831,7 @@ int vfio_register_emulated_iommu_dev(str
  }
  EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
  
-/**
+/*
   * Get a reference to the vfio_device for a device.  Even if the
   * caller thinks they own the device, they could be racing with a
   * release call path, so we can't trust drvdata for the shortcut.
@@ -965,7 +965,7 @@ void vfio_unregister_group_dev(struct vf
  }
  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
  
-/**
+/*
   * VFIO base fd, /dev/vfio/vfio
   */
  static long vfio_ioctl_check_extension(struct vfio_container *container,
@@ -1183,7 +1183,7 @@ static const struct file_operations vfio
  	.compat_ioctl	= compat_ptr_ioctl,
  };
  
-/**
+/*
   * VFIO Group fd, /dev/vfio/$GROUP
   */
  static void __vfio_group_unset_container(struct vfio_group *group)
@@ -1536,7 +1536,7 @@ static const struct file_operations vfio
  	.release	= vfio_group_fops_release,
  };
  
-/**
+/*
   * VFIO Device fd
   */
  static int vfio_device_fops_release(struct inode *inode, struct file *filep)
@@ -1611,7 +1611,7 @@ static const struct file_operations vfio
  	.mmap		= vfio_device_fops_mmap,
  };
  
-/**
+/*
   * External user API, exported by symbols to be linked dynamically.
   *
   * The protocol includes:
@@ -1659,7 +1659,7 @@ struct vfio_group *vfio_group_get_extern
  }
  EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
  
-/**
+/*
   * External user API, exported by symbols to be linked dynamically.
   * The external user passes in a device pointer
   * to verify that:
@@ -1725,7 +1725,7 @@ long vfio_external_check_extension(struc
  }
  EXPORT_SYMBOL_GPL(vfio_external_check_extension);
  
-/**
+/*
   * Sub-module support
   */
  /*
@@ -2272,7 +2272,7 @@ struct iommu_domain *vfio_group_iommu_do
  }
  EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
  
-/**
+/*
   * Module/class support
   */
  static char *vfio_devnode(struct device *dev, umode_t *mode)


