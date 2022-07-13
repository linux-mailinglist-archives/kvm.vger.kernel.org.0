Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC715731F6
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiGMJDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 05:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiGMJCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 05:02:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F55F5134;
        Wed, 13 Jul 2022 02:02:18 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D8kNHW021869;
        Wed, 13 Jul 2022 09:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x+k/O0+knbVaHfdmGiSBpwP+sALfKxsff6dRxgex6qk=;
 b=VGQyPQ7crTVQ7J9xHDZJSw55aFaeHjnyBLAtXHE86RhCs0CJef2GcSDRelvhFK6Ahs/I
 fMEtKpQlFMNJSwiLj+sqsbDupLDW34dQI2oH1ACb+TMfpsCKBitJWaU09WNXbbLmH6dw
 2iTW+wkpCgV0G2JwP4IgpwA8dmcrxkfpXrM3qIS7tS0HWFpvP1ITzcqENYSZdU00uYr2
 whcBUdrunYiEYxnEOOVwY3AOX4gAQPNQY6Ihax33BXUioXuhZ2Q53w+hgU/lOoWzM68Q
 qRn9A4AcVuNrL6mfmNxbc4RFr2f0bbHUadJpQu3TsIFwXKhOkO/xFaNWZRjK+kcBzd92 FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9tu7gber-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:02:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26D8lXgq024428;
        Wed, 13 Jul 2022 09:02:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9tu7gbds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:02:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26D8oeqM018019;
        Wed, 13 Jul 2022 09:02:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3h71a8wd2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 09:02:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26D92C6v20185380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 09:02:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BAF842041;
        Wed, 13 Jul 2022 09:02:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F5E74203F;
        Wed, 13 Jul 2022 09:02:11 +0000 (GMT)
Received: from [9.145.184.105] (unknown [9.145.184.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 09:02:11 +0000 (GMT)
Message-ID: <2e9f3da3-301f-9f1e-c39c-bf59a515e446@linux.ibm.com>
Date:   Wed, 13 Jul 2022 11:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v12 0/3] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220711084148.25017-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kZh4TH3Fpcr6EgKP2LALxnARt9hVOzRG
X-Proofpoint-ORIG-GUID: nXGCAFed1-NxCqUBiPpq2-BQvMI5VPDe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=884 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/11/22 10:41, Pierre Morel wrote:
> Hi all,
> 
> This new spin suppress the check for real cpu migration and
> modify the checking of valid function code inside the interception
> of the STSI instruction.
> 
> The series provides:
> 0- Modification of the ipte lock handling to use KVM instead of the
>     vcpu as an argument because ipte lock work on SCA which is uniq
>     per KVM structure and common to all vCPUs.
> 1- interception of the STSI instruction forwarding the CPU topology
> 2- interpretation of the PTF instruction
> 3- a KVM capability for the userland hypervisor to ask KVM to
>     setup PTF interpretation.
> 4- KVM ioctl to get and set the MTCR bit of the SCA in order to
>     migrate this bit during a migration.

Please rebase before sending the next version
