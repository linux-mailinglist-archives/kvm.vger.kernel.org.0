Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A304423E79
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhJFNRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 09:17:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231259AbhJFNRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 09:17:51 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196D1XbC018339;
        Wed, 6 Oct 2021 09:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fP3ug3GWtJ4XUtKhp0GIZhw+5L55xOn7loHEFuJiyek=;
 b=I8Ah1Bm8OzpcFhN7U9l2SVBsChLoge3vBHpNFib1FbL7RaC+mlBSPJGvQKtHxhnBcvrn
 892VB9b6BiQ9G2lfqlral5qheWjNqjo796cJrv1Jz7qL1jhsjaPMehKCBHPsi5xNoAI7
 juV7e0ANKdqz2lDIKT7ybh4a74Qm+mDv2J74k/VsFIiSxrsXpT0eGANkhUtCYCz+RlAX
 nJDfaaWqB6veZ1nFVsgkTJWcxWAqdGqw7O1U9bX9XlFSAul+vjX7MCXusY52ysLWEJFa
 u8F8nFEzE0iPU9wzuXmBhuLFkluiQoWloivIiKv6mVFjQqWlmpoOExlhAvokN0A8gHZY OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhcatre12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 09:15:59 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196D1mLF019460;
        Wed, 6 Oct 2021 09:15:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhcatre05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 09:15:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196D3JWJ030027;
        Wed, 6 Oct 2021 13:15:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2adp02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:15:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196DFp3k57409876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 13:15:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C77A3AE056;
        Wed,  6 Oct 2021 13:15:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54A3CAE045;
        Wed,  6 Oct 2021 13:15:51 +0000 (GMT)
Received: from [9.171.34.252] (unknown [9.171.34.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 13:15:51 +0000 (GMT)
Message-ID: <8e630f39-805f-7ea8-e36c-142095564b4a@linux.ibm.com>
Date:   Wed, 6 Oct 2021 15:15:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: kvm_stat: do not show halt_wait_ns
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Stefan Raspl <raspl@de.ibm.com>
References: <20211006121724.4154-1-borntraeger@de.ibm.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20211006121724.4154-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5Sfk6Joj-_0lfaTNCfPUMkCDwtVdgyay
X-Proofpoint-GUID: pHaaxB3B3zyTk8Kk_Te9gusC8O_X4T5P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_02,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=978 priorityscore=1501 clxscore=1011 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/21 14:17, Christian Borntraeger wrote:
> Similar to commit 111d0bda8eeb ("tools/kvm_stat: Exempt time-based
> counters"), we should not show timer values in kvm_stat. Remove the new
> halt_wait_ns.
> 
> Fixes: 87bcc5fa092f ("KVM: stats: Add halt_wait_ns stats for all architectures")
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Stefan Raspl <raspl@de.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Stefan Raspl <raspl@linux.ibm.com>
