Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC65759EE2F
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 23:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiHWV0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 17:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiHWV0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 17:26:39 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4A89824
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 14:26:37 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-11c5ee9bf43so18367393fac.5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 14:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=88XJiOmSnVqt34ABSh9LJkvlPL2wXTdT9a7x84FgDcA=;
        b=ajkrkOb9lVgwoqRtIl5yDF1gQr9nA8i+nVQFmuB/HGS6CNUYkxAQAqFePDK7M7oUJG
         8DxAvm1Jk7hK0Z2tlfw3zE39l+ikoJULVRO6c0JuB4gr53mFI/HOcCcM63guZgl4C2NJ
         rjIHhsvY8y5+72ivZr26eHrAyZ/Lc+E/MU6efJO0d+D9eDhev2E5C8x750KvkIUc2nHS
         5yLA8QU4rgU0esf3qz6Pr7iv9v1HobN4VAIyOpu4BBthxVYfwCwv+PfsnqiH2myy+XHR
         zOQ124DAPj+DOLpphYamwbe4WxoLEH+R3b2C8t67cclrTAn12BRNRgSccxYNIruEdTYP
         cYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=88XJiOmSnVqt34ABSh9LJkvlPL2wXTdT9a7x84FgDcA=;
        b=6vvjOr5KJTlGjMgO3esiOrDejaBFEGVykZPHiSlTB4CZsd6//TQFiW3nVKY813qKWW
         d02Vg+PwhqPOP2GNdBkiEltiDJ+HYXDp7yaxpGmql1wRCrkae7P4QuUS2QXk17qJOjlH
         tDXVwgzs+XORd2qhIgPPlQ+/AIf1RfpCw71hOnEreb6a/4w0lnEe1PbRQF5+YtGDpv4P
         OIPeApn/AndwpEYirhWph+wuvL0oGHWlx32R/UxLkE3u+Re/Q4YNwfiHF/RDzQELKOk1
         kz5bLCAYm+iSM0HT17HzCSHbcpXRwgfkXz/T7KxzGtOsORf21Sx+MryZFgJTbcoj1MeV
         +FGA==
X-Gm-Message-State: ACgBeo09yeH6tRzAgivOqlkXjqpAChbhOCgFvuTblY1q5rWWLIlsItGA
        muf+3PSIjppBiR7iW3RfI3o1vgmMuOamaL3Gy+taxQ==
X-Google-Smtp-Source: AA6agR67bw1dvH8TFlRIswHkLor4hFRO/RnxVuSxSSMkGuDIVg3Gz6z0M+esF8pmvvVJjhiPMu5rt5pxf8JVsmk1Pww=
X-Received: by 2002:a05:6870:3282:b0:11d:10ad:a85d with SMTP id
 q2-20020a056870328200b0011d10ada85dmr2261194oac.181.1661289996780; Tue, 23
 Aug 2022 14:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
In-Reply-To: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Aug 2022 14:26:24 -0700
Message-ID: <CALMp9eSKcwChbc=cgYpdrTCtt49S1uuRdYoe83yph3tXGN6a2Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
To:     Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, hpa@zytor.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Sep 23, 2021 at 6:15 PM Babu Moger <babu.moger@amd.com> wrote:
>
> From: Babu Moger <Babu.Moger@amd.com>
>
> Predictive Store Forwarding: AMD Zen3 processors feature a new
> technology called Predictive Store Forwarding (PSF).
>
> PSF is a hardware-based micro-architectural optimization designed
> to improve the performance of code execution by predicting address
> dependencies between loads and stores.
>
> How PSF works:
>
> It is very common for a CPU to execute a load instruction to an address
> that was recently written by a store. Modern CPUs implement a technique
> known as Store-To-Load-Forwarding (STLF) to improve performance in such
> cases. With STLF, data from the store is forwarded directly to the load
> without having to wait for it to be written to memory. In a typical CPU,
> STLF occurs after the address of both the load and store are calculated
> and determined to match.
>
> PSF expands on this by speculating on the relationship between loads and
> stores without waiting for the address calculation to complete. With PSF,
> the CPU learns over time the relationship between loads and stores. If
> STLF typically occurs between a particular store and load, the CPU will
> remember this.
>
> In typical code, PSF provides a performance benefit by speculating on
> the load result and allowing later instructions to begin execution
> sooner than they otherwise would be able to.
>
> The details of security analysis of AMD predictive store forwarding is
> documented here.
> https://www.amd.com/system/files/documents/security-analysis-predictive-s=
tore-forwarding.pdf
>
> Predictive Store Forwarding controls:
> There are two hardware control bits which influence the PSF feature:
> - MSR 48h bit 2 =E2=80=93 Speculative Store Bypass (SSBD)
> - MSR 48h bit 7 =E2=80=93 Predictive Store Forwarding Disable (PSFD)
>
> The PSF feature is disabled if either of these bits are set.  These bits
> are controllable on a per-thread basis in an SMT system. By default, both
> SSBD and PSFD are 0 meaning that the speculation features are enabled.
>
> While the SSBD bit disables PSF and speculative store bypass, PSFD only
> disables PSF.
>
> PSFD may be desirable for software which is concerned with the
> speculative behavior of PSF but desires a smaller performance impact than
> setting SSBD.
>
> Support for PSFD is indicated in CPUID Fn8000_0008 EBX[28].
> All processors that support PSF will also support PSFD.
>
> Linux kernel does not have the interface to enable/disable PSFD yet. Plan
> here is to expose the PSFD technology to KVM so that the guest kernel can
> make use of it if they wish to.
>
> Signed-off-by: Babu Moger <Babu.Moger@amd.com>
> ---
> NOTE: Per earlier discussions, Linux kernel interface for PSF mitigation
> is not included in this series. This series only exposes the PSFD technol=
ogy
> to KVM guests. Here is the link for earlier discussion.
> https://lore.kernel.org/lkml/20210517220059.6452-1-rsaripal@amd.com/
> https://lore.kernel.org/lkml/20210505190923.276051-1-rsaripal@amd.com/
> https://lore.kernel.org/lkml/20210430131733.192414-1-rsaripal@amd.com/
> https://lore.kernel.org/lkml/20210428160349.158774-1-rsaripal@amd.com/
> https://lore.kernel.org/lkml/20210422171013.50207-1-rsaripal@amd.com/
> https://lore.kernel.org/lkml/20210421090117.22315-1-rsaripal@amd.com/
>
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  arch/x86/kvm/cpuid.c               |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cp=
ufeatures.h
> index d0ce5cfd3ac1..7d6268ede35a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -313,6 +313,7 @@
>  #define X86_FEATURE_AMD_SSBD           (13*32+24) /* "" Speculative Stor=
e Bypass Disable */
>  #define X86_FEATURE_VIRT_SSBD          (13*32+25) /* Virtualized Specula=
tive Store Bypass Disable */
>  #define X86_FEATURE_AMD_SSB_NO         (13*32+26) /* "" Speculative Stor=
e Bypass is fixed in hardware. */
> +#define X86_FEATURE_PSFD               (13*32+28) /* Predictive Store Fo=
rwarding Disable */
>
>  /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word=
 14 */
>  #define X86_FEATURE_DTHERM             (14*32+ 0) /* Digital Thermal Sen=
sor */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fe03bd978761..ba773919f21d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -500,7 +500,7 @@ void kvm_set_cpu_caps(void)
>         kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>                 F(CLZERO) | F(XSAVEERPTR) |
>                 F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F=
(VIRT_SSBD) |
> -               F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
> +               F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F=
(PSFD)
>         );
>
>         /*
>
>

For consistency, should this feature be renamed AMD_PSFD, now that
Intel is enumerating PSFD with CPUID.(EAX=3D7,ECX=3D2):EDX.PSFD[bit 0]?
See https://www.intel.com/content/www/us/en/developer/articles/technical/so=
ftware-security-guidance/technical-documentation/cpuid-enumeration-and-arch=
itectural-msrs.html.

And, Paolo, why are we carrying X86_FEATURE_PSFD as a private #define
in KVM rather than putting it where it belongs in cpufeatures.h?
