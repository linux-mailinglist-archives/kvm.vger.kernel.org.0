Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C129560E093
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 14:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiJZMZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 08:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiJZMZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 08:25:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A44E50538
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 05:25:22 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QBqaL1012662
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1yDPmlHweF1434q1fjkjZi2xiEktAxku45rBsAQYg9k=;
 b=my5sLH/AqSswxk1jGZmN2njQ1LRPEqrvbMXPflYfSnWqlBdfphPlaSOCJVnpwK1lcYkm
 ha3ev30T3BTWXmuyYf0pjemBgisj4C4bvQnMwCWa9hOo1BIf7gi0oGWmkQJGhWkoDHHF
 oXlNFtSiDNHQgoJRS4gSi+EuWMSaOCxOaYnsgdt41AGGNKaDGZl1NU2Jh9x/8HjFz2kw
 ZOyzMwiEUrF5X5dFc2BAHqtH9CwZXUZdrYM2jT1XA3JT80IGfBUUNxS724WjTiHneq49
 dQlpWFq1+cjNY9m31UgMUg1UMoc+/0gTP/FvPRprq+xN/OSlJZQOcx6CNAi7SOMtNP47 tA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf09fhg7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:25:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QCKo9d013439
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:25:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3kdv5fhapa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:25:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QCPFbZ131814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 12:25:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A55E0AE04D;
        Wed, 26 Oct 2022 12:25:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F1F0AE053;
        Wed, 26 Oct 2022 12:25:15 +0000 (GMT)
Received: from [9.171.93.253] (unknown [9.171.93.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 12:25:15 +0000 (GMT)
Message-ID: <484f3ddc-dbac-d474-6475-141020e15403@linux.ibm.com>
Date:   Wed, 26 Oct 2022 14:25:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 0/1] KVM: s390: pv: fix clock comparator late after
 suspend/resume
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
References: <20221011160712.928239-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221011160712.928239-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VqQvItjmdsWgFOyA6YrtePB_6_2Lycc3
X-Proofpoint-ORIG-GUID: VqQvItjmdsWgFOyA6YrtePB_6_2Lycc3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=911
 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 18:07, Nico Boehr wrote:
> v3->v4:
> ---
> - squash both commits
> - update docs (thanks Janosch)
> - add a comment (thanks Janosch)
> 
> v2->v3:
> ---
> - add commit to remove kvm_s390_set_tod_clock() function (thanks Claudio)
> 
> v1->v2:
> ---
> - fix broken migration due to deadlock
> 
> After a PV guest in QEMU has been paused and resumed, clock comparator
> interrupts are delivered to the guest much too late.
> 

Thanks, picked
