Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2143934A39A
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCZJDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:03:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229871AbhCZJCj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:02:39 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8X2QR142086
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ChHqh1eWMXAaDVUFfLk8BTVkv/w6ggtncHywWPgDkdQ=;
 b=CA6yLIRDvCzAStLNY+bz/nghq4V7luxGDmqy0ZxZPF99tP3ezug2OTmorlXAKWTsN5o8
 N2J3lwfgegwDiliRVCDoQQK2KbKTRY4kYeTlWHthQToqsSOSxLr9pETrsXgP45YYFK9q
 PQ4tUXZeXJDtAr7J/9q5APWgMLGeIpztXgHE8kehCVsrq0GroiYIA4ElOSudqVQ1P1rf
 T4CY/j8fqooTMInICgV+T7xy66V5w6kBYdQsw2zXmPxau4SGpKe5nAPmvoHRHi5QRDhV
 jOH6bUyaK6y01qbVmsa736a73ElG3oBNAOBsVw77ek7dGdBc+0PWzJ1horlTMuPLHV1/ 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h5ekhsp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:02:39 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12Q8XfQH144073
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:02:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h5ekhsmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 05:02:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8vjmd013298;
        Fri, 26 Mar 2021 09:02:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37h1510fv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 09:02:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12Q92Xq440829258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 09:02:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A85FA4080;
        Fri, 26 Mar 2021 09:02:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B3A1A4099;
        Fri, 26 Mar 2021 09:02:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.63.51])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 09:02:33 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
 <fbd7c533-bc72-42c3-83dc-0b48fce08cb5@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <540936a8-a169-5eb6-06e0-1db56e993fb9@linux.ibm.com>
Date:   Fri, 26 Mar 2021 10:02:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <fbd7c533-bc72-42c3-83dc-0b48fce08cb5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QePlyvqR8aqLTSUWFFzX7lZCQ-2x-0ov
X-Proofpoint-GUID: nQZAKxvVpodI_NibBAgD-YCJPO9WsaHt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_02:2021-03-25,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/21 9:26 AM, Janosch Frank wrote:
> On 3/25/21 10:39 AM, Pierre Morel wrote:
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>

thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
