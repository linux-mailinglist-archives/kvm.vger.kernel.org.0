Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5853B3EA09E
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhHLIgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:36:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhHLIgc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 04:36:32 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C8Zohn060895;
        Thu, 12 Aug 2021 04:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FXu7enlVFhUcsDPME+78LmRZ/lauumeUT0tYKuGKGyk=;
 b=X+KzIbxo3LsmPFtkpcCmIONBS9RomiO6EmEkW5P4UNe87bIEYDY+4uVIkuBDnRogqZ9g
 WlQVXjR0SoQkZQfBJeUpyytMtGI2PLUjYbhnAKTPHfIFqMJDIQZW7TKGJJUC1lxvZIZi
 uka9WgSl4olIXS/+Ky9+jcJjl+h1oAwAxB4AICisT7/gycF39038lmkBGB3r/GbwIScM
 SaBc1CjKL0IgRA/NXjyRHBc9HbvLFlpuQLljI+z/5hkHBCQx9BwuW2JqOzUbUzhIJbMg
 rj6042e6z3IWBQVxGe1tpSlLH1qQe6nk9wAnCEw/ZYpCYhYy32jjWUvXQLSt43DF5wWx 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abrv041gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 04:36:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17C8a7dW062246;
        Thu, 12 Aug 2021 04:36:07 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abrv041gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 04:36:07 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17C8XwUv026584;
        Thu, 12 Aug 2021 08:36:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn768sfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 08:36:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17C8Wm0115991160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 08:32:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 711944C08A;
        Thu, 12 Aug 2021 08:36:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26CDB4C0A9;
        Thu, 12 Aug 2021 08:36:01 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 08:36:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy nested
 level
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
 <313172a3-6074-1bc5-f0fc-c48394b6f9bc@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <3b1cb76d-d416-b91f-2a1a-28a951e97e4d@linux.ibm.com>
Date:   Thu, 12 Aug 2021 10:36:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <313172a3-6074-1bc5-f0fc-c48394b6f9bc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AEyTs72FiKg7-zVeGa2n99BMRHk-Xi3L
X-Proofpoint-ORIG-GUID: hPeX5EyVBajrkiyyZ-maB-OOVriwFbMN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_02:2021-08-11,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/11/21 4:59 PM, Janosch Frank wrote:
> On 8/10/21 6:22 PM, Pierre Morel wrote:
>> The maximum CPU Topology nested level is available with the SCLP
>> READ_INFO command inside the byte at offset 15 of the ReadInfo
>> structure.
>>
>> Let's return this information to check the number of topology nested
>> information available with the STSI 15.1.x instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
