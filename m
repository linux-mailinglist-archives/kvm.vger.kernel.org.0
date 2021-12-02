Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01201466255
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346409AbhLBLcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:32:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346365AbhLBLcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:32:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2ArUTJ012749;
        Thu, 2 Dec 2021 11:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=noEevvq+X3UDU6g9F9ZWu1mwW5kq4C3VT+JbblUPRSk=;
 b=Hzb0gUZjQsxjGJ/mUUsXKlpW9jhnSK2bB5UnBb7n8kUE13ZbZzkHCUlQZnewKbwrNsge
 wJrmgXFwd2D3EeFeOppq0MqmC/hPG+YI6kAAzFeu6n+bIqSg7D6zD8Fynxgl9A65wLWO
 maMS9JIviY09jg3wNhcpEAsnjSt0Da23CXhUskXU9sZZzCDMSh3N2WUNMx+Ga0ImmChW
 GYK2MP7ayQpTtiPRgMlOaQjyBHt39fKQBWwBGjle9inkb/w1nmPXSd4LFoDbC/WLJh/g
 zzQJFruFortxq3q47AKmV0OMI6yPbNXAB3F7vN3NKWPPHhoMtbMF0MCZqiVR/rgOigM6 tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvss8q2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:29:02 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2ArUE2012747;
        Thu, 2 Dec 2021 11:29:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpvss8q1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:29:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2BJV36012082;
        Thu, 2 Dec 2021 11:28:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaa9anf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:28:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2BSujH25231832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 11:28:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A06111C05C;
        Thu,  2 Dec 2021 11:28:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6F6811C04A;
        Thu,  2 Dec 2021 11:28:55 +0000 (GMT)
Received: from [9.145.49.22] (unknown [9.145.49.22])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 11:28:55 +0000 (GMT)
Message-ID: <0b4dff4c-62d4-a656-69e8-bc3ea356f7ae@linux.ibm.com>
Date:   Thu, 2 Dec 2021 12:28:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: make smp_cpu_setup() return
 0 on success
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202095843.41162-1-david@redhat.com>
 <20211202095843.41162-2-david@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211202095843.41162-2-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o_FF9vBSsiqIbd1VEDd1IZi9IKCpxI2s
X-Proofpoint-ORIG-GUID: 5d2zrJ5SJygLWODR2jG9J8SURlbWdnU5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_06,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/21 10:58, David Hildenbrand wrote:
> Properly return "0" on success so callers can check if the setup was
> successful.
> 
> The return value is yet unused, which is why this wasn't noticed so far.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   lib/s390x/smp.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index da6d32f..b753eab 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -212,6 +212,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>   	/* Wait until the cpu has finished setup and started the provided psw */
>   	while (lc->restart_new_psw.addr != psw.addr)
>   		mb();
> +	rc = 0;
>   out:
>   	spin_unlock(&lock);
>   	return rc;
> 

oops

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
