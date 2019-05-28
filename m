Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7F02C983
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfE1PFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 11:05:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfE1PFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 11:05:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SF4QUp083027;
        Tue, 28 May 2019 15:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=G9vBM5THlG8pywNzVbsKIK8sbELnMUDNM7aCaLdslP0=;
 b=bgq/F8b/2xwUVXMlsJqTT/j8YvUXLiDeS1H4MJ+nX4NOQ5xuZxuO5UeAXzVEoTG1w3bf
 iu6Ce7E+Lhxw9casXB7xzxnF/LglbRQEC8Hux6StMYE/xjblB+T7bJ8nOxdBonl07JjK
 i4LWZr8dbuD44I3nkitg/rpMislB3CGkymXU4mlpDIqIm+8/2CgEmV0kh75+vCfvC2L4
 Z8Adu0/Y0OQ8FReXSRrA1zB1u+Z7W4E2Dt6b4GdDgXE31SyMNMgBPdc0LZpdUzdIuZHh
 ka4eUEOZ3WXQdsjyQL6SgjVs8mBV0FmA9pPrU0yOOD7DKhfxFyHFYXk1s/ronu4hv6Mr 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2spw4tbtqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 15:04:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SF3Kh9017458;
        Tue, 28 May 2019 15:04:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ss1fmwp16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 15:04:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4SF4OV0025272;
        Tue, 28 May 2019 15:04:24 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 08:04:24 -0700
Date:   Tue, 28 May 2019 11:04:24 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alan Tull <atull@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: add account_locked_vm utility function
Message-ID: <20190528150424.tjbaiptpjhzg7y75@ca-dmjordan1.us.oracle.com>
References: <de375582-2c35-8e8a-4737-c816052a8e58@ozlabs.ru>
 <20190524175045.26897-1-daniel.m.jordan@oracle.com>
 <20190525145118.bfda2d75a14db05a001e49ad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190525145118.bfda2d75a14db05a001e49ad@linux-foundation.org>
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9270 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=18 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905280098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9270 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905280098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 25, 2019 at 02:51:18PM -0700, Andrew Morton wrote:
> On Fri, 24 May 2019 13:50:45 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> 
> > locked_vm accounting is done roughly the same way in five places, so
> > unify them in a helper.  Standardize the debug prints, which vary
> > slightly, but include the helper's caller to disambiguate between
> > callsites.
> > 
> > Error codes stay the same, so user-visible behavior does too.  The one
> > exception is that the -EPERM case in tce_account_locked_vm is removed
> > because Alexey has never seen it triggered.
> > 
> > ...
> >
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1564,6 +1564,25 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
> >  int get_user_pages_fast(unsigned long start, int nr_pages,
> >  			unsigned int gup_flags, struct page **pages);
> >  
> > +int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
> > +			struct task_struct *task, bool bypass_rlim);
> > +
> > +static inline int account_locked_vm(struct mm_struct *mm, unsigned long pages,
> > +				    bool inc)
> > +{
> > +	int ret;
> > +
> > +	if (pages == 0 || !mm)
> > +		return 0;
> > +
> > +	down_write(&mm->mmap_sem);
> > +	ret = __account_locked_vm(mm, pages, inc, current,
> > +				  capable(CAP_IPC_LOCK));
> > +	up_write(&mm->mmap_sem);
> > +
> > +	return ret;
> > +}
> 
> That's quite a mouthful for an inlined function.  How about uninlining
> the whole thing and fiddling drivers/vfio/vfio_iommu_type1.c to suit. 
> I wonder why it does down_write_killable and whether it really needs
> to...

Sure, I can uninline it.  vfio changelogs don't show a particular reason for
_killable[1].  Maybe Alex has something to add.  Otherwise I'll respin without
it since the simplification seems worth removing _killable.

[1] 0cfef2b7410b ("vfio/type1: Remove locked page accounting workqueue")
