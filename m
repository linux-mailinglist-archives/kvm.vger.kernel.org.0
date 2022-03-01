Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09D44C9810
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 22:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbiCAV6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 16:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbiCAV6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 16:58:46 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0773AA50
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 13:58:04 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id w3-20020a056830060300b005ad10e3becaso13379217oti.3
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 13:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=osJEiazF+j+70r0nxx8W83ZcWYa5eX3qUrje5oSjKKI=;
        b=eYuUMSWqJSobnkSf8t2+SSBRYOeVXr4r5YcdnuqeuPGLpzL6RKLZ3YWAr01pI7yIrx
         zLXYazw0H2qvNCX/kwJ8I2jiGSVEbdt+KG4urm/G3+J9C5GkUeXueRSivtLEy1tLzqOg
         WCkGQypbdc3SOD7hQzesw8oydJy0gbJPzks+A3Vht76Axtz09Zq4wngQ6nyTlK56nYb8
         LRwRcVQhjS1PvVvqU0p/+c1Y7zwlmrte9t4UCXBfFI62WMTC9Av5B+cQQ0xkUgExbEz3
         T6YglGVe/O9XHvfqY2L+T2diQe7+zEV6Oz6PExl9VLE/AEhRg/ZrrqaMeT69aSoHmeJn
         ASKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osJEiazF+j+70r0nxx8W83ZcWYa5eX3qUrje5oSjKKI=;
        b=2YRz1whDUwMH2SWSx6M6hqEFHJhmIBX3iTyNPT86gKD0RoDaxnXelEpi1N8FwUKEKS
         XyailwuSmfJsv+ZvGihD41oHNmb9jiSXG6sm3cFSvM67oBQehLJzNE9p8wtgZpzj0C3k
         zp94I78Xvri1jtncYwBL16/UbHkivhZaOXI2oYd5kTBWvLkGFwjM22lzARMCNDL5azqz
         JFY2y2Uj9xroTp8iz6DeMnkYA94vBrz0CxoB3TjaMKmutaty1PYOvYrMKGnFIsW3faBN
         ADrWyjXVSPtQzNJYGIPXC9vAeLxmJLH1JUidhnhLp2sp+ZSRKO3E7KlaVQkpKUq/Mp8z
         TdhQ==
X-Gm-Message-State: AOAM530yGlfXnSMx+RKd/HvGXfBvbQVgUO+CRc1w+j4d5tcIOCzYLoUx
        8/PhyH3GyR60ioIBy4jzdOvY9wWIA/Z+EhU1euZOMw==
X-Google-Smtp-Source: ABdhPJzJDTsXI/+W86nzvWNFovaIXk/hYv4kJB2ZEJHmmzMjP2ZeCsheXLIfpUvEoXoM1lJT7gLwKZjJAMGOGZghu/E=
X-Received: by 2002:a9d:8b5:0:b0:5a4:9db6:92b4 with SMTP id
 50-20020a9d08b5000000b005a49db692b4mr13546379otf.14.1646171883328; Tue, 01
 Mar 2022 13:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com> <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
 <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com> <bcc83b3d-31fe-949a-6bbf-4615bb982f0c@intel.com>
 <CALMp9eT1NRudtVqPuHU8Y8LpFYWZsAB_MnE2BAbg5NY0jR823w@mail.gmail.com>
 <CALMp9eS6cBDuax8O=woSdkNH2e2Y2EodE-7EfUTFfzBvCWCmcg@mail.gmail.com>
 <71736b9d-9ed4-ea02-e702-74cae0340d66@intel.com> <CALMp9eRwKHa0zdUFtSEBVCwV=MHJ-FmvW1uERxCt+_+Zz4z8fg@mail.gmail.com>
 <4b2ddc09-f68d-1cc3-3d10-f7651d811fc3@intel.com> <CALMp9eQj4Xr9VAdHw4BfPEskQYptEYYHRrpmFfVU1TCQJmHwug@mail.gmail.com>
 <1cca344e-1c2d-8ebf-87ae-d9298a73306a@intel.com> <CALMp9eR_gPSAkSHtgOjAqJDEXF-=8aaoV0nXP3GmZ_J9sTBJFg@mail.gmail.com>
 <91859fc0-82e0-cb74-e519-68f08c9c796d@intel.com>
In-Reply-To: <91859fc0-82e0-cb74-e519-68f08c9c796d@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Mar 2022 13:57:52 -0800
Message-ID: <CALMp9eSJgGJxSjej85yYvTav-n=KHNEPo4m2hEqsET+bHrXLew@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 9:30 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 3/1/2022 12:32 PM, Jim Mattson wrote:
> > On Mon, Feb 28, 2022 at 5:41 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>
> >> On 2/28/2022 10:30 PM, Jim Mattson wrote:
> >>> On Sun, Feb 27, 2022 at 11:10 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>>
> >>>> On 2/26/2022 10:24 PM, Jim Mattson wrote:
> >>>>> On Fri, Feb 25, 2022 at 10:24 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>>>>
> >>>>>> On 2/26/2022 12:53 PM, Jim Mattson wrote:
> >>>>>>> On Fri, Feb 25, 2022 at 8:25 PM Jim Mattson <jmattson@google.com> wrote:
> >>>>>>>>
> >>>>>>>> On Fri, Feb 25, 2022 at 8:07 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>>>>>>>
> >>>>>>>>> On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
> >>>>>>>>>> On 2/25/22 16:12, Xiaoyao Li wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I don't like the idea of making things up without notifying userspace
> >>>>>>>>>>>>> that this is fictional. How is my customer running nested VMs supposed
> >>>>>>>>>>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
> >>>>>>>>>>>>> notify window was exceeded? If this information isn't reported to
> >>>>>>>>>>>>> userspace, I have no way of getting the information to the customer.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Then, maybe a dedicated software define VM exit for it instead of
> >>>>>>>>>>>> reusing triple fault?
> >>>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> Second thought, we can even just return Notify VM exit to L1 to tell
> >>>>>>>>>>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed
> >>>>>>>>>>> to L1.
> >>>>>>>>>>
> >>>>>>>>>> That might cause NULL pointer dereferences or other nasty occurrences.
> >>>>>>>>>
> >>>>>>>>> IMO, a well written VMM (in L1) should handle it correctly.
> >>>>>>>>>
> >>>>>>>>> L0 KVM reports no Notify VM Exit support to L1, so L1 runs without
> >>>>>>>>> setting Notify VM exit. If a L2 causes notify_vm_exit with
> >>>>>>>>> invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no
> >>>>>>>>> support of Notify VM Exit from VMX MSR capability. Following L1 handler
> >>>>>>>>> is possible:
> >>>>>>>>>
> >>>>>>>>> a)      if (notify_vm_exit available & notify_vm_exit enabled) {
> >>>>>>>>>                     handle in b)
> >>>>>>>>>             } else {
> >>>>>>>>>                     report unexpected vm exit reason to userspace;
> >>>>>>>>>             }
> >>>>>>>>>
> >>>>>>>>> b)      similar handler like we implement in KVM:
> >>>>>>>>>             if (!vm_context_invalid)
> >>>>>>>>>                     re-enter guest;
> >>>>>>>>>             else
> >>>>>>>>>                     report to userspace;
> >>>>>>>>>
> >>>>>>>>> c)      no Notify VM Exit related code (e.g. old KVM), it's treated as
> >>>>>>>>> unsupported exit reason
> >>>>>>>>>
> >>>>>>>>> As long as it belongs to any case above, I think L1 can handle it
> >>>>>>>>> correctly. Any nasty occurrence should be caused by incorrect handler in
> >>>>>>>>> L1 VMM, in my opinion.
> >>>>>>>>
> >>>>>>>> Please test some common hypervisors (e.g. ESXi and Hyper-V).
> >>>>>>>
> >>>>>>> I took a look at KVM in Linux v4.9 (one of our more popular guests),
> >>>>>>> and it will not handle this case well:
> >>>>>>>
> >>>>>>>             if (exit_reason < kvm_vmx_max_exit_handlers
> >>>>>>>                 && kvm_vmx_exit_handlers[exit_reason])
> >>>>>>>                     return kvm_vmx_exit_handlers[exit_reason](vcpu);
> >>>>>>>             else {
> >>>>>>>                     WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
> >>>>>>>                     kvm_queue_exception(vcpu, UD_VECTOR);
> >>>>>>>                     return 1;
> >>>>>>>             }
> >>>>>>>
> >>>>>>> At least there's an L1 kernel log message for the first unexpected
> >>>>>>> NOTIFY VM-exit, but after that, there is silence. Just a completely
> >>>>>>> inexplicable #UD in L2, assuming that L2 is resumable at this point.
> >>>>>>
> >>>>>> At least there is a message to tell L1 a notify VM exit is triggered in
> >>>>>> L2. Yes, the inexplicable #UD won't be hit unless L2 triggers Notify VM
> >>>>>> exit with invalid_context, which is malicious to L0 and L1.
> >>>>>
> >>>>> There is only an L1 kernel log message *the first time*. That's not
> >>>>> good enough. And this is just one of the myriad of possible L1
> >>>>> hypervisors.
> >>>>>
> >>>>>> If we use triple_fault (i.e., shutdown), then no info to tell L1 that
> >>>>>> it's caused by Notify VM exit with invalid context. Triple fault needs
> >>>>>> to be extended and L1 kernel needs to be enlightened. It doesn't help
> >>>>>> old guest kernel.
> >>>>>>
> >>>>>> If we use Machine Check, it's somewhat same inexplicable to L2 unless
> >>>>>> it's enlightened. But it doesn't help old guest kernel.
> >>>>>>
> >>>>>> Anyway, for Notify VM exit with invalid context from L2, I don't see a
> >>>>>> good solution to tell L1 VMM it's a "Notify VM exit with invalid context
> >>>>>> from L2" and keep all kinds of L1 VMM happy, especially for those with
> >>>>>> old kernel versions.
> >>>>>
> >>>>> I agree that there is no way to make every conceivable L1 happy.
> >>>>> That's why the information needs to be surfaced to the L0 userspace. I
> >>>>> contend that any time L0 kvm violates the architectural specification
> >>>>> in its emulation of L1 or L2, the L0 userspace *must* be informed.
> >>>>
> >>>> We can make the design to exit to userspace on notify vm exit
> >>>> unconditionally with exit_qualification passed, then userspace can take
> >>>> the same action like what this patch does in KVM that
> >>>>
> >>>>     - re-enter guest when context_invalid is false;
> >>>>     - stop running the guest if context_invalid is true; (userspace can
> >>>> definitely re-enter the guest in this case, but it needs to take the
> >>>> fall on this)
> >>>>
> >>>> Then, for nested case, L0 needs to enable it transparently for L2 if
> >>>> this feature is enabled for L1 guest (the reason as we all agreed that
> >>>> cannot allow L1 to escape just by creating a L2). Then what should KVM
> >>>> do when notify vm exit from L2?
> >>>>
> >>>>     - Exit to L0 userspace on L2's notify vm exit. L0 userspace takes the
> >>>> same action:
> >>>>           - re-enter if context-invalid is false;
> >>>>           - kill L1 if context-invalid is true; (I don't know if there is any
> >>>> interface for L0 userspace to kill L2). Then it opens the potential door
> >>>> for malicious user to kill L1 by creating a L2 to trigger fatal notify
> >>>> vm exit. If you guys accept it, we can implement in this way.
> >>>>
> >>>>
> >>>> in conclusion, we have below solution:
> >>>>
> >>>> 1. Take this patch as is. The drawback is L1 VMM receives a triple_fault
> >>>> from L2 when L2 triggers notify vm exit with invalid context. Neither of
> >>>> L1 VMM, L1 userspace, nor L2 kernel know it's caused due to notify vm
> >>>> exit. There is only kernel log in L0, which seems not accessible for L1
> >>>> user or L2 guest.
> >>>
> >>> You are correct on that last point, and I feel that I cannot stress it
> >>> enough. In a typical environment, the L0 kernel log is only available
> >>> to the administrator of the L0 host.
> >>>
> >>>> 2. a) Inject notify vm exit back to L1 if L2 triggers notify vm exit
> >>>> with invalid context. The drawback is, old L1 hypervisor is not
> >>>> enlightened of it and maybe misbehave on it.
> >>>>
> >>>>       b) Inject a synthesized SHUTDOWN exit to L1, with additional info to
> >>>> tell it's caused by fatal notify vm exit from L2. It has the same
> >>>> drawback that old hypervisor has no idea of it and maybe misbehave on it.
> >>>>
> >>>> 3. Exit to L0 usersapce unconditionally no matter it's caused from L1 or
> >>>> L2. Then it may open the door for L1 user to kill L1.
> >>>>
> >>>> Do you have any better solution other than above? If no, we need to pick> >> one from above though it cannot make everyone happy.
> >>>
> >>> Yes, I believe I have a better solution. We obviously need an API for
> >>> userspace to synthesize a SHUTDOWN event for a vCPU.
> >>
> >> Can you elaborate on it? Do you mean userspace to inject a synthesized
> >> SHUTDOWN to guest? If so, I have no idea how it will work.
> >
> > It can probably be implemented as an extension of KVM_SET_VCPU_EVENTS
> > that invokes kvm_make_request(KVM_REQ_TRIPLE_FAULT).
>
> Then, you mean
>
> 1. notify vm exit from guest;
> 2. exit to userspace on notify vm exit;
> 3. a. if context_invalid, inject SHUTDOWN to vcpu from userspace to
> request KVM_REQ_TRIPLE_FAULT; goto step 4;
>     b. if !context_invalid, re-run vcpu; no step 4 and 5;
> 4. exit to userspace again with KVM_EXIT_SHUTDOWN due to triple fault;
> 5. userspace stop running the vcpu/VM
>
> Then why not handle it as KVM_EXIT_SHUTDOWN directly in 3.a ? I don't
> get the point of userspace to inject TRIPLE_FAULT to KVM.

Sure, that should work, as long as L0 userspace is notified of the
emulation error.

Going back to something you said previously:

>> In addition, to avoid breaking legacy userspace, the NOTIFY VM-exit should be opt-in.

> Yes, it's designed as opt-in already that the feature is off by default.

I meant that userspace should opt-in, per VM. I believe your design is
opt-in by system administrator, host-wide.
