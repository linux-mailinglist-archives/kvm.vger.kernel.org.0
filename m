Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE414B4E99
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfIQM6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 08:58:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfIQM6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 08:58:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HCrhbx194702;
        Tue, 17 Sep 2019 12:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=X3h8WdecAL4SUItO2C5rQjl2a1G1qeQ7InT8kFdPrJw=;
 b=ZtL8AAUe9SJrL2u4PhUmr2MBSwb0D5Q1aJnKS5xEHkzr1rr6mACXeyecia06B1pcqIRO
 DKgC6zzNYk4eCJYdKnxEUolrQS+bwJOTPpsb1CrUqNtwE4uAluvYoBgekU90S9UI3+WA
 iuiMmKaAXa2qDEAZP3T2OYr/6vIMwJMYReUkQk1E90QAQhBU3HrXMFHTbgggUFiLxPvk
 TN/3P40xMS6VMfFxKaIKvsmE2VhPQcvFIbY8+XkRhLbAoTYsKKWHi/kDSjEdznRZIaJ/
 sXE8itgTbWZLeYMWXu9TrnWhS5qFpTiJrUL4R2iRlBeczcNC3HEstfrqqd1h/ymCy0Bq Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v0ruqp4tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 12:57:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HCsBhL042493;
        Tue, 17 Sep 2019 12:57:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v2tmsphp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 12:57:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8HCvLwj025859;
        Tue, 17 Sep 2019 12:57:22 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 05:57:21 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id D019E6A00EE; Tue, 17 Sep 2019 08:59:04 -0400 (EDT)
Date:   Tue, 17 Sep 2019 08:59:04 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
Message-ID: <20190917125904.GB22162@char.us.oracle.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 04:52:55PM +0800, Yang Weijiang wrote:
> EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> Virtual Machine Monitor(VMM) to specify write-permission for guest
> physical memory at a sub-page(128 byte) granularity. When this
> capability is enabled, the CPU enforces write-access check for sub-pages
> within a 4KB page.
> 
> The feature is targeted to provide fine-grained memory protection for
> usages such as device virtualization, memory check-point and VM
> introspection etc.
> 
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> called Sub-Page Permission Table Pointer (SPPTP) which contains a
> 4K-aligned physical address.
> 
> To enable SPP for certain physical page, the gfn should be first mapped
> to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry. 
> While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> physical address to find out the sub-page permissions at the leaf entry.
> If the corresponding bit is set, write to sub-page is permitted,
> otherwise, SPP induced EPT violation is generated.
> 
> This patch serial passed SPP function test and selftest on Ice-Lake platform.
> 
> Please refer to the SPP introduction document in this patch set and
> Intel SDM for details:
> 
> Intel SDM:
> https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> 
> SPP selftest patch:
> https://lkml.org/lkml/2019/6/18/1197
> 
> Previous patch:
> https://lkml.org/lkml/2019/8/14/97

I saw the patches as part of the introspection patch-set.
Are you all working together on this?

Would it be possible for some of the bitdefender folks who depend on this
to provide Tested-by adn could they also take the time to review this patch-set?

Thanks.
