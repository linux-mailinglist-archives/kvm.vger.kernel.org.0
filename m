Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2259375B5EA
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 19:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjGTRxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 13:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjGTRw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 13:52:58 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531BF1BD
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 10:52:57 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-345bc4a438fso8665ab.1
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 10:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689875576; x=1690480376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyJrOl+mRZzvYzgNtRU56geodgE3Is9HDPyopZhcu+Q=;
        b=c8Vk4ZXRrDEu45HwzCD42QsTN/zf6noJGcf5U0Ket6yJ9sIjya+fnfi9DOtX7r3MgL
         UTRceI+FY5To/Kl1X3eUlopfAMQghNfA7ozEpUbNvueGh43RyTk1hrz8O7aCl6sv2/Kg
         j4H8KWK5ylr600ZKi4uxgL+Ifh9M5d4R7exKYvVW/IzGerZrN9/Navx4ay27KnVVf3FO
         mjYLb2wEMd0y3KjgreaxM2QTLH02zdfplRfvT4O+msbKANDzqBbZB9nvEPUqolEyRY2X
         SUF8LPOhH8QKQmXbyqWUs9iffrDucvoigQFJmUWyt6c0m0oh5cDy1LVSelfO82f3AOBE
         YjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689875576; x=1690480376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyJrOl+mRZzvYzgNtRU56geodgE3Is9HDPyopZhcu+Q=;
        b=BIh2hm2boZiDI/4jeVyOB+k86dB9nnakcQCuhkqNJUV4sjP3U1UI0Yv6pH7Zby/Ly1
         /cud6BJJJqGUfENh8VbEaRD+lG5jdDylD4aKNR9ysMfJv3uS8u0UEza9FMm5E3obQjuS
         7xooV0yJGPglBh7fKaZ//YnOyp5Q9h9PtgHZbC+L8INIihtEUfQAsUSbOD0LM6bR+K7C
         lwnB1H+s+j3ELNcCIblmNp6URrt93Kq/ak7PYI+0hHU17IpeqCVndH3tOmXECg6zmOE9
         w0AwczRhuJumtVFTvJTAPljnXCR/UJMP0OK4bQYy2A2Kt6zG2W5+97NRwsmi4QloXcVR
         LE1g==
X-Gm-Message-State: ABy/qLZqtnNn2aOUnNusqS3ycjSD0HMQkuWcdK6toPEAl1KfZdevp5Yl
        HtQj+L40CpvTC986HAeS3iBP74CfenstspU7DmtOjoBe2w0Izt8xPts=
X-Google-Smtp-Source: APBJJlHJ+Dl327Sv5TZ9sDsLCs9NTAZBNAiK9+5Ic7a+jmmaFv2KBMl67wti2T3K94mEnNXzVVhaBvyjn6BXHDFL9HY=
X-Received: by 2002:a05:6e02:12e1:b0:346:1919:7c9b with SMTP id
 l1-20020a056e0212e100b0034619197c9bmr9189iln.26.1689875576095; Thu, 20 Jul
 2023 10:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com> <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com> <ZLjqVszO4AMx9F7T@chao-email>
In-Reply-To: <ZLjqVszO4AMx9F7T@chao-email>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Jul 2023 10:52:44 -0700
Message-ID: <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
To:     Chao Gao <chao.gao@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 1:04=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Wed, Jul 19, 2023 at 09:04:58PM -0700, Jim Mattson wrote:
> >On Wed, Jul 19, 2023 at 6:58=E2=80=AFPM Chao Gao <chao.gao@intel.com> wr=
ote:
> >>
> >> On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
> >> >On 7/20/2023 2:08 AM, Jim Mattson wrote:
> >> >> Normally, we would restrict guest MSR writes based on guest CPU
> >> >> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is n=
ot
> >> >> the case.
> >>
> >> This issue isn't specific to the two MSRs. Any MSRs that are not
> >> intercepted and with some reserved bits for future extenstions may run
> >> into this issue. Right? IMO, it is a conflict of interests between
> >> disabling MSR write intercept for less VM-exits and host's control ove=
r
> >> the value written to the MSR by guest.
> >
> >I've clearly been falling behind in tracking upstream development. I
> >didn't realize that we passed through any other MSRs that had bits
> >reserved for future extensions (virtual addresses don't count). It
> >looks like we've decided to virtualize IA32_FLUSH_CMD as well, even
> >though Konrad had the good sense to talk me out of it when I first
> >proposed it. Are there others I'm missing?
>
> MSR_IA32_XFD{_ERR}, I think
>
> SDM says:
> Bit i of either MSR can be set to 1 only if CPUID.(EAX=3D0DH,ECX=3Di):ECX=
[2]
> is enumerated as 1 (see Section 13.2). An execution of WRMSR that
> attempts to set an unsupported bit in either MSR causes a
> general-protection fault (#GP)
>
> >
> >Philosophically, there are three principles potentially in conflict
> >here: security, correctness, and performance. Userspace should perhaps
> >be given the option of prioritizing one over the others, but the
> >default precedence should be security first, correctness second, and
> >performance last.
>
> I am not sure about the default precedence. I can name a few other cases
> in which KVM behavior doesn't align with this precedence.
> 1. new instructions w/o control bits in CR0/4

We've come a long way since Popek & Goldberg, but that's an example of
why the x86 architecture still isn't virtualizable. I don't think
anything can be done about that.

> 2. CR3.LAM_U57/U48 can always be set by guests if KVM doesn't trap CR3
>    writes, e.g., when EPT is enabled. This case is identical to the PSFD
>    case you mentioned below.

LAM is another feature I haven't been following. It's a bit sad that
the x86 vendors continue to introduce new features that restrict the
host platforms that can share a migration pool.

> 3. GBPAGES*

Is there an Intel CPU that isn't well past EOL that doesn't support GBPAGES=
?

> *: https://lore.kernel.org/all/20230217231022.816138-3-seanjc@google.com/
>
> >
> >> We may need something like CR0/CR4 masks and read shadows for all MSRs
> >> to address this fundamental issue.
> >
> >Not *all* MSRs, but some, certainly. That is one possible solution,
> >but I get the impression that you're not really serious about this
> >proposal.
>
> I meant we need a generic mechanism applicable to all MSRs. There are up
> to 2K MSRs (MSR-bitmap is 4KB). Then adding a mask and read shadow e.g.,
> 16 Bytes for each MSR needs about 32KB. I don't think it is completely
> unacceptable because, IIRC, IPI virtualization takes up to 64KB. To
> reduce the memory consumption, we can even let CPU consume a list of MSR
> index, mask and read shadow, like VM-entry/exit "MSR-load" count/address.

I assume the quoted IPI virtualization overhead is per-VM. We would
need a read shadow per vCPU.

> >> >>
> >> >> For the first non-zero write to IA32_SPEC_CTRL, we check to see tha=
t
> >> >> the host supports the value written. We don't care whether or not t=
he
> >> >> guest supports the value written (as long as it supports the MSR).
> >> >> After the first non-zero write, we stop intercepting writes to
> >> >> IA32_SPEC_CTRL, so the guest can write any value supported by the
> >> >> hardware. This could be problematic in heterogeneous migration pool=
s.
> >> >> For instance, a VM that starts on a Cascade Lake host may set
> >> >> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
> >> >> CPUID.(EAX=3D07H,ECX=3D02H):EDX.PSFD[bit 0] is clear. Then, if that=
 VM is
> >> >> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
> >> >> IA32_SPEC_CTRL to its current value, because Skylake doesn't suppor=
t
> >> >> PSFD.
> >>
> >> It is a guest fault. Can we modify guest kernel in this case?
> >
> >The guest should not have set the bit. The hypervisor should not have
> >allowed it. Both are at fault.
> >
> >I'm willing to bet that Intel has a CPU validation suite that includes
> >such tests as setting reserved bits in MSRs and ensuring that #GP is
> >raised. Those tests should also work in a VM. If they don't, the
> >hypervisor is broken.
>
> I agree hypervisor is broken in this specific case. I just doubt if it
> is worthwhile to fix this issue i.e., the benefit is significant. I am
> assuing the benefit of fixing the issue is just guests won't be able to
> set reserved bits and attempts to do that cause #GP.

I'm not entirely convinced that setting bits in IA32_SPEC_CTRL is (and
always will be) "safe," from a security perspective. *Clearing* bits
certainly isn't.

> And is it fair to good citizens that won't set reserved bits but will
> suffer performance drop caused by the fix?

Is it fair to other tenants of the host to have their data exfiltrated
by a bad citizen, because KVM didn't control access to the MSR?
> >
> >> >>
> >> >> We disable write intercepts IA32_PRED_CMD as long as the guest
> >> >> supports the MSR. That's fine for now, since only one bit of PRED_C=
MD
> >> >> has been defined. Hence, guest support and host support are
> >> >> equivalent...today. But, are we really comfortable with letting the
> >> >> guest set any IA32_PRED_CMD bit that may be defined in the future?
> >> >>
> >> >> The same question applies to IA32_SPEC_CTRL. Are we comfortable wit=
h
> >> >> letting the guest write to any bit that may be defined in the futur=
e?
> >> >
> >> >My point is we need to fix it, though Chao has different point that s=
ometimes
> >> >performance may be more important[*]
> >> >
> >> >[*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/
> >>
> >> Maybe KVM can provide options to QEMU. e.g., we can define a KVM quirk=
.
> >> Disabling the quirk means always intercept IA32_SPEC_CTRL MSR writes.
> >
> >Alternatively, we can check the host value of IA32_SPEC_CTRL on
> >VM-entry, since we have to read it anyway. If any bits are set that
> >cannot be cleared in VMX non-root operation without compromising
> >security, then writes to IA32_SPEC_CTRL should be intercepted.
> >
> >> >
> >> >> At least the AMD approach with V_SPEC_CTRL prevents the guest from
> >> >> clearing any bits set by the host, but on Intel, it's a total
> >> >> free-for-all. What happens when a new bit is defined that absolutel=
y
> >> >> must be set to 1 all of the time?
> >>
> >> I suppose there is no such bit now. For SPR and future CPUs, "virtuali=
ze
> >> IA32_SPEC_CTRL" VMX feature can lock some bits to 0 or 1 regardless of
> >> the value written by guests.
> >
> >As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] is
> >such a bit. If the host has this bit set and you allow the guest to
> >clear it, then you have compromised host security.
>
> If guest can compromise host security, I definitly agree to intercept
> IA32_SPEC_CTRL MSR.

I believe that when the decision was made to pass through this MSR for
write, the assumption was that the host wouldn't ever use it (hence
the host value would be zero). That assumption has not stood the test
of time.
