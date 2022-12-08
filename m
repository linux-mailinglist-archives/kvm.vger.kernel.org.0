Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD46469AD
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 08:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLHHW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 02:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLHHWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 02:22:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4962E2
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 23:22:52 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m14so562494wrh.7
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 23:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+KgrJgKlOCWs8OsRLJcfgfE9La+tQMLkIort8Vs082I=;
        b=FCOqnyeSdn28Fg8m7NEZojAUp1vbm0uShsr0YjvFX3YzeiZopJl+vh0sipA8p4jWDF
         Jx7dss3IysY8nj0n02uKUdDVPchxEeYGpJsKDVwko9nCCmyObdCsX4s6gnkwY/Nw55WG
         UeK4CCEdbDGrDrZJQRRvbz4lxGS/7vSVy+6I345PyN18weapfoOZ2G0IYvzAyKiQihO+
         KRraKZoEOaFZueEtXa5MlbHpMbzKko1rNgT2KkbHmHoM9mes3JQ5UpOA8eO07RtmymbE
         JziPggF53Ges1XttfZB5CmNHsisuFoH9bxug/3GOyWLcEPi9aINJsj87//v7eD6CGo89
         o8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KgrJgKlOCWs8OsRLJcfgfE9La+tQMLkIort8Vs082I=;
        b=js5vkOOGIfou/8Qi0dqrR0zUZWVdK9GPaEi/aONm5tDjhGiBZo765psdnmgL6oWTBq
         OWMU5xo8rDL1O6XmpjuBFrVfXkWFCtey0WRBi2nc/eSdXQZDVIIQut1f42knESiK6X2D
         LR54kLrpsg8D8YOLJr4XkseDrZWRGMd7E10LtiQDIL6k444hFa28YMDx0Z6lgLjCei43
         cPcVLPwby0D6c43mAvkddWshgU2GZ63qLaf67Y81X+YD/1ea7jcwwhU3VYMcpAhfZO/8
         R3IUL8HEtaFzTP23isijlUXhWwTPKT0Qa0f8lkX8lp5mYUQrKOQqjbYzAKmvCX8e0CH2
         ZC7Q==
X-Gm-Message-State: ANoB5plyhpjejGZptHV/xXoJQem+LT6wIdtVKaWex0TgiVu+WxH967q1
        e5KAd7GoQE7Je1cJiP65pxo=
X-Google-Smtp-Source: AA0mqf7wPUBYA5aC2yZigXJDteQzOt+U0qWhwkNWTZFT5SFlUP1NIyz3eJeWC0r9X3G3uYiPE8FVFQ==
X-Received: by 2002:adf:d22f:0:b0:242:481e:467 with SMTP id k15-20020adfd22f000000b00242481e0467mr14800510wrh.72.1670484170796;
        Wed, 07 Dec 2022 23:22:50 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m188-20020a1c26c5000000b003d1d5a83b2esm3829822wmm.35.2022.12.07.23.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 23:22:50 -0800 (PST)
Date:   Thu, 8 Dec 2022 10:22:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev,
        Steve Sistare <steven.sistare@oracle.com>, kvm@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: Re: [PATCH V1 8/8] vfio/type1: change dma owner
Message-ID: <202212081401.mUeUos7m-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-9-git-send-email-steven.sistare@oracle.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steve-Sistare/vfio-virtual-address-update-redo/20221207-055735
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/1670363753-249738-9-git-send-email-steven.sistare%40oracle.com
patch subject: [PATCH V1 8/8] vfio/type1: change dma owner
config: i386-randconfig-m021
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

New smatch warnings:
drivers/vfio/vfio_iommu_type1.c:1546 same_file_mapping() error: uninitialized symbol 'pgoff2'.
drivers/vfio/vfio_iommu_type1.c:1547 same_file_mapping() error: uninitialized symbol 'len2'.
drivers/vfio/vfio_iommu_type1.c:1547 same_file_mapping() error: uninitialized symbol 'flags2'.

vim +/pgoff2 +1546 drivers/vfio/vfio_iommu_type1.c

f42f5cc4de6087 Steve Sistare    2022-12-06  1517  static bool same_file_mapping(struct mm_struct *mm1, unsigned long vaddr1,
f42f5cc4de6087 Steve Sistare    2022-12-06  1518  			      struct mm_struct *mm2, unsigned long vaddr2)
f42f5cc4de6087 Steve Sistare    2022-12-06  1519  {
f42f5cc4de6087 Steve Sistare    2022-12-06  1520  	const unsigned long mask = VM_READ | VM_WRITE | VM_EXEC | VM_SHARED;
f42f5cc4de6087 Steve Sistare    2022-12-06  1521  	struct inode *inode1 = NULL, *inode2 = NULL;
f42f5cc4de6087 Steve Sistare    2022-12-06  1522  	unsigned long pgoff1, len1, flags1;
f42f5cc4de6087 Steve Sistare    2022-12-06  1523  	unsigned long pgoff2, len2, flags2;
f42f5cc4de6087 Steve Sistare    2022-12-06  1524  	struct vm_area_struct *vma;
f42f5cc4de6087 Steve Sistare    2022-12-06  1525  
f42f5cc4de6087 Steve Sistare    2022-12-06  1526  	mmap_read_lock(mm1);
f42f5cc4de6087 Steve Sistare    2022-12-06  1527  	vma = find_vma(mm1, vaddr1);
f42f5cc4de6087 Steve Sistare    2022-12-06  1528  	if (vma && vma->vm_file) {
f42f5cc4de6087 Steve Sistare    2022-12-06  1529  		inode1 = vma->vm_file->f_inode;
f42f5cc4de6087 Steve Sistare    2022-12-06  1530  		pgoff1 = vma->vm_pgoff;
f42f5cc4de6087 Steve Sistare    2022-12-06  1531  		len1 = vma->vm_end - vma->vm_start;
f42f5cc4de6087 Steve Sistare    2022-12-06  1532  		flags1 = vma->vm_flags & mask;
f42f5cc4de6087 Steve Sistare    2022-12-06  1533  	}
f42f5cc4de6087 Steve Sistare    2022-12-06  1534  	mmap_read_unlock(mm1);
f42f5cc4de6087 Steve Sistare    2022-12-06  1535  
f42f5cc4de6087 Steve Sistare    2022-12-06  1536  	mmap_read_lock(mm2);
f42f5cc4de6087 Steve Sistare    2022-12-06  1537  	vma = find_vma(mm2, vaddr2);
f42f5cc4de6087 Steve Sistare    2022-12-06  1538  	if (vma && vma->vm_file) {
f42f5cc4de6087 Steve Sistare    2022-12-06  1539  		inode2 = vma->vm_file->f_inode;
f42f5cc4de6087 Steve Sistare    2022-12-06  1540  		pgoff2 = vma->vm_pgoff;
f42f5cc4de6087 Steve Sistare    2022-12-06  1541  		len2 = vma->vm_end - vma->vm_start;
f42f5cc4de6087 Steve Sistare    2022-12-06  1542  		flags2 = vma->vm_flags & mask;
f42f5cc4de6087 Steve Sistare    2022-12-06  1543  	}
f42f5cc4de6087 Steve Sistare    2022-12-06  1544  	mmap_read_unlock(mm2);
f42f5cc4de6087 Steve Sistare    2022-12-06  1545  
f42f5cc4de6087 Steve Sistare    2022-12-06 @1546  	if (!inode1 || (inode1 != inode2) || (pgoff1 != pgoff2) ||

Presumably the combination of checking !inode1 and inode1 != inode2
prevents an uninitialized variable use, but it's not clear.

f42f5cc4de6087 Steve Sistare    2022-12-06 @1547  	    (len1 != len2) || (flags1 != flags2)) {
f42f5cc4de6087 Steve Sistare    2022-12-06  1548  		pr_debug("vfio vma mismatch for old va %lx vs new va %lx\n",
f42f5cc4de6087 Steve Sistare    2022-12-06  1549  			 vaddr1, vaddr2);
f42f5cc4de6087 Steve Sistare    2022-12-06  1550  		return false;
f42f5cc4de6087 Steve Sistare    2022-12-06  1551  	} else {
f42f5cc4de6087 Steve Sistare    2022-12-06  1552  		return true;
f42f5cc4de6087 Steve Sistare    2022-12-06  1553  	}
f42f5cc4de6087 Steve Sistare    2022-12-06  1554  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

