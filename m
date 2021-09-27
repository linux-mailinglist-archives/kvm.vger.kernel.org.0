Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433A0419163
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhI0JRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 05:17:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57406 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233581AbhI0JRd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 05:17:33 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R90PNx016012
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 05:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eEZi+8QpDN1bnE93Uj3YqnkvLLaR84KbeTV8J4g86mc=;
 b=TNOqGFFq0P2krBcNNXb/o0ciwM6zy5BgGqTSzU33eJrLSriwXzeqUnAy0clC1Pvt4WqJ
 zGDVuM12vNHpe0aN0aHDLad1hYhcz2CuIuZ4YORFRdutBzs/OwGlO1E6TLu+69/ZLCLG
 80rSuZlvRV7t76UNAsEFtXuYt1uhn/RWHr/2bTBZYGel+3btrgFqxSLjD/7WhkQ6I9ZS
 /ZdS28DDPQqQOZHDNwlSuEEa0C5xwwanGwKh8HIzxAlQDec2vcTB7N1IdUACx0+/7nNq
 pmb8j+lteAdyeSwbQoCG1ccJqdrj1sv0ifZo2D8RDs+rHNvM3uqUH2f8ungU5pD3Nxu6 Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bah7yf43p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 05:15:55 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R80WrA020945
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 05:15:55 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bah7yf43a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 05:15:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R9DJug013423;
        Mon, 27 Sep 2021 09:15:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b9ud9a644-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 09:15:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18R9AnRq45351418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 09:10:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39405AE053;
        Mon, 27 Sep 2021 09:15:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E03D8AE056;
        Mon, 27 Sep 2021 09:15:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.159.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 09:15:49 +0000 (GMT)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
To:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923114814.229844-1-pbonzini@redhat.com>
 <ea922e07-bacd-350b-4a8e-898444f25ee8@linux.ibm.com>
 <9a4fb722-201c-7398-9fab-2680b62220f9@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <18aa544c-96ac-9fc7-019c-912bb7bd1a07@linux.ibm.com>
Date:   Mon, 27 Sep 2021 11:15:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9a4fb722-201c-7398-9fab-2680b62220f9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4_tMb8akTFKwNIcrYSMZz_H0_ZeaDKTg
X-Proofpoint-ORIG-GUID: wrtAJnI-iqd72OKyRy5F_84nfpj-rfYv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/21 10:02 AM, Thomas Huth wrote:
> On 27/09/2021 10.00, Janosch Frank wrote:
>> On 9/23/21 1:48 PM, Paolo Bonzini wrote:
>>> Mark PPC as maintained since it is a bit more stagnant than the rest.
>>>
>>> Everything else is supported---strange but true.
>>>
>>> Cc: Laurent Vivier <lvivier@redhat.com>
>>> Cc: Thomas Huth <thuth@redhat.com>
>>> Cc: Janosch Frank <frankja@linux.ibm.com>
>>> Cc: Andrew Jones <drjones@redhat.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>
>> Is there a reason why we suddenly want to add this i.e. is that
>> indication used by anyone right now?
> 
> I think it's for the get_maintainers.pl script that has just been pushed to 
> the repository some days ago.
> 
>   Thomas
> 

Ah, haven't seen that patch yet, time to read more mails...
Thanks for the clarification!
