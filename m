Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABCF39A3AF
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFCOxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 10:53:24 -0400
Received: from 8bytes.org ([81.169.241.247]:42090 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhFCOxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 10:53:24 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1FDDA48E; Thu,  3 Jun 2021 16:51:38 +0200 (CEST)
Date:   Thu, 3 Jun 2021 16:51:35 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Jun Nakajima <jun.nakajima@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sathya Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [CFP LPC 2021] Confidential Computing Microconference
Message-ID: <YLjsd7zskBPaN9C6@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am pleased to announce that the

	Confidential Computing Microconference[1]
	
has been accepted at this years Linux Plumbers Conference.

In this microconference we will discuss how Linux can support encryption
technologies which protect data during processing on the CPU. Examples
are AMD SEV, Intel TDX, IBM Secure Execution for s390x and ARM Secure
Virtualization.

Suggested Topics are:

	- Live Migration of Confidential VMs
	- Lazy Memory Validation
	- APIC emulation/interrupt management
	- Debug Support for Confidential VMs
	- Required Memory Management changes for memory validation
	- Safe Kernel entry for TDX and SEV exceptions
	- Requirements for Confidential Containers
	- Trusted Device Drivers Framework and driver fuzzing
	- Remote Attestation

Please submit your proposals on the LPC website at:

	https://www.linuxplumbersconf.org/event/11/abstracts/#submit-abstract

Make sure to select "Confidential Computing MC" in the Track pulldown
menu.

Looking forward to seeing you all there! :)

Thanks,

	Joerg Roedel
	
[1] https://www.linuxplumbersconf.org/blog/2021/index.php/2021/05/14/confidential-computing-microconference-accepted-into-2021-linux-plumbers-conference/
