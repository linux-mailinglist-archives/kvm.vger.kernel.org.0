Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9C4B0C2C
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240754AbiBJLSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:18:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240696AbiBJLSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:18:42 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F657E49;
        Thu, 10 Feb 2022 03:18:43 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F169436B; Thu, 10 Feb 2022 12:18:40 +0100 (CET)
Date:   Thu, 10 Feb 2022 12:18:36 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     linux-coco@lists.linux.dev
Cc:     Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Jun Nakajima <jun.nakajima@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Marc Orr <marcorr@google.com>, Mike Rapoport <rppt@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Gonda <pgonda@google.com>,
        Sathya Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Confidential Computing microconference 2022 planning kick-off
Message-ID: <YgT0jKIMYWqkuOj6@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

the organizers of the Linux Plumbers Conference 2022 have recently
opened the CfP for microconferences and I thought it would be great to
have another Confidential Computing microconference to bring everyone
together and discuss open problems.

I drafted a proposal for review, feel free to make improvements and/or
add more topics. Please also forward this email to other people who
might be interested, but which I missed here.

If anyone is interested in co-organizing this microconference, please
contact me. I am open to any helping hand :)

I plan to submit the proposal to the LPC website end of next week to get
things going. 

Thanks,

	Joerg

Here is the current proposal text:

Confidential Computing Microconference
======================================

Last years inaugural Confidential Computing microconference brought
together plumbers enabling secure execution features in hypervisors,
firmware, Linux Kernel, over low-level user space up to container
runtimes.

Good progress was made on a couple of topics, most outstanding here is
the development of Linux guest support for Intel TDX[1] and AMD
SEV-SNP[2].  The patch-sets for both are under intensive review and come
close to be merged upstream.

The discussions in the microconference also helped to move other topics
forward, such as support for un-accepted memory[3] or deferred memory
pinning[4] for confidential guests.

But enabling Confidential Computing in the Linux ecosystem is an ongoing
process, and there are still many problems to solve. The most important
ones are:

	* Design and implementation of Intel TDX and AMD SEV-SNP host
	  support
	* Linux kernel memory management changes for secure execution
	  environments
	* Support of upcoming secure execution hardware extensions
	  from ARM and RISC-V
	* Pre-launch and runtime attestation workflows
	* Interrupt security for AMD SEV-SNP
	* Debuggability and live migration of encrypted virtual machines
	* Proper testing of confidential computing support code

The Confidential Computing Microconference wants to bring together
plumbers working on secure execution features to discuss these and other
open problems.

[1] https://lore.kernel.org/all/20220124150215.36893-1-kirill.shutemov@linux.intel.com/
[2] https://lore.kernel.org/all/20220209181039.1262882-1-brijesh.singh@amd.com/
[3] https://lore.kernel.org/all/20220128205906.27503-1-kirill.shutemov@linux.intel.com/
[4] https://lore.kernel.org/all/20220118110621.62462-1-nikunj@amd.com/

Key Attendees:

	* Andi Kleen <ak@linux.intel.com>
	* Andy Lutomirski <luto@kernel.org>
	* Borislav Petkov <bp@alien8.de>
	* Brijesh Singh <brijesh.singh@amd.com>
	* Dr. David Alan Gilbert <dgilbert@redhat.com>
	* Dave Hansen <dave.hansen@linux.intel.com>
	* David Hildenbrand <david@redhat.com>
	* David Kaplan <David.Kaplan@amd.com>
	* David Rientjes <rientjes@google.com>
	* Joerg Roedel <jroedel@suse.de>
	* Jun Nakajima <jun.nakajima@intel.com>
	* Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
	* Marc Orr <marcorr@google.com>
	* Mike Rapoport <rppt@kernel.org>
	* Paolo Bonzini <pbonzini@redhat.com>
	* Peter Gonda <pgonda@google.com>
	* Sathya Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
	* Sean Christopherson <seanjc@google.com>
	* Tom Lendacky <thomas.lendacky@amd.com>

