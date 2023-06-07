Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130F5726A69
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjFGUI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 16:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjFGUIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 16:08:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752D21BD6
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 13:08:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba81b37d9d2so10880558276.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 13:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686168520; x=1688760520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jgJbQ4s3E0ptV0J61xFQqdeD0UJeIxytYchnod3vyfo=;
        b=GkWNBRV6t1YZMx4xdqZJQJwX7kJ0WBw5UzCt6VQht83tzs9v99hEKa28gsZVLS8Lpc
         rmtNOhdK5FKaqiHM6l92mTz/IjTB+gqmHgR7QUsBQEZiMumo4PhSNY5s+K+O1aqZipjJ
         qipL5YLQNjEEBgbTfkVKiPO8ks5b59YTER+ai+7epmaIEVQFH1FSm/vGPw+FAohfugWb
         k3aBtk9WMfkoUi+eugsbMre6SbpIUJzW1upG/p3vPwZuN3haloXRHYwNNNdVk4p0bKq5
         /5XusrILJ1buGjmFr/lmCCjqDHSGnJvsRGRUSsdwOW1FDwexSFscY125DLQjVSoiC2Uu
         Porg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686168520; x=1688760520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgJbQ4s3E0ptV0J61xFQqdeD0UJeIxytYchnod3vyfo=;
        b=cvtL/4oA6zsMdCQbleFg29qTBT9+BOPXBnK+EDdxsmMkuMLz8mRpTqWTqd7PFTuqkI
         lZxKQHNtkGpMtwKlMCbL3Z0fCpCDe6vBnPB+Cv/sHOtKSjoO0v/ho4U5w/iLCKYlkiNn
         o1jR5CZWTPCgEfyrCwxHTJfgRLnqas2Mh5TE1gKVvVsK2ogpIGSBSIDfVIVWmUNhwcsM
         iGR7vo+ps6XBg0YNOw1TZzxbNgImbj6D1RwBnTdzCUCiVCcbkIedWkxlETu94vLcE0vo
         Za9zkUKoCooxQgi31B8jo5VhBldjemCs1Kir8toBgHpmWZICnir+1kTRqzCPU+NX8D0b
         SRZQ==
X-Gm-Message-State: AC+VfDz9vlHTwUajC+bGTMz1EbspLjnSq+EpWbfdo+rosZyescqb/0Yw
        gxmu87CMpoZ8LKSVfGsO/ovJ7alU2b0=
X-Google-Smtp-Source: ACHHUZ4CWqZ7S6LmS14VmBgENlfpWqKaIe0/ag4iqXmtNl7mS/uCOoepaJdD5hQkkWrltaj+S1OMb1y3lbk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:12cc:b0:ba7:8099:c5f2 with SMTP id
 j12-20020a05690212cc00b00ba78099c5f2mr2419940ybu.8.1686168520674; Wed, 07 Jun
 2023 13:08:40 -0700 (PDT)
Date:   Wed, 7 Jun 2023 13:08:39 -0700
In-Reply-To: <20230607194721.GI2244082@ls.amr.corp.intel.com>
Mime-Version: 1.0
References: <cover.1685887183.git.kai.huang@intel.com> <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com> <20230607185355.GH2244082@ls.amr.corp.intel.com>
 <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com> <20230607194721.GI2244082@ls.amr.corp.intel.com>
Message-ID: <ZIDjx4i2Z/OQgUra@google.com>
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, pbonzini@redhat.com,
        david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Isaku Yamahata wrote:
> On Wed, Jun 07, 2023 at 12:27:33PM -0700,
> Dave Hansen <dave.hansen@intel.com> wrote:
> 
> > On 6/7/23 11:53, Isaku Yamahata wrote:
> > >>> VMX enabling, and KVM is the only user of TDX.  This implementation
> > >>> chooses to make KVM itself responsible for enabling VMX before using
> > >>> TDX and let the rest of the kernel stay blissfully unaware of VMX.
> > >>>
> > >>> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
> > >>> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
> > >>> first.  Architecturally, there is no CPU flag to check whether the CPU
> > >>> is in VMX operation.  Also, if a BIOS were buggy, it could still report
> > >>> valid TDX private KeyIDs when TDX actually couldn't be enabled.
> > >> I'm not sure this is a great justification.  If the BIOS is lying to the
> > >> OS, we _should_ oops.
> > >>
> > >> How else can this happen other than silly kernel bugs.  It's OK to oops
> > >> in the face of silly kernel bugs.
> > > TDX KVM + reboot can hit #UD.  On reboot, VMX is disabled (VMXOFF) via
> > > syscore.shutdown callback.  However, guest TD can be still running to issue
> > > SEAMCALL resulting in #UD.
> > > 
> > > Or we can postpone the change and make the TDX KVM patch series carry a patch
> > > for it.
> > 
> > How does the existing KVM use of VMLAUNCH/VMRESUME avoid that problem?
> 
> extable. From arch/x86/kvm/vmx/vmenter.S
> 
> .Lvmresume:
>         vmresume
>         jmp .Lvmfail
> 
> .Lvmlaunch:
>         vmlaunch
>         jmp .Lvmfail
> 
>         _ASM_EXTABLE(.Lvmresume, .Lfixup)
>         _ASM_EXTABLE(.Lvmlaunch, .Lfixup)

More specifically, KVM eats faults on VMX and SVM instructions that occur after
KVM forcefully disables VMX/SVM.

E.g. with reboot -f, this will be reached without first stopping VMs:

static void kvm_shutdown(void)
{
	/*
	 * Disable hardware virtualization and set kvm_rebooting to indicate
	 * that KVM has asynchronously disabled hardware virtualization, i.e.
	 * that relevant errors and exceptions aren't entirely unexpected.
	 * Some flavors of hardware virtualization need to be disabled before
	 * transferring control to firmware (to perform shutdown/reboot), e.g.
	 * on x86, virtualization can block INIT interrupts, which are used by
	 * firmware to pull APs back under firmware control.  Note, this path
	 * is used for both shutdown and reboot scenarios, i.e. neither name is
	 * 100% comprehensive.
	 */
	pr_info("kvm: exiting hardware virtualization\n");
	kvm_rebooting = true;
	on_each_cpu(hardware_disable_nolock, NULL, 1);
}

which KVM x86 (VMX and SVM) then queries when deciding what to do with a spurious
fault on a VMX/SVM instruction

/*
 * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
 *
 * Hardware virtualization extension instructions may fault if a reboot turns
 * off virtualization while processes are running.  Usually after catching the
 * fault we just panic; during reboot instead the instruction is ignored.
 */
noinstr void kvm_spurious_fault(void)
{
	/* Fault while not rebooting.  We want the trace. */
	BUG_ON(!kvm_rebooting);
}
EXPORT_SYMBOL_GPL(kvm_spurious_fault);
