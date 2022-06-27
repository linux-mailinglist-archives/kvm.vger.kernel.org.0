Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA355DDF1
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiF0J2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 05:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiF0J21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 05:28:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3F963CF;
        Mon, 27 Jun 2022 02:28:25 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25R8DSsP029787;
        Mon, 27 Jun 2022 09:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XGSUXB3Rcsiln6Kp4JHxXDV3T+MukAKiofOmAn6K9FA=;
 b=Q5b886FlV11rBGoN7GKImaVBllKgG4qk+8CXwCJ09cHOkvNDojUETWBLsafDeofNW1sQ
 lydWc4sQpLSkkgd0xQlj4/Pk3zfcRyxQVtTAG1L6f8o5VeY4ousyz1T2rSl/sc7m8x56
 grue5xJ+OA4uGnoEwN0kl5gfttfQ2RiB1DXca13JbQe5XxBKo0RECfBHCgsIHTNM1qDy
 6JxQg6eZruUNWgjs8htCfAQkSA/BTpXxzo1w65zN/eDXjgJG/G3HD9BuI+V8L3PtBRM2
 lyYQrk1jrvsmU+HK6L/w/0PzffBQjyu0gcYHl4ITX89lGoNSL7fXNxQePIihKShKfZ+o Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy8ug1wbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 09:28:24 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25R8DxV4030520;
        Mon, 27 Jun 2022 09:28:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy8ug1wb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 09:28:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25R9LU0r014505;
        Mon, 27 Jun 2022 09:28:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj2nsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 09:28:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25R9SPKa24248742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 09:28:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41830A4040;
        Mon, 27 Jun 2022 09:28:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2BA7A404D;
        Mon, 27 Jun 2022 09:28:18 +0000 (GMT)
Received: from [9.145.155.49] (unknown [9.145.155.49])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 09:28:18 +0000 (GMT)
Message-ID: <19169d83-ad31-da70-b3bb-bd7ba43e6484@linux.ibm.com>
Date:   Mon, 27 Jun 2022 11:28:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
 <20220624144518.66573-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: better smp interrupt
 checks
In-Reply-To: <20220624144518.66573-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C85qOWR_UfaN6IIVSzAC9gsZs66nm6bM
X-Proofpoint-GUID: c9dFpqbIRrqyzD70Pmr-4XSN0vEuRZTQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/22 16:45, Claudio Imbrenda wrote:
> Use per-CPU flags and callbacks for Program and Extern interrupts,
> instead of global variables.
> 
> This allows for more accurate error handling; a CPU waiting for an
> interrupt will not have it "stolen" by a different CPU that was not
> supposed to wait for one, and now two CPUs can wait for interrupts at
> the same time.
> 
> This will significantly improve error reporting and debugging when
> things go wrong.
> 
> Both program interrupts and extern interrupts are now CPU-bound, even
> though some extern interrupts are floating (notably, the SCLP
> interrupt). In those cases, the testcases should mask interrupts and/or
> expect them appropriately according to need.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 17 +++++++++++-
>   lib/s390x/smp.h          |  8 +-----
>   lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++++-----------
>   lib/s390x/smp.c          | 11 ++++++++
>   4 files changed, 70 insertions(+), 23 deletions(-)
[...]
>   
> +struct lowcore *smp_get_lowcore(uint16_t idx)
> +{
> +	if (THIS_CPU->idx == idx)
> +		return &lowcore;
> +
> +	check_idx(idx);
> +	return cpus[idx].lowcore;
> +}

This function is unused.

> +
>   int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
>   {
>   	check_idx(idx);
> @@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
>   
>   	/* Copy all exception psws. */
>   	memcpy(lc, cpus[0].lowcore, 512);
> +	lc->this_cpu = cpus + idx;

Why not:
lc->this_cpu = &cpus[idx];

>   
>   	/* Setup stack */
>   	cpus[idx].stack = (uint64_t *)alloc_pages(2);
> @@ -325,6 +335,7 @@ void smp_setup(void)
>   	for (i = 0; i < num; i++) {
>   		cpus[i].addr = entry[i].address;
>   		cpus[i].active = false;
> +		cpus[i].idx = i;
>   		/*
>   		 * Fill in the boot CPU. If the boot CPU is not at index 0,
>   		 * swap it with the one at index 0. This guarantees that the

