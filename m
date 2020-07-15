Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956512217D8
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 00:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGOWjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 18:39:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34928 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgGOWjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 18:39:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMX1sp158825;
        Wed, 15 Jul 2020 22:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LvEdkGzu3ilxX+/hPCcYNqMnNakrm3VhBGR6/znGxdE=;
 b=ZNbZA8FzeGyekCMyr5AFqQxeYLtyDkIhsr9bcLrDkccukgqjK+M3DJtJBbXTGl41hnLs
 XLeW4wPw8m4btNgDKMh8xov7x6zUdfVpCE1jfYbeQNhyzbZMhQV6aLoj/GUkBr/ko/XZ
 PfgbOY1h1VbHpKqna2vuS5Z9NdwL3ctb9E+2f7t2LMAVmlmlMO1zXFzeinD7awyVTDD0
 DRZqR5PHdEVOS9Nq82gcJVArNLTVOYtlLG0QjHVJYPdfIEta9VOA0LE0Fd2zw7ZZtiky
 Ak7CVX6+cRWb7+WKwsvckt8c7Ky277tUYt08oG+3WWKUDMUuRgm+PHmcFag96sn4VUsQ cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cme3r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:39:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMXf1i022763;
        Wed, 15 Jul 2020 22:39:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0s4xfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:39:36 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FMdY1a013211;
        Wed, 15 Jul 2020 22:39:35 GMT
Received: from localhost.localdomain (/10.159.239.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:39:34 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
 <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
Date:   Wed, 15 Jul 2020 15:39:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/15/20 3:27 PM, Nadav Amit wrote:
>> On Jul 15, 2020, at 3:21 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 7/13/20 4:30 PM, Nadav Amit wrote:
>>>> On Jul 13, 2020, at 4:17 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>>>
>>>>
> [snip]
>
>>>> I am just saying that the APM language "should be cleared to 0" is misleading if the processor doesn't enforce it.
>>> Just to ensure I am clear - I am not blaming you in any way. I also found
>>> the phrasing confusing.
>>>
>>> Having said that, if you (or anyone else) reintroduces “positive” tests, in
>>> which the VM CR3 is modified to ensure VM-entry succeeds when the reserved
>>> non-MBZ bits are set, please ensure the tests fails gracefully. The
>>> non-long-mode CR3 tests crashed since the VM page-tables were incompatible
>>> with the paging mode.
>>>
>>> In other words, instead of setting a VMMCALL instruction in the VM to trap
>>> immediately after entry, consider clearing the present-bits in the high
>>> levels of the NPT; or injecting some exception that would trigger exit
>>> during vectoring or something like that.
>>>
>>> P.S.: If it wasn’t clear, I am not going to fix KVM itself for some obvious
>>> reasons.
>> I think since the APM is not clear, re-adding any test that tests those bits, is like adding a test with "undefined behavior" to me.
>>
>>
>> Paolo, Should I send a KVM patch to remove checks for those non-MBZ reserved bits ?
> Which non-MBZ reserved bits (other than those that I addressed) do you refer
> to?
>
I am referring to,

     "[PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are 
not set on vmrun of nested guests"

in which I added the following:


+#define MSR_CR3_LEGACY_RESERVED_MASK        0xfe7U
+#define MSR_CR3_LEGACY_PAE_RESERVED_MASK    0x7U
+#define MSR_CR3_LONG_RESERVED_MASK        0xfff0000000000fe7U

