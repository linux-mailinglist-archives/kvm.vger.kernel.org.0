Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB0492DE4
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbiARSxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:53:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348235AbiARSxD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:53:03 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHvhYp013584;
        Tue, 18 Jan 2022 18:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kkh6dnkMBQ7BJh+27g/eY/wHyV8ihcmB1ILS05V6itU=;
 b=XfTddiXt1lUNbKrhXItRx7ck0wyC66SiiFKJBrDLlkdj0PT/sPYcvg2hzcp0qtNbR/gW
 8SRqP/m6JQ6fkdX3jRroWWO0FLqbPs1N1s95W5bQXJ/UUJK+bsjRJprUmYat2/17tjzG
 k52gOzf8AIdu1ETPGylhER5hDPYsEQfkmEDjcr+T/dowTyckYKOfG01oGtAB6hBjMMeC
 amsXqf+XgJyNKQOhwSdaLlEuJbur5mxxfMFxTwSJQtpL14ln9/bwdV4rnRvaeuZvVa/1
 TxBI0jDdf8b5Hm5hz5v+iMctINCHub9EFkub0qcVQTdWblFVIND6c9uT1Kd6kfhSVYtB Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp2dmst8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:53:03 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IIh57G020061;
        Tue, 18 Jan 2022 18:53:02 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp2dmst7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:53:02 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IIbZYT007882;
        Tue, 18 Jan 2022 18:53:01 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3dknwbnkb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:53:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IIqwO433096072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:52:58 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896E36E04E;
        Tue, 18 Jan 2022 18:52:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E7C6E056;
        Tue, 18 Jan 2022 18:52:56 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:52:56 +0000 (GMT)
Message-ID: <b0055d0c-a745-4f48-4c4a-373d47651b3f@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:52:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 06/30] s390/airq: allow for airq structure that uses an
 input vector
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-7-mjrosato@linux.ibm.com>
 <20220117132920.213bf0bd@p-imbrenda>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220117132920.213bf0bd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B6YZSbF39PR7ucfx0aT4uBqQwP4bk2QM
X-Proofpoint-GUID: hxLeIN5NGqfP32gW9_t5uvQR7SQZ6xzc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 7:29 AM, Claudio Imbrenda wrote:
> On Fri, 14 Jan 2022 15:31:21 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> When doing device passthrough where interrupts are being forwarded
>> from host to guest, we wish to use a pinned section of guest memory
>> as the vector (the same memory used by the guest as the vector).
> 
> maybe expand the description of the patch to explain what exactly is
> being done in this patch. Namely: you add a parameter to a function
> (and some logic in the function to use the new parameter), but the
> function is not being used yet. And pinning is also done somewhere else.
> 
> maybe you can add something like
> 
> 	This patch adds a new parameter for airq_iv_create to pass the
> 	existing vector pinned in guest memory and to use it when
> 	needed instead of allocating a new one.
> 
> Apart from that, the patch looks good.
> 

Thanks, will re-work to:

When doing device passthrough where interrupts are being forwarded from 
host to guest, we wish to use a pinned section of guest memory as the 
vector (the same memory used by the guest as the vector).
To accomplish this, add a new parameter for airq_iv_create which allows 
passing an existing vector to be used instead of allocating a new one. 
The caller is responsible for ensuring the vector is pinned in memory as 
well as for unpinning the memory when the vector is no longer needed.
A subsequent patch will use this new parameter for zPCI interpretation.
