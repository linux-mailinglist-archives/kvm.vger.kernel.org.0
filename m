Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC025A6D2
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 09:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIBHcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 03:32:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgIBHcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 03:32:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0827SsJw042596;
        Wed, 2 Sep 2020 07:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LOa0MTE9JnpSlmp0hUB9HpW3GCi056gX/ikmNfam33c=;
 b=SN0DRME4qRWm2a6B2mA/NOiyGDEXm7Bx/04N//GHQwMHXLSbOi0oMZTlsNtC3zbr7a6b
 2KhBrDpZGlVHvBcKz2OCt1Y8T5zClfcTlTSooE75uJPpAByFX1Nsch5jFpMyaOO5M261
 mAab8zq81Ka8r6J9VKMWMwTkwJ+DxVeQ2gWhy8YTlcckccUXRKlnNBtPq00BGuIMxXHY
 4DUVrkjA0ijmcP+h1EaBnRFyijVOsHD98wnHwkDBLUfQOuY4ueinybXwTn8KV5if5YX8
 VyCGq+mxLVmvV+v7MtpZb6YJYsEd9y7C0VK737OGp/AtRZt252PbgOtno+DFVQgA3pog xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eer0txu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 07:31:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0827UfK5055122;
        Wed, 2 Sep 2020 07:31:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x5ujbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 07:31:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0827VtcI011694;
        Wed, 2 Sep 2020 07:31:56 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 00:31:55 -0700
Date:   Wed, 2 Sep 2020 10:31:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kbuild@lists.01.org, Aaron Lewis <aaronlewis@google.com>,
        jmattson@google.com, lkp@intel.com, kbuild-all@lists.01.org,
        pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        KarimAllah Ahmed <karahmed@amazon.de>
Subject: Re: [PATCH v3 02/12] KVM: x86: Introduce allow list for MSR emulation
Message-ID: <20200902073147.GI8321@kadam>
References: <20200831103933.GF8299@kadam>
 <79dd5f72-a332-a657-674d-f3a9c94146f1@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79dd5f72-a332-a657-674d-f3a9c94146f1@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 09:13:10PM +0200, Alexander Graf wrote:
> 
> 
> On 31.08.20 12:39, Dan Carpenter wrote:
> > 
> > Hi Aaron,
> > 
> > url:    https://github.com/0day-ci/linux/commits/Aaron-Lewis/Allow-userspace-to-manage-MSRs/20200819-051903
> > base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git  linux-next
> > config: x86_64-randconfig-m001-20200827 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Thanks a bunch for looking at this! I'd squash in the change with the actual
> patch as it's tiny, so I'm not sure how attribution would work in that case.

Yep.  No problem.  These are just a template that gets sent to everyone.

> 
> > 
> > smatch warnings:
> > arch/x86/kvm/x86.c:5248 kvm_vm_ioctl_add_msr_allowlist() error: 'bitmap' dereferencing possible ERR_PTR()
> > 
> > # https://github.com/0day-ci/linux/commit/107c87325cf461b7b1bd07bb6ddbaf808a8d8a2a
> > git remote add linux-review https://github.com/0day-ci/linux git fetch
> > --no-tags linux-review
> > Aaron-Lewis/Allow-userspace-to-manage-MSRs/20200819-051903
> > git checkout 107c87325cf461b7b1bd07bb6ddbaf808a8d8a2a
> > vim +/bitmap +5248 arch/x86/kvm/x86.c
> > 
> > 107c87325cf461 Aaron Lewis 2020-08-18  5181  static int kvm_vm_ioctl_add_msr_allowlist(struct kvm *kvm, void __user *argp)
> > 107c87325cf461 Aaron Lewis 2020-08-18  5182  {
> > 107c87325cf461 Aaron Lewis 2020-08-18  5183     struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5184     struct kvm_msr_allowlist __user *user_msr_allowlist = argp;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5185     struct msr_bitmap_range range;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5186     struct kvm_msr_allowlist kernel_msr_allowlist;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5187     unsigned long *bitmap = NULL;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5188     size_t bitmap_size;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5189     int r = 0;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5190
> > 107c87325cf461 Aaron Lewis 2020-08-18  5191     if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
> > 107c87325cf461 Aaron Lewis 2020-08-18  5192                        sizeof(kernel_msr_allowlist))) {
> > 107c87325cf461 Aaron Lewis 2020-08-18  5193             r = -EFAULT;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5194             goto out;
> > 107c87325cf461 Aaron Lewis 2020-08-18  5195     }
> > 107c87325cf461 Aaron Lewis 2020-08-18  5196
> > 107c87325cf461 Aaron Lewis 2020-08-18  5197     bitmap_size = BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
> >                                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^n
> > On 32 bit systems the BITS_TO_LONGS() can integer overflow if
> > kernel_msr_allowlist.nmsrs is larger than ULONG_MAX - bits_per_long.  In
> > that case bitmap_size is zero.
> 
> Nice catch! It should be enough to ...
> 
> > 
> > 107c87325cf461 Aaron Lewis 2020-08-18  5198     if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
> 
> ... add a check for !bitmap_size here as well then, right?

Yup.

regards,
dan carpenter

