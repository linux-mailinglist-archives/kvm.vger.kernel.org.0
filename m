Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB0B3BC7B8
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 10:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhGFIUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 04:20:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7436 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230257AbhGFIUx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 04:20:53 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16683wOJ061522;
        Tue, 6 Jul 2021 04:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3D4pvzYUr06tmIJqrEmEDWqgbM/4TgVCyf0WVq5NWus=;
 b=F6jQS1uMbrRIQV/VC1Rq9EV0tikxutY8jOdxzBw7cc4yeIx+Cpf/8d/PjamTdvbx2R51
 jzryLN6q2f/gXz2xEcto2hN7GJZqRG/r/K2IP9Z8LzYQNliTdn6GaGNcT+ZFecQrks+f
 O23xbSUPUjWYudvhqC87JGx5fAoHrig4SeBSHBiAbENEgPYc7gqeuNvUnNR1uGHprLp8
 HJDwryQZfp6ITvBcWRP0xbmZ+ASVS6MumuHge0PcYxonQkYeKqAR+KPUOifKFFLy1G90
 WLIf/nN2xIqUxoNGZ/502mLCf9UD1t0fHrdcH64nyCUTAMwScwnNpBrzxQCWRXoyBLNs yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14sspp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:18:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16685tCI070742;
        Tue, 6 Jul 2021 04:18:14 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14ssp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:18:14 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1668I8MO019334;
        Tue, 6 Jul 2021 08:18:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h94s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1668IA9o33685994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 08:18:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 673404C04E;
        Tue,  6 Jul 2021 08:18:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 065DA4C058;
        Tue,  6 Jul 2021 08:18:10 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.59.107])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 08:18:09 +0000 (GMT)
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
 <3a7be99a-5438-cc5b-ec6e-938832e7ab5a@de.ibm.com>
 <91b4c894-b04a-1d28-b57e-6496b166186b@de.ibm.com>
Message-ID: <05d65201-8577-699a-740a-a72ade93f829@de.ibm.com>
Date:   Tue, 6 Jul 2021 10:18:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <91b4c894-b04a-1d28-b57e-6496b166186b@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u5mcdTjhQAidEquBtCDui5FZUSFY4hnl
X-Proofpoint-GUID: ER4X_nu4ELlm1452djkW5WX4tcJEHBby
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 06.07.21 09:45, Christian Borntraeger wrote:
> On 06.07.21 09:40, Christian Borntraeger wrote:
>> Paolo,
>>
>> since you have not yet pulled my queue for 5.14. Shall I add the two selftest patches and send a new
>> pull request?
> 
> Hmm, I cant put it on top of the next queue since I would need to rebase.
> So lets do the original pull request and I will do another one
> on top of kvm/master for the 2 selftest patches.

And I just realized that you did already pull the s390x and sent it to Linus.
Pull request for the selftest patches will follow soon.
