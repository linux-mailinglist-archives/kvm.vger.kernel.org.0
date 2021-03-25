Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01799349355
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 14:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCYNw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 09:52:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhCYNwL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 09:52:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PDojtU095132;
        Thu, 25 Mar 2021 09:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q57OIOYbQxNgJgBZpPX2Nv5l2VDDXn4fIeSQ4EAZgBk=;
 b=i8uk+BEar5S57tJYJBrkRw6sUegZcyQVhdZpuJJc99+Qog5abXSEadyPTyf2suVqlHJ9
 uqTEmtQLaTBghh/dTePR25+8iwsuj+Vcd0Qea0LwvvTJAXaqCs0ih1GAquW2P7DoM8zT
 c/vv0IMcNTH2fZFvbbKeXvAhgitmK4ZqLzoXRjlveGeW6qO4xh67bvVTd08D9WE1ecvm
 /f+60UYyKdsDAWUt6+JDDjAwkolwUFPr8FrLndvtF6K7AMqJyOcTHp3KzTSvXa5OxhuU
 AS+m6Z/JU6L9h5czxeuh6un9qGWcVet66wfMPhPJxaOPWSF/DMJWh7Tfx94Ko/n0adMB DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gurvr0q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:52:10 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PDqAUL106261;
        Thu, 25 Mar 2021 09:52:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gurvr0pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:52:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PDq8eb001315;
        Thu, 25 Mar 2021 13:52:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68d09g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 13:52:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PDq5dS41746786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 13:52:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3349711C0A5;
        Thu, 25 Mar 2021 13:52:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D6E11C0AA;
        Thu, 25 Mar 2021 13:52:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 13:52:04 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, farman@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com, akrowiak@linux.ibm.com,
        cohuck@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        alex.williamson@redhat.com
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6d6bc700-4481-b7a4-c09b-402e1c702036@linux.ibm.com>
Date:   Thu, 25 Mar 2021 14:52:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_03:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1011 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 2:41 PM, Matthew Rosato wrote:
> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   MAINTAINERS | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9e87692..68a5623 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15634,8 +15634,8 @@ F:	Documentation/s390/pci.rst
>   
>   S390 VFIO AP DRIVER
>   M:	Tony Krowiak <akrowiak@linux.ibm.com>
> -M:	Pierre Morel <pmorel@linux.ibm.com>

Acked-by: Pierre Morel <pmorel@linux.ibm.com>


-- 
Pierre Morel
IBM Lab Boeblingen
