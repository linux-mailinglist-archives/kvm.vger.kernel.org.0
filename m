Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38112583237
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiG0Sm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiG0SmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 14:42:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4249A4E850;
        Wed, 27 Jul 2022 10:39:27 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RHGbsc031733;
        Wed, 27 Jul 2022 17:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PGNr+W/tDeCvxXs8XOO+xvV8eQfBVwnBD+0wayRjodc=;
 b=MEjv/m7736mmycXXAIdW8aadQXth0uyn/166Xj1VPPi22NfHmodLGr0UaBl5xWXNpq7M
 Y7LpDzZtqlvTB5hIK6JOgKrggHoCa0cMWMJSJ0I+tZgTSblnSoY4FeCrTQDajviOStjg
 7SY+DBovb1ehbmhRPSNiaVLL6oDGorrq31u2j7xP+7eqoy/rkhRdAyZBwFM8Ijg2ltps
 AIWrOfaTNzUPgnkDdd3EvmmEl8wW3GTylQuwfndm5F37DAYE2IjWXiy4+Zkb5WWt3HEO
 WQPVVJKAYiIYVx7lkKzxpkS4B+MC4GxsmQ6J1BeLLZGWr7cnRdhehcvEw+bIjWB067nh bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk9mc8sx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:39:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26RHH0pa032480;
        Wed, 27 Jul 2022 17:39:24 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk9mc8sw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:39:24 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26RHZLfx027516;
        Wed, 27 Jul 2022 17:39:23 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3hg98a159h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:39:23 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26RHdMlE38469892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 17:39:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23033136051;
        Wed, 27 Jul 2022 17:39:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C59313604F;
        Wed, 27 Jul 2022 17:39:21 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.142.12])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jul 2022 17:39:20 +0000 (GMT)
Message-ID: <e47029a2689e2075bfe4d78c9a10ea23df7aa219.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio/ccw: Add length to DMA_UNMAP checks
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Wed, 27 Jul 2022 13:39:20 -0400
In-Reply-To: <08dfc4b6-9b75-d519-4d59-319badb1fb9e@linux.ibm.com>
References: <20220726150123.2567761-1-farman@linux.ibm.com>
         <20220726150123.2567761-2-farman@linux.ibm.com>
         <74db2158-a334-abb7-d93e-158b97305a57@linux.ibm.com>
         <82a08af9dd2d83537d20e26416bf99148fdd94f9.camel@linux.ibm.com>
         <08dfc4b6-9b75-d519-4d59-319badb1fb9e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mzGIyuC9xVQyr4KDbErnyrGtmChr9yYX
X-Proofpoint-GUID: Pet5WA_gWheP2GdRHXarEfwX9AH2ZY9m
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_06,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-27 at 13:16 -0400, Matthew Rosato wrote:
> On 7/27/22 12:45 PM, Eric Farman wrote:
> > On Tue, 2022-07-26 at 12:12 -0400, Matthew Rosato wrote:
> > > On 7/26/22 11:01 AM, Eric Farman wrote:
> > > > As pointed out with the simplification of the
> > > > VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
> > > > parameter was never used to check against the pinned
> > > > pages.
> > > > 
> > > > Let's correct that, and see if a page is within the
> > > > affected range instead of simply the first page of
> > > > the range.
> > > > 
> > > > [1]
> > > > https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
> > > > 
> > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > ---
> > > >    drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++----
> > > >    drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
> > > >    drivers/s390/cio/vfio_ccw_ops.c |  2 +-
> > > >    3 files changed, 9 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> > > > b/drivers/s390/cio/vfio_ccw_cp.c
> > > > index 8963f452f963..f15b5114abd1 100644
> > > > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > > > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > > > @@ -170,12 +170,14 @@ static void page_array_unpin_free(struct
> > > > page_array *pa, struct vfio_device *vde
> > > >    	kfree(pa->pa_iova);
> > > >    }
> > > >    
> > > > -static bool page_array_iova_pinned(struct page_array *pa,
> > > > unsigned
> > > > long iova)
> > > > +static bool page_array_iova_pinned(struct page_array *pa,
> > > > unsigned
> > > > long iova,
> > > > +				   unsigned long length)
> > > >    {
> > > >    	int i;
> > > >    
> > > >    	for (i = 0; i < pa->pa_nr; i++)
> > > > -		if (pa->pa_iova[i] == iova)
> > > > +		if (pa->pa_iova[i] >= iova &&
> > > > +		    pa->pa_iova[i] <= iova + length)
> > > 
> > > For the sake of completeness, I think you want to be checking to
> > > make
> > > sure the end of the page is also within the range, not just the
> > > start?
> > > 
> > > if (pa->pa_iova[i] >= iova &&
> > >       pa->pa_iova[i] + PAGE_SIZE <= iova + length)
> > 
> > Well +PAGE_SIZE would iterate to the next page, so that would be
> > captured on the next iteration of the for(i) loop if the pages were
> > contiguous (or not applicable, if the pages weren't).
> 
> FWIW, the '+ PAGE_SIZE' was to match the '+ length' in your
> comparison.
> 
> If you really only want to only look at the start of the pa_iova
> being 
> within the range, then I think you want 'pa->pa_iova[i] < iova + 
> length', not <=.

Touche.

> 
> > But, since the comment is really about the end of the page (0xfff),
> > I
> > guess I'm not understanding what that gets us so perhaps you could
> > help
> > elaborate your question? From my chair, since the pa_iova argument
> > passed to vfio_pin_pages() pins the whole page, checking the start
> > address versus the end (or anywhere in between) should still
> > capture
> > its interaction with an affected range. That is to say, we don't
> > care
> > about the -whole- page being within the unmap range, but -any- part
> > of
> > it.
> > 
> 
> As far as my suggestion to also look at the end of the pa_iova[i] -- 
> This was particularly geared at ensuring the entire page fell within
> the 
> range, not just a subset.  But I think you're right, we don't really 
> care about that.  On the flip side, do we care if the iova somehow 
> starts sometime between pa_iova[i] and pa_iova[i] + PAGE_SIZE - 1?  

As I was mulling your original reply, I was having the same thought. I
think the answer is it's probably unlikely, but was trying to figure
out how to rope something in for that.

> That 
> would still be a subset, though I'm not sure such a thing could
> happen 
> today (e.g. an input 'iova' that is not on a page boundary)..
> 
> I wonder if the simplest thing would be to just copy what gvt does
> and 
> convert to pfn as it takes all of this out of the equation and looks 
> instead at whether the inputs overlaps at a page granularity (which
> is 
> what we really care about)

Agreed.

> , e.g. something like (untested):

Ha. This is almost exactly what I had in place originally, before I
applied Nicolin's series and the pfns were still available in the
struct that pa points to. I should have left that all in place instead
of cleaning it up this way. Let me get that refit and doublechecked,
and I'll send a v2. Thanks!

> 
> u64 iov_pfn = iova >> PAGE_SHIFT;
> u64 end_iov_pfn = iov_pfn + (length / PAGE_SIZE);
> u64 pfn;
> int i;
> 
> for (i = 0; i < pa->pa_nr; i++) {
>     pfn = pa->pa_iova[i] >> PAGE_SHIFT;
>     if (pfn >= iov_pfn && pfn < end_iov_pfn)
> 	return true;
> }
> 
> 
> 

