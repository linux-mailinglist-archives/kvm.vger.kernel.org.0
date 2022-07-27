Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5356B5831C6
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 20:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiG0SQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 14:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243399AbiG0SQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 14:16:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97058E0D52;
        Wed, 27 Jul 2022 10:17:02 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RGBsUJ028074;
        Wed, 27 Jul 2022 17:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ros1bcOlSjpGOVrvaT2AfaCUphW/rcQ3EopPo28iFNU=;
 b=KTVsAsfS69EdBG/sqWB95cuvobzicMdT0ruMdePRacqQC5JLRJn7kGsgbptnCd8K0SFi
 XsxNvXSIPuQciwK8Zr8HTomV7lxkWiUscTzCBgVHTORbSmhkJojq0Z+UYDQwGgidXOxS
 06kd9f82dxQafzTzuiR86LJEfQTncEs6q0UEW4VoiLu3KGhK7ULBjrCkL5YbQlUMKNQm
 I/rhKlAYuRX8Eo6DHt6Dogff+5Zb7F94KPIKrBI1su+Melmd2B3cV6wHbqAy3Bo27Uyf
 7bth/EZbiZ2DZNqlNXRL0bbXPhvEB98eafKdC1JZbFb2DLo8gOcUfK6kZd/HZUX+e2lb 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk8nyjesy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:17:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26RGCDBO029991;
        Wed, 27 Jul 2022 17:17:00 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk8nyjes3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:16:59 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26RH58HT029271;
        Wed, 27 Jul 2022 17:16:58 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3hg943jgr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 17:16:58 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26RHGw2q328414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 17:16:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19AB628059;
        Wed, 27 Jul 2022 17:16:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8C4A2805A;
        Wed, 27 Jul 2022 17:16:55 +0000 (GMT)
Received: from [9.211.95.8] (unknown [9.211.95.8])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jul 2022 17:16:55 +0000 (GMT)
Message-ID: <08dfc4b6-9b75-d519-4d59-319badb1fb9e@linux.ibm.com>
Date:   Wed, 27 Jul 2022 13:16:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] vfio/ccw: Add length to DMA_UNMAP checks
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220726150123.2567761-1-farman@linux.ibm.com>
 <20220726150123.2567761-2-farman@linux.ibm.com>
 <74db2158-a334-abb7-d93e-158b97305a57@linux.ibm.com>
 <82a08af9dd2d83537d20e26416bf99148fdd94f9.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <82a08af9dd2d83537d20e26416bf99148fdd94f9.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LrBMCDEHbFCBNp_2z5K1g82BBFwK9R-4
X-Proofpoint-GUID: 4_KkoS0PI3SyrjSZoetYDN7P73CGasMn
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_06,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/27/22 12:45 PM, Eric Farman wrote:
> On Tue, 2022-07-26 at 12:12 -0400, Matthew Rosato wrote:
>> On 7/26/22 11:01 AM, Eric Farman wrote:
>>> As pointed out with the simplification of the
>>> VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
>>> parameter was never used to check against the pinned
>>> pages.
>>>
>>> Let's correct that, and see if a page is within the
>>> affected range instead of simply the first page of
>>> the range.
>>>
>>> [1]
>>> https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>    drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++----
>>>    drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>>>    drivers/s390/cio/vfio_ccw_ops.c |  2 +-
>>>    3 files changed, 9 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index 8963f452f963..f15b5114abd1 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -170,12 +170,14 @@ static void page_array_unpin_free(struct
>>> page_array *pa, struct vfio_device *vde
>>>    	kfree(pa->pa_iova);
>>>    }
>>>    
>>> -static bool page_array_iova_pinned(struct page_array *pa, unsigned
>>> long iova)
>>> +static bool page_array_iova_pinned(struct page_array *pa, unsigned
>>> long iova,
>>> +				   unsigned long length)
>>>    {
>>>    	int i;
>>>    
>>>    	for (i = 0; i < pa->pa_nr; i++)
>>> -		if (pa->pa_iova[i] == iova)
>>> +		if (pa->pa_iova[i] >= iova &&
>>> +		    pa->pa_iova[i] <= iova + length)
>>
>> For the sake of completeness, I think you want to be checking to
>> make
>> sure the end of the page is also within the range, not just the
>> start?
>>
>> if (pa->pa_iova[i] >= iova &&
>>       pa->pa_iova[i] + PAGE_SIZE <= iova + length)
> 
> Well +PAGE_SIZE would iterate to the next page, so that would be
> captured on the next iteration of the for(i) loop if the pages were
> contiguous (or not applicable, if the pages weren't).

FWIW, the '+ PAGE_SIZE' was to match the '+ length' in your comparison.

If you really only want to only look at the start of the pa_iova being 
within the range, then I think you want 'pa->pa_iova[i] < iova + 
length', not <=.

> 
> But, since the comment is really about the end of the page (0xfff), I
> guess I'm not understanding what that gets us so perhaps you could help
> elaborate your question? From my chair, since the pa_iova argument
> passed to vfio_pin_pages() pins the whole page, checking the start
> address versus the end (or anywhere in between) should still capture
> its interaction with an affected range. That is to say, we don't care
> about the -whole- page being within the unmap range, but -any- part of
> it.
> 

As far as my suggestion to also look at the end of the pa_iova[i] -- 
This was particularly geared at ensuring the entire page fell within the 
range, not just a subset.  But I think you're right, we don't really 
care about that.  On the flip side, do we care if the iova somehow 
starts sometime between pa_iova[i] and pa_iova[i] + PAGE_SIZE - 1?  That 
would still be a subset, though I'm not sure such a thing could happen 
today (e.g. an input 'iova' that is not on a page boundary)..

I wonder if the simplest thing would be to just copy what gvt does and 
convert to pfn as it takes all of this out of the equation and looks 
instead at whether the inputs overlaps at a page granularity (which is 
what we really care about), e.g. something like (untested):

u64 iov_pfn = iova >> PAGE_SHIFT;
u64 end_iov_pfn = iov_pfn + (length / PAGE_SIZE);
u64 pfn;
int i;

for (i = 0; i < pa->pa_nr; i++) {
    pfn = pa->pa_iova[i] >> PAGE_SHIFT;
    if (pfn >= iov_pfn && pfn < end_iov_pfn)
	return true;
}



