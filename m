Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA445A506C
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 17:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiH2PqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 11:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiH2PqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 11:46:13 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619897FFAA
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:46:11 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id m2so7953696lfp.11
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3meqtXbTYxJmns+VU1IFRu37s6xoAgQHZSDijK61tz4=;
        b=edhns5+ibpza5cnoclqkhsHKueRr/cmtpIZAuHlzyb0bTfEPRNDvcq1R0JoAuRP+Ih
         UHSq2t/76VsG03kG/rB5gmkylLs+o/oK2XvRfDxCy95HXznVf66+oXxb1i7Qg7xuAKnu
         pNlTHuHu3A5RUH/S9xbLGuEEIONxCptjG63O0lvw00zRpEBznDf53OlNDuqcsQIW4U78
         oacpH1SB8cS/WY+eYRYzcNqWiF4a30TfvRGzbJHt+sZ+8lPZnlPbansa/C0fsCBtgRna
         LroemF3STxBRf0lJZ3QjAOSbhDY6kDYhXCxjGTpP8mhqW7bbnBkcufA7cADzQSMRwQHI
         gSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3meqtXbTYxJmns+VU1IFRu37s6xoAgQHZSDijK61tz4=;
        b=Npu4BDrLLtv4Ja/P1thy2gI4LoW6hMyjfD/jP5NCbnkGWO36H2gkxisvliAtCTWXBz
         lKm1nd9s3O+esHOipxj7YHWfocz1d1sKK+5HPFObfSLTaiRhbGPmbHN7aEdGirrhTN8+
         Yh/L2Ag+hvTQa6GbyB9X+38qg/RIMSycYwo2R3XluqppSK4ks+0qtZ/jlf0kRZ6/v+/A
         PCtHlR6jtRYbyiMYydPIG5ipINKXkUDSXx6nLXXirvZBYa13CfxWHDazNSRd3i8CNpXv
         ZBNcCC92sEnkwyS8rSK/OmSjgu1iVcHTsXL04b/AXoKuzWw2Kabpe1iL8eJLPH5jXI2c
         oxZA==
X-Gm-Message-State: ACgBeo1Vq/MNDJobcO7wELF+mR4shN4azqnBerDvBgeE+Ep2Mytt3JtX
        8OUVdkKqrlnblSaYfr4GV7smHy2m10G/X/pYb+CPAA==
X-Google-Smtp-Source: AA6agR77LJ+xzS/LIsRxYhg7g023PHZpA7hzN92OnEVBaA0dIpVIYD9T30FIiBpgS9sf7+CTU8GDiTPD7K+NBjJrMTI=
X-Received: by 2002:a05:6512:2525:b0:494:7562:dd54 with SMTP id
 be37-20020a056512252500b004947562dd54mr539627lfb.70.1661787969495; Mon, 29
 Aug 2022 08:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com> <20220810152033.946942-9-pgonda@google.com>
 <Yv2I48GqFpc9PHIy@google.com>
In-Reply-To: <Yv2I48GqFpc9PHIy@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 29 Aug 2022 09:45:57 -0600
Message-ID: <CAMkAt6oGtMukLM223x5Lj3A1DpQ=4ZxZ8U8L72=eKuPcjZKSbQ@mail.gmail.com>
Subject: Re: [V3 08/11] KVM: selftests: add library for creating/interacting
 with SEV guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Vishal Annapurve <vannapurve@google.com>
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

On Wed, Aug 17, 2022 at 6:33 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 10, 2022, Peter Gonda wrote:
> > +enum {
> > +       SEV_GSTATE_UNINIT = 0,
> > +       SEV_GSTATE_LUPDATE,
> > +       SEV_GSTATE_LSECRET,
> > +       SEV_GSTATE_RUNNING,
> > +};
> > +
>
> Name the enum, e.g. enum sev_guest_state?

Done

>
> And s/GSTATE/GUEST?  Ugh, AMD's documentation uses GSTATE.
>
> But looking at the docs, I only see GSTATE_LAUNCH?  Or does SEV have different
> status codes than -ES and/or -SNP?

SEV and SEV-ES have the same states, SNP has a different set.

See "Table 43. GSTATE Finite State Machine":
https://www.amd.com/system/files/TechDocs/55766_SEV-KM_API_Specification.pdf

>
> > +struct kvm_vm *sev_get_vm(struct sev_vm *sev)
> > +{
> > +     return sev->vm;
>
> Why bother with a wrapper?
>
> > +}
> > +
> > +uint8_t sev_get_enc_bit(struct sev_vm *sev)
> > +{
>
> Same here, IMO it just obfuscates code with no real benefit.  ANd it's inconsistent,
> e.g. why have a wrapper for enc_bit but not sev->fd?
>

Removed.

> > +     return sev->enc_bit;
> > +}
> > +
> > +void sev_ioctl(int sev_fd, int cmd, void *data)
> > +{
> > +     int ret;
> > +     struct sev_issue_cmd arg;
> > +
> > +     arg.cmd = cmd;
> > +     arg.data = (unsigned long)data;
> > +     ret = ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
> > +     TEST_ASSERT(ret == 0,
> > +                 "SEV ioctl %d failed, error: %d, fw_error: %d",
> > +                 cmd, ret, arg.error);
> > +}
> > +
> > +void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data)
> > +{
> > +     struct kvm_sev_cmd arg = {0};
> > +     int ret;
> > +
> > +     arg.id = cmd;
> > +     arg.sev_fd = sev->fd;
> > +     arg.data = (__u64)data;
> > +
> > +     ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
> > +     TEST_ASSERT(ret == 0,
> > +                 "SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
> > +                 cmd, ret, errno, strerror(errno), arg.error);
> > +}
> > +
> > +/* Local helpers. */
> > +
> > +static void
>
> Don't split here, e.g. a grep/search for the function, should also show the return
> type and any attributes, e.g. "static" vs. something else is typically much more
> interesting than the parameters (and parameters is not a fully solvable problem).
>
> > +sev_register_user_region(struct sev_vm *sev, void *hva, uint64_t size)
>
> Align like so:
>
> static void sev_register_user_region(struct sev_vm *sev, void *hva,
>                                      uint64_t size)
>
> or maybe even let it poke out.

Ah never thought about that, sounds good. Done.

>
> > +{
> > +     struct kvm_enc_region range = {0};
> > +     int ret;
> > +
> > +     pr_debug("%s: hva: %p, size: %lu\n", __func__, hva, size);
> > +
> > +     range.addr = (__u64)hva;
> > +     range.size = size;
> > +
> > +     ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> > +     TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n", errno);
> > +}
> > +
> > +static void
> > +sev_encrypt_phy_range(struct sev_vm *sev, vm_paddr_t gpa, uint64_t size)
>
> Same thing here.
>
> > +{
> > +     struct kvm_sev_launch_update_data ksev_update_data = {0};
> > +
> > +     pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
> > +
> > +     ksev_update_data.uaddr = (__u64)addr_gpa2hva(sev->vm, gpa);
> > +     ksev_update_data.len = size;
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
> > +}
> > +
> > +static void sev_encrypt(struct sev_vm *sev)
> > +{
> > +     const struct sparsebit *enc_phy_pages;
> > +     struct kvm_vm *vm = sev->vm;
> > +     sparsebit_idx_t pg = 0;
> > +     vm_paddr_t gpa_start;
> > +     uint64_t memory_size;
> > +
> > +     /* Only memslot 0 supported for now. */
>
> Eww.  Haven't looked at this in depth, but is there a way to avoid hardcoding the
> memslot in this code?

Done.

>
> > +void sev_vm_launch(struct sev_vm *sev)
> > +{
> > +     struct kvm_sev_launch_start ksev_launch_start = {0};
> > +     struct kvm_sev_guest_status ksev_status = {0};
>
> Doesn't " = {};" do the same thing?  And for the status, and any other cases where
> userspace is reading, wouldn't it be better from a test coverage perspective to
> _not_ zero the data?  Hmm, though I suppose false passes are possible in that case...

We want to zero out kvm_sev_launch_start because it has main fields we
explicitly want zero: the dh_* and session_* fields need to be set up
correctly or zeroed. We can add a test for these later if we want, but
it would be mostly testing userspace + the PSP.

We can not zero status I agree.

>
> > +     /* Need to use ucall_shared for synchronization. */
> > +     //ucall_init_ops(sev_get_vm(sev), NULL, &ucall_ops_halt);
>
> Can this be deleted?  If not, what's up?

Whoops, removed.
