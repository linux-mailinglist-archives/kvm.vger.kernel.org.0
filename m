Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2A55087A6
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 14:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378376AbiDTMH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 08:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiDTMHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 08:07:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD8B13F60;
        Wed, 20 Apr 2022 05:05:09 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KBabgG000407;
        Wed, 20 Apr 2022 12:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=DMK4RtPEXc4aCRxWUjvnynrQQ7uId43lB2XEBLBDo9k=;
 b=AxJI/dbvd0aPXzNiyE/bfimPYYcZklYixH8zHccfepikAvWw2jD7/mQm/haO1N7BdaxM
 96boqR3cBCG+r5U5qwd409lz7tkOJHP95+e0FCrSHWmQ2b414rx7zNTPctMuTZQRlIsE
 W/sSejHICeuz+R3DxmJOWeLZMAEmDy1zH28VU/ylY26LqNZ6uJIMHI+0aSnDqsZ4dVlF
 UNl3pSvksVgC3wBx+K7eD9c9NR+wBTlBHF5zcxdFXeX4rWF0kMhBLtIuFPP8fTzi9ahW
 sXtKCteJfBZO3fbw3j2hSwP6vvEsKfLWxbnfiKbIoV92VspuMWsjoowhQZbxe8WVNNmB +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7kb8ps6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:05:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBqskX007633;
        Wed, 20 Apr 2022 12:05:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7kb8prh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:05:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBr1cx023275;
        Wed, 20 Apr 2022 12:05:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8p8h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:05:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KC52dR48693546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 12:05:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBEBD5204F;
        Wed, 20 Apr 2022 12:05:02 +0000 (GMT)
Received: from osiris (unknown [9.145.25.85])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4938652050;
        Wed, 20 Apr 2022 12:05:02 +0000 (GMT)
Date:   Wed, 20 Apr 2022 14:05:00 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Message-ID: <Yl/27Pz3pvARmIHn@osiris>
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-2-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420113430.11876-2-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J0rFueCiVfJMxrhK7mQuXmjYb4w5WObt
X-Proofpoint-GUID: 2wgfhGRqB5wbxbmXLB63v09yc57GCV1I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=839 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
> +{
> +	if (!test_kvm_facility(vcpu->kvm, 11))
> +		return false;
> +
> +	/* A new vCPU has been hotplugged */
> +	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
> +		return true;
> +
> +	/* The real CPU backing up the vCPU moved to another socket */
> +	if (cpumask_test_cpu(vcpu->cpu,
> +			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> +		return true;
> +
> +	return false;
> +}

This seems to be wrong. I'd guess that you need

	if (cpumask_test_cpu(vcpu->cpu,
			     topology_core_cpumask(vcpu->arch.prev_cpu)))
-->		return false;
-->	return true;
