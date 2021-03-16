Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0232633D1C8
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhCPK1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:27:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236612AbhCPK1l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:27:41 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GA4NSk152158
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PM95sIxEPyrwDeEFbT++SXa/UbHFepuM/e4kT/JNFw0=;
 b=oVRT7+1elR9TgaYffLBcp/be3IEfLzXbSYYH5DsIhVX4kTjvA8GobmYhKQW3Br7ijxV0
 ILu1tNOZVXlmz5PuM1UbQbwsshl2equQtOcHynP+odvh0MrlkDFYunrqBZen0Hms4cAj
 ydpLPSE0UBt5FsC1WmiTM1+fk7Ewy612V/YkWf63AKanm4PQjOE8hzfXblT5pe1sX9Ga
 yAJ2v+9vfBGRhsSRtoS/oJqqXeAdyRQTMP9uaqZ97Pd7HOBjG3EnJKTBY+y6khdBHLhb
 Dy7XjMSqunKIOxVkJb7iDdzdKUHbsIHFbSF+8AYowtOPr3n4zrbCwC+dPbVKhsxLe7uk PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ap24yw6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:39 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12GAOELR030149
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:39 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ap24yw69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 06:27:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12GAM2As015819;
        Tue, 16 Mar 2021 10:27:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18jqjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 10:27:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12GARZ6q37814774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 10:27:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4C7052057;
        Tue, 16 Mar 2021 10:27:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A358052054;
        Tue, 16 Mar 2021 10:27:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 5/6] s390x: css: testing measurement
 block format 0
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-6-git-send-email-pmorel@linux.ibm.com>
 <0b2ebdfd-c6f9-bca2-b2d7-5187bdfab4a2@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <77a4f765-a225-f2f4-ef1a-24a761088d67@linux.ibm.com>
Date:   Tue, 16 Mar 2021 11:27:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0b2ebdfd-c6f9-bca2-b2d7-5187bdfab4a2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/15/21 11:53 AM, Janosch Frank wrote:
> On 3/12/21 11:41 AM, Pierre Morel wrote:
>> We test the update of the measurement block format 0, the
>> measurement block origin is calculated from the mbo argument
>> used by the SCHM instruction and the offset calculated using
>> the measurement block index of the SCHIB.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
>> ---
thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
