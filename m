Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B044D0C31
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 00:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbiCGXqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 18:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243084AbiCGXqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 18:46:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E42294;
        Mon,  7 Mar 2022 15:45:51 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227MxUpk017724;
        Mon, 7 Mar 2022 23:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uyIxG5y1JBocl+WfqDrffowhHyfi3AUk9e3P3tvDBO8=;
 b=LDwB9axiQ+eDZ9zf8v2DQbjEI8JBnsfJordlyh7t8PcZAQWmZlpjbVbBcABBWg5Q7F5P
 +AGbNUo+LwrEzFyC32o5cxN+csBb5iYSacva0mc4In9gHow9vodw7MJvU8FRu2pQiQHJ
 zPZ3RCZ9s0vkNPxKzHNo13gc1GKSN/k6LXklKkkpY4QDTN1uQv4TBtZ/1UWFaahPSvHy
 4TQqK7l610vf4hqMtk+1YLWk6JboD2TaER29Q4fMxNk+PgRUqCCmWOU/ceEeuHjqJXSK
 hijjKk1ZDakj+HgMVGCbKuiI+Mko+SUsNFrzg+HZdxsMHFc98wHRxE1KPEnScKWCOTBY NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enndrqxah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 23:45:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227Ne90A032589;
        Mon, 7 Mar 2022 23:45:49 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enndrqxaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 23:45:49 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227NT2iM003994;
        Mon, 7 Mar 2022 23:45:48 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3ekyg9wfjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 23:45:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227NjloW55902506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 23:45:47 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A009124053;
        Mon,  7 Mar 2022 23:45:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5800612405A;
        Mon,  7 Mar 2022 23:45:46 +0000 (GMT)
Received: from [9.160.116.147] (unknown [9.160.116.147])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 23:45:46 +0000 (GMT)
Message-ID: <eb30a519-5707-717a-ff22-cc3a8e65dc7e@linux.ibm.com>
Date:   Mon, 7 Mar 2022 18:45:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-9-akrowiak@linux.ibm.com>
 <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
 <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
 <20220307142711.5af33ece.pasic@linux.ibm.com>
 <151241e6-3099-4be2-da54-1f0e5cb3a705@linux.ibm.com>
 <20220307181027.29c821b6.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220307181027.29c821b6.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JM6_2fVlWDg6C5D_slv-iLlRmtVzKvjk
X-Proofpoint-GUID: zLOsl1U_XwxSOis-IU6ZNJdSREpIfF1h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_12,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/7/22 12:10, Halil Pasic wrote:
> On Mon, 7 Mar 2022 09:10:29 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 3/7/22 08:27, Halil Pasic wrote:
>>> On Mon, 7 Mar 2022 07:31:21 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> On 3/3/22 10:39, Jason J. Herne wrote:
>>>>> On 2/14/22 19:50, Tony Krowiak wrote:
>>>>>>     /**
>>>>>> - * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is
>>>>>> not configured
>>>>>> + * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by
>>>>>> matrix mdevs
>>>>>>      *
>>>>>> - * @matrix_mdev: the mediated matrix device
>>>>>> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>>>>>> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>>>>>>      *
>>>>>> - * Verifies that the APQNs derived from the cross product of the AP
>>>>>> adapter IDs
>>>>>> - * and AP queue indexes comprising the AP matrix are not configured
>>>>>> for another
>>>>>> + * Verifies that each APQN derived from the Cartesian product of a
>>>>>> bitmap of
>>>>>> + * AP adapter IDs and AP queue indexes is not configured for any matrix
>>>>>>      * mediated device. AP queue sharing is not allowed.
>>>>>>      *
>>>>>> - * Return: 0 if the APQNs are not shared; otherwise returns
>>>>>> -EADDRINUSE.
>>>>>> + * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
>>>>>>      */
>>>>>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev
>>>>>> *matrix_mdev)
>>>>>> +static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>>>>>> +                      unsigned long *mdev_aqm)
>>>>>>     {
>>>>>> -    struct ap_matrix_mdev *lstdev;
>>>>>> +    struct ap_matrix_mdev *matrix_mdev;
>>>>>>         DECLARE_BITMAP(apm, AP_DEVICES);
>>>>>>         DECLARE_BITMAP(aqm, AP_DOMAINS);
>>>>>>     -    list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
>>>>>> -        if (matrix_mdev == lstdev)
>>>>>> +    list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>>>>>> +        /*
>>>>>> +         * If the input apm and aqm belong to the matrix_mdev's matrix,
>>> How about:
>>>
>>> s/belong to the matrix_mdev's matrix/are fields of the matrix_mdev
>>> object/
>> This is the comment I wrote:
>>
>>           /*
>>            * Comparing an mdev's newly updated apm/aqm with itself would
>>            * result in a false positive when verifying whether any APQNs
>>            * are shared; so, if the input apm and aqm belong to the
>>            * matrix_mdev's matrix, then move on to the next one.
>>            */
>>
>> However, I'd be happy to change it to whatever either of you want.
> What ain't obvious for the comment is that "belong to" actually means
> composition and not association. In other words, there there is no
> pointer/indirection involved, a pointer that would tell us what matrix
> does belong to what matrix_mdev, but rather the matrix is just a part
> of the matrix_mdev object.
>
> I don't like 'false positive' either, and whether the apm/aqm is
> newly updated or not is also redundant and confusing in my opinion. When
> we check because of inuse there is not updated whatever. IMHO the old
> message was better than this one.
>
> Just my opinion, if you two agree, that this is the way to go, I'm fine
> with that.
>
> Regards,
> Halil

Feel free to recommend the verbiage for this comment. I'm not married
to my comments and am open to anything that helps others to
understand what is going on here. It seems obvious to me, but I wrote
the code. Obviously, it is not so obvious based on Jason's comments,
so maybe someone else can compose a better comment.

>
>

