Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41F52993A6
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776000AbgJZRVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:21:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733033AbgJZRVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:21:52 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QH4Us3024592;
        Mon, 26 Oct 2020 13:21:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g+Ifd7mrXCvbxXWux+peCk/vtLHzslD9kpY+WNVM6SA=;
 b=HdFehZEYxVLAXgU34uAYmsCk4gGaA67EHtAmT7EeeP0KIStHPSVMIh5ral/1QhniGRGj
 UBBuWyB7epnC99H8SSYWMZZg5NtzuL0nOuC9KaBskg53+sEYAgJm9ths2nqp8YAFCtgQ
 HIMISQMLUTiHL61OTwRzSLdgbhtrFXu8yHWJvA224piufOyC+ypswZEXU/VQiy+SZuxV
 fjoLLR9FGun9730wBNgAVgp9MK/GG8DEnNTXe/3N4AZn4cCgTLAm6ck/VI+sIpfUN+bK
 BnbMB+96UEsP33/ojjtkoEvAqMRIEEMUpdfJutVlLPiKiNEB8Dnc/I06N8kszWM8FQrs KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dsmmruf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 13:21:50 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QH5Jns028638;
        Mon, 26 Oct 2020 13:21:50 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dsmmrueu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 13:21:50 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QHH0hN029102;
        Mon, 26 Oct 2020 17:21:49 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 34e1gn8mrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 17:21:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QHLgbD3867378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 17:21:42 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CFDE13604F;
        Mon, 26 Oct 2020 17:21:47 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AEDE136053;
        Mon, 26 Oct 2020 17:21:46 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.190.62])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 17:21:46 +0000 (GMT)
Subject: Re: [PATCH v11 12/14] s390/vfio-ap: handle host AP config change
 notification
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <20201022171209.19494-13-akrowiak@linux.ibm.com>
 <202010230508.bSSV3BvM-lkp@intel.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <a902bb74-fc43-8d1d-9a18-779ef3608ccf@linux.ibm.com>
Date:   Mon, 26 Oct 2020 13:21:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202010230508.bSSV3BvM-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/22/20 5:17 PM, kernel test robot wrote:
> Hi Tony,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on s390/features]
> [also build test WARNING on linus/master next-20201022]
> [cannot apply to kvms390/next linux/master v5.9]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
> config: s390-allyesconfig (attached as .config)
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
> All warnings (new ones prefixed by >>):
>
>     drivers/s390/crypto/vfio_ap_ops.c:1316:5: warning: no previous prototype for 'vfio_ap_mdev_reset_queue' [-Wmissing-prototypes]
>      1316 | int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>           |     ^~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c:1568:6: warning: no previous prototype for 'vfio_ap_mdev_hot_unplug_queue' [-Wmissing-prototypes]
>      1568 | void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c: In function 'vfio_ap_mdev_on_cfg_remove':
>>> drivers/s390/crypto/vfio_ap_ops.c:1777:7: warning: variable 'unassigned' set but not used [-Wunused-but-set-variable]
>      1777 |  bool unassigned = false;
>           |       ^~~~~~~~~~
>     drivers/s390/crypto/vfio_ap_ops.c: At top level:
>>> drivers/s390/crypto/vfio_ap_ops.c:1813:6: warning: no previous prototype for 'vfio_ap_mdev_on_cfg_add' [-Wmissing-prototypes]
>      1813 | void vfio_ap_mdev_on_cfg_add(void)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~

Needs to be static, will fix.

>     In file included from drivers/s390/crypto/vfio_ap_ops.c:11:
>     In function 'memcpy',
>         inlined from 'vfio_ap_mdev_unassign_apids' at drivers/s390/crypto/vfio_ap_ops.c:1655:3,
>         inlined from 'vfio_ap_mdev_on_cfg_remove' at drivers/s390/crypto/vfio_ap_ops.c:1800:8,
>         inlined from 'vfio_ap_on_cfg_changed' at drivers/s390/crypto/vfio_ap_ops.c:1836:2:
>     include/linux/string.h:402:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
>       402 |    __read_overflow2();
>           |    ^~~~~~~~~~~~~~~~~~

Will replace memcpy with bitmap_copy.

>
> vim +/unassigned +1777 drivers/s390/crypto/vfio_ap_ops.c
>
>    1774	
>    1775	static void vfio_ap_mdev_on_cfg_remove(void)
>    1776	{
>> 1777		bool unassigned = false;
>    1778		int ap_remove, aq_remove;
>    1779		struct ap_matrix_mdev *matrix_mdev;
>    1780		DECLARE_BITMAP(apid_rem, AP_DEVICES);
>    1781		DECLARE_BITMAP(apqi_rem, AP_DOMAINS);
>    1782		unsigned long *cur_apm, *cur_aqm, *prev_apm, *prev_aqm;
>    1783	
>    1784		cur_apm = (unsigned long *)matrix_dev->config_info.apm;
>    1785		cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
>    1786		prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
>    1787		prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
>    1788	
>    1789		ap_remove = bitmap_andnot(apid_rem, prev_apm, cur_apm, AP_DEVICES);
>    1790		aq_remove = bitmap_andnot(apqi_rem, prev_aqm, cur_aqm, AP_DOMAINS);
>    1791	
>    1792		if (!ap_remove && !aq_remove)
>    1793			return;
>    1794	
>    1795		list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>    1796			if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>    1797				continue;
>    1798	
>    1799			if (ap_remove) {
>    1800				if (vfio_ap_mdev_unassign_apids(matrix_mdev, apid_rem))
>    1801					unassigned = true;
>    1802				vfio_ap_mdev_unlink_apids(matrix_mdev, apid_rem);
>    1803			}
>    1804	
>    1805			if (aq_remove) {
>    1806				if (vfio_ap_mdev_unassign_apqis(matrix_mdev, apqi_rem))
>    1807					unassigned = true;
>    1808				vfio_ap_mdev_unlink_apqis(matrix_mdev, apqi_rem);
>    1809			}
>    1810		}
>    1811	}
>    1812	
>> 1813	void vfio_ap_mdev_on_cfg_add(void)
>    1814	{
>    1815		unsigned long *cur_apm, *cur_aqm, *prev_apm, *prev_aqm;
>    1816	
>    1817		cur_apm = (unsigned long *)matrix_dev->config_info.apm;
>    1818		cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
>    1819	
>    1820		prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
>    1821		prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
>    1822	
>    1823		bitmap_andnot(matrix_dev->ap_add, cur_apm, prev_apm, AP_DEVICES);
>    1824		bitmap_andnot(matrix_dev->aq_add, cur_aqm, prev_aqm, AP_DOMAINS);
>    1825	}
>    1826	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

