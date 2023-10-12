Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7E67C712A
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347190AbjJLPPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347140AbjJLPP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:15:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35810D8;
        Thu, 12 Oct 2023 08:15:26 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5tVD6ylDz6K6j4;
        Thu, 12 Oct 2023 23:15:00 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 12 Oct
 2023 16:15:22 +0100
Date:   Thu, 12 Oct 2023 16:15:22 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231012161522.000050ce@Huawei.com>
In-Reply-To: <95d87143-43a1-4140-af08-b4e9ea09b32a@amd.com>
References: <cover.1695921656.git.lukas@wunner.de>
        <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
        <20231007100433.GA7596@wunner.de>
        <20231009123335.00006d3d@Huawei.com>
        <20231009134950.GA7097@wunner.de>
        <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
        <20231010081913.GA24050@wunner.de>
        <2a21b730-9ad4-4585-b636-9aa139266f94@amd.com>
        <20231011175746.00003d57@Huawei.com>
        <95d87143-43a1-4140-af08-b4e9ea09b32a@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Oct 2023 14:00:00 +1100
Alexey Kardashevskiy <aik@amd.com> wrote:

> On 12/10/23 03:57, Jonathan Cameron wrote:
> > On Tue, 10 Oct 2023 23:53:16 +1100
> > Alexey Kardashevskiy <aik@amd.com> wrote:
> >   
> >> On 10/10/23 19:19, Lukas Wunner wrote:  
> >>> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:  
> >>>> On 10/10/23 00:49, Lukas Wunner wrote:  
> >>>>> PCI Firmware Spec would seem to be appropriate.  However this can't
> >>>>> be solved by the kernel community.  
> >>>>
> >>>> How so? It is up to the user to decide whether it is SPDM/CMA in the kernel
> >>>> or   the firmware + coco, both are quite possible (it is IDE which is not
> >>>> possible without the firmware on AMD but we are not there yet).  
> >>>
> >>> The user can control ownership of CMA-SPDM e.g. through a BIOS knob.
> >>> And that BIOS knob then influences the outcome of the _OSC negotiation
> >>> between platform and OS.
> >>>
> >>>      
> >>>> But the way SPDM is done now is that if the user (as myself) wants to let
> >>>> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> >>>> as CMA is not a (un)loadable module or built-in (with some "blacklist"
> >>>> parameters), and does not provide a sysfs knob to control its tentacles.  
> >>>
> >>> The problem is every single vendor thinks they can come up with
> >>> their own idea of who owns the SPDM session:
> >>>
> >>> I've looked at the Nvidia driver and they've hacked libspdm into it,
> >>> so their idea is that the device driver owns the SPDM session.
> >>   >
> >>> AMD wants the host to proxy DOE but not own the SPDM session.
> >>   >
> >>> We have *standards* for a reason.  So that products are interoperable.  
> >>
> >> There is no "standard PCI ethernet device", somehow we survive ;)
> >>  
> >>> If the kernel tries to accommodate to every vendor's idea of SPDM ownership
> >>> we'll end up with an unmaintainable mess of quirks, plus sysfs knobs
> >>> which were once intended as a stopgap but can never be removed because
> >>> they're userspace ABI.  
> >>
> >> The host kernel needs to accommodate the idea that it is not trusted,
> >> and neither is the BIOS.
> >>  
> >>> This needs to be solved in the *specification*.
> >>   >
> >>> And the existing solution for who owns a particular PCI feature is _OSC.
> >>> Hence this needs to be taken up with the Firmware Working Group at the
> >>> PCISIG.  
> >>
> >> I do like the general idea of specifying things, etc but this place does
> >> not sound right. The firmware you are talking about has full access to
> >> PCI, the PSP firmware does not have any (besides the IDE keys
> >> programming), is there any example of such firmware in the PCI Firmware
> >> spec? From the BIOS standpoint, the host OS owns DOE and whatever is
> >> sent over it (on AMD SEV TIO). The host OS chooses not to compose these
> >> SPDM packets itself (while it could) in order to be able to run guests
> >> without having them to trust the host OS.  
> > 
> > As a minimum I'd like to see something saying - "keep away from discovery
> > protocol on this DOE instance".  An ACPI _OSC or _DSM or similar could do that.
> > It won't be needed for every approach, but it might for some.  
> 
> I am relying on the existing DOE code to do the discovery. No APCI in 
> the SEV TIO picture.
> 
> > Then either firmwware knows what to do, or a specific driver does.
> > 
> > If your proxy comes up late enough that we've already done (and cached) discovery
> > protocols results then this might not be a problem for this particular
> > approach as we have no reason to rerun discovery (other than hotplug in which
> > case there is lots of other stuff to do anyway).
> > 
> > For your case we need some hooks for the PSP to be able to drive the SPDM session
> > but that should be easy to allow.   
> 
> This is just a couple of calls:
> doe_md = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG, 
> PCI_DOE_PROTOCOL_SECURED_CMA_SPDM);
> and
> pci_doe(doe_mb, PCI_VENDOR_ID_PCI_SIG, 
> PCI_DOE_PROTOCOL_SECURED_CMA_SPDM, ...)
> 
> 
> > I don't think precludes the hypervisor also
> > verifying the hardware is trusted by it along the way (though not used for IDE).
> > So if you are relying on a host OS proxy I don't thing you need to disable CONFIG_CMA
> > (maybe something around resets?)  
> 
> If I do the above 2 calls, then pdev->spdm_state will be out of sync.

Understood - might need a hand-off function call.  Or put something
in the pci_find_doe_mailbox() - though currently we don't have a way to release
it again.

Or alternatively we might not care that it's out of sync. The host core code
doesn't need to know if you separately created an SPDM session.
Might just be a comment saying that variable is only indicating the state
of the host kernel managed spdm session - there might be others.

> 
> > Potentially the host OS tries first (maybe succeeds - that doesn't matter though
> > nothing wrong with defense in depth) and then the PSP via a proxy does it all over
> > again which is fine.  All we need to do is guarantee ordering and I think we are
> > fine for that.  
> 
> Only trusted bits go all over again, untrusted stuff such as discovery 
> is still done by the host OS and PSP is not rerunning it.
> 
> 
> > Far too many possible models here but such is life I guess.  
> 
> True. When I joined the x86 world (quite recently), I was surprised how 
> different AMD and Intel are in everything besides the userspace :)

:)

> 
> 
> >>>> Note, this PSP firmware is not BIOS (which runs on the same core and has
> >>>> same access to PCI as the host OS), it is a separate platform processor
> >>>> which only programs IDE keys to the PCI RC (via some some internal bus
> >>>> mechanism) but does not do anything on the bus itself and relies on the host
> >>>> OS proxying DOE, and there is no APCI between the core and the psp.  
> >>>
> >>> Somewhat tangentially, would it be possible in your architecture
> >>> that the host or guest asks PSP to program IDE keys into the Root Port?  
> >>
> >> Sure it is possible to implement. But this does not help our primary use
> >> case which is confidential VMs where the host OS is not trusted with the
> >> keys.
> >>  
> >>> Or alternatively, access the key registers directly without PSP involvement?  
> >>
> >> No afaik, for the reason above.  
> 
> 

