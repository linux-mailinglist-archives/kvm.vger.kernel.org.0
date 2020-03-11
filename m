Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1B8182550
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 23:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgCKW4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 18:56:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbgCKW4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 18:56:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BMnRQH153471;
        Wed, 11 Mar 2020 22:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=H92c14jfbdOiWXoVQXozXgEKK/fOqBx4Sd/fH3FD4lE=;
 b=qP7MX0T0CGi2FCamucF0WfpfI9qzI0PE6yBvDWT0v0nuTfi3YW6nwUuBt87SsBZcpmdZ
 gPvmKVrRJeBnukiBYd5fz6ppYZDsUZmfeBAVYqal4exyR/1whfZViyaMqQG1py9dicpd
 dI/rdIKh900tDMQmK1M9HbQ4qOmLoVTsuVxbTplpN3UUJzhGaZQi/AXgwhk9cmhLa1nF
 8tw51k/m/4k5nxnrX8J0H70sY/FGuv4dEd6m9Aljz2Zt6IiN4uqTz02ql1xan9ypbcWu
 rzPtgGP+kYazrdLEd3wwK3iYwX0NodgSoy8aekBywJYMaDOhBtkPa4fOab3pz0vuArHA qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yp7hmaurx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 22:56:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BMoHcd172168;
        Wed, 11 Mar 2020 22:54:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ypv9wdq8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 22:54:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02BMs9Uh017169;
        Wed, 11 Mar 2020 22:54:10 GMT
Received: from [192.168.14.112] (/109.66.218.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 15:54:09 -0700
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
To:     Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, jmattson@google.com
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
 <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <d5f0ba6a-8c7f-60b6-871b-615d11b08a1b@oracle.com>
Date:   Thu, 12 Mar 2020 00:54:05 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/03/2020 23:53, Nadav Amit wrote:
>> On Mar 11, 2020, at 2:46 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>
>> On Wed, Mar 11, 2020 at 01:38:24PM -0700, Krish Sadhukhan wrote:
>>
>> That being said, I don't understand the motivation for these tests.  KVM
>> doesn't have any dedicated logic for checking guest segments, i.e. these
>> tests are validating hardware behavior, not KVM behavior.  The validation
>> resources thrown at hardware dwarf what kvm-unit-tests can do, i.e. the
>> odds of finding a silicon bug are tiny, and the odds of such a bug being
>> exploitable aginst L0 are downright miniscule.
> I see no reason for not including such tests. Liran said he uses
> kvm-unit-test with WHPX, and I also use it in some non-KVM setups.

+1.
I admit I haven't read this thread at all but I wanted to point out 
something I already told Paolo at KVM Forum:
kvm-unit-tests should be renamed to cpu-unit-tests. i.e. It should be 
treated as a suite of unit-tests that verifies CPU behavior.
It doesn't matter if the CPU it runs on top of is Bare-Metal (As Nadav 
runs it) or on top of a vCPU implementation (E.g. KVM, VirtualBox, 
VMware, Hyper-V, whatever).

There are multiple reasons of why it should be treated like that:
* It allows us to verify that the unit-test indeed pass on a real CPU 
and thus enforce on vCPU implementation a behavior that a real CPU 
performs. Instead of what the unit-test author thought the CPU should 
perform.
   I have personally already made a mistake on this area when I wrote 
the unit-test to verify KVM handling of INIT signal while vCPU is in VMX 
root-mode. Nadav run the test on top of a Bare-Metal CPU and showed that
   the unit-test fails and therefore should written otherwise.
* It allows, hopefully, for multiple hypervisor vendors to collaborate 
on the same set of unit-tests. Sharing regression tests and helping each 
other enforce correct vCPU behavior.
    As Nadav have pointed out, I have used this technique already to run 
the unit-tests on top of Hyper-V using WHPX. Which indeed revealed bugs 
in Hyper-V.

Of course it was best if Intel would have shared their unit-tests for 
CPU functionality (Sean? I'm looking at you :P), but I am not aware that 
they did.
So cpu-unit-tests (Previously named kvm-unit-tests) should be our best 
replacement for now.

This is also why I would wish that we will make sure that all unit-tests 
enforcing CPU functionality will be written in cpu-unit-tests and not on 
KVM selftests.
Only tests involving using KVM userspace API should be written in KVM 
selftests suite.

-Liran




