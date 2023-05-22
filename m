Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F78E70C0E2
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 16:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjEVOT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 10:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbjEVOTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 10:19:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD4DF9;
        Mon, 22 May 2023 07:19:51 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MEFPol018220;
        Mon, 22 May 2023 14:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=z2ZSDd89AXbLMt+6T7YsO2fdF0Yi8CPnR5yZ/lkSqSY=;
 b=b6NU5OeCXax+WrVwHJKBxU/2eP96sPFh/BlyPWwACQ/7wUWy6YKEjXCQw9pGRd6Hq9u6
 MLWn9B4REgKuxAwXLXxVoiQ/caTY+5b2VJYARsH2GLmnE/WF+75uxVAMsycMBbGGbTN0
 WdlESeBK8OJxuulsQRedH+dgpSmBwtogMv1YWS89315e3uleicCPE65liI3FCc0CRUsp
 IMoEoP6IguzCWOKm9MeOaeUZ0trUtnp3AJqz9TIT2AQ7wc2ARtMGjMJ+GvNpVqnqflEm
 38hJ8QrXOMCAwnMAHMotE71twb0+4R7u+wbmNBqvd9/1givEuwWgmivHIjEM5kOfo1wL Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qr8y9au0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 14:18:53 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MEFUDT018701;
        Mon, 22 May 2023 14:18:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qr8y9atyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 14:18:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M812dN006123;
        Mon, 22 May 2023 14:18:49 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qppe08ty6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 14:18:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MEIj8V35258654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 14:18:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7DAC2004B;
        Mon, 22 May 2023 14:18:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2169620040;
        Mon, 22 May 2023 14:18:43 +0000 (GMT)
Received: from osiris (unknown [9.171.20.176])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 22 May 2023 14:18:43 +0000 (GMT)
Date:   Mon, 22 May 2023 16:18:41 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 06/13] s390/time: Provide sched_clock_noinstr()
Message-ID: <ZGt5wR/VyVFTPHEK@osiris>
References: <20230519102058.581557770@infradead.org>
 <20230519102715.570170436@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519102715.570170436@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8u38vrNKBwlno1xrZVRe_usY_SDPYYwI
X-Proofpoint-GUID: -02WeZ8d1wkDcrhX0-M0Ma7vvv7DyGGi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_10,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0
 mlxlogscore=643 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:21:04PM +0200, Peter Zijlstra wrote:
> With the intent to provide local_clock_noinstr(), a variant of
> local_clock() that's safe to be called from noinstr code (with the
> assumption that any such code will already be non-preemptible),
> prepare for things by providing a noinstr sched_clock_noinstr()
> function.
> 
> Specifically, preempt_enable_*() calls out to schedule(), which upsets
> noinstr validation efforts.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/s390/include/asm/timex.h |   13 +++++++++----
>  arch/s390/kernel/time.c       |   11 ++++++++++-
>  2 files changed, 19 insertions(+), 5 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>
