Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED734967E
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYQNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:13:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229730AbhCYQNj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:13:39 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG4SSW008226
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y3acvgzNUu/hFnvkC0yI2mKKzXytv16UcYxQ6WDIcNA=;
 b=iXiXMlMt+pe+CKyDpj0L1tlhYuukZjAoPiJ5FgVTWjLbUC01X8eHS//h33cLq5g4gDd6
 I3bafXO21BlyABFEbLIhinGNIaNGz1PLQPVFWm0zbovUDu/kF+semuYyRAqEYmPwXr+S
 TKFXHSKwqKFRmDd1C9nfrlL2Qp5N0bd0K34cggAuTJzPvAHK8J58UAwFLnVUNBXnfqAu
 ctIReLvD8S+B7R9jR6u7pdLDL0t6Dnv67Ic40qEMGz1KT4+qS46CU1avxbM//IIlf0Y4
 0q3AWlDxGK48maSTYgM5+ZgdqG07a597Ix8GdHWziiGlMDYDG16b5s2h4DzfbZpFwbUZ Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvavkc2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:13:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG4ZMt009009
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:13:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvavkc28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:13:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PG7fGB008423;
        Thu, 25 Mar 2021 16:13:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 37d9bmnhkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:13:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PGDF6l27329018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:13:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80EDD11C04C;
        Thu, 25 Mar 2021 16:13:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4319611C04A;
        Thu, 25 Mar 2021 16:13:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:13:33 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
 <20210325160041.28516b9b@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <99958800-ad39-099f-6a09-eed73247c100@linux.ibm.com>
Date:   Thu, 25 Mar 2021 17:13:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325160041.28516b9b@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 4:00 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:01 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We need the SCSW definitions to test clear and halt subchannel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
>> ---

Thanks,
Pierre


> 

-- 
Pierre Morel
IBM Lab Boeblingen
