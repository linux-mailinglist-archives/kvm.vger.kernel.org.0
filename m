Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3E4D1BDE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347870AbiCHPib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347867AbiCHPhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:37:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEC84EA0E;
        Tue,  8 Mar 2022 07:36:55 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228F79fM020896;
        Tue, 8 Mar 2022 15:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gMr0TNEsEf4o8OCGCZhLnRNEH7GjXcuzCkk0iumKG9s=;
 b=QSoCD5l+mytYtmCnJLMCysKhjP1PuwlqsmFaPMX708d+NTAJcHGgJuFo9bE/YWwVgY83
 2+RUByqUDPlWwcCM8Z67ABxYxYR5ojZKoh5sBYxlDQDJTp2Wy3gJo3reOc7EZSs9q9Xr
 Fzm7ERMlOPvBLaN8uaYOsuVu/eP1uvPwVcTSn0Vj83KrMJ+FMDfkx7Nx99PXciPx8Mxg
 SE5l95qoi8Mx5r+yo67YAMJaHFfOuJnX5HWqDzym/4SipkBOrLFNP8DCvM9jjUA3Xcde
 pWenAqfp8a/dMzFzzBSSmaV2WTLwzln0Et0bM/r0XqgD/usk2pgOaDudqix1RSQUro7y qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enww7f843-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:54 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 228DrQID006838;
        Tue, 8 Mar 2022 15:36:53 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enww7f83g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:53 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228F7QGW021001;
        Tue, 8 Mar 2022 15:36:52 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3ekyg9u91y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:36:52 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228FaoY530605810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 15:36:50 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BAEE78063;
        Tue,  8 Mar 2022 15:36:50 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D06797805C;
        Tue,  8 Mar 2022 15:36:48 +0000 (GMT)
Received: from [9.160.116.147] (unknown [9.160.116.147])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  8 Mar 2022 15:36:48 +0000 (GMT)
Message-ID: <069b28e7-4ab2-47c8-cce3-186cd987834d@linux.ibm.com>
Date:   Tue, 8 Mar 2022 10:36:48 -0500
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
 <eb30a519-5707-717a-ff22-cc3a8e65dc7e@linux.ibm.com>
 <20220308110637.2e839732.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220308110637.2e839732.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 014tZ3LzC9Rq0mG_H_poaoTOzh4g8lz3
X-Proofpoint-GUID: KIM0uyOdsx2x71QiI9cPgnnZIsxrFejj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0
 mlxlogscore=964 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/8/22 05:06, Halil Pasic wrote:
> On Mon, 7 Mar 2022 18:45:45 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
> [..]
>>>>> s/belong to the matrix_mdev's matrix/are fields of the matrix_mdev
>>>>> object/
>>>> This is the comment I wrote:
>>>>
>>>>            /*
>>>>             * Comparing an mdev's newly updated apm/aqm with itself would
>>>>             * result in a false positive when verifying whether any APQNs
>>>>             * are shared; so, if the input apm and aqm belong to the
>>>>             * matrix_mdev's matrix, then move on to the next one.
>>>>             */
>>>>
>>>> However, I'd be happy to change it to whatever either of you want.
>>> What ain't obvious for the comment is that "belong to" actually means
>>> composition and not association. In other words, there there is no
>>> pointer/indirection involved, a pointer that would tell us what matrix
>>> does belong to what matrix_mdev, but rather the matrix is just a part
>>> of the matrix_mdev object.
>>>
>>> I don't like 'false positive' either, and whether the apm/aqm is
>>> newly updated or not is also redundant and confusing in my opinion. When
>>> we check because of inuse there is not updated whatever. IMHO the old
>>> message was better than this one.
>>>
>>> Just my opinion, if you two agree, that this is the way to go, I'm fine
>>> with that.
>>>
>>> Regards,
>>> Halil
>> Feel free to recommend the verbiage for this comment. I'm not married
>> to my comments and am open to anything that helps others to
>> understand what is going on here. It seems obvious to me, but I wrote
>> the code. Obviously, it is not so obvious based on Jason's comments,
>> so maybe someone else can compose a better comment.
> /*
> * If the input apm and aqm are fields of the matrix_mdev object,
> * then move on to the next matrix_mdev.
> */

Perfect, you write better English than me!

>
> Regards,
> Halil

