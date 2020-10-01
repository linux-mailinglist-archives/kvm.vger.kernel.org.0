Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CC27F6C5
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 02:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgJAAbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 20:31:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730873AbgJAAbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 20:31:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0910Ta0m114028;
        Thu, 1 Oct 2020 00:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9RBvlZpwHdlyBRpW9tt6rYVWjb+8DimHvsk2Vhon7Ro=;
 b=Ax+v//2Dg1DoIB5YRhsmWTPSWkJwkv6cNlq5tblJgaXDDj/T++zFhIjGe1a8AM3aWSe/
 PVDzDVVcg1Uqz3/OIw1HNKHVwU4lflXYdwcVsrvymqzx9Kdbf5BynMGgsytuKcWEgCQU
 RLQFdFnlT4AROrKRjmy5Awfc3HR/5XhRYI8Ur1C8erKI21PYX+om/mhTvDK5GuTXQeUF
 pAKhE84o2Kqi/NEreTaoUdQBk1rMuWzlf9A227FRp9dkaZNN1hCf9iANMVb/7M506q54
 Q9JMlvC4Nd+5/x28DJzYXpwaYYNlH4uRGovzeAIIsJ8t9or3MGhYu0/THCwOpUQF4li8 OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkm3bp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 00:31:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0910Pmg9023916;
        Thu, 1 Oct 2020 00:29:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33tfk0kwr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 00:29:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0910TPt3012917;
        Thu, 1 Oct 2020 00:29:25 GMT
Received: from localhost.localdomain (/10.159.237.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 17:29:24 -0700
Subject: Re: [PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in
 long mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
 <20200928072043.9359-4-krish.sadhukhan@oracle.com>
 <20200929031154.GC31514@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <5f236941-5086-167a-6518-6191d8ef04cf@oracle.com>
Date:   Wed, 30 Sep 2020 17:29:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929031154.GC31514@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010002
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/20 8:11 PM, Sean Christopherson wrote:
> On Mon, Sep 28, 2020 at 07:20:42AM +0000, Krish Sadhukhan wrote:
>> According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
>> need to be set by software as follows:
>>
>> 	"Reserved Bits. Reserved fields should be cleared to 0 by software
>> 	when writing CR3."
> Nothing in the shortlog or changelog actually states what this patch does.
> "Test non-MBZ reserved bits in CR3 in long mode" is rather ambiguous, and
> IIUC, the changelog is straight up misleading.
>
> Based on the discussion from v1, I _think_ this test verifies that KVM does
> _not_ fail nested VMRUN if non-MBZ bits are set, correct?

Not KVM, hardware rather.  Hardware doesn't consider it as an invalid 
guest state if non-MBZ reserved bits are set.
>
> If so, then something like:
>
>    KVM: nSVM: Verify non-MBZ CR3 reserved bits can be set in long mode
>
> with further explanation in the changelog would be very helpful.

Even though the non-MBZ reserved bits are ignored by the consistency 
checks in hardware, eventually page-table walks fail. So, I am wondering 
whether it is appropriate to say,

             "Verify non-MBZ CR3 reserved bits can be set in long mode"

because the test is inducing an artificial failure even before any guest 
instruction is executed. We are not entering the guest with these bits set.

I prefer to keep the commit header as is and rather expand the commit 
message to explain what I have described here. How about that ?

