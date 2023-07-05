Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B14747F7F
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjGEIXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjGEIWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:22:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E71BD8
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:22:21 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3658HcwC028486;
        Wed, 5 Jul 2023 08:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=fkyPXjO8/F+cWUP+ZPKbGDIJ5dfTpmNiFp01dSVrcUY=;
 b=eENWUy+YHgWMRrmTFvVMv5o01jUUPMiRKm5eSooCw5FRLVhfbHCSQEJUSgrvN6grTj7a
 usTgS4f6YlhrAx8Jtc8QtIeM09dX75rx9QS+lD9E1MRMKK0FasMfnXb5XS1KEdPgmLSh
 I7TddJUBk9lCZCDo62QbtaQfjRtoNGXZvkrmaLOK5pplyvYZveMibBZuTZJtpsqicL6g
 imdlcc+cecjtmPI4Zm4x/qhKpITkLG2Q7KNBT7gvRkudZgweLdYj/KNg9ZUwrKO3Q1Gu
 ObHM+j2bQYzaffnUzfmt26+vutL1t7wUf5BjquS3W9rEJf7mpHhvJ7jdnwp6F+SLrlHZ ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rn4vh82fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 08:21:57 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3658IVD8031194;
        Wed, 5 Jul 2023 08:21:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rn4vh82ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 08:21:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3651PhAx011735;
        Wed, 5 Jul 2023 08:21:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rjbde2f8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jul 2023 08:21:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3658LpHY6292168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jul 2023 08:21:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6152016C;
        Wed,  5 Jul 2023 08:21:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D40920168;
        Wed,  5 Jul 2023 08:21:46 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.67.112])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  5 Jul 2023 08:21:45 +0000 (GMT)
Date:   Wed, 5 Jul 2023 13:51:42 +0530
From:   Kautuk Consul <kconsul@linux.vnet.ibm.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZKUoFqGr5H0x/DIN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-4-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602161921.208564-4-amoorthy@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OTBVPG8mru5mZB3f2H-c6aDI9A45DyD3
X-Proofpoint-ORIG-GUID: qS4furHV_RduUROiLjqaJG1AX6jLl6Jt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-04_16,2023-07-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=639 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307050073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

> +
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> +				     uint64_t gpa, uint64_t len, uint64_t flags)
> +{
> +	if (WARN_ON_ONCE(!vcpu))
> +		return;
> +
> +	preempt_disable();
> +	/*
> +	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
> +	 * would open the door for races between concurrent calls to this
> +	 * function.
> +	 */
> +	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> +		goto out;
Sorry, I also wrote to the v3 discussion for this patch.
Re-iterating what I said there:
Why use WARN_ON_ONCE when there is a clear possiblity of preemption
kicking in (with the possibility of vcpu_load/vcpu_put being called
in the new task) before preempt_disable() is called in this function ?
I think you should use WARN_ON_ONCE only where there is some impossible
or unhandled situation happening, not when there is a possibility of that
situation clearly happening as per the kernel code. I think that this WARN_ON_ONCE
could make sense if kvm_populate_efault_info() is called from atomic context,
but not when you are disabling preemption from this function itself.
Basically I don't think there is any way we can guarantee that
preemption DOESN'T kick in before the preempt_disable() such that
this if-check is actually something that deserves to have a kernel
WARN_ON_ONCE() warning.
Can we get rid of this WARN_ON_ONCE and straightaway jump to the
out label if "(vcpu != __this_cpu_read(kvm_running_vcpu))" is true, or
please do correct me if I am wrong about something ?
> +	/*
> +	 * Try not to overwrite an already-populated run struct.
> +	 * This isn't a perfect solution, as there's no guarantee that the exit
> +	 * reason is set before the run struct is populated, but it should prevent
> +	 * at least some bugs.
> +	 */
> +	else if (WARN_ON_ONCE(vcpu->run->exit_reason != KVM_EXIT_UNKNOWN))
> +		goto out;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +	vcpu->run->memory_fault.gpa = gpa;
> +	vcpu->run->memory_fault.len = len;
> +	vcpu->run->memory_fault.flags = flags;
> +
> +out:
> +	preempt_enable();
> +}
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 
