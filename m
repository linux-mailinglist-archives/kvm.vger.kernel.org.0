Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4D4492826
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbiARORt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:17:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbiARORs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 09:17:48 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IEBa3M024929;
        Tue, 18 Jan 2022 14:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cfKbut9R12wdzkP3BqGvG0qGTq5ITpv79/1msMfHDE4=;
 b=He7HAmHhFHIXlwTEf33QhcMKeie91pF6r++wtBhvN1bl/xTHblclIsyBhDlDvqN/i8q9
 cpSHTr48qvdNH+i8JAt3L/kUtkYAP5cs+DIDrGBVBMFzvo5hWMJD2CiM7bikj2frvcGc
 GOlcKYF2muKetBXqCpi76IKKFiLt5Lr+g9pCzaakA0ON0DcVpQLs25i2EEmPICKzA3ca
 42kBsNGJB5yYjrDj+YetITgn+1gIzZNQ8pYXBtvBDiHXNEjx7oTrCLVlc57+w6ApaRmU
 rwEWLVw/dx54YdUIyKx9HJaDj8K/hGeHJb3t/AiHEWfd2b/C7VKsGpZo0hocp4qqXrvI zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjwuq8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 14:16:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IECndL032346;
        Tue, 18 Jan 2022 14:16:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjwuq74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 14:16:27 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IEFXod007255;
        Tue, 18 Jan 2022 14:16:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw9bwjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 14:16:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IE6a4231785230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 14:06:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B3D5AE058;
        Tue, 18 Jan 2022 14:15:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACF84AE051;
        Tue, 18 Jan 2022 14:15:51 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 14:15:51 +0000 (GMT)
Message-ID: <77e8d214-372b-3f0e-7b4e-5c2d23a4199c@linux.ibm.com>
Date:   Tue, 18 Jan 2022 15:15:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
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
 <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
 <20220118131223.GC17938@C02TD0UTHF1T.local>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118131223.GC17938@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: apQBE_BGUNoyRSDIRrY4wFjy4JO4HZuL
X-Proofpoint-ORIG-GUID: gPYCTVnG2DV1pSbyRVhK4x0S-IUnsiKk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201180087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.01.22 um 14:12 schrieb Mark Rutland:
> On Tue, Jan 18, 2022 at 01:42:26PM +0100, Christian Borntraeger wrote:
>>
>>
>> Am 18.01.22 um 13:02 schrieb Mark Rutland:
>>> On Mon, Jan 17, 2022 at 06:45:36PM +0100, Paolo Bonzini wrote:
>>>> On 1/14/22 16:19, Mark Rutland wrote:
>>>>> I also think there is another issue here. When an IRQ is taken from SIE, will
>>>>> user_mode(regs) always be false, or could it be true if the guest userspace is
>>>>> running? If it can be true I think tha context tracking checks can complain,
>>>>> and it*might*  be possible to trigger a panic().
>>>>
>>>> I think that it would be false, because the guest PSW is in the SIE block
>>>> and switched on SIE entry and exit, but I might be incorrect.
>>>
>>> Ah; that's the crux of my confusion: I had thought the guest PSW would
>>> be placed in the regular lowcore *_old_psw slots. From looking at the
>>> entry asm it looks like the host PSW (around the invocation of SIE) is
>>> stored there, since that's what the OUTSIDE + SIEEXIT handling is
>>> checking for.
>>>
>>> Assuming that's correct, I agree this problem doesn't exist, and there's
>>> only the common RCU/tracing/lockdep management to fix.
>>
>> Will you provide an s390 patch in your next iteration or shall we then do
>> one as soon as there is a v2? We also need to look into vsie.c where we
>> also call sie64a
> 
> I'm having a go at that now; my plan is to try to have an s390 patch as
> part of v2 in the next day or so.
> 
> Now that I have a rough idea of how SIE and exception handling works on
> s390, I think the structural changes to kvm-s390.c:__vcpu_run() and
> vsie.c:do_vsie_run() are fairly simple.
> 
> The only open bit is exactly how/where to identify when the interrupt
> entry code needs to wake RCU. I can add a per-cpu variable or thread
> flag to indicate that we're inside that EQS, or or I could move the irq
> enable/disable into the sie64a asm and identify that as with the OUTSIDE
> macro in the entry asm.
What exactly would the low-level interrupt handler need to do?

CC Sven, Heiko for the entry.S changes.

