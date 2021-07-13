Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213D43C7373
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbhGMPoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 11:44:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236932AbhGMPo3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 11:44:29 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DFY1Y4030828;
        Tue, 13 Jul 2021 11:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C67rRYggur724KHXds6NoJueS54B51mksilrQ6bj8wY=;
 b=CskMpAoKKnDakdBzHcV3liOfBuVugtzis0NdO53BETT1zUchnnTIFwoKVwTg2hDcriQa
 7EIMPoeKqBMehjbSCAORGsQVFtFFdkXl825uo+pWp25YhUQm6UxQOyU/4rYEwe7+A4oM
 INnDDyLFOLE5N7GcQKcdrbGuoDoofH3yJBG7EN2OYHTDgA1d4sL+Bwv4YG9vfHfPzXu/
 XV2zttiympd7StjZ2kgLI38iyRoK0oukerNdBAVRYZt2zRuQRmXhwVIRXy8Kp3YG0IXp
 1ecqcOLRFLsT4etDGUyFl7qBbV4La+PcZYgYenTo9AgMxtwHWZYWOJLc5r6afeViA7FB LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs66939y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:41:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16DFY83K032040;
        Tue, 13 Jul 2021 11:41:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39qs66939h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 11:41:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DFakl8031929;
        Tue, 13 Jul 2021 15:41:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2th9ccq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 15:41:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DFdSv336831704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 15:39:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CACD14C040;
        Tue, 13 Jul 2021 15:41:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 623564C046;
        Tue, 13 Jul 2021 15:41:33 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.60.208])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Jul 2021 15:41:33 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210713145713.2815167-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <82d32e12-c061-1fe0-0a3e-02c930cbab2e@de.ibm.com>
Date:   Tue, 13 Jul 2021 17:41:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713145713.2815167-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z-N-7DbuHw320TW23npB6T-xYSvNcdPp
X-Proofpoint-GUID: DpiZ84yez1A35d_gV9-V4KW1fkFJUlkN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_07:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.07.21 16:57, Heiko Carstens wrote:
[..]
> +#define HYPERCALL_FMT_0
> +#define HYPERCALL_FMT_1 , "0" (r2)
> +#define HYPERCALL_FMT_2 , "d" (r3) HYPERCALL_FMT_1
> +#define HYPERCALL_FMT_3 , "d" (r4) HYPERCALL_FMT_2
> +#define HYPERCALL_FMT_4 , "d" (r5) HYPERCALL_FMT_3
> +#define HYPERCALL_FMT_5 , "d" (r6) HYPERCALL_FMT_4
> +#define HYPERCALL_FMT_6 , "d" (r7) HYPERCALL_FMT_5

This will result in reverse order.
old:
"d" (__nr), "0" (__p1), "d" (__p2), "d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
new:
"d"(__nr), "d"(r7), "d"(r6), "d"(r5), "d"(r4), "d"(r3), "0"(r2)

As we do not reference the variable in the asm this should not matter,
I just noticed it when comparing the result of the preprocessed files.

Assuming that we do not care this looks good.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
