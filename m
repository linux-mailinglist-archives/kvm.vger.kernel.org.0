Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9062E49B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfE2SjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 14:39:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2SjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 14:39:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TIXRk1051803;
        Wed, 29 May 2019 18:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=THamC/necnAG3k0b6m2lzotQxZzYf7wS5P936VQIGeY=;
 b=WrBZnM6ZmVcJlPylNNIR/dfOAgxQ1n5mBVtox4d3xjQyTPWqyy6eMNHnrmBnlkjatlvA
 uGOysuC9TQIkhHoRn4A0EY8PusDh25gpV/Wi4bOglzrKwaHlZYMsOaCkMAEh7Oc1zG4H
 o5aBY3h0pke87yaD6FFtpEWCGOFT3e22OuLLNMpFqQBRqJf1s1U9+ZhsZbUHtiEJimhk
 CCZzlWi4wabkYmp44sPv7LEg5Mh5sXvNW2aC2mg7bGejM8GPo82kSDE92MGxM5yTU4Sv
 FYNjz+9EfB1A2l+UFVFPM/S+5WCUb8cfNrvM8MGDkLXLQ+KQUnKnAuC5N9DwD7JNDbJI ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2spw4tktvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 18:38:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TIa26f039849;
        Wed, 29 May 2019 18:36:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sr31ve7qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 18:36:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TIZxGZ002287;
        Wed, 29 May 2019 18:35:59 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 11:35:59 -0700
Date:   Wed, 29 May 2019 14:35:59 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        akpm@linux-foundation.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
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
Message-ID: <20190529183559.jzkpvbdiimnp3n2m@ca-dmjordan1.us.oracle.com>
References: <de375582-2c35-8e8a-4737-c816052a8e58@ozlabs.ru>
 <20190524175045.26897-1-daniel.m.jordan@oracle.com>
 <20190529180547.GA16182@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529180547.GA16182@iweiny-DESK2.sc.intel.com>
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=18 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 11:05:48AM -0700, Ira Weiny wrote:
> On Fri, May 24, 2019 at 01:50:45PM -0400, Daniel Jordan wrote:
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
> > +
...snip...
> > +/**
> > + * __account_locked_vm - account locked pages to an mm's locked_vm
> > + * @mm:          mm to account against, may be NULL
> 
> This kernel doc is wrong.  You dereference mm straight away...
...snip...
> > +
> > +	locked_vm = mm->locked_vm;
> 
> here...
> 
> Perhaps the comment was meant to document account_locked_vm()?

Yes, the comment got out of sync when I moved the !mm check outside
__account_locked_vm.  Thanks for catching, will fix.
