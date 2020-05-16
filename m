Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843581D5D60
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 02:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEPAsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 20:48:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgEPAsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 20:48:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0bSnt159034;
        Sat, 16 May 2020 00:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HQwkaHXkXuZp0dlAvHdJkA0L8L3gGGQPv/vPCWSF5IU=;
 b=q7LxNEXW466wJuIvxCWLu2ceRw2FVBPZ2SZCfDTJZ/aYRvyHErrIsWcOoj9XhWcv3jkZ
 f4946/DE0VMLo8u5u1qlHy8Ch/xFrykUIp9/kjnJh2hkJfhilNLc4ng5PIgvInLSTF6y
 LTbfpEOOKZcfBUXVoz87sYttMxZeCih3ax8YraNgBbnbnu+2zwWFZT8RYDwWvFSkJCKz
 9pZ+unBYuLcfAOxO+b+qkuI5yXnCbuCz/WslR+VjHx+apkWq3l1fPu7A79O8dSQiMMFZ
 Yg84OviCnULekRoPdb2rKho8DbfZnbkw366W/cu73T8tlZ42OjYn/KES0LSpmBq0HkID KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100ygefpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 00:48:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0cG06156506;
        Sat, 16 May 2020 00:48:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31259qhdfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 00:48:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04G0mMR0002277;
        Sat, 16 May 2020 00:48:22 GMT
Received: from [10.154.119.223] (/10.154.119.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 17:48:21 -0700
Subject: Re: question: KVM_MR_CREATE and kvm_mmu_slot_apply_flags()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <7796d7df-9c6b-7f34-6cf4-38607fcfd79b@oracle.com>
 <20200515234151.GN17572@linux.intel.com>
From:   Anthony <anthony.yznaga@oracle.com>
Message-ID: <4fd77a0d-e379-6aba-132a-0982020ac45b@oracle.com>
Date:   Fri, 15 May 2020 17:48:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515234151.GN17572@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160003
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/15/20 4:41 PM, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 02:28:54PM -0700, Anthony Yznaga wrote:
>> Hi,
>>
>> I'm investigating optimizing qemu start time for large memory guests,
>> and I'm trying to understand why kvm_mmu_slot_apply_flags() is called by
>> kvm_arch_commit_memory_region() for KVM_MR_CREATE.  The comments in
>> kvm_mmu_slot_apply_flags() imply it should be, but what I've observed is
>> that the new slot will have no mappings resulting in slot_handle_level_range()
>> walking the rmaps and doing nothing.  This can take a noticeable amount of
>> time for very large ranges.  It doesn't look like there would ever be any
>> mappings in a newly created slot.  Am I missing something?
> 
> I don't think so.  I've stared at that call more than once trying to figure
> out why it's there.  AFAICT, the original code was completely unoptimized,
> then the DELETE check got added as the obvious "this is pointless" case.
> Note, KVM_MR_MOVE is in the same boat as CREATE; it's basically DELETE+CREATE.
> 
> There can theoretically be rmaps for the new/moved memslot, but they should
> already be up-to-date since they're consuming the new memslot's properties.
> 
> I've always been too scared to remove it and didn't have a strong argument
> for doing so :-)
> 


Thanks, Sean.  This is my first foray into kvm code so I'm still getting
familiar with the code.  I haven't studied the KVM_MR_MOVE case yet, but it
sounds like kvm_mmu_slot_apply_flags() may only do useful work for the
KVM_MR_FLAGS_ONLY case.

Anthony
