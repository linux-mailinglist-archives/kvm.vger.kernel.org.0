Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D2156BDF3
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbiGHPym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238813AbiGHPyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:54:40 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74F270E5F
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:54:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d12so13702960lfq.12
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/os5t3S4cPsz3I/S9Mj4qyigjvCHgQQtkEVeDgJ05RM=;
        b=PsBVmJ6R6GowUlEMeEe8ZRY8jb52v2WfXzscfT5jLoCOQsbZ36cbawSyHAtGiHnafj
         HaFtIhvPwrjTsy3gBfiNpXk6CLJYS++w+8CYIEoISvqmxuuVetqxorhjsydgFa23mZKQ
         5/cnrNL72sWZGEGfjILngANqq9MIg3cWbdiTWVR/h5IQrycCXuvQ4YGYcrr2ICC+JjoL
         DyDSxQSfjivojcSr1c9UT0BUbasRhFYlNTGM0VY5acbNpT07M1F5BIlW4gQlVvfNsmya
         l77+tZgU/wKnuxcPYeZ/vqIStbc7H1V+E0CACaXVs84rluFvh1bSyYJPimKqQ++dB94y
         p0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/os5t3S4cPsz3I/S9Mj4qyigjvCHgQQtkEVeDgJ05RM=;
        b=tO7gnZtEbWlL/QSKUqVwwQ11z7t6FRJgUmc97FEQkd1uSsL2a/880AzFKaoLq1n9GX
         ktPjC6q8C/uLnfHWMtxYyy6XOdrmEmRzQmuis8Za6ZvR1rwHvmLHdGEdYPc+ovhLr4w7
         PvchhinN8uBXsix5U9GgRfYjbQkFFQvdsX4QOxf+Kxy6CGzKqbxqkca1EBp7hEDKXhJd
         pTwk+xTb0iVnoLNnPjl3ENHAskTrxuVw6UBhWty60DmGT1YyM+inAABZjjhILid4WLW6
         U9tc6bNgL0GuasbGMK9NMJTo1+cpD5C685h4ZQChVPK2s89YJZdgnEvjQPgW2EKZMUAu
         qh2Q==
X-Gm-Message-State: AJIora8McN5se6eLTfAas00Oz8MKspNKvTSEBkmHpAWmL/bL21KPecf+
        LtLcU13ewb0r9Hu1+j/S7EAwqztF6X5SokpzZU9HM7Y2miv7GY8V
X-Google-Smtp-Source: AGRyM1vakIVeDaj9C17a1elb+iyUeaYTA/kg2lyv8/76nZi9IF95NVCr4t6HVeEbFti0eBxcXliDfOCnMI7CCXuWRVI=
X-Received: by 2002:a05:6512:a8c:b0:484:73f8:704d with SMTP id
 m12-20020a0565120a8c00b0048473f8704dmr3076083lfu.193.1657295675981; Fri, 08
 Jul 2022 08:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
 <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6pdoMY1yV+kcUzOftD2WKS8sQy-R2b=Aty8wS-gGp-21Q@mail.gmail.com> <SN6PR12MB276787F711EE80D3546431848E839@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB276787F711EE80D3546431848E839@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 8 Jul 2022 09:54:24 -0600
Message-ID: <CAMkAt6oea8CfjupTRBS1CQQogaixNakF1+KjSZ-+bhRBRj3GvQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host map
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 2:31 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> >> >There is a perf cost to this suggestion but it might make accessing
> >> >the GHCB safer for KVM. Have you thought about just using
> >> >kvm_read_guest() or copy_from_user() to fully copy out the GCHB into =
a KVM owned buffer, then copying it back before the VMRUN. That way the KVM=
 doesn't need to guard against page_state_changes on the GHCBs, that could =
be a perf ?>>improvement in a follow up.
> >>
> >> Along with the performance costs you mentioned, the main concern here
> >> will be the GHCB write-back path (copying it back) before VMRUN: this
> >> will again hit the issue we have currently with
> >> kvm_write_guest() / copy_to_user(), when we use it to sync the scratch
> >> buffer back to GHCB. This can fail if guest RAM is mapped using huge-p=
age(s) and RMP is 4K. Please refer to the patch/fix mentioned below, kvm_wr=
ite_guest() potentially can fail before VMRUN in case of SNP :
> >>
> >> commit 94ed878c2669532ebae8eb9b4503f19aa33cd7aa
> >> Author: Ashish Kalra <ashish.kalra@amd.com>
> >> Date:   Mon Jun 6 22:28:01 2022 +0000
> >>
> >>     KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb
> >>
> >>    Using kvm_write_guest() to sync the GHCB scratch buffer can fail
> >>     due to host mapping being 2M, but RMP being 4K. The page fault han=
dling
> >>     in do_user_addr_fault() fails to split the 2M page to handle RMP f=
ault due
> >>     to it being called here in a non-preemptible context. Instead use
> >>     the already kernel mapped ghcb to sync the scratch buffer when the
> >>     scratch buffer is contained within the GHCB.
>
> >Ah I didn't see that issue thanks for the pointer.
>
> >The patch description says "When SEV-SNP is enabled the mapped GPA needs=
 to be protected against a page state change." since if the guest were to c=
onvert the GHCB page to private when the host is using the GHCB the host co=
uld get an RMP violation right?
>
> Right.
>
> >That RMP violation would cause the host to crash unless we use some copy=
_to_user() type protections.
>
> As such copy_to_user() will only swallow the RMP violation and return fai=
lure, so the host can retry the write.
>
> > I don't see anything mechanism for this patch to add the page state cha=
nge protection discussed. Can't another vCPU still convert the GHCB to priv=
ate?
>
> We do have the protections for GHCB getting mapped to private specificall=
y, there are new post_{map|unmap}_gfn functions added to verify if it is sa=
fe to map
> GHCB pages. There is a PSC spinlock added which protects again page state=
 change for these mapped pages.
> Below is the reference to this patch:
> https://lore.kernel.org/lkml/cover.1655761627.git.ashish.kalra@amd.com/T/=
#mafcaac7296eb9a92c0ea58730dbd3ca47a8e0756
>
> But do note that there is protection only for GHCB pages and there is a n=
eed to add generic post_{map,unmap}_gfn() ops that can be used to verify
> that it's safe to map a given guest page in the hypervisor. This is a TOD=
O right now and probably this is something which UPM can address more clean=
ly.

Thank you Ashish. I had missed that.

Can you help me understand why its OK to use kvm_write_guest() for the
|snp_certs_data| inside of snp_handle_ext_guest_request() in patch
42/49? I would have thought we'd have the same 2M vs 4K mapping
issues.

>
> >I was wrong about the importance of this though seanjc@ walked me throug=
h how UPM will solve this issue so no worries about this until the series i=
s rebased on to UPM.
>
> Thanks,
> Ashish
