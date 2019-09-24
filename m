Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACABCB9E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390501AbfIXPfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 11:35:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388173AbfIXPfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 11:35:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFYIN9177126;
        Tue, 24 Sep 2019 15:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=QEIbhfL1lRjZRLhfXRyEIJQiBEMCHyObEwOy+3gAXd8=;
 b=i1M48Y/Z3Sa7UruED12rIedqnM+NhYCvyrfl/C8he7nUGt7BMpP4JjoKkTqBvciwSGx0
 8zYEu4YyEm8e0god0m7Wn/H0AxF5I/ggAJqN+WJBCvemhxWSIqs9ERskaCjgIuUloRxM
 1cUvIa+c+7gartC90lA89a+MzL1YDsacrVdxNK2wktrEeSIoDC4ahzVt1MK+dxT8FLRv
 EFRMTAuGhjL35O5Y7z05L8sv2tbKm6q42GbiI9UQC/ISD5sP8LeIt8lt0T4EdO8/YB9E
 7+lymE94TguBRoleIgsJUFO/jUJtBUwL6859RYBBi/XjZ2earW0yrWOIeB/F95Wp+x71 Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgqxw7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:34:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFXREt148131;
        Tue, 24 Sep 2019 15:34:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v6yvrx6we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:34:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OFYeEx026820;
        Tue, 24 Sep 2019 15:34:40 GMT
Received: from [192.168.14.112] (/79.177.238.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 08:34:40 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87a7b09y5g.fsf@vitty.brq.redhat.com>
Date:   Tue, 24 Sep 2019 18:34:36 +0300
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8A53DB10-E776-40CC-BB33-0E9A84479194@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <87a7b09y5g.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

> On 19 Sep 2019, at 17:08, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> 
> Liran Alon <liran.alon@oracle.com> writes:
> 
>> Hi,
>> 
>> This patch series aims to add a vmx test to verify the functionality
>> introduced by KVM commit:
>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
>> 
>> The test verifies the following functionality:
>> 1) An INIT signal received when CPU is in VMX operation
>>  is latched until it exits VMX operation.
>> 2) If there is an INIT signal pending when CPU is in
>>  VMX non-root mode, it result in VMExit with (reason == 3).
>> 3) Exit from VMX non-root mode on VMExit do not clear
>>  pending INIT signal in LAPIC.
>> 4) When CPU exits VMX operation, pending INIT signal in
>>  LAPIC is processed.
>> 
>> In order to write such a complex test, the vmx tests framework was
>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>> implemented in patches 1-7. The test itself is implemented at patch 8.
>> This enhancement to the vmx tests framework is a bit hackish, but
>> I believe it's OK because this functionality is rarely required by
>> other VMX tests.
>> 
> 
> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Thanks!
> 
> -- 
> Vitaly

