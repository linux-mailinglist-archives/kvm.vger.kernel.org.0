Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBE11D1B4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 17:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfLLQC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 11:02:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfLLQCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 11:02:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCG0o5u121018;
        Thu, 12 Dec 2019 16:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=f7AVG1lyL0yNfd+//JV/XgNkQxufThH6oQbBgh5a/Ww=;
 b=Sj0Wn+YL4klICcznGm6I71xp21V+X5XUBe6wB6k6sOlBPMO9KyhfBYA08sxyElTN8AGb
 g//51JVWibxwezuxAndAOvGoqx0Amnr4EKxGsiPL5GWEPfcGeC3iBrfCI69dRJr/AIpv
 dvazGiJxCvLSViJ8cQAyF4yPhVkx+nxCQna2x2Glsg/ieS3bMVesGfzq/71PoU5jDTyv
 /SMvldgrHrc7Fnvk1ihMdpgfbOCK/GuKQP4xzp17iWYvirVOm6QAfWt20qMdYjwYIh/i
 al+KeiXzEx37QzYyPpUcRZYgWeX2WfMc7fzlaxDzCYNfPHMIa8LiFWMatkEbPIjjxx8N Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wr4qruvmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 16:02:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCFsKHv101098;
        Thu, 12 Dec 2019 16:00:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wums9kqwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 16:00:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCG0GdA008664;
        Thu, 12 Dec 2019 16:00:16 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 08:00:16 -0800
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id B081A6A0119; Thu, 12 Dec 2019 11:03:45 -0500 (EST)
Date:   Thu, 12 Dec 2019 11:03:45 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 0/7] Introduce support for guest CET feature
Message-ID: <20191212160345.GA13420@char.us.oracle.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101085222.27997-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 04:52:15PM +0800, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) provides protection against
> Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> 
> KVM change is required to support guest CET feature.
> This patch serial implemented CET related CPUID/XSAVES enumeration, MSRs
> and vmentry/vmexit configuration etc.so that guest kernel can setup CET
> runtime infrastructure based on them. Some CET MSRs and related feature
> flags used reference the definitions in kernel patchset.
> 
> CET kernel patches is here:
> https://lkml.org/lkml/2019/8/13/1110
> https://lkml.org/lkml/2019/8/13/1109

Is there a git tree with all of them against v5.5-rc1 (so all three series)?
I tried your github tree: https://github.com/yyu168/linux_cet.git #cet
but sadly that does not apply against 5.5-rc1 :-(

Thanks!
