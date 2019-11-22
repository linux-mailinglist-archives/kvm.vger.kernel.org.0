Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B75107221
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 13:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfKVM2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 07:28:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVM2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 07:28:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMC9Nfu189160;
        Fri, 22 Nov 2019 12:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xML39FfoeKNBp74I8QZARutVKNtg3tLXEW+pE1lUyJY=;
 b=AWxG9ImQ+2yMuKMQYaPKcOusSRGzXSaZ9ctwT5q7ac1K03k0jN18FuDqrML81ntjwWDV
 UQrnDB7ppiO3Ppj4vjVeE3EjgXpCxLib8oSYmn5IofLfKElClOE3O7R+mbfmVfwjdsd+
 XsIExNvSTexTYpYzGZd+HQuU2cHiRmErSuWa07UlvUx4meHGUMhUy/KVmNxam9xB1VMM
 RNGqejtZfmP6kUH+hV/mQQ/N2opDmNX4DfNDKQjezEVkI2hBlEu4le9O6Q5/8ZfrX80o
 TkZ624Lynykydoo0kaXswBZxO4ihPH4od2+sb/HGWStluw0l222496DPfTelM5uA6sdm Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92qa89w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 12:26:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMC8Y5E078279;
        Fri, 22 Nov 2019 12:26:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2we6g70v9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 12:26:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMCQWX8022781;
        Fri, 22 Nov 2019 12:26:32 GMT
Received: from kadam (/41.210.159.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 04:26:31 -0800
Date:   Fri, 22 Nov 2019 15:25:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
Message-ID: <20191122120413.GI617@kadam>
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com>
 <20191119121423.GB5604@kadam>
 <87imnggidr.fsf@vitty.brq.redhat.com>
 <20191119123956.GC5604@kadam>
 <87a78sgfqj.fsf@vitty.brq.redhat.com>
 <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 06:58:51AM -0500, Nitesh Narayan Lal wrote:
> For the build error, I didn't trigger it because I didn't compile with
> appropriate flags.

It's going to be a serveral years before we can enable that flag by
default.

regards,
dan carpenter
