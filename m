Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14288651364
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 20:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiLSTlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 14:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLSTk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 14:40:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B64A13E90;
        Mon, 19 Dec 2022 11:40:56 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJDdCZ004676;
        Mon, 19 Dec 2022 19:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RqqH0RjLhCug/eBYSsrHMsAcrmGxUzxYgqeoeVBIyqQ=;
 b=fyKdfWvH2OgpJpGsaEwfLOJPt3NLu4TfC1pCHAU/48miGrNAicfhkpg3SK2r3nDZjouR
 cqF1ROyOoKhYAyWCPyyZ9jkohiPDQI1LtbiM9rC2qGVR0gnpXhu46al9iIRWU5Kd49F5
 dtZHdi7ODggCezDtr8QlH1T7jrcPmqbwOkdTBTeaUfr7WC5kosumMWVouRLjy0ICM5jm
 u5x/Gz369cp6b1olQZ2thteGlV3nPOR7hUhOcsvpXIpob6Tc8UXBGpbdEp0Rx6P6gf5T
 tGFx3TPoJS6FsMPl1zDpFs04qNrGzVN4z/9pT3h/6FgfBorWn5XHobc4ubUma9c6ngDo fg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjwx20s9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:40:55 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHt7eE008375;
        Mon, 19 Dec 2022 19:40:54 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3mh6ywydcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:40:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJJerk711404020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:40:53 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C25B58059;
        Mon, 19 Dec 2022 19:40:53 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C087A58058;
        Mon, 19 Dec 2022 19:40:51 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 19:40:51 +0000 (GMT)
Message-ID: <bd8545ae-c44b-b231-7cd6-71c8586d195d@linux.ibm.com>
Date:   Mon, 19 Dec 2022 14:40:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 10/16] vfio/ccw: refactor the idaw counter
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-11-farman@linux.ibm.com>
 <a271f36b-0464-d14d-73ce-32603128ef05@linux.ibm.com>
 <7f898d8a9dcf73d70f2f99377549ae9ad3b98527.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7f898d8a9dcf73d70f2f99377549ae9ad3b98527.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N4KWmOQKnGEPqoA8fEPN9bW__ogkwMaV
X-Proofpoint-ORIG-GUID: N4KWmOQKnGEPqoA8fEPN9bW__ogkwMaV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190173
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/19/22 2:31 PM, Eric Farman wrote:
> On Mon, 2022-12-19 at 14:16 -0500, Matthew Rosato wrote:
>> On 11/21/22 4:40 PM, Eric Farman wrote:
>>> The rules of an IDAW are fairly simple: Each one can move no
>>> more than a defined amount of data, must not cross the
>>> boundary defined by that length, and must be aligned to that
>>> length as well. The first IDAW in a list is special, in that
>>> it does not need to adhere to that alignment, but the other
>>> rules still apply. Thus, by reading the first IDAW in a list,
>>> the number of IDAWs that will comprise a data transfer of a
>>> particular size can be calculated.
>>>
>>> Let's factor out the reading of that first IDAW with the
>>> logic that calculates the length of the list, to simplify
>>> the rest of the routine that handles the individual IDAWs.
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>  drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++++++++++----
>>> ----
>>>  1 file changed, 30 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index a30f26962750..34a133d962d1 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -496,23 +496,25 @@ static int ccwchain_fetch_tic(struct ccw1
>>> *ccw,
>>>         return -EFAULT;
>>>  }
>>>  
>>> -static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>>> -                             struct page_array *pa,
>>> -                             struct channel_program *cp)
>>> +/*
>>> + * ccw_count_idaws() - Calculate the number of IDAWs needed to
>>> transfer
>>> + * a specified amount of data
>>> + *
>>> + * @ccw: The Channel Command Word being translated
>>> + * @cp: Channel Program being processed
>>> + */
>>> +static int ccw_count_idaws(struct ccw1 *ccw,
>>> +                          struct channel_program *cp)
>>>  {
>>>         struct vfio_device *vdev =
>>>                 &container_of(cp, struct vfio_ccw_private, cp)-
>>>> vdev;
>>>         u64 iova;
>>> -       unsigned long *idaws;
>>>         int ret;
>>>         int bytes = 1;
>>> -       int idaw_nr, idal_len;
>>> -       int i;
>>>  
>>>         if (ccw->count)
>>>                 bytes = ccw->count;
>>>  
>>> -       /* Calculate size of IDAL */
>>>         if (ccw_is_idal(ccw)) {
>>>                 /* Read first IDAW to see if it's 4K-aligned or
>>> not. */
>>>                 /* All subsequent IDAws will be 4K-aligned. */
>>> @@ -522,7 +524,26 @@ static int ccwchain_fetch_ccw(struct ccw1
>>> *ccw,
>>>         } else {
>>>                 iova = ccw->cda;
>>>         }
>>> -       idaw_nr = idal_nr_words((void *)iova, bytes);
>>> +
>>> +       return idal_nr_words((void *)iova, bytes);
>>> +}
>>> +
>>> +static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>>> +                             struct page_array *pa,
>>> +                             struct channel_program *cp)
>>> +{
>>> +       struct vfio_device *vdev =
>>> +               &container_of(cp, struct vfio_ccw_private, cp)-
>>>> vdev;
>>> +       unsigned long *idaws;
>>> +       int ret;
>>> +       int idaw_nr, idal_len;
>>> +       int i;
>>> +
>>> +       /* Calculate size of IDAL */
>>> +       idaw_nr = ccw_count_idaws(ccw, cp);
>>> +       if (idaw_nr < 0)
>>> +               return idaw_nr;
>>> +
>>
>> What about if we get a 0 back from ccw_count_idaws?   The next thing
>> we're going to do (not shown here) is kcalloc(0, sizeof(*idaws)),
>> which I think means you'll get back ZERO_SIZE_PTR, not a null
>> pointer.
> 
> While it's true that the idal_nr_words routines could return zero, I
> don't see how the ccw_count_idaws routine which calls it could do the
> same. We added a check for a zero data count with commit 453eac312445e
> ("s390/cio: Allow zero-length CCWs in vfio-ccw"), such that a CCW that
> has no length will cause us to allocate -something- that would be valid
> for the channel to use, even if it's not going to put anything in/out
> of it.

Ah, yeah I was specifically looking at idal_nr_words and I missed the 'int bytes = 1;' business at the top of ccw_count_idaws. 

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> 
>>
>>>         idal_len = idaw_nr * sizeof(*idaws);
>>>  
>>>         /* Allocate an IDAL from host storage */
>>> @@ -555,7 +576,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>>>                 for (i = 0; i < idaw_nr; i++)
>>>                         pa->pa_iova[i] = idaws[i];
>>>         } else {
>>> -               pa->pa_iova[0] = iova;
>>> +               pa->pa_iova[0] = ccw->cda;
>>>                 for (i = 1; i < pa->pa_nr; i++)
>>>                         pa->pa_iova[i] = pa->pa_iova[i - 1] +
>>> PAGE_SIZE;
>>>         }
>>
> 

