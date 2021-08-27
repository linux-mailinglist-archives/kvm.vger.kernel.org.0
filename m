Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB2B3F9A74
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245246AbhH0Nsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:48:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232417AbhH0Nsw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 09:48:52 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RDXu5M063141
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 09:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JMiY4AEb+VlXhUbpIWK4zVHATAP1nKeeqE8811q7pHM=;
 b=C/h+YqvB1GbNXbAFCe2SRm2RL5uO2BuJwVuyjGD6/YkB8rJX9KBE56gdkrisx9MmjIW/
 lufmutVGE1PgRsNqZWXkZ3VucggyiErDZMjn7qfGxPphQLymbZZb2LWvAV/PgsNQ7SkY
 G+d2xhauVNqVsOgchUScEXVH4UPdZfuowPwsPao3PQpOERP/xtsOnUVJAsksTmgPFW6R
 DKB8um8eaodYF8gHJM5t/VUuGuczz/R7QgqE1SLjUnMOHdsRxt1Qjls+PjWJuDo7r/qe
 JMrYeHA8t66ICrUZuD4xCN/GfDTXBw+tB94gIOguY07WvkpDmfI8z/WxDVTjeJLwXRma KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwwxdp69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 09:48:03 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RDZVNF072456
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 09:48:03 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwwxdp50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 09:48:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RDbfiP013103;
        Fri, 27 Aug 2021 13:47:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ajs48hnyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 13:47:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RDi5NZ41877960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 13:44:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E919942056;
        Fri, 27 Aug 2021 13:47:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A34444203F;
        Fri, 27 Aug 2021 13:47:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 13:47:55 +0000 (GMT)
Subject: Re: [PATCH kvm-unit-tests v2] Makefile: Don't trust PWD
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20210827105407.313916-1-drjones@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <85a8c896-a492-e783-4c27-02dbeffaa3c2@linux.ibm.com>
Date:   Fri, 27 Aug 2021 15:47:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827105407.313916-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jp60F1J5lShX8gQeAwhDl5DCdNOpCqEO
X-Proofpoint-ORIG-GUID: uwZ0XL9H-WTXVBqBqW0QbZ80QTaL0ypO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_04:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/27/21 12:54 PM, Andrew Jones wrote:
> PWD comes from the environment and it's possible that it's already
> set to something which isn't the full path of the current working
> directory. Use the make variable $(CURDIR) instead.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28c9319..6792b93c4e16 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>   cscope:
>   	$(RM) ./cscope.*
>   	find -L $(cscope_dirs) -maxdepth 1 \
> -		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
> +		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>   	cscope -bk
>   
>   .PHONY: tags
> 

Perfect for me, works as expected on Z.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


-- 
Pierre Morel
IBM Lab Boeblingen
