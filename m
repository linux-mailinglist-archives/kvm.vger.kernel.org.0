Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DA857A1C
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 05:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF0Dhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 23:37:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfF0Dhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 23:37:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R3Y2ko095743;
        Thu, 27 Jun 2019 03:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=nxMs4h/6RcJBUFEIvJBgo9aJwQP29EP3zQ4e3KQb5VQ=;
 b=km8f7oZ3aB83RO1CQMYX9+GN0qW7qia7dHvNVe4nfJyyfLWh9C5Bied10WW3/OO+5til
 TYwF7HZIykSG2G3TwRj+uxcB3ax6AJbPjMzrkY+F1e/PJQUGq1bR1MLat/XtGHlC5TrO
 Oz2hdJg6q59SaLFIwVuAz9ZkBaMTd6BoPKCJr/uBMog7tNBRytXODuuUb/kRcyy4ZeNo
 /KJLVkvQFDM5VGmzUd0YihQdwqFWFvnFNCshcL9NScArhrJtQFOscHUbbpyjTkLxBUuf
 TKOXw5G7YFOiHRQaKjqr18yg+VaOIncP1wPsbJtH7Jo7BmhKFFooD0ygRXPZ0GE3KPrm og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t9cyqnm13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 03:37:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R3bZbq099738;
        Thu, 27 Jun 2019 03:37:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t9acd15hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 03:37:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5R3bZwH019756;
        Thu, 27 Jun 2019 03:37:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 20:37:34 -0700
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: Re: [PATCH 0/2] scsi: add support for request batching
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190530112811.3066-1-pbonzini@redhat.com>
        <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
Date:   Wed, 26 Jun 2019 23:37:32 -0400
In-Reply-To: <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com> (Paolo
        Bonzini's message of "Wed, 26 Jun 2019 15:51:32 +0200")
Message-ID: <yq1lfxnk8ar.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=808
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=874 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270039
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Paolo,

> Ping?  Are there any more objections?

It's a core change so we'll need some more reviews. I suggest you
resubmit.

-- 
Martin K. Petersen	Oracle Linux Engineering
