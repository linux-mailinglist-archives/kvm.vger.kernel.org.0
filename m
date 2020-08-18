Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298EC248DEE
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 20:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRSZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 14:25:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgHRSZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 14:25:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIGuC9081131;
        Tue, 18 Aug 2020 18:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AC7xeNy8QSk3IKTpZxGdhu4R7meRkplPsYfpRMyJUUo=;
 b=RAFJOJYJf7THJirklm/Z2f1xq972LdXdtl9Z3iwDWAUbx+qOEsRjkza3IlghmeaOu4G3
 8frPf6LPPeCKPsZAE7m0RoyyyZt5LUsQrXgeRvM8OO7j7J9IWRD1NEjEqNUO2luypcGV
 7vHLPM9wd+2wr1JkYdeZ5yP60GqGo2+072EHQhOItcDhiAWsvYSz6HobeHQPQNQOytcR
 2RpYBMyjsdPzkYTr4PQy8Eb9qM+FnZIysr8gi2WOHOseYA9/gaEKRomnIBW5AwnH5L72
 CnAvc2qULUwWO5Y5v3w/8P0RsE0lSfKzXZv9Sd5dNXGZ5M4Rw0xt9VZSA2XzyWF6Vb54 ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn6ejv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 18:25:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIHkWp162068;
        Tue, 18 Aug 2020 18:25:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm3g3e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 18:25:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IIPkMP001456;
        Tue, 18 Aug 2020 18:25:46 GMT
Received: from localhost.localdomain (/10.159.130.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 11:25:46 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
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
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <605458bd-b4a5-69ca-99e1-3494f5a67d09@oracle.com>
Date:   Tue, 18 Aug 2020 11:25:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <02cab471-0023-08f9-1722-2d42a3686a50@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/17/20 11:38 PM, Paolo Bonzini wrote:
> On 05/08/20 01:13, Krish Sadhukhan wrote:
>> I did some experiments on the processor behavior on an Epyc 2 system via
>> KVM:
>>
>> Â Â  1. MBZ bits:Â  VMRUN passes even if these bits are set to 1 and
>> guest is exiting with exit code of Â Â Â  Â Â Â  Â Â  SVM_EXIT_VMMCALL.
>> According to the APM, this settting should constitute an invalid guest
>> state and hence I should get and exit code of SVM_EXIT_ERR. There's no
>> KVM check in place for these CR3 bits, so the check is all done in
>> hardware.
>>
>> Â Â  2. non-MBZ reserved bits:Â  Based on Nadav Amit's suggestion, I set
>> the 'not present' bit in an upper level NPT in order to trigger an NPF
>> and I did get an exit code of SVM_EXIT_NPF when I set any of these bits.
>> I am hoping that the processor has done the consistency check before it
>> tripped on NPF and not the other way around, so that our test is useful :
>>
>> Â Â Â  In PAE-legacy and non-PAE-legacy modes, the guest doesn't exit
>> with SVM_EXIT_VMMCALL when these bits are set to 0. I am not sure if I
>> am missing any special setting for the PAE-legacy and non-PAE-legacy
>> modes. In long-mode, however, the processor seems to behave as per APM,
>> i.e., guest exits with SVM_EXIT_VMMCALL when these bits are set to 0.
> Are you going to send patches for this?


Yes, I am working on it. I need to complete some more investigation.

>
> Thanks,
>
> Paolo
>
