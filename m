Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA6D3EA0BA
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhHLIja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:39:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64926 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235414AbhHLIj0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 04:39:26 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C8Xqld083485;
        Thu, 12 Aug 2021 04:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nPi+tziXsWzLwlIC7He6b2SR5B8SMwXcjMRDxxWjICs=;
 b=opSjRzTF3vwyuvZVjtMMmpWc/KfE/0r5ac2fpdo2127b5AbXod3j5tE4lOlJwtUxI817
 n/TSevoCb9/jtgvjTg/1MfPrehvqIdg1YO3QOMzO68NwKOQEMhdFzyFQJna5DzdCATRt
 ss7+xe5LNcWU22uvjTQrWrK72oTcqMP3JwJQqJQ4yeXQrFoWcW8fQIweNJPaWL4/RKbZ
 l0dCAGWX8PLqbD1KmsmIlI44wJmm1ycFBXeBIc8vDpdjrPg2fveDjml4vGrwqB1V76gd
 CpbfvYUBfosZkXM8d36vk/EzqkQ3iRvoyAkNIlB2oii+BrzXgnLcWynpY7wb+JlczDED jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abt98gba7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 04:39:01 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17C8YVZL085695;
        Thu, 12 Aug 2021 04:39:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abt98gb9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 04:39:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17C8Y1ZZ026980;
        Thu, 12 Aug 2021 08:38:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn768smg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 08:38:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17C8ctUv49938858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 08:38:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 965224C064;
        Thu, 12 Aug 2021 08:38:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C4054C0B0;
        Thu, 12 Aug 2021 08:38:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 08:38:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Simplify stsi_get_fc
 and move it to library
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
 <b38410e3-5248-4e48-6577-c57673e89378@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4f85265e-a38b-f7a4-e3db-f1732c68effa@linux.ibm.com>
Date:   Thu, 12 Aug 2021 10:38:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b38410e3-5248-4e48-6577-c57673e89378@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fKhloq0ATNtjpYsEIY1G2KM6p2eJu4F3
X-Proofpoint-GUID: uK_MW1qzIB1f5ZVr6BcafNFrnu7cv7zn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_02:2021-08-11,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/11/21 5:01 PM, Janosch Frank wrote:
> On 8/10/21 6:22 PM, Pierre Morel wrote:
>> stsi_get_fc is now needed in multiple tests.
>>
>> As it does not need to store information but only returns
>> the machine level, suppress the address parameter.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> Please push this one to devel for coverage:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 

Thanks and done,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
