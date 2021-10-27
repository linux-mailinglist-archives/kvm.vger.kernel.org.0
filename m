Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B19F43C24C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 07:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239564AbhJ0FoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 01:44:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10058 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233793AbhJ0FoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 01:44:19 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R4kwcI022693;
        Wed, 27 Oct 2021 05:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=z4zVekMJb2A7Z8gao/omTLQSGSzMa4L8ihjQ3jWsJQY=;
 b=mL6P3uwKyKPnmzE2D2LWpOLkS7Z6wqVDpagfXLe6gWnlOIMGk2MvLho4a5yG19xbpQIn
 gx77QWKHhWEO9DHfFXTS5rhpznhV+wxjqCp9Ejs2IaXAgFwGyMirad46NSdhC47O2v1k
 PPkOqtr5nrDQAYBWHSWVO+XT/8GIthbSymUWtN2JU6Hk7LsaOgPIJFFnG0iUnx2Mw+oU
 83m3dhkWvYpSagT1FPFxTxCzOkdFVyPrA18enzk6ip76cFIjHZ89UaZUkvfywgl7zg+H
 F9hj1KQeGJVhXtMuR0HpbYX4t4HskqipGY1f90L9c1GyS/VCtOqFfcqLJymk4DgYd1oe aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k9c65k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:41:54 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19R5Rucg020974;
        Wed, 27 Oct 2021 05:41:53 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k9c657-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:41:53 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19R5cUfj030044;
        Wed, 27 Oct 2021 05:41:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3bx4eptu6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:41:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19R5fmZF52625686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 05:41:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93F2AE055;
        Wed, 27 Oct 2021 05:41:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AC9CAE045;
        Wed, 27 Oct 2021 05:41:48 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.78.35])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 05:41:48 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
To:     Collin Walling <walling@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <5f91eed7-993a-cb76-8a9f-0c17438cd064@de.ibm.com>
Date:   Wed, 27 Oct 2021 07:41:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027025451.290124-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AqsuzR8Q-z4-w_1cQNajp8036A3sZNg0
X-Proofpoint-ORIG-GUID: lq74MrM9VGVqyc06VbhhMObCY46jQNFR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 27.10.21 um 04:54 schrieb Collin Walling:
> The diag 318 data contains values that denote information regarding the
> guest's environment. Currently, it is unecessarily difficult to observe
> this value (either manually-inserted debug statements, gdb stepping, mem
> dumping etc). It's useful to observe this information to obtain an
> at-a-glance view of the guest's environment, so lets add a simple VCPU
> event that prints the CPNC to the s390dbf logs.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>

applied and queued
> ---
>   arch/s390/kvm/kvm-s390.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..da3ff24eabd0 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>   	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>   		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>   		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
> +		VCPU_EVENT(vcpu, 2, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);

After comparing this with the other events I think level==3 is better. Changed when applying.
>   	}
>   	/*
>   	 * If userspace sets the riccb (e.g. after migration) to a valid state,
> 
