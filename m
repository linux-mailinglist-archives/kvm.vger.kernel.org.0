Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0584925E2
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 13:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbiARMoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 07:44:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10334 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237441AbiARMoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 07:44:17 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ICYsYb035744;
        Tue, 18 Jan 2022 12:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=m12V+yXH4hlsiZwa8i+pDOp/j8Cs7qgKrlgEwxXj7L4=;
 b=RnlpiRvsUmkTWbjkruFslYg1tMFQEJuByDNn/0YTdV7DSI138NX40q5meitQdeZeW1Yu
 k5EjYZWjx9qzdO56Aja0MBuq7X6zydGGr2b/7ryqUtGTk+0pWv0/UvAgzDo9tFZTnhCq
 1k2P5DRAR2BQ79VW7//cIBf0CxghnC0wU7poxz2X0XDJ+Vk3dmGawcG8O7VEddXlyFql
 fQXA8mYfg7MLeFtLfrvIuBe06ReGD+eoc2oj85gI0N8OiMxaxJZBX8t0doppb8oWBua3
 dpD1zfzbh0R9xrycvwLTF86PosVpuQlw0XDwCxxcVroA7CfX9Kdvjs34WHLCN5M0NDdM Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnv93anyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:42:35 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ICgYjv023877;
        Tue, 18 Jan 2022 12:42:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnv93anxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:42:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ICbc3T000483;
        Tue, 18 Jan 2022 12:42:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9m9cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:42:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ICgT1r44761424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 12:42:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B548AE134;
        Tue, 18 Jan 2022 12:42:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85CDBAE143;
        Tue, 18 Jan 2022 12:42:26 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 12:42:26 +0000 (GMT)
Message-ID: <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:42:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
 <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
 <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
 <20220118120154.GA17938@C02TD0UTHF1T.local>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118120154.GA17938@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kBuNuBs-U6Vi15T0uagzyQoDh0iT-1MZ
X-Proofpoint-GUID: ryNn6W6_ACAD_AcE88cXBjk0KElOYo9l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_03,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.01.22 um 13:02 schrieb Mark Rutland:
> On Mon, Jan 17, 2022 at 06:45:36PM +0100, Paolo Bonzini wrote:
>> On 1/14/22 16:19, Mark Rutland wrote:
>>> I also think there is another issue here. When an IRQ is taken from SIE, will
>>> user_mode(regs) always be false, or could it be true if the guest userspace is
>>> running? If it can be true I think tha context tracking checks can complain,
>>> and it*might*  be possible to trigger a panic().
>>
>> I think that it would be false, because the guest PSW is in the SIE block
>> and switched on SIE entry and exit, but I might be incorrect.
> 
> Ah; that's the crux of my confusion: I had thought the guest PSW would
> be placed in the regular lowcore *_old_psw slots. From looking at the
> entry asm it looks like the host PSW (around the invocation of SIE) is
> stored there, since that's what the OUTSIDE + SIEEXIT handling is
> checking for.
> 
> Assuming that's correct, I agree this problem doesn't exist, and there's
> only the common RCU/tracing/lockdep management to fix.

Will you provide an s390 patch in your next iteration or shall we then do
one as soon as there is a v2? We also need to look into vsie.c where we
also call sie64a
