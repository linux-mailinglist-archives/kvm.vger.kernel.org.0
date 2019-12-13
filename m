Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD1111DB45
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 01:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfLMAuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 19:50:18 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726897AbfLMAuS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 19:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576198216;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUaVXuLemLT2U2WNL56jj+lKMFOF8eSW7XMIEYuqX9M=;
        b=DgUsIBygVm5RRqezkdMf28+ngWoOJlIeIs6xwV9cnPfDhMvf5li7rKvuErYB7gQUZEIHT1
        8+hqi28R5IW6fvghRLfZjvmzrgtNzhyWHmGnMrGLjNsN+JKKKdsNAr8oIYRptnr+ws+GJP
        /Y/WOrJC5NQQCaAQQhP19g2D01YzegM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-leUMgiPINfOG3x_nIvnK1g-1; Thu, 12 Dec 2019 19:50:14 -0500
X-MC-Unique: leUMgiPINfOG3x_nIvnK1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4DE0107ACC4;
        Fri, 13 Dec 2019 00:50:13 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC0DD39C;
        Fri, 13 Dec 2019 00:50:08 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
Date:   Fri, 13 Dec 2019 11:50:06 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 8:23 PM, Marc Zyngier wrote:
> On 2019-12-12 02:45, Gavin Shan wrote:
>> This standardizes kvm exit reason field name by replacing "esr_ec"
>> with "exit_reason".
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>> =C2=A0virt/kvm/arm/trace.h | 14 ++++++++------
>> =C2=A01 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
>> index 204d210d01c2..0ac774fd324d 100644
>> --- a/virt/kvm/arm/trace.h
>> +++ b/virt/kvm/arm/trace.h
>> @@ -27,25 +27,27 @@ TRACE_EVENT(kvm_entry,
>> =C2=A0);
>>
>> =C2=A0TRACE_EVENT(kvm_exit,
>> -=C2=A0=C2=A0=C2=A0 TP_PROTO(int ret, unsigned int esr_ec, unsigned lo=
ng vcpu_pc),
>> -=C2=A0=C2=A0=C2=A0 TP_ARGS(ret, esr_ec, vcpu_pc),
>> +=C2=A0=C2=A0=C2=A0 TP_PROTO(int ret, unsigned int exit_reason, unsign=
ed long vcpu_pc),
>> +=C2=A0=C2=A0=C2=A0 TP_ARGS(ret, exit_reason, vcpu_pc),
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_STRUCT__entry(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=
=A0 int,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 )
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=A0=
 unsigned int,=C2=A0=C2=A0=C2=A0 esr_ec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 )
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=A0=
 unsigned int,=C2=A0=C2=A0=C2=A0 exit_reason=C2=A0=C2=A0=C2=A0 )
>=20
> I don't think the two are the same thing. The exit reason should be
> exactly that: why has the guest exited (exception, host interrupt, trap=
).
>=20
> What we're reporting here is the exception class, which doesn't apply t=
o
> interrupts, for example (hence the 0 down below, which we treat as a
> catch-all).
>=20

Marc, thanks a lot for your reply. Yeah, the combination (ret and esr_ec)=
 is
complete to indicate the exit reasons if I'm understanding correctly.

The exit reasons seen by kvm_stat is exactly the ESR_EL1[EC]. It's declar=
ed
by marcro AARCH64_EXIT_REASONS in tools/kvm/kvm_stat/kvm_stat. So it's pr=
ecise
and complete from perspective of kvm_stat.

For the patch itself, it standardizes the filter name by renaming "esr_ec=
"
to "exit_reason", no functional changes introduced and I think it would b=
e
fine.

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __field(=C2=A0=C2=A0=C2=
=A0 unsigned long,=C2=A0=C2=A0=C2=A0 vcpu_pc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 )
>> =C2=A0=C2=A0=C2=A0=C2=A0 ),
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_fast_assign(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->ret=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ARM_EXCEPTI=
ON_CODE(ret);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->esr_ec =3D ARM_EX=
CEPTION_IS_TRAP(ret) ? esr_ec : 0;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->exit_reason =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 AR=
M_EXCEPTION_IS_TRAP(ret) ? exit_reason: 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->vcpu_pc=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D vcpu_pc;
>> =C2=A0=C2=A0=C2=A0=C2=A0 ),
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08=
lx",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print_s=
ymbolic(__entry->ret, kvm_arm_exception_type),
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->esr_e=
c,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print_symbol=
ic(__entry->esr_ec, kvm_arm_exception_class),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->exit_=
reason,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __print_symbol=
ic(__entry->exit_reason,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_arm_exception_class),
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __entry->=
vcpu_pc)
>> =C2=A0);
>=20
> The last thing is whether such a change is an ABI change or not. I've b=
een very
> reluctant to change any of this for that reason.
>=20

Yeah, I think it is ABI change unfortunately, but I'm not sure how many a=
pplications
are using this filter. However, the fixed filter name ("exit_reason") is =
beneficial
in long run. The application needn't distinguish architects to provide di=
fferent
tracepoint filters at least.

Regards,
Gavin

