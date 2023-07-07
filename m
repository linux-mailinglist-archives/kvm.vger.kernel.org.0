Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B4974B047
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 13:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjGGLuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 07:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjGGLuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 07:50:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEACFE53
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 04:50:51 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 367BmEKI002105;
        Fri, 7 Jul 2023 11:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=OgrbxqxZiy/IEV/pD1B9ZsIerk6P1eg9FNEREDyUkBo=;
 b=rAQgeKn0poml1n3TpcdDi9n7v1mV2PIelNj54Rxqd2xNa4T7bgsITEYdle/P8J4+kOWT
 NrvuHa+ZXB6EPDCxWuqLyYhgvt3e4HReW6SgrDze9zqC2R42svkJliFcZsZ4lOQkJxN2
 bhisuj4v2Saagg28YLYeNYjYa5PxgnLPZV5HIUuXH52I/oj5BJSOz7Yi8wbBBsdJCoCP
 MkoOak3IB7pt5pKv6WQkyZWduUqsJ1Cvojqv74qM8yI7le+jaCALE+O8cTmKftn8b+NO
 igEveuxgVVf18ulF+hM9Mt4tOxbR8oIyqG6RN4Qo6GTQnLOcZtTeJJ268VqdUQYQm2Wj WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpj59g3j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 11:50:30 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 367BmibW005217;
        Fri, 7 Jul 2023 11:50:30 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpj59g3hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 11:50:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3677meuI016768;
        Fri, 7 Jul 2023 11:50:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rjbs4uyvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 11:50:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 367BoPmk43057786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 11:50:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9547B20040;
        Fri,  7 Jul 2023 11:50:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DEBF20043;
        Fri,  7 Jul 2023 11:50:20 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.179.3.211])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri,  7 Jul 2023 11:50:19 +0000 (GMT)
Date:   Fri, 7 Jul 2023 17:20:16 +0530
From:   Kautuk Consul <kconsul@linux.vnet.ibm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIn6VQSebTRN1jtX@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hKZ61VUave8D7AzCiDtdaJxWSBJ_c5bk
X-Proofpoint-GUID: ojZ9cFLOkXewqrpaSn_t0VT2W2qDTc9O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_08,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 clxscore=1015 mlxlogscore=755 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307070107
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
> 
> > +
> > +	preempt_disable();
> > +	/*
> > +	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
> > +	 * would open the door for races between concurrent calls to this
> > +	 * function.
> > +	 */
> > +	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> > +		goto out;
> 
> Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is an
> abomination that I wish didn't exist, not a pattern that should be copied.  If
> we do keep this sanity check, it can simply be
> 
> 	if (WARN_ON_ONCE(vcpu != kvm_get_running_vcpu()))
> 		return;
> 
> because as the comment for kvm_get_running_vcpu() explains, the returned vCPU
> pointer won't change even if this task gets migrated to a different pCPU.  If
> this code were doing something with vcpu->cpu then preemption would need to be
> disabled throughout, but that's not the case.
> 
I think that this check is needed but without the WARN_ON_ONCE as per my 
other comment.
Reason is that we really need to insulate the code against preemption
kicking in before the call to preempt_disable() as the logic seems to
need this check to avoid concurrency problems.
(I don't think Anish simply copied this if-check from mark_page_dirty_in_slot)
