Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70D3BF66B
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 09:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhGHHr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 03:47:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48643 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230463AbhGHHr4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 03:47:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3217E1940A12;
        Thu,  8 Jul 2021 03:45:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 08 Jul 2021 03:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fs8Fw3
        B/MxbOBk66GHqMORc4adG8RcWLEZr4+IxeVFY=; b=p+oqyNxvNg1CCZAmyEWXQA
        SKsEqw/k4fR3aFpCj3QuaJUpjhr5haZizBhuhmpJk3Uvf43TA8EWe1y4kf8njYaD
        8eAKidIOFu7/kqm9Hw7h4IMG01HDAqYCzCqJrHtBcmjLzA70a694KFr/DSGoOgVj
        sj40KUj26uNxWIDP5lIlJ3fz6j6DFZhaTPFOXz15/o8/tF0WEa90MYV3ZFMcVYXr
        lEtDxYXfPAt5DTJP2m6gYFsY5KAQnkixvAyd/Mq48y3CSFvWIPuRLY4m9rmfKROJ
        LUx7mLHy07aaDkVCUlSGx8iCU1cPJa50cfiPt67BgmCmDp/ft4xXeatEjA9QLe6A
        ==
X-ME-Sender: <xms:Cq3mYAbBKEBUjCjzAMuayeBbloH7NiCLJPCvxoxZKNasnbcNk-EppQ>
    <xme:Cq3mYLavQ1xFe617uJwUiGvFueIsbT15sbIAOS8ufiVIbazav0i6KrJ9JRlQLoFRR
    qr_gRS_VTvRjXy5GI4>
X-ME-Received: <xmr:Cq3mYK-s1986fHRzbBKACtxGCQgPXY6wxmbMZAuF0ShtOzMir3f1dPoUxa7ex_0120R3GKhIUmvHiBptjpE18dbctewAwogrGUnk1Hms7Ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdefgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegumhgvsegumh
    gvrdhorhhg
X-ME-Proxy: <xmx:Cq3mYKosMUyer9po5NwK2ENIbv7CeN_wxHkr25YpPcIy998PFPa2Ww>
    <xmx:Cq3mYLqEDHQ698DJlVrcWtisYsxcYkghDlDqk3cc3LAq_CZFdDAdeA>
    <xmx:Cq3mYIQ78tDuQPEqWq18eInDRuu6VN94TRUTSBu4cQaNxXdIpRGHxA>
    <xmx:C63mYIi55QSarcgF02KshZUhNsg08opf9x2g5tcLpNeu5mWiaz62tA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 03:45:13 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 122846d3;
        Thu, 8 Jul 2021 07:45:12 +0000 (UTC)
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cameron Esfahani <dirty@apple.com>, babu.moger@amd.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 8/8] target/i386: Move X86XSaveArea into TCG
In-Reply-To: <m2czru4epe.fsf@dme.org>
References: <20210705104632.2902400-1-david.edmondson@oracle.com> <20210705104632.2902400-9-david.edmondson@oracle.com> <0d75c3ab-926b-d4cd-244a-8c8b603535f9@linaro.org> <m2czru4epe.fsf@dme.org>
X-HGTTG: zarniwoop
From:   David Edmondson <dme@dme.org>
Date:   Thu, 08 Jul 2021 08:45:12 +0100
Message-ID: <m24kd5p7uf.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-07-07 at 11:10:21 +01, David Edmondson wrote:

> On Tuesday, 2021-07-06 at 18:09:42 -07, Richard Henderson wrote:
>
>> On 7/5/21 3:46 AM, David Edmondson wrote:
>>> Given that TCG is now the only consumer of X86XSaveArea, move the
>>> structure definition and associated offset declarations and checks to a
>>> TCG specific header.
>>> 
>>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>>> ---
>>>   target/i386/cpu.h            | 57 ------------------------------------
>>>   target/i386/tcg/fpu_helper.c |  1 +
>>>   target/i386/tcg/tcg-cpu.h    | 57 ++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 58 insertions(+), 57 deletions(-)
>>> 
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index 96b672f8bd..0f7ddbfeae 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -1305,48 +1305,6 @@ typedef struct XSavePKRU {
>>>       uint32_t padding;
>>>   } XSavePKRU;
>>>   
>>> -#define XSAVE_FCW_FSW_OFFSET    0x000
>>> -#define XSAVE_FTW_FOP_OFFSET    0x004
>>> -#define XSAVE_CWD_RIP_OFFSET    0x008
>>> -#define XSAVE_CWD_RDP_OFFSET    0x010
>>> -#define XSAVE_MXCSR_OFFSET      0x018
>>> -#define XSAVE_ST_SPACE_OFFSET   0x020
>>> -#define XSAVE_XMM_SPACE_OFFSET  0x0a0
>>> -#define XSAVE_XSTATE_BV_OFFSET  0x200
>>> -#define XSAVE_AVX_OFFSET        0x240
>>> -#define XSAVE_BNDREG_OFFSET     0x3c0
>>> -#define XSAVE_BNDCSR_OFFSET     0x400
>>> -#define XSAVE_OPMASK_OFFSET     0x440
>>> -#define XSAVE_ZMM_HI256_OFFSET  0x480
>>> -#define XSAVE_HI16_ZMM_OFFSET   0x680
>>> -#define XSAVE_PKRU_OFFSET       0xa80
>>> -
>>> -typedef struct X86XSaveArea {
>>> -    X86LegacyXSaveArea legacy;
>>> -    X86XSaveHeader header;
>>> -
>>> -    /* Extended save areas: */
>>> -
>>> -    /* AVX State: */
>>> -    XSaveAVX avx_state;
>>> -
>>> -    /* Ensure that XSaveBNDREG is properly aligned. */
>>> -    uint8_t padding[XSAVE_BNDREG_OFFSET
>>> -                    - sizeof(X86LegacyXSaveArea)
>>> -                    - sizeof(X86XSaveHeader)
>>> -                    - sizeof(XSaveAVX)];
>>> -
>>> -    /* MPX State: */
>>> -    XSaveBNDREG bndreg_state;
>>> -    XSaveBNDCSR bndcsr_state;
>>> -    /* AVX-512 State: */
>>> -    XSaveOpmask opmask_state;
>>> -    XSaveZMM_Hi256 zmm_hi256_state;
>>> -    XSaveHi16_ZMM hi16_zmm_state;
>>> -    /* PKRU State: */
>>> -    XSavePKRU pkru_state;
>>> -} X86XSaveArea;
>>> -
>>>   QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>>>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
>>>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
>>> @@ -1355,21 +1313,6 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
>>>   QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>>>   QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
>>>   
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
>>> -QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
>>> -
>>>   typedef struct ExtSaveArea {
>>>       uint32_t feature, bits;
>>>       uint32_t offset, size;
>>> diff --git a/target/i386/tcg/fpu_helper.c b/target/i386/tcg/fpu_helper.c
>>> index 4e11965067..74bbe94b80 100644
>>> --- a/target/i386/tcg/fpu_helper.c
>>> +++ b/target/i386/tcg/fpu_helper.c
>>> @@ -20,6 +20,7 @@
>>>   #include "qemu/osdep.h"
>>>   #include <math.h>
>>>   #include "cpu.h"
>>> +#include "tcg-cpu.h"
>>>   #include "exec/helper-proto.h"
>>>   #include "fpu/softfloat.h"
>>>   #include "fpu/softfloat-macros.h"
>>> diff --git a/target/i386/tcg/tcg-cpu.h b/target/i386/tcg/tcg-cpu.h
>>> index 36bd300af0..53a8494455 100644
>>> --- a/target/i386/tcg/tcg-cpu.h
>>> +++ b/target/i386/tcg/tcg-cpu.h
>>> @@ -19,6 +19,63 @@
>>>   #ifndef TCG_CPU_H
>>>   #define TCG_CPU_H
>>>   
>>> +#define XSAVE_FCW_FSW_OFFSET    0x000
>>> +#define XSAVE_FTW_FOP_OFFSET    0x004
>>> +#define XSAVE_CWD_RIP_OFFSET    0x008
>>> +#define XSAVE_CWD_RDP_OFFSET    0x010
>>> +#define XSAVE_MXCSR_OFFSET      0x018
>>> +#define XSAVE_ST_SPACE_OFFSET   0x020
>>> +#define XSAVE_XMM_SPACE_OFFSET  0x0a0
>>> +#define XSAVE_XSTATE_BV_OFFSET  0x200
>>> +#define XSAVE_AVX_OFFSET        0x240
>>> +#define XSAVE_BNDREG_OFFSET     0x3c0
>>> +#define XSAVE_BNDCSR_OFFSET     0x400
>>> +#define XSAVE_OPMASK_OFFSET     0x440
>>> +#define XSAVE_ZMM_HI256_OFFSET  0x480
>>> +#define XSAVE_HI16_ZMM_OFFSET   0x680
>>> +#define XSAVE_PKRU_OFFSET       0xa80
>>> +
>>> +typedef struct X86XSaveArea {
>>> +    X86LegacyXSaveArea legacy;
>>> +    X86XSaveHeader header;
>>> +
>>> +    /* Extended save areas: */
>>> +
>>> +    /* AVX State: */
>>> +    XSaveAVX avx_state;
>>> +
>>> +    /* Ensure that XSaveBNDREG is properly aligned. */
>>> +    uint8_t padding[XSAVE_BNDREG_OFFSET
>>> +                    - sizeof(X86LegacyXSaveArea)
>>> +                    - sizeof(X86XSaveHeader)
>>> +                    - sizeof(XSaveAVX)];
>>> +
>>> +    /* MPX State: */
>>> +    XSaveBNDREG bndreg_state;
>>> +    XSaveBNDCSR bndcsr_state;
>>> +    /* AVX-512 State: */
>>> +    XSaveOpmask opmask_state;
>>> +    XSaveZMM_Hi256 zmm_hi256_state;
>>> +    XSaveHi16_ZMM hi16_zmm_state;
>>> +    /* PKRU State: */
>>> +    XSavePKRU pkru_state;
>>> +} X86XSaveArea;
>>> +
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fcw) != XSAVE_FCW_FSW_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.ftw) != XSAVE_FTW_FOP_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpip) != XSAVE_CWD_RIP_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpdp) != XSAVE_CWD_RDP_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.mxcsr) != XSAVE_MXCSR_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.fpregs) != XSAVE_ST_SPACE_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, legacy.xmm_regs) != XSAVE_XMM_SPACE_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
>>> +QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
>>
>> My only quibble is that these offsets are otherwise unused.  This just becomes validation 
>> of compiler layout.
>
> Yes.
>
>> I presume that XSAVE_BNDREG_OFFSET is not merely ROUND_UP(offsetof(avx_state) + 
>> sizeof(avx_state), some_pow2)?
>
> The offsets were just extracted from a CPU at some point in the
> past. It's likely that things are as you describe, but that is not
> defined anywhere.
>
>> Do these offsets need to be migrated?  Otherwise, how can one start a vm with kvm and then 
>> migrate to tcg?  I presume the offsets above are constant for a given cpu, and that 
>> whatever cpu provides different offsets is not supported by tcg?  Given the lack of avx, 
>> that's trivial these days...
>
> For TCG I think that the offsets used should be derived from the CPU
> model selected, rather than being the same for all CPU models.
>
> If that was done, then in principle it should be possible to migrate
> XSAVE state between same CPU model KVM and TCG environments.

Actually, that's nonsense. With KVM or HVF we have to use the offsets of
the host CPU, as the hardware won't do anything else, irrespective of
the general CPU model chosen.

To have KVM -> TCG migration work it would be necessary to pass the
offsets in the migration stream and have TCG observe them, as you
originally said.

TCG -> KVM migration would only be possible if TCG was configured to use
the same offsets as would later required by KVM (meaning, the host CPU).

dme.
-- 
She's as sweet as Tupelo honey, she's an angel of the first degree.
