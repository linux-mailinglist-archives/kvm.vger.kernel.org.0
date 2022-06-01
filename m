Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86253AD1A
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 20:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiFASzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiFASzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 14:55:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E2152D99;
        Wed,  1 Jun 2022 11:55:01 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251IJcdG030907;
        Wed, 1 Jun 2022 18:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=ZSRNauAIIz3T3KQSlyheFSn9sDOzFc2WKfdsvdYbF4c=;
 b=Ex0FrcDRYpnwmCI5csJKXgAKZVjXhPXJGiV32HooZYyT9296mzK5MjxsEPcPPhxm23GH
 Ak6lVQbVF+CkIAFnydi6HLUqcj+58myAftlZp6VrmYtiaN7iWIkcCHTZU7ZkHaWe60ZK
 3qPAygmvciWz3r78e7DUojJ4C9/lqGxBnf5nG+zLYCmHgX00jx+aiu5zx3ngTRrzcleT
 tDXH3pUzo6Qr/GqzEzF0BD0ErSrp56fHWB5pQJpmj75wsDjfic6DuciqyzmILx1bHp3U
 GB74eBN7Ac0zuFWuHpI5AUZhyFby09tZgXprbNImIeKq9ojA54CjxpBgIYY9Pv21Q+W1 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ged9hrw1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:54:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251InY9d002483;
        Wed, 1 Jun 2022 18:54:50 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ged9hrw0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:54:48 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251IolfX022842;
        Wed, 1 Jun 2022 18:54:47 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1ad2rxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 18:54:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251IskZ864028980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 18:54:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68126AE05F;
        Wed,  1 Jun 2022 18:54:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF470AE060;
        Wed,  1 Jun 2022 18:54:45 +0000 (GMT)
Received: from [9.65.239.109] (unknown [9.65.239.109])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jun 2022 18:54:45 +0000 (GMT)
Message-ID: <164f0852-3d7c-7d38-6fb2-9cacf6728ede@linux.ibm.com>
Date:   Wed, 1 Jun 2022 14:54:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 12/20] s390/vfio-ap: allow hot plug/unplug of AP
 devices when assigned/unassigned
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-13-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-13-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o93ObAkzWTcrkRSfTeAGBymQd9TXBSIH
X-Proofpoint-ORIG-GUID: 4J00neEdMbTV_qncTuOWgeGVeRxwBtmN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_06,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010077
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> Let's hot plug an adapter, domain or control domain into the guest when it
> is assigned to a matrix mdev that is attached to a KVM guest. Likewise,
> let's hot unplug an adapter, domain or control domain from the guest when
> it is unassigned from a matrix_mdev that is attached to a KVM guest.
> 
> Whenever an assignment or unassignment of an adapter, domain or control
> domain is performed, the APQNs and control domains assigned to the matrix
> mdev will be filtered and assigned to the AP control block
> (APCB) that supplies the AP configuration to the guest so that no
> adapter, domain or control domain that is not in the host's AP
> configuration nor any APQN that does not reference a queue device bound
> to the vfio_ap device driver is assigned.
> 
> After updating the APCB, if the mdev is in use by a KVM guest, it is
> hot plugged into the guest to dynamically provide access to the adapters,
> domains and control domains provided via the newly refreshed APCB.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 112 +++++++++++++++---------------
>   1 file changed, 57 insertions(+), 55 deletions(-)

Seems sane.

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
