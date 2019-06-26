Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7386A57453
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfFZWcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 18:32:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZWcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 18:32:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QMTQFl086372;
        Wed, 26 Jun 2019 22:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BYTOEYWesOfoeKy8uquXYjKQjDB+u/UbUE7xz1resDU=;
 b=VufNzg1qpMKSnLzJ6jrffUNAjkgNSM9dwfUT/CvnwCVM8vidHSDQ8funuBV36/pUVvbl
 gqR/HJcefn3+cquzYdl1bG7GW3j8F9dx3lSjLNzUQflY6S1I1FNWZ1tWs58bRj3AjGD0
 yUX59KoMSQrp/EYhIrf+L9DksoqFnXxFIapLKrX3Q/jSnuwT5Zu19foB29TCsvZ0I9JS
 Q7oAVHM9IPA8ufSXNsclWw/Zgyuw8v7MtIy9uM7Md3xzCXqj3JOx4iEqGbEZ7JQtWFuv
 8rypChnMC0KbnpJYEPDWjA2L9acYwctHumiYMMBCz2LyXMA+pRi/lURDL3ZW0ZgteGaw Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t9brtcyey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 22:32:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QMUlce034607;
        Wed, 26 Jun 2019 22:32:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t9p6v1613-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 22:32:08 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QMW7Qf030834;
        Wed, 26 Jun 2019 22:32:07 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 15:32:07 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190625120627.8705-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
Date:   Wed, 26 Jun 2019 15:32:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190625120627.8705-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260257
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 5:06 AM, Nadav Amit wrote:
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/apic.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index 537fdfb..b5bf208 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>   	switch (reg) {
>   	case 0x000 ... 0x010:
>   	case 0x040 ... 0x070:
> +	case 0x090:
>   	case 0x0c0:
>   	case 0x0e0:
>   	case 0x290 ... 0x2e0:


  0x02f0 which is also reserved, is missing from the above list.

