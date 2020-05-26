Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A611E2103
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgEZLjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:39:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731446AbgEZLjb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 07:39:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QBVsC2034789;
        Tue, 26 May 2020 07:39:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316y4ubg7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:39:30 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QBW3Yf035250;
        Tue, 26 May 2020 07:39:30 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316y4ubg72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:39:30 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QBbSLG001051;
        Tue, 26 May 2020 11:39:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 316uf8wu78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 11:39:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QBdPDk62063042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 11:39:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B439C4204B;
        Tue, 26 May 2020 11:39:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6928C42045;
        Tue, 26 May 2020 11:39:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.178.226])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 11:39:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 01/12] s390x: saving regs for interrupts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-2-git-send-email-pmorel@linux.ibm.com>
 <e06ed054-6038-3a7e-3eda-0d37ee382919@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ec90a237-0edb-121e-6c16-f1dc96a3a169@linux.ibm.com>
Date:   Tue, 26 May 2020 13:39:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e06ed054-6038-3a7e-3eda-0d37ee382919@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_01:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005260083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 12:30, Janosch Frank wrote:
> On 5/18/20 6:07 PM, Pierre Morel wrote:
>> If we use multiple source of interrupts, for example, using SCLP
>> console to print information while using I/O interrupts, we need
>> to have a re-entrant register saving interruption handling.
>>
>> Instead of saving at a static memory address, let's save the base
>> registers, the floating point registers and the floating point
>> control register on the stack in case of I/O interrupts
>>
>> Note that we keep the static register saving to recover from the
>> RESET tests.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Some nits below
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
> 

Thanks, I will modify the nits as you proposed.

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
