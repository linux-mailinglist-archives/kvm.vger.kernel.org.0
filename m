Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738C020A102
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405408AbgFYOn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 10:43:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405300AbgFYOn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 10:43:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PEaLI1193292;
        Thu, 25 Jun 2020 10:43:27 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ux080umb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 10:43:26 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05PEcEuS003122;
        Thu, 25 Jun 2020 10:43:26 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ux080ukj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 10:43:26 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05PEe3BQ015397;
        Thu, 25 Jun 2020 14:43:25 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 31uurvyx4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 14:43:25 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05PEhMg928508628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 14:43:22 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCAD5B2065;
        Thu, 25 Jun 2020 14:43:22 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91F45B2066;
        Thu, 25 Jun 2020 14:43:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.202.75])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Jun 2020 14:43:22 +0000 (GMT)
Subject: Re: [PATCH 2/2] docs: kvm: fix rst formatting
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, thuth@redhat.com
References: <20200624202200.28209-1-walling@linux.ibm.com>
 <20200624202200.28209-3-walling@linux.ibm.com>
 <20200625083423.2ee75bb1.cohuck@redhat.com>
 <22b7d435-480e-ac7f-de4f-b992df6c9ebb@linux.ibm.com>
 <20200625090942.21dbc0cf.cohuck@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <97c7d88f-1e97-1499-9e9a-77497a27d386@linux.ibm.com>
Date:   Thu, 25 Jun 2020 10:43:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625090942.21dbc0cf.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_10:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 cotscore=-2147483648 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/20 3:09 AM, Cornelia Huck wrote:
> On Thu, 25 Jun 2020 09:07:43 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 6/25/20 8:34 AM, Cornelia Huck wrote:
>>> On Wed, 24 Jun 2020 16:22:00 -0400
>>> Collin Walling <walling@linux.ibm.com> wrote:
>>>   
>>>> KVM_CAP_S390_VCPU_RESETS and KVM_CAP_S390_PROTECTED needed
>>>> just a little bit of rst touch-up
>>>>  
>>>
>>> Fixes: 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API")
>>> Fixes: 04ed89dc4aeb ("KVM: s390: protvirt: Add KVM api documentation")  
>>
>> Do we really do that for documentation changes?
> 
> Feel free to keep it or leave it :)
> 

I'm indifferent. I suppose I'll go with David's suggestion of
"Introduced in commit..."

Thanks for all the feedback. Will sent out v2 shortly.

-- 
Regards,
Collin

Stay safe and stay healthy
