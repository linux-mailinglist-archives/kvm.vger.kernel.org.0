Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E657CFAC9
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345754AbjJSNV3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 19 Oct 2023 09:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjJSNV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 09:21:28 -0400
X-Greylist: delayed 539 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Oct 2023 06:21:25 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F9106;
        Thu, 19 Oct 2023 06:21:25 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 805E34306B;
        Thu, 19 Oct 2023 15:12:24 +0200 (CEST)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 19 Oct 2023 15:12:23 +0200
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] KVM: nSVM: TLB_CONTROL / FLUSHBYASID "fixes"
From:   "Stefan Sterz" <s.sterz@proxmox.com>
To:     "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Message-Id: <CWCFRS30GBXB.2KV4ZAWTFNZTO@erna>
X-Mailer: aerc 0.14.0
References: <20231018194104.1896415-1-seanjc@google.com>
In-Reply-To: <20231018194104.1896415-1-seanjc@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed Oct 18, 2023 at 9:41 PM CEST, Sean Christopherson wrote:
> Two "fixes" to play nice with running VMware Workstation on top of KVM,
> in quotes because patch 2 isn't really a fix.
>

Hey, thanks for providing these patches. Tested them here with ESXi 7,
they work like a charm!

As a sidenote regarding my tests: had to fiddle a bit with the reverted
commit as I applied them on top of the v6.2 tag, because that is still
the kernel version we use over here.

> Sean Christopherson (2):
>   Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested
>     VMCB"
>   KVM: nSVM: Advertise support for flush-by-ASID
>
>  arch/x86/kvm/svm/nested.c | 15 ---------------
>  arch/x86/kvm/svm/svm.c    |  1 +
>  2 files changed, 1 insertion(+), 15 deletions(-)
>
>
> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
> --
> 2.42.0.655.g421f12c284-goog


