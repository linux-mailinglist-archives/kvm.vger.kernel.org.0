Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97F8299329
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786718AbgJZQ5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:57:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1786707AbgJZQ5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 12:57:21 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QGY0j3003983;
        Mon, 26 Oct 2020 12:57:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bGuH4VZc8uowe8eSPFVCZk+6FDbMv3vx7xFMnlP36n0=;
 b=pANmEen/q7xQ5zSIb60uzcBJodUZ0u0YJnaF8m0ftnibMJdFvrz/EfqET/xiSZZkJaOG
 cIWyqh4+f4z3Y5YVKTGkQ+PbDxVxILUBTpRRz5hdAhHZRR6t5hNA9tyDq7d2+ffBqwHJ
 2IM3ZWeeEIY+XvcWzZrEQr5F4mlkkc9q8gpiqa6wQ5jx9rCRBiGlI4e3ltHN9+WMNP+L
 2iLuAJiUGKgQmx0wjqVamauxNSxKYFHAaZY0UQhO90DttF9KXPJhLfFsauOJChnnhfTJ
 OgPy1GW2eMJw0hqxUsOHsLv744T4LHGkQijKzQxyUnXlLRPLLtyTLxTdgLluWmCQ/O6w yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34drcu28a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 12:57:16 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QGYEl8005483;
        Mon, 26 Oct 2020 12:57:16 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34drcu289y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 12:57:16 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QGbTR8029623;
        Mon, 26 Oct 2020 16:57:15 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 34cbw8s4fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 16:57:15 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QGv80o39715272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 16:57:08 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF82E6A04F;
        Mon, 26 Oct 2020 16:57:13 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1EAC6A047;
        Mon, 26 Oct 2020 16:57:12 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.190.62])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 16:57:12 +0000 (GMT)
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <20201022171209.19494-2-akrowiak@linux.ibm.com>
 <202010230305.RyRsFmf9-lkp@intel.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8aa98c96-9194-504a-8e00-3354b5ca1d6c@linux.ibm.com>
Date:   Mon, 26 Oct 2020 12:57:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202010230305.RyRsFmf9-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 suspectscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/22/20 3:44 PM, kernel test robot wrote:
> Hi Tony,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on s390/features]
> [also build test WARNING on linus/master kvms390/next linux/master v5.9 next-20201022]
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
>          # https://github.com/0day-ci/linux/commit/572c94c40a76754d49f07e4e383097d2db132f8c
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20201023-011543
>          git checkout 572c94c40a76754d49f07e4e383097d2db132f8c
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=s390
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> drivers/s390/crypto/vfio_ap_ops.c:1119:5: warning: no previous prototype for 'vfio_ap_mdev_reset_queue' [-Wmissing-prototypes]
>      1119 | int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>           |     ^~~~~~~~~~~~~~~~~~~~~~~~

This function needs to be made static because it is no longer defined in 
the header file.

>
> vim +/vfio_ap_mdev_reset_queue +1119 drivers/s390/crypto/vfio_ap_ops.c
>
> 258287c994de8f Tony Krowiak 2018-09-25  1118
> ec89b55e3bce7c Pierre Morel 2019-05-21 @1119  int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1120  			     unsigned int retry)
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1121  {
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1122  	struct ap_queue_status status;
> ec89b55e3bce7c Pierre Morel 2019-05-21  1123  	int retry2 = 2;
> ec89b55e3bce7c Pierre Morel 2019-05-21  1124  	int apqn = AP_MKQID(apid, apqi);
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1125
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1126  	do {
> ec89b55e3bce7c Pierre Morel 2019-05-21  1127  		status = ap_zapq(apqn);
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1128  		switch (status.response_code) {
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1129  		case AP_RESPONSE_NORMAL:
> ec89b55e3bce7c Pierre Morel 2019-05-21  1130  			while (!status.queue_empty && retry2--) {
> ec89b55e3bce7c Pierre Morel 2019-05-21  1131  				msleep(20);
> ec89b55e3bce7c Pierre Morel 2019-05-21  1132  				status = ap_tapq(apqn, NULL);
> ec89b55e3bce7c Pierre Morel 2019-05-21  1133  			}
> 024cdcdbf3cf99 Halil Pasic  2019-09-03  1134  			WARN_ON_ONCE(retry2 <= 0);
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1135  			return 0;
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1136  		case AP_RESPONSE_RESET_IN_PROGRESS:
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1137  		case AP_RESPONSE_BUSY:
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1138  			msleep(20);
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1139  			break;
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1140  		default:
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1141  			/* things are really broken, give up */
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1142  			return -EIO;
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1143  		}
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1144  	} while (retry--);
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1145
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1146  	return -EBUSY;
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1147  }
> 46a7263d4746a2 Tony Krowiak 2018-09-25  1148
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

