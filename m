Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D447222CCD7
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 20:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgGXSNw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 24 Jul 2020 14:13:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgGXSNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 14:13:52 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OI3K9L049700;
        Fri, 24 Jul 2020 14:13:45 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32fac4c6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 14:13:45 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06OIBK6B025023;
        Fri, 24 Jul 2020 18:13:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7xcpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 18:13:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06OIDeZs32899382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 18:13:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0ACDA404D;
        Fri, 24 Jul 2020 18:13:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51A46A405B;
        Fri, 24 Jul 2020 18:13:37 +0000 (GMT)
Received: from [9.85.74.228] (unknown [9.85.74.228])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Jul 2020 18:13:36 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [v3 12/15] powerpc/perf: Add support for outputting extended regs
 in perf intr_regs
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
In-Reply-To: <b7aa5dfb-273b-e0f7-6337-c71094c666cd@linux.ibm.com>
Date:   Fri, 24 Jul 2020 23:43:34 +0530
Cc:     Gautham R Shenoy <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>, maddy@linux.vnet.ibm.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        acme@kernel.org, jolsa@kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <763A7E0C-24E4-4F60-AE92-F0DBB64BAE4B@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
 <b7aa5dfb-273b-e0f7-6337-c71094c666cd@linux.ibm.com>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_07:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 24-Jul-2020, at 5:56 PM, Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:
> 
> Hi Athira,
> 
>> +/* Function to return the extended register values */
>> +static u64 get_ext_regs_value(int idx)
>> +{
>> +	switch (idx) {
>> +	case PERF_REG_POWERPC_MMCR0:
>> +		return mfspr(SPRN_MMCR0);
>> +	case PERF_REG_POWERPC_MMCR1:
>> +		return mfspr(SPRN_MMCR1);
>> +	case PERF_REG_POWERPC_MMCR2:
>> +		return mfspr(SPRN_MMCR2);
>> +	default: return 0;
>> +	}
>> +}
>> +
>>  u64 perf_reg_value(struct pt_regs *regs, int idx)
>>  {
>> -	if (WARN_ON_ONCE(idx >= PERF_REG_POWERPC_MAX))
>> -		return 0;
>> +	u64 PERF_REG_EXTENDED_MAX;
> 
> PERF_REG_EXTENDED_MAX should be initialized. otherwise ...
> 
>> +
>> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
>> +		PERF_REG_EXTENDED_MAX = PERF_REG_MAX_ISA_300;
>>    	if (idx == PERF_REG_POWERPC_SIER &&
>>  	   (IS_ENABLED(CONFIG_FSL_EMB_PERF_EVENT) ||
>> @@ -85,6 +103,16 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
>>  	    IS_ENABLED(CONFIG_PPC32)))
>>  		return 0;
>>  +	if (idx >= PERF_REG_POWERPC_MAX && idx < PERF_REG_EXTENDED_MAX)
>> +		return get_ext_regs_value(idx);
> 
> On non p9/p10 machine, PERF_REG_EXTENDED_MAX may contain random value which will
> allow user to pass this if condition unintentionally.

> 
> Neat: PERF_REG_EXTENDED_MAX is a local variable so it should be in lowercase.
> Any specific reason to define it in capital?

Hi Ravi

There is no specific reason. I will include both these changes in next version

Thanks
Athira Rajeev


> 
> Ravi

