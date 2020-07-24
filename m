Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EFC22CCBE
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 20:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGXSCb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 24 Jul 2020 14:02:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgGXSCb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 14:02:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OHi6ak169093;
        Fri, 24 Jul 2020 14:02:21 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32fack89yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 14:02:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06OHp7LG029088;
        Fri, 24 Jul 2020 18:02:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32brq845ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 18:02:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06OI2Ejl30212556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 18:02:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A096CA4040;
        Fri, 24 Jul 2020 18:02:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 461D5A4053;
        Fri, 24 Jul 2020 18:02:11 +0000 (GMT)
Received: from [9.85.74.228] (unknown [9.85.74.228])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Jul 2020 18:02:11 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [v3 13/15] tools/perf: Add perf tools support for extended
 register capability in powerpc
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
In-Reply-To: <7fcf405f-440a-19dc-7c3a-33fc52c9d1ef@linux.ibm.com>
Date:   Fri, 24 Jul 2020 23:32:08 +0530
Cc:     Gautham R Shenoy <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>, maddy@linux.vnet.ibm.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        acme@kernel.org, jolsa@kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4940969B-501F-4F1E-B233-B1047EDD1384@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-14-git-send-email-atrajeev@linux.vnet.ibm.com>
 <7fcf405f-440a-19dc-7c3a-33fc52c9d1ef@linux.ibm.com>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_07:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 24-Jul-2020, at 4:32 PM, Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:
> 
> Hi Athira,
> 
> On 7/17/20 8:08 PM, Athira Rajeev wrote:
>> From: Anju T Sudhakar <anju@linux.vnet.ibm.com>
>> Add extended regs to sample_reg_mask in the tool side to use
>> with `-I?` option. Perf tools side uses extended mask to display
>> the platform supported register names (with -I? option) to the user
>> and also send this mask to the kernel to capture the extended registers
>> in each sample. Hence decide the mask value based on the processor
>> version.
>> Currently definitions for `mfspr`, `SPRN_PVR` are part of
>> `arch/powerpc/util/header.c`. Move this to a header file so that
>> these definitions can be re-used in other source files as well.
> 
> It seems this patch has a regression.
> 
> Without this patch:
> 
>  $ sudo ./perf record -I
>  ^C[ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.458 MB perf.data (318 samples) ]
> 
> With this patch:
> 
>  $ sudo ./perf record -I
>  Error:
>  dummy:HG: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'


Hi Ravi,

Thanks for reviewing this patch and also testing. The above issue happens since
commit 0a892c1c9472 ("perf record: Add dummy event during system wide synthesis”) which adds a dummy event.

The fix for this issue is currently discussed here:  https://lkml.org/lkml/2020/7/19/413
So once this fix is in, the issue will be resolved.

Thanks
Athira

> 
> Ravi

