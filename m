Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C446BBB83
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjCOR5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCOR5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:57:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D6E2C64C;
        Wed, 15 Mar 2023 10:57:31 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHgf6v038090;
        Wed, 15 Mar 2023 17:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2L9voBsmfYrGPUbXcC4Da6Sws5+0ftbCvBKodcR+X8Y=;
 b=YPwBk6BCQGukzruEtG9oqQmlemjBEPaM4AQ+n2+tuAAsM7rSMeo5RevAtalrX5JbIyTa
 UR7bIwscDReM6RPDjWTEmaDPrICWCWDVhYNtxJDTP8w8KGMkjKgWH3t3xU08X/ZcM55L
 FEQurLuN+PcwkZsQ8OkWcye65TIVzA4vk9zhJTswBAGMKk43rEPinjmb7aSiIt6UMtKa
 WfM/2eM43eC1dwCoaso+ivSisdcI9NQKX3ibpkKDtPEu5g53y5zuvhjoIzX9D+4Wsqvc
 b5zurjl4Op+WikAvOW/ozlRHcqZ0edeo85u3Qgt4EO5zXPYuaFo1Rx+mkYbX+mr9Yapr Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbf9fy3vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:57:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FHurN6030984;
        Wed, 15 Mar 2023 17:57:31 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbf9fy3va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:57:30 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FGLApd018985;
        Wed, 15 Mar 2023 17:57:30 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3pb29pdpyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:57:30 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FHvSc57471804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 17:57:28 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 543D958053;
        Wed, 15 Mar 2023 17:57:28 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70FBD58043;
        Wed, 15 Mar 2023 17:57:27 +0000 (GMT)
Received: from [9.60.85.43] (unknown [9.60.85.43])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 17:57:27 +0000 (GMT)
Message-ID: <3accd046-0dee-db7c-7e60-287bf2792a8e@linux.ibm.com>
Date:   Wed, 15 Mar 2023 13:57:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] s390/vfio_ap: fix memory leak in vfio_ap device driver
Content-Language: en-US
To:     freude@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com
References: <20230315153932.165031-1-akrowiak@linux.ibm.com>
 <b9be5d298de3ca70f8fa86a1b58cb4f2@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <b9be5d298de3ca70f8fa86a1b58cb4f2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3pRQytibEx_EBahlmUqJwos3yI27kAd8
X-Proofpoint-ORIG-GUID: m-DXF8pXbb5dq_D-H5YCrHF2iWipyk1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_09,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxlogscore=889 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

snip ...


> I needed some indirections to follow what exactly happens here and how 
> you
> fix it, but finally I got it.
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

Sorry about the indirections. Thanks for the review.

