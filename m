Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3317A3AE20
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 06:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfFJEaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 00:30:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43104 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfFJEaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 00:30:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id r18so7650191wrm.10;
        Sun, 09 Jun 2019 21:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLFOgijD3HB5KmUWDkH6ccOdMN9woZkm1YckFf6JZf8=;
        b=ODCi1JRVlqrYBi5jNYcAKSUcbNyNKyAIWOpDjDnChCYwRu+wGE/aYaoVblLTbh7VrC
         f+SzptJvFPxx0YfXORTrB5unvfbK0isk+8fYSb4S3gnNzMwq/KvWKNDC73/ZC9m+XhRh
         S2tuHAdmanNRR6ackEWM6MmPo4ELV0Lc3VIPnaE3oKGsBTp0FgrRh8QNhfaO0nrBdHGj
         0M4ZZab9lkP/ehDzF8ONIF57NbS6WAxRKfHMZdT0PQGpKX7RyWE39zFYdIRQ6m3ErSCU
         S6u8d1p37+FlJw7XG6HQWzQrOltVPOSQ6eoT614lSvW8lye5Za02KPNNRCefU6IFEaSl
         bhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLFOgijD3HB5KmUWDkH6ccOdMN9woZkm1YckFf6JZf8=;
        b=h/3dr6El+Ok8T0ObHWBLBPiEBuerYOi64JSuM8ipjmMFQiXe4C0yzKiL5BNs78wSZ+
         NZN3bCSpyDNGim5w4HlylMFTwDjUjgANb1DZRrDc+eVtC6W+kR+nalhZOV9KxYLtMGvc
         IGncU7krvTzgCbrOgaVbED74ZPGUJd8Hj/+z3LxkAOQ6eKNwwI0ZyIYA8SVWcb1WZMSu
         GgWlmmtkWmW1ojSC/SszlD9Ep07caHCpZnQc0o7BmCoFgkCJA/K/WJHsvM/b3LaWUeGb
         101x2KUlRV0NE7x0KAAJDu4HPy+egOXp7p+eqfoALXDy92RukbkpUoixO3trD4slEeJK
         cn+Q==
X-Gm-Message-State: APjAAAW837ZPr+ugH3ZUgyKapxMPxyclorzJ5EczzhM7v/VGy0WtcT5V
        N/nkzZ/pI0Mhq4deImT8fAjKy2REWIEbZxya1fo=
X-Google-Smtp-Source: APXvYqzBsJxznsOOZ+p6iesGZbcVBJ1dJsWR1woYLr1iHtiWQyf51ATklXi3KE9GwV6uFzWtHaLGruDz5WFVfzPirzs=
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr33012135wrt.295.1560141016240;
 Sun, 09 Jun 2019 21:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190606152812.13141-1-weijiang.yang@intel.com>
 <20190606152812.13141-2-weijiang.yang@intel.com> <CAG4AFWZG2xKmnt4etNfrefy7WcX2joaJhMOthQUao_qHfrvi5A@mail.gmail.com>
 <20190607131155.GA17556@local-michael-cet-test>
In-Reply-To: <20190607131155.GA17556@local-michael-cet-test>
From:   Jidong Xiao <jidong.xiao@gmail.com>
Date:   Sun, 9 Jun 2019 22:31:02 -0600
Message-ID: <CAG4AFWb8vy+ekyfVrCBT5XoT7MZ3UjuPfUf0hkc_Ax6gNW8ofg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] Documentation: Introduce EPT based Subpage Protection
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com, yu.c.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 7, 2019 at 7:12 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Thu, Jun 06, 2019 at 09:57:00PM -0600, Jidong Xiao wrote:
> > Hi, Weijiang,
> >
> > Does this require some specific Intel processors or is it supported by
> > older processors as well?
> >
> > -Jidong
> Hi, Jidong,
> SPP is a feature on new platforms, so only available with new
> Intel processors.
Oh, I see. Thanks!

-Jidong

> >
> > On Thu, Jun 6, 2019 at 9:33 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >  Documentation/virtual/kvm/spp_kvm.txt | 216 ++++++++++++++++++++++++++
> > >  1 file changed, 216 insertions(+)
> > >  create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
> > >
> > > diff --git a/Documentation/virtual/kvm/spp_kvm.txt b/Documentation/virtual/kvm/spp_kvm.txt
> > > new file mode 100644
> > > index 000000000000..4b5edcaf48b6
> > > --- /dev/null
> > > +++ b/Documentation/virtual/kvm/spp_kvm.txt
> > > @@ -0,0 +1,216 @@
> > > +EPT-Based Sub-Page Protection (SPP) for KVM
> > > +=============================================
> > > +
> > > +1. Overview
> > > +
> > > +EPT-based Sub-Page Protection (SPP) capability to allow Virtual Machine
> > > +Monitors to specify write-protection for guest physical memory at a
> > > +sub-page (128 byte) granularity. When this capability is utilized, the
> > > +CPU enforces write-access permissions for sub-page regions inside 4K pages
> > > +as specified by the VMI tools.
> > > +
> > > +2. Operation of SPP
> > > +
> > > +Sub-Page Protection Table (SPPT) is introduced to manage sub-page
> > > +write-access.
> > > +
> > > +SPPT is active when:
> > > +a) moddule parameter spp=on is configured for kvm-intel.ko
> > > +b) large paging is disabled on host
> > > +c) "sub-page write protection" VM-execution control bit is set
> > > +SPPT looks up the guest physical address to seek a 64-bit
> > > +bitmap indicating sub-page write permission in SPPT leaf entry.
> > > +
> > > +When the "sub-page write protection" VM-execution control is 1, the SPPT
> > > +is used to lookup write permission bits for the 128 byte sub-page regions
> > > +contained in the 4KB guest physical page. EPT specifies the 4KB page
> > > +write-protection privilege whereas SPPT defines the write permissions
> > > +at 128-byte granularity within one 4KB page. Write accesses
> > > +prevented due to sub-page permissions induces EPT violation VM exits.
> > > +Similar to EPT, a logical processor uses SPPT to lookup sub-page level
> > > +write permissions for guest-physical addresses only when those addresses
> > > +are used to access memory.
> > > +__________________________________________________________________________
> > > +
> > > +How SPP hardware works:
> > > +__________________________________________________________________________
> > > +
> > > +Guest write access --> GPA --> Walk EPT --> EPT leaf entry -----|
> > > +|---------------------------------------------------------------|
> > > +|-> if VMexec_control.spp && ept_leaf_entry.spp_bit (bit 61)
> > > +     |
> > > +     |-> <false> --> EPT legacy behavior
> > > +     |
> > > +     |
> > > +     |-> <true>  --> if ept_leaf_entry.writable
> > > +                      |
> > > +                      |-> <true>  --> Ignore SPP
> > > +                      |
> > > +                      |-> <false> --> GPA --> Walk SPP 4-level table--|
> > > +                                                                      |
> > > +|------------<----------get-the-SPPT-point-from-VMCS-filed-----<------|
> > > +|
> > > +Walk SPP L4E table
> > > +|
> > > +|---> if-entry-misconfiguration ------------>-------|-------<---------|
> > > + |                                                  |                 |
> > > +else                                                |                 |
> > > + |                                                  |                 |
> > > + |   |------------------SPP VMexit<-----------------|                 |
> > > + |   |                                                                |
> > > + |   |-> exit_qualification & sppt_misconfig --> sppt misconfig       |
> > > + |   |                                                                |
> > > + |   |-> exit_qualification & sppt_miss --> sppt miss                 |
> > > + |---|                                                                |
> > > +     |                                                                |
> > > +walk SPPT L3E--|--> if-entry-misconfiguration------------>------------|
> > > +               |                                                      |
> > > +              else                                                    |
> > > +               |                                                      |
> > > +               |                                                      |
> > > +        walk SPPT L2E --|--> if-entry-misconfiguration-------->-------|
> > > +                        |                                             |
> > > +                       else                                           |
> > > +                        |                                             |
> > > +                        |                                             |
> > > +                 walk SPPT L1E --|-> if-entry-misconfiguration--->----|
> > > +                                 |
> > > +                               else
> > > +                                 |
> > > +                                 |-> if sub-page writable
> > > +                                 |-> <true>  allow, write access
> > > +                                 |-> <false> disallow, EPT violation
> > > +______________________________________________________________________________
> > > +
> > > +3. Interfaces
> > > +
> > > +* Feature enabling
> > > +
> > > +Add "spp=on" to KVM module parameter to enable SPP feature, default is off.
> > > +
> > > +* Get/Set sub-page write access permission
> > > +
> > > +New KVM ioctl:
> > > +
> > > +KVM_SUBPAGES_GET_ACCESS:
> > > +Get sub-pages write access bitmap corresponding to given rang of continuous gfn.
> > > +
> > > +KVM_SUBPAGES_SET_ACCESS
> > > +Set sub-pages write access bitmap corresponding to given rang of continuous gfn.
> > > +
> > > +
> > > +/* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
> > > +struct kvm_subpage_info {
> > > +    __u64 gfn;
> > > +    __u64 npages; /* number of 4K pages */
> > > +    __u64 *access_map; /* sub-page write-access bitmap array */
> > > +};
> > > +
> > > +#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, struct kvm_subpage_info)
> > > +#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, struct kvm_subpage_info)
> > > +
> > > +
> > > +4. SPPT initialization
> > > +
> > > +* SPPT root page allocation
> > > +
> > > +  SPPT is referenced via a 64-bit control field called "sub-page
> > > +  protection table pointer" (SPPTP, encoding 0x2030) which contains a
> > > +  4K-align physical address.
> > > +
> > > +  SPPT is a 4-level paging structure similar as EPT. When KVM
> > > +  loads mmu, it allocates a root page for SPPT L4 table as well.
> > > +
> > > +* EPT leaf entry SPP bit (bit 61)
> > > +
> > > +  Set 0 to SPP bit to close SPP.
> > > +
> > > +5. Set/Get Sub-Page access bitmap for a bunch of guest physical pages
> > > +
> > > +* To utilize SPP feature, system admin should set sub-page access via
> > > +  SPP KVM ioctl `KVM_SUBPAGES_SET_ACCESS`, configuring EPT and SPPT in below flow:
> > > +
> > > +  (1) If the target 4KB pages to be protected are there, it locates EPT leaf entries
> > > +      via the guest physical addresses, flags the bit 61 of the corresponding entries to
> > > +      enable sub-page protection for the pages, then setup SPPT paging structure.
> > > +  (2) otherwise, stores the [gfn,permission] mappings in KVM data structure. When
> > > +      EPT page-fault is generated due to target protected page accessing, it settles
> > > +      EPT entry configureation together with SPPT build-up.
> > > +
> > > +   The SPPT paging structure format is as below:
> > > +
> > > +   Format of the SPPT L4E, L3E, L2E:
> > > +   | Bit    | Contents                                                                 |
> > > +   | :----- | :------------------------------------------------------------------------|
> > > +   | 0      | Valid entry when set; indicates whether the entry is present             |
> > > +   | 11:1   | Reserved (0)                                                             |
> > > +   | N-1:12 | Physical address of 4KB aligned SPPT LX-1 Table referenced by this entry |
> > > +   | 51:N   | Reserved (0)                                                             |
> > > +   | 63:52  | Reserved (0)                                                             |
> > > +   Note: N is the physical address width supported by the processor. X is the page level
> > > +
> > > +   Format of the SPPT L1E:
> > > +   | Bit   | Contents                                                          |
> > > +   | :---- | :---------------------------------------------------------------- |
> > > +   | 0+2i  | Write permission for i-th 128 byte sub-page region.               |
> > > +   | 1+2i  | Reserved (0).                                                     |
> > > +   Note: 0<=i<=31
> > > +
> > > +6. SPPT-induced vmexits
> > > +
> > > +* SPP VM exits
> > > +
> > > +Accesses using guest physical addresses may cause VM exits due to a SPPT
> > > +misconfiguration or a SPPT missing.
> > > +
> > > +A SPPT misconfiguration vmexit occurs when, in the course of translating
> > > +a guest physical address, the logical processor encounters a leaf EPT
> > > +paging-structure entry mapping a 4KB page, with SPP enabled, during the
> > > +SPPT lookup, a SPPT paging-structure entry contains an unsupported
> > > +value.
> > > +
> > > +A SPPT missing vmexit occurs during the SPPT lookup there is no SPPT
> > > +misconfiguration but any level of SPPT paging-structure entries are not
> > > +present.
> > > +
> > > +NOTE. SPPT misconfigurations and SPPT miss can occur only due to an
> > > +attempt to write memory with a guest physical address.
> > > +
> > > +* EPT violation vmexits due to SPPT
> > > +
> > > +EPT violations generated due to SPP sub-page
> > > +permission are reported as EPT violation vmexits.
> > > +
> > > +7. SPPT-induced vmexits handling
> > > +
> > > +
> > > +#define EXIT_REASON_SPP                 66
> > > +
> > > +static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> > > +    ...
> > > +    [EXIT_REASON_SPP]                     = handle_spp,
> > > +    ...
> > > +};
> > > +
> > > +
> > > +New exit qualification for SPPT-induced vmexits.
> > > +
> > > +| Bit   | Contents                                                          |
> > > +| :---- | :---------------------------------------------------------------- |
> > > +| 10:0  | Reserved (0).                                                     |
> > > +| 11    | SPPT VM exit type. Set for SPPT Miss, cleared for SPPT Misconfig. |
> > > +| 12    | NMI unblocking due to IRET                                        |
> > > +| 63:13 | Reserved (0)                                                      |
> > > +
> > > +In addition to the exit qualification, Guest Linear Address and Guest
> > > +Physical Address fields will be reported.
> > > +
> > > +* SPPT miss and misconfiguration
> > > +
> > > +Allocate a page for the SPPT entry and set the entry correctly.
> > > +
> > > +* EPT violation vmexits due to SPPT
> > > +
> > > +While hardware traverses SPPT, If the sub-page region write
> > > +permission bit is set, the write is allowed, otherwise it's prevented
> > > +and an EPT violation is generated.
> > > --
> > > 2.17.2
> > >
