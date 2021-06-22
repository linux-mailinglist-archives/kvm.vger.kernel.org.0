Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5881E3B0AA2
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFVQwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:52:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229751AbhFVQwM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:52:12 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MGXH3U092752;
        Tue, 22 Jun 2021 12:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N+nCIBChoZxZTXIaXdw5uH30INWPR73VPJaaXcXTE90=;
 b=R2kZ2zaDpAGWqukvqHrQPCQMSDUgGh5g+Z9vTu6nNn+y0nprrWwTOnkt0EKI/L+TEci8
 2zucgQb133/euyKJcbK6vckd/pjYAlnbnJRw5XzTOJU790htOqC0xsUlbePncr9WdxdJ
 ZQ6A9Wa7QVI90LlyLb5fYiJKuNXCuAAAVRP5idcJwMfFklaWez3+R7rcPUyLboJ8u0+E
 FiSh/XzSmMsSV4Wu6hGpz3FzVzn5nuQxhLqmOtlJHdH1FVVHPRF/Up/B9Sr0B8QQlQMN
 ELoWf/aYHm4ZhZu+z5s+dzDgThjE6msKIp/bvB8gETVgTtRte+J5/MK9TO0G0ajiq6z0 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bjas3dd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:49:56 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MGYHon095228;
        Tue, 22 Jun 2021 12:49:55 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bjas3dcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 12:49:55 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MGmMZc024724;
        Tue, 22 Jun 2021 16:49:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhgvcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 16:49:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MGnp5d31982042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 16:49:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DD64C044;
        Tue, 22 Jun 2021 16:49:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 076284C04E;
        Tue, 22 Jun 2021 16:49:51 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.32.128])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 16:49:50 +0000 (GMT)
Subject: Re: [PATCH 0/2] KVM: s390: Enable some more facilities
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
 <871r8tontj.fsf@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <f9a467ba-2730-7a41-6cc5-dc0a5c9e34fc@de.ibm.com>
Date:   Tue, 22 Jun 2021 18:49:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <871r8tontj.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FLIG4R_DpXREgzPqvQqI1HE3v5SvsL_q
X-Proofpoint-GUID: XhbERjjXmvlxqjAdMfZG1UPB6ZFTidmF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-22,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.21 18:40, Cornelia Huck wrote:
> On Tue, Jun 22 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> Some more facilities that can be enabled in the future.
>>
>> Christian Borntraeger (2):
>>    KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
>>    KVM: s390: allow facility 192 (vector-packed-decimal-enhancement
>>      facility 2)
>>
>>   arch/s390/kvm/kvm-s390.c         | 4 ++++
>>   arch/s390/tools/gen_facilities.c | 4 ++++
>>   2 files changed, 8 insertions(+)
> 
> I assume we can also expect some QEMU patches sometime in the future
> that add some new features?

yes. Either today or tomorrow.
