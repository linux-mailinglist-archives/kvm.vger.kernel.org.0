Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A805B9F9D
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 18:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiIOQ2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 12:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIOQ2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 12:28:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87AF9E11F;
        Thu, 15 Sep 2022 09:28:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FFECZI016989;
        Thu, 15 Sep 2022 16:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3EkFjAR8k5C804PaGRzIAGHsfuCHMxISa88a7ags8cg=;
 b=MoY46RERgCFVolL5jeg8Us82VOvmavjHzuqwliU+u7brgOqJCk3wG0XZzcM1kRirlG5O
 0E8MIUo2sm7/quOm78ufMrGhNhmuo2om7uGKPC6KkU1u2F1YK/DTvdPpBrSch3ELbPc1
 3NwD4aIXMIYAzOSx5fFgXu3az2s1qdP7CzOxZhahXT7lr9bF3zHtg5wQcON6z3PS5Fpl
 ze5YRyzruBqi/SXZPoPemPYfIf4LqghjyG7zdi/rwKFptR60AB39+Bh7Sp4N/LKwmHAU
 dExmMdR28r2Co6DcTRqWjYL9Pr8YogARipsWzAZacT5+WRR9LfBd+TfivMS5g24pr39H xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm6grjf81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:28:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FFHr8d003508;
        Thu, 15 Sep 2022 16:28:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm6grjf76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:28:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FGKkC6003295;
        Thu, 15 Sep 2022 16:28:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jjyfrancu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:28:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FGSXXc37421514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 16:28:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B6424C044;
        Thu, 15 Sep 2022 16:28:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A7EB4C040;
        Thu, 15 Sep 2022 16:28:32 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 16:28:32 +0000 (GMT)
Message-ID: <68b0e84f-38fd-fdca-f2f0-ba664b44d1d3@linux.ibm.com>
Date:   Thu, 15 Sep 2022 18:28:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: s390: pci: fix plain integer as NULL pointer
 warnings
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220823191548.77526-1-mjrosato@linux.ibm.com>
 <c558a8c8-4d87-13ee-8d33-ba0285445d62@linux.ibm.com>
 <9645ad8e-1fbe-894a-6a13-f5e91d019199@linux.ibm.com>
In-Reply-To: <9645ad8e-1fbe-894a-6a13-f5e91d019199@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kaDj6_oBD16dfH7kHgdYJ77xaVtoS66E
X-Proofpoint-GUID: -H71A-lvbD2OKA9xPVqDuiiBcwMXCCf9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=829 clxscore=1015 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150095
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.09.22 um 18:16 schrieb Christian Borntraeger:
> Am 23.08.22 um 21:18 schrieb Matthew Rosato:
>> On 8/23/22 3:15 PM, Matthew Rosato wrote:
>>> Fix some sparse warnings that a plain integer 0 is being used instead of
>>> NULL.
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>
>> @Janosch, since you are taking the other PCI fix can you also take this small cleanup through KVM?
> 
> Queued now for the kvm tree. Will have to look if we have other things for 6.0. Otherwise it will go with 6.1.

Hmmm, checkpatch --strict has this:

CHECK: Comparison to NULL could be written "!aift->kzdev"
#52: FILE: arch/s390/kvm/pci.h:49:
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||

CHECK: Comparison to NULL could be written "!aift->kzdev[si]"
#53: FILE: arch/s390/kvm/pci.h:50:
+	    aift->kzdev[si] == NULL)

total: 0 errors, 0 warnings, 2 checks, 28 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.


Can you maybe redo this so that we avoid followup patches?
