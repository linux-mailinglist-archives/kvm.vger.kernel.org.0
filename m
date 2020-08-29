Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006C0256402
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 03:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgH2BjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 21:39:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH2BjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 21:39:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T1Tvcn164844;
        Sat, 29 Aug 2020 01:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XUKgikCgkniEVKcRyR1vsvwOAS5x/WPKFOkeK8WrEmE=;
 b=nL0tlPvTI59xyzyvWcY6HEy6RienvnGJC28FApYq/XTr+nvasp0amU2jvuIoiDvzraYs
 C9l/HVKkmeVJkgol/MaxX/O7eaGIn3l3RNeNk8MH2pTiWlarieFZG2kA1B+2WQA5LT3+
 8S+cUiagGWuhXBb2c0UygMW1xTn13IVoIeSo0dUDXkkTzpW7Te94Yc/w6isCLjhaRukb
 SV7s/6j1GeMFUEMV4MAT+bREWUxj4b541QD85MERJRnxzaVX82+CYYrHqLMoqT3rj2vo
 uKM0MwTjE9ZF6j+UeiiBOUQxIrp6iLBK0hqePnMZobOAwuTZUd/C+SntBnyKaawgeREo Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbsepgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 01:39:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T1aOdD131704;
        Sat, 29 Aug 2020 01:39:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 333ruh6pm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 01:39:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07T1d94e019993;
        Sat, 29 Aug 2020 01:39:09 GMT
Received: from localhost.localdomain (/10.159.139.90)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 18:39:09 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Nadav Amit <namit@vmware.com>,
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
 <4bb7c975-70dd-0247-3824-973229f3337b@oracle.com>
 <02cab471-0023-08f9-1722-2d42a3686a50@redhat.com>
 <605458bd-b4a5-69ca-99e1-3494f5a67d09@oracle.com>
Message-ID: <c36d4ccb-95f1-5fbb-9973-6977145a9d1f@oracle.com>
Date:   Fri, 28 Aug 2020 18:39:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <605458bd-b4a5-69ca-99e1-3494f5a67d09@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/18/20 11:25 AM, Krish Sadhukhan wrote:
>
> On 8/17/20 11:38 PM, Paolo Bonzini wrote:
>> On 05/08/20 01:13, Krish Sadhukhan wrote:
>>> I did some experiments on the processor behavior on an Epyc 2 system 
>>> via
>>> KVM:
>>>
>>> Â Â  1. MBZ bits:Â  VMRUN passes even if these bits are set to 1 and
>>> guest is exiting with exit code of Â Â Â  Â Â Â  Â Â SVM_EXIT_VMMCALL.
>>> According to the APM, this settting should constitute an invalid guest
>>> state and hence I should get and exit code of SVM_EXIT_ERR. There's no
>>> KVM check in place for these CR3 bits, so the check is all done in
>>> hardware.
>>>
>>> Â Â  2. non-MBZ reserved bits:Â  Based on Nadav Amit's suggestion, I 
>>> set
>>> the 'not present' bit in an upper level NPT in order to trigger an NPF
>>> and I did get an exit code of SVM_EXIT_NPF when I set any of these 
>>> bits.
>>> I am hoping that the processor has done the consistency check before it
>>> tripped on NPF and not the other way around, so that our test is 
>>> useful :
>>>
>>> Â Â Â  In PAE-legacy and non-PAE-legacy modes, the guest doesn't exit
>>> with SVM_EXIT_VMMCALL when these bits are set to 0. I am not sure if I
>>> am missing any special setting for the PAE-legacy and non-PAE-legacy
>>> modes. In long-mode, however, the processor seems to behave as per APM,
>>> i.e., guest exits with SVM_EXIT_VMMCALL when these bits are set to 0.
>> Are you going to send patches for this?
>
>
> Yes, I am working on it. I need to complete some more investigation.


I have sent out a patch for testing the non-MBZ reserved bits in long mode.

I haven't been able to find a reliable way to test the non-MBZ reserved 
bits in legacy (PAE and non-PAE) modes.  In long mode if I set any MBZ 
bit and an in valid NPT entry, I get VMEXIT_INVALID before VMEXIT_NPF.  
But I am not sure if this same method of testing is working when a 
non-MBZ reserved bit is set. It seems that consistency checking is not 
enforced on these low-order reserved bits. My goal is to get past the 
consistency checking phase and then trigger a VMEXIT_NPF during 
translation of guest pages in NPT.  I created a 3-level page table for 
legacy PAE mode (as per APM) and tried VMRUN with a  non-MBZ reserved 
bit set, I am getting VMEXIT_NPF but the EXITINFO1 field contains the 
nested guest's CR3. So I am not entirely sure if I have gotten past the 
consistency checking phase.

If there's a better way to test these bits, please let me know.

>>
>> Thanks,
>>
>> Paolo
>>
