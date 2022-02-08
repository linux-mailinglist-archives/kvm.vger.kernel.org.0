Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9394ACFC1
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 04:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346408AbiBHD1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 22:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiBHD1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 22:27:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5CAC043188;
        Mon,  7 Feb 2022 19:27:10 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21812rME020077;
        Tue, 8 Feb 2022 03:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qq4f3rvSDeOM8mnrm2qT95b1d3QKIrpuIfb7jj8TN5A=;
 b=kruQRmPmlhHxST7P9LmSG8yMu49V5RMWy5z9KkgalUnNmD6dgc+ho6x8kzK910llVxTl
 HbZfL+jIAZTQ+U1HahEqgS7izBkOh+Pu33S8kQUf7ExoIi+YcfK4VQLRzcgxj0Om9iCH
 uxiZQt1bYyIY1K20iaien34Ym2vJbgQnJ6K7Q+BxualDKoUiinZVz3FnB/E0OptT3KjW
 2zYABOC0KA72iWm882WNX1+TAXUyEUEzcXw8chePp4T+AorFlPRo6MQ1X4wlTgpMvh8e
 7mXnRlII1F3z2Tl/+Le87ZJoJ/+FOYdnVrpdEoXrmfGH/5Si1Mp6cx7O2PwsBoFlJ7fp 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355aqt1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 03:27:08 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2183ODP5013230;
        Tue, 8 Feb 2022 03:27:08 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355aqt16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 03:27:07 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2183Nr7i003178;
        Tue, 8 Feb 2022 03:27:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3e2f8mwu2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 03:27:06 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2183R5WA35258686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 03:27:05 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65D0711206D;
        Tue,  8 Feb 2022 03:27:05 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 366D7112067;
        Tue,  8 Feb 2022 03:27:04 +0000 (GMT)
Received: from [9.65.232.50] (unknown [9.65.232.50])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 03:27:04 +0000 (GMT)
Message-ID: <145477fb-0408-d5c9-2366-139d44e2cc91@linux.ibm.com>
Date:   Mon, 7 Feb 2022 22:27:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-15-akrowiak@linux.ibm.com>
 <20220204114359.4898b9c5.pasic@linux.ibm.com>
 <573f8647-7479-3561-cd88-035b4db33e36@linux.ibm.com>
 <20220208023835.1fc8c6dd.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220208023835.1fc8c6dd.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YJtKL5PNxjd7yMLLjicEpJ69p5tbusLJ
X-Proofpoint-ORIG-GUID: ck6l8VA0NqtyOwm_KW4pg6c9ASRMvRg_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_01,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080014
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/22 20:38, Halil Pasic wrote:
> On Mon, 7 Feb 2022 14:39:31 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> Back to the topic of locking: it looks to me that on this path you
>>> do the filtering and thus the accesses to matrix_mdev->shadow_apcb,
>>> matrix_mdev->matrix and matrix_dev->config_info some of which are
>>> of type write whithout the matrix_dev->lock held. More precisely
>>> only with the matrix_dev->guests_lock held in "read" mode.
>>>
>>> Did I misread the code? If not, how is that OK?
>> You make a valid point, a struct rw_semaphore is not adequate for the
>> purposes
>> it is used in this patch series. It needs to be a mutex.
>>
> Good we agree that v17 is racy.
>
>> For v18 which is forthcoming probably this week, I've been reworking the
>> locking
>> based on your observation that the struct ap_guest is not necessary given we
>> already have a list of the mediated devices which contain the KVM
>> pointer. On the other
> [..]
>>> BTW I got delayed on my "locking rules" writeup. Sorry for that!
>> No worries, I've been writing up a vfio-ap-locking.rst document to
>> include with the next
>> version of the patch series.
> I'm looking forward to v18 including that document. I prefer not to
> discuss what you wrote about the approach taken in v18 now. It is easier
> to me when I have both the text stating the intended design, and the
> code that is supposed to adhere to this design.
>
> Regards,
> Halil

Coming soon to a theater near you:)

>

