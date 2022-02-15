Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465074B6227
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 05:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiBOEfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 23:35:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiBOEfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 23:35:21 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1FFA9E0F
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 20:35:11 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so21770329ooq.10
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 20:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qYSqY3YS8isYaXKC9g95HmfKybyran2nMh3SkYVfaG8=;
        b=GkVTRi/p6cI7KkFkD61wJvkUtDUbK3g/g6ETQ0OnRIvgyOcis9+Z4HylbxD6phMLUw
         9PsrtiE70a1OmLmqSR+bSI38ujdE/svS2carK+5dHfuNR2zcmt9EHpOEQcbbHvm2D4UN
         SIHFD2hDVHkBVxvVeyqOCMN6nI5Cmk/NG82JTZmH2DtHe9FPC1/nKMIsXrW6QSewKq9a
         oep40hCiBo2MyX34N0hQGfOEHhyhNpDcZ24545qULLDFlyY5IwQU1t83zontgHr6b5Af
         ctDdqhBXfO8ZJXFiT2FnxgPz2498GJMGsDE2J7PmvJl00tm5l4s2GES1t383LjoACUN+
         Y3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qYSqY3YS8isYaXKC9g95HmfKybyran2nMh3SkYVfaG8=;
        b=sqJ8rDTQiqDX+bEWHQYs77J8vL9LpRY8Lm4hEDrbJctQDTPfZ3A6HPMYKnsb1lp08g
         ffXcsyJGDJ9DhvoBGDjALFns/fzPoNWEPS1tUIaAsvxEQ042VW6bRlYj2MSkaoWvov5M
         Ga28bmQKH/76dEoX3/utpU5z+XBopOa1qSxCvrnWHQ/E9lQl9sVC30QFnOyBrChDWdpc
         okO8f6QVV3H5w7yvhiC12VMO+oyXpUKyqOP1pOm7C1MQleP2DTCwBM+V7Q9tA5ctkSES
         NjVLlKP2njiYw2tOt+M7o+hcVj/zeLPyD/V22gX0ZrY5qOvrE04Y46lb7OLXhBo/wuFJ
         uZ/Q==
X-Gm-Message-State: AOAM53076WDB3gER2TSk4zskUTyppTX+FabMheRbTslliVIRTXe38/nu
        AxiNvGu8RL2jIrRSGnwvgwWL/wh9O0si0R878yA+JA==
X-Google-Smtp-Source: ABdhPJzgnFuW2tsEmguImvLtwMtIdI4189ZwkUbbj8QJ1TipA69+XG5fgVeAc0GF1IZrYshMjoH7+ucPZ+ub84NuWxM=
X-Received: by 2002:a05:6870:3742:b0:d1:4cc7:67b5 with SMTP id
 a2-20020a056870374200b000d14cc767b5mr789532oak.153.1644899710922; Mon, 14 Feb
 2022 20:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20220209164254.8664-1-varad.gautam@suse.com> <CAA03e5F0yDkaKhL42LKreLGyiy5gwZvtS4YR9q-ZFpqt2uxqnQ@mail.gmail.com>
 <f32b32b3-2a47-209c-ea25-31d1af61a57f@suse.com>
In-Reply-To: <f32b32b3-2a47-209c-ea25-31d1af61a57f@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 14 Feb 2022 20:34:59 -0800
Message-ID: <CAA03e5GOO_RotHtNpVDYWLtm-u1zuxGxb3bVnWXnqpVEAkqENA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86/efi: Allow specifying AMD
 SEV/SEV-ES guest launch policy to run
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 5:34 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Hi Marc,
>
> On 2/13/22 4:48 AM, Marc Orr wrote:
> > On Wed, Feb 9, 2022 at 8:43 AM Varad Gautam <varad.gautam@suse.com> wrote:
> >>
> >> Make x86/efi/run check for AMDSEV envvar and set corresponding
> >> SEV/SEV-ES parameters on the qemu cmdline, to make it convenient
> >> to launch SEV/SEV-ES tests.
> >>
> >> Since the C-bit position depends on the runtime host, fetch it
> >> via cpuid before guest launch.
> >>
> >> AMDSEV can be set to `sev` or `sev-es`.
> >>
> >> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> >> ---
> >>  x86/efi/README.md |  5 +++++
> >>  x86/efi/run       | 38 ++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 43 insertions(+)
> >>
> >> diff --git a/x86/efi/README.md b/x86/efi/README.md
> >> index a39f509..1222b30 100644
> >> --- a/x86/efi/README.md
> >> +++ b/x86/efi/README.md
> >> @@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
> >>
> >>      EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
> >>
> >> +To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
> >> +`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
> >> +
> >> +    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
> >> +
> >>  ## Code structure
> >>
> >>  ### Code from GNU-EFI
> >> diff --git a/x86/efi/run b/x86/efi/run
> >> index ac368a5..9bf0dc8 100755
> >> --- a/x86/efi/run
> >> +++ b/x86/efi/run
> >> @@ -43,6 +43,43 @@ fi
> >>  mkdir -p "$EFI_CASE_DIR"
> >>  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
> >>
> >> +amdsev_opts=
> >> +if [ -n "$AMDSEV" ]; then
> >> +       # Guest policy bits, used to form QEMU command line.
> >> +       readonly AMDSEV_POLICY_NODBG=$(( 1 << 0 ))
> >> +       readonly AMDSEV_POLICY_ES=$(( 1 << 2 ))
> >> +
> >> +       gcc -x c -o getcbitpos - <<EOF
> >> +       /* CPUID Fn8000_001F_EBX bits 5:0 */
> >> +       int get_cbit_pos(void)
> >> +       {
> >> +               int ebx;
> >> +               __asm__("mov \$0x8000001f , %eax\n\t");
> >> +               __asm__("cpuid\n\t");
> >> +               __asm__("mov %%ebx, %0\n\t":"=r" (ebx));
> >> +               return (ebx & 0x3f);
> >> +       }
> >> +       int main(void)
> >> +       {
> >> +               return get_cbit_pos();
> >> +       }
> >> +EOF
> >
> > We could do this in bash directly, using the cpuid driver:
> > https://man7.org/linux/man-pages/man4/cpuid.4.html
> >
> > I'm not a Linux shell wizard, but I found an example of a script using
> > this module here:
> > https://git.irsamc.ups-tlse.fr/dsanchez/spectre-meltdown-checker/src/branch/master/spectre-meltdown-checker.sh
> >
> > After studying that script (for like an hour, lol), I was able to
> > extract the cbit position. Below, I explain how to do this with the
> > cpuid driver. My only complaint about using the cpuid driver is that
> > it's awfully hard to follow. So I'd be OK to stick with the C code
> > that you've got. Though it may be better to break out the C code into
> > an actual .c file, rather than embed it in the script like this, and
> > magically build it and clean it up, which seems pretty hacky. I know I
> > was doing something similar with a dummy.c file embedded in the run
> > script file to get the run_tests.sh script to work, and Paolo ended up
> > moving that into an explicit build target in the x86/ directory.
> >
> > Getting the c bit position in pure bash, using the cpuid driver.
> > $ ebx=$(dd if=/dev/cpu/0/cpuid bs=16 skip=134217729 count=16
> > 2>/dev/null | od -j 240 -An -t u4 | awk '{print $'"2"'}')
> > $ echo $(( $ebx&0x3f ))
> >
>
> Tom also suggested magic using the cpuid module earlier [1], but I would
> like to avoid a dependency on CONFIG_X86_CPUID here. Besides the readability
> of the C snippet, I believe gcc (ie userspace) is easier to install on a set
> of test hosts already prepared with CONFIG_X86_CPUID=n, than to
> enable/deploy/install the cpuid kmod there, which becomes important when
> testing a large number of hosts at once.
>
> Unlike x86/dummy.c, the C code doesn't run in a guest context, which is why
> I'm hesitant to place it as a build target under x86/. I "hid" it within
> the run script since it's only needed when constructing the qemu cmdline,
> and packaging a 'getcbitpos' binary didn't make much sense. Thoughts?
>
> [1] https://lore.kernel.org/kvm/1a79ea5b-71dd-2782-feba-0d733f8c2fbf@amd.com/
>
> Thanks,
> Varad

Ah. Got it now. I had forgotten about Tom's reply. And you make good
points about the cpuid binary this patch is building being unique from
other binaries in that it does not run under the guest...

Also, I agree with minimizing dependencies on the machine under test.

If we go with the current approach, is there any reason not to just
split out the C code into a standalone .c file? Also, any reason not
to build it when we build the rest of the x86 binaries? I agree it
should not reside in the x86/ directory, since it is not a guest-side
program as you mentioned. But I'm wondering if we can compile it in
advance of running the test, rather than while running the test.
