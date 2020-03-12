Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85651183D72
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCLXiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:38:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgCLXiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:38:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNIbjc050226;
        Thu, 12 Mar 2020 23:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4+fjIpyF2vTr8vy41OpFV0LuUn5jW0g5BXbM6Vxcf6w=;
 b=V0+L792qTKt3WVLSrqgMH61ueBn/4vS10Ef3aJ9C+a1lV57jFwhCr7t80PfkiO3eMlBZ
 dCqy5A/SOvbxw10KFXsVaQxjXbXWeJVYLlhR/2qeJ+r/GE7F5gS/Sov2iLbG+D05cvfL
 3bZMJUcRbsR91VLaZWAlaGb+FnAjvtUI6GAGtgrXVSrgBqnWJ6ngOmbzCErpukaoFMn4
 JL0aUo7MXHtBtpJi5uJjvkxBiMSK6HCbZKtM34X4rJKuyNqhhJe+NRwIc9P3jDlAdP1U
 y3IIV6kLCTt8yTPavWISIFTVZ2N/SpKa6lu0t2WPxxQfT27RcVB5jKzWEfyp5grsLbSv mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yqtaes49u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:37:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNJH0Y097419;
        Thu, 12 Mar 2020 23:37:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yqtatx4ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:37:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CNbvWF006814;
        Thu, 12 Mar 2020 23:37:57 GMT
Received: from localhost.localdomain (/10.159.129.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:37:56 -0700
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment registers
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <CALMp9eR9hL9OQPBfekDbRAFHx5j-wgBcijjAV0T22NGoSpxpdA@mail.gmail.com>
 <20200311152459.GD21852@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <59359699-430e-9d83-4926-3fde6d0f4122@oracle.com>
Date:   Thu, 12 Mar 2020 16:37:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200311152459.GD21852@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003120116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/11/20 8:24 AM, Sean Christopherson wrote:
> On Tue, Mar 10, 2020 at 04:51:40PM -0700, Jim Mattson wrote:
>> On Tue, Mar 10, 2020 at 4:29 PM Krish Sadhukhan
>> <krish.sadhukhan@oracle.com> wrote:
>>> Even thought today's x86 hardware uses paging and not segmentation for memory
>>> management, it is still good to have some tests that can verify the sanity of
>>> the segment register fields on vmentry of nested guests.
>>>
>>> The test on SS Selector field is failing because the hardware (I am using
>>> Intel Xeon Platinum 8167M 2.00GHz) doesn't raise any error even if the
>>> prescribed bit pattern is not set and as a result vmentry succeeds.
>> Are you sure this isn't just an L0 bug? For instance, does your L0 set
>> "unrestricted guest" in vmcs02, even when L1 doesn't set it in vmcs12?
>
> I assume this is the check being discussed?  The code is flawed, if CS=3
> and SS=3, "sel = sel_saved | (~cs_rpl_bits & 0x3)" will yield SS=3 and pass.
>
> I think you wanted something like:
>
>    sel = (sel_saved & ~0x3) | (~cs_rpl_bits & 0x3);

Yes, my bit-setting was wrong and I have fixed it. But that's not the 
cause of the failure.

It appears that Jim's suspicion is correct. L0 is not checking in 
prepare_vmcs02_early(), whether vmcs12 has "unrestricted guest" turned 
off. After I put the relevant setting in that function, the test now 
passes (meaning vmentry fails).

I will add this fix in v2.


>
>
>> +	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
>> +	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
>> +		u16 cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
>> +		sel_saved = vmcs_read(GUEST_SEL_SS);
>> +		sel = sel_saved | (~cs_rpl_bits & 0x3);
>> +		TEST_SEGMENT_SEL(GUEST_SEL_SS, "GUEST_SEL_SS", sel, sel_saved);
>> +	}
>> +}
