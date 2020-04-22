Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50EA1B36FD
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 07:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgDVFy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 01:54:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgDVFy1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 01:54:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M5WDln019561
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:54:26 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gj24ffq8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:54:26 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 22 Apr 2020 06:53:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 06:53:45 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M5sJq626345580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 05:54:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CA54A4053;
        Wed, 22 Apr 2020 05:54:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F67BA4040;
        Wed, 22 Apr 2020 05:54:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.55.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 05:54:19 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 03/10] s390x: cr0: adding AFP-register
 control bit
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-4-git-send-email-pmorel@linux.ibm.com>
 <a4ce1829-027e-d632-be2b-9f6b59d9b96d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 22 Apr 2020 07:54:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a4ce1829-027e-d632-be2b-9f6b59d9b96d@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042205-0008-0000-0000-0000037529FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042205-0009-0000-0000-00004A96F1CF
Message-Id: <b7cd0ae4-ce3d-52a9-697a-d2d6e04bf953@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_10:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220041
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-21 18:15, David Hildenbrand wrote:
> On 20.02.20 13:00, Pierre Morel wrote:
>> While adding the definition for the AFP-Register control bit, move all
>> existing definitions for CR0 out of the C zone to the assmbler zone to
>> keep the definitions concerning CR0 together.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
...snip...
>> -	.quad	0x0000000000040000
>> +	.quad	CR0_AFP_REG_CRTL
>>
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

