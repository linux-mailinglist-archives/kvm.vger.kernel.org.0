Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC0A52EFAC
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbiETPsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiETPsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:48:23 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476F15C85D;
        Fri, 20 May 2022 08:48:20 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C8AF3246; Fri, 20 May 2022 17:48:18 +0200 (CEST)
Date:   Fri, 20 May 2022 17:48:17 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-sgx@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
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
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [CFP LPC 2022] Confidential Computing Microconference
Message-ID: <Yoe4QZr8dqy1hrU1@8bytes.org>
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

as already announced by the planning committee, there will be another

	Confidential Computing Microconference

at this years Linux Plumbers Conference (LPC) happening from 12th to
14th of September in Dublin, Ireland.

In this microconference we want to discuss ongoing developments around
Linux support for memory encryption and support for Confidential
Computing in general.

Suggested topics are:

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

	* Support for Confidential Containers

	* Or anything else related to Confidential Computing in Linux

Please submit your proposals on the LPC website at:

	https://lpc.events/event/16/abstracts/

Make sure to select "Confidential Computing MC" in the Track pulldown
menu.

Looking forwart to seeing you all there, either in Dublin or virtual :)

Thanks,

	Joerg
