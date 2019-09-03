Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401AAA69AD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfICNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 09:24:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54644 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICNYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 09:24:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DOBRR046799;
        Tue, 3 Sep 2019 13:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=N0dhzPeHhYC4XlS3vhv+mp5Dqn5D1d+WUQpRrpj/MME=;
 b=TqUYv3n9pnI+dMGFXnFD4f97r9Bcul8OUh5hAiqBPOweO9PB0k1fbASweZOQ3M5RRBIz
 jw73cf24EjbqeESiEEIwDVlXpC4aL/dXihP0TPNPGGeascovw6Oc8eS/adxt6iPlIQ1P
 awGibA9NV7mWq9JfkAI7Lo3XgHcmuwCj/YRrRiWj6zzLrwe7aBuxVcl8BicMqd38n+Nc
 srji7tWoFODW5I0KtPX4lv+HPTown1aMR11jNYrZcixFnVZ4vkRDlD1jJLOcKA0747eo
 WMm5tM38UIpv6EN+Br9K224XrSI5/LvYbTbGWDZilm8Y+/QIUhQRpMG7U1GnFShN1+J+ LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2usrvsr1kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83DO2oW164806;
        Tue, 3 Sep 2019 13:24:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uryv6pwd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 13:24:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x83DNWfM032023;
        Tue, 3 Sep 2019 13:23:32 GMT
Received: from [10.175.205.235] (/10.175.205.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 06:23:32 -0700
Subject: Re: [PATCH v1 0/4] cpuidle, haltpoll: governor switching on idle
 register
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190903113913.9257-1-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <37c06dda-dcc2-113e-18ed-353b28e9efd3@oracle.com>
Date:   Tue, 3 Sep 2019 14:23:29 +0100
MIME-Version: 1.0
In-Reply-To: <20190903113913.9257-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=954
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/19 12:39 PM, Joao Martins wrote:
> Hey,
> 
> Presented herewith a series with aims to tie in together the haltpoll
> idle driver and governor, without sacrificing previous governor setups.
> In addition, there are a few fixes with respect to module loading for
> cpuidle-haltpoll. 
> 
> The series is organized as follows:
> 
>  Patch 1: Allows idle driver stating a preferred governor that it
>           wants to use, based on discussion here:
> 
>   https://lore.kernel.org/kvm/457e8ca1-beb3-ca39-b257-e7bc6bb35d4d@oracle.com/
> 
>  Patch 2: Decrease rating of governor, and allows previous defaults
> 	  to be as before haltpoll, while using @governor to switch to haltpoll
> 	  when haltpoll driver is registered;
> 
>  Patch 3 - 4: Module loading fixes. first is the incorrect error
> 	      reporting and second is supportting module unloading.
> 
> Thoughts, comments appreciated.

Forgot to add Fixes tags on patches 3 and 4 (they are bugfixes).

Let me respin, sorry for the noise.

	Joao
