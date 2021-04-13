Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054FF35E12A
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhDMOQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:16:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhDMOQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:16:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DEFHKH095853;
        Tue, 13 Apr 2021 14:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NIh49Dj/kn2fUpzyeA1h47utONydvPDU+amfrcRk324=;
 b=oRCCvh47ioUXRgzXsA9xrctMTseAnO5DP0QYsewGhvhn8IpPyu6fduafTSg/9yUjwyCH
 4C0d4SBKtMoVU5R+qTA5iXsDz/D0sshciiqxethhc5YfFZV1f6QlLy5/LZxOHAPUU7BM
 euGiFQjJF1VTlyAMuo6P5zV00WN6xoToQGXs+dSktcDlw+8en0X5PMTvpGFH7cv6Bl0E
 Z7WEMjtY292tgEY2SGGhJuB6vVmneEmEtG7HbDVykfvQstKtrUDIDIQvIqNq+vUEek9x
 lMBt3nm3rLEqh3h9mJCxYGrJCBJa6FG3HB8/uG98t7ptaYVVbik9PmdMO1kGvu67lmKI bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnf6rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 14:15:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DEFUYr009554;
        Tue, 13 Apr 2021 14:15:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 37unsse9e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 14:15:32 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13DEFHEa017895;
        Tue, 13 Apr 2021 14:15:17 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Apr 2021 07:15:17 -0700
Date:   Tue, 13 Apr 2021 17:15:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     zhongbaisong <zhongbaisong@huawei.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] s390/protvirt: fix error return code in
 uv_info_init()
Message-ID: <20210413141509.GF6021@kadam>
References: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130101
X-Proofpoint-ORIG-GUID: 6xX0RmcbNbMtEUbJpzbBOznee1VVVXc2
X-Proofpoint-GUID: 6xX0RmcbNbMtEUbJpzbBOznee1VVVXc2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 08:38:55PM +0800, zhongbaisong wrote:
                                          ^^^^^^^^^^^^

Heiko Carstens already fixed and applied the patch but it's best to fix
this From line so it says "Baisong Zhong" like your Signed-off-by line.

regards,
dan carpenter

