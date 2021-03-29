Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0B434D007
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhC2MZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 08:25:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231150AbhC2MZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 08:25:27 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TC3MgN008493
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4NlLNNWIDR4WiYitPFcDwOGvqKapIekGe2LLxUnwLY4=;
 b=hJuDfPHT/HOWtqDMD7slD/7/v4B0DBpfDkkYlIY9BwM7r5/5VxX9YIyKuCMyv6hChUjx
 QKagNBeak7rZcwPGaCWhMeQC0dSi7/Nv4t/b32yYGG1kOd8jmHzwJaapkjwiT4BJ7HqD
 iiD47mokoFiknoDR5FF7xnB2MvFPIW9Xli40eblOxN5bE3Uh/oix+HR9xd9XY0ynZQOQ
 w6l8tYTP8DHz9cWiC5ecyLKydtwLAJADX0kLFpZeWZGXhvJrYlgXyOaYshdHi+DhxvPJ
 2BUxXR88zDGs7tdXfmhlAZgj3K5mqJVIi7+RbYeZlZquJ14RIgmVDD+Jcm7eoFRroXP3 ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsrp5ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:25:23 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TC3OB8008827
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:25:22 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsrp5e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 08:25:22 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TCMe7f001901;
        Mon, 29 Mar 2021 12:25:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 37hvb88xex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:25:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TCPHcK27853250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 12:25:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3217A42047;
        Mon, 29 Mar 2021 12:25:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C294242041;
        Mon, 29 Mar 2021 12:25:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 12:25:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
 <f2c2b1a9-d1ae-624b-7c1c-0636dcaa36c3@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a57e70de-a633-38a1-03ec-47610ca4c56d@linux.ibm.com>
Date:   Mon, 29 Mar 2021 14:25:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <f2c2b1a9-d1ae-624b-7c1c-0636dcaa36c3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tbrXf9ShpFWht67pRI4HCKfZUI-4ty4z
X-Proofpoint-ORIG-GUID: WY30unYWasmL-lnKQO4VJQcpKE4VsNUQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_08:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:09 AM, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> We need the SCSW definitions to test clear and halt subchannel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 23 +++++++++++++++++++++++
>>   1 file changed, 23 insertions(+)
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
