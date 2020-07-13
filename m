Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8967E21E356
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 01:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGMXB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 19:01:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGMXB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 19:01:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DMwL4U007922;
        Mon, 13 Jul 2020 23:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AjrKe/x7JY8vDRZOAdc0q9oS+j8D6pXToYAtRGxF1Fo=;
 b=i4O7iAgc+gzJDB+eftjrJnMlp2QPGHCAFIWfffe4skcZ5zoFNe4uQl6p4n5KXy+j31mA
 +J+4fVpa1wsudyJ53fpXaX+1xnl0+W6ZPc5tyCxUMvNOK838NlYWbDm1Ut5gkExuRe19
 XXJQvjYkZpKY4jxFoFb24ZeEyeRlBSwgHLjgBLqgB7xOOLGaAgXic3jvvdG+gxw8q8Nn
 8MFXy5elvbMX1k3BFvapB4hLpeFARqGWi5cqlwD1QGmIzsYCHEe6f4pPT8GB5T59i7Vm
 /9MeVCUIpSV/+2KA94uIoX8tZyTkUBTUjZZYaUcbQLNTrplin9Z7wVeOspH0rZi6IHTP ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur22ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 23:01:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DMvYQY050403;
        Mon, 13 Jul 2020 23:01:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 327q6r0nsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 23:01:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DN1PEe025730;
        Mon, 13 Jul 2020 23:01:25 GMT
Received: from localhost.localdomain (/10.159.236.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 16:01:24 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: reverse FW_CFG_MAX_ENTRY and
 FW_CFG_MAX_RAM
To:     Nadav Amit <namit@vmware.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200711161432.32862-1-namit@vmware.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <27973b01-9aa9-2108-5222-758dfbee299f@oracle.com>
Date:   Mon, 13 Jul 2020 16:01:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200711161432.32862-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/11/20 9:14 AM, Nadav Amit wrote:
> FW_CFG_MAX_ENTRY should obviously be the last entry.
>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>   lib/x86/fwcfg.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index 64d4c6e..8095d8a 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -20,8 +20,8 @@
>   #define FW_CFG_NUMA             0x0d
>   #define FW_CFG_BOOT_MENU        0x0e
>   #define FW_CFG_MAX_CPUS         0x0f
> -#define FW_CFG_MAX_ENTRY        0x10
> -#define FW_CFG_MAX_RAM		0x11
> +#define FW_CFG_MAX_RAM		0x10
> +#define FW_CFG_MAX_ENTRY        0x11
>   
>   #define FW_CFG_WRITE_CHANNEL    0x4000
>   #define FW_CFG_ARCH_LOCAL       0x8000
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
