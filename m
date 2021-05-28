Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0C639478F
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 21:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE1Txj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 15:53:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhE1Txg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 15:53:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SJiAgf134480;
        Fri, 28 May 2021 19:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=d7lYFVRu2/DsTt9miAcAAYzp4TfW5m6k0vsj37rIFlc=;
 b=XPR8/WA8hKa4vhLJponB1HSE+DK9786wj/pZNTnf5iEkMzhFykToTMDWz3xeEipTwtxd
 HVuuFY9p2uOACZ/lGI1xbzh/OnV+6DR5FZ5CzPZGiMfp7qVi2K/Q+DPbdgBqVHQGUOCu
 /nMEkvdWqYwCHg7cjQ/CIqqofVDYwHJJgD/0perVCnLNLZPnc85x6Z4GJWA+JoEX9Ykv
 JZ25G5daGKpWjlX5Py0a2cL5G8jos+kYbc0aeLQnDGWCPNnH/267viMKptgBFJq22+ko
 H15jVB36Ae6nGU/L1Pxi2hyv/DVzCx2pWi+HmaHFD+YvxDR/SOkbfx1C5z1bAa/xF7UP jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38q3q97gkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 19:51:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14SJjglN127300;
        Fri, 28 May 2021 19:51:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 38pq2xsje9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 19:51:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14SJpvtb011909;
        Fri, 28 May 2021 19:51:57 GMT
Received: from [10.175.200.219] (/10.175.200.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 May 2021 12:51:57 -0700
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210528191134.3740950-1-pbonzini@redhat.com>
Message-ID: <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
Date:   Fri, 28 May 2021 21:51:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210528191134.3740950-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280129
X-Proofpoint-GUID: MPS4dkIngEeJ4_2CxoGLaE1zHn5s3WVv
X-Proofpoint-ORIG-GUID: MPS4dkIngEeJ4_2CxoGLaE1zHn5s3WVv
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9998 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.05.2021 21:11, Paolo Bonzini wrote:
> The memory that is allocated in vm_create is already mapped close to
> GPA 0, because test_execute passes the requested memory to
> prepare_vm.  This causes overlapping memory regions and the
> test crashes.  For simplicity just move MEM_GPA higher.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I am not sure that I understand the issue correctly, is vm_create_default()
already reserving low GPAs (around 0x10000000) on some arches or run
environments?

Thanks,
Maciej
