Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E221471AB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 20:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAWTVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 14:21:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55648 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAWTVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 14:21:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NJE5RT149228;
        Thu, 23 Jan 2020 19:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=cQAa34safu7RTWXNdnm6nfUDuAEPRdtTWK0vwl0uMl8=;
 b=l6xUQj2qTsQzLk9ROwPPSZoHhpF2PXR6YwtCW+w/7uAwv+NxAvSo+DZY5cajaYkM0gQX
 zjW6jf5oe1ubqgj7hp5i23qgAO9qHHrtsYtvzDi/2U7/QwLfyRcxsYlbEUzzywlRlnev
 Or+gQ/hjt2j7Uo896OXvtjU9hxpiGof4/UDPM8gFECyBbGpvfDdfN86FmqpWMF7WLXHg
 scg7cmoMHQ3YVw/ijXxBFVyLJV+gJokpkNBQMOc/vFf7BXvpDb1Oz0bTIKdSaBZOr/YW
 jU78OfmLH55rSApu5swe4xXtbebHBbyK0MWu8r01LcGJS8d8cnzjbA627tAHSckVica0 tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqmfvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 19:20:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NJE0tP170896;
        Thu, 23 Jan 2020 19:20:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xppq8pse2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 19:20:27 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00NJKO34008855;
        Thu, 23 Jan 2020 19:20:24 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 11:20:24 -0800
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 08E6D6A060C; Thu, 23 Jan 2020 14:24:00 -0500 (EST)
Date:   Thu, 23 Jan 2020 14:23:59 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Graf <graf@amazon.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de,
        "Paterson-Jones, Roland" <rolandp@amazon.com>, hannes@cmpxchg.org,
        hare@suse.com, "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
Message-ID: <20200123192359.GB11346@char.us.oracle.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
 <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
 <21444cdc-76f9-1b06-093e-950cbeb4aa1f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21444cdc-76f9-1b06-093e-950cbeb4aa1f@intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 09:20:15AM -0800, Dave Hansen wrote:
> On 1/23/20 8:26 AM, Alexander Duyck wrote:
> >> The big piece I'm missing is the page cache. Linux will by default try 
> >> to keep the free list as small as it can in favor of page cache, so most 
> >> of the benefit of this patch set will be void in real world scenarios.
> > Agreed. This is a the next piece of this I plan to work on once this is
> > accepted. For now the quick and dirty approach is to essentially make use
> > of the /proc/sys/vm/drop_caches interface in the guest by either putting
> > it in a cronjob somewhere or to have it after memory intensive workloads.
> 
> There was an implementation in "Clear Linux" that used this sysctl:
> 
> > https://github.com/Conan-Kudo/omv-kernel-rc/blob/master/0154-sysctl-vm-Fine-grained-cache-shrinking.patch
> 
> (I can't find it in the Clear repos at the moment, must not be used
> currently).  But the idea was to have a little daemon in the host that
> periodically applied some artificial pressure with this sysctl.  This
> sysctl is a smaller hammer than /proc/sys/vm/drop_caches and lets you
> drop small amounts of cache.
> 
> The right way to do it is probably to do real, generic reclaim instead
> of drop_caches.

This  sounds like Transcendent Memory (https://www.linux-kvm.org/images/d/d7/TmemNotVirt-Linuxcon2011-Final.pdf)
which has (which is in the Linux kernel) a driver to push on the swapper
and everything else to evict pages to the hypervisor. 

Look at cleancache and frontswap and xen-selfballoon.c (was removed by
by 814bbf49dcd0ad642e7ceb8991e57555c5472cce)

Avi Kivity pointed out one big issue with all of this - customers have
to be nicely behaved - which they don't seem to be.

But I would recommend you look at cleancache for the page cache.

> 
> This isn't conceptually *that* far away from the "proactive reclaim"
> that other folks have proposed:
> 
> 	https://lwn.net/Articles/787611/
