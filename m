Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCEE2ED36E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbhAGPUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 10:20:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbhAGPUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 10:20:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FFUMo130563;
        Thu, 7 Jan 2021 15:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7qXRLgu/lX7JHrJYHGvjHopNWdY8iSEi1z5q0Jj7omc=;
 b=wH/yJ2aJENSOIuR6+wddEdzlb2xWvpsgYgs23o11U7sOItmLFoOwj58PnC008yZATb4u
 raGrsEXxuwiIJxxsFjNoFMPJxx3SCB8UtT/17p5stFlvn563Xslvd31s0yuQsr+0sAj7
 F3ay0cb/dO10IW6c+r7/+nq/EpJijw+9KLbLhCXfSSNviv44IjG4T1rBht2QcHLgp4DU
 QPq+r05EQivOUQ9GwRIC+A+3Qs1iox048PijGssb/lvSBlGKor5lAT+0T60U/S+kE0CC
 BtIaUiM+a9tERwprqEkwpMhzVj0O6QN8ablCd1yefPkw8kJsNwMQ+rLE82jVdFTasP62 Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxw6g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 15:19:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FActW130897;
        Thu, 7 Jan 2021 15:17:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35w3qtuvj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 15:17:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107FHiK8010677;
        Thu, 7 Jan 2021 15:17:44 GMT
Received: from [10.39.247.197] (/10.39.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 15:17:44 +0000
Subject: Re: [PATCH V1 5/5] vfio: block during VA suspend
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
 <202101060351.XqLDTP2F-lkp@intel.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <2d462b92-bc3f-e9b0-6a05-69b1192d4fca@oracle.com>
Date:   Thu, 7 Jan 2021 10:17:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <202101060351.XqLDTP2F-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will fix the warnings in V2, and make W=1 C=1 for all my submissions!

- Steve

On 1/5/2021 3:03 PM, kernel test robot wrote:
> Hi Steve,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on vfio/next]
> [also build test WARNING on v5.11-rc2 next-20210104]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Steve-Sistare/vfio-virtual-address-update/20210106-000752
> base:   https://github.com/awilliam/linux-vfio.git next
> config: x86_64-randconfig-s022-20210105 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.3-208-g46a52ca4-dirty
>         # https://github.com/0day-ci/linux/commit/f680b8156755f4465e94574d5421747561d23749
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Steve-Sistare/vfio-virtual-address-update/20210106-000752
>         git checkout f680b8156755f4465e94574d5421747561d23749
>         # save the attached .config to linux build tree
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> "sparse warnings: (new ones prefixed by >>)"
>    drivers/vfio/vfio_iommu_type1.c:163:32: sparse: sparse: Using plain integer as NULL pointer
>    drivers/vfio/vfio_iommu_type1.c:179:23: sparse: sparse: Using plain integer as NULL pointer
>>> drivers/vfio/vfio_iommu_type1.c:503:6: sparse: sparse: symbol 'vfio_vaddr_valid' was not declared. Should it be static?
> 
> Please review and possibly fold the followup patch.
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
