Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8A04467A7
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 18:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhKERU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 13:20:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229569AbhKERU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 13:20:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5ErEMQ028764;
        Fri, 5 Nov 2021 17:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TYuZMz/GRHunKpGVJtFn/ggrv7zxgIZrPeNPZjKSLT0=;
 b=Qy2VpLlio98Vjcnj/1A66rjTEewneXN3/bf1MvSZiTGRNfdGiEt6ROm0oqGcc7OpYafc
 3h0d27/jM9+asPKM4xEy1ZQKFGNA+/cHcTZJ9clUQFmsx6b7MIzgjdqQnlNKHGyxUDFJ
 qv3uxl1/Lc54updkFlrMs+v5si7e1QHKQdhb5p3DgInl9+DM82oXsf/u9qRPiqUUANU3
 25cyjf91PfYVrcshcG/qBkyAtA0CPGg0HU4RDVz8kwcERbqALW0mR+WsbLrw2fEF3Pd7
 /MZLw6vHQJoNnRaWskjIac88MettqRKphjI4jS9SJREZn6RFiV4gGfAseckR/20XMzTr jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4t5d1yx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 17:17:17 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A5H9dnW004322;
        Fri, 5 Nov 2021 17:17:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4t5d1ywh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 17:17:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A5HDKw5010480;
        Fri, 5 Nov 2021 17:17:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3c4t4devm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 17:17:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A5HHCRQ64422324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 17:17:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 687EB5204F;
        Fri,  5 Nov 2021 17:17:12 +0000 (GMT)
Received: from [9.171.41.66] (unknown [9.171.41.66])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A18C052063;
        Fri,  5 Nov 2021 17:17:11 +0000 (GMT)
Message-ID: <bc06dd82-06e1-b455-b2c1-59125b530dda@linux.vnet.ibm.com>
Date:   Fri, 5 Nov 2021 18:17:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LRvqoi4N8NyUTBMmgNMV7OrETYjz-Urp
X-Proofpoint-ORIG-GUID: QTqJdycscF51xHjxo47GCvqhzR2f2HPV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1011
 spamscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/21 23:45, David Matlack wrote:

[...]
> 
> The last alternative is to perform dirty tracking at a 2M granularity.
> This would reduce the amount of splitting work required by 512x,
> making the current approach of splitting on fault less impactful to
> customer performance. We are in the early stages of investigating 2M
> dirty tracking internally but it will be a while before it is proven
> and ready for production. Furthermore there may be scenarios where
> dirty tracking at 4K would be preferable to reduce the amount of
> memory that needs to be demand-faulted during precopy.

I'm curious how you're going about evaluating this, as I've experimented with
2M dirty tracking in the past, in a continuous checkpointing context however.
I suspect it's very sensitive to the workload. If the coarser granularity
leads to more memory being considered dirty, the length of pre-copy rounds
increases, giving the workload more time to dirty even more memory.
Ideally large pages would be used only for regions that won't be dirty or
regions that would also be pretty much completely dirty when tracking at 4K.
But deciding the granularity adaptively is hard, doing 2M tracking instead
of 4K robs you of the very information you'd need to judge that. 
