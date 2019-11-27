Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B786B10A787
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 01:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfK0Adp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 19:33:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfK0Adp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 19:33:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0TMFF140221;
        Wed, 27 Nov 2019 00:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=kqipk6RKk3GGvgBii/Ma57n7ZBn4RdHXBYyFNgTlfM0=;
 b=SNQYsosqvFg/p1NgnySaVnDkwtU9SlFZFxy0ukl79YwOGJFfxJFH+yP9vLzu886FL2tX
 mzCb1nkxPM2qJlitxSyWaOgq2wW9/8UICgrPOsN6OZK1lKy1Q2u9zF5bHSxXDzWzmBRr
 IvZwN4fkdrNVxLvc9e7N1i8Qmf906oo+X7QXBxy3xsUZzuCO0WzE/Z2OTR5bo1/crS7z
 lClm3mCrdEHI+OPIZwIYRhRZL8LaZVKv9WfDDU/aK8e8HKm1Q7jVF+Isl4zemSYfCXXt
 otaYKLiiDMj8dy+aGibyU/RmL4qVtVTg8oV6/voFQmCx0fA5H0LHUdBHZKRTDAbT8Nif 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wev6ua38e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:33:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0TJTw115538;
        Wed, 27 Nov 2019 00:33:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wgvhb3pgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:33:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAR0XY7e002872;
        Wed, 27 Nov 2019 00:33:35 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 16:33:34 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm/x86: export kvm_vector_hashing_enabled() is
 unnecessary
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1574814625-29295-1-git-send-email-richard.peng@oppo.com>
Date:   Wed, 27 Nov 2019 02:33:30 +0200
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7E74C77B-ADB3-4B1F-BC7A-4F8BF531E11D@oracle.com>
References: <1574814625-29295-1-git-send-email-richard.peng@oppo.com>
To:     Peng Hao <richard.peng@oppo.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Nov 2019, at 2:30, Peng Hao <richard.peng@oppo.com> wrote:
> 
> kvm_vector_hashing_enabled() is just called in kvm.ko module.
> 
> Signed-off-by: Peng Hao <richard.peng@oppo.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

