Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A006F9086
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 10:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjEFIVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjEFIV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 04:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90ADD9EF9
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 01:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683361241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+cU6hTxnO9+qbS4HZrZOmgB68CTHmsF8DCfihRTe+M=;
        b=KTW0r2HhoHkuk+jK1DyS2gZQbsgyaS8qVAGoAAvNBIQmwZt/EuiPPF9k5FisyUNTz+Gnff
        ESt+Fw5Yd0X8FIB9u67B7aVONBlvv9f0zatLX3u7rV6SwBwo9p6yif8T3uliQGZcdMqJaB
        FkyctEadoR2PWul/FrOjKqOEAIEBMq0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-fcyq1iJ_NPuaaE_FUQvT5A-1; Sat, 06 May 2023 04:20:36 -0400
X-MC-Unique: fcyq1iJ_NPuaaE_FUQvT5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B88DE1C05AF3;
        Sat,  6 May 2023 08:20:35 +0000 (UTC)
Received: from ptitbras (unknown [10.39.192.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 104AC1121314;
        Sat,  6 May 2023 08:20:33 +0000 (UTC)
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
 <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
User-agent: mu4e 1.10.0; emacs 28.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     jejb@linux.ibm.com
Cc:     =?utf-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Date:   Fri, 05 May 2023 14:35:29 +0200
In-reply-to: <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
Message-ID: <m25y95j2gg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023-05-04 at 13:04 -04, James Bottomley <jejb@linux.ibm.com> wrote...
> On Wed, 2023-05-03 at 14:26 +0200, J=C3=B6rg R=C3=B6del wrote:
>> On Tue, May 02, 2023 at 06:03:55PM -0500, Tom Lendacky wrote:
> [...]
>> > =C2=A0 - On the subject of priorities, the number one priority for the
>> > =C2=A0=C2=A0=C2=A0 linux-svsm project has been to quickly achieve prod=
uction
>> > quality vTPM support. The support for this is being actively worked
>> > on by linux-svsm contributors and we'd want to find fastest path
>> > towards getting that redirected into coconut-svsm (possibly
>> > starting with CPL0
>> > =C2=A0=C2=A0=C2=A0 implementation until CPL3 support is available) and=
 the project
>> > =C2=A0=C2=A0=C2=A0 hardened for a release.=C2=A0 I imagine there will =
be some competing
>> > =C2=A0=C2=A0=C2=A0 priorities from coconut-svsm project currently, so =
wanted to
>> > get this out on the table from the beginning.
>>
>> That has been under discussion for some time, and honestly I think
>> the approach taken is the main difference between linux-svsm and
>> COCONUT. My position here is, and that comes with a big 'BUT', that I
>> am not fundamentally opposed to having a temporary solution for the
>> TPM until CPL-3 support is at a point where it can run a TPM module.
>
> OK, so this, for IBM, is directly necessary.  We have the vTPM pull
> request about ready to go and we'll probably send it still to the AMD
> SVSM.  Given that the AMD SVSM already has the openssl library and the
> attestation report support, do you want to pull them into coconut
> directly so we can base a coconut vTPM pull request on that?
>
>> And here come the 'BUT': Since the goal of having one project is to
>> bundle community efforts, I think that the joint efforts are better
>> targeted at getting CPL-3 support to a point where it can run
>> modules. On that side some input and help is needed, especially to
>> define the syscall interface so that it suits the needs of a TPM
>> implementation.
>
> Crypto support in ring-0 is unavoidable if we want to retain control of
> the VMPCK0 key in ring-0.  I can't see us giving it to ring-3 because
> that would give up control of the SVSM identity and basically make the
> ring-0 separation useless because you can compromise ring-3 and get the
> key and then communicate with the PSP as the SVSM.

I'm a but confused regarding the roles that VMPL vs rings is in the security
model here. In particular, I assume that any attack on ring3 would still
have to cross either the VMPL boundary (if coming from the guest) or the TEE
boundary (if coming from the host).

>
> I think the above problem also indicates no-one really has a fully
> thought out security model that shows practically how ring-3 improves
> the security posture.  So I really think starting in ring-0 and then
> moving pieces to ring-3 and discussing whether this materially improves
> the security posture based on the code and how it operates gets us
> around the lack of understanding of the security model because we
> proceed by evolution.

And there is definitely a lot of complexity added by supporting ring3. You
are essentially getting the complexity of a "real" operating system. By
contrast, TDX is providing the same kind of isolation with secure enclaves,
but at least the base OS kernel is shared.

The expected benefit is to be able to run more complex code from ring3 with
a better way to handle malfunctions, faults, whatever. At least that's the
way I read it. So it's a way to write software in a more modular way.

IIUC, the ring-3 modules of the SVSM would still be at VMPL0, so presumably,
not accesible from host or guest. If we consider this property as strong,
then do we really care entrusting ring3 with sensitive data?

>
> The next question that's going to arise is *where* the crypto libraries
> should reside.  Given they're somewhat large, duplicating them for
> every cpl-3 application plus cpl-3 seems wasteful, so some type of vdso
> model sounds better (and might work instead of a syscall interfaces for
> cpl-0 services that are pure code).

I don't understand what you call "pure code". I presume you mean "code that
does not need to access ring0 data"?

>
>> It is also not the case that CPL-3 support is out more than a year or
>> so. The RamFS is almost ready, as is the archive file inclusion[1].
>> We will move to task management next, the goal is still to have basic
>> support ready in 2H2023.
>>
>> [1] https://github.com/coconut-svsm/svsm/pull/27
>
> Well, depending on how you order them, possibly.  The vTPM has a simple
> request/response model, so it really doesn't have much need of a
> scheduler for instance.  And we could obviously bring up cpl-3 before a
> module loader/ram filesystem and move to that later.
>
>> If there is still a strong desire to have COCONUT with a TPM (running
>> at CPL-0) before CPL-3 support is usable, then I can live with
>> including code for that as a temporary solution. But linking huge
>> amounts of C code (like openssl or a tpm lib) into the SVSM rust
>> binary kind of contradicts the goals which made us using Rust for
>> project in the first place. That is why I only see this as a
>> temporary solution.
>
> I'm not sure it will be.  If some cloud or distro wants to shoot for
> FIPS compliance of the SVSM, for instance, a requirement will likely be
> to use a FIPS certified crypto library ... and they're all currently in
> C.  That's not to say we shouldn't aim for minimizing the C
> dependencies, but I don't see a "pure rust or else" approach
> facilitating the initial utility of the project.
>
> James


--
Cheers,
Christophe de Dinechin (https://c3d.github.io)
Freedom Covenant (https://github.com/c3d/freedom-covenant)
Theory of Incomplete Measurements (https://c3d.github.io/TIM)

