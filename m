Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F2AC341C
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbfJAMUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:20:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfJAMUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:20:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C8wwt176445;
        Tue, 1 Oct 2019 12:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XqKYBH2rj49VsUv2rjzzQD9a0buLWcIjZyuAld412dg=;
 b=asLkTs8RqJIa5YzwrclG2A/BoEvcUNDek9oT48r54xUIVDOF5FcLu5m8yiiQuEn3QfGw
 1NadgCYCz+X5UJWgpadKCjI0dTXmlXzrGImAeR4RJgiEICXzKO+SK386PXFBKkm/PaL/
 MGyeywX/AzIK/u9e2CJY/Pkdhk2yCDAgTV7HD9JpbzTA5bWC3PoeNrqOmKtXAIMlh0Y9
 e3CKSar1xs866ICs7pWvfTlYaBbqmo3wKNGXPIG3/kv+P4BOQMN6kB/MM6VzhwxmxYvI
 RFVTFbfF7RW3vRdhJ5y0Ybfx+0h/EBRoq9X3npnrGnGs2giRqSPSFS5Ez3LZa1tBdxdL TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxunea4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:19:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C8xJn157645;
        Tue, 1 Oct 2019 12:19:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vbmpyf59p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:19:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91CJsBZ020088;
        Tue, 1 Oct 2019 12:19:54 GMT
Received: from [10.191.21.54] (/10.191.21.54)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:19:54 -0700
Subject: Re: [PATCH v2 0/3] Add a unified parameter "nopvspin"
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org
References: <1569845340-11884-1-git-send-email-zhenzhong.duan@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <099f544b-8ff5-d9ba-1af5-2042075e1e6d@oracle.com>
Date:   Tue, 1 Oct 2019 20:19:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1569845340-11884-1-git-send-email-zhenzhong.duan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/9/30 20:08, Zhenzhong Duan wrote:
> There are cases folks want to disable spinlock optimization for
> debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
> and "hv_nopvspin" to support that, but kvm doesn't.
>
> The first patch adds that feature to KVM guest with "nopvspin".
>
> For compatibility reason original parameters "xen_nopvspin" and
> "hv_nopvspin" are retained and marked obsolete.
>
> v2:
> PATCH1: pick the print code change into seperate PATCH2,
>          updated patch description             [Vitaly Kuznetsov]
> PATCH2: new patch with print code change      [Vitaly Kuznetsov]

Sorry, please ignore this mail thread, just found the indentation in 
PATCH2 is wrong. I'll send a v3 later.

Thanks

Zhenzhong

