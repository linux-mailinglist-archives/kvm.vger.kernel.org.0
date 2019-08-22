Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC599F20
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbfHVSpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 14:45:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731002AbfHVSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 14:45:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MIhOdc128479;
        Thu, 22 Aug 2019 18:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HUv+lkG2MDR8iOM0avK7EJCSDMC5MFOb22lsBW8DTWc=;
 b=NW2wEBcgzv3d1joEU6hYLtwvpPK7uW+2RN/ktG8XPGK3FODaNH0UBHbt7962W4N73XuL
 XOkD1z8axxJJFbwhrgbjolCB7Z7iYkIUb6n1MNfAEfye542eIFSO0CxTfWq21Z6H8U1m
 L1RXQfMVDjWwZ6eJsIdWUf94qQldisAdWHwN2GQNwL5s68NhVqotK8iFz5eGRiOyZESg
 Zl+8v+oDvfq9BIqyHJwWowJCbo3YYsSmmeTTegI1M/qz3C+wHr47K/a+u6QzOmBKbdg7
 V/smeJKSUJYACLtpzlL/QcRhLAsNcSwmYdSitBPO7gx3ts/d2tNgcZrfeHTrsOZw0Dxh xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7r7t8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 18:45:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MIhCMm085595;
        Thu, 22 Aug 2019 18:45:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ugj7recus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 18:45:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7MIj5bb005953;
        Thu, 22 Aug 2019 18:45:05 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 11:45:05 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 95FD06A0141; Thu, 22 Aug 2019 14:46:56 -0400 (EDT)
Date:   Thu, 22 Aug 2019 14:46:56 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@redhat.com, ehabkost@redhat.com
Subject: Re: [PATCH 1/3] KVM: x86: fix reporting of AMD speculation bug CPUID
 leaf
Message-ID: <20190822184656.GC9964@char.us.oracle.com>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
 <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 10:26:40AM +0200, Paolo Bonzini wrote:
> The AMD_* bits have to be set from the vendor-independent
> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> about the vendor and they should be set on Intel processors as well.
> On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
> VIRT_SSBD does not have to be added manually because it is a
> cpufeature that comes directly from the host's CPUID bit.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!
