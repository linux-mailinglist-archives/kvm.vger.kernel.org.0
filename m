Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0B53C81D3
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbhGNJln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 05:41:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36762 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238189AbhGNJlm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 05:41:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E9XcRS162958;
        Wed, 14 Jul 2021 05:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5JLFl30o09Kpy4DAtWSnZKK8AwMuy4ePYcYLOD5TpoA=;
 b=r8LEnHgpgEIohtME0rrBVlV1lRegGYMC517GgCmfNTQ7egL7UPyiuAGxWBd5H0RLM45k
 ziOUxRL5UNQD0MAPJS2kOsXh+tb4LznrQxUsvf5MHKO4RVUfOxIPqXIoPCx0buYmD9h6
 GPw3zVEykirl2D8SISWQRiDEPqG6rJMFluBloUG4Kgqs6lnilNrtktdwtNPn+4esp3Y+
 eFqx0G1DLkodR0od3GwUMiMif4YY7TX15NSibLuqUkaZH5q8pYTaa/GJCIz5sz/1Ui/o
 bM/dlZtNYXUQKQXfkkCXrf9FBK8AngznvG+vtrVHSCK6nXXepHdnaIGyNBt5W02tR73P +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ssmqxh4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 05:38:50 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16E9bXq1177116;
        Wed, 14 Jul 2021 05:38:50 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ssmqxh3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 05:38:50 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16E9X1mJ001865;
        Wed, 14 Jul 2021 09:38:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2th9q3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 09:38:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16E9cjvZ29950422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 09:38:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 089DF5206B;
        Wed, 14 Jul 2021 09:38:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.177])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9A285204F;
        Wed, 14 Jul 2021 09:38:44 +0000 (GMT)
Date:   Wed, 14 Jul 2021 11:38:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
Message-ID: <20210714113843.6daa7e09@p-imbrenda>
In-Reply-To: <20210713145713.2815167-1-hca@linux.ibm.com>
References: <20210713145713.2815167-1-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4_Zkm34kBy17UFmecU7QEEIkjdgr3N5p
X-Proofpoint-GUID: QIlcN9EKBRjJfJXTfh2aT2tC2KAu4ymP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_04:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jul 2021 16:57:13 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

[snip]

> +#define HYPERCALL_ARGS_0
> +#define HYPERCALL_ARGS_1 , arg1
> +#define HYPERCALL_ARGS_2 HYPERCALL_ARGS_1, arg2
> +#define HYPERCALL_ARGS_3 HYPERCALL_ARGS_2, arg3
> +#define HYPERCALL_ARGS_4 HYPERCALL_ARGS_3, arg4
> +#define HYPERCALL_ARGS_5 HYPERCALL_ARGS_4, arg5
> +#define HYPERCALL_ARGS_6 HYPERCALL_ARGS_5, arg6
> +
> +#define GENERATE_KVM_HYPERCALL_FUNC(args)
> 	\ +static inline
> 			\ +long __kvm_hypercall##args(unsigned long
> nr HYPERCALL_PARM_##args)	\ +{
> 					\
> +	register unsigned long __nr asm("1") = nr;
> 	\
> +	register long __rc asm("2");
> 	\

didn't we want to get rid of asm register allocations?

this would have been a nice time to do such a cleanup

> +	HYPERCALL_REGS_##args;
> 		\
> +
> 	\
> +	asm volatile (
> 		\
> +		"	diag	2,4,0x500\n"
> 		\
> +		: "=d" (__rc)
> 	\
> +		: "d" (__nr) HYPERCALL_FMT_##args
> 	\
> +		: "memory", "cc");
> 	\
> +	return __rc;
> 	\ +}
> 		\
> +
> 	\ +static inline
> 			\ +long kvm_hypercall##args(unsigned long nr
> HYPERCALL_PARM_##args)	\ +{
> 					\
> +	diag_stat_inc(DIAG_STAT_X500);
> 		\
> +	return __kvm_hypercall##args(nr
> HYPERCALL_ARGS_##args);		\ +}
> +
> +GENERATE_KVM_HYPERCALL_FUNC(0)
> +GENERATE_KVM_HYPERCALL_FUNC(1)
> +GENERATE_KVM_HYPERCALL_FUNC(2)
> +GENERATE_KVM_HYPERCALL_FUNC(3)
> +GENERATE_KVM_HYPERCALL_FUNC(4)
> +GENERATE_KVM_HYPERCALL_FUNC(5)
> +GENERATE_KVM_HYPERCALL_FUNC(6)
>  
>  /* kvm on s390 is always paravirtualization enabled */
>  static inline int kvm_para_available(void)

