Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E95FC354
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJLJzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 05:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiJLJzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 05:55:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CDC7199D
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 02:55:52 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29C9C3ls014137
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2HnuQc9Zl+dt/E1D5funmpB6jZL5lE4Crvz55s6h2uk=;
 b=tsqI/rJW3STrj2T6wx3AadxepdcjErq8CWzKw1g8ydWKB4QvKGgQPPNKZ7MlH3jsNnOq
 +bZ4KJz6O1ZCAtbGQ/irPrLIrYW3jD4/1GukG/D1uDfMwgVkABaT04md7/K8YrVdOBkz
 UMrL/1ohvrL/7uHei80BapuT1KePCXxP322GmQKlXd+p0gftEZl8I1RK8fzUheYZktlP
 TnucUdiF4LdbQGGM7YbGfRcInJ03BvJ5LR2IXEARtwhf7T+msXY9DD28dwXVOzbB9fxh
 xjtb95DoO0V1Bk01Os+m1y5cqT9AJqGM+4MwPNRcX22DMJaiOGT+kJ2sl2DC237hZvqD 1A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5tr4h6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:55:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29C9olXb030066
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:55:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u95s0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:55:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29C9uHUW24510924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 09:56:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73D3AA4040;
        Wed, 12 Oct 2022 09:55:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B86FA404D;
        Wed, 12 Oct 2022 09:55:46 +0000 (GMT)
Received: from [9.171.35.161] (unknown [9.171.35.161])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 09:55:46 +0000 (GMT)
Message-ID: <0f594af8-52c5-9405-b9eb-30cae2049893@linux.ibm.com>
Date:   Wed, 12 Oct 2022 11:55:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
References: <20221011160712.928239-1-nrb@linux.ibm.com>
 <20221011160712.928239-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 1/1] KVM: s390: pv: don't allow userspace to set the
 clock under PV
In-Reply-To: <20221011160712.928239-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zODYgi7UOx2uBskWrWN_pC8-MNjBO2DV
X-Proofpoint-GUID: zODYgi7UOx2uBskWrWN_pC8-MNjBO2DV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_04,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=959 impostorscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120062
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 18:07, Nico Boehr wrote:
> When running under PV, the guest's TOD clock is under control of the
> ultravisor and the hypervisor isn't allowed to change it. Hence, don't
> allow userspace to change the guest's TOD clock by returning
> -EOPNOTSUPP.
> 
> When userspace changes the guest's TOD clock, KVM updates its
> kvm.arch.epoch field and, in addition, the epoch field in all state
> descriptions of all VCPUs.
> 
> But, under PV, the ultravisor will ignore the epoch field in the state
> description and simply overwrite it on next SIE exit with the actual
> guest epoch. This leads to KVM having an incorrect view of the guest's
> TOD clock: it has updated its internal kvm.arch.epoch field, but the
> ultravisor ignores the field in the state description.
> 
> Whenever a guest is now waiting for a clock comparator, KVM will
> incorrectly calculate the time when the guest should wake up, possibly
> causing the guest to sleep for much longer than expected.
> 
> With this change, kvm_s390_set_tod() will now take the kvm->lock to be
> able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
> also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.
> 
> The function kvm_s390_set_tod_clock is now unused, hence remove it.
> Update the documentation to indicate the TOD clock attr calls can now
> return -EOPNOTSUPP.
> 
> Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
