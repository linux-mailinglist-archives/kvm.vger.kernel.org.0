Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2802C17C717
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 21:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCFUcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 15:32:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50324 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCFUcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 15:32:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026KSIag029940;
        Fri, 6 Mar 2020 20:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hUxoi3XFrl2/CSFQO79E5gQXcXroCsm8xqh+ZSmCFRk=;
 b=uaIPXK6WGBYrA39WlcXInj6aLaS0BRN2cHHlCUVy+jVPAjIyFRYX5DznTcKY1USxQDaS
 wvpziYH7Ny/xfg3UfkuSEjR+sff9P7Gx7+gzqWbASAPhGe42fFCyo2tm3FCIWpoZ261P
 rSsHg1PjlqfodaiWCsOsxzl2jAw4wuzwEiycpXy2f5Myvw42/W3mcd76cx54rPrfhGrp
 7p0kYTaSBpak/IVKhyMsGJ6a9vlJl8uWFTooDwfCXULY7Ny0Ib3WEfUS80dmoEO/Xn6V
 uI5h5LGtWmGrio0HF0HSEGaXme20NyT5Hr0ORYBVaU2WKsHKFqdjjaAE2irgFL/4Z9cI fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwrdd81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 20:32:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 026KRFEJ042450;
        Fri, 6 Mar 2020 20:32:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yg1h6gq4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Mar 2020 20:32:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 026KW6AE006302;
        Fri, 6 Mar 2020 20:32:06 GMT
Received: from localhost.localdomain (/10.159.228.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 12:32:06 -0800
Subject: Re: [PATCH] kvm-unit-test: nSVM: Restructure nSVM test code
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200205205026.16858-1-krish.sadhukhan@oracle.com>
Message-ID: <96986f3e-ade2-c3ee-9971-fdc70de612c4@oracle.com>
Date:   Fri, 6 Mar 2020 12:31:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200205205026.16858-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=13 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=13
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003060122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/5/20 12:50 PM, Krish Sadhukhan wrote:
> This patch restructures the test code for nSVM in order to match its
> counterpart nVMX. This restructuring effort separates the test infrastructure
> from the test code and puts them in different files. This will make it
> easier to add future tests, both SVM and nSVM, as well as maintain them.
>
>
> [PATCH] kvm-unit-test: nSVM: Restructure nSVM test code
>
>   x86/Makefile.x86_64 |    1 +
>   x86/svm.c           | 1718 +++++++--------------------------------------------
>   x86/svm.h           |   52 +-
>   x86/svm_tests.c     | 1279 ++++++++++++++++++++++++++++++++++++++
>   4 files changed, 1551 insertions(+), 1499 deletions(-)
>
> Krish Sadhukhan (1):
>        nSVM: Restructure nSVM test code
>
Ping ...
