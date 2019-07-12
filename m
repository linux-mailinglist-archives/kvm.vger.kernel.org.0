Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3463F672C4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfGLPuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:50:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfGLPuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:50:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CFmwEh190845;
        Fri, 12 Jul 2019 15:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=RYkiqVETLtObP6N2KXLNm4gxMOSHpW0oeM8qzwyLjxw=;
 b=hLmC4WuxHYUFd4cDJOor4xOMIWOFfN9CxJ1TEjlwBbzo1y9zHQ6knf+Hzzm8+Eliy5Ko
 fYJGo7KsvzHUUMehL177wgRZEWwZjHVou3l+NObnGQQJg1R2mAF8My0KWKnn/WBeH9ET
 /8YqEcIudQdMXANEdtZ8qVvWuLmYldV6mBYaCoaOP0IS/4GM+YhuLPzXj5SW4HZ2MjaL
 PyMpqxTwsXmfmEzG0hytYM7wAr/UVvCOhZuzm8OnKb4L6uJZTVfQgg5uU3fccc0rmup8
 jR0gvzPqX7Sn2B6VZk5gS980Y2ApYhHOVXhurUm0xC1tjroe6KnS6kzvrzZY8uDrE2sj ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tjk2u6gna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 15:50:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CFlwDk064066;
        Fri, 12 Jul 2019 15:50:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tpefd5wh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 15:50:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6CFoQEi025344;
        Fri, 12 Jul 2019 15:50:27 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 08:50:26 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id CCDC76A0123; Fri, 12 Jul 2019 11:52:15 -0400 (EDT)
Date:   Fri, 12 Jul 2019 11:52:15 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] Add AMD SEV guest live migration support
Message-ID: <20190712155215.GA12840@char.us.oracle.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710201244.25195-1-brijesh.singh@amd.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:12:59PM +0000, Singh, Brijesh wrote:
> The series add support for AMD SEV guest live migration commands. To protect the
> confidentiality of an SEV protected guest memory while in transit we need to
> use the SEV commands defined in SEV API spec [1].
> 
> SEV guest VMs have the concept of private and shared memory. Private memory
> is encrypted with the guest-specific key, while shared memory may be encrypted
> with hypervisor key. The commands provided by the SEV FW are meant to be used
> for the private memory only. The patch series introduces a new hypercall.
> The guest OS can use this hypercall to notify the page encryption status.
> If the page is encrypted with guest specific-key then we use SEV command during
> the migration. If page is not encrypted then fallback to default.
> 

I am bit lost. Why can't the hypervisor keep track of hypervisor key pages
and treat all other pages as owned by the guest and hence using the guest-specific
key?

