Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A551825C0
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 00:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgCKXWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 19:22:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 19:22:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BNJMi7002706;
        Wed, 11 Mar 2020 23:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XH5izjhAjE3b/k6+22PeagK1e6WFNeDzjPmPOyeLkyo=;
 b=IBLsF9Hcz+r4gSrMjMwlipxxnLfMS4KacNF9wGmUM0OsQRLMhZkzGC9MQSH11xV8rdPx
 7rAyitgMlbH5KvUAt/9jtFUfZ6CUdObiBE8wR/r3BVKlQCPLm8qD1t14Y+S4h/Rv81y9
 4c5DWCZM+y2GlbmK3/DgffRdXy8Ji7F3ppENV972pmY1vs0+ZJCtTOewjhWFGrWJgWiV
 Vj963edqaQIXIFXgQyL8DYkcXCVhfMWzVhd4k1Nk2tRCrQQDB8kyaZueBepDq2OPYHEj
 AfGSMXGnoiV6mKwbgQlEEGy/SzFcFOSB8JlnOUpJrFH1uxgwa+SBwzQV2vb81C2jQxqm Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yp7hmay14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 23:22:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BNKEY0157785;
        Wed, 11 Mar 2020 23:22:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ypv9wf5pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 23:22:38 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02BNMbYC019399;
        Wed, 11 Mar 2020 23:22:37 GMT
Received: from [192.168.14.112] (/109.66.218.218) by default (Oracle Beehive
 Gateway v4.0) with ESMTP ; Wed, 11 Mar 2020 16:22:17 -0700
USER-AGENT: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <e87a88de-f1cd-0bde-48a8-c66b915435de@oracle.com>
Date:   Wed, 11 Mar 2020 23:22:13 +0000 (UTC)
From:   Liran Alon <liran.alon@oracle.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, jmattson@google.com
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
 <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
 <d5f0ba6a-8c7f-60b6-871b-615d11b08a1b@oracle.com>
 <20200311231206.GL21852@linux.intel.com>
In-Reply-To: <20200311231206.GL21852@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/03/2020 1:12, Sean Christopherson wrote:
> On Thu, Mar 12, 2020 at 12:54:05AM +0200, Liran Alon wrote:
>> Of course it was best if Intel would have shared their unit-tests for CPU
>> functionality (Sean? I'm looking at you :P), but I am not aware that they
>> did.
> Only in my dreams :-)  I would love to open source some of Intel's
> validation tools so that they could be adapted to hammer KVM, but it'll
> never happen for a variety of reasons.

I hope then you at least built a setup internally at Intel that runs 
these test suites on top of KVM to find bugs. :)
It would also be nice of Intel to even setup this internally on top of 
other common hypervisors (e.g. Hyper-V, VMware) and report bugs to vendors.

-Liran


