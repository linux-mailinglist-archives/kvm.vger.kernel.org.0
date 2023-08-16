Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3802677E0A3
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 13:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbjHPLl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 07:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244563AbjHPLlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 07:41:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2FC138;
        Wed, 16 Aug 2023 04:41:17 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37GBYUhU004945;
        Wed, 16 Aug 2023 11:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ATRkcftm/koJhVgjKHAy13Gi8x2deFwWc+yUG5Qd52k=;
 b=KyRvdXT7KAjOskAF1cq+Jy32cwM1B8lQPv4NCi5oE+0iexMhp76yMoi4xQRe3EdyaZa3
 M4UOBal8VPrxnzFHMcVOaAg4YkJF4ER1UUjiZZeQSXFlKhx2qsRXNtVyNNNai0W4iv49
 Pg4JlyeJtjIB+OY78Xq8QoeWZMJj8gfpJJsjvPglbBGt4zPb1ZshKR3Ns4CjG7jDYYf/
 zaDL6je6elWahm85POfOVtZ7RKP9GhwxjUorRXRe7ijeXc9J59z1+Ib/xMPWh5QRxDFL
 0nHhaq9Fyb1Li52rtv29EUniJE5OLkx4e9piqVg9U/ZvANDVQ39WFDiGHtPt9lPOoD/L WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgwm38v3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 11:41:14 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37GBYa7j005768;
        Wed, 16 Aug 2023 11:40:43 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgwm38tse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 11:40:43 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37GAYVwm013228;
        Wed, 16 Aug 2023 11:39:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sepmjud9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 11:39:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37GBdgWU6357604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 11:39:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7B22004D;
        Wed, 16 Aug 2023 11:39:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C868620040;
        Wed, 16 Aug 2023 11:39:41 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 16 Aug 2023 11:39:41 +0000 (GMT)
Message-ID: <b083c649-0032-4501-54eb-1d86af5fd4c8@linux.ibm.com>
Date:   Wed, 16 Aug 2023 13:39:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/12] s390/vfio_ap: crypto pass-through for SE guests
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1QHu8e0_DWMi-cJjoC9Rc4q3Txb8W7a-
X-Proofpoint-ORIG-GUID: Oo76oWWaZJmz0yyuYd8ullmy6WNOk5-y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_09,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=950 clxscore=1011
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308160102
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/23 20:43, Tony Krowiak wrote:
> This patch series is for the changes required in the vfio_ap device
> driver to facilitate pass-through of crypto devices to a secure
> execution guest. In particular, it is critical that no data from the
> queues passed through to the SE guest is leaked when the guest is
> destroyed. There are also some new response codes returned from the
> PQAP(ZAPQ) and PQAP(TAPQ) commands that have been added to the
> architecture in support of pass-through of crypto devices to SE guests;
> these need to be accounted for when handling the reset of queues.
> 

@Heiko: Once this has soaked a day or two, could you please apply this 
and create a feature branch that I can pull from?
