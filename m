Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA511719CC7
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjFAM5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjFAM5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:57:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6C1123;
        Thu,  1 Jun 2023 05:57:21 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351CpSKJ023806;
        Thu, 1 Jun 2023 12:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BhnFPD9WBpyKOH+EIz0yZ5u6juJOqEY0p6yS3SSS1KE=;
 b=LqemEYbxjAzoL4l51mevRW7W1Dg/eX0ZC18892oKfS3taSLxFCdRq3efxiLc3tUqlu6y
 FTrfX7AR937ewo0p578Ne9X4sqpj5hZsjxRLtZPvF/sf+eO4cntAV6/BUNElZDY7Wgj2
 zjlxGZD0ulITmG9Js1ZfwUB8wPQF5llYwhaF/Ekb/+HvYAd2z0M1SRAh8qKoZScZDYhe
 whH/adxea1loAPH1utzu44PH8fJ1/EWIRcKLrr7pDhC0Fvujap4dG0fq6r5LyTcA0d3p
 hF81LlyoTzd0LsprJPz0YZXTnne2p2GjHmWQ+E0PMvtMsr7HMCkPBinRDM+HNQzBdb95 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxucrgwjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:57:20 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351CUoLH021478;
        Thu, 1 Jun 2023 12:57:20 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxucrgwj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:57:19 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 351CsoGL016816;
        Thu, 1 Jun 2023 12:57:19 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qu9g6yr45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:57:19 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351CvH1B61276604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 12:57:17 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18C1958051;
        Thu,  1 Jun 2023 12:57:17 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389875805E;
        Thu,  1 Jun 2023 12:57:16 +0000 (GMT)
Received: from [9.61.34.174] (unknown [9.61.34.174])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 12:57:16 +0000 (GMT)
Message-ID: <85a26195-1f75-6cae-14e4-b474afe780d2@linux.ibm.com>
Date:   Thu, 1 Jun 2023 08:57:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest is
 removed
Content-Language: en-US
To:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <9837da27-e224-aded-fe3e-4f4db6b1599c@linux.ibm.com>
 <17cf1288-03c5-4143-c62b-9234ed9c4d9a@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <17cf1288-03c5-4143-c62b-9234ed9c4d9a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a0KaCMB5W9lSE1E8OilX4lGScHL3YP1-
X-Proofpoint-ORIG-GUID: QEEHxB9iNyct_MeLtsoIY5Fwyws3v18t
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=975 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010111
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 8:15 AM, Anthony Krowiak wrote:
> 
> 
> On 5/31/23 10:48 AM, Matthew Rosato wrote:

>> I also did some testing using the companion qemu series at
>> https://lore.kernel.org/qemu-devel/20230530225544.280031-1-akrowiak@linux.ibm.com
> 
> Shall I credit you with Tested-by also?
> 

Sure.

Thanks,
Matt

