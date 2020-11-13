Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9442B2B2636
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 22:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKMVGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 16:06:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbgKMVGe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 16:06:34 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADL2UPW007740;
        Fri, 13 Nov 2020 16:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bZcV74Uia22ODAVbadbhWk4gKJDekDGniQvx3ed1vcw=;
 b=L1yTVX4MSBFHtqUPj/zC9HclI6qudQXVqonV0s1q8GWf2yT2ncX9+8meuejiYugloWFx
 3iz8Ve825C95TICbvL+3aBsfG3zL3SYVwCyLKHIXGB5oFflnUtU1SeyVmoa/VtqXg/Pc
 zy6iqL6RifrJ+tojYUOLwh6YnqKXTtYFBWyXKjmCZC4EUErX9NN7hzQuzTqV9wwQWNli
 uXdmmqBa+0Ium/PgaYPIR+W+dXRi1g7+8TSiW1R+cN32bTI270l8VbDcRedVWQLzZbOM
 sZ5mkxnG1wUUe9jC8xKk5pi+EQZ1wL4chQQrKIdQdVwpCtg95PUAzWQuL/us/nggAuQj xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34t0jr21n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 16:06:31 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADL3ov8017669;
        Fri, 13 Nov 2020 16:06:31 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34t0jr21mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 16:06:31 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADL3WgS004380;
        Fri, 13 Nov 2020 21:06:30 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 34nk7ak82j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 21:06:30 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADL6T477996090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 21:06:29 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023596A054;
        Fri, 13 Nov 2020 21:06:29 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD4C36A04F;
        Fri, 13 Nov 2020 21:06:27 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 21:06:27 +0000 (GMT)
Subject: Re: [PATCH v11 12/14] s390/vfio-ap: handle host AP config change
 notification
To:     kernel test robot <lkp@intel.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <20201022171209.19494-13-akrowiak@linux.ibm.com>
 <202011031740.6Uu0Z5yG-lkp@intel.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <7507e3aa-699b-05a7-1a45-d9c0b8a40003@linux.ibm.com>
Date:   Fri, 13 Nov 2020 16:06:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202011031740.6Uu0Z5yG-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_17:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed the errors.

On 11/3/20 4:48 AM, kernel test robot wrote:
> Hi Tony,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on s390/features]
> [also build test ERROR on linus/master v5.10-rc2 next-20201103]
> [cannot apply to kvms390/next linux/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
> config: s390-allmodconfig (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/32786ef6d4ba3703d993a8894ea1d763785fd3a4
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
>          git checkout 32786ef6d4ba3703d993a8894ea1d763785fd3a4
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     drivers/s390/crypto/vfio_ap_ops.c:1316:5: warning: no previous prototype for 'vfio_ap_mdev_reset_queue' [-Wmissing-prototypes]
>      1316 | int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>           |     ^~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c:1568:6: warning: no previous prototype for 'vfio_ap_mdev_hot_unplug_queue' [-Wmissing-prototypes]
>      1568 | void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c: In function 'vfio_ap_mdev_on_cfg_remove':
>     drivers/s390/crypto/vfio_ap_ops.c:1777:7: warning: variable 'unassigned' set but not used [-Wunused-but-set-variable]
>      1777 |  bool unassigned = false;
>           |       ^~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c: At top level:
>     drivers/s390/crypto/vfio_ap_ops.c:1813:6: warning: no previous prototype for 'vfio_ap_mdev_on_cfg_add' [-Wmissing-prototypes]
>      1813 | void vfio_ap_mdev_on_cfg_add(void)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~
>     In file included from drivers/s390/crypto/vfio_ap_ops.c:11:
>     In function 'memcpy',
>         inlined from 'vfio_ap_mdev_unassign_apids' at drivers/s390/crypto/vfio_ap_ops.c:1655:3,
>         inlined from 'vfio_ap_mdev_on_cfg_remove' at drivers/s390/crypto/vfio_ap_ops.c:1800:8,
>         inlined from 'vfio_ap_on_cfg_changed' at drivers/s390/crypto/vfio_ap_ops.c:1836:2:
>>> include/linux/string.h:402:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
>       402 |    __read_overflow2();
>           |    ^~~~~~~~~~~~~~~~~~
>
> vim +/__read_overflow2 +402 include/linux/string.h
>
> 6974f0c4555e285 Daniel Micay  2017-07-12  393
> 6974f0c4555e285 Daniel Micay  2017-07-12  394  __FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
> 6974f0c4555e285 Daniel Micay  2017-07-12  395  {
> 6974f0c4555e285 Daniel Micay  2017-07-12  396  	size_t p_size = __builtin_object_size(p, 0);
> 6974f0c4555e285 Daniel Micay  2017-07-12  397  	size_t q_size = __builtin_object_size(q, 0);
> 6974f0c4555e285 Daniel Micay  2017-07-12  398  	if (__builtin_constant_p(size)) {
> 6974f0c4555e285 Daniel Micay  2017-07-12  399  		if (p_size < size)
> 6974f0c4555e285 Daniel Micay  2017-07-12  400  			__write_overflow();
> 6974f0c4555e285 Daniel Micay  2017-07-12  401  		if (q_size < size)
> 6974f0c4555e285 Daniel Micay  2017-07-12 @402  			__read_overflow2();
> 6974f0c4555e285 Daniel Micay  2017-07-12  403  	}
> 6974f0c4555e285 Daniel Micay  2017-07-12  404  	if (p_size < size || q_size < size)
> 6974f0c4555e285 Daniel Micay  2017-07-12  405  		fortify_panic(__func__);
> 47227d27e2fcb01 Daniel Axtens 2020-06-03  406  	return __underlying_memcpy(p, q, size);
> 6974f0c4555e285 Daniel Micay  2017-07-12  407  }
> 6974f0c4555e285 Daniel Micay  2017-07-12  408
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

