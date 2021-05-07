Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA04375F98
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 07:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhEGFDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 01:03:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhEGFDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 01:03:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14751qTh056194;
        Fri, 7 May 2021 05:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/HKU6Ng+BrRVqtSTYd0Pmq7ALei3Vd56o5oCrPq6vSY=;
 b=gwajVnp/tl7ltxJ8wX3WLiWH7/GXBI+eO5OidA02CfCRFHCfet/nMRU8UnjW3umRHAuN
 LWlu0p4kXmMau28wlidr1DymwyGD+KwViTmCmsHO2iV0L+JwzKeo8goCowrgF+jUP5Lk
 Qh4NQGcx9zrH28bh0bLcGN7hr+7eLCWhDcBOvR0PlA+B6vG9Csp2DJxxc7NPhO4or9XZ
 f7YS+bFpc75DFg63X/1LqSK7GNRSfLJkz0J2Mc88SLjxwBixPAOuouISKgtqX8VRsL8C
 gjkTAAGNrkKAO7TjxkRY/UAE1+68g+XWgH24fcXaa2cTpjR95GcaWZyADYw5nLWWj6Lp 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38ctd88b50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 May 2021 05:02:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1474xWJP088558;
        Fri, 7 May 2021 05:02:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38csre1c08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 May 2021 05:02:05 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 147524nk108125;
        Fri, 7 May 2021 05:02:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38csre1by1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 May 2021 05:02:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1475209M029971;
        Fri, 7 May 2021 05:02:00 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 May 2021 22:01:59 -0700
Date:   Fri, 7 May 2021 08:01:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <20210507050153.GC1922@kadam>
References: <YIpeKpSB7Wqkqn9f@mwanda>
 <YJQw8jlJcPO9ImNO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQw8jlJcPO9ImNO@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: Lgjie_AlCOtezkuq_T6ZF3fjgBlHGgvh
X-Proofpoint-ORIG-GUID: Lgjie_AlCOtezkuq_T6ZF3fjgBlHGgvh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9976 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105070035
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 06:09:54PM +0000, Sean Christopherson wrote:
> On Thu, Apr 29, 2021, Dan Carpenter wrote:
> > Hello Brijesh Singh,
> > 
> > The patch d3d1af85e2c7: "KVM: SVM: Add KVM_SEND_UPDATE_DATA command"
> > from Apr 15, 2021, leads to the following static checker warning:
> > 
> > arch/x86/kvm/svm/sev.c:1268 sev_send_update_data() warn: 'guest_page' is an error pointer or valid
> > arch/x86/kvm/svm/sev.c:1316 sev_send_update_data() warn: maybe return -EFAULT instead of the bytes remaining?
> > arch/x86/kvm/svm/sev.c:1462 sev_receive_update_data() warn: 'guest_page' is an error pointer or valid
> 
> Thanks for the report.  Is the static checker you're using publicly available?
> Catching these bugs via a checker is super cool!

This is a Smatch check, but I'm glad you asked about this because it
turns out I never committed the "is an error pointer or valid" check.
I'll do that now and push it later today.

regards,
dan carpenter
