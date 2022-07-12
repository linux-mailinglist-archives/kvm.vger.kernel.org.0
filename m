Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021C657203B
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiGLQE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiGLQEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:04:21 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE01D2314D
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:04:19 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d12so14694061lfq.12
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 09:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c0RcQSLjeYCnLvxH8el7ACbuvLKqs4ymAPhMSssf3fo=;
        b=rgy8GpGjigNewPkDfawGIyJhs5SthypU/zUHIYssEnhqMMiqNAKc4ezJ19mpUkfSMy
         nHlnPMccqvaAAhX/ySaXKSzNEJ+RUL0TBhSHaW0HqHGvmgX2wxKuTd+jA0VHIQPZ9QFF
         a6LEAvMbeWy1+vmRd8d6u+JJ7f13B0rTgQTdohwT7+APFsOdcZJnmvacai86xywgvwxZ
         kEZYabnYpVeCuAKxSwQRmTLVQyoTaFQAZoagdzVEMYGEcN4G14TusnppOWvHU3N4UMpc
         t6xNmt5QTEm/TElgI+kc11twOzYFn1L/5P2tE2Iy6Q0EvlpQEc4560MbpDvwkPfROLHC
         yEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c0RcQSLjeYCnLvxH8el7ACbuvLKqs4ymAPhMSssf3fo=;
        b=rgqwulUuvBVgdCNQEf6D2OrqdGet9BXdHx9l9l4vJGlq1uOT6VwWV0dVIflee2vlh+
         6JK9SSlLUuSS2Wd3QO3ZH9WXKHa4z6oTfnKK0OAEm/7X3GA4pp4mUtYuPvuFJjqz5+Gh
         7HVYnWWVXzyu8EnQFAfThWuOri2D7hSV/qaQuCZrYS4pWRbwlLZANA4xBYTW2Kxq2wo4
         sVEuDRZWz19fknanpuypbItEFpfGMza6oeYPKX+4QQbQTp+nbfdY34Ei/AQaPCoH8/bP
         wPrVDbBTjCvE1iFDsR4zD8n3FvHJlaiVuixZSV5pPWe6CCAkjMK/3H5UWTfgnwrS1ADv
         jFAw==
X-Gm-Message-State: AJIora+fiVKP/770De5d1UAkyTboo2KBaAVPWO2US+HxEv8535CKOE4X
        uH4TXzvwAULe6fovbZ75kjM2tbChHkHZWlulyhiakw==
X-Google-Smtp-Source: AGRyM1ve5bKkRgY91JODr6G0KYNj14IUXmUe2XTmEOY9UMxbgvLVrQb6DVioXtQ4vfZSOB7V9pobKh55jgw4lPONCfA=
X-Received: by 2002:a05:6512:32c5:b0:481:1822:c41f with SMTP id
 f5-20020a05651232c500b004811822c41fmr16158485lfg.373.1657641857910; Tue, 12
 Jul 2022 09:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
 <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com> <SN6PR12MB2767D8C552388D438D9F88268E869@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767D8C552388D438D9F88268E869@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 12 Jul 2022 10:04:05 -0600
Message-ID: <CAMkAt6pO3knGsvctewCC1z0K0c5jfgpTzGhB3Ujvc-xCYcEojQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
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

On Tue, Jul 12, 2022 at 9:22 AM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> >> >Given the guest uses the SNP NAE AP boot protocol we were expecting t=
hat there would be some option to add vCPUs to the VM but mark them as "pen=
ding AP boot creation protocol" state. This would allow the LaunchDigest of=
 a VM doesn't change >just because its vCPU count changes. Would it be poss=
ible to add a new add an argument to KVM_SNP_LAUNCH_FINISH to tell it which=
 vCPUs to LAUNCH_UPDATE VMSA pages for or similarly a new argument for KVM_=
CREATE_VCPU?
> >>
> >> But don't we want/need to measure all vCPUs using LAUNCH_UPDATE_VMSA b=
efore we issue SNP_LAUNCH_FINISH command ?
> >>
> >> If we are going to add vCPUs and mark them as "pending AP boot creatio=
n" state then how are we going to do LAUNCH_UPDATE_VMSAs for them after SNP=
_LAUNCH_FINISH ?
>
> >If I understand correctly we don't need or even want the APs to be LAUNC=
H_UPDATE_VMSA'd. LAUNCH_UPDATEing all the VMSAs causes VMs with different n=
umbers of vCPUs to have different launch digests. Its my understanding the =
SNP AP >Creation protocol was to solve this so that VMs with different vcpu=
 counts have the same launch digest.
>
> >Looking at patch "[Part2,v6,44/49] KVM: SVM: Support SEV-SNP AP Creation=
 NAE event" and section "4.1.9 SNP AP Creation" of the GHCB spec. There is =
no need to mark the LAUNCH_UPDATE the AP's VMSA or mark the vCPUs runnable.=
 Instead we >can do that only for the BSP. Then in the guest UEFI the BSP c=
an: create new VMSAs from guest pages, RMPADJUST them into the RMP state VM=
SA, then use the SNP AP Creation NAE to get the hypervisor to mark them run=
nable. I believe this is all >setup in the UEFI patch:
> >https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.=
mail-archive.com%2Fdevel%40edk2.groups.io%2Fmsg38460.html&amp;data=3D05%7C0=
1%7CAshish.Kalra%40amd.com%7Ca40178ac6f284a9e33aa08da64152baa%>7C3dd8961fe4=
884e608e11a82d994e183d%7C0%7C0%7C637932339382401133%7CUnknown%7CTWFpbGZsb3d=
8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%=
7C%7C%7C&amp;sdata=3DZaiHHo9S24f9BB6E%>2FjexOt5TdKJQXxQDJI5QoYdDDHc%3D&amp;=
reserved=3D0.
>
> Yes, I discussed the same with Tom, and this will be supported going forw=
ard, only the BSP will need to go through the LAUNCH_UPDATE_VMSA and at run=
time the guest can dynamically create more APs using the SNP AP Creation NA=
E event.
>
> Now, coming back to the original question, why do we need a separate vCPU=
 count argument for SNP_LAUNCH_FINISH, won't the statically created vCPUs i=
n kvm->created_vcpus/online_vcpus be sufficient for that, any dynamically c=
reated
> vCPU's won't be part of the initial measurement or LaunchDigest of the VM=
, right ?

Are you suggesting that QEMU will KVM_CREATE_VCPU the BSP, then
LAUNCH_FINISH, then KVM_CREATE_VCPU all the APs to their VMSAs were
not LAUNCH_UPDATED? If so, it seems annoying to have to create vCPUs
at different times to get their VMSAs into different states. That's
why I was suggesting some other mechanism so we can continue to
KVM_CREATE_VCPU all the vCPUs at the same time.

>
> Thanks,
> Ashish
