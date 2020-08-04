Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787ED23C215
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHDXNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 19:13:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60656 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgHDXNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 19:13:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 074NDXje191497;
        Tue, 4 Aug 2020 23:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=y53NKxn8aOrH3bHEOTlBOYnFp+EJNoJg67+P0D74cvQ=;
 b=AwUeYYLVuUruoH7R6PkIgp2sPOj6E4D6KXJD2g5Bz5mAMEvQxZOMSYdipAzbcpSYyXUx
 R154nsTxqR84BAu0EjCxNMxL4nIMQW/TdPx+Fkg77ZnWIJx0bsWUoFFyz6MsHbn/fdDm
 PZoBYJervR4devppViTjMjgcZzxV3FvmlojKzYI8VHM0cbhlyjtIKrSeIUSrRhX8Z0Lp
 ahI06xlEhAhiWHX7/V/xD6c02y6EO1OekHGyOu7XDFlmLI6nrEDJx0Pn/7hR2aT+uiQC
 IXHXSFKZESDdUBOA41ZyGiXzKlu/lwxdCzrMu9FoFdAWP1OqxtkHVdKEdWcesj5lL727 Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32pdnqactp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 04 Aug 2020 23:13:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 074NCqQU176708;
        Tue, 4 Aug 2020 23:13:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32pdnrjq22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Aug 2020 23:13:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 074NDVYR000904;
        Tue, 4 Aug 2020 23:13:32 GMT
Received: from localhost.localdomain (/10.159.250.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 16:13:31 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Jim Mattson <jmattson@google.com>
Cc:     Nadav Amit <namit@vmware.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
 <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
 <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
 <CALMp9eSoRSKBvNwjm5fpPG2XDJnnC1b-tm68P-K_Jnyab4aPMg@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4bb7c975-70dd-0247-3824-973229f3337b@oracle.com>
Date:   Tue, 4 Aug 2020 16:13:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSoRSKBvNwjm5fpPG2XDJnnC1b-tm68P-K_Jnyab4aPMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/15/20 4:12 PM, Jim Mattson wrote:
> On Wed, Jul 15, 2020 at 3:40 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 7/15/20 3:27 PM, Nadav Amit wrote:
>>>> On Jul 15, 2020, at 3:21 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>>>
>>>>
>>>> On 7/13/20 4:30 PM, Nadav Amit wrote:
>>>>>> On Jul 13, 2020, at 4:17 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>>>>>
>>>>>>
>>> [snip]
>>>
>>>>>> I am just saying that the APM language "should be cleared to 0" is misleading if the processor doesn't enforce it.
>>>>> Just to ensure I am clear - I am not blaming you in any way. I also found
>>>>> the phrasing confusing.
>>>>>
>>>>> Having said that, if you (or anyone else) reintroduces “positive” tests, in
>>>>> which the VM CR3 is modified to ensure VM-entry succeeds when the reserved
>>>>> non-MBZ bits are set, please ensure the tests fails gracefully. The
>>>>> non-long-mode CR3 tests crashed since the VM page-tables were incompatible
>>>>> with the paging mode.
>>>>>
>>>>> In other words, instead of setting a VMMCALL instruction in the VM to trap
>>>>> immediately after entry, consider clearing the present-bits in the high
>>>>> levels of the NPT; or injecting some exception that would trigger exit
>>>>> during vectoring or something like that.
>>>>>
>>>>> P.S.: If it wasn’t clear, I am not going to fix KVM itself for some obvious
>>>>> reasons.
>>>> I think since the APM is not clear, re-adding any test that tests those bits, is like adding a test with "undefined behavior" to me.
>>>>
>>>>
>>>> Paolo, Should I send a KVM patch to remove checks for those non-MBZ reserved bits ?
>>> Which non-MBZ reserved bits (other than those that I addressed) do you refer
>>> to?
>>>
>> I am referring to,
>>
>>       "[PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
>> not set on vmrun of nested guests"
>>
>> in which I added the following:
>>
>>
>> +#define MSR_CR3_LEGACY_RESERVED_MASK        0xfe7U
>> +#define MSR_CR3_LEGACY_PAE_RESERVED_MASK    0x7U
>> +#define MSR_CR3_LONG_RESERVED_MASK        0xfff0000000000fe7U
> In my experience, the APM generally distinguishes between "reserved"
> and "reserved, MBZ." The low bits you have indicated for CR3 are
> marked only as "reserved" in Figures 3-4, 3-5, and 3-6 of the APM,
> volume 2. Only bits 63:52 are marked as "reserved, MBZ." (In fact,
> Figure 3-6 of the May 2020 version of the APM, revision 3.35, also
> calls out bits 11:0 as the PCID when CR4.PCIDE is set.)
>
> Of course, you could always test the behavior. :-)

I did some experiments on the processor behavior on an Epyc 2 system via 
KVM:

    1. MBZ bits:  VMRUN passes even if these bits are set to 1 and guest 
is exiting with exit code of            SVM_EXIT_VMMCALL. According to 
the APM, this settting should constitute an invalid guest state and 
hence I should get and exit code of SVM_EXIT_ERR. There's no KVM check 
in place for these CR3 bits, so the check is all done in hardware.

    2. non-MBZ reserved bits:  Based on Nadav Amit's suggestion, I set 
the 'not present' bit in an upper level NPT in order to trigger an NPF 
and I did get an exit code of SVM_EXIT_NPF when I set any of these bits. 
I am hoping that the processor has done the consistency check before it 
tripped on NPF and not the other way around, so that our test is useful :

     In PAE-legacy and non-PAE-legacy modes, the guest doesn't exit with 
SVM_EXIT_VMMCALL when these bits are set to 0. I am not sure if I am 
missing any special setting for the PAE-legacy and non-PAE-legacy modes. 
In long-mode, however, the processor seems to behave as per APM, i.e., 
guest exits with SVM_EXIT_VMMCALL when these bits are set to 0.

