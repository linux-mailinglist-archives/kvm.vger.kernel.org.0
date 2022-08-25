Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D815A0B80
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 10:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiHYIa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 04:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiHYIa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 04:30:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2A173917;
        Thu, 25 Aug 2022 01:30:56 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P7hbJY006639;
        Thu, 25 Aug 2022 08:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=OMmWGgs6vn9kUJMlHv3vwopOndmuKt1TnFR7XsnYx2c=;
 b=ElpG8HKOkwXNv3EQEfn/Vmm7HOPfJ3Ov4bf3mPYEwUcoiPv7DHeiKQEMd1mgIA/5FWal
 mCNU+pEFLUmZQ9u0wgQKbOrJwi8QSj8k/tOyvBoOR2YQwpFEQF0eU4vbd0qfM99/iG31
 zz7iB1Mv1QN4yTjgYCDYhtg+rfpMvI3MnEzz6fbx1koX02dLCkADKM9q3c/4/SeS2Qrh
 rMvdss44EHeDRdYBCcG2gBkDq2R3TSjCcp81zyijQN+YRyiud8t30tR0ZwF89NOyl81l
 vCsFmQDeTkUhL776U8Nccq3iRQbLLOz5l2RMbkUMTq8ECS9FQ64CyStUgMo3Xi9h0YD/ JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64xj9saw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 08:30:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27P7iMVm010001;
        Thu, 25 Aug 2022 08:30:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j64xj9s9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 08:30:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27P8LGKk025828;
        Thu, 25 Aug 2022 08:30:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88x4y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 08:30:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27P8UkSN43647262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 08:30:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37B7DA4057;
        Thu, 25 Aug 2022 08:30:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0D27A4051;
        Thu, 25 Aug 2022 08:30:25 +0000 (GMT)
Received: from osiris (unknown [9.152.212.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Aug 2022 08:30:25 +0000 (GMT)
Date:   Thu, 25 Aug 2022 10:30:25 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Pass initialized arg even if unused
Message-ID: <YwczITkxvvghyvWq@osiris>
References: <20220824153011.4004573-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824153011.4004573-1-scgl@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5C8nJE7uOf4tY54ddV2fCifhenVmKfAD
X-Proofpoint-ORIG-GUID: _VtMFW8bFbPGvLC4RSTO0qGpF_UZqb8s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1011 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 05:30:11PM +0200, Janis Schoetterl-Glausch wrote:
> This silences smatch warnings reported by kbuild bot:
> arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
> arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.
> 
> This is because it cannot tell that the value is not used in this case.
> The trans_exc* only examine prot if code is PGM_PROTECTION.
> Pass a dummy value for other codes.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
...
> @@ -503,6 +505,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>  
>  	switch (code) {
>  	case PGM_PROTECTION:
> +		WARN(unlikely(prot == PROT_NONE), "Invalid prot argument");

The WARN macro comes with unlikely, please get rid of unlikely here. Also:

> +		case PROT_NONE:
> +			/* We should never get here, acts like termination */

Why not put it here? And make it WARN_ON_ONCE() in addition?

>  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> -			if (kvm_is_error_gpa(vcpu->kvm, gpa))
> +			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
>  				rc = PGM_ADDRESSING;
> +				prot = PROT_NONE;
> +			}
...
> +		if (rc == PGM_PROTECTION)
> +			prot = PROT_TYPE_KEYC;
> +		else
> +			prot = PROT_NONE;

For both cases I would suggest to preinitialize prot with PROT_NONE in
order to keep the code smaller - but not my call.
