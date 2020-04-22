Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A01B3ADF
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDVJLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 05:11:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgDVJLZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 05:11:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M92em6078165
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:11:25 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvhv9w1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:11:24 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 22 Apr 2020 10:10:29 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 10:10:26 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M9BI7956623312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:11:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32267A409A;
        Wed, 22 Apr 2020 09:11:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2BEBA4082;
        Wed, 22 Apr 2020 09:11:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.55.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 09:11:17 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 03/10] s390x: cr0: adding AFP-register
 control bit
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-4-git-send-email-pmorel@linux.ibm.com>
 <a40f5061-e261-a6dd-ea6a-a8bec703175f@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 22 Apr 2020 11:11:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a40f5061-e261-a6dd-ea6a-a8bec703175f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042209-0020-0000-0000-000003CC6ACF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042209-0021-0000-0000-0000222565DF
Message-Id: <a3083ef7-d007-f6e9-9770-fc5fd158d95f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_03:2020-04-21,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-22 09:39, Janosch Frank wrote:
> On 2/20/20 1:00 PM, Pierre Morel wrote:
>> While adding the definition for the AFP-Register control bit, move all
>> existing definitions for CR0 out of the C zone to the assmbler zone to
>> keep the definitions concerning CR0 together.
> 
> How about:
> s390x: Move control register bit definitions and add AFP to them
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
If no one disagree I'll pick it.

Thanks for the review
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

