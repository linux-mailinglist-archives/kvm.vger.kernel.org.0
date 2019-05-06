Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80AA1500A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEFPX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 11:23:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfEFPX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 11:23:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46FIG5G043231
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 11:23:58 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sap6qm0xj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 11:23:58 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 6 May 2019 16:23:57 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 16:23:55 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46FNrJ019071030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 15:23:53 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77968C605B;
        Mon,  6 May 2019 15:23:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F9D5C6055;
        Mon,  6 May 2019 15:23:52 +0000 (GMT)
Received: from [9.85.230.129] (unknown [9.85.230.129])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 15:23:52 +0000 (GMT)
Subject: Re: [PATCH 1/7] s390/cio: Update SCSW if it points to the end of the
 chain
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-2-farman@linux.ibm.com>
 <20190506164710.5fe0b6c8.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Mon, 6 May 2019 11:23:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506164710.5fe0b6c8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050615-8235-0000-0000-00000E90143C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011060; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199451; UDB=6.00629266; IPR=6.00980327;
 MB=3.00026754; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 15:23:56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050615-8236-0000-0000-000045728D08
Message-Id: <d879574f-176f-1403-54dd-08911cbfc90a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/19 10:47 AM, Cornelia Huck wrote:
> On Fri,  3 May 2019 15:49:06 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Per the POPs [1], when processing an interrupt the SCSW.CPA field of an
>> IRB generally points to 8 bytes after the last CCW that was executed
>> (there are exceptions, but this is the most common behavior).
>>
>> In the case of an error, this points us to the first un-executed CCW
>> in the chain.  But in the case of normal I/O, the address points beyond
>> the end of the chain.  While the guest generally only cares about this
>> when possibly restarting a channel program after error recovery, we
>> should convert the address even in the good scenario so that we provide
>> a consistent, valid, response upon I/O completion.
>>
>> [1] Figure 16-6 in SA22-7832-11.  The footnotes in that table also state
>> that this is true even if the resulting address is invalid or protected,
>> but moving to the end of the guest chain should not be a surprise.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index 384b3987eeb4..f86da78eaeaa 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -870,7 +870,7 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>>   	 */
>>   	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>>   		ccw_head = (u32)(u64)chain->ch_ccw;
>> -		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len)) {
>> +		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len + 1)) {
> 
> Maybe add a comment
> 
> /* On successful execution, cpa points just beyond the end of the chain. */
> 
> or so, to avoid head-scratching and PoP-reading in the future?

And deny future visitors the confusion?  :)

Good point; added.

> 
>>   			/*
>>   			 * (cpa - ccw_head) is the offset value of the host
>>   			 * physical ccw to its chain head.
> 

