Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E725D42D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGBQYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:24:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbfGBQYf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 12:24:35 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62GLRtp092867
        for <kvm@vger.kernel.org>; Tue, 2 Jul 2019 12:24:33 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tg8fxxunw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 12:24:33 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 2 Jul 2019 17:24:32 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 2 Jul 2019 17:24:30 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62GOTXQ54854058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 16:24:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1409CAE05C;
        Tue,  2 Jul 2019 16:24:29 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDEEFAE062;
        Tue,  2 Jul 2019 16:24:28 +0000 (GMT)
Received: from [9.60.84.127] (unknown [9.60.84.127])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 16:24:28 +0000 (GMT)
Subject: Re: [RFC v1 3/4] vfio-ccw: Set pa_nr to 0 if memory allocation fails
 for pa_iova_pfn
To:     Farhan Ali <alifm@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1561997809.git.alifm@linux.ibm.com>
 <19d813c58e0c45df3f23d8b1033e00b5ac5c7779.1561997809.git.alifm@linux.ibm.com>
 <20190702104550.7d2e7563.cohuck@redhat.com>
 <96b27fc4-5899-b17e-0a93-31e7b69f80a7@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Tue, 2 Jul 2019 12:24:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <96b27fc4-5899-b17e-0a93-31e7b69f80a7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070216-0052-0000-0000-000003D966B6
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011366; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01226439; UDB=6.00645669; IPR=6.01007660;
 MB=3.00027555; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-02 16:24:31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070216-0053-0000-0000-0000618AB13F
Message-Id: <7b7b1d6b-07b0-0fff-2a23-006ec67d7e3f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/19 10:07 AM, Farhan Ali wrote:
> 
> 
> On 07/02/2019 04:45 AM, Cornelia Huck wrote:
>> On Mon,  1 Jul 2019 12:23:45 -0400
>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>
>>> So we clean up correctly.

You mean, "so we don't try to call vfio_unpin_pages()" ?

>>>
>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_cp.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index cab1be9..c5655de 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -72,8 +72,10 @@ static int pfn_array_alloc(struct pfn_array *pa,
>>> u64 iova, unsigned int len)
>>>                     sizeof(*pa->pa_iova_pfn) +
>>>                     sizeof(*pa->pa_pfn),
>>>                     GFP_KERNEL);
>>> -    if (unlikely(!pa->pa_iova_pfn))
>>> +    if (unlikely(!pa->pa_iova_pfn)) {
>>> +        pa->pa_nr = 0;
>>>           return -ENOMEM;
>>> +    }
>>>       pa->pa_pfn = pa->pa_iova_pfn + pa->pa_nr;
>>>         pa->pa_iova_pfn[0] = pa->pa_iova >> PAGE_SHIFT;
>>
>> This looks like an older error -- can you give a Fixes: tag? (Yeah, I
>> know I sound like a broken record wrt that tag... :)
>>
> Yes, this is an older error. And yup I will add a fixes tag :)

Seems okay.

Reviewed-by: Eric Farman <farman@linux.ibm.com>

