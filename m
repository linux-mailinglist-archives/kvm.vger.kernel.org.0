Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED1F22C520
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgGXM1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 08:27:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726381AbgGXM1L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 08:27:11 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OCNcsu012438;
        Fri, 24 Jul 2020 08:26:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32fadg2grp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 08:26:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06OCHjZY007328;
        Fri, 24 Jul 2020 12:26:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 32brq879g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 12:26:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06OCQr5G66322784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 12:26:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 704584203F;
        Fri, 24 Jul 2020 12:26:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18A6942049;
        Fri, 24 Jul 2020 12:26:51 +0000 (GMT)
Received: from [9.199.32.41] (unknown [9.199.32.41])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jul 2020 12:26:50 +0000 (GMT)
Subject: Re: [v3 12/15] powerpc/perf: Add support for outputting extended regs
 in perf intr_regs
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     mpe@ellerman.id.au, ego@linux.vnet.ibm.com, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org, linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Message-ID: <b7aa5dfb-273b-e0f7-6337-c71094c666cd@linux.ibm.com>
Date:   Fri, 24 Jul 2020 17:56:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594996707-3727-13-git-send-email-atrajeev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_03:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Athira,

> +/* Function to return the extended register values */
> +static u64 get_ext_regs_value(int idx)
> +{
> +	switch (idx) {
> +	case PERF_REG_POWERPC_MMCR0:
> +		return mfspr(SPRN_MMCR0);
> +	case PERF_REG_POWERPC_MMCR1:
> +		return mfspr(SPRN_MMCR1);
> +	case PERF_REG_POWERPC_MMCR2:
> +		return mfspr(SPRN_MMCR2);
> +	default: return 0;
> +	}
> +}
> +
>   u64 perf_reg_value(struct pt_regs *regs, int idx)
>   {
> -	if (WARN_ON_ONCE(idx >= PERF_REG_POWERPC_MAX))
> -		return 0;
> +	u64 PERF_REG_EXTENDED_MAX;

PERF_REG_EXTENDED_MAX should be initialized. otherwise ...

> +
> +	if (cpu_has_feature(CPU_FTR_ARCH_300))
> +		PERF_REG_EXTENDED_MAX = PERF_REG_MAX_ISA_300;
>   
>   	if (idx == PERF_REG_POWERPC_SIER &&
>   	   (IS_ENABLED(CONFIG_FSL_EMB_PERF_EVENT) ||
> @@ -85,6 +103,16 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
>   	    IS_ENABLED(CONFIG_PPC32)))
>   		return 0;
>   
> +	if (idx >= PERF_REG_POWERPC_MAX && idx < PERF_REG_EXTENDED_MAX)
> +		return get_ext_regs_value(idx);

On non p9/p10 machine, PERF_REG_EXTENDED_MAX may contain random value which will
allow user to pass this if condition unintentionally.

Neat: PERF_REG_EXTENDED_MAX is a local variable so it should be in lowercase.
Any specific reason to define it in capital?

Ravi
