Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5F740AE7
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbjF1INA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:13:00 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47263 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231509AbjF1IKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:10:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 56E6F5C0078;
        Wed, 28 Jun 2023 00:55:46 -0400 (EDT)
Received: from imap50 ([10.202.2.100])
  by compute1.internal (MEProxy); Wed, 28 Jun 2023 00:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1687928146; x=1688014546; bh=Dr
        kfQZA4ZAS1gh0epx3coneRI+oyfY6k0HGVYNs6GJY=; b=Kf9Lwrmr0v8lFU0t92
        H5QXsii6fPb6Qlu/s5Jp0uC5J4ZhnylbNjKaJBO3MkadNpr25csmXaFVYUwd/Jdx
        rwaqd26MHUdVq51eQh6lkvQtKqtKJuKr5UXy9s43VL6Gu9tNw1jO6dxaE6wQQPX1
        L9K7wFv/1UFG9M7SlR7oQCiOD1a8c+Y7O7tzlOOgL51a5jHt17A3DDkJPzg6sBNJ
        2+PxT0VFfMKulsD6oETx4cHcynBFgT0CQWdti+UpSHGch0KEavZ6L3sQDzdqnQVc
        ZZEZTlIJkzWsnjFOn6J5cXOq9aV4+Z4SInTTZkM9AO1aPTO+Mes+7tBSanpKAl8Q
        aq2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1687928146; x=1688014546; bh=DrkfQZA4ZAS1g
        h0epx3coneRI+oyfY6k0HGVYNs6GJY=; b=P35eUrXrQAqM/4cW9cePk3hDAlY6c
        5Jq5RiqyDYbpcUZbJHToh47Pm3G0GiXb1J+qhQp7Lvchuya9rYJLi2+TB/it+TPj
        6pyomZcT2POh04hrzdnYxHT2d2MHoOMum4qEh/OaOvg5fSj8Cl5poE4V5SmEfP4a
        MZ4qXPZwHvGEwtdyJ/binLznlrQi7XVSlExKYHioNAMhe/IKTlaglTSjNe8+BiVr
        LowVo3Wke/5MUitu382SkGvbbxl7s71QV+t7CvBt/D4ynkc2O6gx6Gi8H+CK4NSN
        k5s/SjC1ODiPgq6ZBYLllsFTyYTsApkB631uP+qrZ9xc3D6bXfALXsvhQ==
X-ME-Sender: <xms:UL2bZLCUVtFhsnbPWsg-DNYDpJGIzmvHx9MfdyX_h8VfFwSDrNA8Sg>
    <xme:UL2bZBiLqeUDbJljf0PRLNUpdSRCPKmUFxjqeWj9AcGj9OIHxjU09b5u3XiVSyFC1
    B3kSp9KHH_AewFJ4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrtddugdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfuthgv
    fhgrnhcuqfdktfgvrghrfdcuoehsohhrvggrrhesfhgrshhtmhgrihhlrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeehjeelgeekkeelfeeugeekffduveffvdfghfefteejtefgfeek
    hfekkedttdefudenucffohhmrghinhepshhouhhrtggvfigrrhgvrdhorhhgpdhinhhfrh
    gruggvrggurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepshhorhgvrghrsehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:UL2bZGkhqB3QP820CC7YUMjw4XhGi1hZpsDGe7-GBqI28yiOPzUVWg>
    <xmx:UL2bZNz7Sc6saWs8J0QtG6-xiksAUBd1a7rRty71JHS7q2G5U2HwAA>
    <xmx:UL2bZASp24C38Hp_mdkx7_BBAGn-Of_6Yp6QzaCYn024u4Q2LpqRxA>
    <xmx:Ur2bZJDVYEvgRTpNJKkIiG774eQYP1AnCYcE2ORkKjdUFzt8jhp_bQ>
Feedback-ID: i84414492:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C72F21700089; Wed, 28 Jun 2023 00:55:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-499-gf27bbf33e2-fm-20230619.001-gf27bbf33
Mime-Version: 1.0
Message-Id: <b911c5e1-458a-456a-abe4-a8964580a85b@app.fastmail.com>
In-Reply-To: <mhng-97928779-5d76-4390-a84c-398fdc6a0a4f@palmer-ri-x1c9>
References: <mhng-97928779-5d76-4390-a84c-398fdc6a0a4f@palmer-ri-x1c9>
Date:   Wed, 28 Jun 2023 00:53:38 -0400
From:   "Stefan O'Rear" <sorear@fastmail.com>
To:     "Palmer Dabbelt" <palmer@dabbelt.com>
Cc:     "Andy Chiu" <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, anup@brainfault.org,
        "Atish Patra" <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        "Vineet Gupta" <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, "Jonathan Corbet" <corbet@lwn.net>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>,
        "Heiko Stuebner" <heiko.stuebner@vrull.eu>,
        "Evan Green" <evan@rivosinc.com>,
        "Conor Dooley" <conor.dooley@microchip.com>,
        "Andrew Jones" <ajones@ventanamicro.com>,
        "Celeste Liu" <coelacanthus@outlook.com>,
        "Andrew Bresticker" <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v21 03/27] riscv: hwprobe: Add support for probing V in
 RISCV_HWPROBE_KEY_IMA_EXT_0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, at 9:56 PM, Palmer Dabbelt wrote:
> On Tue, 27 Jun 2023 17:30:33 PDT (-0700), sorear@fastmail.com wrote:
>> On Mon, Jun 5, 2023, at 7:07 AM, Andy Chiu wrote:
>>> Probing kernel support for Vector extension is available now. This only
>>> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>>>
>>> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
>>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>>> Reviewed-by: Evan Green <evan@rivosinc.com>
>>> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
>>> ---
>>> Changelog v20:
>>>  - Fix a typo in document, and remove duplicated probes (Heiko)
>>>  - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
>>>    Evan)
>>> ---
>>>  Documentation/riscv/hwprobe.rst       | 3 +++
>>>  arch/riscv/include/uapi/asm/hwprobe.h | 1 +
>>>  arch/riscv/kernel/sys_riscv.c         | 4 ++++
>>>  3 files changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
>>> index 9f0dd62dcb5d..7431d9d01c73 100644
>>> --- a/Documentation/riscv/hwprobe.rst
>>> +++ b/Documentation/riscv/hwprobe.rst
>>> @@ -64,6 +64,9 @@ The following keys are defined:
>>>    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>>>      by version 2.2 of the RISC-V ISA manual.
>>>
>>> +  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as defined by
>>> +    version 1.0 of the RISC-V Vector extension manual.
>>> +
>>>  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>>>    information about the selected set of processors.
>>>
>>> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h
>>> b/arch/riscv/include/uapi/asm/hwprobe.h
>>> index 8d745a4ad8a2..7c6fdcf7ced5 100644
>>> --- a/arch/riscv/include/uapi/asm/hwprobe.h
>>> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
>>> @@ -25,6 +25,7 @@ struct riscv_hwprobe {
>>>  #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
>>>  #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
>>>  #define		RISCV_HWPROBE_IMA_C		(1 << 1)
>>> +#define		RISCV_HWPROBE_IMA_V		(1 << 2)
>>>  #define RISCV_HWPROBE_KEY_CPUPERF_0	5
>>>  #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
>>>  #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
>>> diff --git a/arch/riscv/kernel/sys_riscv.c
>>> b/arch/riscv/kernel/sys_riscv.c
>>> index 5db29683ebee..88357a848797 100644
>>> --- a/arch/riscv/kernel/sys_riscv.c
>>> +++ b/arch/riscv/kernel/sys_riscv.c
>>> @@ -10,6 +10,7 @@
>>>  #include <asm/cpufeature.h>
>>>  #include <asm/hwprobe.h>
>>>  #include <asm/sbi.h>
>>> +#include <asm/vector.h>
>>>  #include <asm/switch_to.h>
>>>  #include <asm/uaccess.h>
>>>  #include <asm/unistd.h>
>>> @@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe
>>> *pair,
>>>  		if (riscv_isa_extension_available(NULL, c))
>>>  			pair->value |= RISCV_HWPROBE_IMA_C;
>>>
>>> +		if (has_vector())
>>> +			pair->value |= RISCV_HWPROBE_IMA_V;
>>> +
>>>  		break;
>>
>> I am concerned by the exception this is making.  I believe the intention of
>> riscv_hwprobe is to replace AT_HWCAP as the single point of truth for userspace
>> to make instruction use decisions.  Since this does not check riscv_v_vstate_ctrl_user_allowed,
>> application code which wants to know if V instructions are usable must use
>> AT_HWCAP instead, unlike all other extensions for which the relevant data is
>> available within the hwprobe return.
>
> I guess we were vague in the docs about what "supported" means, but IIRC 
> the goal was for riscv_hwprobe() to indicate what's supported by both 
> the HW and the kernel.  In other words, hwprobe should indicate what's 

Should this be "the HW, the firmware, and the kernel" in the cases where it
matters, or are you considering the firmware part of the kernel's view of
the hardware?

> possible to enable -- even if there's some additional steps necessary to 
> enable it.
>
> We can at least make this a little more explicit with something like
>
>     diff --git a/Documentation/riscv/hwprobe.rst 
> b/Documentation/riscv/hwprobe.rst
>     index 19165ebd82ba..7f82a5385bc3 100644
>     --- a/Documentation/riscv/hwprobe.rst
>     +++ b/Documentation/riscv/hwprobe.rst
>     @@ -27,6 +27,13 @@ AND of the values for the specified CPUs. 
> Usermode can supply NULL for cpus and
>      0 for cpu_count as a shortcut for all online CPUs. There are 
> currently no flags,
>      this value must be zero for future compatibility.
>     
>     +Calls to `sys_riscv_hwprobe()` indicate the features supported by 
> both the
>     +kernel and the hardware that the system is running on.  For 
> example, if the
>     +hardware supports the V extension and the kernel has V support 
> enabled then
>     +`RISCV_HWPROBE_KEY_IMA_EXT_0`/`RISCV_HWPROBE_IMA_V` will be set 
> even if the V
>     +extension is disabled via a userspace-controlled tunable such as
>     +`PR_RISCV_V_SET_CONTROL`.
>     +
>      On success 0 is returned, on failure a negative error code is 
> returned.
>     
>      The following keys are defined:
>     @@ -65,7 +72,10 @@ The following keys are defined:
>          by version 2.2 of the RISC-V ISA manual.
>     
>        * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, 
> as defined by
>     -    version 1.0 of the RISC-V Vector extension manual.
>     +    version 1.0 of the RISC-V Vector extension manual.  For strict 
> uABI
>     +    compatibility some systems may disable V by default even when 
> the hardware
>     +    supports in, in which case users must call 
> `prctl(PR_RISCV_V_SET_CONTROL,
>     +    ...` to explicitly allow V to be used.
>     
>        * :c:macro:`RISCV_HWPROBE_EXT_ZBA`: The Zba address generation 
> extension is
>             supported, as defined in version 1.0 of the 
> Bit-Manipulation ISA
>
> IMO that's the better way to go that to require that userspace tries to enable
> V via the prctl() first, but we haven't released this yet so in theory we could
> still change it.

It's certainly a more precise definition but I'm arguing it's not a useful one.

The description of the prctl() in Documentation/riscv/vector.rst is fairly clear
that it is intended only for use by init systems, and not by libraries.

Would you agree that "V is supported by the hardware and kernel, and could have
been enabled by the init system but wasn't" is not actionable information for
most applications and libraries?

https://sourceware.org/pipermail/libc-alpha/2023-April/147062.html proposes to
use hwprobe to "do things like dynamically choose a memcpy implementation".
Would you agree that hwprobe as currently defined in for-next is not suitable
for the purpose described in that message, since it describes features that could
be enabled, not features that are enabled?

> We'd have a similar discussion for some of the counters that need to feed
> through the perf interface, though those are still in flight...

The documented intent of the vector prctl is to enable or disable vector use as
a policy for a tree of processes.  If I understand them correctly the perf
counter user access patches require _individual processes_ to enable perf
counters for their own use, which makes it a very different story from the
perspective of the hwprobe API consumers.

-s

>> Assuming this is intentional, what is the path forward for future extensions
>> that cannot be used from userspace without additional conditions being met?
>> For instance, if we add support in the future for the Zve* extensions, the V
>> bit would not be set in HWCAP for them, which would require library code to
>> use the prctl interface unless we define the hwcap bits to imply userspace
>> usability.
>
> In this case a system that supports some of the Zve extensions but not 
> the full V extension would not be probably from userspace, as V would 
> not be set anywhere.  The way to support that would be to add new bits 
> into hwprobe to indicate those extensions, it just wasn't clear that 
> anyone was interested in building Linux-flavored systems that supported 
> only some a strict subset of V.
>
> Happy to see patches if you know of some hardware in the pipeline, though ;)
>
>>
>> -s
>>
>>>  	case RISCV_HWPROBE_KEY_CPUPERF_0:
>>> --
>>> 2.17.1
>>>
>>>
>>> _______________________________________________
>>> linux-riscv mailing list
>>> linux-riscv@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
