Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F293F4741
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhHWJSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 05:18:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8194 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235785AbhHWJSA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 05:18:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17N92lFe126298;
        Mon, 23 Aug 2021 05:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rLcSNFjcfA/ZrjBflytK2z0AIpIHCYuemF2e14i4OJA=;
 b=hQSVHtCNXgUKI94AfH2p6AI3Z/Z4w60QGXXei/p7JyUhznQBI0iMZKz1Lb+3+iO6cAfw
 9FMIVEXOtbGgyQEKYaez7jn6goOA8+ZOoz3PSK4x4U1sOBhRlLstIC7Pox4EgEMHPxdG
 2YcueXDdrk3Y+WS/AM4LYLmLfR0cGfJ3pOPluroXtRIS270FnnheCD4c8lHnxcQs//NC
 cqC9k4M0zOZNskh7nfHm+Au1pgkPJ6VvW4NoBf3e1lfOooMuuP8EiVNwuy2oMHVZq2cV
 XBUaAX/FGbR/W0P7EE6yrbHHCyqcudC//0tQ0NT3irXFj8+PA5f+qVOlMc8kdjpR1rqb gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3am6nkbscg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 05:17:17 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17N9310d127284;
        Mon, 23 Aug 2021 05:17:17 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3am6nkbsbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 05:17:17 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17N9HFkt029424;
        Mon, 23 Aug 2021 09:17:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3ajs48ajyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 09:17:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17N9H8bH52035906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 09:17:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D34D152065;
        Mon, 23 Aug 2021 09:17:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.22.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8E97952071;
        Mon, 23 Aug 2021 09:17:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Simplify stsi_get_fc
 and move it to library
To:     Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
 <887680c1-f5e7-0fdb-2195-e501e607c905@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <bfea0441-de24-37de-8472-524a3bc46761@linux.ibm.com>
Date:   Mon, 23 Aug 2021 11:17:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <887680c1-f5e7-0fdb-2195-e501e607c905@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vzbgeQwZxra_eOmfZbj1ljVbICwlrLhX
X-Proofpoint-ORIG-GUID: QVMfbJ-faIEzXzHbR2SGu2lFZjhg8SzY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_02:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/18/21 9:45 AM, Thomas Huth wrote:
> On 10/08/2021 18.22, Pierre Morel wrote:
>> stsi_get_fc is now needed in multiple tests.
>>
>> As it does not need to store information but only returns
>> the machine level, suppress the address parameter.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>>   s390x/stsi.c             | 20 ++------------------
>>   2 files changed, 18 insertions(+), 18 deletions(-)
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
